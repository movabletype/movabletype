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

use MT::Test;

my $alive = eval {
    my $m = MT::Memcached->instance;
    $m->set( __FILE__, __FILE__, 1 );
};

if ( !$alive ) {
    plan skip_all => "Memcached is not available";
    done_testing();
}
else {
    ( my $filename = __FILE__ ) =~ s/-memcached\.t\z/.t/;
    require($filename);
}
