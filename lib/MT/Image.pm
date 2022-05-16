# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Image;

use strict;
use warnings;
use MT;
use base qw( Class::Accessor::Fast MT::ErrorHandler );

__PACKAGE__->mk_accessors(qw( jpeg_quality png_quality ));

sub new {
    my $class = shift;
    $class .= "::" . MT->config->ImageDriver;
    eval "require $class"
        or return __PACKAGE__->error(
        MT->translate( "Invalid Image Driver [_1]", $class ) );
    my $image = bless {}, $class;
    $image->load_driver
        or return $class->error( $image->errstr );
    if (@_) {
        $image->init(@_)
            or return $class->error( $image->errstr );
    }
    $image;
}

sub init {
    my ( $image, %param ) = @_;

    $image->{param} = \%param;

    my $jpeg_quality
        = exists $param{JpegQuality}
        ? $param{JpegQuality}
        : MT->config->ImageQualityJpeg;
    my $png_quality
        = exists $param{PngQuality}
        ? $param{PngQuality}
        : MT->config->ImageQualityPng;

    $image->jpeg_quality($jpeg_quality);
    $image->png_quality($png_quality);

    $image;
}

sub get_dimensions {
    my $image = shift;
    my %param = @_;
    my ($w, $h);
    if ( my $pct = $param{Scale} ) {
        $image->_init_image_size;
        ( $w, $h ) = ( int( $image->{width} * $pct / 100 ), int( $image->{height} * $pct / 100 ) );
        $w = 1 if $w < 1;
        $h = 1 if $h < 1;
    }
    else {
        if ( $param{Width} && $param{Height} ) {
            ( $w, $h ) = ( $param{Width}, $param{Height} );
        }
        else {
            $image->_init_image_size;
            ($w, $h) = ($image->{width}, $image->{height});
            my $x = $param{Width}  || $w;
            my $y = $param{Height} || $h;
            my $w_pct = $x / $w;
            my $h_pct = $y / $h;
            my $pct   = $param{Width} ? $w_pct : $h_pct;
            ( $w, $h ) = ( int( $w * $pct ), int( $h * $pct ) );
        }
    }
    ( $w, $h );
}

sub get_degrees {
    my $image = shift;
    my %param = @_;
    $image->_init_image_size;
    my ( $w, $h ) = ( $image->{width}, $image->{height} );
    my $degrees = $param{Degrees};

    if ( int( $degrees / 90 ) % 2 == 1 ) {
        ( $w, $h ) = ( $h, $w );
    }

    ( $degrees, $w, $h );
}

sub inscribe_square {
    my $class  = shift;
    my %params = @_;
    my ( $w, $h ) = @params{qw( Width Height )};

    my ( $dim, $x, $y );

    if ( $w > $h ) {
        $dim = $h;
        $x   = int( ( $w - $dim ) / 2 );
        $y   = 0;
    }
    else {
        $dim = $w;
        $x   = 0;
        $y   = int( ( $h - $dim ) / 2 );
    }

    return ( Size => $dim, X => $x, Y => $y );
}

sub make_square {
    my $image  = shift;
    $image->_init_image_size;
    my %square = $image->inscribe_square(
        Width  => $image->{width},
        Height => $image->{height},
    );
    $image->crop(%square);
}

sub is_valid_image {
    my ($fh) = @_;
    return unless $fh;

    ## Read first 1k of image file
    my $data = '';
    binmode($fh);
    seek( $fh, 0, 0 );
    read $fh, $data, 1024;
    seek( $fh, 0, 0 );

    return 0
        if ( $data =~ m/^\s*<[!?]/ )
        || ( $data
        =~ m/<(HTML|SCRIPT|TITLE|BODY|HEAD|PLAINTEXT|TABLE|IMG |PRE|A )/i )
        || ( $data =~ m/text\/html/i )
        || (
        $data =~ m/^\s*<(FRAMESET|IFRAME|LINK|BASE|STYLE|DIV|FONT|APPLET)/i )
        || (
        $data =~ m/^\s*<(APPLET|META|CENTER|FORM|ISINDEX|H[123456]|BR)/i );

    return 1;
}

sub get_image_info {
    my $class  = shift;
    my %params = @_;

    require Image::ExifTool;
    my $info;
    if ( my $fh = $params{Fh} ) {
        seek $fh, 0, 0;
        require File::RandomAccess;
        $info = Image::ExifTool::ImageInfo(File::RandomAccess->new($fh));
        seek $fh, 0, 0;
    }
    elsif ( my $filename = $params{Filename} ) {
        $info = Image::ExifTool::ImageInfo($filename);
    }
    return unless $info;
    return int($info->{ImageWidth} || 0), int($info->{ImageHeight} || 0), $info->{FileTypeExtension};
}

