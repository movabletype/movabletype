use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use Test::More;
use MT::Test::Env;

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::DataAPI;
use MT::Test::Permission;

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $user = MT->model('author')->load(1);
$user->email('melody@example.com');
$user->save;

$app->user($user);

# manage_content_types permission remove.
my $system_perm = MT::Permission->load({author_id => $user->id, blog_id => 0});
my $permissions = $system_perm->permissions();
$permissions =~ s/'manage_content_types',?//;
$system_perm->permissions($permissions);
$system_perm->save();

my $site_id = 1;

my $category_set
    = MT::Test::Permission->make_category_set( blog_id => $site_id );
ok($category_set);
my $category_set_id = $category_set->id;

my $other_category_set = MT::Test::Permission->make_category_set(
    blog_id => $site_id,
    name    => 'Other Category Set'
);
ok($other_category_set);
my $other_category_set_id = $other_category_set->id;

my $parent_category = MT::Test::Permission->make_category(
    blog_id         => $site_id,
    category_set_id => $category_set_id,
);
ok($parent_category);
my $parent_category_id = $parent_category->id;

my $category = MT::Test::Permission->make_category(
    blog_id         => $site_id,
    category_set_id => $category_set->id,
    parent          => $parent_category->id,
);
ok($category);
ok( $category->parent );
my $category_id = $category->id;

my $sibling_category = MT::Test::Permission->make_category(
    blog_id         => $site_id,
    category_set_id => $category_set_id,
    parent          => $parent_category->id,
);
ok($sibling_category);
my $sibling_category_id = $sibling_category->id;

normal_tests_for_create_category();
irregular_tests_for_create_category();

irregular_tests_for_get_category();
normal_tests_for_get_category();

irregular_tests_for_update_category();
normal_tests_for_update_category();

irregular_tests_for_list_categories();
normal_tests_for_list_categories();

irregular_tests_for_list_parent_categories();
normal_tests_for_list_parent_categories();

irregular_tests_for_list_sibling_categories();
normal_tests_for_list_sibling_categories();

irregular_tests_for_list_child_categories();
normal_tests_for_list_child_categories();

irregular_tests_for_permutate_categories();
normal_tests_for_permutate_categories();

irregular_tests_for_delete_category();
normal_tests_for_delete_category();

sub normal_tests_for_create_category {
    test_data_api(
        {   note => 'non superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories",
            method    => 'POST',
            params    => { category => { label => 'create-category', }, },
            callbacks => [

                # category_sets
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.category_set',
                    count => 1,
                },

                # category
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.category',
                    count => 1,
                },
                {   name => 'MT::App::DataAPI::data_api_save_filter.category',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.category',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.category',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('category')->load(
                    {   category_set_id => $category_set_id,
                        label           => 'create-category',
                    }
                );
            },
        }
    );
    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories",
            method       => 'POST',
            is_superuser => 1,
            params    => { category => { label => 'create-category-2', }, },
            callbacks => [

                # category_sets
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.category_set',
                    count => 0,
                },

                # category
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.category',
                    count => 0,
                },
                {   name => 'MT::App::DataAPI::data_api_save_filter.category',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.category',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.category',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('category')->load(
                    {   category_set_id => $category_set_id,
                        label           => 'create-category-2',
                    }
                );
            },
        }
    );
}

sub irregular_tests_for_create_category {
    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories",
            method    => 'POST',
            author_id => 0,
            params    => { category => { label => 'create-category-3', }, },
            code      => 401,
        }
    );
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/categorySets/$category_set_id/categories",
            method => 'POST',
            params => { category => { label => 'create-category-3', }, },
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'invalid category_set_id',
            path   => "/v4/sites/$site_id/categorySets/1000/categories",
            method => 'POST',
            params => { category => { label => 'create-category-3', }, },
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'other site',
            path   => "/v4/sites/2/categorySets/$category_set_id/categories",
            method => 'POST',
            params => { category => { label => 'create-category-3', }, },
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'no category_set permission',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories",
            method       => 'POST',
            restrictions => { $site_id => ['save_category_set'], },
            params => { category => { label => 'create-category-3', }, },
            code   => 403,
        }
    );
    test_data_api(
        {   note => 'no category permission',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories",
            method       => 'POST',
            restrictions => { $site_id => ['save_category'], },
            params => { category => { label => 'create-category-3', }, },
            code   => 403,
        }
    );
}

