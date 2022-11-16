# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: Image.pm 5319 2010-02-22 00:07:51Z auno $

package MT::Image::NetPBM;
use strict;
use warnings;

use base qw( MT::Image );

sub load_driver {
    my $image = shift;
    eval { require IPC::Run };
    if ( my $err = $@ ) {
        return $image->error(
            MT->translate( "Cannot load IPC::Run: [_1]", $err ) );
    }
    my $pbm = $image->_find_pbm or return;
    1;
}

sub init {
    my $image = shift;
    my %param = @_;

    $image->SUPER::init(%param);

    if ( my $file = $param{Filename} ) {
        $image->{file} = $file;
        if ( !defined $param{Type} ) {
            ( my $ext = $file ) =~ s/.*\.//;
            $param{Type} = uc $ext;
        }
    }
    elsif ( my $blob = $param{Data} ) {
        $image->{data} = $blob;
    }

    my $type = $image->{type} = _translate_filetype( lc $param{Type} );
    if ( !$type ) {
        return $image->error(
            MT->translate(
                "Unsupported image file type: [_1]", $param{Type}
            )
        );
    }
    $image;
}

sub _init_image_size {
    my $image = shift;
    return ($image->{width}, $image->{height}) if defined $image->{width} && defined $image->{height};

    my ( $out, $err );
    my $pbm = $image->_find_pbm or return;
    my $type = $image->{type};

    my @in = ( "$pbm${type}topnm", ( $image->{file} ? $image->{file} : () ) );
    my @out = ( "${pbm}pnmfile", '-allimages' );
    IPC::Run::run( \@in, '<', ( $image->{file} ? \undef : \$image->{data} ),
        '|', \@out, \$out, \$err )
        or return $image->error(
        MT->translate( "Reading image failed: [_1]", $err ) );
    ( $image->{width}, $image->{height} ) = $out =~ /(\d+)\s+by\s+(\d+)/;
}

sub _has_alpha {
    my $image = shift;
    my $pbm = $image->_find_pbm or return;
    my $type = $image->{type};

    # Preserve alpha channel of PNG image.
    if ( $type eq 'png' ) {
        return $image->{alpha} if $image->{alpha};

        my @alpha_in = (
            "$pbm${type}topnm", '-alpha',
            ( $image->{file} ? $image->{file} : () )
        );
        my $alpha_err;
        IPC::Run::run( \@alpha_in,
            ( $image->{file} ? \undef : \$image->{data} ),
            \$image->{alpha}, \$alpha_err )
            or return $image->error(
            MT->translate(
                "Reading alpha channel of image failed: [_1]", $alpha_err
            )
            );

        return $image->{alpha};
    }
    return;
}

sub _translate_filetype {
    return {
        jpg  => 'jpeg',
        jpeg => 'jpeg',
        gif  => 'gif',
        png  => 'png',

        # TODO: NetPBM driver does not support TIFF.
        # case #113464
        # tif  => 'tiff',
        # tiff => 'tiff',
    }->{ lc $_[0] };
}

sub scale {
    my $image = shift;
    my ( $w, $h ) = $image->get_dimensions(@_);
    my $type = $image->{type};
    my ( $out, $err );
    my $pbm = $image->_find_pbm or return;

    # Scale alpha channel.
    if ( $image->_has_alpha ) {
        my @scale_alpha = ( "${pbm}pnmscale", '-width', $w, '-height', $h );
        my ( $alpha, $alpha_err );
        IPC::Run::run( \@scale_alpha, \$image->{alpha}, \$alpha, \$alpha_err )
            or return $image->error(
            MT->translate(
                "Scaling to [_1]x[_2] failed: [_3]",
                $w, $h, $alpha_err
            )
            );
        $image->{alpha} = $alpha;
    }

    my @in = (
        "$pbm${type}topnm",
        ( $image->{data} ? () : $image->{file} ? $image->{file} : () )
    );
    my @scale = ( "${pbm}pnmscale", '-width', $w, '-height', $h );
    my @out = $image->_generate_converting_command( $pbm, $type );
    my (@quant);

    if ( $type eq 'gif' ) {
        push @quant, ( [ "${pbm}ppmquant", 256 ], '|' );
    }
    IPC::Run::run( \@in, '<', ( $image->{data} ? \$image->{data} : \undef ),
        '|', \@scale, '|', @quant, \@out, \$out, \$err )
        or return $image->error(
        MT->translate( "Scaling to [_1]x[_2] failed: [_3]", $w, $h, $err ) );
    ( $image->{width}, $image->{height}, $image->{data} ) = ( $w, $h, $out );
    wantarray ? ( $out, $w, $h ) : $out;
}

