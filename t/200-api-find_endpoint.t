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


BEGIN {
    use Test::More;
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

use lib qw(lib extlib t/lib);
use MT::Test ();
use MT;
use MT::App::DataAPI;

my $mock = Test::MockModule->new('MT::App::DataAPI');
$mock->mock(
    'core_endpoints',
    sub {
        return [
            {   id      => 'get_entry',
                route   => '/sites/:site_id/entries/:entry_id',
                version => 1,
            },
            {   id      => 'get_entry',
                route   => '/sites/:site_id/entries/:entry_id',
                version => 2,
            },
            {   id      => 'create_entry',
                route   => '/sites/:site_id/entries',
                verb    => 'POST',
                version => 1,
            },
            {   id      => 'update_entry',
                route   => '/sites/:site_id/entries/:entry_id',
                verb    => 'PUT',
                version => 1,
            },
            {   id      => 'delete_entry',
                route   => '/sites/:site_id/entries/:entry_id',
                verb    => 'DELETE',
                version => 1,
            },
            {   id      => 'get_some_resources_of_entry',
                route   => '/sites/:site_id/entries/:entry_id/resources',
                format  => 'html',
                version => 2,
            },
        ];
    }
);

my $app = MT::App::DataAPI->new;

my @suite = (
    {   request  => [ 'GET', 1, '/sites/2/entries/3' ],
        id       => [ 1,     'get_entry' ],
        endpoint => {
            id      => 'get_entry',
            version => 1,
        },
        params => {
            site_id  => 2,
            entry_id => 3,
        }
    },
    {   request  => [ 'GET', 1, '/sites/2/entries/3.xml' ],
        id       => [ 1,     'get_entry' ],
        endpoint => {
            id      => 'get_entry',
            version => 1,
        },
        params => {
            format   => 'xml',
            site_id  => 2,
            entry_id => 3,
        }
    },
    {   request  => [ 'GET', 2, '/sites/2/entries/3' ],
        id       => [ 2,     'get_entry' ],
        endpoint => {
            id      => 'get_entry',
            version => 2,
        },
        params => {
            site_id  => 2,
            entry_id => 3,
        }
    },
    {   request  => [ 'GET', 3, '/sites/2/entries/3' ],
        id       => [ 3,     'get_entry' ],
        endpoint => {
            id      => 'get_entry',
            version => 2,
        },
        params => {
            site_id  => 2,
            entry_id => 3,
        }
    },
    {   request  => [ 'POST', 1, '/sites/2/entries' ],
        id       => [ 1,      'create_entry' ],
        endpoint => {
            id      => 'create_entry',
            version => 1,
        },
        params => { site_id => 2, }
    },
    {   request  => [ 'PUT', 1, '/sites/2/entries/3' ],
        id       => [ 1,     'update_entry' ],
        endpoint => {
            id      => 'update_entry',
            version => 1,
        },
        params => {
            site_id  => 2,
            entry_id => 3,
        }
    },
    {   request  => [ 'DELETE', 1, '/sites/2/entries/3' ],
        id       => [ 1,        'delete_entry' ],
        endpoint => {
            id      => 'delete_entry',
            version => 1,
        },
        params => {
            site_id  => 2,
            entry_id => 3,
        }
    },
    {   request => [ 'GET', 1, '/sites/2/entries/3/resources' ],
        id       => [ 1, 'get_some_resources_of_entry' ],
        note     => 'This route has no version 1',
        endpoint => undef,
    },
    {   request => [ 'GET', 2, '/sites/2/entries/3/resources' ],
        id       => [ 2, 'get_some_resources_of_entry' ],
        endpoint => {
            id      => 'get_some_resources_of_entry',
            version => 2,
        },
        params => {
            site_id  => 2,
            entry_id => 3,
        }
    },
    {   note =>
            'Should not assign format for the endpoint that has own format.',
        request => [ 'GET', 2, '/sites/2/entries/3/resources.xml' ],
        id       => [ 2, 'get_some_resources_of_entry' ],
        endpoint => {
            id      => 'get_some_resources_of_entry',
            version => 2,
        },
        params => {
            site_id  => 2,
            entry_id => 3,
        }
    },
    {   request  => [ 'GET', 1, '/sites/0/entries/3' ],
        id       => [ 1,     'get_entry' ],
        endpoint => {
            id      => 'get_entry',
            version => 1,
        },
        params => {
            site_id  => 0,
            entry_id => 3,
        }
    },
);

note('find_endpoint_by_path');
for my $d (@suite) {
    subtest 'find_endpoint_by_path for ['
        . join( ' ', @{ $d->{request} } )
        . ']' => sub {
        note( $d->{note} ) if $d->{note};

        my ( $endpoint, $params )
            = $app->find_endpoint_by_path( @{ $d->{request} } );

        if ( $d->{endpoint} ) {
            my $endpoint_data
                = { map { $_ => $endpoint->{$_}, } keys %{ $d->{endpoint} } };
            is_deeply( $endpoint_data, $d->{endpoint}, 'endpoint' );
            is_deeply( $params,        $d->{params},   'extracted params' );
        }
        else {
            ok( !$endpoint, 'endpoint' );
            ok( !$params,   'extracted params' );
        }
        };
}

note('find_endpoint_by_id');
for my $d (@suite) {
    subtest 'find_endpoint_by_id for ['
        . join( ' ', @{ $d->{id} } )
        . ']' => sub {
        note( $d->{note} ) if $d->{note};

        my $endpoint = $app->find_endpoint_by_id( @{ $d->{id} } );

        if ( $d->{endpoint} ) {
            my $endpoint_data
                = { map { $_ => $endpoint->{$_}, } keys %{ $d->{endpoint} } };
            is_deeply( $endpoint_data, $d->{endpoint}, 'endpoint' );
        }
        else {
            ok( !$endpoint, 'endpoint' );
        }
        };
}

done_testing();
