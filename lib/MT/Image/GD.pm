# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: Image.pm 5319 2010-02-22 00:07:51Z auno $

package MT::Image::GD;
use strict;
use warnings;

use base qw( MT::Image );

use Class::Method::Modifiers;

our $OVERRIDE;

sub load_driver {
    my $image = shift;
    eval { require GD };
    if ( my $err = $@ ) {
        return $image->error( MT->translate( "Cannot load GD: [_1]", $err ) );
    }
    GD::Image->trueColor(1);

    # All file starting SOI is JPEG.
    if ( !$OVERRIDE ) {
        $OVERRIDE = 1;
        around 'GD::Image::_image_type' => sub {
            my ( $orig, $data ) = @_;
            my $magic = unpack( 'H*', substr( $data, 0, 2 ) );
            return 'Jpeg' if $magic eq 'ffd8';
            $orig->($data);
        };
    }

    1;
}

sub init {
    my $image = shift;
    my %param = @_;

    $image->SUPER::init(%param);

    if ( ( !defined $param{Type} ) && ( my $file = $param{Filename} ) ) {
        ( my $ext = $file ) =~ s/.*\.//;
        $param{Type} = lc $ext;
    }
    $image->{type} = _translate_filetype( $param{Type} )
        or return $image->error(
        MT->translate( "Unsupported image file type: [_1]", $param{Type} ) );

    $image;
}

sub _gd {
    my $image = shift;
    return $image->{gd} if $image->{gd};

    my $param = $image->{param};
    if ( my $file = $param->{Filename} ) {
        $image->{gd} = GD::Image->new($file)
            or return $image->error(
            MT->translate( "Reading file '[_1]' failed: [_2]", $file, $@ ) );
    }
    elsif ( my $blob = $param->{Data} ) {
        $image->{gd} = GD::Image->new($blob)
            or return $image->error(
            MT->translate( "Reading image failed: [_1]", $@ ) );
    }
    $image->_init_image_size;
    $image->{gd}->alphaBlending(0);
    $image->{gd}->saveAlpha(1);
    $image->{gd};
}

sub _init_image_size {
    my $image = shift;
    return ($image->{width}, $image->{height}) if defined $image->{width} && defined $image->{height};
    my $gd = $image->_gd or return;
    ( $image->{width}, $image->{height} ) = $gd->getBounds();
}

sub _translate_filetype {
    return {
        jpg  => 'jpeg',
        jpeg => 'jpeg',
        gif  => 'gif',
        png  => 'png',
    }->{ lc $_[0] };
}

sub blob {
    my ( $image, $quality ) = @_;
    my $type = $image->{type};
    my $gd   = $image->_gd or return;

    if ( !defined $quality ) {
        my $quality_column = "${type}_quality";
        $quality
            = $image->can($quality_column) ? $image->$quality_column : undef;
    }

    if ( defined $quality ) {
        $gd->$type($quality);
    }
    else {
        $gd->$type;
    }
}

sub scale {
    my $image = shift;
    my ( $w, $h ) = $image->get_dimensions(@_);
    my $src = $image->_gd;
    my $gd = GD::Image->new( $w, $h, 1 );    # True color image (24 bit)
    $gd->alphaBlending(0);
    $gd->saveAlpha(1);
    $gd->copyResampled( $src, 0, 0, 0, 0, $w, $h, $image->{width},
        $image->{height} );
    ( $image->{gd}, $image->{width}, $image->{height} ) = ( $gd, $w, $h );
    wantarray ? ( $image->blob, $w, $h ) : $image->blob;
}

sub crop_rectangle {
    my $image = shift;
    my %param = @_;
    my ( $width, $height, $x, $y ) = @param{qw( Width Height X Y )};
    my $src = $image->_gd;
    my $gd = GD::Image->new( $width, $height, 1 ); # True color image (24 bit)
    $gd->alphaBlending(0);
    $gd->saveAlpha(1);

    # Use copyResampled() instead of copy(),
    # because copy() with libgd 2.0.35 or lower does not work correctly.
    # $gd->copy( $src, 0, 0, $x, $y, $size, $size );
    $gd->copyResampled( $src, 0, 0, $x, $y, $width, $height, $width,
        $height );
    ( $image->{gd}, $image->{width}, $image->{height} )
        = ( $gd, $width, $height );
    wantarray ? ( $image->blob, $width, $height ) : $image->blob;
}

sub flipHorizontal {
    my $image = shift;

    my $gd = $image->_gd or return;
    $gd->flipHorizontal;

    wantarray ? ( $image->blob, @$image{qw(width height)} ) : $image->blob;
}

sub flipVertical {
    my $image = shift;

    my $gd = $image->_gd or return;
    $gd->flipVertical;

    wantarray ? ( $image->blob, @$image{qw(width height)} ) : $image->blob;
}

sub rotate {
    my $image = shift;
    my $gd = $image->_gd or return;
    my ( $degrees, $w, $h ) = $image->get_degrees(@_);

    my $method      = "rotate$degrees";
    my $copy_method = "copyRotate$degrees";
    if ( $gd->can($method) ) {
        $gd->$method;
    }
    elsif ( $gd->can($copy_method) ) {
        $image->{gd} = $gd->$copy_method;
    }
    else {
        return $image->error(
            MT->translate(
                "Rotate (degrees: [_1]) is not supported", $degrees
            )
        );
    }

    wantarray
        ? ( $image->blob, $w, $h )
        : $image->blob;
}

sub convert {
    my $image = shift;
    my %param = @_;
    $image->{type} = _translate_filetype( $param{Type} );
    $image->blob;
}

1;
