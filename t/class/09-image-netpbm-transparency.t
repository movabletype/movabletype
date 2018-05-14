#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use File::Basename;
use File::Spec;
use File::Temp qw( tempfile );

use MT::Test;
use MT::FileMgr;
use MT::Image;

my $file   = File::Spec->rel2abs(__FILE__);
my $mt_dir = dirname( dirname($file) );
my $png    = File::Spec->catfile( $mt_dir, 'mt-static', 'images', 'logo',
    'movable-type-logo.png' );

my $cfg = MT->config;
$cfg->ImageDriver('NetPBM');

# Skip this test when NetPBM driver is invalid.
my $image = MT::Image->new( Filename => $png )
    or plan skip_all => 'NetPBM driver may not be installed.';

# Rotate 360 degrees PNG image.
$image->rotate( Degrees => 180 );
my ( $out, $width, $height ) = $image->rotate( Degrees => 180 );

# Write rotated image data to temporary file.
my $fmgr = MT::FileMgr->new('Local');
my ( $fh, $temp_filename ) = tempfile;
close $fh;
$fmgr->put_data( $out, $temp_filename, 'upload' );

# Read alpha channel data from temporary file.
my $alpha     = `pngtopnm -alpha $temp_filename`;
my $blank_pbm = `pbmmake $width $height`;

isnt( $alpha, $blank_pbm,
    'Transparency data of rotated PNG image is not blank.' );

done_testing;
