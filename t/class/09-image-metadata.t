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
use MT;
use MT::Image;
use MT::Test::Image;

use Image::ExifTool;

$test_env->prepare_fixture('db');

my $cfg = MT->config;

for my $driver ( $test_env->image_drivers ) {
    subtest $driver => sub {

        $cfg->ImageDriver($driver);
        is( $cfg->ImageDriver, $driver, qq{ImageDriver is "$driver".} );

        my ( $guard, $tempfile ) = MT::Test::Image->tempfile(
            DIR    => $test_env->root,
            SUFFIX => '.jpg',
        );
        close $guard;

        ok( -s $tempfile, 'JPEG file exists.' );

        # JPEG file does not have 'Comment' tag.
        my $tag  = 'Comment';
        my $exif = Image::ExifTool->new;
        $exif->ExtractInfo($tempfile);
        ok( !$exif->GetValue($tag), qq{JPEG file does not have $tag tag.} );

        # Set 'Keywords' tag.
        $exif->SetNewValue( $tag, 1 );
        $exif->WriteInfo($tempfile);
        $exif->ExtractInfo($tempfile);
        ok( $exif->GetValue($tag), qq{$tag tag is set to JPEG file.} );

        # Remove 'Keywords' tag. (remove all tags)
        MT::Image->remove_metadata($tempfile);

        SKIP: {
            my $img = MT::Image->new;
            skip( "no $driver for image $tempfile", 3 ) unless $img;
            ok( $img->init( Filename => $tempfile ) );
            $exif->ExtractInfo($tempfile);
            ok( !$exif->GetValue($tag),
                qq{$tag tag has been removed from JPEG file.} );
            ok( $exif->GetValue('JFIFVersion'),
                'JFIFVersion tag is stiall remaining.'
            );
        }
    };
}

done_testing;
