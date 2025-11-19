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
use MT::Test::Permission;

use MT::ContentType;
use Feature::Compat::Try;

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

    # wrap this test with a transaction to restore everything (cursor, etc.) to the correct state
    my $ct2;
    try {
        MT::ContentType->begin_work;
        $ct2 = MT::ContentType->new( blog_id => 1, name => 'ct2' );
        $ct2->unique_id( $ct1->unique_id );
        $ct2->save;
        MT::ContentType->commit;
    } catch ($e) {
        MT::ContentType->rollback;
    }
    ok( $ct2->errstr, 'unique_id column must be unique' );
};

subtest 'categories_fields' => sub {
    my $ct = MT::Test::Permission->make_content_type( blog_id => 1 );
    is_deeply( $ct->categories_fields, [], 'no field' );

    my $cf_single = MT::Test::Permission->make_content_field(
        blog_id         => 1,
        content_type_id => $ct->id,
        name            => 'single',
        type            => 'single_line_text',
    );
    $ct->fields(
        [   {   id        => $cf_single->id,
                name      => $cf_single->name,
                options   => { label => $cf_single->name, },
                order     => 1,
                type      => $cf_single->type,
                unique_id => $cf_single->unique_id,
            },
        ]
    );
    $ct->save or die;
    $ct->refresh;
    is_deeply( $ct->categories_fields, [], '1 non categories field' );

    my $catset = MT::Test::Permission->make_category_set( blog_id => 1 );
    my $cf_cat = MT::Test::Permission->make_content_field(
        blog_id         => 1,
        content_type_id => $ct->id,
        name            => 'cat',
        type            => 'categories',
    );
    my $cat_field_hash = {
        id      => $cf_cat->id,
        name    => $cf_cat->name,
        options => {
            category_set => $catset->id,
            label        => $cf_cat->name,
        },
        order     => 2,
        type      => $cf_cat->type,
        unique_id => $cf_cat->unique_id,
    };
    $ct->fields( [ @{ $ct->fields }, $cat_field_hash, ], );
    $ct->save or die;
    $ct->refresh;
    is_deeply( $ct->categories_fields, [$cat_field_hash],
        '1 categories field' );
};

done_testing;

