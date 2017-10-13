#!/usr/bin/perl -w

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
    eval { require Test::MockObject }
        or plan skip_all => 'Test::MockObject is not installed';
}

use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test qw( :app );
use MT::Image;
use File::Temp;
use File::Copy;
use Image::ExifTool;

my $src_file
    = File::Spec->catfile( $ENV{MT_HOME}, 't', 'images', 'test.jpg' );
my $src_image = MT::Image->new( Filename => $src_file );

sub _create_image_with_orientation {
    my ($orientation) = @_;
    my $exifTool = new Image::ExifTool;
    $exifTool->SetNewValue(
        Orientation => $orientation,
        Type        => 'ValueConv'
    );
    my ( $fh, $file ) = File::Temp::tempfile(
        SUFFIX => '.jpg',
        DIR    => MT->config->TempDir
    );
    close($fh);
    copy( $src_file, $file );
    $exifTool->WriteInfo($file);

    $file;
}

my %map = (
    1 => {
        put            => 0,
        flipHorizontal => 0,
        flipVertical   => 0,
        rotate         => 0,
        width          => $src_image->{width},
        height         => $src_image->{height},
    },
    2 => {
        put            => 1,
        flipHorizontal => 0,
        flipVertical   => 1,
        rotate         => 0,
        width          => $src_image->{width},
        height         => $src_image->{height},
    },
    3 => {
        put            => 1,
        flipHorizontal => 0,
        flipVertical   => 0,
        rotate         => 180,
        width          => $src_image->{width},
        height         => $src_image->{height},
    },
    4 => {
        put            => 1,
        flipHorizontal => 1,
        flipVertical   => 0,
        rotate         => 0,
        width          => $src_image->{width},
        height         => $src_image->{height},
    },
    5 => {
        put            => 1,
        flipHorizontal => 0,
        flipVertical   => 1,
        rotate         => 270,
        width          => $src_image->{height},
        height         => $src_image->{width},
    },
    6 => {
        put            => 1,
        flipHorizontal => 0,
        flipVertical   => 0,
        rotate         => 90,
        width          => $src_image->{height},
        height         => $src_image->{width},
    },
    7 => {
        put            => 1,
        flipHorizontal => 0,
        flipVertical   => 1,
        rotate         => 90,
        width          => $src_image->{height},
        height         => $src_image->{width},
    },
    8 => {
        put            => 1,
        flipHorizontal => 0,
        flipVertical   => 0,
        rotate         => 270,
        width          => $src_image->{height},
        height         => $src_image->{width},
    },
);

sub _run {
    for my $orientation ( 1 .. 8 ) {
        my $expected = $map{$orientation};
        subtest 'Orientation: ' . $orientation => sub {
            my $file = _create_image_with_orientation($orientation);

            my %counter = ();

            my $fmgr_module = Test::MockModule->new('MT::FileMgr::Local');
            $fmgr_module->mock(
                'put_data',
                sub {
                    $counter{put}++;
                    $fmgr_module->original('put_data')->(@_);
                }
            );

            my $image_obj        = MT::Image->new( Filename => $file );
            my $image_module     = Test::MockModule->new( ref $image_obj );
            my @manipulated_data = ( '', @$expected{qw(width height)} );
            $image_module->mock(
                'flipHorizontal',
                sub {
                    $counter{flipHorizontal}++;
                    @manipulated_data;
                }
            );
            $image_module->mock(
                'flipVertical',
                sub {
                    $counter{flipVertical}++;
                    @manipulated_data;
                }
            );
            $image_module->mock(
                'rotate',
                sub {
                    my ( $self, %params ) = @_;
                    $counter{rotate} += $params{Degrees};
                    @manipulated_data;
                }
            );

            my $asset = MT::Asset::Image->new;
            $asset->file_path($file);
            $asset->file_ext('jpg');
            $asset->image_width( $image_obj->{width} );
            $asset->image_height( $image_obj->{height} );

            $asset->normalize_orientation;

            is( $asset->image_width,  $expected->{width},  'Updated width' );
            is( $asset->image_height, $expected->{height}, 'Updated height' );
            if ( $expected->{rotate} == 0 ) {
                is( $counter{rotate} || 0, 0, 'rotate is not colled' );
            }
            else {
                is( $counter{rotate} || 0,
                    $expected->{rotate},
                    'rotate is colled (Degrees:' . $expected->{rotate} . ')'
                );
            }
            for my $k (qw(put flipHorizontal flipVertical)) {
                next unless exists $expected->{$k};
                is( $counter{$k} || 0,
                    $expected->{$k},
                    $k . ' is called ' . $expected->{$k} . ' time(s)' );
            }

            my $fixed_orientation
                = Image::ExifTool::ImageInfo($file)->{Orientation};
            ok( !$fixed_orientation
                    || $fixed_orientation eq 'Horizontal (normal)',
                'Orientation is cleared'
            );

            done_testing();
        };
    }
}

my @drivers = qw( ImageMagick NetPBM GD Imager );
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

        _run();

        done_testing();
    };
}

done_testing();
