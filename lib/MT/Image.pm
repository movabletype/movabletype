# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Image;

use strict;
use MT;
use base qw( MT::ErrorHandler );

sub new {
    my $class = shift;
    $class .= "::" . MT->config->ImageDriver;
    my $image = bless {}, $class;
    $image->load_driver
        or return $class->error( $image->errstr );
    if (@_) {
        $image->init(@_)
            or return $class->error( $image->errstr );
    }
    $image;
}

sub get_dimensions {
    my $image = shift;
    my %param = @_;
    my($w, $h) = ($image->{width}, $image->{height});
    if (my $pct = $param{Scale}) {
        ($w, $h) = (int($w * $pct / 100), int($h * $pct / 100));
    } else {
        if ($param{Width} && $param{Height}) {
            ($w, $h) = ($param{Width}, $param{Height});
        } else {
            my $x = $param{Width} || $w;
            my $y = $param{Height} || $h;
            my $w_pct = $x / $w;
            my $h_pct = $y / $h;
            my $pct = $param{Width} ? $w_pct : $h_pct;
            ($w, $h) = (int($w * $pct), int($h * $pct));
        }
    }
    ($w, $h);
}

sub inscribe_square {
    my $class = shift;
    my %params = @_;
    my ($w, $h) = @params{qw( Width Height )};

    my ($dim, $x, $y);

    if ($w > $h) {
        $dim = $h;
        $x = int(($w - $dim) / 2);
        $y = 0;
    }
    else {
        $dim = $w;
        $x = 0;
        $y = int(($h - $dim) / 2);
    }

    return ( Size => $dim, X => $x, Y => $y ); 
}

sub make_square {
    my $image = shift;
    my %square = $image->inscribe_square(
        Width  => $image->{width},
        Height => $image->{height},
    );
    $image->crop(%square);
}

sub check_upload {
    my $class = shift;
    my %params = @_;

    my $fh = $params{Fh};

    ## Use Image::Size to check if the uploaded file is an image, and if so,
    ## record additional image info (width, height). We first rewind the
    ## filehandle $fh, then pass it in to imgsize.
    seek $fh, 0, 0;
    eval { require Image::Size; };
    return $class->error(
        MT->translate(
                "Perl module Image::Size is required to determine "
              . "width and height of uploaded images."
        )
    ) if $@;
    my ( $w, $h, $id ) = Image::Size::imgsize($fh);

    my $write_file = sub {
        $params{Fmgr}->put( $fh, $params{Local}, 'upload' );
    };

    ## Check file size?
    my $file_size;
    if ($params{Max}) {
        ## Seek to the end of the handle to find the size.
        seek $fh, 0, 2;  # wind to end
        $file_size = tell $fh;
        seek $fh, 0, 0;
    }

    ## If the image exceeds the dimension limit, resize it before writing.
    if (my $max_dim = $params{MaxDim}) {
        if (defined($w) && defined($h) && ($w > $max_dim || $h > $max_dim)) {
            my $uploaded_data = eval { local $/; <$fh> };
            my $img = $class->new( Data => $uploaded_data )
                or return $class->error($class->errstr);

            if ($params{Square}) {
                (undef, $w, $h) = $img->make_square()
                    or return $class->error($img->errstr);
            }
            (my($resized_data), $w, $h) = $img->scale(
                (($w > $h) ? 'Width' : 'Height') => $max_dim )
                    or return $class->error($img->errstr);

            $write_file = sub {
                $params{Fmgr}->put_data( $resized_data, $params{Local}, 'upload' )
            };
            $file_size = length $resized_data;
        }
    }

    if (my $max_size = $params{Max}) {
        if ($max_size < $file_size) {
            return $class->error(MT->translate( "File size exceeds maximum allowed: [_1] > [_2]",
                    $file_size, $max_size ) );
        }
    }

    ($w, $h, $id, $write_file);
}

package MT::Image::ImageMagick;
@MT::Image::ImageMagick::ISA = qw( MT::Image );

sub load_driver {
    my $image = shift;
    eval { require Image::Magick };
    if (my $err = $@) {
        return $image->error(MT->translate("Can't load Image::Magick: [_1]", $err));
    }
    1;
}

sub init {
    my $image = shift;
    my %param = @_;
    my %arg = ();
    if (my $type = $param{Type}) {
        %arg = (magick => lc($type));
    } elsif (my $file = $param{Filename}) {
        (my $ext = $file) =~ s/.*\.//;
        %arg = (magick => lc($ext));
    }
    my $magick = $image->{magick} = Image::Magick->new(%arg);
    if (my $file = $param{Filename}) {
        my $x = $magick->Read($file);
        return $image->error(MT->translate(
            "Reading file '[_1]' failed: [_2]", $file, $x)) if $x;
        ($image->{width}, $image->{height}) = $magick->Get('width', 'height');
    } elsif ($param{Data}) {
        my $x = $magick->BlobToImage($param{Data});
        return $image->error(MT->translate(
            "Reading image failed: [_1]", $x)) if $x;
        ($image->{width}, $image->{height}) = $magick->Get('width', 'height');
    }
    $image;
}

