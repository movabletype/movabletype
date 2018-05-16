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

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # export_entries - irregular tests.
        {    # Non-existent site.
            path   => '/v2/sites/10/entries/export',
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
        {    # System.
            path   => '/v2/sites/0/entries/export',
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
            path      => '/v2/sites/1/entries/export',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/entries/export',
            method       => 'GET',
            restrictions => { 1 => [qw/ export_blog /], },
            code         => 403,
            error        => 'You do not have export permissions',
        },

        # export_entries - normal tests.
        {    # Blog.
            path   => '/v2/sites/1/entries/export',
            method => 'GET',
        },
        {    # Whbsite.
            path   => '/v2/sites/2/entries/export',
            method => 'GET',
        },

        # import_entries - irregular tests.
        {    # Non-existent site.
            path   => '/v2/sites/10/entries/import',
            method => 'POST',
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
        {    # System.
            path   => '/v2/sites/0/entries/import',
            method => 'POST',
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
        {    # No file.
            path   => '/v2/sites/1/entries/import',
            method => 'POST',
            code   => 500,
            error  => qr/^An error occurred during the import process: /,
        },
        {    # import_as_me=0 and no password.
            path   => '/v2/sites/1/entries/import',
            method => 'POST',
            params => { import_as_me => 0 },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME},                      "t",
                    '277-api-endpoint-import-export.d', 'first_entry.txt'
                ),
            ],
            code   => 400,
            result => sub {
                return +{
                    error => {
                        code => 400,
                        message =>
                            'You need to provide a parameter "password" if you are going to create new users for each user listed in your blog.',
                    },
                };
            },
            complete => sub {
                my $entry = $app->model('entry')
                    ->load( { blog_id => 1, title => 'First Entry' } );
                is( $entry, undef, 'An entry has not been imported.' );
            },
        },
        {    # import_as_me=0 and invalid password.
            path   => '/v2/sites/1/entries/import',
            method => 'POST',
            params => {
                import_as_me => 0,
                password     => 123,
            },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME},                      "t",
                    '277-api-endpoint-import-export.d', 'first_entry.txt'
                ),
            ],
            code   => 400,
            result => sub {
                return +{
                    error => {
                        code => 400,
                        message =>
                            'Password should be longer than 8 characters',
                    },
                };
            },
            complete => sub {
                my $entry = $app->model('entry')
                    ->load( { blog_id => 1, title => 'First Entry' } );
                is( $entry, undef, 'An entry has not been imported.' );
            },
        },
        {    # Invalid import_type.
            path   => '/v2/sites/1/entries/import',
            method => 'POST',
            params => { import_type => 'invalid', },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME},                      "t",
                    '277-api-endpoint-import-export.d', 'first_entry.txt'
                ),
            ],
            code   => 400,
            result => sub {
                return +{
                    error => {
                        code    => 400,
                        message => 'Invalid import_type: invalid',
                    },
                };
            },
            complete => sub {
                my $entry = $app->model('entry')
                    ->load( { blog_id => 1, title => 'First Entry' } );
                is( $entry, undef, 'An entry has not been imported.' );
            },
        },
        {    # Invalid endoing.
            path   => '/v2/sites/1/entries/import',
            method => 'POST',
            params => { encoding => 'invalid', },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME},                      "t",
                    '277-api-endpoint-import-export.d', 'first_entry.txt'
                ),
            ],
            code   => 400,
            result => sub {
                return +{
                    error => {
                        code    => 400,
                        message => 'Invalid encoding: invalid',
                    },
                };
            },
            complete => sub {
                my $entry = $app->model('entry')
                    ->load( { blog_id => 1, title => 'First Entry' } );
                is( $entry, undef, 'An entry has not been imported.' );
            },
        },
        {    # Invalid convert_breaks.
            path   => '/v2/sites/1/entries/import',
            method => 'POST',
            params => { convert_breaks => 'invalid', },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME},                      "t",
                    '277-api-endpoint-import-export.d', 'first_entry.txt'
                ),
            ],
            code   => 400,
            result => sub {
                return +{
                    error => {
                        code    => 400,
                        message => 'Invalid convert_breaks: invalid',
                    },
                };
            },
            complete => sub {
                my $entry = $app->model('entry')
                    ->load( { blog_id => 1, title => 'First Entry' } );
                is( $entry, undef, 'An entry has not been imported.' );
            },
        },
        {    # Invalid default_cat_id.
            path   => '/v2/sites/1/entries/import',
            method => 'POST',
            params => { default_cat_id => 100, },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME},                      "t",
                    '277-api-endpoint-import-export.d', 'first_entry.txt'
                ),
            ],
            code   => 400,
            result => sub {
                return +{
                    error => {
                        code    => 400,
                        message => 'Invalid default_cat_id: 100',
                    },
                };
            },
            complete => sub {
                my $entry = $app->model('entry')
                    ->load( { blog_id => 1, title => 'First Entry' } );
                is( $entry, undef, 'An entry has not been imported.' );
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/1/entries/import',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/entries/import',
            method       => 'POST',
            restrictions => { 1 => [qw/ import_blog /], },
            code         => 403,
            error        => 'Do not have permission to import entries.',
        },

        # import_entries - normal tests.
        {    # Blog.
            path   => '/v2/sites/1/entries/import',
            method => 'POST',
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME},                      "t",
                    '277-api-endpoint-import-export.d', 'first_entry.txt'
                ),
            ],
            result => sub {
                return +{ status => 'success', };
            },
            complete => sub {
                my $entry = $app->model('entry')
                    ->load( { blog_id => 1, title => 'First Entry' } );
                ok( $entry, 'A entry has been imported.' );
            },
        },
        {    # Website.
            path   => '/v2/sites/2/entries/import',
            method => 'POST',
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME},                      "t",
                    '277-api-endpoint-import-export.d', 'second_entry.txt'
                ),
            ],
            result => sub {
                return +{ status => 'success', };
            },
            complete => sub {
                my $entry = $app->model('entry')
                    ->load( { blog_id => 2, title => 'Second Entry' } );
                ok( $entry, 'A entry has been imported.' );
            },
        },
        {    # import_as_me=0.
            path   => '/v2/sites/1/entries/import',
            method => 'POST',
            params => {
                import_as_me => 0,
                password     => 'password',
            },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME},                      "t",
                    '277-api-endpoint-import-export.d', 'third_entry.txt'
                ),
            ],
            result => sub {
                return +{ status => 'success', };
            },
            complete => sub {
                my $entry = $app->model('entry')
                    ->load( { blog_id => 1, title => 'Third Entry' } );
                ok( $entry, 'A entry has been imported.' );
            },
        },
        {    # import_type=import_mt_format.
            path   => '/v2/sites/1/entries/import',
            method => 'POST',
            params => { import_type => 'import_mt_format', },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME},                      "t",
                    '277-api-endpoint-import-export.d', 'fourth_entry.txt'
                ),
            ],
            result => sub {
                return +{ status => 'success', };
            },
            complete => sub {
                my $entry = $app->model('entry')
                    ->load( { blog_id => 1, title => 'Fourth Entry' } );
                ok( $entry, 'A entry has been imported.' );
            },
        },

    ];
}

