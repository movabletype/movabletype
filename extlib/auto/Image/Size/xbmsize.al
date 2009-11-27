# NOTE: Derived from Image/Size.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Image::Size;

#line 930 "Image/Size.pm (autosplit into /Users/fyoshimatsu/Downloads/Image-Size-3.2/auto/Image/Size/xbmsize.al)"
sub xbmsize
{
    my $stream = shift;

    my $input;
    my ($x, $y, $id) = (undef, undef, "Could not determine XBM size");

    $input = &$read_in($stream, 1024);
    if ($input =~ /^\#define\s*\S*\s*(\d+)\s*\n\#define\s*\S*\s*(\d+)/si)
    {
        ($x, $y) = ($1, $2);
        $id = 'XBM';
    }

    ($x, $y, $id);
}

# end of Image::Size::xbmsize
1;
