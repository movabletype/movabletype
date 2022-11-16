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

use MT::Test;
use MT::ConfigMgr;
use MT::Image;
use MT::Test::Image;

MT->instance;

my $cfg = MT::ConfigMgr->instance;

for my $d ( $test_env->image_drivers ) {
    subtest "ImageDriver: $d" => sub {
        $cfg->ImageDriver($d);

        # PNG
        subtest 'PNG' => sub {
            if ( $d eq 'Imager' ) {
                plan skip_all =>
                    'Imager cannot change the quality of PNG image.';
            }

            my ( $guard, $png_file ) = MT::Test::Image->tempfile(
                DIR    => $test_env->root,
                SUFFIX => '.png',
            );
            close $guard;

            my @blob_size;
            for my $q ( 0 .. 9 ) {
                $cfg->ImageQualityPng($q);

                my $png_image = MT::Image->new( Filename => $png_file )
                    or plan skip_all => qq/ImageDriver "$d" may be disabled./;

                is( $png_image->png_quality,
                    $d =~ /(?:Image|Graphics)Magick/ ? $q * 10 : $q,
                    "ImagePngQuality: $q"
                );

                my $size = length $png_image->blob;
                note "Quality: $q, blob size: $size";
                push @blob_size, $size;
            }

            my $greater_count = 0;
            my $prev_size     = shift @blob_size;
            for my $s (@blob_size) {
                $greater_count++ if $prev_size > $s;
                $prev_size = $s;
            }
            cmp_ok( $greater_count, '>=', 5,
                '50% or more of blob size are bigger than next blob size.' );
        };

        # JPEG
        subtest 'JPEG' => sub {
            my ( $guard, $jpg_file ) = MT::Test::Image->tempfile(
                DIR    => $test_env->root,
                SUFFIX => '.jpg',
            );
            close $guard;

            my @blob_size;
            for my $q ( reverse 0 .. 100 ) {
                $cfg->ImageQualityJpeg($q);

                my $jpg_image = MT::Image->new( Filename => $jpg_file )
                    or plan skip_all => qq/ImageDriver "$d" may be disabled./;

                if ( $d =~ /(?:Image|Graphics)Magick/ && $q == 0 ) {
                    is( $jpg_image->jpeg_quality, 1,
                        "ImageJpegQuality: 1 (This is a special case)" );
                }
                else {
                    is( $jpg_image->jpeg_quality, $q,
                        "ImageJpegQuality: $q" );
                }

                my $size = length $jpg_image->blob;
                note "Quality: $q, blob size: $size";
                push @blob_size, $size;
            }

            my $greater_count = 0;
            my $prev_size     = shift @blob_size;
            for my $s (@blob_size) {
                $greater_count++ if $prev_size > $s;
                $prev_size = $s;
            }
            cmp_ok( $greater_count, '>=', 95,
                '95% or more of blob size are bigger than next blob size.' );
        };
    };
}

done_testing;
