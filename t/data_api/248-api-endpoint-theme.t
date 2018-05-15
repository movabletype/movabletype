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

        # list_themes - irregular tests.
        {    # Not logged in.
            path      => '/v2/themes',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/themes',
            method       => 'GET',
            restrictions => { 0 => [qw/ open_theme_listing_screen /], },
            code         => 403,
            error =>
                'Do not have permission to retrieve the requested themes.',
        },

        # list_themes - normal tests
        {   path   => '/v2/themes',
            method => 'GET',
        },

        # list_themes_for site - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/5/themes',
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
            path      => '/v2/sites/2/themes',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions (site).
            path         => '/v2/sites/2/themes',
            method       => 'GET',
            restrictions => {
                0 => [qw/ open_theme_listing_screen /],
                2 => [qw/ open_theme_listing_screen /],
            },
            code => 403,
            error =>
                'Do not have permission to retrieve the requested site\'s themes.',
        },
        {    # No permissions (system).
            path         => '/v2/sites/0/themes',
            method       => 'GET',
            restrictions => { 0 => [qw/ open_theme_listing_screen /], },
            code         => 403,
            error =>
                'Do not have permission to retrieve the requested site\'s themes.',
        },

        # list_themes_for_site - normal tests
        {    # Website.
            path   => '/v2/sites/2/themes',
            method => 'GET',
        },
        {    # Blog.
            path   => '/v2/sites/1/themes',
            method => 'GET',
        },
        {    # System. Same as list_themes endpoint.
            path   => '/v2/sites/0/themes',
            method => 'GET',
        },

        # get_theme - irregular tests
        {    # Non-existent theme.
            path   => '/v2/themes/non_existent_theme',
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Theme not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/themes/classic_website',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/themes/classic_website',
            method       => 'GET',
            restrictions => { 0 => [qw/ open_theme_listing_screen /], },
            code         => 403,
            error =>
                'Do not have permission to retrieve the requested theme.',
        },

        # get_theme - normal tests
        {   path   => '/v2/themes/classic_website',
            method => 'GET',
            result => sub {
                require MT::Theme;
                my $theme = MT::Theme->load('classic_website');

                return $theme->to_resource();
            },
        },

        # get_theme_for_site - normal tests
        {    # Website.
            path   => '/v2/sites/2/themes/classic_website',
            method => 'GET',
            result => sub {
                require MT::Theme;
                my $theme = MT::Theme->load('classic_website');

                return $theme->to_resource();
            },
        },
        {    # Blog.
            path   => '/v2/sites/1/themes/classic_blog',
            method => 'GET',
            result => sub {
                require MT::Theme;
                my $theme = MT::Theme->load('classic_blog');

                return $theme->to_resource();
            },
        },
        {   path   => '/v2/sites/0/themes/classic_website',
            method => 'GET',
            result => sub {
                require MT::Theme;
                my $theme = MT::Theme->load('classic_website');

                return $theme->to_resource();
            },
        },

        # get_theme_for_site - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/10/themes/classic_blog',
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
        {    # Non-existent theme.
            path   => '/v2/sites/2/themes/non_existent_theme',
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Theme not found',
                    },
                };
            },
        },
        {    # get website theme via blog.
            path   => '/v2/sites/1/themes/classic_website',
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Theme not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/0/themes/classic_website',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions (site).
            path         => '/v2/sites/2/themes/classic_website',
            method       => 'GET',
            restrictions => {
                0 => [qw/ open_theme_listing_screen /],
                2 => [qw/ open_theme_listing_screen /],
            },
            code => 403,
            error =>
                'Do not have permission to retrieve the requested site\'s theme.',
        },
        {    # No permissions (system).
            path         => '/v2/sites/0/themes/classic_website',
            method       => 'GET',
            restrictions => { 0 => [qw/ open_theme_listing_screen /], },
            code         => 403,
            error =>
                'Do not have permission to retrieve the requested site\'s theme.',
        },

        # apply_theme_to_site - normal tests
        {    # Website.
            path  => '/v2/sites/2/themes/pico/apply',
            setup => sub {
                my $site = MT->model('blog')->load(2);
                die if $site->theme_id eq 'pico';
            },
            method   => 'POST',
            complete => sub {
                my $site = MT->model('blog')->load(2);
                is( $site->theme_id, 'pico', 'Changed into pico.' );
            },
        },
        {    # Blog.
            path  => '/v2/sites/1/themes/pico/apply',
            setup => sub {
                my $site = MT->model('blog')->load(1);
                die if $site->theme_id eq 'pico';
            },
            method   => 'POST',
            complete => sub {
                my $site = MT->model('blog')->load(1);
                is( $site->theme_id, 'pico', 'Changed into pico.' );
            },
        },

        # apply_theme_to_site - irregular tests
        {    # system scope.
            path   => '/v2/sites/0/themes/pico/apply',
            method => 'POST',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Non-existent site.
            path   => '/v2/sites/10/themes/pico/apply',
            method => 'POST',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Non-existent theme.
            path   => '/v2/sites/2/themes/non_existent_theme/apply',
            method => 'POST',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Theme not found',
                    },
                };
            },
        },
        {    # Non-existent site and non-existent theme.
            path   => '/v2/sites/5/themes/non_existent_theme/apply',
            method => 'POST',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Try to apply website theme to blog.
            path   => '/v2/sites/1/themes/classic_website/apply',
            method => 'POST',
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'Cannot apply website theme to blog.',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/2/themes/pico/apply',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/2/themes/pico/apply',
            method       => 'POST',
            restrictions => {
                0 => [qw/ apply_theme /],
                2 => [qw/ apply_theme /],
            },
            code => 403,
            error =>
                'Do not have permission to apply the requested theme to site.',
        },

        # export_site_theme - normal tests
        {   path   => '/v2/sites/2/export_theme',
            method => 'POST',
            params => { overwrite_yes => 1, },
            result => sub {
                +{ status => 'success' };
            },
        },

        # export_site_theme - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/5/export_theme',
            method => 'POST',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # System.
            path   => '/v2/sites/0/export_theme',
            method => 'POST',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Already exists.
            path   => '/v2/sites/2/export_theme',
            method => 'POST',
            code   => 409,
        },
        {    # Not logged in.
            path      => '/v2/sites/5/export_theme',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/2/export_theme',
            method       => 'POST',
            restrictions => {
                0 => [qw/ do_export_theme /],
                2 => [qw/ do_export_theme /],
            },
            code  => 403,
            error => 'Do not have permission to export the requested theme.',
        },

        # uninstall_theme - irregular tests
        {    # Protected.
            path   => '/v2/themes/classic_website',
            method => 'DELETE',
            code   => 403,
            result => sub {
                +{  error => {
                        code    => 403,
                        message => 'Cannot uninstall this theme.',
                    },
                };
            },
        },
        {    # Non-existent theme.
            path   => '/v2/themes/non_existent_theme',
            method => 'DELETE',
            code   => 404,
            error  => 'Theme not found',
        },
    ];
}

