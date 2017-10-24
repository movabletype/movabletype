package Image::Info::ICO;
$VERSION = '0.02';

# Copyright (C) 2009 Slaven Rezic. All rights reserved.
# This package is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

use strict;

sub process_file {
    my($info, $fh) = @_;

    my $buf;
    if (read($fh, $buf, 6) != 6) {
	$info->push_info(0, 'error' => 'Short read (expected at least 6 bytes)');
	return;
    }

    $info->push_info(0, 'file_media_type' => 'image/x-icon'); # XXX or is there already an official vnd format?
    $info->push_info(0, 'file_ext' => 'ico');

    my($no_icons) = unpack('v', substr($buf, 4, 2));

    for my $img_no (0 .. $no_icons-1) {
	if (read($fh, $buf, 16) != 16) {
	    $info->push_info(0, 'error' => "Short read while getting information for image at index $img_no");
	    return;
	}
	my($width,
	   $height,
	   $colors,
	   undef, # reserved
	   undef, # $planes
	   undef, # $bitcount
	   undef, # $size_in_bytes
	   undef, # $file_offset
	  ) = unpack('CCCCvvVV', $buf);
	if ($colors == 0) { $colors = 256 }

	$info->push_info($img_no, 'width', $width);
	$info->push_info($img_no, 'height', $height);
	$info->push_info($img_no, 'color_type', 'Indexed-RGB');
	$info->push_info($img_no, 'colors', $colors);
    }
}

1;

__END__

=head1 NAME

Image::Info::ICO - Microsoft ICO support for Image::Info

=head1 NOTES

This module adds only support for MS Icon files, but not for cursor
files.

=head1 AUTHOR

Slaven Rezic

=head1 SEE ALSO

L<Image::Info>

=begin register

MAGIC: /^\000\000\001\000/

This module supports the Microsoft Windows Icon Resource format
(.ico).

=end register

=cut
