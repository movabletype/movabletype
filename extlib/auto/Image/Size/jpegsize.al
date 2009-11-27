# NOTE: Derived from Image/Size.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Image::Size;

#line 1018 "Image/Size.pm (autosplit into /Users/fyoshimatsu/Downloads/Image-Size-3.2/auto/Image/Size/jpegsize.al)"
# jpegsize: gets the width and height (in pixels) of a jpeg file
# Andrew Tong, werdna@ugcs.caltech.edu           February 14, 1995
# modified slightly by alex@ed.ac.uk
# and further still by rjray@blackperl.com
# optimization and general re-write from tmetro@vl.com
sub jpegsize
{
    my $stream = shift;

    my $MARKER      = "\xFF";       # Section marker.

    my $SIZE_FIRST  = 0xC0;         # Range of segment identifier codes
    my $SIZE_LAST   = 0xC3;         #  that hold size info.

    my ($x, $y, $id) = (undef, undef, "could not determine JPEG size");

    my ($marker, $code, $length);
    my $segheader;

    # Dummy read to skip header ID
    &$read_in($stream, 2);
    while (1)
    {
        $length = 4;
        $segheader = &$read_in($stream, $length);

        # Extract the segment header.
        ($marker, $code, $length) = unpack("a a n", $segheader);

        # Verify that it's a valid segment.
        if ($marker ne $MARKER)
        {
            # Was it there?
            $id = "JPEG marker not found";
            last;
        }
        elsif ((ord($code) >= $SIZE_FIRST) && (ord($code) <= $SIZE_LAST))
        {
            # Segments that contain size info
            $length = 5;
            ($y, $x) = unpack("xnn", &$read_in($stream, $length));
            $id = 'JPG';
            last;
        }
        else
        {
            # Dummy read to skip over data
            &$read_in($stream, ($length - 2));
        }
    }

    ($x, $y, $id);
}

# end of Image::Size::jpegsize
1;
