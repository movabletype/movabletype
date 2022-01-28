#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use File::Basename qw( basename );
use File::Spec;

use MT::Test;
use MT::Test::Permission;
use MT;
use MT::Image;
use MT::Test::Image;

use Image::ExifTool;

$test_env->prepare_fixture('db');

my $cfg = MT->config;

for my $driver ( $test_env->image_drivers ) {
    subtest $driver => sub {
        $cfg->ImageDriver($driver);
        is( $cfg->ImageDriver, $driver, 'Set ImageDriver' );

        my ( $guard, $tempfile ) = MT::Test::Image->tempfile(
            DIR    => $test_env->root,
            SUFFIX => '.jpg',
        );
        close $guard;

        ok( -s $tempfile, 'JPEG file exists.' );

        my $image = MT::Test::Permission->make_asset(
            blog_id   => 1,
            class     => 'image',
            file_ext  => 'jpg',
            file_name => basename($tempfile),
            file_path => $tempfile,
        );
        ok( $image, 'Create MT::Asset::Image record.' );

        subtest 'image_metadata field' => sub {
            isa_ok( $image->image_metadata, 'HASH' );
            isnt( %{ $image->image_metadata },
                (), 'image_metadata field is not empty.' );
        };

        subtest 'exif method' => sub {
            ok( $image->can('exif'), 'Has exif method.' );
            my $exif = Image::ExifTool->new;
            $exif->ExtractInfo( $image->file_path );
            is_deeply(_remove_access_date($image->exif), _remove_access_date($exif), 'Check exif data.' );
        };

        subtest 'has_metadata method' => sub {
            ok( $image->can('has_metadata'), 'Has has_metadata method.' );
            ok( $image->has_metadata,        'has metadata.' );

            my $exif = $image->exif;
            $exif->SetNewValue( 'Orientation', 1 );
            $exif->WriteInfo( $image->file_path );

            ok( $image->has_metadata, 'Added metadata.' );
        };

        subtest 'has_gps_metadata method' => sub {
            ok( $image->can('has_gps_metadata'),
                'Has has_gps_metadata method.'
            );
            # current image has gps metadata
            # ok( !$image->has_gps_metadata, 'Does not have GPS metadata.' );

            my $exif = $image->exif;
            $exif->SetNewValue( 'GPSDateTime', '2015:08:30 00:00:00Z' );
            $exif->WriteInfo( $image->file_path );

            ok( $image->has_gps_metadata, 'Has GPS metadata.' );

            $exif->SetNewValue( 'GPSVersionID', '2.2.1.0' );
            $exif->WriteInfo( $image->file_path );

            ok( $image->has_gps_metadata, 'Has GPS metadata.' );
        };

        subtest 'change_quality method' => sub {
            ok( $image->can('change_quality'), 'Has change_quality method.' );
            $image->change_quality(70);
            ok( $image->has_gps_metadata,
                'GPS metadata is remaining after doing change_quality method.'
            );
        };

        subtest 'remove_gps_metadata method' => sub {
            ok( $image->can('remove_gps_metadata'),
                'Has remove_gps_metadata method.'
            );

            $image->remove_gps_metadata;

            ok( !$image->has_gps_metadata, 'Removed GPS metadata.' );
            ok( $image->has_metadata,      'Other metadata still remains.' );
        };

        subtest 'remove_all_metadata method' => sub {
            ok( $image->can('remove_all_metadata'),
                'Has remove_all_metadata method.'
            );

            $image->remove_all_metadata;

            ok( !$image->has_metadata, 'has_metadata method returns false.' );
            ok( $image->exif->GetValue('JFIFVersion'),
                'JFIFVersion tag is still remaining.'
            );
            ok( $image->exif->GetValue('Orientation'),
                'Orientation tag is still remaining.'
            );

        SKIP: {
                my $mtimg = MT::Image->new;
                skip( "no $driver for image $tempfile", 1 ) unless $mtimg;
                ok( $mtimg->init( Filename => $image->file_path ),
                    'Read the image having no metadata.'
                );

                $image->rotate(90);
            }

            ok( !$image->has_metadata,
                'Has no metadata after rotating image.' );
        };
    };
}

done_testing;

sub _remove_access_date {
    my $exif = shift;
    delete $exif->{VALUE}{FileAccessDate};
    $exif->GetInfo;
}
