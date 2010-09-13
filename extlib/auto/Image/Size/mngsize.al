# NOTE: Derived from Image/Size.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Image::Size;

#line 994 "Image/Size.pm (autosplit into /Users/fyoshimatsu/Downloads/Image-Size-3.2/auto/Image/Size/mngsize.al)"
# mngsize: gets the width and height (in pixels) of an MNG file.
# See <URL:http://www.libpng.org/pub/mng/spec/> for the specification.
#
# Basically a copy of pngsize.
sub mngsize
{
    my $stream = shift;

    my ($x, $y, $id) = (undef, undef, "could not determine MNG size");
    my ($offset, $length);

    # Offset to first Chunk Type code = 8-byte ident + 4-byte chunk length + 1
    $offset = 12; $length = 4;
    if (&$read_in($stream, $length, $offset) eq 'MHDR')
    {
        # MHDR = Image Header
        $length = 8;
        ($x, $y) = unpack("NN", &$read_in($stream, $length));
        $id = 'MNG';
    }

    ($x, $y, $id);
}

# end of Image::Size::mngsize
1;
