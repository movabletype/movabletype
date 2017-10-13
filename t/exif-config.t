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

use File::Basename;
use File::Spec;

my $config_file;

BEGIN {
    my $current_dir = dirname(__FILE__);
    $config_file = File::Spec->catfile( $current_dir, 'exif_config' );

    no warnings 'once';
    $Image::ExifTool::configFile = $config_file;
}

use MT::Test qw( :app :db );

use Image::ExifTool;
ok( !MT->can('load_exif_config'), "ExifTool's config file is not loaded." );

done_testing;

