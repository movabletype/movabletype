#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib extlib t/lib);

use Test::More;
use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $suite = suite();
test_data_api(@$suite);

done_testing;

sub suite {
    return +[
        {   path      => '/v2/sites/1/entries/6/categories',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.category',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;
                require MT::Util;
                my $result = MT::Util::from_json($body);
                is( $result->{totalResults}, 1, 'Has 1 category.' );
                is( $result->{items}[0]{id}, 1, 'Category ID is 1.' );
            },
        },
        {   path      => '/v2/sites/1/entries/5/categories',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.category',
                    count => 1,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;
                require MT::Util;
                my $result = MT::Util::from_json($body);
                is( $result->{totalResults}, 0, 'Has no category.' );
            },
        },
        {   path     => '/v2/sites/1/entries/10/categories',
            method   => 'GET',
            code     => 404,
            complete => sub {
                my ( $data, $body ) = @_;
                require MT::Util;
                my $result = MT::Util::from_json($body);
                is( $result->{error}{message},
                    'Entry not found',
                    'Error message: Entry not found'
                );
            },
        },
    ];
}

