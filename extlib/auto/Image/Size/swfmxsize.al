# NOTE: Derived from Image/Size.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Image::Size;

#line 1242 "Image/Size.pm (autosplit into /Users/fyoshimatsu/Downloads/Image-Size-3.2/auto/Image/Size/swfmxsize.al)"
# swfmxsize: determine size of compressed ShockWave/Flash MX files. Adapted
# from code sent by Victor Kuriashkin <victor@yasp.com>
sub swfmxsize
{
    eval 'require Compress::Zlib;';
    return (undef, undef, "Error loading Compress::Zlib: $@") if $@;

    my ($image) = @_;
    my $header = &$read_in($image, 1058);
    my $ver = _bin2int(unpack 'B8', substr($header, 3, 1));

    my ($d, $status) = Compress::Zlib::inflateInit();
    $header = substr($header, 8, 1024);
    $header = $d->inflate($header);

    my $bs = unpack 'B133', substr($header, 0, 9);
    my $bits = _bin2int(substr($bs, 0, 5));
    my $x = int(_bin2int(substr($bs, 5+$bits, $bits))/20);
    my $y = int(_bin2int(substr($bs, 5+$bits*3, $bits))/20);

    return ($x, $y, 'CWS');
}

1;
# end of Image::Size::swfmxsize
