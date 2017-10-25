package Image::Info::XPM;
$VERSION = '1.09';
use strict;
use Image::Xpm 1.09;


sub process_file{
    my($info, $source, $opts) = @_;

    local $SIG{__WARN__} = sub {
	$info->push_info(0, "Warn", shift);
    };

    my $i = Image::Xpm->new(-width => 0, -height => 0);
    # loading the file as a separate step avoids a "-r" test, this would
    # file with in-memory strings (aka fake files)
    $i->load($source);

    $info->push_info(0, "color_type" => "Indexed-RGB");
    $info->push_info(0, "file_ext" => "xpm");
    $info->push_info(0, "file_media_type" => "image/x-xpixmap");
    $info->push_info(0, "height", $i->get(-height));
    $info->push_info(0, "resolution", "1/1");
    $info->push_info(0, "width", $i->get(-width));
    $info->push_info(0, "BitsPerSample" => 8);
    $info->push_info(0, "SamplesPerPixel", 1);

    $info->push_info(0, "XPM_CharactersPerPixel" => $i->get(-cpp) );
    # XXX is this always?
    $info->push_info(0, "ColorResolution", 8);
    $info->push_info(0, "ColorTableSize" => $i->get(-ncolours) );
    if( $opts->{ColorPalette} ){
	$info->push_info(0, "ColorPalette" => [keys %{$i->get(-cindex)}] );
    }
    if( $opts->{L1D_Histogram} ){
	#Do Histograms
	my(%RGB, @l1dhist, $R, $G, $B, $color);
	for(my $y=0; $y<$i->get(-height); $y++){
	    for(my $x=0; $x<$i->get(-width); $x++){
		$color = $i->xy($x, $y);
		if( $color =~ /^(none|opaque)$/i ) {
		    next;
		} elsif( $color !~ /^#/ ){
		    unless( exists($RGB{white}) ){
			local $_;
			if( open(RGB, _get_rgb_txt()) ){
			    while(<RGB>){
				next if /^\s*!/;
				/(\d+)\s+(\d+)\s+(\d+)\s+(.*)/;
				$RGB{$4}=[$1,$2,$3];
			    }
			}
			else{
			    $RGB{white} = "0 but true";
			    $info->push_info(0, "Warn", "Unable to open RGB database, you may need to set \$Image::Info::XPM::RGBLIB");
			}
		    }
		    $R = $RGB{$color}->[0];
		    $G = $RGB{$color}->[1];
		    $B = $RGB{$color}->[2];
		}
		elsif (length $color == 7) {
		    $R = hex(substr($color,1,2));
		    $G = hex(substr($color,3,2));
		    $B = hex(substr($color,5,2));
		}
		elsif (length $color == 13) {
		    $R = hex(substr($color,1,2));
		    $G = hex(substr($color,5,2));
		    $B = hex(substr($color,9,2));
		}
		elsif (length $color == 4) {
		    $R = hex(substr($color,1,1))*16;
		    $G = hex(substr($color,2,1))*16;
		    $B = hex(substr($color,3,1))*16;
		}
		else {
		    warn "Unexpected length in color specification '$color'";
		}
		if( $opts->{L1D_Histogram} ){
		    $l1dhist[(.3*$R + .59*$G + .11*$B)]++;
		}
	    }
	}
	if( $opts->{L1D_Histogram} ){
	    $info->push_info(0, "L1D_Histogram", [@l1dhist]);
	}
    }
    $info->push_info(0, "HotSpotX" => $i->get(-hotx) );
    $info->push_info(0, "HotSpotY" => $i->get(-hoty) );
    $info->push_info(0, 'XPM_Extension-'.ucfirst($i->get(-extname)) => $i->get(-extlines)) if
	$i->get(-extname);

    for (@{$i->get(-comments)}) {
	$info->push_info(0, "Comment", $_);
    }
}