sub irregular_tests_for_get_category {
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/categorySets/$category_set_id/categories/$category_id",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid category_set_id',
            path =>
                "/v4/sites/$site_id/categorySets/1000/categories/$category_id",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'invalid category_id',
            path   => "/v4/sites/$site_id/categorySets/1000/categories/1000",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path =>
                "/v4/sites/2/categorySets/$category_set_id/categories/$category_id",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other category set',
            path =>
                "/v4/sites/$site_id/categorySets/$other_category_set_id/categories/$category_id",
            method => 'GET',
            code   => 404,
        }
    );
}

sub normal_tests_for_get_category {
    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id",
            method    => 'GET',
            author_id => 0,
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category',
                    count => 1,
                },
            ],
            result => sub { $category; },
        }
    );
    test_data_api(
        {   note => 'non superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id",
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category',
                    count => 1,
                },
            ],
            result => sub { $category; },
        }
    );
    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id",
            method       => 'GET',
            is_superuser => 1,
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category',
                    count => 0,
                },
            ],
            result => sub { $category; },
        }
    );
}

sub irregular_tests_for_update_category {
    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id",
            method    => 'PUT',
            author_id => 0,
            params    => { category => { label => 'update-category-2', }, },
            code      => 401,
        }
    );
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/categorySets/$category_set_id/categories/$category_id",
            method => 'PUT',
            params => { category => { label => 'update-category-2', }, },
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid category_set_id',
            path =>
                "/v4/sites/$site_id/categorySets/1000/categories/$category_id",
            method => 'PUT',
            params => { category => { label => 'update-category-2', }, },
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid category_set_id',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/1000",
            method => 'PUT',
            params => { category => { label => 'update-category-2', }, },
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path =>
                "/v4/sites/2/categorySets/$category_set_id/categories/$category_id",
            method => 'PUT',
            params => { category => { label => 'update-category-2', }, },
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other category_set',
            path =>
                "/v4/sites/$site_id/categorySets/$other_category_set_id/categories/$category_id",
            method => 'PUT',
            params => { category => { label => 'update-category-2', }, },
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'no category_set permission',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id",
            method       => 'PUT',
            restrictions => { $site_id => ['save_category_set'], },
            params => { category => { label => 'update-category-2', }, },
            code   => 403,
        }
    );
    test_data_api(
        {   note => 'no category permission',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id",
            method       => 'PUT',
            restrictions => { $site_id => ['save_category'], },
            params => { category => { label => 'update-category-2', }, },
            code   => 403,
        }
    );
}

sub normal_tests_for_update_category {
    test_data_api(
        {   note => 'non superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id",
            method    => 'PUT',
            params    => { category => { label => 'update-category', }, },
            callbacks => [

                # category_set
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.category_set',
                    count => 1,
                },

                # category
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.category',
                    count => 1,
                },
                {   name => 'MT::App::DataAPI::data_api_save_filter.category',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.category',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.category',
                    count => 1,
                },
            ],
            result => sub {
                $category = MT->model('category')->load($category_id);
            },
        }
    );
    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id",
            method       => 'PUT',
            is_superuser => 1,
            params    => { category => { label => 'update-category-2', }, },
            callbacks => [

                # category_set
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.category_set',
                    count => 0,
                },

                # category
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.category',
                    count => 0,
                },
                {   name => 'MT::App::DataAPI::data_api_save_filter.category',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.category',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.category',
                    count => 1,
                },
            ],
            result => sub {
                $category = MT->model('category')->load($category_id);
            },
        }
    );
}

