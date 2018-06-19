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

use MT::Test;
use MT::Test::Permission;

use MT::Category;
use MT::CategorySet;

MT::Test->init_app;

$test_env->prepare_fixture('db');

my $blog_id = 1;

subtest 'blog' => sub {
    my $cat_set = MT::Test::Permission->make_category_set(
        blog_id => 1,
        name    => 'test blog',
    );
    ok( $cat_set->blog, 'return $blog' );
    is( $cat_set->blog->id, $blog_id, '$blog->id is ' . $blog_id );
};

subtest 'cat_count' => sub {
    my $cat_set = MT::Test::Permission->make_category_set(
        blog_id => 1,
        name    => 'test cat_count',
    );

    my $cat1 = MT::Test::Permission->make_category(
        blog_id         => $blog_id,
        category_set_id => $cat_set->id,
    );
    $cat_set->save or die $cat_set->errstr;
    is( $cat_set->cat_count, 1, 'cat_count is 1' );

    my $cat2 = MT::Test::Permission->make_category(
        blog_id         => $blog_id,
        category_set_id => $cat_set->id,
    );
    $cat_set->save or die $cat_set->errstr;
    is( $cat_set->cat_count, 2, 'cat_count is 2' );

    my $other_cat
        = MT::Test::Permission->make_category( blog_id => $blog_id );
    $cat_set->save or die $cat_set->errstr;
    is( $cat_set->cat_count, 2, 'cat_count is 2' );

    $cat1->remove  or die $cat1->errstr;
    $cat_set->save or die $cat_set->errstr;
    is( $cat_set->cat_count, 1, 'cat_count is 1' );
};

subtest 'ct_count' => sub {
    my $cat_set = MT::Test::Permission->make_category_set(
        blog_id => 1,
        name    => 'test ct_count',
    );

    my $ct = MT::Test::Permission->make_content_type(
        blog_id => $blog_id,
        name    => 'test content type',
    );

    my $cf = MT::Test::Permission->make_content_field(
        blog_id            => $blog_id,
        content_type_id    => $ct->id,
        related_cat_set_id => $cat_set->id,
        name               => 'test category field',
        type               => 'categories',
    );

    $cat_set = MT::CategorySet->load( $cat_set->id );
    is( $cat_set->ct_count, 1, 'ct_count is 1' );

    $cf->type('radio_button');
    $cf->save or die $cf->errstr;
    $cat_set = MT::CategorySet->load( $cat_set->id );
    is( $cat_set->ct_count, 0, 'ct_count is 0' );
};

subtest 'remove' => sub {
    my $cat_set = MT::Test::Permission->make_category_set(
        blog_id => 1,
        name    => 'test remove',
    );

    my $cat = MT::Test::Permission->make_category(
        blog_id         => $blog_id,
        category_set_id => $cat_set->id,
    );

    my $count = sub {
        MT::Category->count(
            {   blog_id         => $blog_id,
                category_set_id => $cat_set->id,
            }
        );
    };

    $cat_set->save or die $cat_set->errstr;
    ok( $count->(), 'category count is more than 0' );

    $cat_set->remove or die $cat_set->errstr;
    is( $count->(), 0, 'category count is 0' );
};

done_testing;

