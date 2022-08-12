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

$test_env->prepare_fixture('db_data');

my %json;
test_data_api({
        path     => "/v4/",
        method   => 'GET',
        code     => 200,
        complete => sub {
            my ($data, $body, $headers) = @_;
            $json{v4} = MT::Util::from_json($body);
        },
    },
);
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

for my $name (qw/asset blog cf content_type group log permission template templatemap user website/) {
    is($json{v4}{components}{schemas}{$name}{properties}{id}{type}, 'string', "$name id is string type in v4");
    is($json{v5}{components}{schemas}{$name}{properties}{id}{type}, 'integer', "$name id is integer type in v5");
}

# entry / page
for my $component (qw/entry page/) {
    is($json{v4}{components}{schemas}{$component}{properties}{author}{properties}{id}{type}, 'string', "$component author/id is string type in v4");
    is($json{v5}{components}{schemas}{$component}{properties}{author}{properties}{id}{type}, 'integer', "$component author/id is integer type in v5");
}

done_testing;