sub irregular_tests_for_permutate_categories {
    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/permutate",
            method    => 'POST',
            author_id => 0,
            params    => sub {
                my @order = split ',', $category_set->order;
                @order[ 3, 4 ] = @order[ 4, 3 ];
                +{ categories => [ map { +{ id => $_ } } @order ] };
            },
            code => 401,
        }
    );
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/categorySets/$category_set_id/categories/permutate",
            method => 'POST',
            params => sub {
                my @order = split ',', $category_set->order;
                @order[ 3, 4 ] = @order[ 4, 3 ];
                +{ categories => [ map { +{ id => $_ } } @order ] };
            },
            code => 404,
        }
    );
    test_data_api(
        {   note => 'invalid category_set_id',
            path =>
                "/v4/sites/$site_id/categorySets/1000/categories/permutate",
            method => 'POST',
            params => sub {
                my @order = split ',', $category_set->order;
                @order[ 3, 4 ] = @order[ 4, 3 ];
                +{ categories => [ map { +{ id => $_ } } @order ] };
            },
            code => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path =>
                "/v4/sites/2/categorySets/$category_set_id/categories/permutate",
            method => 'POST',
            params => sub {
                my @order = split ',', $category_set->order;
                @order[ 3, 4 ] = @order[ 4, 3 ];
                +{ categories => [ map { +{ id => $_ } } @order ] };
            },
            code => 404,
        }
    );
    test_data_api(
        {   note => 'no categories paramter',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/permutate",
            method => 'POST',
            code   => 400,
        }
    );
    test_data_api(
        {   note => 'insufficient categories parameter',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/permutate",
            method => 'POST',
            params => sub {
                my @order = split ',', $category_set->order;
                pop @order;
                +{ categories => [ map { +{ id => $_ } } @order ] };
            },
            code => 400,
        }
    );
    test_data_api(
        {   note => 'no category_set permission',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/permutate",
            method       => 'POST',
            restrictions => { $site_id => ['save_category_set'], },
            params       => sub {
                my @order = split ',', $category_set->order;
                +{ categories => [ map { +{ id => $_ } } @order ] };
            },
            code => 403,
        }
    );
    test_data_api(
        {   note => 'no category permission',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/permutate",
            method       => 'POST',
            restrictions => { $site_id => ['edit_categories'], },
            params       => sub {
                my @order = split ',', $category_set->order;
                +{ categories => [ map { +{ id => $_ } } @order ] };
            },
            code => 403,
        }
    );
}

sub normal_tests_for_permutate_categories {
    test_data_api(
        {   note => 'non superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/permutate",
            method => 'POST',
            params => sub {
                my @order = split ',', $category_set->order;
                @order[ 3, 4 ] = @order[ 4, 3 ];
                +{ categories => [ map { +{ id => $_ } } @order ] };
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.category_set',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_bulk_save.category',
                    count => 1,
                },
            ],
            result => sub {
                $category_set = MT->model('category_set')
                    ->load( { id => $category_set_id } );
                my @order = split ',', $category_set->order;

                $app->user($user);

                return MT::DataAPI::Resource->from_object(
                    [ map { $app->model('category')->load($_) } @order ] );
            },
        }
    );
    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/permutate",
            method       => 'POST',
            is_superuser => 1,
            params       => sub {
                my @order = split ',', $category_set->order;
                @order[ 3, 4 ] = @order[ 4, 3 ];
                +{ categories => [ map { +{ id => $_ } } @order ] };
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.category_set',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_bulk_save.category',
                    count => 1,
                },
            ],
            result => sub {
                $category_set = MT->model('category_set')
                    ->load( { id => $category_set_id } );
                my @order = split ',', $category_set->order;

                $app->user($user);

                return MT::DataAPI::Resource->from_object(
                    [ map { $app->model('category')->load($_) } @order ] );
            },
        }
    );
}

sub irregular_tests_for_list_categories {
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/categorySets/$category_set_id/categories",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'invalid category_set_id',
            path   => "/v4/sites/$site_id/categorySets/1000/categories",
            method => 'GET',
            code   => 404,
        }
    );
}

