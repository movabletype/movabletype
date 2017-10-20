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

use MT::DataAPI::Endpoint::Common;

my @suite = (
    [ 'a'       => ['a'] ],
    [ 'a b'     => [ 'a', 'b' ] ],
    [ '"a b"'   => ['a b'] ],
    [ 'a"b c"d' => [ 'a', 'b c', 'd' ] ],
    [ '"a b'    => ['a b'] ],
    [ 'a b"' => [ 'a', 'b' ] ],
);

note('Simple query parser for DataAPI');
for my $data (@suite) {
    is_deeply( MT::DataAPI::Endpoint::Common::query_parser( $data->[0] ),
        $data->[1], $data->[0] );
}

done_testing();