sub _get_rgb_txt{
    return $Image::Info::XPM::RGBLIB if defined $Image::Info::XPM::RGBLIB;
    # list taken from Tk::ColorEditor
    for my $try(
	'/usr/local/lib/X11/rgb.txt',
	'/usr/lib/X11/rgb.txt',
	'/usr/X11R6/lib/X11/rgb.txt',
	'/usr/local/X11R5/lib/X11/rgb.txt',
	'/X11/R5/lib/X11/rgb.txt',
	'/X11/R4/lib/rgb/rgb.txt',
	'/usr/openwin/lib/X11/rgb.txt',
	'/usr/share/X11/rgb.txt', # This is the Debian and RH5 location
	'/usr/X11/share/X11/rgb.txt', # seen on a Mac OS X 10.5.1 system
	'/usr/X11R6/share/X11/rgb.txt', # seen on a OpenBSD 4.2 system
	'/etc/X11R6/rgb.txt',
	'/etc/X11/rgb.txt', # seen on HP-UX 11.31
    ){
	if( -r $try ){
	    $Image::Info::XPM::RGBLIB = $try;
	    return $try;
	}
    }
    undef;
}

1;
__END__

=head1 NAME

Image::Info::XPM - XPM support for Image::Info

=head1 SYNOPSIS

 use Image::Info qw(image_info dim);

 my $info = image_info("image.xpm");
 if (my $error = $info->{error}) {
     die "Can't parse image info: $error\n";
 }
 my $color = $info->{color_type};

 my($w, $h) = dim($info);

=head1 DESCRIPTION

This modules supplies the standard key names
except for Compression, Gamma, Interlace, LastModificationTime, as well as:

=over

=item ColorPalette

Reference to an array of all colors used.
This key is only present if C<image_info> is invoked
as C<image_info($file, ColorPaletteE<gt>=1)>.

=item ColorTableSize

The number of colors the image uses.

=item HotSpotX

The x-coord of the image's hotspot.
Set to -1 if there is no hotspot.

=item HotSpotY

The y-coord of the image's hotspot.
Set to -1 if there is no hotspot.

=item L1D_Histogram

Reference to an array representing a one dimensional luminance
histogram. This key is only present if C<image_info> is invoked
as C<image_info($file, L1D_Histogram=E<gt>1)>. The range is from 0 to 255,
however auto-vivification is used so a null field is also 0,
and the array may not actually contain 255 fields.

=item XPM_CharactersPerPixel

This is typically 1 or 2. See L<Image::Xpm>.

=item XPM_Extension-.*

XPM Extensions (the most common is XPMEXT) if present.

=back

=head1 METHODS

=head2 process_file()
    
	$info->process_file($source, $options);

Processes one file and sets the found info fields in the C<$info> object.

=head1 FILES

This module requires L<Image::Xpm>

I<$Image::Info::XPM::RGBLIB> is set to F</usr/X11R6/lib/X11/rgb.txt>
or an equivalent path (see the C<_get_rgb_txt> function for the
complete list) by default, this is used to resolve textual color names
to their RGB counterparts.

=head1 SEE ALSO

L<Image::Info>, L<Image::Xpm>

=head1 NOTES

For more information about XPM see
L<ftp://ftp.x.org/contrib/libraries/xpm-README.html>

=head1 CAVEATS

While the module attempts to be as robust as possible, it may not recognize
older XPMs (Versions 1-3), if this is the case try inserting S</* XPM */>
as the first line.

=head1 AUTHOR

Jerrad Pierce <belg4mit@mit.edu>/<webmaster@pthbb.org>

Tels - (c) 2006.

Now maintained by Slaven Rezic <srezic@cpan.org>.

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

=begin register

MAGIC: /(^\/\* XPM \*\/)|(static\s+char\s+\*\w+\[\]\s*=\s*{\s*"\d+)/

See L<Image::Info::XPM> for details.

=end register

=cut