sub normal_tests_for_list_categories {
    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories",
            method    => 'GET',
            author_id => 0,
            params    => { sortBy => 'id', },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.category',
                    count => 2,
                },
            ],
            result => sub {
                my @cats = MT->model('category')->load(
                    { category_set_id => $category_set_id },
                    { sort            => 'id', direction => 'descend' },
                );
                +{  totalResults => scalar @cats,
                    items => MT::DataAPI::Resource->from_object( \@cats ),
                };
            },
        }
    );
    test_data_api(
        {   note => 'non superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories",
            method => 'GET',
            params => {
                sortBy    => 'id',
                sortOrder => 'ascend',
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.category',
                    count => 2,
                },
            ],
            result => sub {
                my @cats = MT->model('category')->load(
                    { category_set_id => $category_set_id },
                    { sort            => 'id', direction => 'ascend' },
                );
                +{  totalResults => scalar @cats,
                    items => MT::DataAPI::Resource->from_object( \@cats ),
                };
            },
        }
    );

    my @cat_ids = map { $_->id } @{ $category_set->categories };
    @cat_ids = @cat_ids[ 3, 4, 0, 1, 2 ];
    $category_set->order( join ',', @cat_ids );
    $category_set->save or die $category_set->errstr;

    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories",
            method       => 'GET',
            is_superuser => 1,
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 0,
                },
                {   name  => 'data_api_pre_load_filtered_list.category',
                    count => 2,
                },
            ],
            result => sub {
                my %cats
                    = map { $_->id => $_ } @{ $category_set->categories };
                my @sorted_cats = map { $cats{$_} } reverse @cat_ids;
                +{  totalResults => scalar @sorted_cats,
                    items =>
                        MT::DataAPI::Resource->from_object( \@sorted_cats ),
                };
            },
        }
    );
}

sub irregular_tests_for_list_parent_categories {
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/categorySets/$category_set_id/categories/$category_id/parents",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid category_set_id',
            path =>
                "/v4/sites/$site_id/categorySets/1000/categories/$category_id/parents",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid category_id',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/1000/parents",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path =>
                "/v4/sites/2/categorySets/$category_set_id/categories/$category_id/parents",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other category_set',
            path =>
                "/v4/sites/$site_id/categorySets/$other_category_set_id/categories/$category_id/parents",
            method => 'GET',
            code   => 404,
        }
    );
}

sub normal_tests_for_list_parent_categories {
    my @cats = MT->model('category')->load( $category->parent );
    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id/parents",
            method    => 'GET',
            author_id => 0,
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category',
                    count => scalar @cats,
                },
            ],
            result => sub {
                +{  totalResults => scalar @cats,
                    items => MT::DataAPI::Resource->from_object( \@cats ),
                };
            },
        }
    );
    test_data_api(
        {   note => 'non superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id/parents",
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category',
                    count => scalar @cats,
                },
            ],
            result => sub {
                my @cats = MT->model('category')->load( $category->parent );
                +{  totalResults => scalar @cats,
                    items => MT::DataAPI::Resource->from_object( \@cats ),
                };
            },
        }
    );
    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id/parents",
            method       => 'GET',
            is_superuser => 1,
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category',
                    count => 0,
                },
            ],
            result => sub {
                my @cats = MT->model('category')->load( $category->parent );
                +{  totalResults => scalar @cats,
                    items => MT::DataAPI::Resource->from_object( \@cats ),
                };
            },
        }
    );
}

sub irregular_tests_for_list_sibling_categories {
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/categorySets/$category_set_id/categories/$category_id/siblings",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid category_set_id',
            path =>
                "/v4/sites/$site_id/categorySets/1000/categories/$category_id/siblings",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid category_id',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/1000/siblings",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path =>
                "/v4/sites/2/categorySets/$category_set_id/categories/$category_id/siblings",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other category_set',
            path =>
                "/v4/sites/$site_id/categorySets/$other_category_set_id/categories/$category_id/siblings",
            method => 'GET',
            code   => 404,
        }
    );
}

