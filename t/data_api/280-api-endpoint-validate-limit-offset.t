#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use Test::MockModule;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::DataAPI;
use MT::Test::Permission;
use File::Path 'remove_tree';

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $blog = $app->model('blog')->load;
my $blog_folder = $app->model('folder')->load( { blog_id => $blog->id, } );

my $mock_stats = Test::MockModule->new('MT::Stats');
$mock_stats->mock( 'readied_provider', sub {1} );

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # list_entries_for_category - limit
        {   path   => '/v2/sites/1/categories/1/entries',
            method => 'GET',
            params => { limit => 'a', },
            code   => 500,
            error  => qr/Invalid parameter./,
        },

        # list_entries_for_category - offset
        {   path   => '/v2/sites/1/categories/1/entries',
            method => 'GET',
            params => { offset => 'a', },
            code   => 500,
            error  => qr/Invalid parameter./,
        },

        # list_pages_for_folder - limit
        {   path   => '/v2/sites/1/folders/' . $blog_folder->id . '/pages',
            method => 'GET',
            params => { limit => 'a', },
            code   => 500,
            error  => qr/Invalid parameter./,
        },

        # list_pages_for_folder - offset
        {   path   => '/v2/sites/1/folders/' . $blog_folder->id . '/pages',
            method => 'GET',
            params => { offset => 'a', },
            code   => 500,
            error  => qr/Invalid parameter./,
        },

        # permission - limit
        {   path         => '/v1/users/2/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { limit => 'a', },
            code         => 500,
            error        => qr/Invalid parameter./,
        },

        # permission - offset
        {   path         => '/v1/users/2/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { offset => 'a', },
            code         => 500,
            error        => qr/Invalid parameter./,
        },

        # stats - limit
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { limit => 'a', },
            code   => 500,
            error  => qr/Invalid parameter./,
        },

        # stats - offset
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { offset => 'a', },
            code   => 500,
            error  => qr/Invalid parameter./,
        },
    ];
}

