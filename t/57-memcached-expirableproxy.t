#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        MemcachedServers => '127.0.0.1:11211',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Memcached::ExpirableProxy;

my $alive = eval {
    my $m = MT::Memcached->instance;
    $m->set( __FILE__, __FILE__, 1 );
};

if ( !$alive ) {
    plan skip_all => "Memcached is not available";
}

MT::Test::init_time();

my @values = (
    {   key   => 'test_key1',
        value => 'test_value1',
    },
    {   key   => 'test_key2',
        value => 'test_value2',
    },
);

sub set_values {
    my ($sleep) = @_;
    $sleep ||= 0;

    my $driver = MT::Memcached::ExpirableProxy->new();
    for my $hash (@values) {
        $driver->set( $hash->{key}, $hash->{value} );
        sleep $sleep;
    }
    sleep( -$sleep );
}

for my $method (qw(add set)) {
    note( 'MT::Memcached::ExpirableProxy->' . $method );
    {
        my $driver = MT::Memcached::ExpirableProxy->new();
        $driver->delete( $values[0]{key} );
        ok( $driver->$method( $values[0]{key}, $values[0]{value} ),
            "call $method" );
        is( $driver->get( $values[0]{key} ),
            $values[0]{value}, 'should get a value' );
    }
}

note('MT::Memcached::ExpirableProxy->replace');
{
    my $driver = MT::Memcached::ExpirableProxy->new();
    $driver->delete( $values[0]{key} );
    ok( !$driver->replace( $values[0]{key}, $values[0]{value} ),
        'call replace for a deleted key' );
    is( $driver->get( $values[0]{key} ), undef, 'should get undef' );

    $driver->set( $values[0]{key}, $values[1]{value} . 'Dummy' );
    ok( $driver->replace( $values[0]{key}, $values[0]{value} ),
        'call replace for an existing key' );
    is( $driver->get( $values[0]{key} ),
        $values[0]{value}, 'should get a value' );
}

note('MT::Memcached::ExpirableProxy->get');
{
    my @suite = (
        {   sleep => 1,
            ttl   => 2,
            key   => $values[0]{key},
            value => $values[0]{value},
        },
        {   sleep => 2,
            ttl   => 2,
            key   => $values[0]{key},
            value => $values[0]{value},
        },
        {   sleep => 3,
            ttl   => 2,
            key   => $values[0]{key},
            value => undef,
        },
    );

    foreach my $hash (@suite) {
        set_values();

        sleep $hash->{sleep};

        my $driver
            = MT::Memcached::ExpirableProxy->new( ttl => $hash->{ttl} );
        is( $driver->get( $hash->{key} ),
            $hash->{value},
            "get a value (sleep: $hash->{sleep}, ttl: $hash->{ttl})" );
    }
}

note('MT::Memcached::ExpirableProxy->get_multi');
{
    my @suite = (
        {   set_values_sleep => 0,
            sleep            => 1,
            ttl              => 2,
            key              => [ map { $values[$_]{key} } 0 .. 1 ],
            value =>
                { map { $values[$_]{key} => $values[$_]{value} } 0 .. 1 },
        },
        {   set_values_sleep => 1,
            sleep            => 2,
            ttl              => 2,
            key              => [ map { $values[$_]{key} } 0 .. 1 ],
            value            => {
                $values[0]{key} => undef,
                $values[1]{key} => $values[1]{value},
            }
        },
        {   set_values_sleep => 1,
            sleep            => 3,
            ttl              => 2,
            key              => [ map { $values[$_]{key} } 0 .. 1 ],
            value            => { map { $values[$_]{key} => undef } 0 .. 1 },
        },
    );

    foreach my $hash (@suite) {
        set_values( $hash->{set_values_sleep} );

        sleep $hash->{sleep};

        my $driver
            = MT::Memcached::ExpirableProxy->new( ttl => $hash->{ttl} );

        is_deeply(
            $driver->get_multi( @{ $hash->{key} } ),
            $hash->{value},
            "get a value (set_values_sleep: $hash->{set_values_sleep}, sleep: $hash->{sleep}, ttl: $hash->{ttl})"
        );
    }
}

done_testing();
