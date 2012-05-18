# NOTE: Derived from blib/lib/Image/Size.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Image::Size;

#line 1369 "blib/lib/Image/Size.pm (autosplit into blib/lib/auto/Image/Size/emfsize.al)"
# Windows EMF files, requested by Jan v/d Zee
sub emfsize
{
    my $image = shift;

    my ($x, $y);
    my $buffer = $READ_IN->($image, 24);

    my ($x1, $y1, $x2, $y2) = unpack 'x8VVVV', $buffer;

    # The four values describe a box *around* the image, not *of* the image.
    # In other words, the dimensions are not inclusive.
    $x = $x2 - $x1 - 1;
    $y = $y2 - $y1 - 1;

    return ($x, $y, 'EMF');
}

1;
# end of Image::Size::emfsize
