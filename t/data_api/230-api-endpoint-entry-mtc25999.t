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
use MT::Test::Permission;

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[
        {   path   => '/v2/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    title           => 'test-api-permission-entry',
                    status          => 'Publish',
                    unpublishedDate => '2020-01-01 00:00:00',
                },
            },
            complete => sub {
                my ( $data, $body ) = @_;
                require MT::Entry;
                my $entry = MT->model('entry')->load(
                    {   title  => 'test-api-permission-entry',
                        status => MT::Entry::RELEASE(),
                    }
                );
                is( $entry->unpublished_on => '20200101000000' );
            },
        },
        {   path   => '/v2/sites/1/entries',
            method => 'POST',
            params => {
                entry => {
                    title           => 'test-api-permission-entry-empty',
                    status          => 'Publish',
                    unpublishedDate => '',
                },
            },
            complete => sub {
                my ( $data, $body ) = @_;
                require MT::Entry;
                my $entry = MT->model('entry')->load(
                    {   title  => 'test-api-permission-entry-empty',
                        status => MT::Entry::RELEASE(),
                    }
                );
                is( $entry->unpublished_on => undef );
            },
        },
        {   path   => '/v2/sites/1/entries/1',
            method => 'PUT',
            params => {
                entry => { unpublishedDate => '2038-01-01 00:00:00' },
            },
            complete => sub {
                my ( $data, $body ) = @_;
                is( MT->model('entry')->load(1)->unpublished_on => '20380101000000' );
            },
        },
        {   path   => '/v2/sites/1/entries/1',
            method => 'PUT',
            params => {
                entry => { unpublishedDate => '' },
            },
            complete => sub {
                my ( $data, $body ) = @_;
                is( MT->model('entry')->load(1)->unpublished_on => undef );
            },
        },
    ];
}

