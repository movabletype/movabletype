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

# preparation.
{
    my $author = $app->model('author')->load(1);

    my $website_entry = $app->model('entry')->new;
    $website_entry->set_values(
        {   blog_id   => 2,
            author_id => 1,
            status    => 1,
        }
    );
    $website_entry->save or die $website_entry->errstr;

    my $website = $app->model('website')->load(2) or die;
    my $role = $app->model('role')->load( { name => 'Site Administrator' } )
        or die;

    require MT::Association;
    MT::Association->link( $author, $website, $role );
}

# test.
my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # No restriction.
        {
            # superuser.
            # blog.
            path         => '/v2/sites/1/entries',
            method       => 'GET',
            is_superuser => 1,
            complete     => sub {
                my ( $data, $body ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( $got->{totalResults}, 8,
                    'No restriction, superuser, blog.' );
            },
        },
        {
            # superuser.
            # website.
            path         => '/v2/sites/2/entries',
            method       => 'GET',
            is_superuser => 1,
            complete     => sub {
                my ( $data, $body ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( $got->{totalResults}, 1,
                    'No restriction, superuser, website.' );
            },
        },
        {
            # superuser.
            # system.
            path         => '/v2/sites/0/entries',
            method       => 'GET',
            is_superuser => 1,
            complete     => sub {
                my ( $data, $body ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( $got->{totalResults}, 9,
                    'No restriction, superuser, system.' );
            },
        },
        {
            # non-superuser.
            # blog.
            path     => '/v2/sites/1/entries',
            method   => 'GET',
            complete => sub {
                my ( $data, $body ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( $got->{totalResults}, 8,
                    'No restriction, non-superuser, blog.' );
            },
        },
        {
            # non-superuser.
            # website.
            path     => '/v2/sites/2/entries',
            method   => 'GET',
            complete => sub {
                my ( $data, $body ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( $got->{totalResults}, 1,
                    'No restriction, non-superuser, website.' );
            },
        },
        {
            # non-superuser.
            # system.
            path     => '/v2/sites/0/entries',
            method   => 'GET',
            complete => sub {
                my ( $data, $body ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( $got->{totalResults}, 9,
                    'No restriction, non-superuser, system.' );
            },
        },

        # Restriction (blog_id=1 is disabled).
        {
            # superuser.
            # blog.
            path         => '/v2/sites/1/entries',
            method       => 'GET',
            is_superuser => 1,
            setup        => sub {
                $app->config->DataAPIDisableSite(1);
                $app->config->save_config;
            },
            complete => sub {
                my ( $data, $body ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( $got->{totalResults}, 8,
                    'Restriction, superuser, blog.' );
            },
        },
        {
            # superuser.
            # website.
            path         => '/v2/sites/2/entries',
            method       => 'GET',
            is_superuser => 1,
            complete     => sub {
                my ( $data, $body ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( $got->{totalResults}, 1,
                    'Restriction, superuser, website.' );
            },
        },
        {
            # superuser.
            # system.
            path         => '/v2/sites/0/entries',
            method       => 'GET',
            is_superuser => 1,
            complete     => sub {
                my ( $data, $body ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( $got->{totalResults}, 9,
                    'Restriction, superuser, system.' );
            },
        },
        {
            # non-superuser.
            # blog.
            path   => '/v2/sites/1/entries',
            method => 'GET',
            code   => 403,
        },
        {
            # non-superuser.
            # website.
            path     => '/v2/sites/2/entries',
            method   => 'GET',
            complete => sub {
                my ( $data, $body ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( $got->{totalResults}, 1,
                    'Restriction, non-superuser, website.' );
            },
        },
        {
            # non-superuser.
            # system.
            path     => '/v2/sites/0/entries',
            method   => 'GET',
            complete => sub {
                my ( $data, $body ) = @_;
                my $got = $app->current_format->{unserialize}->($body);
                is( $got->{totalResults}, 1,
                    'Restriction, non-superuser, system.' );
            },
        },
    ];
}

