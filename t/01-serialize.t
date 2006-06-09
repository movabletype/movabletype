# $Id$

use Test;
use MT::Serialize;
use strict;

BEGIN { plan tests => 72 };

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
    ok($ser);
    for my $hash (@TESTS) {
        my $res = $ser->serialize(\$hash);
        ok($res);
        my $thawed = $ser->unserialize($res);
        ok($thawed);
        ok(ref($thawed), 'REF');
        my $hash2 = $$thawed;
        ok(ref($hash2), 'HASH');
        for my $key (keys %$hash) {
            ok($hash->{$key}, $hash2->{$key});
        }
    }
}
