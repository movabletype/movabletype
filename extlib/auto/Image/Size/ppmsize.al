# NOTE: Derived from Image/Size.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Image::Size;

#line 1072 "Image/Size.pm (autosplit into /Users/fyoshimatsu/Downloads/Image-Size-3.2/auto/Image/Size/ppmsize.al)"
# ppmsize: gets data on the PPM/PGM/PBM family.
#
# Contributed by Carsten Dominik <dominik@strw.LeidenUniv.nl>
sub ppmsize
{
    my $stream = shift;

    my ($x, $y, $id) = (undef, undef,
                        "Unable to determine size of PPM/PGM/PBM data");
    my $n;

    my $header = &$read_in($stream, 1024);

    # PPM file of some sort
    $header =~ s/^\#.*//mg;
    ($n, $x, $y) = ($header =~ /^(P[1-6])\s+(\d+)\s+(\d+)/s);
    $id = "PBM" if $n eq "P1" || $n eq "P4";
    $id = "PGM" if $n eq "P2" || $n eq "P5";
    $id = "PPM" if $n eq "P3" || $n eq "P6";
    if ($n eq 'P7')
    {
        # John Bradley's XV thumbnail pics (thanks to inwap@jomis.Tymnet.COM)
        $id = 'XV';
        ($x, $y) = ($header =~ /IMGINFO:(\d+)x(\d+)/s);
    }

    ($x, $y, $id);
}

# end of Image::Size::ppmsize
1;
