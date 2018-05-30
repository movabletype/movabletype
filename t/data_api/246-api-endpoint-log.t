#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
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

# preparation.
my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

# test.
my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # create_log - irregular tests
        {    # No resource.
            path   => '/v2/sites/1/logs',
            method => 'POST',
            code   => 400,
            error  => "A resource \"log\" is required.",
        },
        {    # No message.
            path   => '/v2/sites/1/logs',
            method => 'POST',
            params => { log => {} },
            code   => 409,
            error  => "A parameter \"message\" is required.\n",
        },
        {    # Not logged in.
            path      => '/v2/sites/1/logs',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/logs',
            method       => 'POST',
            params       => { log => { message => 'create-log-site-1', }, },
            restrictions => {
                0 => [qw/ view_log /],
                1 => [qw/ view_blog_log /],
            },
            code  => 403,
            error => 'Do not have permission to create a log.',
        },

        # create_log - normal tests
        {   path      => '/v2/sites/1/logs',
            method    => 'POST',
            params    => { log => { message => 'create-log-site-1', }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.log',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.log',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.log',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.log',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('log')
                    ->load(
                    { blog_id => 1, message => 'create-log-site-1' } );
            },
        },
        {   path   => '/v2/sites/1/logs',
            method => 'POST',
            params => {
                log => {
                    message  => 'create-log-site-1-with-params',
                    metadata => 'metadata',
                    by       => { id => 1 },
                    level    => 'DEBUG',
                    category => 'entry',
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.log',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.log',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.log',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.log',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('log')->load(
                    {   class   => '*',
                        blog_id => 1,
                        message => 'create-log-site-1-with-params'
                    }
                );
            },
        },

        # get_log - irregular tests.
        {    # Non-existent log.
            path   => '/v2/sites/1/logs/10',
            method => 'GET',
            code   => 404,
            error  => 'Log not found',
        },
        {    # Non-existent site.
            path   => '/v2/sites/10/logs/1',
            method => 'GET',
            code   => 404,
            error  => 'Site not found',
        },
        {    # Other site.
            path   => '/v2/sites/2/logs/1',
            method => 'GET',
            code   => 404,
            error  => 'Log not found',
        },
        {    # Other site (system).
            path   => '/v2/sites/0/logs/1',
            method => 'GET',
            code   => 404,
            error  => 'Log not found',
        },
        {    # Not logged in.
            path      => '/v2/sites/1/logs/1',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/logs/1',
            method       => 'GET',
            restrictions => {
                0 => [qw/ view_log /],
                1 => [qw/ view_blog_log /],
            },
            code  => 403,
            error => 'Do not have permission to retrieve the requested log.',
        },

        # get_log - normal tests.
        {   path   => '/v2/sites/1/logs/1',
            method => 'GET',
            result => sub { $app->model('log')->load(1) },
        },

        # list_logs - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/5/logs',
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/1/logs',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },

        # list_logs - normal tests
        {   path      => '/v2/sites/1/logs',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.log',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;

                my $got_logs = $app->current_format->{unserialize}->($body);
                my @expected_logs
                    = MT->model('log')->load( { class => '*', blog_id => 1 },
                    { sort => 'created_on', direction => 'descend' } );

                my @got_log_ids = map { $_->{id} } @{ $got_logs->{items} };
                my @expected_log_ids = map { $_->id } @expected_logs;

                is_deeply( \@got_log_ids, \@expected_log_ids,
                    'IDs of items are "' . "@got_log_ids" . '"' );
            },
        },

        {    # System.
            path      => '/v2/sites/0/logs',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.log',
                    count => 2,
                },
            ],
            result => sub {
                my @logs = $app->model('log')->load( { class => '*' },
                    { sort => 'created_on', direction => 'descend' } );
                return +{
                    totalResults => scalar @logs,
                    items => MT::DataAPI::Resource->from_object( \@logs ),
                };
            },
        },
        {    # Search message.
            path      => '/v2/sites/1/logs',
            method    => 'GET',
            params    => { search => 'with-param', },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.log',
                    count => 2,
                },
            ],
            result => sub {
                $app->user($author);

                my @logs = $app->model('log')->load(
                    {   blog_id => 1,
                        message => { like => '%with-param%' },
                    }
                );

                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( \@logs ),
                };
            },
        },
        {    # Search ip.
            path   => '/v2/sites/1/logs',
            method => 'GET',
            params => { search => '192.168', },
            setup  => sub {
                my $log = $app->model('log')->load( { blog_id => 1 } );
                $log->ip('192.168.56.1');
                $log->save or die $log->errstr;
            },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.log',
                    count => 2,
                },
            ],
            result => sub {
                $app->user($author);

                my @logs = $app->model('log')->load(
                    {   blog_id => 1,
                        ip      => { like => '%192.168%' },
                    }
                );

                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( \@logs ),
                };
            },
        },
        {    # Filter by level (info).
            path      => '/v2/sites/1/logs',
            method    => 'GET',
            params    => { level => 'info', },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.log',
                    count => 2,
                },
            ],
            result => sub {
                $app->user($author);

                my @logs = $app->model('log')->load(
                    {   blog_id => 1,
                        level   => MT::Log::INFO(),
                    }
                );

                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( \@logs ),
                };
            },
        },
        {    # Filter by level (error).
            path      => '/v2/sites/1/logs',
            method    => 'GET',
            params    => { level => 'error', },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.log',
                    count => 1,
                },
            ],
            result => sub {
                $app->user($author);

                my @logs = $app->model('log')->load(
                    {   blog_id => 1,
                        level   => MT::Log::ERROR(),
                    }
                );

                return +{
                    totalResults => 0,
                    items => MT::DataAPI::Resource->from_object( \@logs ),
                };
            },
        },
        {    # Sort by blog_id.
            path         => '/v2/sites/0/logs',
            method       => 'GET',
            params       => { sortBy => 'blog_id', },
            is_superuser => 1,
        },
        {    # Sort by author_id.
            path   => '/v2/sites/1/logs',
            method => 'GET',
            params => { sortBy => 'author_id', },
        },
        {    # Sort by level.
            path   => '/v2/sites/1/logs',
            method => 'GET',
            params => { sortBy => 'level', },
        },
        {    # Sort by class.
            path   => '/v2/sites/1/logs',
            method => 'GET',
            params => { sortBy => 'class', },
        },
        {    # Sort by id.
            path   => '/v2/sites/1/logs',
            method => 'GET',
            params => { sortBy => 'id', },
        },

        # export_log - irregular tests.
        {    # Non-existent site.
            path   => '/v2/sites/10/logs/export',
            method => 'GET',
            code   => 404,
            result => sub {
                return +{
                    error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/1/logs/export',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },

        # wrong encoding parameter.
        {   path   => '/v2/sites/1/logs/export',
            method => 'GET',
            params => { encoding => 'WinLatin1', },
            code   => 400,
            result => sub {
                return +{
                    error => {
                        message => 'Invalid encoding: WinLatin1',
                        code    => 400
                    }
                };
            },
        },
        {   path   => '/v2/sites/1/logs/export',
            method => 'GET',
            params => { encoding => 'guess', },
            code   => 400,
            result => sub {
                return +{
                    error => {
                        message => 'Invalid encoding: guess',
                        code    => 400
                    }
                };
            },
        },

        # No permissions.

        # export_log - normal tests.
        {    # Blog.
            path     => '/v2/sites/1/logs/export',
            method   => 'GET',
            complete => sub {
                my ( $data, $body ) = @_;
                my @line = split /\n/, $body;
                is( scalar @line, 4, '3 lines are output.' );
                print $_[1];
            },
        },
        {    # Website.
            path   => '/v2/sites/2/logs/export',
            method => 'GET',
            setup  => sub {
                my $log = $app->model('log')->new;
                $log->set_values( { blog_id => 2, } );
                $log->save or die $log->errstr;
            },
            complete => sub {
                my ( $data, $body ) = @_;
                my @line = split /\n/, $body;
                is( scalar @line, 5, '4 lines are output.' );
                print $_[1];
            },
        },
        {    # System.
            path   => '/v2/sites/0/logs/export',
            method => 'GET',
            setup  => sub {
                my $log = $app->model('log')->new;
                $log->set_values( { blog_id => 0, } );
                $log->save or die $log->errstr;
            },
            complete => sub {
                my ( $data, $body ) = @_;
                my @line = split /\n/, $body;
                is( scalar @line, 6, '5 lines are output.' );
                print $_[1];
            },
        },
        {    # encoding=utf8.
            path   => '/v2/sites/0/logs/export',
            method => 'GET',
            params => { encoding => 'utf8' },
        },
        {    # encoding=ascii.
            path   => '/v2/sites/0/logs/export',
            method => 'GET',
            params => { encoding => 'ascii' },
        },

        # update_log - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/10/logs/1',
            method => 'PUT',
            params => { log => { message => 'update-log-site-1', }, },
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Non-existent log.
            path   => '/v2/sites/1/logs/10',
            method => 'PUT',
            params => { log => { message => 'update-log-site-1', }, },
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Log not found',
                    },
                };
            },
        },
        {    # Other site.
            path   => '/v2/sites/2/logs/1',
            method => 'PUT',
            params => { log => { message => 'update-log-site-1', }, },
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Log not found',
                    },
                };
            },
        },
        {    # Other site (system).
            path   => '/v2/sites/0/logs/1',
            method => 'PUT',
            params => { log => { message => 'update-log-site-1', }, },
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Log not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/1/logs/1',
            method    => 'PUT',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/logs/1',
            method       => 'PUT',
            restrictions => {
                0 => [qw/ view_log /],
                1 => [qw/ view_blog_log /],
            },
            params => { log => { message => 'update-log-site-1', }, },
            code   => 403,
            error => 'Do not have permission to update a log.',
        },

        # update_log - normal tests
        {   path   => '/v2/sites/1/logs/1',
            method => 'PUT',
            setup  => sub {
                MT->model('log')->load(1)
                    and !MT->model('log')
                    ->load(
                    { class => '*', message => 'update-log-site-1' } );
            },
            params    => { log => { message => 'update-log-site-1', }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.log',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.log',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.log',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.log',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('log')
                    ->load(
                    { message => 'update-log-site-1', blog_id => 1, } );
            },
        },

        # delete_log - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/10/logs/1',
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Non-existent log.
            path   => '/v2/sites/1/logs/10',
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Log not found',
                    },
                };
            },
        },
        {    # Other site.
            path   => '/v2/sites/2/logs/1',
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Log not found',
                    },
                };
            },
        },
        {    # Other site (system).
            path   => '/v2/sites/0/logs/1',
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Log not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/1/logs/1',
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/logs/1',
            method       => 'DELETE',
            restrictions => {
                0 => [qw/ reset_system_log /],
                1 => [qw/ reset_blog_log /],
            },
            code  => 403,
            error => 'Do not have permission to delete a log.',
        },

        # delete_log - normal tests
        {   path      => '/v2/sites/1/logs/1',
            method    => 'DELETE',
            setup     => sub { MT->model('log')->load(1) or die },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.log',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_delete.log',
                    count => 1,
                },
            ],
            complete => sub {
                is( MT->model('log')->load(1),
                    undef, 'A log (ID:1) was deleted.' );
            },
        },

        # reset_logs - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/10/logs',
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/0/logs',
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions (blog).
            path         => '/v2/sites/1/logs',
            method       => 'DELETE',
            restrictions => { 1 => [qw/ reset_blog_log /], },
            code         => 403,
            error        => 'Do not have permission to reset logs.',
        },
        {    # No permissions (system).
            path         => '/v2/sites/0/logs',
            method       => 'DELETE',
            restrictions => {
                0 => [qw/ reset_system_log reset_blog_log /],
                1 => [qw/ reset_blog_log /],
                2 => [qw/ reset_blog_log /],
            },
            code  => 403,
            error => 'Do not have permission to reset logs.',
        },

        # reset_logs - normal tests
        {    # Blog.
            path   => '/v2/sites/1/logs',
            method => 'DELETE',
            setup  => sub {
                ok( MT->model('log')->exist( { class => '*', blog_id => 1 } ),
                    'Logs in blog (blog_id=1) exists.'
                );
            },
            result => sub {
                +{ status => 'success' };
            },
            complete => sub {
                my @logs = MT->model('log')
                    ->load( { class => '*', blog_id => 1 } );
                is( scalar @logs, 1, 'There is one log.' );
                is( $logs[0]->category, 'reset_log',
                    'All logs except reset_log were deleted.' );
            },
        },
        {    # System.
            path   => '/v2/sites/0/logs',
            method => 'DELETE',
            setup  => sub {
                ok( MT->model('log')->exist( { class => '*' } ),
                    'Logs on all sites exists.' );
            },
            result => sub {
                +{ status => 'success' };
            },
            complete => sub {
                my @logs = MT->model('log')->load( { class => '*' } );
                is( scalar @logs, 1, 'There is one log.' );
                is( $logs[0]->category, 'reset_log',
                    'All logs except reset_log were deleted.' );
            },
        },
    ];
}

