# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.

package MT::Image::SVG;
use strict;
use warnings;
use Carp;
use base qw( MT::Image );
use XML::SAX::SVGTransformer;
use XML::SAX::ParserFactory;
use XML::SAX::Writer;

my $HasLibXML;
my $HasExpat;
my $HasCompressZlib;

sub load_driver {
    return 1;    # everything is bundled
}

# Always use an XS parser if available; PP is too slow for large images
sub _check_xs_parser {
    if (!defined $HasLibXML) {
        $HasLibXML = eval { require XML::LibXML::SAX; 1 } ? 1 : 0;
    }
    if ($HasLibXML) {
        return $XML::SAX::ParserPackage = 'XML::LibXML::SAX';
    }
    if (!defined $HasExpat) {
        $HasExpat = eval { require XML::SAX::Expat; 1 } ? 1 : 0;
    }
    if ($HasExpat) {
        return $XML::SAX::ParserPackage = 'XML::SAX::Expat';
    }
}

# Just in case as Compress::Zlib is a core module since 5.9.3
sub _check_compress_zlib {
    if (!defined $HasCompressZlib) {
        $HasCompressZlib = eval { require Compress::Zlib; 1 } ? 1 : 0;
    }
    $HasCompressZlib;
}

sub _transform {
    my ($self, $blob, %args) = @_;
    my $gzipped     = is_gzipped($blob);
    my $output      = '';
    my $writer      = XML::SAX::Writer->new(Output => \$output);
    my $transformer = XML::SAX::SVGTransformer->new(%args, Handler => $writer);
    my $parser      = XML::SAX::ParserFactory->parser(Handler => $transformer);
    $blob = gunzip($blob) if $gzipped;
    $parser->parse_string($blob);
    my $info = $transformer->info;
    @$self{qw/width height/} = @$info{qw/width height/};
    $output = gzip($output) if $gzipped;
    $output;
}

sub _init_image_size {
    my $self = shift;
    return ($self->{width}, $self->{height}) if defined $self->{width} && defined $self->{height};
    _check_xs_parser();
    my $transformer = XML::SAX::SVGTransformer->new;
    my $parser      = XML::SAX::ParserFactory->parser(Handler => $transformer);
    if (my $data = $self->{param}{Data}) {
        $data = gunzip($data) if is_gzipped($data);
        $parser->parse_string($data);
    } elsif ($self->{param}{Filename}) {
        $parser->parse_uri($self->{param}{Filename});
    } elsif (my $fh = $self->{param}{Fh}) {
        $parser->parse_file($fh);
    }
    my $info = $transformer->info;
    @$self{qw/width height/} = @$info{qw/width height/};
}

sub is_gzipped {
    my $data = shift;
    $data =~ /^\x1f\x8b\x08/;
}

sub gzip {
    my $data = shift;
    return $data unless _check_compress_zlib();
    require Compress::Zlib;
    Compress::Zlib::memGzip($data);
}

sub gunzip {
    my $data = shift;
    return $data unless _check_compress_zlib();
    require Compress::Zlib;
    Compress::Zlib::memGunzip($data);
}

sub get_size {
    my ($self, $file, $type) = @_;
    _check_xs_parser();
    my $transformer = XML::SAX::SVGTransformer->new;
    my $parser      = XML::SAX::ParserFactory->parser(Handler => $transformer);
    my $ext         = 'svg';
    if ($type =~ /gzip/i && _check_compress_zlib()) {
        require IO::Uncompress::Gunzip;
        $parser->parse_file(IO::Uncompress::Gunzip->new($file));
        $ext = 'svgz';
    } elsif (ref $file) {
        $parser->parse_file($file);
    } else {
        $parser->parse_uri($file);
    }
    my $info = $transformer->info;
    return { ImageWidth => $info->{width}, ImageHeight => $info->{height}, FileTypeExtension => $ext };
}

sub scale {
    my $self = shift;
    my ($w, $h) = $self->get_dimensions(@_);
    my $blob = $self->blob;
    $blob = $self->_transform($blob, Width => $w, Height => $h, KeepAspectRatio => 1);
    wantarray ? ($blob, @$self{qw(width height)}) : $blob;
}

sub crop_rectangle {
    my $self = shift;
    my $blob = $self->blob;
    # Cropping SVG is not supported yet
    wantarray ? ($blob, @$self{qw(width height)}) : $blob;
}

sub flipHorizontal {
    my $self = shift;
    my $blob = $self->blob;
    $blob = $self->_transform($blob, Transform => "flipx");
    wantarray ? ($blob, @$self{qw(width height)}) : $blob;
}

sub flipVertical {
    my $self = shift;
    my $blob = $self->blob;
    $blob = $self->_transform($blob, Transform => "flipy");
    wantarray ? ($blob, @$self{qw(width height)}) : $blob;
}

sub rotate {
    my $self = shift;
    my ($degrees, $w, $h) = $self->get_degrees(@_);
    my $blob = $self->blob;
    $blob = $self->_transform($blob, Transform => "rotate($degrees)");
    wantarray ? ($blob, @$self{qw(width height)}) : $blob;
}

sub convert {
    my $self = shift;
    my $blob = $self->blob;
    Carp::carp "Converting SVG is not supported";
    wantarray ? ($blob, @$self{qw(width height)}) : $blob;
}

sub blob {
    my $self = shift;
    my $fmgr = MT::FileMgr->new('Local');
    if ($self->{param}{Data}) {
        return $self->{param}{Data};
    }
    my $path = $self->{param}{Filename} or return;
    my $blob = $fmgr->get_data($path, 'upload');
    $blob;
}

1;
