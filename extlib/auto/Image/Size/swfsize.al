# NOTE: Derived from Image/Size.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Image::Size;

#line 1206 "Image/Size.pm (autosplit into /Users/fyoshimatsu/Downloads/Image-Size-3.2/auto/Image/Size/swfsize.al)"
# swfsize: determine size of ShockWave/Flash files. Adapted from code sent by
# Dmitry Dorofeev <dima@yasp.com>
sub swfsize
{
    my $image  = shift;
    my $header = &$read_in($image, 33);

    my $ver = _bin2int(unpack 'B8', substr($header, 3, 1));
    my $bs = unpack 'B133', substr($header, 8, 17);
    my $bits = _bin2int(substr($bs, 0, 5));
    my $x = int(_bin2int(substr($bs, 5+$bits, $bits))/20);
    my $y = int(_bin2int(substr($bs, 5+$bits*3, $bits))/20);

    return ($x, $y, 'SWF');
}

# end of Image::Size::swfsize
1;
