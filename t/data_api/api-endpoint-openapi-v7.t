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

use MT::Test::DataAPI;

$test_env->prepare_fixture('db');

# This test can't force api version
local $ENV{MT_TEST_FORCE_DATAAPI_VERSION};

my %json;
test_data_api({
        path     => "/v6/",
        method   => 'GET',
        code     => 200,
        complete => sub {
            my ($data, $body, $headers) = @_;
            $json{v6} = MT::Util::from_json($body);
        },
    },
);

test_data_api({
        path     => "/v7/",
        method   => 'GET',
        code     => 200,
        complete => sub {
            my ($data, $body, $headers) = @_;
            $json{v7} = MT::Util::from_json($body);
        },
    },
);

# theme
ok( !defined $json{v6}{paths}{"/sites/{site_id}/export_theme"}{post}{requestBody} );
ok( defined $json{v7}{paths}{"/sites/{site_id}/export_theme"}{post}{requestBody} );

done_testing;
