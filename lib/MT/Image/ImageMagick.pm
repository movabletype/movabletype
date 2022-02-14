# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: Image.pm 5319 2010-02-22 00:07:51Z auno $

package MT::Image::ImageMagick;
use strict;
use warnings;

use base qw( MT::Image );
use constant MagickClass => 'Image::Magick';

$ENV{MAGICK_THREAD_LIMIT} ||= 1;

sub load_driver {
    my $image = shift;

    my $magick_class = $image->MagickClass;
    eval "require $magick_class";
    if ( my $err = $@ ) {
        return $image->error(
            MT->translate( "Cannot load [_1]: [_2]", $magick_class, $err ) );
    }
    1;
}

sub init {
    my $image = shift;
    my %param = @_;

    $image->SUPER::init(%param);

    $image;
}

sub _magick {
    my $image = shift;
    return $image->{magick} if $image->{magick};

    my $param = $image->{param};
    my %arg = ();
    if ( my $type = $param->{Type} ) {
        %arg = ( magick => lc($type) );
    }
    my $magick = $image->{magick} = $image->MagickClass->new(%arg);
    if ( my $file = $param->{Filename} ) {
        my $x;
        eval { $x = $magick->Read($file); };
        return $image->error(
            MT->translate( "Reading file '[_1]' failed: [_2]", $file, $x ) )
            if $x;
    }
    elsif ( $param->{Data} ) {
        my $x;
        eval { my $x = $magick->BlobToImage( $param->{Data} ); };
        return $image->error(
            MT->translate( "Reading image failed: [_1]", $x ) )
            if $x;
    }
    $magick;
}

sub _init_image_size {
    my $image = shift;
    return ($image->{width}, $image->{height}) if defined $image->{width} && defined $image->{height};
    my $magick = $image->_magick or return;
    ( $image->{width}, $image->{height} ) = $magick->Get( 'width', 'height' );
}

# http://www.imagemagick.org/script/command-line-options.php#quality
# Range of JPEG quality value of ImageMagick is between 1 and 100.
# So, return 1 when the value is 0.
sub jpeg_quality {
    my $image = shift;
    $image->SUPER::jpeg_quality(@_) || 1;
}

# http://www.imagemagick.org/script/command-line-options.php#quality
# Return 10 times value according to the spec.
sub png_quality {
    my $image = shift;
    $image->SUPER::png_quality(@_) * 10;
}

my $HasRefType;
sub _get_first_image {
    my $magick = shift or return;
    if ( !defined $HasRefType ) {
        $HasRefType = eval { require Scalar::Util; 1 } ? 1 : 0;
    }

    # It may cost too much to manipulate large animated GIF image
    # that contains many images inside.
    if ( $HasRefType and Scalar::Util::reftype($magick) eq 'ARRAY' ) {
        return $magick->[0];
    }
    return $magick;
}

sub scale {
    my $image = shift;
    my ( $w, $h ) = $image->get_dimensions(@_);
    my $magick = _get_first_image( $image->_magick ) or return;
    my $blob;
    eval {
        my ( $orig_x, $orig_y ) = $magick->Get( 'width', 'height' );

        my $err
            = $magick->can('Resize')
            ? $magick->Resize( width => $w, height => $h )
            : $magick->Scale( width => $w, height => $h );

        # Case #112908
        # $magick->Resize() does nothing with Strawberry Perl 5.10.1
        # and Image::Magick 6.83.
        if ( !$err && $^O eq 'MSWin32' && $magick->can('Resize') ) {
            my ( $x, $y ) = $magick->Get( 'width', 'height' );
            if (   $orig_x != $w
                && $orig_y != $h
                && $x == $orig_x
                && $y == $orig_y )
            {
                $err = $magick->Scale( width => $w, height => $h );
            }
        }

        return $image->error(
            MT->translate(
                "Scaling to [_1]x[_2] failed: [_3]", $w, $h, $err
            )
        ) if $err;
        $magick->Profile("*") if $magick->can('Profile');
        ( $image->{width}, $image->{height} ) = ( $w, $h );
        $blob = $magick->ImageToBlob;
    };
    return $image->error(
        MT->translate( "Scaling to [_1]x[_2] failed: [_3]", $w, $h, $@ ) )
        if $@;
    wantarray ? ( $blob, $w, $h ) : $blob;
}

