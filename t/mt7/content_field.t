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


use Test::More;

use lib qw( lib extlib t/lib );
use MT;
use MT::Test qw( :db );

use MT::ContentField;

subtest 'set unique_id' => sub {
    my $unique_id = '1234' x 10;

    my $cf = MT::ContentField->new(
        blog_id         => 1,
        content_type_id => 1,
    );

    $cf->unique_id($unique_id);
    is( $cf->unique_id, $unique_id, 'can set unique_id before save' );

    $cf->save or die $cf->errstr;
    $cf = MT::ContentField->load( $cf->id );
    is( $cf->unique_id, $unique_id, 'can save unique_id' );

    $cf->unique_id( 'abcd' x 10 );
    is( $cf->unique_id, $unique_id, 'cannot change unique_id after save' );
};

subtest 'generate unique_id automatically' => sub {
    my $cf = MT::ContentField->new(
        blog_id         => 1,
        content_type_id => 1,
    );
    $cf->save or die $cf->errstr;
    ok( $cf->unique_id, 'unique_id is generated' );
    is( length $cf->unique_id, 40, 'unique_id is valid' );
};

subtest 'forbid creating content_field with not unique unique_id' => sub {
    my $cf1 = MT::ContentField->new(
        blog_id         => 1,
        content_type_id => 1,
    );
    $cf1->save or die $cf1->errstr;

    my $cf2 = MT::ContentField->new(
        blog_id         => 1,
        content_type_id => 1,
    );
    $cf2->unique_id( $cf1->unique_id );
    $cf2->save;
    ok( $cf2->errstr, 'unique_id column must be unique' );
};

done_testing;