sub crop_rectangle {
    my $image = shift;
    my %param = @_;
    my ( $width, $height, $x, $y ) = @param{qw( Width Height X Y )};

    my ( $w, $h ) = $image->get_dimensions(@_);
    my $type = $image->{type};
    my ( $out, $err );
    my $pbm = $image->_find_pbm or return $image->error('Failed to find pbm');

    # Crop alpha channel.
    if ( $image->_has_alpha ) {
        my @crop_alpha = ( "${pbm}pnmcut", $x, $y, $width, $height );
        my ( $alpha, $alpha_err );
        IPC::Run::run( \@crop_alpha, \$image->{alpha}, \$alpha, \$alpha_err )
            or return $image->error(
            MT->translate(
                'Cropping to [_1]x[_2] failed: [_3]',
                $width, $height, $alpha_err
            )
            );
        $image->{alpha} = $alpha;
    }

    my @in = (
        "$pbm${type}topnm",
        ( $image->{data} ? () : $image->{file} ? $image->{file} : () )
    );

    my @crop = ( "${pbm}pnmcut", $x, $y, $width, $height );
    my @out = $image->_generate_converting_command( $pbm, $type );
    my (@quant);
    if ( $type eq 'gif' ) {
        push @quant, ( [ "${pbm}ppmquant", 256 ], '|' );
    }
    IPC::Run::run( \@in, '<', ( $image->{data} ? \$image->{data} : \undef ),
        '|', \@crop, '|', @quant, \@out, \$out, \$err )
        or return $image->error(
        MT->translate(
            "Cropping to [_1]x[_2] failed: [_3]",
            $width, $height, $err
        )
        );
    ( $image->{width}, $image->{height}, $image->{data} )
        = ( $width, $height, $out );
    wantarray ? ( $out, $width, $height ) : $out;
}

sub flipHorizontal {
    my $image = shift;
    my $type  = $image->{type};
    my ( $out, $err );
    my $pbm = $image->_find_pbm or return;

    # Flip horizontal alpha channel.
    if ( $image->_has_alpha ) {
        my @flip_alpha = ( "${pbm}pnmflip", '-lr' );
        my ( $alpha, $alpha_err );
        IPC::Run::run( \@flip_alpha, \$image->{alpha}, \$alpha, \$alpha_err )
            or return $image->error(
            MT->translate( 'Flip horizontal failed: [_1]', $alpha_err ) );
        $image->{alpha} = $alpha;
    }

    my @in = (
        "$pbm${type}topnm",
        ( $image->{data} ? () : $image->{file} ? $image->{file} : () )
    );
    my @scale = ( "${pbm}pnmflip", '-lr' );
    my @out = $image->_generate_converting_command( $pbm, $type );
    my (@quant);

    if ( $type eq 'gif' ) {
        push @quant, ( [ "${pbm}ppmquant", 256 ], '|' );
    }
    IPC::Run::run( \@in, '<', ( $image->{data} ? \$image->{data} : \undef ),
        '|', \@scale, '|', @quant, \@out, \$out, \$err )
        or return $image->error(
        MT->translate( "Flip horizontal failed: [_1]", $err ) );
    $image->{data} = $out;
    wantarray ? ( $out, @$image{qw(width height)} ) : $out;
}

sub flipVertical {
    my $image = shift;
    my $type  = $image->{type};
    my ( $out, $err );
    my $pbm = $image->_find_pbm or return;

    # Flip vertical alpha channel.
    if ( $image->_has_alpha ) {
        my @flip_alpha = ( "${pbm}pnmflip", '-tb' );
        my ( $alpha, $alpha_err );
        IPC::Run::run( \@flip_alpha, \$image->{alpha}, \$alpha, \$alpha_err )
            or return $image->error(
            MT->translate( 'Flip vertical failed: [_1]', $alpha_err ) );
        $image->{alpha} = $alpha;
    }

    my @in = (
        "$pbm${type}topnm",
        ( $image->{data} ? () : $image->{file} ? $image->{file} : () )
    );
    my @scale = ( "${pbm}pnmflip", '-tb' );
    my @out = $image->_generate_converting_command( $pbm, $type );
    my (@quant);

    if ( $type eq 'gif' ) {
        push @quant, ( [ "${pbm}ppmquant", 256 ], '|' );
    }
    IPC::Run::run( \@in, '<', ( $image->{data} ? \$image->{data} : \undef ),
        '|', \@scale, '|', @quant, \@out, \$out, \$err )
        or return $image->error(
        MT->translate( "Flip vertical failed: [_1]", $err ) );
    $image->{data} = $out;
    wantarray ? ( $out, @$image{qw(width height)} ) : $out;
}

