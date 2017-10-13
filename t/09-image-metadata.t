#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}


use Test::More;

use File::Basename;
use File::Copy;
use File::Spec;
use File::Temp qw( tempfile );

use lib qw( lib extlib t/lib );
use MT::Test qw( :app :db );
use MT;
use MT::Image;

use Image::ExifTool;

my $cfg = MT->config;

for my $driver (qw/ ImageMagick GD Imager NetPBM /) {
    subtest $driver => sub {

        $cfg->ImageDriver($driver);
        is( $cfg->ImageDriver, $driver, qq{ImageDriver is "$driver".} );

        my $file   = File::Spec->rel2abs(__FILE__);
        my $mt_dir = dirname( dirname($file) );
        my $jpg_file
            = File::Spec->catfile( $mt_dir, 't', 'images', 'test.jpg' );

        # Copy JPEG file.
        my ( $fh, $tempfile ) = tempfile( SUFFIX => '.jpg' );
        close $fh;
        copy( $jpg_file, $tempfile );
        ok( -s $tempfile, 'Copy JPEG file.' );

        # JPEG file does not have 'Orientation' tag.
        my $tag  = 'Orientation';
        my $exif = Image::ExifTool->new;
        $exif->ExtractInfo($tempfile);
        ok( !$exif->GetValue($tag), qq{JPEG file does not have $tag tag.} );

        # Set 'Orientation' tag.
        $exif->SetNewValue( $tag, 1 );
        $exif->WriteInfo($tempfile);
        $exif->ExtractInfo($tempfile);
        ok( $exif->GetValue($tag), qq{$tag tag is set to JPEG file.} );

        # Remove 'Orientation' tag. (remove all tags)
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
