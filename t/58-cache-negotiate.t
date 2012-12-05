#!/usr/bin/perl

use strict;
use lib qw( t/lib extlib lib ../lib ../extlib );

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-memcached-test.cfg';
}

BEGIN {
    use Test::More;
    eval { require Test::MockObject }
        or plan skip_all => 'Test::MockObject is not installed';
}

use MT::Test;
use MT::Cache::Negotiate;
use MT::Memcached::ExpirableProxy;

my $alive = eval {
    my $m = MT::Memcached->instance;
    $m->set( __FILE__, __FILE__, 1 );
};

if ($alive) {
    my $mock = Test::MockObject->new;
    my $set_count;
    $mock->fake_module( 'MT::Memcached::ExpirableProxy',
        set => sub { $set_count++ } );

    {
        $set_count = 0;
        my $driver = MT::Cache::Negotiate->new();
        $driver->set( 'key', 'value' );
        is( $set_count, 0, 'MT::Memcached::ExpirableProxy is not used' );
    }

    {
        $set_count = 0;
        my $driver = MT::Cache::Negotiate->new( expirable => 1 );
        $driver->set( 'key', 'value' );
        is( $set_count, 1, 'MT::Memcached::ExpirableProxy is used' );
    }
}

done_testing();
