use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;

use MT::ContentType;

$test_env->prepare_fixture('db');

subtest 'set unique_id' => sub {
    my $unique_id = '1234' x 10;

    my $ct = MT::ContentType->new( blog_id => 1, name => 'ct' );

    $ct->unique_id($unique_id);
    is( $ct->unique_id, $unique_id, 'can set unique_id before save' );

    $ct->save or die $ct->errstr;
    $ct = MT::ContentType->load( $ct->id );
    is( $ct->unique_id, $unique_id, 'can save unique_id' );

    $ct->unique_id( 'abcd' x 10 );
    is( $ct->unique_id, $unique_id, 'cannot set unique_id after save' );
};

subtest 'generate unique_id automatically' => sub {
    my $ct = MT::ContentType->new( blog_id => 1, name => 'ct0' );
    $ct->save or die $ct->errstr;
    ok( $ct->unique_id, 'unique_id is generated' );
    is( length $ct->unique_id, 40, 'unique_id is valid' );
};

subtest 'forbid creating content_type with not unique unique_id' => sub {
    my $ct1 = MT::ContentType->new( blog_id => 1, name => 'ct1' );
    $ct1->save or die $ct1->errstr;

    my $ct2 = MT::ContentType->new( blog_id => 1, name => 'ct2' );
    $ct2->unique_id( $ct1->unique_id );
    $ct2->save;
    ok( $ct2->errstr, 'unique_id column must be unique' );
};

ok( MT::ContentType->table_is_created, 'mt_content_type table is created' );

done_testing;

