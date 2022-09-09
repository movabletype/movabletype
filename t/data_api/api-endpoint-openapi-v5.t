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

my %json;
test_data_api({
        path     => "/v5/",
        method   => 'GET',
        code     => 200,
        complete => sub {
            my ($data, $body, $headers) = @_;
            $json{v5} = MT::Util::from_json($body);
        },
    },
);

for my $prop (qw/assets categories/) {
    is_deeply(
        $json{v5}{components}{schemas}{entry_updatable}{properties}{$prop},
        {
            type  => 'array',
            items => {
                type       => 'object',
                properties => {
                    id => { type => 'integer' },
                },
            },
        },
        "entry_updatable has $prop property"
    );
    ok(!exists $json{v5}{components}{schemas}{page_updatable}{properties}{$prop}, "page_updatable does not have $prop property");
}

done_testing;
