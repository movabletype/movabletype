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
use MT::Test::Permission;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $author = MT->model('author')->load(2);

my $unpublished_page = MT::Test::Permission->make_page(
    blog_id => 1,
    status  => 1,
);

my $suite = suite();
test_data_api($suite);

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

        # version 2

        # list_trackbacks_for_page - irregular tests.
        {    # Non-existent page.
            path   => '/v2/sites/1/pages/230/trackbacks',
            method => 'GET',
            code   => 404,
            error  => 'Page not found',
        },
        {    # Entry.
            path   => '/v2/sites/1/pages/1/trackbacks',
            method => 'GET',
            code   => 404,
            error  => 'Page not found',
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/pages/23/trackbacks',
            method => 'GET',
            code   => 404,
            error  => 'Site not found',
        },
        {    # System.
            path   => '/v2/sites/0/pages/23/trackbacks',
            method => 'GET',
            code   => 404,
            error  => 'Page not found',
        },
        {    # Unpublished page and not logged in.
            path => '/v2/sites/1/pages/'
                . $unpublished_page->id
                . '/trackbacks',
            method    => 'GET',
            author_id => 0,
            code      => 403,
            error =>
                'Do not have permission to retrieve the list of trackbacks.',
        },
        {    # Unpublished page and no permissions.
            path => '/v2/sites/1/pages/'
                . $unpublished_page->id
                . '/trackbacks',
            method       => 'GET',
            restrictions => { 1 => [qw/ open_page_edit_screen /], },
            code         => 403,
            error =>
                'Do not have permission to retrieve the list of trackbacks.',
        },

        # list_trackbacks_for_page - normal tests.
        {   path   => '/v2/sites/1/pages/23/trackbacks',
            method => 'GET',
            result => sub {
                my $tbping = $app->model('tbping')->load(3);
                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( [$tbping] ),
                };
            },
        },
    ];
}

