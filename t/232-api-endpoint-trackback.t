#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib extlib t/lib);

use Test::More;
use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $author = MT->model('author')->load(2);

my $suite = suite();
test_data_api(@$suite);

done_testing;

sub suite {
    return +[
        {   path      => '/v1/sites/1/trackbacks',
            method    => 'GET',
            author_id => 2,
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.ping',
                    count => 2,
                },
            ],
        },
        {   path      => '/v1/sites/1/entries/1/trackbacks',
            method    => 'GET',
            author_id => 2,
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.ping',
                    count => 2,
                },
            ],
        },
        {   path      => '/v1/sites/1/trackbacks/1',
            method    => 'GET',
            author_id => 2,
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.ping',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('ping')->load(1);
            },
        },
        {   path      => '/v1/sites/1/trackbacks/1',
            method    => 'PUT',
            author_id => 2,
            params    => { trackback => { status => 'Pending' } },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.ping',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.ping',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.ping',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.ping',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('ping')->load(
                    {   id      => 1,
                        visible => 0,
                    }
                );
            },
        },
        {   path      => '/v1/sites/1/trackbacks/1',
            method    => 'DELETE',
            author_id => 2,
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.ping',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_delete.ping',
                    count => 1,
                },
            ],
            complete => sub {
                my $deleted = MT->model('ping')->load(1);
                is( $deleted, undef, 'deleted' );
            },
        },
    ];
}

