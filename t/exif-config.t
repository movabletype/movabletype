use strict;
use warnings;

use Test::More;

use File::Basename;
use File::Spec;

my $config_file;

BEGIN {
    my $current_dir = dirname(__FILE__);
    $config_file = File::Spec->catfile( $current_dir, 'exif_config' );

    no warnings 'once';
    $Image::ExifTool::configFile = $config_file;
}

use lib qw( lib extlib t/lib );
use MT::Test qw( :app :db );

use Image::ExifTool;
ok( !MT->can('load_exif_config'), "ExifTool's config file is not loaded." );

done_testing;

