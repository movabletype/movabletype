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

use MT;
use MT::Test;

MT::Test->init_app;

my $mt = MT->instance;

# Make additional data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;
    MT::Test->init_data;

    # make_data();
});

my ( $app, $out );
my $menus = MT->app->registry('menus');
use Data::Dumper;
diag Dumper $menus;

#
#
# $app = _run_app(
#     'MT::App::CMS',
#     {   __test_user      => $other,
#         __request_method => 'POST',
#         __mode           => 'save',
#         _type            => 'asset',
#         blog_id          => 1,
#         id               => 1
#     }
# );
# $out = delete $app->{__test_output};
# ok( $out, "Update an asset" );
# location_param_contains(
#     $out,
#     { __mode => 'dashboard', permission => 1 },
#     "Update an asset: result"
# );
