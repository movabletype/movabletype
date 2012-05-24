#!/usr/bin/perl

use strict;
use lib qw( t/lib extlib lib ../lib ../extlib );

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-memcached-test.cfg';
}

use MT::Test;
use Test::More;

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
