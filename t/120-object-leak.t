#!/usr/bin/perl

use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use MT::Test qw(:db :data);
use MT;
use constant HAS_LEAKTRACE => eval { require Test::LeakTrace };
use Test::More HAS_LEAKTRACE
    ? ( tests => 1 )
    : ( skip_all => 'require Test::LeakTrace' );
use Test::LeakTrace;

my $mt = MT->new();

# Clear cache
my $request = MT::Request->instance;
$request->{__stash} = {};

# Bugid:107443, Memory Leak: Reblessed objects contain cyclic ref
# this test should run with:
# DisableObjectCache 1
# otherwise the cache will hold the leaked object, and it won't be seen as leak

no_leaks_ok {
    my $website = MT->model('website')->load(1);
}
"Website object should not leak";