sub crop_rectangle {
    my $image = shift;
    my %param = @_;
    my ( $width, $height, $x, $y ) = @param{qw( Width Height X Y )};
    my $magick = _get_first_image( $image->_magick ) or return;
    my $blob;

    eval {
        my $err = $magick->Crop(
            width  => $width,
            height => $height,
            x      => $x,
            y      => $y
        );
        return $image->error(
            MT->translate(
                "Cropping a [_1]x[_2] square at [_3],[_4] failed: [_5]",
                $width, $height, $x, $y, $err
            )
        ) if $err;

        ## Remove page offsets from the original image, per this thread:
        ## http://studio.imagemagick.org/pipermail/magick-users/2003-September/010803.html
        $magick->Set( page => '+0+0' );

        ( $image->{width}, $image->{height} ) = ( $width, $height );
        $blob = $magick->ImageToBlob;
    };
    return $image->error(
        MT->translate(
            "Cropping a [_1]x[_2] square at [_3],[_4] failed: [_5]",
            $width, $height, $x, $y, $@
        )
    ) if $@;

    wantarray ? ( $blob, $width, $height ) : $blob;
}

sub flipHorizontal {
    my $image  = shift;
    my $magick = _get_first_image( $image->_magick ) or return;
    my $blob;

    eval {
        $magick->Flop();
        $blob = $magick->ImageToBlob;
    };
    return $image->error(
        MT->translate( "Flip horizontal failed: [_1]", $@ ) )
        if $@;
    wantarray ? ( $blob, @$image{qw(width height)} ) : $blob;
}

sub flipVertical {
    my $image  = shift;
    my $magick = _get_first_image( $image->_magick ) or return;
    my $blob;

    eval {
        $magick->Flip();
        $blob = $magick->ImageToBlob;
    };
    return $image->error( MT->translate( "Flip vertical failed: [_1]", $@ ) )
        if $@;
    wantarray ? ( $blob, @$image{qw(width height)} ) : $blob;
}

sub rotate {
    my $image = shift;
    my ( $degrees, $w, $h ) = $image->get_degrees(@_);
    my $magick = _get_first_image( $image->_magick ) or return;
    my $blob;

    eval {
        $magick->Rotate( degrees => $degrees );
        $blob = $magick->ImageToBlob;
    };
    return $image->error(
        MT->translate( "Rotate (degrees: [_1]) failed: [_2]", $degrees, $@ ) )
        if $@;
    wantarray ? ( $blob, $w, $h ) : $blob;
}

sub convert {
    my $image  = shift;
    my %param  = @_;
    my $type   = $image->{type} = $param{Type};
    my $magick = _get_first_image( $image->_magick ) or return;
    my $blob;

    eval {
        my $err = $magick->Set( magick => uc $type );
        return $image->error(
            MT->translate(
                "Converting image to [_1] failed: [_2]",
                $type, $err
            )
        ) if $err;

        # Set quality parameter for new type.
        $image->_set_quality or return;

        $blob = $magick->ImageToBlob;
    };
    return $image->error(
        MT->translate( "Converting image to [_1] failed: [_2]", $type, $@ ) )
        if $@;

    return $blob;
}

sub blob {
    my ( $image, $quality ) = @_;
    my $magick = $image->_magick or return;
    my $blob;

    eval {
        $image->_set_quality($quality) or return;

        $blob = $magick->ImageToBlob;
    };
    return $image->error(
        MT->translate( 'Outputting image failed: [_1]', $@ ) )
        if $@;

    return $blob;
}

sub _set_quality {
    my ( $image, $quality ) = @_;
    my $magick = $image->_magick or return;
    my $type = $magick->Get('magick') or return 1;

    if ( !defined $quality ) {
        my $lc_type = lc($type);
        $lc_type = 'jpeg' if $lc_type eq 'jpg';
        my $quality_column = $lc_type . '_quality';
        $quality
            = $image->can($quality_column)
            ? $image->$quality_column
            : undef;
    }
    if ( defined $quality ) {

        # Do not adjust the value when the value is set by argument.
        my $err = $magick->Set( quality => $quality );
        return $image->error(
            MT->transalte(
                'Setting quality parameter [_1] failed: [_2]', $quality,
                $err
            )
        ) if $err;
    }

    1;
}

1;
