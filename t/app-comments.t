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

use MT::App::Comments;

is( MT::App::Comments::HOLD(),    1, 'MT::Entry::HOLD() is imported' );
is( MT::App::Comments::RELEASE(), 2, 'MT::Entry::RELEASE() is imported' );
is( MT::App::Comments::FUTURE(),  4, 'MT::Entry::FUTURE() is imported' );

done_testing;

