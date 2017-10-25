package Image::Info::BMP;
$VERSION = '1.04';
use strict;

use constant _CAN_LITTLE_ENDIAN_PACK => $] >= 5.009002;

sub process_file {
    my($info, $source, $opts) = @_;
    my(@comments, @warnings, @header, %info, $buf, $total);

    read($source, $buf, 54) == 54 or die "Can't reread BMP header: $!";
    @header = unpack((_CAN_LITTLE_ENDIAN_PACK
		      ? "vVv2V2Vl<v2V2V2V2"
		      : "vVv2V2V2v2V2V2V2"
		     ), $buf);
    $total += length($buf);

    if( $header[9] && $header[9] < 24 ){
	$info->push_info(0, "color_type" => "Indexed-RGB");
    }
    else{
	$info->push_info(0, "color_type" => "RGB");
    }
    $info->push_info(0, "file_media_type" => "image/bmp");
    if( $header[10] == 1 || $header[10] == 2){
	$info->push_info(0, "file_ext" => "rle");
    }
    else{
	$info->push_info(0, "file_ext" => "bmp"); # || dib
    }

    $info->push_info(0, "height", (_CAN_LITTLE_ENDIAN_PACK
				   ? abs($header[7])
				   : ($header[7] >= 2**31 ? 2**32 - $header[7] : $header[7])
				  ));
    $info->push_info(0, "resolution", "$header[12]/$header[13]");
    $info->push_info(0, "width", $header[6]);
    $info->push_info(0, "BitsPerSample" => $header[9]);
    $info->push_info(0, "SamplesPerPixel", $header[8]);

    $info->push_info(0, "BMP_ColorsImportant", $header[15]);
    $info->push_info(0, "BMP_Origin",
		     $header[7]>1 ? 1 : 0 );
    $info->push_info(0, "ColorTableSize", $header[14]);
    $info->push_info(0, "Compression", [
					'none',
					'RLE8',
					'RLE4',
					'BITFIELDS',	#V4
					'JPEG',		#V5
					'PNG',		#V5
					]->[$header[10]]);
    #Version 5 Header amendments
    # XXX Discard for now, need a test image
    if( $header[5] > 40 ){
	read($source, $buf, $header[5]-40);  # XXX test
	$total += length($buf);
	my @v5 = unpack("V38", $buf);
	splice(@v5, 5, 27);
	$info->push_info(0, "BMP_MaskRed", $v5[0]);
	$info->push_info(0, "BMP_MaskGreen", $v5[1]);
	$info->push_info(0, "BMP_MaskBlue", $v5[2]);
	$info->push_info(0, "BMP_MaskAlpha", $v5[3]);
#	$info->push_info(0, "BMP_color_type", $v5[4]);
	$info->push_info(0, "BMP_GammaRed", $v5[5]);
	$info->push_info(0, "BMP_GammaGreen", $v5[6]);
	$info->push_info(0, "BMP_GammaBlue", $v5[7]);
    }
    if( $header[9] < 24 && $opts->{ColorPalette} ){
	my(@color, @palette);
	for(my $i=0; $i<$header[14]; $i++){
	    read($source, $buf, 4) == 4 or die "Can't read: $!";
	    $total += length($buf);
	    @color = unpack("C3", $buf);
	    # Damn M$, BGR instead of RGB
	    push @palette, sprintf("#%02x%02x%02x",
				   $color[2], $color[1], $color[0]);
	}
	$info->push_info(0, "ColorPalette", @palette);
    }

    #Verify size # XXX Cheat and do -s if it's an actual file?
    while( read($source, $buf, 1024) ){
	$total += length($buf);
    }
    if( $header[1] != $total ){
	push @warnings, "Size mismatch."
    }

    for (@comments) {
	$info->push_info(0, "Comment", $_);
    }

    for (@warnings) {
	$info->push_info(0, "Warn", $_);
    }
}
1;
__END__

=pod

=head1 NAME

Image::Info::BMP - Windows Device Independent Bitmap support for Image::Info

=head1 SYNOPSIS

 use Image::Info qw(image_info dim);

 my $info = image_info("image.bmp");
 if (my $error = $info->{error}) {
     die "Can't parse image info: $error\n";
 }
 my $color = $info->{color_type};

 my($w, $h) = dim($info);

=head1 DESCRIPTION

This module supplies the standard key names
except for Gamma, Interlace, LastModificationTime, as well as:

=over

=item BMP_ColorsImportant

Specifies the number of color indexes that are required for
displaying the bitmap. If this value is zero, all colors are required. 

=item BMP_Origin

If true the bitmap is a bottom-up DIB and its origin is the lower-left corner.
Otherwise, the bitmap is a top-down DIB and its origin is the upper-left 
corner. 

=item ColorPalette

Reference to an array of all colors used.
This key is only present if C<image_info> is invoked
as C<image_info($file, ColorPalette=E<gt>1)>.

=item ColorTableSize

The number of colors the image uses.
If 0 then this is a true color image.
The number of colors I<available> is 2 ^ B<BitsPerSample>.

=back

=head1 METHODS

=head2 process_file()
    
	$info->process_file($source, $options);

Processes one file and sets the found info fields in the C<$info> object.

=head1 SEE ALSO

L<Image::Info>

=head1 NOTES

For more information about BMP see L<http://msdn.microsoft.com>.

Random notes:

  warn if height is negative and compress is not RGB or BITFILEDS (0 or 3)
  ICO and CUR support?
  ### v5
  If bit depth is 0, it relies upon underlying JPG/PNG :-(
  Extra Information
    DWORD        bV5RedMask; 
    DWORD        bV5GreenMask; 
    DWORD        bV5BlueMask; 
    DWORD        bV5AlphaMask; 
    DWORD        bV5CSType; 
    CIEXYZTRIPLE bV5EndPoints; #3*CIEXYZ #CIEXYZ = 3*FXPT2DOT30#FXPT2DOT30 = long
    DWORD        bV5GammaRed; 
    DWORD        bV5GammaGreen; 
    DWORD        bV5GammaBlue; 
    DWORD        bV5Intent; 
    DWORD        bV5ProfileData; 
    DWORD        bV5ProfileSize; 

=head1 DIAGNOSTICS

=over

=item Size mismatch

The image may be correct, but the filesize does not match the internally stored
value.

=back

=head1 BUGS

The current implementation only functions on little-endian architectures.
Consequently erroneous data concerning compression (including
B<file_ext> and B<file_mime_type>) may be reported.

=head1 AUTHOR

Jerrad Pierce <belg4mit@mit.edu>/<webmaster@pthbb.org>

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=begin register

MAGIC: /^BM/

This module supports the Microsoft Device Independent Bitmap format
(BMP, DIB, RLE).

For more information see L<Image::Info::BMP>.

=end register

=cut
