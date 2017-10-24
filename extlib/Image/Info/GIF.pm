package Image::Info::GIF;
$VERSION = '1.02';

# Copyright 1999-2000, Gisle Aas.
#
# This library is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

=begin register

MAGIC: /^GIF8[79]a/

Both GIF87a and GIF89a are supported and the version number is found
as C<GIF_Version> for the first image.  GIF files can contain multiple
images, and information for all images will be returned if
image_info() is called in list context.  The Netscape-2.0 extension to
loop animation sequences is represented by the C<GIF_Loop> key for the
first image.  The value is either "forever" or a number indicating
loop count.

=end register

=cut

use strict;

sub my_read
{
    my($source, $len) = @_;
    my $buf;
    my $n = read($source, $buf, $len);
    die "read failed: $!" unless defined $n;
    die "short read ($len/$n) at pos " . tell($source) unless $n == $len;
    $buf;
}

sub read_data_blocks
{
    my $source = shift;
    my @data;
    while (my $len = ord(my_read($source, 1))) {
	push(@data, my_read($source, $len));
    }
    join("", @data);
}

sub seek_data_blocks
{
    my $source = shift;
    while (my $len = ord(my_read($source, 1))) {
	seek($source, $len, 1);
    }
}

sub process_file
{
    my($info, $fh) = @_;

    my $header = my_read($fh, 13);
    die "Bad GIF signature"
	unless $header =~ s/^GIF(8[79]a)//;
    my $version = $1;
    $info->push_info(0, "GIF_Version" => $version);

    # process logical screen descriptor
    my($sw, $sh, $packed, $bg, $aspect) = unpack("vvCCC", $header);
    $info->push_info(0, "ScreenWidth" => $sw);
    $info->push_info(0, "ScreenHeight" => $sh);

    my $color_table_size = 1 << (($packed & 0x07) + 1);
    $info->push_info(0, "ColorTableSize" => $color_table_size);

    $info->push_info(0, "SortedColors" => ($packed & 0x08) ? 1 : 0)
	if $version eq "89a";

    $info->push_info(0, "ColorResolution", (($packed & 0x70) >> 4) + 1);

    my $global_color_table = $packed & 0x80;
    $info->push_info(0, "GlobalColorTableFlag" => $global_color_table ? 1 : 0);
    if ($global_color_table) {
	$info->push_info(0, "BackgroundColor", $bg);
    }

    if ($aspect) {
	$aspect = ($aspect + 15) / 64;
	$info->push_info(0, "PixelAspectRatio" => $aspect);

	# XXX is this correct????
	$info->push_info(0, "resolution", "1/$aspect");
    }
    else {
	$info->push_info(0, "resolution", "1/1");
    }

    $info->push_info(0, "file_media_type" => "image/gif");
    $info->push_info(0, "file_ext" => "gif");

    # more??
    if ($global_color_table) {
       my $color_table = my_read($fh, $color_table_size * 3);
       #$info->push_info(0, "GlobalColorTable", color_table($color_table));
    }

    my $img_no = 0;
    my @comments;
    my @warnings;

    while (1) {
	last if eof($fh); # EOF
	my $intro = ord(my_read($fh, 1));
	if ($intro == 0x3B) {  # trailer (end of image)
	    last;
	}
	elsif ($intro == 0x2C) {  # new image


	    if (@comments) {
		for (@comments) {
		    $info->push_info(0, "Comment", $_);
		}
		@comments = ();
	    }

	    $info->push_info($img_no, "color_type" => "Indexed-RGB");

	    my($x_pos, $y_pos, $w, $h, $packed) =
		unpack("vvvvC", my_read($fh, 9));
	    $info->push_info($img_no, "XPosition", $x_pos);
	    $info->push_info($img_no, "YPosition", $y_pos);
	    $info->push_info($img_no, "width", $w);
	    $info->push_info($img_no, "height", $h);

	    if ($packed & 0x80) {
		# yes, we have a local color table
		my $ct_size = 1 << (($packed & 0x07) + 1);
		$info->push_info($img_no, "LColorTableSize" => $ct_size);
		my $color_table = my_read($fh, $ct_size * 3);
	    }

	    $info->push_info($img_no, "Interlace" => "GIF")
		if $packed & 0x40;

	    my $lzw_code_size = ord(my_read($fh, 1));
	    #$info->push_info($img_no, "LZW_MininmCodeSize", $lzw_code_size);
	    seek_data_blocks($fh);  # skip image data
	    $img_no++;
	}
	elsif ($intro == 0x21) {  # GIF89a extension
	    push(@warnings, "GIF 89a extensions in 87a")
		if $version eq "87a";

	    my $label = ord(my_read($fh, 1));
	    my $data = read_data_blocks($fh);
	    if ($label == 0xF9 && length($data) == 4) {  # Graphic Control
		my($packed, $delay, $trans_color) = unpack("CvC", $data);
		my $disposal_method = ($packed >> 2) & 0x07;
		$info->push_info($img_no, "DisposalMethod", $disposal_method)
		    if $disposal_method;
		$info->push_info($img_no, "UserInput", 1)
		    if $packed & 0x02;
		$info->push_info($img_no, "Delay" => $delay/100) if $delay;
		$info->push_info($img_no, "TransparencyIndex" => $trans_color)
		    if $packed & 0x01;
	    }
	    elsif ($label == 0xFE) {  # Comment
		$data =~ s/\0+$//;  # is often NUL-terminated
		push(@comments, $data);
	    }
	    elsif ($label == 0xFF) {  # Application
		my $app = substr($data, 0, 11, "");
		my $auth = substr($app, -3, 3, "");
		if ($app eq "NETSCAPE" && $auth eq "2.0"
		    && $data =~ /^\01/) {
		    my $loop = unpack("xv", $data);
		    $loop = "forever" unless $loop;
		    $info->push_info(0, "GIF_Loop" => $loop);
		} else {
		    $info->push_info(0, "APP-$app-$auth" => $data);
		}
	    }
	    else {
		$info->push_info($img_no, "GIF_Extension-$label" => $data);
	    }
	}
	else {
	    push @warnings, "Unknown introduced code $intro, ignoring following chunks";
	    last;
	}
    }

    for (@comments) {
	$info->push_info(0, "Comment", $_);
    }

    for (@warnings) {
	$info->push_info(0, "Warn", $_);
    }
}

sub color_table
{
    my @n = unpack("C*", shift);
    die "Color table not a multiple of 3" if @n % 3;
    my @table;
    while (@n) {
	my @triple = splice(@n, -3);
	push(@table, sprintf("#%02x%02x%02x", @triple));
    }
    [reverse @table];
}

1;

__END__

=pod

=head1 NAME

Image::Info::GIF - Graphics Interchange Format support for Image::Info

=head1 SYNOPSIS

 use Image::Info qw(image_info dim);

 my $info = image_info("image.gif");
 if (my $error = $info->{error}) {
     die "Can't parse image info: $error\n";
 }
 my $color = $info->{color_type};

 my($w, $h) = dim($info);

=head1 DESCRIPTION

This module supplies the standard key names as well as

=over

=item GIF_Loop

The Netscape-2.0 extension to loop animation sequences is represented by the GIF_Loop key for the first image. The value is either "forever" or a number indicating loop count.

=back

head1 METHODS

=head2 process_file()
    
	$info->process_file($source, $options);

Processes one file and sets the found info fields in the C<$info> object.

=head1 SEE ALSO

L<Image::Info>

=cut
