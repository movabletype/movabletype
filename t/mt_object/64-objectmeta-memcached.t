#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib",    # t/lib
    "$FindBin::Bin/../..";         # $ENV{MT_HOME}
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Memcached;

my $memcached = MT::Test::Memcached->new or plan skip_all => "Memcached is not available";
MT->config(MemcachedServers => $memcached->address);

my $m = MT::Memcached->instance;
$m->set(__FILE__, __FILE__, 1);

(my $filename = __FILE__) =~ s/-memcached\.t\z/.t/;
require("./$filename");    # t/64-objectmeta.t
