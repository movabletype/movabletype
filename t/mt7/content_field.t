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

use MT;
use MT::Test;

use MT::ContentField;

$test_env->prepare_fixture('db');

subtest 'set unique_id' => sub {
    my $unique_id = '1234' x 10;

    my $cf = MT::ContentField->new(
        blog_id         => 1,
        content_type_id => 1,
        name            => 'test1',
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
        name            => 'test2',
    );
    $cf->save or die $cf->errstr;
    ok( $cf->unique_id, 'unique_id is generated' );
    is( length $cf->unique_id, 40, 'unique_id is valid' );
};

subtest 'forbid creating content_field with not unique unique_id' => sub {
    my $cf1 = MT::ContentField->new(
        blog_id         => 1,
        content_type_id => 1,
        name            => 'test3-1',
    );
    $cf1->save or die $cf1->errstr;

    my $cf2 = MT::ContentField->new(
        blog_id         => 1,
        content_type_id => 1,
        name            => 'test3-2',
    );
    $cf2->unique_id( $cf1->unique_id );
    $cf2->save;
    ok( $cf2->errstr, 'unique_id column must be unique' );
};

subtest 'remove an orphan content field' => sub {
    my $cf1 = MT::ContentField->new(
        blog_id         => 1,
        content_type_id => 9999,
        name            => 'test4-1',
    );
    $cf1->save or die $cf1->errstr;
    my $old_id = $cf1->id;

    $test_env->remove_logfile;

    ok $cf1->remove;

    unlike $test_env->slurp_logfile => qr/Can't call method "unique_id" on an undefined value/, "no known warnings";

    ok !MT::ContentField->load($old_id), "cf is removed";
};

done_testing;