sub get_image_type {
    my $class = shift;
    my @image_size = $class->get_image_info( Fh => @_ );

    ( $image_size[0] && $image_size[1] && $image_size[2] )
        ? lc $image_size[2]
        : ();
}

sub check_upload {
    my $class  = shift;
    my %params = @_;

    my $fh = $params{Fh};

    my ( $w, $h, $id ) = $class->get_image_info(@_);

    my $write_file = sub {
        $params{Fmgr}->put( $fh, $params{Local}, 'upload' );
    };

    ## Check file size?
    my $file_size;
    if ( $params{Max} ) {
        ## Seek to the end of the handle to find the size.
        seek $fh, 0, 2;    # wind to end
        $file_size = tell $fh;
        seek $fh, 0, 0;
    }

    ## Check file content
    my $filepath = $params{Local};
    my ( $filename, $path, $ext )
        = ( File::Basename::fileparse( $filepath, qr/[A-Za-z0-9]+$/ ) );

    # Check for Content Sniffing bug (IE)
    require MT::Asset::Image;
    if ( MT::Asset::Image->can_handle($ext) ) {
        return $class->error(
            MT->translate(
                "Saving [_1] failed: Invalid image file format.",
                $filename . $ext
            )
        ) unless is_valid_image( $params{Fh} );
    }

    ## If the image exceeds the dimension limit, resize it before writing.
    if ( my $max_dim = $params{MaxDim} ) {
        if (   defined($w)
            && defined($h)
            && ( $w > $max_dim || $h > $max_dim ) )
        {
            my $uploaded_data = eval { local $/; <$fh> };
            my $img = $class->new( Data => $uploaded_data )
                or return $class->error( $class->errstr );

            if ( $params{Square} ) {
                ( undef, $w, $h ) = $img->make_square()
                    or return $class->error( $img->errstr );
            }
            ( my ($resized_data), $w, $h )
                = $img->scale(
                ( ( $w > $h ) ? 'Width' : 'Height' ) => $max_dim )
                or return $class->error( $img->errstr );

            $write_file = sub {
                $params{Fmgr}
                    ->put_data( $resized_data, $params{Local}, 'upload' );
            };
            $file_size = length $resized_data;
        }
    }

    if ( my $max_size = $params{Max} ) {
        if ( $max_size < $file_size ) {
            return $class->error(
                MT->translate(
                    "File size exceeds maximum allowed: [_1] > [_2]",
                    $file_size, $max_size
                )
            );
        }
    }

    ( $w, $h, $id, $write_file );
}

sub crop {
    my $image = shift;
    my %param = @_;
    $param{Width} = $param{Height} = $param{Size};
    $image->crop_rectangle(%param);
}

sub remove_metadata {
    my ( $class, $file ) = @_;

    return 1 if lc($file) !~ /\.(jpe?g|tiff?)$/;

    require Image::ExifTool;
    my $exif = Image::ExifTool->new;
    $exif->ExtractInfo($file);
    if ($exif->GetValue('Error')) {
        return 1;
    }

    $exif = Image::ExifTool->new;
    $exif->ExtractInfo($file);

    my $orientation = $exif->GetValue('Orientation');

    $exif->SetNewValue('*');
    if (lc($file) =~ /\.jpe?g$/) {
        $exif->SetNewValue( 'JFIF:*', undef, Replace => 2 );
        $exif->SetNewValue( 'ICC_Profile:*', undef, Replace => 2 );
        $exif->SetNewValue( 'EXIF:Orientation', $orientation ) if $orientation;
    }
    $exif->WriteInfo($file)
        or $class->trans_error( 'Writing metadata failed: [_1]',
        $exif->GetValue('Error') );
}

1;

__END__

=head1 NAME

MT::Image - Movable Type image manipulation routines

=head1 SYNOPSIS

    use MT::Image;
    my $img = MT::Image->new( Filename => '/path/to/image.jpg' );
    my($blob, $w, $h) = $img->scale( Width => 100 );

    open FH, ">thumb.jpg" or die $!;
    binmode FH;
    print FH $blob;
    close FH;

=head1 DESCRIPTION

