# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Util::Captcha;

use strict;
use warnings;
use base qw( MT::ErrorHandler );

sub READABLECHARS {'23456789abcdefghjkmnzpqrstuvwxyz'}
sub WIDTH         {25}
sub HEIGHT        {35}
sub LENGTH        {6}
sub EXPIRE        { 60 * 10 }

use MT::Session;

$ENV{MAGICK_THREAD_LIMIT} ||= 1;
our $MagickClass;

sub magick_class {
    my $class = shift;
    return $MagickClass if defined $MagickClass;
    if (MT->config->ImageDriver =~ /Magick$/) {
        $MagickClass = MT->config->ImageDriver;
        $MagickClass =~ s/Magick/::Magick/;
        if (eval "require $MagickClass") {
            return $MagickClass;
        }
    }
    if (eval {require Graphics::Magick}) {
        return $MagickClass = "Graphics::Magick";
    }
    if (eval {require Image::Magick}) {
        return $MagickClass = "Image::Magick";
    }
    $MagickClass = "";
}

sub check_availability {
    my $class = shift;

    if (!$class->magick_class) {
        return MT->translate(
            'Movable Type default CAPTCHA provider requires Image::Magick.');
    }

    my $cfg  = MT->config;
    my $base = $cfg->CaptchaSourceImageBase;
    unless ($base) {
        require File::Spec;
        $base = File::Spec->catfile(
            MT->instance->config_dir, 'mt-static',
            'images',                 'captcha-source'
        );
        $base = undef unless ( -d $base );
    }
    unless ($base) {
        return MT->translate('You need to configure CaptchaSourceImageBase.');
    }
    undef;
}

sub form_fields {
    my $self = shift;
    my ($blog_id) = @_;

    require MT::App;
    my $token = MT::App->make_magic_token;
    return q() unless $token;

    my $cfg     = MT->config;
    my $cgipath = $cfg->CGIPath;
    $cgipath .= '/' if $cgipath !~ m!/$!;
    my $static = $cfg->StaticWebPath;
    if (!$static) {
        $static = $cgipath;
        $static .= 'mt-static/';
    }
    $static .= '/' if $static !~ m!/$!;
    my $commentscript = $cfg->CommentScript;

    my $caption = MT->translate('Captcha');
    my $description
        = MT->translate('Type the characters you see in the picture above.');
    return <<FORM_FIELDS;
<div class="label"><label for="captcha_code">$caption:</label></div>
<div class="field">
<input type="hidden" name="token" value="$token" />
<img id="captcha_image" src="$cgipath$commentscript/captcha/$blog_id/$token" width="150" height="35" loading="lazy" decoding="async" /><a href="javascript:void(0)" onclick="var i=document.getElementById('captcha_image');i.src=i.src.replace(/((\\\\?c=\\\\d+)|\\\$)/,'?c='+Date.now());return false;"><img src="${static}images/nav_icons/color/rebuild.gif" alt="refresh captcha" style="margin-bottom:10px" loading="lazy" decoding="async"></a><br />
<input type="text" name="captcha_code" id="captcha_code" class="text" value="" autocomplete="off" />
<p>$description</p>
</div>
FORM_FIELDS
}

sub generate_captcha {
    my $self = shift;
    my ( $app, $blog_id, $token ) = @_;

    my $code = $self->_generate_code( LENGTH() );

    my $sess = MT::Session->new;
    $sess->id($code);
    $sess->kind('CA');    #CA == CaptchA
    $sess->start(time);
    $sess->duration( time + EXPIRE() );
    $sess->name($token);
    $sess->save
        or $app->error( $sess->errstr ), return undef;

    my $image_data = $self->_generate_captcha( $app, $code, 'png' )
        or return undef;

    return $image_data;
}

sub validate_captcha {
    my $self = shift;
    my ($app) = @_;

    my $token = $app->param('token');
    my $code  = $app->param('captcha_code');

    my $from = time - EXPIRE();
    MT::Session->remove( { kind => 'CA', start => [ undef, $from ] },
        { range => { start => 1 } } );

    my $sess
        = MT::Session->load( { id => $code, name => $token, kind => 'CA' } );
    return 0 unless $sess;
    if ( $sess->start() < ( time - EXPIRE() ) ) {
        $sess->remove;
        return 0;
    }
    $sess->remove;
    return 1;
}

sub _makerandom {
    my $size = shift;

    my $bytes = int( $size / 8 ) + ( $size % 8 ? 1 : 0 );

    my $rand;
    if ( -e "/dev/urandom" ) {
        my $fh;
        open( $fh, "<", '/dev/urandom' )
            or die "Couldn't open /dev/urandom";
        my $got = sysread $fh, $rand, $bytes;
        die "Didn't read all bytes from urandom" unless $got == $bytes;
        close $fh;
    }
    else {
        for ( 1 .. $bytes ) {
            $rand .= chr( int( rand(256) ) );
        }
    }
    $rand;
}

