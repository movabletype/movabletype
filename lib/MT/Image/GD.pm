# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: Image.pm 5319 2010-02-22 00:07:51Z auno $

package MT::Image::GD;
use strict;
use warnings;

@MT::Image::GD::ISA = qw( MT::Image );

sub load_driver {
    my $image = shift;
    eval { require GD };
    if (my $err = $@) {
        return $image->error(MT->translate("Can't load GD: [_1]", $err));
    }
    1;
}

sub init {
    my $image = shift;
    my %param = @_;

    if ((!defined $param{Type}) && (my $file = $param{Filename})) {
        (my $ext = $file) =~ s/.*\.//;
        $param{Type} = lc $ext;
    }
    $image->{type} = _translate_filetype($param{Type})
        or return $image->error(MT->translate("Unsupported image file type: [_1]", $param{Type}));

    if (my $file = $param{Filename}) {
    $image->{gd} = GD::Image->new($file)
        or return $image->error(MT->translate("Reading file '[_1]' failed: [_2]", $file, $@));
    } elsif (my $blob = $param{Data}) {
    $image->{gd} = GD::Image->new($blob)
        or return $image->error(MT->translate("Reading image failed: [_1]", $@));
    }
    ($image->{width}, $image->{height}) = $image->{gd}->getBounds();
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
    my $type = $image->{type};
    $image->{gd}->$type;
}

sub scale {
    my $image = shift;
    my($w, $h) = $image->get_dimensions(@_);
    my $src = $image->{gd};
    my $gd = GD::Image->new($w, $h, 1);  # True color image (24 bit)
    $gd->copyResampled($src, 0, 0, 0, 0, $w, $h, $image->{width}, $image->{height});
    ($image->{gd}, $image->{width}, $image->{height}) = ($gd, $w, $h);
    wantarray ? ($image->blob, $w, $h) : $image->blob;
}

sub crop {
    my $image = shift;
    my %param = @_;
    my ($size, $x, $y) = @param{qw( Size X Y )};
    my $src = $image->{gd};
    my $gd = GD::Image->new($size, $size, 1);  # True color image (24 bit)
    $gd->copy($src, 0, 0, $x, $y, $size, $size);
    ($image->{gd}, $image->{width}, $image->{height}) = ($gd, $size, $size);
    wantarray ? ($image->blob, $size, $size) : $image->blob;
}

sub convert {
    my $image = shift;
    my %param = @_;
    $image->{type} = _translate_filetype( $param{Type} );
    $image->blob;
}

1;
