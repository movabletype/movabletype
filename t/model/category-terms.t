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

my $blog_id = 1;

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;
        my $category = MT::Test::Permission->make_category( blog_id => 1 );
        my $folder = MT::Test::Permission->make_folder( blog_id => 1 );
        my $category_set
            = MT::Test::Permission->make_category_set( blog_id => $blog_id );
        my $category_for_category_set = MT::Test::Permission->make_category(
            blog_id         => $blog_id,
            category_set_id => $category_set->id,
        );
    }
);

my $category_set = MT->model('category_set')->load( { blog_id => $blog_id } )
    or die;

subtest 'Do not load category for category set without terms' => sub {
    my @categories = MT->model('category')->load;

    is( @categories,                     1 );
    is( $categories[0]->class,           'category' );
    is( $categories[0]->category_set_id, 0 );
};

subtest
    'Do not load category for category set without category_set_id (HASH)' =>
    sub {
    my $terms = { blog_id => $blog_id };
    my @categories = MT->model('category')->load($terms);

    is( @categories,                     1 );
    is( $categories[0]->class,           'category' );
    is( $categories[0]->category_set_id, 0 );
    };

subtest
    'Do not load category for category set without category_set_id (ARRAY)'
    => sub {
    my $terms = [ { blog_id => $blog_id }, { class => 'category' } ];
    my @categories = MT->model('category')->load($terms);

    is( @categories,                     1 );
    is( $categories[0]->class,           'category' );
    is( $categories[0]->category_set_id, 0 );
    };

subtest 'Load category for category set with category_set_id (HASH)' => sub {
    my $terms = {
        blog_id         => $blog_id,
        category_set_id => $category_set->id,
    };
    my @categories = MT->model('category')->load($terms);

    is( @categories,                     1 );
    is( $categories[0]->category_set_id, $category_set->id );
};

subtest 'Load category for category set with category_set_id (ARRAY)' => sub {
    my $terms = [
        { blog_id => $blog_id, category_set_id => $category_set->id },
        { parent => [ \'IS NULL', 0 ], category_set_id => $category_set->id },
    ];
    my @categories = MT->model('category')->load($terms);

    is( @categories,                     1 );
    is( $categories[0]->category_set_id, $category_set->id );
};

subtest 'Load category for category set by its id' => sub {
    my $category_for_category_set
        = MT->model('category')
        ->load(
        { blog_id => $blog_id, category_set_id => $category_set->id, } )
        or die;
    my $category
        = MT->model('category')->load( $category_for_category_set->id );

    ok($category);
};

subtest 'Load category for category set with id without category_set_id' =>
    sub {
    my $category_for_category_set
        = MT->model('category')
        ->load(
        { blog_id => $blog_id, category_set_id => $category_set->id } )
        or die;
    my $terms = { id => $category_for_category_set->id };
    my @categories = MT->model('category')->load($terms);

    is( @categories,        1 );
    is( $categories[0]->id, $category_for_category_set->id );
    };

subtest 'Load all categories with no_category_set_id => 1' => sub {
    my $terms = { blog_id            => $blog_id };
    my $args  = { no_category_set_id => 1 };
    my @categories = MT->model('category')->load( $terms, $args );

    is( @categories,                     2 );
    is( $categories[0]->class,           'category' );
    is( $categories[0]->category_set_id, 0 );
    is( $categories[1]->class,           'category' );
    is( $categories[1]->category_set_id, $category_set->id );
};

subtest 'Load all categories with category_set_id => "*"' => sub {
    my $terms = {
        blog_id         => $blog_id,
        category_set_id => '*',
    };
    my @categories = MT->model('category')->load($terms);

    is( @categories,                     2 );
    is( $categories[0]->class,           'category' );
    is( $categories[0]->category_set_id, 0 );
    is( $categories[1]->class,           'category' );
    is( $categories[1]->category_set_id, $category_set->id );
};

subtest
    'load_iter method does not load category for category set without category_set_id'
    => sub {
    my $terms = { blog_id => $blog_id };
    my $iter = MT->model('category')->load_iter($terms);

    my @categories;
    while ( my $cat = $iter->() ) {
        push @categories, $cat;
    }
    is( @categories,                     1 );
    is( $categories[0]->class,           'category' );
    is( $categories[0]->category_set_id, 0 );
    };

subtest
    'count method does not count category for category set without category_set_id'
    => sub {
    my $terms = { blog_id => $blog_id };
    my $count = MT->model('category')->count($terms);

    is( $count, 1 );
    };

subtest
    'remove method does not remove category for category set without category_set_id'
    => sub {
    my $terms = { blog_id => $blog_id };
    my $removed = MT->model('category')->remove($terms);

    ok($removed);
    my $category_for_category_set_exists
        = MT->model('category')
        ->exist(
        { blog_id => $blog_id, category_set_id => $category_set->id } );
    ok($category_for_category_set_exists);
    };

subtest 'remove_all method does not remove category for category set' => sub {
    MT::Test::Permission->make_category( blog_id => $blog_id );
    my $removed = MT->model('category')->remove_all;

    ok($removed);
    my $category_exists
        = MT->model('category')->exist( { blog_id => $blog_id } );
    ok( !$category_exists );
    my $category_for_category_set_exists
        = MT->model('category')
        ->exist(
        { blog_id => $blog_id, category_set_id => $category_set->id } );
    ok($category_for_category_set_exists);
};

done_testing;

