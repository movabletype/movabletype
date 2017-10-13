#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
BEGIN {
    eval { require Test::MockObject }
        or plan skip_all => 'Test::MockObject is not installed';
}

use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        MemcachedServers => '127.0.0.1:11211',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Cache::Negotiate;
use MT::Memcached::ExpirableProxy;

my $alive = eval {
    my $m = MT::Memcached->instance;
    $m->set( __FILE__, __FILE__, 1 );
};
plan skip_all => 'memcached is not alive' unless $alive;

{
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
