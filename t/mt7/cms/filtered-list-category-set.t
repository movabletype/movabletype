#!/usr/bin/perl

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
use MT::Test::App;

$test_env->prepare_fixture('db');

my $blog_id = 1;
my $blog    = MT::Blog->load($blog_id);

my $admin = MT::Author->load(1);

my $author = MT::Test::Permission->make_author(
    name     => 'author',
    nickname => 'author',
);

# Category
my $category_set1 = MT::Test::Permission->make_category_set(
    blog_id => $blog->id,
    name    => 'first test category set',
);
my $category_set2 = MT::Test::Permission->make_category_set(
    blog_id => $blog->id,
    name    => 'second test category set',
);
my $category1 = MT::Test::Permission->make_category(
    blog_id         => $blog->id,
    category_set_id => $category_set1->id,
);
my $category2 = MT::Test::Permission->make_category(
    blog_id         => $blog->id,
    category_set_id => $category_set2->id,
);
my $category3 = MT::Test::Permission->make_category(
    blog_id         => $blog->id,
    category_set_id => $category_set2->id,
);

# Content
my $content_type1 = MT::Test::Permission->make_content_type(
    blog_id => $blog->id,
    name    => 'first test content type',
);
my $content_type2 = MT::Test::Permission->make_content_type(
    blog_id => $blog->id,
    name    => 'second test content type',
);
my $cf_category1 = MT::Test::Permission->make_content_field(
    blog_id            => $blog->id,
    content_type_id    => $content_type1->id,
    related_cat_set_id => $category_set1->id,
    name               => 'test category field',
    type               => 'categories',
);
my $cf_category2 = MT::Test::Permission->make_content_field(
    blog_id            => $blog->id,
    content_type_id    => $content_type2->id,
    related_cat_set_id => $category_set2->id,
    name               => 'test category field',
    type               => 'categories',
);
my $cf_category3 = MT::Test::Permission->make_content_field(
    blog_id            => $blog->id,
    content_type_id    => $content_type2->id,
    related_cat_set_id => $category_set2->id,
    name               => 'test category field',
    type               => 'categories',
);
$content_type1->fields([{
        id        => $cf_category1->id,
        name      => $cf_category1->name,
        options   => { label => $cf_category1->name, },
        order     => 1,
        type      => $cf_category1->type,
        unique_id => $cf_category1->unique_id,
    },
]);
$content_type2->fields([{
        id        => $cf_category2->id,
        name      => $cf_category2->name,
        options   => { label => $cf_category2->name, },
        order     => 1,
        type      => $cf_category2->type,
        unique_id => $cf_category2->unique_id,
    },
    {
        id        => $cf_category3->id,
        name      => $cf_category3->name,
        options   => { label => $cf_category3->name, },
        order     => 1,
        type      => $cf_category3->type,
        unique_id => $cf_category3->unique_id,
    },
]);
$content_type1->save or die $content_type1->errstr;
$content_type2->save or die $content_type2->errstr;

subtest 'category_set' => sub {
    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        'blog_id'    => $blog->id,
        '__mode'     => 'filtered_list',
        'datasource' => 'category_set',
        'columns'    => 'name',
        'items'      => '"[{\\"type\\":\\"content_type_name\\",\\"args\\":{\\"string\\":\\"first\\",\\"option\\":\\"contains\\"}}]"'
    });
    $app->has_no_permission_error("filtered_list method succeeded");
    $app->content_like(
        qr!first test category set!i,
        "conteins filter by a name of a content type succeeded"
    );
    $app->content_unlike(
        qr!second test category set!i,
        "conteins filter by a name of a content type succeeded"
    );

    $app->post_ok({
        'blog_id'    => $blog->id,
        '__mode'     => 'filtered_list',
        'datasource' => 'category_set',
        'columns'    => 'name',
        'items'      => '"[{\\"type\\":\\"content_type_name\\",\\"args\\":{\\"string\\":\\"first\\",\\"option\\":\\"not_contains\\"}}]"'
    });
    $app->has_no_permission_error("filtered_list method succeeded");
    $app->content_unlike(
        qr!first test category set!i,
        "not_contains filter by a name of a content type succeeded"
    );
    $app->content_like(
        qr!second test category set!i,
        "not_contains filter by a name of a content type succeeded"
    );

    $app->post_ok({
        'blog_id'    => $blog->id,
        '__mode'     => 'filtered_list',
        'datasource' => 'category_set',
        'columns'    => 'category_count,content_type_count',
        'items'      => '"[]"'
    });
    $app->has_no_permission_error("filtered_list method succeeded");
    my $obj = MT::Util::from_json($app->content);
    is_deeply($obj->{result}{objects}, [[$category_set1->id, 1, 1], [$category_set2->id, 2, 2]]);
};

done_testing();
