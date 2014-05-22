# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: Image.pm 5319 2010-02-22 00:07:51Z auno $

package MT::Image::GD;
use strict;
use warnings;

use base qw( MT::Image );

sub load_driver {
    my $image = shift;
    eval { require GD };
    if ( my $err = $@ ) {
        return $image->error( MT->translate( "Cannot load GD: [_1]", $err ) );
    }
    GD::Image->trueColor(1);
    1;
}

sub init {
    my $image = shift;
    my %param = @_;

    if ( ( !defined $param{Type} ) && ( my $file = $param{Filename} ) ) {
        ( my $ext = $file ) =~ s/.*\.//;
        $param{Type} = lc $ext;
    }
    $image->{type} = _translate_filetype( $param{Type} )
        or return $image->error(
        MT->translate( "Unsupported image file type: [_1]", $param{Type} ) );

    if ( my $file = $param{Filename} ) {
        $image->{gd} = GD::Image->new($file)
            or return $image->error(
            MT->translate( "Reading file '[_1]' failed: [_2]", $file, $@ ) );
    }
    elsif ( my $blob = $param{Data} ) {
        $image->{gd} = GD::Image->new($blob)
            or return $image->error(
            MT->translate( "Reading image failed: [_1]", $@ ) );
    }
    ( $image->{width}, $image->{height} ) = $image->{gd}->getBounds();
    $image;
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
    my $image = shift;
    my $type  = $image->{type};
    $image->{gd}->$type;
}

sub scale {
    my $image = shift;
    my ( $w, $h ) = $image->get_dimensions(@_);
    my $src = $image->{gd};
    my $gd = GD::Image->new( $w, $h, 1 );    # True color image (24 bit)
    $gd->alphaBlending(0);
    $gd->saveAlpha(1);
    $gd->copyResampled( $src, 0, 0, 0, 0, $w, $h, $image->{width},
        $image->{height} );
    ( $image->{gd}, $image->{width}, $image->{height} ) = ( $gd, $w, $h );
    wantarray ? ( $image->blob, $w, $h ) : $image->blob;
}

sub crop {
    my $image = shift;
    my %param = @_;
    my ( $size, $x, $y ) = @param{qw( Size X Y )};
    my $src = $image->{gd};
    my $gd = GD::Image->new( $size, $size, 1 );    # True color image (24 bit)
    $gd->alphaBlending(0);
    $gd->saveAlpha(1);

    # Use copyResampled() instead of copy(),
    # because copy() with libgd 2.0.35 or lower does not work correctly.
    # $gd->copy( $src, 0, 0, $x, $y, $size, $size );
    $gd->copyResampled( $src, 0, 0, $x, $y, $size, $size, $size, $size );
    ( $image->{gd}, $image->{width}, $image->{height} )
        = ( $gd, $size, $size );
    wantarray ? ( $image->blob, $size, $size ) : $image->blob;
}

sub flipHorizontal {
    my $image = shift;
    $image->{gd}->flipHorizontal;

    wantarray ? ( $image->blob, @$image{qw(width height)} ) : $image->blob;
}

sub flipVertical {
    my $image = shift;
    $image->{gd}->flipVertical;

    wantarray ? ( $image->blob, @$image{qw(width height)} ) : $image->blob;
}

sub rotate {
    my $image = shift;
    my ( $degrees, $w, $h ) = $image->get_degrees(@_);

    my $method      = "rotate$degrees";
    my $copy_method = "copyRotate$degrees";
    if ( $image->{gd}->can($method) ) {
        $image->{gd}->$method;
    }
    elsif ( $image->{gd}->can($copy_method) ) {
        $image->{gd} = $image->{gd}->$copy_method;
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
