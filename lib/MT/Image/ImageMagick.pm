# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: Image.pm 5319 2010-02-22 00:07:51Z auno $

package MT::Image::ImageMagick;
use strict;
use warnings;

@MT::Image::ImageMagick::ISA = qw( MT::Image );

sub load_driver {
    my $image = shift;
    eval { require Image::Magick };
    if (my $err = $@) {
        return $image->error(MT->translate("Can't load Image::Magick: [_1]", $err));
    }
    1;
}

sub init {
    my $image = shift;
    my %param = @_;
    my %arg = ();
    if (my $type = $param{Type}) {
        %arg = (magick => lc($type));
    } elsif (my $file = $param{Filename}) {
        (my $ext = $file) =~ s/.*\.//;
        %arg = (magick => lc($ext));
    }
    my $magick = $image->{magick} = Image::Magick->new(%arg);
    if (my $file = $param{Filename}) {
        my $x = $magick->Read($file);
        return $image->error(MT->translate(
            "Reading file '[_1]' failed: [_2]", $file, $x)) if $x;
        ($image->{width}, $image->{height}) = $magick->Get('width', 'height');
    } elsif ($param{Data}) {
        my $x = $magick->BlobToImage($param{Data});
        return $image->error(MT->translate(
            "Reading image failed: [_1]", $x)) if $x;
        ($image->{width}, $image->{height}) = $magick->Get('width', 'height');
    }
    $image;
}

sub scale {
    my $image = shift;
    my($w, $h) = $image->get_dimensions(@_);
    my $magick = $image->{magick};
    my $err = $magick->can('Resize') ?
              $magick->Resize(width => $w, height => $h) :
              $magick->Scale(width => $w, height => $h);
    return $image->error(MT->translate(
        "Scaling to [_1]x[_2] failed: [_3]", $w, $h, $err)) if $err;
    $magick->Profile("*") if $magick->can('Profile');
    ($image->{width}, $image->{height}) = ($w, $h);
    wantarray ? ($magick->ImageToBlob, $w, $h) : $magick->ImageToBlob;
}

sub crop {
    my $image = shift;
    my %param = @_;
    my ($size, $x, $y) = @param{qw( Size X Y )};
    my $magick = $image->{magick};

    my $err = $magick->Crop(width => $size, height => $size, x => $x, y => $y);
    return $image->error(MT->translate(
        "Cropping a [_1]x[_1] square at [_2],[_3] failed: [_4]", $size, $x,
        $y, $err)) if $err;

    ## Remove page offsets from the original image, per this thread:
    ## http://studio.imagemagick.org/pipermail/magick-users/2003-September/010803.html
    $magick->Set( page => '+0+0' );

    ($image->{width}, $image->{height}) = ($size, $size);
    wantarray ? ($magick->ImageToBlob, $size, $size) : $magick->ImageToBlob;
}

sub convert {
    my $image = shift;
    my %param = @_;
    my $type = $image->{type} = $param{Type};

    my $magick = $image->{magick};
    my $err = $magick->Set( magick => uc $type );
    return $image->error(MT->translate(
            "Converting image to [_1] failed: [_2]", $type, $err)) if $err;
    $magick->ImageToBlob;
}

1;