sub normal_tests_for_list_sibling_categories {
    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id/siblings",
            method    => 'GET',
            author_id => 0,
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.category',
                    count => 2,
                },
            ],
            result => sub {
                my @cats = MT->model('category')->load(
                    {   id     => { not => $category_id },
                        parent => $category->parent,
                    }
                );
                +{  totalResults => scalar @cats,
                    items => MT::DataAPI::Resource->from_object( \@cats ),
                };
            },
        }
    );
    test_data_api(
        {   note => 'non superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id/siblings",
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.category',
                    count => 2,
                },
            ],
            result => sub {
                my @cats = MT->model('category')->load(
                    {   id     => { not => $category_id },
                        parent => $category->parent,
                    }
                );
                +{  totalResults => scalar @cats,
                    items => MT::DataAPI::Resource->from_object( \@cats ),
                };
            },
        }
    );
    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id/siblings",
            method       => 'GET',
            is_superuser => 1,
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 0,
                },
                {   name  => 'data_api_pre_load_filtered_list.category',
                    count => 2,
                },
            ],
            result => sub {
                my @cats = MT->model('category')->load(
                    {   id     => { not => $category_id },
                        parent => $category->parent,
                    }
                );
                +{  totalResults => scalar @cats,
                    items => MT::DataAPI::Resource->from_object( \@cats ),
                };
            },
        }
    );
}

sub irregular_tests_for_list_child_categories {
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/categorySets/$category_set_id/categories/$parent_category_id/children",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid category_set_id',
            path =>
                "/v4/sites/$site_id/categorySets/1000/categories/$parent_category_id/children",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid category_id',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/1000/children",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path =>
                "/v4/sites/2/categorySets/$category_set_id/categories/$parent_category_id/children",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other category set',
            path =>
                "/v4/sites/$site_id/categorySets/$other_category_set_id/categories/$parent_category_id/children",
            method => 'GET',
            code   => 404,
        }
    );
}

sub normal_tests_for_list_child_categories {
    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$parent_category_id/children",
            method    => 'GET',
            author_id => 0,
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 1,
                },
            ],
            result => sub {
                +{  totalResults => 2,
                    items        => MT::DataAPI::Resource->from_object(
                        [ $sibling_category, $category ]
                    ),
                };
            },
        }
    );
    test_data_api(
        {   note => 'non superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$parent_category_id/children",
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 1,
                },
            ],
            result => sub {
                +{  totalResults => 2,
                    items        => MT::DataAPI::Resource->from_object(
                        [ $sibling_category, $category ]
                    ),
                };
            },
        }
    );
    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$parent_category_id/children",
            method       => 'GET',
            is_superuser => 1,
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 0,
                },
            ],
            result => sub {
                +{  totalResults => 2,
                    items        => MT::DataAPI::Resource->from_object(
                        [ $sibling_category, $category ]
                    ),
                };
            },
        }
    );
}

sub irregular_tests_for_delete_category {
    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id",
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/categorySets/$category_set_id/categories/$category_id",
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid category_set_id',
            path =>
                "/v4/sites/$site_id/categorySets/1000/categories/$category_id",
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid category_id',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/1000",
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path =>
                "/v4/sites/2/categorySets/$category_set_id/categories/$category_id",
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other category_set',
            path =>
                "/v4/sites/$site_id/categorySets/$other_category_set_id/categories/$category_id",
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'no category_set permission',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id",
            method       => 'DELETE',
            restrictions => { $site_id => ['save_category_set'], },
            code         => 403,
        }
    );
    test_data_api(
        {   note => 'no category permission',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id",
            method       => 'DELETE',
            restrictions => { $site_id => ['delete_category'], },
            code         => 403,
        }
    );
}

sub normal_tests_for_delete_category {
    test_data_api(
        {   note => 'non superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/$category_id",
            method    => 'DELETE',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.category_set',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.category',
                    count => 1,
                },
                {   name => 'MT::App::DataAPI::data_api_post_delete.category',
                    count => 1,
                },
            ],
            result   => sub { $category; },
            complete => sub {
                ok( !MT->model('category')->load($category_id) );
            },
        }
    );

    my $cat = MT->model('category')
        ->load( { category_set_id => $category_set_id } );
    ok($cat);

    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/categorySets/$category_set_id/categories/"
                . $cat->id,
            method       => 'DELETE',
            is_superuser => 1,
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.category_set',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.category',
                    count => 0,
                },
                {   name => 'MT::App::DataAPI::data_api_post_delete.category',
                    count => 1,
                },
            ],
            result   => sub { $cat; },
            complete => sub {
                ok( !MT->model('category')->load( $cat->id ) );
            },
        }
    );
}

done_testing;
