# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
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

    if ( ( !defined $param{Type} ) && ( my $file = $param{Filename} ) ) {
        ( my $ext = $file ) =~ s/.*\.//;
        $param{Type} = lc $ext;
    }

    $image->{type} = _translate_filetype( $param{Type} )
        or return $image->error(
        MT->translate( "Unsupported image file type: [_1]", $param{Type} ) );

    my $imager = Imager->new;
    if ( my $file = $param{Filename} ) {
        $imager->read( file => $file, type => $image->{type} )
            or return $image->error(
            MT->translate(
                "Reading file '[_1]' failed: [_2]", $file,
                $imager->errstr
            )
            );
    }
    elsif ( my $blob = $param{Data} ) {
        $imager->read( data => $blob, type => $image->{type} )
            or return $image->error(
            MT->translate( "Reading image failed: [_1]", $imager->errstr ) );
    }

    $image->{imager} = $imager;
    $image->{width}  = $image->{imager}->getwidth;
    $image->{height} = $image->{imager}->getheight;

    $image;
}

{
    my $Types;

    sub _translate_filetype {
        if ( !defined $Types ) {
            $Types = { map { $_ => $_ } Imager->read_types };
            $Types->{jpg} = 'jpeg' if $Types->{jpeg};
        }
        return $Types->{ lc $_[0] };
    }
}

sub blob {
    my $image = shift;
    my $blob;
    my $imager = $image->{imager};
    if (   defined $image->{type}
        && $image->{type} eq 'jpeg'
        && ( $imager->getchannels == 2 || $imager->getchannels == 4 ) )
    {
        $imager = $imager->convert( preset => "noalpha" );
    }
    $imager->write( data => \$blob, type => $image->{type} );
    $blob;
}

sub scale {
    my $image = shift;
    my ( $w, $h ) = $image->get_dimensions(@_);

    $image->{imager} = $image->{imager}
        ->scale( xpixels => $w, ypixels => $h, type => 'nonprop' );
    @$image{qw/width height/} = ( $w, $h );

    wantarray ? ( $image->blob, $w, $h ) : $image->blob;
}

sub crop {
    my $image = shift;
    my %param = @_;
    my ( $size, $x, $y ) = @param{qw( Size X Y )};

    $image->{imager} = $image->{imager}
        ->crop( left => $x, top => $y, width => $size, height => $size );
    $image->{width} = $image->{height} = $size;

    wantarray ? ( $image->blob, $size, $size ) : $image->blob;
}

sub flipHorizontal {
    my $image = shift;
    $image->{imager} = $image->{imager}->flip( dir => 'h' );

    wantarray ? ( $image->blob, @$image{qw(width height)} ) : $image->blob;
}

sub flipVertical {
    my $image = shift;
    $image->{imager} = $image->{imager}->flip( dir => 'v' );

    wantarray ? ( $image->blob, @$image{qw(width height)} ) : $image->blob;
}

sub rotate {
    my $image = shift;
    my ( $degrees, $w, $h ) = $image->get_degrees(@_);

    $image->{imager} = $image->{imager}->rotate( right => $degrees );

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
