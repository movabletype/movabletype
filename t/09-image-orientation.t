#!/usr/bin/perl -w

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval { require Image::Magick }
        or plan skip_all => 'Image::Magick is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Image;

MT->instance;

my @drivers = qw( ImageMagick NetPBM GD Imager );

my $original_width  = 3;
my $original_height = 2;
my $original_image  = Image::Magick->new;
$original_image->Read(
    File::Spec->catfile( $ENV{MT_HOME}, 't', 'images', 'test.png' ) );
$original_image->Resize(
    width  => $original_width,
    height => $original_height
);

my %pixels_map = ();
for ( my $i = 0; $i < $original_width; $i++ ) {
    for ( my $j = 0; $j < $original_height; $j++ ) {
        $original_image->SetPixel(
            x       => $i,
            y       => $j,
            channel => 'RGB',
            color   => [ $i * 0.2, $j * 0.2, 0 ],
        );
        $pixels_map{$i}{$j} = [
            $original_image->GetPixel(
                x       => $i,
                y       => $j,
                channel => 'RGB',
            )
        ];
    }
}

my $original_image_blob = $original_image->ImageToBlob;

for my $driver (@drivers) {
    subtest $driver => sub {
        my $cfg = MT::ConfigMgr->instance;
        $cfg->ImageDriver($driver);
        MT::Image->error('');
        MT::Image->new(
            Filename => File::Spec->catfile(
                $ENV{MT_HOME}, 't', 'images', 'test.png'
            )
        ) or plan skip_all => "Cannot load MT::Image::$driver";

        _run_for_each_method();

        done_testing();
    };
}

sub _run {
    my ( $label, $sub, $width, $height, $expected_map ) = @_;
    my $image = MT::Image->new( Data => $original_image_blob, Type => 'png' );

    my ( $blob, $w, $h ) = $sub->($image);

    is( $w, $width,  'Returned width' );
    is( $h, $height, 'Returned height' );

    my $result_image = Image::Magick->new;
    $result_image->BlobToImage($blob);

    my ( $converted_width, $converted_height )
        = $result_image->Get( 'width', 'height' );
    is( $converted_width,  $width,  'Image width' );
    is( $converted_height, $height, 'Image height' );

    my %result_map = ();
    for ( my $i = 0; $i < $converted_width; $i++ ) {
        for ( my $j = 0; $j < $converted_height; $j++ ) {
            $result_map{$i}{$j} = [
                $result_image->GetPixel(
                    x       => $i,
                    y       => $j,
                    channel => 'RGB',
                )
            ];
        }
    }

    is_deeply( \%result_map, $expected_map, 'All pixels' );
}

sub _rotate90 {
    my ($map) = @_;
    my $converted = {};

    for my $i ( sort keys %$map ) {
        my $size = scalar keys %{ $map->{$i} };
        for my $j ( sort keys %{ $map->{$i} } ) {
            $converted->{ $size - $j - 1 }{$i} = $map->{$i}{$j};
        }
    }

    $converted;
}

sub _run_for_each_method {
    subtest 'flipHorizontal' => sub {
        my %expected_map = ();
        for ( my $i = 0; $i < $original_width; $i++ ) {
            for ( my $j = 0; $j < $original_height; $j++ ) {
                $expected_map{$i}{$j}
                    = $pixels_map{ $original_width - $i - 1 }{$j};
            }
        }

        _run(
            'flipHorizontal',
            sub {
                $_[0]->flipHorizontal;
            },
            $original_width,
            $original_height,
            \%expected_map
        );

        done_testing();
    };

    subtest 'flipVertical' => sub {
        my %expected_map = ();
        for ( my $i = 0; $i < $original_width; $i++ ) {
            for ( my $j = 0; $j < $original_height; $j++ ) {
                $expected_map{$i}{$j}
                    = $pixels_map{$i}{ $original_height - $j - 1 };
            }
        }

        _run(
            'flipVertical',
            sub {
                $_[0]->flipVertical;
            },
            $original_width,
            $original_height,
            \%expected_map
        );

        done_testing();
    };

    subtest 'rotate:90' => sub {
        _run(
            'rotate:90',
            sub {
                $_[0]->rotate( Degrees => 90 );
            },
            $original_height,
            $original_width,
            _rotate90( \%pixels_map )
        );

        done_testing();
    };

    subtest 'rotate:180' => sub {
        _run(
            'rotate:180',
            sub {
                $_[0]->rotate( Degrees => 180 );
            },
            $original_width,
            $original_height,
            _rotate90( _rotate90( \%pixels_map ) )
        );

        done_testing();
    };

    subtest 'rotate:270' => sub {
        _run(
            'rotate:270',
            sub {
                $_[0]->rotate( Degrees => 270 );
            },
            $original_height,
            $original_width,
            _rotate90( _rotate90( _rotate90( \%pixels_map ) ) )
        );

        done_testing();
    };
}

done_testing();
