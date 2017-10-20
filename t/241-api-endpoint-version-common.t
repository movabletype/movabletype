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

use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

{
    ( my $base = __FILE__ ) =~ s/\.t$/.d/;
    $app->_init_plugins_core( {}, 1,
        [ File::Spec->join( $base, 'plugins' ) ] );
}

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[
        {   path   => '/v1/users/1/sites',
            method => 'GET',
            code   => 200,
        },
        {   path   => '/vx/users/1/sites',
            method => 'GET',
            code   => 400,
        },
        {   path   => '/v1/users/1/sites',
            method => 'GET',
            code   => 200,
        },
        {   path   => '/v1/endpoint-test',
            method => 'GET',
            code   => 200,
            result => +{ version => 1 },
        },
        {   path   => '/v2/endpoint-test',
            method => 'GET',
            code   => 200,
            result => +{ version => 2 },
        },
    ];
}

