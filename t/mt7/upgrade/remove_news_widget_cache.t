use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Upgrade;

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;
        MT::Test::Permission->make_session( id => '1', kind => 'NW' );
        MT::Test::Permission->make_session( id => '2', kind => 'LW' );
        MT::Test::Permission->make_session( id => '3', kind => 'DW' );
    }
);

is( MT::Session->count({ kind => 'NW' }), 1, "Cache (kind=NW) exists." );
is( MT::Session->count({ kind => 'LW' }), 1, "Cache (kind=LW) exists." );
is( MT::Session->count({ kind => 'DW' }), 1, "Cache (kind=DW) exists." );

MT::Test::Upgrade->upgrade( from => 7.0045 );

is( MT::Session->count({ kind => 'NW' }), 0, "Cache (kind=NW) removed." );
is( MT::Session->count({ kind => 'LW' }), 0, "Cache (kind=LW) removed." );
is( MT::Session->count({ kind => 'DW' }), 0, "Cache (kind=DW) removed." );

done_testing;

1;