sub scale {
    my $image = shift;
    my($w, $h) = $image->get_dimensions(@_);
    my $magick = $image->{magick};
    my $err = $magick->can('Resize') ?
              $magick->Resize(width => $w, height => $h) :
              $magick->Scale(width => $w, height => $h);
    return $image->error(MT->translate(
        "Scaling to [_1]x[_2] failed: [_3]", $w, $h, $err)) if $err;
    $magick->Profile("*") if $magick->can('Profile');
    ($image->{width}, $image->{height}) = ($w, $h);
    wantarray ? ($magick->ImageToBlob, $w, $h) : $magick->ImageToBlob;
}

sub crop {
    my $image = shift;
    my %param = @_;
    my ($size, $x, $y) = @param{qw( Size X Y )};
    my $magick = $image->{magick};

    my $err = $magick->Crop(width => $size, height => $size, x => $x, y => $y);
    return $image->error(MT->translate(
        "Cropping a [_1]x[_1] square at [_2],[_3] failed: [_4]", $size, $x,
        $y, $err)) if $err;

    ## Remove page offsets from the original image, per this thread:
    ## http://studio.imagemagick.org/pipermail/magick-users/2003-September/010803.html
    $magick->Set( page => '+0+0' );

    ($image->{width}, $image->{height}) = ($size, $size);
    wantarray ? ($magick->ImageToBlob, $size, $size) : $magick->ImageToBlob;
}

sub convert {
    my $image = shift;
    my %param = @_;
    my $type = $param{Type};

    my $magick = $image->{magick};
    my $err = $magick->Set( magick => uc $type );
    return $image->error(MT->translate(
            "Converting image to [_1] failed: [_2]", $type, $err)) if $err;

    $magick->ImageToBlob;
}

package MT::Image::NetPBM;
@MT::Image::NetPBM::ISA = qw( MT::Image );

sub load_driver {
    my $image = shift;
    eval { require IPC::Run };
    if (my $err = $@) {
        return $image->error(MT->translate("Can't load IPC::Run: [_1]", $err));
    }
    my $pbm = $image->_find_pbm or return;
    1;
}

sub init {
    my $image = shift;
    my %param = @_;
    if (my $file = $param{Filename}) {
        $image->{file} = $file;
        if (!defined $param{Type}) {
            (my $ext = $file) =~ s/.*\.//;
            $param{Type} = uc $ext;
        }
    } elsif (my $blob = $param{Data}) {
        $image->{data} = $blob;
    }
    my %Types = (jpg => 'jpeg', jpeg => 'jpeg', gif => 'gif', 'png' => 'png');
    my $type = $image->{type} = $Types{ lc $param{Type} };
    if (!$type) {
        return $image->error(MT->translate("Unsupported image file type: [_1]", $type));
    }
    my($out, $err);
    my $pbm = $image->_find_pbm or return;
    my @in = ("$pbm${type}topnm", ($image->{file} ? $image->{file} : ()));
    my @out = ("${pbm}pnmfile", '-allimages');
    IPC::Run::run(\@in, '<', ($image->{file} ? \undef : \$image->{data}), '|',
        \@out, \$out, \$err)
        or return $image->error(MT->translate(
            "Reading image failed: [_1]", $err));
    ($image->{width}, $image->{height}) = $out =~ /(\d+)\s+by\s+(\d+)/;
    $image;
}

sub scale {
    my $image = shift;
    my($w, $h) = $image->get_dimensions(@_);
    my $type = $image->{type};
    my($out, $err);
    my $pbm = $image->_find_pbm or return;
    my @in = ("$pbm${type}topnm", ($image->{file} ? $image->{file} : ()));
    my @scale = ("${pbm}pnmscale", '-width', $w, '-height', $h);
    my @out;
    for my $try (qw( ppm pnm )) {
        my $prog = "${pbm}${try}to$type";
        @out = ($prog), last if -x $prog;
    }
    my(@quant);
    if ($type eq 'gif') {
        push @quant, ([ "${pbm}ppmquant", 256 ], '|');
    }
    IPC::Run::run(\@in, '<', ($image->{file} ? \undef : \$image->{data}), '|',
        \@scale, '|',
        @quant,
        \@out, \$out, \$err)
        or return $image->error(MT->translate(
            "Scaling to [_1]x[_2] failed: [_3]", $w, $h, $err));
    ($image->{width}, $image->{height}) = ($w, $h);
    wantarray ? ($out, $w, $h) : $out;
}

