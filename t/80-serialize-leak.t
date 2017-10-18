#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval { use Test::LeakTrace; 1 }
        or plan skip_all => 'require Test::LeakTrace';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
plan tests => 12;

require MT::Serialize;
my %sers
    = map { $_ => MT::Serialize->new($_) } qw(MTJ JSON MT MT2 MTS Storable);

my $a     = [1];
my $c     = 3;
my $data1 = [
    1, { a => 'value-a', b => $a, c => [ 'array', $a, $c, 2 ], d => 1 }, undef
];
my $data2 = [
    1, { a => 'value-a', b => $a, c => [ 'array', $a, $c, 2 ], d => 1 },
    undef
];
$data2->[1]->{z} = $data2;

for my $label ( sort keys %sers ) {
    my $ser = $sers{$label};
    note "Checking leaks for $label\n";

    # Call it once outside of leak check to make sure we load the serialization backend
    $ser->serialize( \$data1 );

    no_leaks_ok {
        my $frozen = $ser->serialize( \$data1 );
        my $thawed = ${ $ser->unserialize($frozen) };
    }
    "$label: No leaks with no circular data";

    # JSON format would die because they doesn't support circular reference
    if ( $label eq 'MTJ' || $label eq 'JSON' ) {
        eval {
            my $frozen = $ser->serialize( \$data2 );
            my $thawed = ${ $ser->unserialize($frozen) };
        };
        like(
            $@,
            qr/json text or perl structure exceeds maximum nesting level/,
            "$label doesn't support circular reference"
        );
    }
    else {
        leaks_cmp_ok {
            my $frozen = $ser->serialize( \$data2 );
            my $thawed = ${ $ser->unserialize($frozen) };
        }
        '<', 20, "$label: leak with circular data";
    }
}
