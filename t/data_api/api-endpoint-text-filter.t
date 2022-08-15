use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use Test::More;
use MT::Test::Env;

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::DataAPI;

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

test_data_api({
    path     => "/v5/textFilters",
    method   => 'GET',
    complete => sub {
        my ($data, $body) = @_;
        my $got = $app->current_format->{unserialize}->($body);
        my @got_keys;
        for my $item (@{ $got->{items} }) {
            push @got_keys, $item->{key};
        }
        my $filters = $app->all_text_filters();
        is(scalar(keys(%$filters)) + 1, $got->{totalResults}, 'Count text filters');
        is_deeply(['0', keys(%$filters)], \@got_keys, 'Compare filter keys');
    },
});

done_testing;
