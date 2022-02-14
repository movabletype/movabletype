# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: Image.pm 5319 2010-02-22 00:07:51Z auno $

package MT::Image::Imager;
use strict;
use warnings;

use base qw( MT::Image );

sub load_driver {
    my $image = shift;

    eval { require Imager };
    if ( my $err = $@ ) {
        return $image->error(
            MT->translate( "Cannot load Imager: [_1]", $err ) );
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

sub _imager {
    my $image = shift;
    return $image->{imager} if $image->{imager};

    my $param = $image->{param};

    my $imager = Imager->new;
    if ( my $file = $param->{Filename} ) {
        $imager->read( file => $file, type => $image->{type} )
            or return $image->error(
            MT->translate(
                "Reading file '[_1]' failed: [_2]", $file,
                $imager->errstr
            )
            );
    }
    elsif ( my $blob = $param->{Data} ) {
        $imager->read( data => $blob, type => $image->{type} )
            or return $image->error(
            MT->translate( "Reading image failed: [_1]", $imager->errstr ) );
    }

    $image->{imager} = $imager;
}

sub _init_image_size {
    my $image = shift;
    return ($image->{width}, $image->{height}) if defined $image->{width} && defined $image->{height};

    my $imager = $image->_imager;
    $image->{width}  = $imager->getwidth;
    $image->{height} = $imager->getheight;
    return ($image->{width}, $image->{height});
}

{
    my $Types;

    sub _translate_filetype {
        if ( !defined $Types ) {
            $Types = { map { $_ => $_ } Imager->read_types };
            $Types->{jpg} = 'jpeg' if $Types->{jpeg};
            $Types->{tif} = 'tiff' if $Types->{tiff};
        }
        return $Types->{ lc $_[0] };
    }
}

sub blob {
    my ( $image, $quality ) = @_;
    my $blob;
    my $imager = $image->_imager;
    my $is_jpeg = defined $image->{type} && $image->{type} eq 'jpeg';
    if ( $is_jpeg
        && ( $imager->getchannels == 2 || $imager->getchannels == 4 ) )
    {
        $imager = $imager->convert( preset => "noalpha" );
    }

    # TODO: Imager cannot change PNG compression level.
    if ( $is_jpeg && !defined $quality ) {
        $quality = $image->jpeg_quality;
    }

    $imager->write(
        data => \$blob,
        type => $image->{type},
        $is_jpeg ? ( jpegquality => $quality ) : (),
    );
    $blob;
}

sub scale {
    my $image = shift;
    my ( $w, $h ) = $image->get_dimensions(@_);

    $image->{imager} = $image->_imager
        ->scale( xpixels => $w, ypixels => $h, type => 'nonprop' );
    @$image{qw/width height/} = ( $w, $h );

    wantarray ? ( $image->blob, $w, $h ) : $image->blob;
}

sub crop_rectangle {
    my $image = shift;
    my %param = @_;
    my ( $width, $height, $x, $y ) = @param{qw( Width Height X Y )};

    $image->{imager} = $image->_imager
        ->crop( left => $x, top => $y, width => $width, height => $height );
    $image->{width}  = $width;
    $image->{height} = $height;

    wantarray ? ( $image->blob, $width, $height ) : $image->blob;
}

sub flipHorizontal {
    my $image = shift;
    my $imager = $image->_imager or return;
    $image->{imager} = $imager->flip( dir => 'h' );

    wantarray ? ( $image->blob, @$image{qw(width height)} ) : $image->blob;
}

sub flipVertical {
    my $image = shift;
    my $imager = $image->_imager or return;
    $image->{imager} = $imager->flip( dir => 'v' );

    wantarray ? ( $image->blob, @$image{qw(width height)} ) : $image->blob;
}

sub rotate {
    my $image = shift;
    my $imager = $image->_imager or return;
    my ( $degrees, $w, $h ) = $image->get_degrees(@_);

    $image->{imager} = $imager->rotate( right => $degrees );

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
