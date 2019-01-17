use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
my $app = MT->instance;

my @subs = ( sub {0}, sub {1}, sub {2} );

ok( !MT->handler_to_coderef, 'returns nothing when there is no argument' );
is( MT->handler_to_coderef( $subs[0] ),
    $subs[0], 'returns the argument when argument is a coderef' );
is( MT->handler_to_coderef( \@subs ),
    $subs[2],
    'returns last argument when arguments are multiple coderefs for scalar context'
);

my @coderefs = MT->handler_to_coderef( \@subs );
is_deeply( \@coderefs, \@subs,
    'returns all arguments when arguments are multiple coderefs for list context'
);

done_testing;

