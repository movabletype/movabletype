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


use lib 't/lib', 'lib', 'extlib';
use Test::More tests => 1;

BEGIN {
        $ENV{MT_APP} = 'MT::App::CMS';
}

use MT;
use MT::Test qw( :app :db :data );

my $app = MT::App::CMS->instance();

my $static_path = $app->static_file_path;
ok ($static_path, "Static path exists: $static_path");