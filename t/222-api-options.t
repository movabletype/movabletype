#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib extlib t/lib);

use Test::More;
use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

{
    ( my $base = __FILE__ ) =~ s/\.t$/.d/;
    $app->_init_plugins_core( {}, 1,
        [ File::Spec->join( $base, 'plugins' ) ] );
}

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[
        {   path             => '/v1/sites/1',
            method           => 'OPTIONS',
            author_id        => 2,
            response_headers => { Allow => 'GET, OPTIONS', },
        },
        {   path             => '/v1/sites/1/entries',
            method           => 'OPTIONS',
            author_id        => 2,
            response_headers => { Allow => 'GET, POST, OPTIONS', },
        },
        {   path             => '/v1/options-test',
            method           => 'OPTIONS',
            author_id        => 2,
            response_headers => {
                Allow            => undef,
                'X-OPTIONS-TEST' => 1,
            },
        },
    ];
}

