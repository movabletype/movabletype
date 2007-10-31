# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Util::Captcha;

use strict;
use warnings;
use base qw( MT::ErrorHandler );

use constant READABLECHARS => '23456789abcdefghjkmnzpqrstuvwxyz';
use constant WIDTH  => 25;
use constant HEIGHT => 35;
use constant LENGTH => 6;
use constant EXPIRE => 60 * 10;

use MT::Session;

sub check_availability {
    my $class = shift;

    eval "require Image::Magick;";
    if ($@) {
        return MT->translate('Movable Type default CAPTCHA provider requires Image::Magick.');
    }

    my $cfg = MT->config;
    my $base = $cfg->CaptchaSourceImageBase;
    unless ($base) {
        require File::Spec;
        $base = File::Spec->catfile(MT->instance->config_dir, 'mt-static', 'images', 'captcha-source');
        $base = undef unless (-d $base);
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

    my $cfg = MT->config;
    my $cgipath = $cfg->CGIPath;
    my $commentscript = $cfg->CommentScript;

    my $caption = MT->translate('Captcha');
    my $description = MT->translate('Type the characters you see in the picture above.');
    return <<FORM_FIELDS;
<div class="label"><label for="captcha_code">$caption:</label></div>
<div class="field">
<input type="hidden" name="token" value="$token" />
<img src="$cgipath$commentscript/captcha/$blog_id/$token" width="150" height="35" /><br />
<input name="captcha_code" id="captcha-code" value="" />
<p>$description</p>
</div>
FORM_FIELDS
}

sub generate_captcha {
    my $self = shift;
    my ($app, $blog_id, $token) = @_;

    my $code = $self->_generate_code(LENGTH());

    my $sess = MT::Session->new;
    $sess->id($code);
    $sess->kind('CA'); #CA == CaptchA
    $sess->start(time);
    $sess->name($token);
    $sess->save or
        $app->error($sess->errstr), return undef;
    
    my $image_data = $self->_generate_captcha($app, $code, 'png') or
        return undef; 

    return $image_data; 
}

sub validate_captcha {
    my $self = shift;
    my ($app) = @_;

    my $token = $app->param('token');
    my $code = $app->param('captcha_code');

    my $from = time - EXPIRE();
    MT::Session->remove({ kind => 'CA', start => [undef, $from] }, { range => { start => 1 }});

    my $sess = MT::Session->load({ id => $code, name => $token, kind => 'CA' });
    return 0 unless $sess;
    if ($sess->start() < (time - EXPIRE())) {
        $sess->remove;
        return 0;
    }
    $sess->remove;
    return 1;
}

sub _generate_code {
    my $self = shift;
    my($len) = @_;

    my $code = '';

    require Crypt::DH;
    my $genval = unpack('H*', Crypt::DH::_makerandom($len*8/2));

    # Cycle throught the octets pulling off the lower 5 bits then mapped into
    # our acceptable characters
    foreach my $i (0..($len-1)) {
      my $byte = ord(pack('H2', substr($genval, $i*2, 2)));
      my $x = ($byte & 31);

      $code .= substr(READABLECHARS(), $byte & 31, 1);
    }

    return $code;
}

sub _generate_captcha {
    my $self = shift;
    my ($app, $code, $format) = @_;
    $format ||= 'png';
    my $len = LENGTH();

    my $cfg = $app->config;
    my $base = $cfg->CaptchaSourceImageBase;
    unless ($base) {
        require File::Spec;
        $base = File::Spec->catfile(MT->instance->config_dir, 'mt-static', 'images', 'captcha-source');
        $base = undef unless (-d $base);
    }
    return $app->error($app->translate('You need to configure CaptchaSourceImageBase.'))
        unless $base;

    require Image::Magick;
    my $imbase = Image::Magick->new(magick=>'png')
        or return $app->error($app->translate("Image creation failed."));

    # Read the predefined letter PNG for each letter in $code
    my $x = $imbase->Read(map { File::Spec->catfile($base, $_ . '.png') }
                          split(//, $code));
    if ($x) {
        return $app->error($app->translate("Image error: [_1]", $x));
    }

    # Futz with the size and blurriness of each letter
    foreach my $i (0..($len - 1)) {
        my $a = int rand int(WIDTH() / 14);
        my $b = int rand int(HEIGHT() / 12);

        $imbase->[$i]->Resize(width => $a, height => $b, blur => rand(3));
    }

    # Combine all the individual tiles into one block
    my $tile_geom    = join('x', $len, 1);
    my $geometry_str = join('x', WIDTH(), HEIGHT());
    my $im = $imbase->Montage(geometry => $geometry_str,
                              tile     => $tile_geom);
    $im->Blur();

    # Add some lines and dots to the image
    for my $i (0..($len * WIDTH() * HEIGHT() / 14+200-1)) {
        my $a = int rand($len * WIDTH());
        my $b = int rand HEIGHT();
        my $c = int rand($len * WIDTH());
        my $d = int rand HEIGHT();
        my $index = $im->Get("pixel[$a, $b]");


        if ($i < ($len * WIDTH() * HEIGHT() / 14+200) / 100) {
	    $im->Draw(primitive => 'line',
                      stroke    => $index,
                      points    => "$a, $b, $c, $d");
        } elsif ($i < ($len * WIDTH() * HEIGHT() / 14+200) / 2) {
            $im->Set("pixel[$c, $d]" => $index);
        } else {
            $im->Set("pixel[$c, $d]" => "black");
        }
    }

    # Read in the background file
    my $a = int rand(5) + 1;
    my $background = Image::Magick->new();
    $background->Read(File::Spec->catfile($base, 'background' . $a . '.png'));
    $background->Resize(width => ($len * WIDTH()), height => HEIGHT());
    $im->Composite(compose => "Bumpmap",
                   tile    => 'False',
                   image   => $background);
    $im->Modulate(brightness => 105);
    $im->Border(fill     => 'black',
                width    => 1,
                height   => 1,
                geometry => join('x', WIDTH() * $len, HEIGHT()));

    my @blobs = $im->ImageToBlob(magick=>$format);
    return $blobs[0];
}

1;
