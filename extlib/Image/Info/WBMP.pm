# -*- perl -*-

#
# Copyright (C) 2013 Slaven Rezic. All rights reserved.
# This package is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#

package Image::Info::WBMP;

use strict;
use vars qw($VERSION @EXPORT_OK);
$VERSION = '0.01';

require Exporter;
*import = \&Exporter::import;

@EXPORT_OK = qw(wbmp_image_info);

sub process_file {
    my($info, $fh) = @_;

    # wbmp files have no magic, so no signature check

    $info->push_info(0, 'file_media_type' => 'image/vnd.wap.wbmp');
    $info->push_info(0, 'file_ext' => 'wbmp');

    # logic taken from netpbm's wbmptopbm.c and adapted to perl

    my $readint = sub {
	my $sum = 0;
	my $pos = 0;
	my $c;
	do {
	    $c = ord(getc $fh);
	    $sum = ($sum << 7*$pos++) | ($c & 0x7f);
	} while($c & 0x80);
	return $sum;
    };

    my $readheader = sub {
	my $h = shift;
	if ($h & 0x60 == 0) {
	    # type 00: read multi-byte bitfield
	    my $c;
	    do { $c = ord(getc $fh) } while($c & 0x80);
	} elsif ($h & 0x60 == 0x60) {
	    # type 11: read name/value pair
	    for(my $i=0; $i < (($h & 0x70) >> 4) + ($h & 0x0f); $i++) { getc $fh }
	}
    };

    my $c;
    $c = $readint->();
    $c == 0
	or die "Unrecognized WBMP type (got $c)";
    $c = ord(getc $fh); # FixHeaderField
    while($c & 0x80) { # ExtheaderFields
	$c = ord(getc $fh);
	$readheader->($c);
    }
    my $w = $readint->();
    my $h = $readint->();
    $info->push_info(0, 'width', $w);
    $info->push_info(0, 'height', $h);
}

sub wbmp_image_info {
    my $source = Image::Info::_source(shift);
    return $source if ref $source eq 'HASH'; # Pass on errors

    return Image::Info::_image_info_for_format('WBMP', $source);
}

1;

__END__

=head1 NAME

Image::Info::WBMP - WBMP support for Image::Info

=head1 SYNOPSIS

 use Image::Info qw(dim);
 use Image::Info::WBMP qw(wbmp_image_info);

 my $info = wbmp_image_info("image.xpm");
 if (my $error = $info->{error}) {
     die "Can't parse image info: $error\n";
 }
 my($w, $h) = dim($info);

=head1 DESCRIPTION

wbmp is a magic-less file format, so using L<Image::Info>'s
C<image_info> or C<image_type> does not work here. Instead, the user
has to determine the file type himself, e.g. by relying on the file
suffix or mime type, and use the C<wbmp_image_info> function instead.
The returned value looks the same like L<Image::Info>'s C<image_info>
and may be used in a call to the C<dim> function.

=head1 AUTHOR

Slaven Rezic <srezic@cpan.org>

=begin register

NO MAGIC: true

wbmp files have no magic, so cannot be used with the normal
Image::Info functions. See L<Image::Info::WBMP> for more information.

=end register

=cut
