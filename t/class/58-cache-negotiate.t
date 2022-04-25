#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval { require Test::MockObject }
        or plan skip_all => 'Test::MockObject is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Cache::Negotiate;
use MT::Memcached::ExpirableProxy;
use MT::Test::Memcached;
use MT::Memcached;

my $memcached = MT::Test::Memcached->new or plan skip_all => "Memcached is not available";
MT->config(MemcachedServers => $memcached->address);
MT::Memcached::cleanup();

my $m = MT::Memcached->instance;
$m->set( __FILE__, __FILE__, 1 );

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
