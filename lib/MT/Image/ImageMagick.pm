# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: Image.pm 5319 2010-02-22 00:07:51Z auno $

package MT::Image::ImageMagick;
use strict;
use warnings;

use base qw( MT::Image );

sub load_driver {
    my $image = shift;
    eval { require Image::Magick };
    if ( my $err = $@ ) {
        return $image->error(
            MT->translate( "Cannot load Image::Magick: [_1]", $err ) );
    }
    1;
}

sub init {
    my $image = shift;
    my %param = @_;

    $image->SUPER::init(%param);

    my %arg = ();
    if ( my $type = $param{Type} ) {
        %arg = ( magick => lc($type) );
    }
    elsif ( my $file = $param{Filename} ) {
        ( my $ext = $file ) =~ s/.*\.//;
        %arg = ( magick => lc($ext) );
    }
    my $magick = $image->{magick} = Image::Magick->new(%arg);
    if ( my $file = $param{Filename} ) {
        my $x;
        eval { $x = $magick->Read($file); };
        return $image->error(
            MT->translate( "Reading file '[_1]' failed: [_2]", $file, $x ) )
            if $x;
        ( $image->{width}, $image->{height} )
            = $magick->Get( 'width', 'height' );
    }
    elsif ( $param{Data} ) {
        my $x;
        eval { my $x = $magick->BlobToImage( $param{Data} ); };
        return $image->error(
            MT->translate( "Reading image failed: [_1]", $x ) )
            if $x;
        ( $image->{width}, $image->{height} )
            = $magick->Get( 'width', 'height' );
    }

    # Set quality.
    my $quality;
    if ( $arg{magick} eq 'jpg' || $arg{magick} eq 'jpeg' ) {
        $quality = $image->jpeg_quality;
    }
    elsif ( $arg{magick} eq 'png' ) {
        $quality = $image->png_quality;
    }
    if ( defined $quality ) {
        eval {
            my $err = $magick->Set( quality => $quality );
            return $image->error(
                MT->transalte(
                    'Setting quality parameter [_1] failed: [_2]', $quality,
                    $err
                )
            ) if $err;
        };
    }

    $image;
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

sub scale {
    my $image = shift;
    my ( $w, $h ) = $image->get_dimensions(@_);
    my $magick = $image->{magick};
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
    my $magick = $image->{magick};
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
    my $magick = $image->{magick};
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
    my $magick = $image->{magick};
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
    my $magick = $image->{magick};
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
    my $magick = $image->{magick};
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
    my $magick = $image->{magick};
    my $blob;

    eval {
        $image->_set_quality($quality) or return;

        $blob = $magick->ImageToBlob;
    };
    return $image->error(
        MT->translate( 'Outputting image failed: [_1]', $@ ) )
        if $@;

    return $magick->ImageToBlob;
}

sub _set_quality {
    my ( $image, $quality ) = @_;
    my $type = $image->{type} or return 1;
    my $magick = $image->{magick};

    if ( !defined $quality ) {
        my $lc_type = uc($type);
        $lc_type = 'jpeg' if $lc_type eq 'jpg';
        my $quality_column = uc($type) . '_quality';
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
