#!/usr/bin/perl
use strict;
use warnings;

use File::Basename;
use File::Copy;
use File::Spec;
use File::Temp qw( tempfile );
use Test::More;

use lib qw( lib extlib );
use MT::Image;
use Image::ExifTool;

my $file     = File::Spec->rel2abs(__FILE__);
my $mt_dir   = dirname( dirname($file) );
my $jpg_file = File::Spec->catfile( $mt_dir, 't', 'images', 'test.jpg' );

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

# Remove 'Orientation' tag.
MT::Image->remove_metadata($tempfile);
$exif->ExtractInfo($tempfile);
ok( !$exif->GetValue($tag), qq{$tag tag has been removed from JPEG file.} );

done_testing;