sub _generate_code {
    my $self = shift;
    my ($len) = @_;

    my $code = '';

    my $genval = unpack( 'H*', _makerandom( $len * 2 * 8 / 2 ) );

    # Cycle through the octets pulling off the lower 5 bits then mapped into
    # our acceptable characters
    foreach my $i ( 0 .. ( $len - 1 ) ) {
        my $byte = ord( pack( 'H2', substr( $genval, $i * 2, 2 ) ) );
        my $x = ( $byte & 31 );

        $code .= substr( READABLECHARS(), $byte & 31, 1 );
    }

    return $code;
}

sub _generate_captcha {
    my $self = shift;
    my ( $app, $code, $format ) = @_;
    $format ||= 'png';
    my $len = LENGTH();

    my $cfg  = $app->config;
    my $base = $cfg->CaptchaSourceImageBase;
    unless ($base) {
        require File::Spec;
        $base = File::Spec->catfile(
            MT->instance->config_dir, 'mt-static',
            'images',                 'captcha-source'
        );
        $base = undef unless ( -d $base );
    }
    return $app->error(
        $app->translate('You need to configure CaptchaSourceImageBase.') )
        unless $base;

    my $magick_class = $self->magick_class or return MT->translate(
            'Movable Type default CAPTCHA provider requires Image::Magick.');
    my $imbase = $magick_class->new( magick => 'png' )
        or return $app->error( $app->translate("Image creation failed.") );

    # Read the predefined letter PNG for each letter in $code
    my $error = $imbase->Read(
        map { File::Spec->catfile( $base, $_ . '.png' ) }
            split( //, $code )
    );
    if ($error) {
        return $app->error( $app->translate( "Image error: [_1]", $error ) );
    }

    # Combine all the individual tiles into one block
    my $tile_geom    = join( 'x', $len,    1 );
    my $geometry_str = join( 'x', WIDTH(), HEIGHT() );
    my $im           = $imbase->Montage(
        geometry => $geometry_str,
        tile     => $tile_geom
    );
    if (!ref $im) {
        return $app->error( $app->translate( "Image error: [_1]", $im ) );
    }

    $error = $im->Blur('0.0x1.0');
    if ($error) {
        return $app->error( $app->translate( "Image error: [_1]", $error ) );
    }

    # Add some lines and dots to the image
    for my $i ( 0 .. 200 ) {
        my $x1    = int rand( $len * WIDTH() );
        my $x2    = int rand( $len * WIDTH() );
        my $y1    = int rand HEIGHT();
        my $y2    = int rand HEIGHT();
        my $index = $im->Get("pixel[$x1, $y1]");

        my $modified_index = join ",", map { $_ >>= 8 while ($_ > 255 || $_ < 0); $_ } split ",", $index;
        my $color_name     = "rgba($modified_index)";

        if ( $i < 2 ) {
            $error = $im->Draw(
                primitive => 'line',
                stroke    => "black",  ## seems to be better than $color_name,
                points    => "$x1, $y1 $x2, $y2"
            );
            if ($error) {
                return $app->error( $app->translate( "Image error: [_1]", $error ) );
            }
        }
        elsif ( $i < 100 ) {
            $error = $im->Set( "pixel[$x2, $y2]" => $color_name );
            if ($error) {
                return $app->error( $app->translate( "Image error: [_1]", $error ) );
            }
        }
        else {
            $error = $im->Set( "pixel[$x2, $y2]" => "black" );
            if ($error) {
                return $app->error( $app->translate( "Image error: [_1]", $error ) );
            }
        }
    }

    # Read in the background file
    my @bg_ids = (1, 2, 4, 5);  ## 3 is a bit too hard to read
    my $bg_id  = $bg_ids[int rand(scalar @bg_ids)];
    my $background = $magick_class->new();
    $error = $background->Read(
        File::Spec->catfile( $base, 'background' . $bg_id . '.png' ) );
    if ($error) {
        return $app->error( $app->translate( "Image error: [_1]", $error ) );
    }
    $error = $background->Resize( width => ( $len * WIDTH() ), height => HEIGHT() );
    if ($error) {
        return $app->error( $app->translate( "Image error: [_1]", $error ) );
    }
    $error = $im->Composite(
        compose => "Bumpmap",
        tile    => 'False',
        image   => $background
    );
    if ($error) {
        return $app->error( $app->translate( "Image error: [_1]", $error ) );
    }
    $error = $im->Modulate( brightness => 105 );
    if ($error) {
        return $app->error( $app->translate( "Image error: [_1]", $error ) );
    }
    $error = $im->Border(
        fill     => 'black',
        width    => 1,
        height   => 1,
        geometry => join( 'x', WIDTH() * $len, HEIGHT() )
    );
    if ($error) {
        return $app->error( $app->translate( "Image error: [_1]", $error ) );
    }

    my @blobs = $im->ImageToBlob( magick => $format );
    return $blobs[0];
}

1;
