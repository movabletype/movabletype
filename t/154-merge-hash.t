#!/usr/bin/perl
use strict;
use warnings;

use Test::More;

use lib qw( lib extlib t/lib );
use MT::Bootstrap;
use MT;
use MT::Util qw( merge_hash );

my @test = (

    # scalar
    {   hash1  => {},
        hash2  => {},
        merged => {},
        test   => 'merged two empty hashes'
    },
    {   hash1  => { a => 1 },
        hash2  => {},
        merged => { a => 1 },
        test   => 'merged hash with empty hash',
    },
    {   hash1  => {},
        hash2  => { b => 2 },
        merged => { b => 2 },
        test   => 'merged empty hash with hash',
    },
    {   hash1  => { a => 1 },
        hash2  => { b => 2 },
        merged => { a => 1, b => 2 },
        test => 'merged two hashes',
    },

    # replace
    {   hash1  => { a => 1 },
        hash2  => { a => 1 },
        merged => { a => [ 1, 1 ] },
        test => 'hash value is retained',
    },
    {   hash1   => { a => 1 },
        hash2   => { a => 1 },
        replace => 1,
        merged  => { a => 1 },
        test    => 'hash value is replaced',
    },

    # array
    {   hash1  => { a => [ 1, 2 ] },
        hash2  => { a => [ 3, 4 ] },
        merged => { a => [ 1, 2, 3, 4 ] },
        test => 'merged two arrays',
    },
    {   hash1  => { a => 1 },
        hash2  => { a => [ 2, 3 ] },
        merged => { a => [ 1, 2, 3 ] },
        test => 'merged scalar with array',
    },
    {   hash1 => { a => [ 1, 2 ] },
        hash2 => { a => 3 },
        merged => { a => [ 1, 2, 3 ] },
        test   => 'merged array with scalar',
    },

    # hash
    {   hash1  => { a => { x => 1 } },
        hash2  => { a => { y => 2 } },
        merged => { a => { x => 1, y => 2 } },
        test => 'merged two child hashes',
    },
    {   hash1  => { a => 1 },
        hash2  => { a => { y => 2 } },
        merged => { a => [ 1, { y => 2 } ] },
        test => 'merged scalar with hash',
    },
    {   hash1 => { a => { x => 1 } },
        hash2 => { a => 2 },
        merged => { a => [ { x => 1 }, 2 ] },
        test   => 'merged hash with scalar',
    },
    {   hash1 => { a => [ 1, 2 ] },
        hash2 => { a => { y => 3 } },
        merged => { a => [ 1, 2, { y => 3 } ] },
        test   => 'merged array with hash',
    },
    {   hash1 => { a => { x => 1 } },
        hash2 => { a => [ 2, 3 ] },
        merged => { a => [ { x => 1 }, 2, 3 ] },
        test   => 'merged hash with array',
    },
);

for my $t (@test) {
    merge_hash( $t->{hash1}, $t->{hash2}, $t->{replace} );
    is_deeply( $t->{hash1}, $t->{merged}, $t->{test} );
}

done_testing;
