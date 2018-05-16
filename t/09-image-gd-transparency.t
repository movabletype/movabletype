#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval 'use GD; 1'
        or plan skip_all => 'GD is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use File::Basename;
use File::Spec;

use MT::Test;
use MT::Image;

my $dir = dirname( dirname( File::Spec->rel2abs(__FILE__) ) );
my $file = File::Spec->catfile( $dir, qw/ t images test.png / );

my $cfg = MT->config;
$cfg->ImageDriver('GD');
is( $cfg->ImageDriver, 'GD', 'ImageDriver is GD' );

has_alpha( sub { shift->blob },
    'Image has alpha value after outputting data' );
has_alpha(
    sub {
        my $img = shift;
        my ( $width, $height ) = $img->get_dimensions;
        $img->scale(
            Width  => int( $width / 2 ),
            Height => int( $height / 2 )
        );
    },
    'Image has alpha value after scaling',
);
has_alpha(
    sub {
        my $img = shift;
        my ( $width, $height ) = $img->get_dimensions;
        $img->crop_rectangle(
            X      => 0,
            Y      => 0,
            Width  => int( $width / 2 ),
            Height => int( $width / 2 ),
        );
    },
    'Image has alpha value after cropping',
);
has_alpha(
    sub {
        shift->flipHorizontal;
    },
    'Image has alpha value after flipping horizontally',
);
has_alpha(
    sub {
        shift->flipVertical;
    },
    'Image has alpha value after flipping vertically',
);
has_alpha(
    sub {
        shift->rotate( Degrees => 180 );
    },
    'Image has alpha value after rotating',
);

done_testing;

sub has_alpha {
    my ( $sub, $test ) = @_;

    my $img = MT::Image->new( Filename => $file );

    $sub->($img);

    my $gd = GD::Image->new( $img->blob );
    my $alpha = $gd->getPixel( 0, 0 ) >> 24;
    ok( $alpha, $test );
}

