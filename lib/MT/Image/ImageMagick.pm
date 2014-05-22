# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
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
    my %arg   = ();
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
    $image;
}

sub scale {
    my $image = shift;
    my ( $w, $h ) = $image->get_dimensions(@_);
    my $magick = $image->{magick};
    my $blob;
    eval {
        my $err
            = $magick->can('Resize')
            ? $magick->Resize( width => $w, height => $h )
            : $magick->Scale( width => $w, height => $h );
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

sub crop {
    my $image = shift;
    my %param = @_;
    my ( $size, $x, $y ) = @param{qw( Size X Y )};
    my $magick = $image->{magick};
    my $blob;

    eval {
        my $err = $magick->Crop(
            width  => $size,
            height => $size,
            x      => $x,
            y      => $y
        );
        return $image->error(
            MT->translate(
                "Cropping a [_1]x[_1] square at [_2],[_3] failed: [_4]",
                $size, $x, $y, $err
            )
        ) if $err;

        ## Remove page offsets from the original image, per this thread:
        ## http://studio.imagemagick.org/pipermail/magick-users/2003-September/010803.html
        $magick->Set( page => '+0+0' );

        ( $image->{width}, $image->{height} ) = ( $size, $size );
        $blob = $magick->ImageToBlob;
    };
    return $image->error(
        MT->translate(
            "Cropping a [_1]x[_1] square at [_2],[_3] failed: [_4]",
            $size, $x, $y, $@
        )
    ) if $@;

    wantarray ? ( $blob, $size, $size ) : $blob;
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
        $blob = $magick->ImageToBlob;
    };
    return $image->error(
        MT->translate( "Converting image to [_1] failed: [_2]", $type, $@ ) )
        if $@;

    return $blob;
}

1;
