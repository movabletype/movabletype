# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
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
    my ( $out, $err );
    my $pbm = $image->_find_pbm or return;
    my @in = ( "$pbm${type}topnm", ( $image->{file} ? $image->{file} : () ) );
    my @out = ( "${pbm}pnmfile", '-allimages' );
    IPC::Run::run( \@in, '<', ( $image->{file} ? \undef : \$image->{data} ),
        '|', \@out, \$out, \$err )
        or return $image->error(
        MT->translate( "Reading image failed: [_1]", $err ) );
    ( $image->{width}, $image->{height} ) = $out =~ /(\d+)\s+by\s+(\d+)/;
    $image;
}

sub _translate_filetype {
    return {
        jpg  => 'jpeg',
        jpeg => 'jpeg',
        gif  => 'gif',
        png  => 'png',
    }->{ lc $_[0] };
}

sub scale {
    my $image = shift;
    my ( $w, $h ) = $image->get_dimensions(@_);
    my $type = $image->{type};
    my ( $out, $err );
    my $pbm = $image->_find_pbm or return;
    my @in = (
        "$pbm${type}topnm",
        ( $image->{data} ? () : $image->{file} ? $image->{file} : () )
    );
    my @scale = ( "${pbm}pnmscale", '-width', $w, '-height', $h );
    my @out;

    for my $try (qw( ppm pnm )) {
        my $prog = "${pbm}${try}to$type";
        @out = ($prog), last if -x $prog;
    }
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

sub crop {
    my $image = shift;
    my %param = @_;
    my ( $size, $x, $y ) = @param{qw( Size X Y )};

    my ( $w, $h ) = $image->get_dimensions(@_);
    my $type = $image->{type};
    my ( $out, $err );
    my $pbm = $image->_find_pbm or return $image->error('Failed to find pbm');
    my @in = (
        "$pbm${type}topnm",
        ( $image->{data} ? () : $image->{file} ? $image->{file} : () )
    );

    my @crop = ( "${pbm}pnmcut", $x, $y, $size, $size );
    my @out;
    for my $try (qw( ppm pnm )) {
        my $prog = "${pbm}${try}to$type";
        @out = ($prog), last if -x $prog;
    }
    my (@quant);
    if ( $type eq 'gif' ) {
        push @quant, ( [ "${pbm}ppmquant", 256 ], '|' );
    }
    IPC::Run::run( \@in, '<', ( $image->{data} ? \$image->{data} : \undef ),
        '|', \@crop, '|', @quant, \@out, \$out, \$err )
        or return $image->error(
        MT->translate( "Cropping to [_1]x[_1] failed: [_2]", $size, $err ) );
    ( $image->{width}, $image->{height}, $image->{data} )
        = ( $size, $size, $out );
    wantarray ? ( $out, $size, $size ) : $out;
}

sub flipHorizontal {
    my $image = shift;
    my $type  = $image->{type};
    my ( $out, $err );
    my $pbm = $image->_find_pbm or return;
    my @in = (
        "$pbm${type}topnm",
        ( $image->{data} ? () : $image->{file} ? $image->{file} : () )
    );
    my @scale = ( "${pbm}pnmflip", '-lr' );
    my @out;

    for my $try (qw( ppm pnm )) {
        my $prog = "${pbm}${try}to$type";
        @out = ($prog), last if -x $prog;
    }
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
    my @in = (
        "$pbm${type}topnm",
        ( $image->{data} ? () : $image->{file} ? $image->{file} : () )
    );
    my @scale = ( "${pbm}pnmflip", '-tb' );
    my @out;

    for my $try (qw( ppm pnm )) {
        my $prog = "${pbm}${try}to$type";
        @out = ($prog), last if -x $prog;
    }
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
    my @in = (
        "$pbm${type}topnm",
        ( $image->{data} ? () : $image->{file} ? $image->{file} : () )
    );
    my @scale = ( "${pbm}pnmflip", '-r' . ( 360 - $degrees ) );
    my @out;

    for my $try (qw( ppm pnm )) {
        my $prog = "${pbm}${try}to$type";
        @out = ($prog), last if -x $prog;
    }
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
        ( $image->{data} ? () : $image->{file} ? $image->{file} : () )
    );

    my @out;
    for my $try (qw( ppm pnm )) {
        my $prog = "${pbm}${try}to$outtype";
        @out = ($prog), last if -x $prog;
    }
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

1;
