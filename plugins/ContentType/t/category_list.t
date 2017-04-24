use strict;
use warnings;

use Test::More;

use lib qw( lib extlib t/lib );
use MT;
use MT::Test qw( :app :db );
use MT::Test::Permission;

use MT::Blog;
use MT::Category;
use MT::CategoryList;
use MT::ContentType;
use MT::ContentField;

my $blog_id = 1;

subtest 'blog' => sub {
    my $cat_list = MT::CategoryList->new;
    $cat_list->set_values(
        {   blog_id => 1,
            name    => 'test blog',
        }
    );
    $cat_list->save or die $cat_list->errstr;

    ok( $cat_list->blog, 'return $blog' );
    is( $cat_list->blog->id, $blog_id, '$blog->id is ' . $blog_id );
};

subtest 'cat_count' => sub {
    my $cat_list = MT::CategoryList->new;
    $cat_list->set_values(
        {   blog_id => 1,
            name    => 'test cat_count',
        }
    );
    $cat_list->save or die $cat_list->errstr;

    my $cat1 = MT::Test::Permission->make_category(
        blog_id => $blog_id,
        list_id => $cat_list->id,
    );
    $cat_list->save or die $cat_list->errstr;
    is( $cat_list->cat_count, 1, 'cat_count is 1' );

    my $cat2 = MT::Test::Permission->make_category(
        blog_id => $blog_id,
        list_id => $cat_list->id,
    );
    $cat_list->save or die $cat_list->errstr;
    is( $cat_list->cat_count, 2, 'cat_count is 2' );

    my $other_cat
        = MT::Test::Permission->make_category( blog_id => $blog_id );
    $cat_list->save or die $cat_list->errstr;
    is( $cat_list->cat_count, 2, 'cat_count is 2' );

    $cat1->remove   or die $cat1->errstr;
    $cat_list->save or die $cat_list->errstr;
    is( $cat_list->cat_count, 1, 'cat_count is 1' );
};

subtest 'ct_count' => sub {
    my $cat_list = MT::CategoryList->new;
    $cat_list->set_values(
        {   blog_id => 1,
            name    => 'test ct_count',
        }
    );
    $cat_list->save or die $cat_list->errstr;

    my $ct = MT::ContentType->new;
    $ct->set_values(
        {   blog_id => $blog_id,
            name    => 'test content type',
        }
    );
    $ct->save or die $ct->errstr;

    my $cf = MT::ContentField->new;
    $cf->set_values(
        {   blog_id             => $blog_id,
            content_type_id     => $ct->id,
            related_cat_list_id => $cat_list->id,
            name                => 'test category field',
            type                => 'category',
        }
    );
    $cf->save or die $ct->errstr;

    $cat_list = MT::CategoryList->load( $cat_list->id );
    is( $cat_list->ct_count, 1, 'ct_count is 1' );

    $cf->type('radio');
    $cf->save or die $cf->errstr;
    $cat_list = MT::CategoryList->load( $cat_list->id );
    is( $cat_list->ct_count, 0, 'ct_count is 0' );
};

subtest 'remove' => sub {
    my $cat_list = MT::CategoryList->new;
    $cat_list->set_values(
        {   blog_id => 1,
            name    => 'test remove',
        }
    );
    $cat_list->save or die $cat_list->errstr;

    my $cat = MT::Test::Permission->make_category(
        blog_id => $blog_id,
        list_id => $cat_list->id,
    );
    $cat_list->save or die $cat_list->errstr;

    my $count = sub {
        MT::Category->count(
            {   blog_id => $blog_id,
                list_Id => $cat_list->id,
            }
        );
    };
    ok( $count->(), 'category count is more than 0' );
    $cat_list->remove or die $cat_list->errstr;
    is( $count->(), 0, 'category count is 0' );
};

done_testing;

