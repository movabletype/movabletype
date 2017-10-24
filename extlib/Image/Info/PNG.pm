package Image::Info::PNG;

# Copyright 1999-2000, Gisle Aas.
#
# This library is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

=begin register

MAGIC: /^\x89PNG\x0d\x0a\x1a\x0a/

Information from IHDR, PLTE, gAMA, pHYs, tEXt, tIME chunks are
extracted.  The sequence of chunks are also given by the C<PNG_Chunks>
key.

=end register

=cut

use strict;
use vars qw/$VERSION/;

$VERSION = 1.03;

# Test for Compress::Zlib (for reading zTXt chunks)
my $have_zlib = 0;
eval {
    require Compress::Zlib;
    $have_zlib++;
};

# Test for Encode (for reading iTXt chunks)
my $have_encode = 0;
eval {
    require Encode;
    $have_encode++;
};

sub my_read
{
    my($source, $len) = @_;
    my $buf;
    my $n = read($source, $buf, $len);
    die "read failed: $!" unless defined $n;
    die "short read ($len/$n) at pos " . tell($source) unless $n == $len;
    $buf;
}


sub process_file
{
    my($info, $fh) = @_;

    my $signature = my_read($fh, 8);
    die "Bad PNG signature"
	unless $signature eq "\x89PNG\x0d\x0a\x1a\x0a";

    $info->push_info(0, "file_media_type" => "image/png");
    $info->push_info(0, "file_ext" => "png");

    my @chunks;

    while (1) {
        my($len, $type) = unpack("Na4", my_read($fh, 8));

	if (@chunks) {
	    my $last = $chunks[-1];
	    my $count = 1;
	    $count = $1 if $last =~ s/\s(\d+)$//;
	    if ($last eq $type) {
		$count++;
		$chunks[-1] = "$type $count";
	    }
	    else {
		push(@chunks, $type);
	    }
	}
	else {
	    push(@chunks, $type);
	}

        last if $type eq "IEND";
        my $data = my_read($fh, $len + 4);
	my $crc = unpack("N", substr($data, -4, 4, ""));
	if ($type eq "IHDR" && $len == 13) {
	    my($w, $h, $depth, $ctype, $compression, $filter, $interlace) =
		unpack("NNCCCCC", $data);
	    $ctype = {
		      0 => "Gray",
		      2 => "RGB",
		      3 => "Indexed-RGB",
		      4 => "GrayA",
		      6 => "RGBA",
		     }->{$ctype} || "PNG-$ctype";

	    $compression = "Deflate" if $compression == 0;
	    $filter = "Adaptive" if $filter == 0;
	    $interlace = "Adam7" if $interlace == 1;

	    $info->push_info(0, "width", $w);
	    $info->push_info(0, "height", $h);
	    $info->push_info(0, "SampleFormat", "U$depth");
	    $info->push_info(0, "color_type", $ctype);

	    $info->push_info(0, "Compression", $compression);
	    $info->push_info(0, "PNG_Filter", $filter);
	    $info->push_info(0, "Interlace", $interlace)
		if $interlace;
	}
	elsif ($type eq "PLTE") {
	    my @table;
	    while (length $data) {
		push(@table, sprintf("#%02x%02x%02x",
				     unpack("C3", substr($data, 0, 3, ""))));
	    }
	    $info->push_info(0, "ColorPalette" => \@table);
	}
	elsif ($type eq "gAMA" && $len == 4) {
	    $info->push_info(0, "Gamma", unpack("N", $data)/100_000);
	}
	elsif ($type eq "pHYs" && $len == 9) {
	    my $res;
	    my($res_x, $res_y, $unit) = unpack("NNC", $data);
	    if (0 && $unit == 1) {
		# convert to dpi
		$unit = "dpi";
		for ($res_x, $res_y) {
		    $_ *= 0.0254;
		}
	    }
	    $res = ($res_x == $res_y) ? $res_x : "$res_x/$res_y";
	    if ($unit) {
		if ($unit == 1) {
		    $res .= " dpm";
		}
		else {
		    $res .= " png-unit-$unit";
		}
	    }
	    $info->push_info(0, "resolution" => $res)
	}
	elsif ($type eq "tEXt" || $type eq "zTXt" || $type eq "iTXt") {
	    my($key, $val) = split(/\0/, $data, 2);
            my($method,$ctext,$is_i);
            if ($type eq "iTXt") {
                ++$is_i;
                (my $compressed, $method, my $lang, my $trans, $ctext)
                    = unpack "CaZ*Z*a*", $val;
                unless ($compressed) {
                    undef $method;
                    $val = $ctext;
                }
            }
            elsif ($type eq "zTXt") {
		($method,$ctext) = split(//, $val, 2);
            }

            if (defined $method) {
                if ($have_zlib && $method eq "\0") {
                    $val = Compress::Zlib::uncompress($ctext);
                } else {
                    undef $val;
                }
            }

            if ($is_i) {
                if ($have_encode) {
                    $val = Encode::decode("UTF-8", $val);
                } else {
                    undef $val;
                }
            }

            if (defined $val) {
                # XXX should make sure $key is not in conflict with any
                # other key we might generate
                $info->push_info(0, $key, $val);
            } else {
                $info->push_info(0, "Chunk-$type" => $data);
            }
	}
	elsif ($type eq "tIME" && $len == 7) {
	    $info->push_info(0, "LastModificationTime",
			     sprintf("%04d-%02d-%02d %02d:%02d:%02d",
				     unpack("nC5", $data)));
	}
	elsif ($type eq "sBIT") {
	    $info->push_info(0, "SignificantBits" => unpack("C*", $data));
	}
	elsif ($type eq "IDAT") {
	    # ignore
	}
	else {
	    $info->push_info(0, "Chunk-$type" => $data);
	}
    }

    $info->push_info(0, "PNG_Chunks", @chunks);

    unless ($info->get_info(0, "resolution")) {
	$info->push_info(0, "resolution", "1/1");
    }
}

1;