I<MT::Image> contains image manipulation routines using either the
I<NetPBM> tools, the I<ImageMagick> and I<Image::Magick> Perl module,
or the I<GD> and I<GD> Perl module.
The backend framework used (NetPBM, ImageMagick, GD) depends on the value of
the I<ImageDriver> setting in the F<mt.cfg> file (or, correspondingly, set
on an instance of the I<MT::ConfigMgr> class).

Currently all this is used for is to create thumbnails from uploaded images.

=head1 USAGE

=head2 MT::Image->new( %arg )

Constructs a new I<MT::Image> object. Returns the new object on success; on
error, returns C<undef>, and the error message is in C<MT::Image-E<gt>errstr>.

I<%arg> can contain:

=over 4

=item * Filename

The path to an image to load.

=item * Data

The actual contents of an image, already loaded from a file, a database,
etc.

=item * Type

The image format of the data in I<Data>. This should be either I<JPG> or
I<GIF>.

=back

=head2 $img->init( %arg )

Set $img->jpeg_quality and $img->png_quality parameter from $arg{JpegQuality}
and $arg{PngQuality}. When $arg{JpegQuality}/$arg{PngQuality} is not set,
MT->config->ImageJpegQuality/MT->config->ImagePngQuality is used.

=head2 $img->scale( %arg )

Creates a thumbnail from the image represented by I<$img>; on success, returns
a list containing the binary contents of the thumbnail image, the width of the
scaled image, and the height of the scaled image. On error, returns C<undef>,
and the error message is in C<$img-E<gt>errstr>.

I<%arg> can contain:

=over 4

=item * Width

=item * Height

The width and height of the final image, respectively. If you provide only one
of these arguments, the other dimension will be scaled appropriately. If you
provide neither, the image will be scaled to C<100%> of the original (that is,
the same size). If you provide both, the image will likely look rather
distorted.

=item * Scale

To be used instead of I<Width> and I<Height>; the value should be a percentage
(ie C<100> to return the original image without resizing) by which both the
width and height will be scaled equally.

=back

=head2 MT::Image->inscribe_square( %arg )

Calculates a square of dimensions that are capable of holding an image
of the height and width indicated. This method receives I<%arg>, which
may contain:

=over 4

=item * Height

=item * Width

=back

The square will be the smaller value of the Height and Width parameter.

The method returns a hash containing the following information:

=over 4

=item * Size

The size of the calculated square, in pixels.

=item * X

The horizontal space to crop from the image, in pixels.

=item * Y

The vertical space to crop from the image, in pixels.

=back

This information is suited for the L<crop> method.

=head2 $img->make_square()

Takes an image which may or may not be a square in dimension and forces
it into a square shape (trimming the longer side, as necesary).

=head2 $img->get_dimensions(%arg)

This utility method returns a width and height value pair after applying
the given arguments. Valid arguments are the same as the L<scale> method.
If 'Width' is given, a proportionate height will be calculated. If a
'Height' is given, the width will be calculated. If 'Scale' is given
the height and width will be calculated based on that scale (a value
between 1 to 100).

=head2 $img->get_degrees(%arg)

This utility method returns a degrees and width and height values after
applying the given arguments.

I<%arg> can contain:

=over 4

=item * Degrees

The degrees of the final rotated image.

=back

=head2 MT::Image->check_upload( %arg )

Utility method used to handle image upload and storage, along with some
constraining factors. The I<%arg> hash may contain the following elements:

=over 4

=item * Fh

A filehandle for the uploaded file.

=item * Fmgr

A handle to a L<MT::FileMgr> object that will be used for writing the
file into place.

=item * Local

A path and filename for the location to write the uploaded file.

=item * Max (optional)

A number that specifies the maximum physical file size for the uploaded
image (specified in bytes).

=item * MaxDim (optional)

A number that specifies the maximum dimension allowed for the uploaded
image (specified in pixels).

=back

If the uploaded image is valid and passes the file size and image
dimension requirements (assuming those parameters are given),
the return value is a list consisting of the following elements:

=over 4

=item * $width

The width of the uploaded image, in pixels.

=item * $height

The height of the uploaded image, in pixels.

=item * $id

A string identifying the type of image file (returned by L<Image::Size>,
so typically "GIF", "JPG", "PNG").

=item * $write_coderef

A Perl coderef that, when invoked writes the image to the specified
location.

=back

If any error occurs from this routine, it will return 'undef', and
assign the error message, accessible using the L<errstr> class method.

=head2 MT::Image->remove_metadata($file)

Remove metadata (e.g. Exif) from $file. 

If any error occurs from this routine, it will return 'undef', and
assign the error message, accessible using the L<errstr> class method.

Do nothing when $file's metadata is broken.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
