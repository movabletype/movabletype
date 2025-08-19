#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use JSON::Validator;
use MT::Test::Env;
our $test_env;

BEGIN {
    plan skip_all => 'JSON::Validator requires Perl 5.16' if $] < 5.016;

    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::App::DataAPI;
use MT::Test::DataAPI;

$test_env->prepare_fixture('db_data');

for my $version (1 .. MT::App::DataAPI::DEFAULT_VERSION) {
    my $suite = suite($version);
    test_data_api($suite);
}

done_testing;

sub suite {
    my ($version) = @_;
    return +[
        {   path   => "/v$version/",
            method => 'GET',
            code  => 200,
            complete => sub {
                my ($data, $body, $headers) = @_;
                my $body_json = MT::Util::from_json($body);
                my $jv = JSON::Validator->new->schema($body_json)->schema;
                isa_ok $jv, 'JSON::Validator::Schema::OpenAPIv3';
                is_deeply $jv->errors, [], 'No errors on v' . $version;
            },
        },
    ];
}