sub crop {
    my $image = shift;
    my %param = @_;
    my ($size, $x, $y) = @param{qw( Size X Y )};
    
    my($w, $h) = $image->get_dimensions(@_);
    my $type = $image->{type};
    my($out, $err);
    my $pbm = $image->_find_pbm or return;
    my @in = ("$pbm${type}topnm", ($image->{file} ? $image->{file} : ()));

    my @crop = ("${pbm}pnmcut", $x, $y, $size, $size);
    my @out;
    for my $try (qw( ppm pnm )) {
        my $prog = "${pbm}${try}to$type";
        @out = ($prog), last if -x $prog;
    }
    my(@quant);
    if ($type eq 'gif') {
        push @quant, ([ "${pbm}ppmquant", 256 ], '|');
    }
    IPC::Run::run(\@in, '<', ($image->{file} ? \undef : \$image->{data}), '|',
        \@crop, '|',
        @quant,
        \@out, \$out, \$err)
        or return $image->error(MT->translate(
            "Cropping to [_1]x[_1] failed: [_2]", $size, $err));
    ($image->{width}, $image->{height}) = ($w, $h);
    wantarray ? ($out, $w, $h) : $out;
}

sub convert {
    my $image = shift;
    my %param = @_;

    my $type = $image->{type};
    my $outtype = lc $param{Type};

    my($out, $err);
    my $pbm = $image->_find_pbm or return;
    my @in = ("$pbm${type}topnm", ($image->{file} ? $image->{file} : ()));

    my @out;
    for my $try (qw( ppm pnm )) {
        my $prog = "${pbm}${try}to$outtype";
        @out = ($prog), last if -x $prog;
    }
    my(@quant);
    if ($type eq 'gif') {
        push @quant, ([ "${pbm}ppmquant", 256 ], '|');
    }
    IPC::Run::run(\@in, '<', ($image->{file} ? \undef : \$image->{data}), '|',
        @quant,
        \@out, \$out, \$err)
        or return $image->error(MT->translate(
            "Converting to [_1] failed: [_2]", $type, $err));
    $out;
}

sub _find_pbm {
    my $image = shift;
    return $image->{__pbm_path} if $image->{__pbm_path};
    my @NetPBM = qw( /usr/local/netpbm/bin /usr/local/bin /usr/bin );
    my $pbm;
    for my $path (MT->config->NetPBMPath, @NetPBM) {
        next unless $path;
        $path .= '/' unless $path =~ m!/$!;
        $pbm = $path, last if -x "${path}pnmscale";
    }
    return $image->error(MT->translate(
        "You do not have a valid path to the NetPBM tools on your machine."))
        unless $pbm;
    $image->{__pbm_path} = $pbm;
}

package MT::Image::GD;
@MT::Image::GD::ISA = qw( MT::Image );

sub load_driver {
    my $image = shift;
    eval { require GD };
    if (my $err = $@) {
        return $image->error(MT->translate("Can't load GD: [_1]", $err));
    }
    1;
}

sub init {
    my $image = shift;
    my %param = @_;

    if ((!defined $param{Type}) && (my $file = $param{Filename})) {
    (my $ext = $file) =~ s/.*\.//;
    $param{Type} = lc $ext;
    }
    my %Types = (jpg => 'jpeg', jpeg => 'jpeg', gif => 'gif', 'png' => 'png');
    $image->{type} = $Types{ lc $param{Type} }
        or return $image->error(MT->translate("Unsupported image file type: [_1]", $param{Type}));

    if (my $file = $param{Filename}) {
    $image->{gd} = GD::Image->new($file)
        or return $image->error(MT->translate("Reading file '[_1]' failed: [_2]", $file, $@));
    } elsif (my $blob = $param{Data}) {
    $image->{gd} = GD::Image->new($blob)
        or return $image->error(MT->translate("Reading image failed: [_2]", $@));
    }
    ($image->{width}, $image->{height}) = $image->{gd}->getBounds();
    $image;
}

sub blob {
    my $image = shift;
    my $type = $image->{type};
    $image->{gd}->$type;
}

sub scale {
    my $image = shift;
    my($w, $h) = $image->get_dimensions(@_);
    my $src = $image->{gd};
    my $gd = GD::Image->new($w, $h);
    $gd->copyResampled($src, 0, 0, 0, 0, $w, $h, $image->{width}, $image->{height});
    ($image->{gd}, $image->{width}, $image->{height}) = ($gd, $w, $h);
    wantarray ? ($image->blob, $w, $h) : $image->blob;
}

sub crop {
    my $image = shift;
    my %param = @_;
    my ($size, $x, $y) = @param{qw( Size X Y )};
    my $src = $image->{gd};
    my $gd = GD::Image->new($size, $size);
    $gd->copy($src, 0, 0, $x, $y, $size, $size);
    ($image->{gd}, $image->{width}, $image->{height}) = ($gd, $size, $size);
    wantarray ? ($image->blob, $size, $size) : $image->blob;
}

sub convert {
    my $image = shift;
    my %param = @_;
    $image->{type} = lc $param{Type};
    $image->blob;
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

=head2 MT::Image->new(%arg)

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

=head2 $img->scale(%arg)

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

=head2 $img->get_dimensions(%arg)

This utility method returns a width and height value pair after applying
the given arguments. Valid arguments are the same as the L<scale> method.
If 'Width' is given, a proportionate height will be calculated. If a
'Height' is given, the width will be calculated. If 'Scale' is given
the height and width will be calculated based on that scale (a value
between 1 to 100).

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