sub rotate {
    my $image = shift;
    my ( $degrees, $w, $h ) = $image->get_degrees(@_);
    my $type = $image->{type};
    my ( $out, $err );
    my $pbm = $image->_find_pbm or return;

    # Rotate alpha channel.
    if ( $image->_has_alpha ) {
        my @rotate_alpha = ( "${pbm}pnmflip", '-r' . ( 360 - $degrees ) );
        my ( $alpha, $alpha_err );
        IPC::Run::run( \@rotate_alpha, \$image->{alpha}, \$alpha,
            \$alpha_err )
            or return $image->error(
            MT->translate(
                'Rotate (degrees: [_1]) failed: [_2]', $degrees,
                $alpha_err
            )
            );
        $image->{alpha} = $alpha;
    }

    my @in = (
        "$pbm${type}topnm",
        ( $image->{data} ? () : $image->{file} ? $image->{file} : () )
    );
    my @scale = ( "${pbm}pnmflip", '-r' . ( 360 - $degrees ) );
    my @out = $image->_generate_converting_command( $pbm, $type );
    my (@quant);

    if ( $type eq 'gif' ) {
        push @quant, ( [ "${pbm}ppmquant", 256 ], '|' );
    }
    IPC::Run::run( \@in, '<', ( $image->{data} ? \$image->{data} : \undef ),
        '|', \@scale, '|', @quant, \@out, \$out, \$err )
        or return $image->error(
        MT->translate(
            "Rotate (degrees: [_1]) failed: [_2]", $degrees, $err
        )
        );
    ( $image->{width}, $image->{height}, $image->{data} ) = ( $w, $h, $out );
    wantarray ? ( $out, $w, $h ) : $out;
}

sub convert {
    my $image = shift;
    my %param = @_;

    my $type    = $image->{type};
    my $outtype = _translate_filetype( $param{Type} );
    return $image->{data} if $type eq $outtype;
    my ( $out, $err );
    my $pbm = $image->_find_pbm or return;
    my @in = (
        "$pbm${type}topnm",
        ( $type eq 'png' ? '-mix' : () ),    # Mix alpha channel if needed.
        ( $image->{data} ? () : $image->{file} ? $image->{file} : () )
    );

    my @out = $image->_generate_converting_command( $pbm, $outtype );
    my (@quant);
    if ( $outtype eq 'gif' ) {
        push @quant, ( [ "${pbm}ppmquant", 256 ], '|' );
    }
    IPC::Run::run( \@in, '<', ( $image->{data} ? \$image->{data} : \undef ),
        '|', @quant, \@out, \$out, \$err )
        or return $image->error(
        MT->translate(
            "Converting image to [_1] failed: [_2]",
            $outtype, $err
        )
        );
    $image->{data} = $out;
    $image->{type} = $outtype;

    # Update alpha channel.
    if ( $outtype eq 'png' ) {
        my @alpha_in = ( "${pbm}pngtopnm", '-alpha' );
        my $alpha_err;
        IPC::Run::run( \@alpha_in, \$image->{data}, \$image->{alpha},
            \$alpha_err )
            or return $image->error(
            MT->translate(
                "Reading alpha channel of image failed: [_1]", $alpha_err
            )
            );
    }
    else {
        delete $image->{alpha};
    }

    $out;
}

sub blob {
    my ( $image, $quality ) = @_;

    my $type = $image->{type};
    my ( $out, $err );
    my $pbm = $image->_find_pbm or return;
    my @in = (
        "$pbm${type}topnm",
        ( $image->{data} ? () : $image->{file} ? $image->{file} : () )
    );

    my @out = $image->_generate_converting_command( $pbm, $type, $quality );
    my (@quant);
    if ( $type eq 'gif' ) {
        push @quant, ( [ "${pbm}ppmquant", 256 ], '|' );
    }
    IPC::Run::run( \@in, '<', ( $image->{data} ? \$image->{data} : \undef ),
        '|', @quant, \@out, \$out, \$err )
        or return $image->error(
        MT->translate( "Outputting image failed: [_1]", $err ) );
    $image->{data} = $out;

    $out;
}

sub _find_pbm {
    my $image = shift;
    return $image->{__pbm_path} if ref $image and $image->{__pbm_path};
    my @NetPBM = qw( /usr/local/netpbm/bin /usr/local/bin /usr/bin );
    my $pbm;
    for my $path ( MT->config->NetPBMPath, @NetPBM ) {
        next unless $path;
        $path .= '/' unless $path =~ m!/$!;
        $pbm = $path, last if -x "${path}pnmscale";
    }
    return $image->error(
        MT->translate(
            "You do not have a valid path to the NetPBM tools on your machine."
        )
    ) unless $pbm;
    $image->{__pbm_path} = $pbm if ref $image;
    $pbm;
}

sub _generate_converting_command {
    my ( $image, $pbm, $type, $quality ) = @_;
    my @out;

    for my $try (qw( ppm pnm )) {
        my $prog = "${pbm}${try}to$type";
        @out = ($prog), last if -x $prog;
    }

    if (@out) {
        if ( $type eq 'jpeg' ) {
            $quality = $image->jpeg_quality if !defined $quality;
            push @out, ( '-quality=' . $quality );
        }
        elsif ( $type eq 'png' ) {
            $quality = $image->png_quality if !defined $quality;
            push @out, ( '-compression', $quality );
        }

        # Set alpha channel data.
        if ( $type eq 'png' && $image->_has_alpha ) {
            require File::Temp;
            require MT::FileMgr;

            # 'OPEN => 0' option outputs a warning.
            my ( $fh, $filename )
                = File::Temp::tempfile( DIR => MT->config->TempDir );
            close $fh;

            my $fmgr = MT::FileMgr->new('Local');
            $fmgr->put_data( $image->{alpha}, $filename, 'upload' );

            push @out, ( '-alpha', $filename );
        }
    }

    @out;
}

1;
