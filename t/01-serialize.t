#!/usr/bin/perl
# $Id$
use strict;
use warnings;
use Test::More tests => 73;
use_ok 'MT::Serialize';

my @TESTS = (
    { },
    { foo => undef },
    { '' => 'bar' },
    { foo => '' },
    { foo => 0 },
    { foo => 'bar' },
    { foo => 'bar', baz => 'quux' },
);

for my $meth (qw( Storable MT )) {
    my $ser = MT::Serialize->new($meth);
    isa_ok($ser, 'MT::Serialize', "with $meth");
    for my $hash (@TESTS) {
        my $res = $ser->serialize(\$hash);
        ok($res, 'serialize');
        my $thawed = $ser->unserialize($res);
        ok($thawed, 'unserialize');
        is(ref($thawed), 'REF', 'REF');
        my $hash2 = $$thawed;
        is(ref($hash2), 'HASH', 'HASH');
        for my $key (keys %$hash) {
            is($hash->{$key}, $hash2->{$key}, "'$key' values");
        }
    }
}
