# NOTE: Derived from Image/Size.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Image::Size;

#line 947 "Image/Size.pm (autosplit into /Users/fyoshimatsu/Downloads/Image-Size-3.2/auto/Image/Size/xpmsize.al)"
# Added by Randy J. Ray, 30 Jul 1996
# Size an XPM file by looking for the "X Y N W" line, where X and Y are
# dimensions, N is the total number of colors defined, and W is the width of
# a color in the ASCII representation, in characters. We only care about X & Y.
sub xpmsize
{
    my $stream = shift;

    my $line;
    my ($x, $y, $id) = (undef, undef, "Could not determine XPM size");

    while ($line = &$read_in($stream, 1024))
    {
        next unless ($line =~ /"\s*(\d+)\s+(\d+)(\s+\d+\s+\d+){1,2}\s*"/s);
        ($x, $y) = ($1, $2);
        $id = 'XPM';
        last;
    }

    ($x, $y, $id);
}

# end of Image::Size::xpmsize
1;
