use strict;
use warnings;
use FindBin;
use Test::More;
use lib "$FindBin::Bin/../extlib";
use Image::ExifTool;

my $exif_version = $Image::ExifTool::VERSION;

my $pm = do { open my $fh, '<', "$FindBin::Bin/../lib/MT/Image/ExifData.pm"; local $/; <$fh> };
my ($pm_version) = $pm =~ /# Generated from Image::ExifTool ([0-9.]+)/;

is $pm_version => $exif_version, "MT::Image::ExifData is up-to-date";

done_testing;
