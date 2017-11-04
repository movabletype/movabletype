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

$test_env->prepare_fixture('db_data');

my $app = MT::App::DataAPI->new;

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    +[    # Irregular tests.
        {   note   => 'Invalid dateFrom parameter.',
            path   => '/v3/sites/1/entries',
            method => 'GET',
            params => { dateFrom => 'invalid', },
            code   => 400,
            result => sub {
                +{  error => {
                        message => 'Invalid dateFrom parameter: invalid',
                        code    => 400,
                    }
                };
            },
        },
        {   note   => 'Invalid dateTo parameter.',
            path   => '/v3/sites/1/entries',
            method => 'GET',
            params => { dateTo => 'invalid', },
            code   => 400,
            result => sub {
                +{  error => {
                        message => 'Invalid dateTo parameter: invalid',
                        code    => 400,
                    }
                };
            },
        },
        {   note   => 'Date filter is enabled with Data API v3 or later.',
            path   => '/v2/sites/1/entries',
            method => 'GET',
            params => { dateTo => 'invalid', },
        },

        # Normal tests.
        {   note   => 'Filter by dateFrom parameter.',
            path   => '/v3/sites/1/entries',
            method => 'GET',
            params => { dateFrom => '1979-01-01', },
            result => sub {
                my @entries = MT->model('entry')->load(
                    { blog_id => 1, modified_on => \'>= 19790101000000' },
                    { sort => 'authored_on', direction => 'descend' },
                );
                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( \@entries ),
                };
            },
        },
        {   note   => 'Filter by dateTo parameter.',
            path   => '/v3/sites/1/entries',
            method => 'GET',
            params => { dateTo => '1962-12-31', },
            result => sub {
                my @entries = MT->model('entry')->load(
                    { blog_id => 1, modified_on => \'<= 19621231125959' },
                    { sort => 'authored_on', direction => 'descend' },
                );
                return +{
                    totalResults => 2,
                    items => MT::DataAPI::Resource->from_object( \@entries ),
                };
            },
        },
        {   note   => 'Filter by dateFrom parameter and dateTo parameter.',
            path   => '/v3/sites/1/entries',
            method => 'GET',
            params => { dateFrom => '1962-01-01', dateTo => '1965-12-31', },
            result => sub {
                my @entries = MT->model('entry')->load(
                    [   { blog_id     => 1, },
                        { modified_on => \'>= 19620101000000' },
                        { modified_on => \'<= 19651231125959' },
                    ],
                    { sort => 'authored_on', direction => 'descend' },
                );
                return +{
                    totalResults => 4,
                    items => MT::DataAPI::Resource->from_object( \@entries ),
                };
            },
        },
        {   note   => 'Filter by dateField parameter and dateFrom parameter.',
            path   => '/v3/sites/1/entries',
            method => 'GET',
            params =>
                { dateField => 'authored_on', dateFrom => '1979-01-01', },
            result => sub {

   #                my @entries = MT->model('entry')->load(
   #                    { blog_id => 1, authored_on => \'>= 19790101000000' },
   #                    { sort => 'authored_on', direction => 'descend' },
   #                );
                return +{
                    totalResults => 0,
                    items        => [],
                };
            },
        },
        {   note   => 'MT::Author can be filtered by dateFrom parameter.',
            path   => '/v3/users',
            method => 'GET',
            params => { dateFrom => '1979-01-01', },
            is_superuser => 1,
            result       => sub {
                my @authors = MT->model('author')->load(
                    { modified_on => \'>= 19790101000000', },
                    { sort        => 'name', direction => 'ascend' }
                );
                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( \@authors ),
                };
            },
        },
    ];
}
