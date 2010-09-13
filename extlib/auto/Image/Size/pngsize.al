# NOTE: Derived from Image/Size.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Image::Size;

#line 970 "Image/Size.pm (autosplit into /Users/fyoshimatsu/Downloads/Image-Size-3.2/auto/Image/Size/pngsize.al)"
# pngsize : gets the width & height (in pixels) of a png file
# cor this program is on the cutting edge of technology! (pity it's blunt!)
#
# Re-written and tested by tmetro@vl.com
sub pngsize
{
    my $stream = shift;

    my ($x, $y, $id) = (undef, undef, "could not determine PNG size");
    my ($offset, $length);

    # Offset to first Chunk Type code = 8-byte ident + 4-byte chunk length + 1
    $offset = 12; $length = 4;
    if (&$read_in($stream, $length, $offset) eq 'IHDR')
    {
        # IHDR = Image Header
        $length = 8;
        ($x, $y) = unpack("NN", &$read_in($stream, $length));
        $id = 'PNG';
    }

    ($x, $y, $id);
}

# end of Image::Size::pngsize
1;
