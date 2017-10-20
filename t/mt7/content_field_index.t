use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test qw( :db );

use MT::ContentFieldIndex;

subtest 'set_value' => sub {
    my $cf_idx = MT::ContentFieldIndex->new;

    ok( $cf_idx->set_value( 'varchar', 'abc' ), 'set varchar' );
    is( $cf_idx->value_varchar, 'abc', 'get varchar' );

    ok( $cf_idx->set_value( 'blob', 'aiueo' ), 'set blob' );
    is( $cf_idx->value_blob, 'aiueo', 'get blob' );

    ok( $cf_idx->set_value( 'datetime', '20170413000000' ), 'set datetime' );
    is( $cf_idx->value_datetime, '20170413000000', 'get datetime' );

    ok( $cf_idx->set_value( 'integer', 123 ), 'set integer' );
    is( $cf_idx->value_integer, 123, 'get integer' );

    ok( $cf_idx->set_value( 'float', 3.141592 ), 'set float' );
    is( $cf_idx->value_float, 3.141592, 'get float' );

    # irregular tests
    ok( !$cf_idx->set_value( 'INVALID_TYPE', 'irohani' ),
        'set invalid type' );
    ok( !$cf_idx->set_value( '',    'hoheto' ),      'set empty string' );
    ok( !$cf_idx->set_value( undef, 'chirinuruwo' ), 'set undef' );
};

done_testing;

