#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib extlib t/lib);

use Test::More;
use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # list_categories - normal tests
        {   path      => '/v1/sites/1/categories',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.category',
                    count => 2,
                },
            ],
            setup => sub {
                my $blog = MT->model('blog')->load(1);
                $blog->category_order('1,2');
                $blog->save;

            },
            result => sub {
                +{  'totalResults' => '3',
                    'items'        => MT::DataAPI::Resource->from_object(
                        [ map { MT->model('category')->load($_) } 1, 3, 2 ]
                    ),
                };
            },
        },
        {   path      => '/v1/sites/1/categories',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.category',
                    count => 2,
                },
            ],
            setup => sub {
                my $blog = MT->model('blog')->load(1);
                $blog->category_order('2,1');
                $blog->save;
            },
            result => sub {
                +{  'totalResults' => '3',
                    'items'        => MT::DataAPI::Resource->from_object(
                        [ map { MT->model('category')->load($_) } 2, 1, 3 ]
                    ),
                };
            },
        },
        {    # sortBy label.
            path   => '/v1/sites/1/categories',
            method => 'GET',
            params => {
                sortBy    => 'label',
                sortOrder => 'ascend',
                limit     => 1,
            },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.category',
                    count => 2,
                }
            ],
            result => sub {
                +{  totalResults => 3,
                    items        => MT::DataAPI::Resource->from_object(
                        [   MT->model('category')->load(
                                undef,
                                {   sort      => 'label',
                                    direction => 'ascend',
                                    limit     => 1
                                }
                            )
                        ]
                    ),
                };
            },
        },
        {    # sortBy created_by.
            path      => '/v1/sites/1/categories',
            method    => 'GET',
            params    => { sortBy => 'created_by', },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.category',
                    count => 2,
                }
            ],
            result => sub {
                +{  totalResults => 3,
                    items        => MT::DataAPI::Resource->from_object(
                        [   MT->model('category')
                                ->load( undef, { sort => 'created_by', } )
                        ]
                    ),
                };
            },
        },

        # create_category - normal tests
        {   path   => '/v2/sites/1/categories',
            method => 'POST',
            params =>
                { category => { label => 'test-api-permission-category' }, },
            callbacks => [
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
                MT->model('category')
                    ->load( { label => 'test-api-permission-category' } );
            },
        },
        {   path   => '/v2/sites/1/categories',
            method => 'POST',
            params => {
                category => {
                    label  => 'test-create-category-with-parent',
                    parent => 1,
                },
            },
            callbacks => [
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
                    {   label  => 'test-create-category-with-parent',
                        parent => 1
                    }
                );
            },
        },

        # create_category - irregular tests
        {    # No resource.
            path   => '/v2/sites/1/categories',
            method => 'POST',
            code   => 400,
            error  => 'A resource "category" is required.',
        },
        {    # No label.
            path   => '/v2/sites/1/categories',
            method => 'POST',
            params => { category => {} },
            code   => 409,
            error  => 'A parameter "label" is required.' . "\n",
        },
        {    # Too long label.
            path   => '/v2/sites/1/categories',
            method => 'POST',
            params => { category => { label => ( '1234567890' x 11 ) }, }
            ,    # exceeding 100 characters
            code        => 409,
                  error => "The label '"
                . ( '1234567890' x 11 )
                . "' is too long.\n",
        },
        {        # Category having same name exists.
            path   => '/v2/sites/1/categories',
            method => 'POST',
            params =>
                { category => { label => 'test-api-permission-category' } },
            code => 409,
            error =>
                'Save failed: The category name \'test-api-permission-category\' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.'
                . "\n",
        },
        {        # Invalid parent (folder).
            path   => '/v2/sites/1/categories',
            method => 'POST',
            params => {
                category => {
                    label  => 'test-create-category-with-parent-folder',
                    parent => 20,
                },
            },
            code  => 409,
            error => 'Parent category (ID:20) not found.' . "\n",
        },
        {        # Invalid parent ( non-existent category ).
            path   => '/v2/sites/1/categories',
            method => 'POST',
            params => {
                category => {
                    label  => 'test-create-category-with-invalid-parent',
                    parent => 100,
                },
            },
            code  => 409,
            error => 'Parent category (ID:100) not found.' . "\n",
        },

        # get_category - normal tests
        {   path      => '/v2/sites/1/categories/1',
            method    => 'GET',
            code      => 200,
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category',
                    count => 1,
                },
            ],
            result => sub {
                $app->model('category')->load(1);
            },
        },

        # get_category - irregular tests
        {    # Other site.
            path   => '/v2/sites/2/categories/1',
            method => 'GET',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v2/sites/0/categories/1',
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent category.
            path   => '/v2/sites/1/categories/4',
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/categories/1',
            method => 'GET',
            code   => 404,
        },

        # update_category - normal tests
        {   path   => '/v2/sites/1/categories/1',
            method => 'PUT',
            params => {
                category => { label => 'update-test-api-permission-category' }
            },
            callbacks => [
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
                MT->model('category')
                    ->load(
                    { label => 'update-test-api-permission-category' } );
            },
        },
        {   path      => '/v2/sites/1/categories/1',
            method    => 'PUT',
            params    => { category => { parent => 2 } },
            callbacks => [
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
                MT->model('category')->load( { id => 1, parent => 2 } );
            },
        },

        # update_category - irregular tests
        {    # No resource.
            path   => '/v2/sites/1/categories/1',
            method => 'PUT',
            code   => 400,
            error  => 'A resource "category" is required.',
        },
        {    # No label.
            path   => '/v2/sites/1/categories/1',
            method => 'PUT',
            params => { category => { label => '' } },
            code   => 409,
            error  => 'A parameter "label" is required.' . "\n",
        },
        {    # Too long label.
            path   => '/v2/sites/1/categories/1',
            method => 'PUT',
            params => { category => { label => ( '1234567890' x 11 ) }, }
            ,    # exceeding 100 characters
            code        => 409,
                  error => "The label '"
                . ( '1234567890' x 11 )
                . "' is too long.\n",
        },
        {        # Other site.
            path   => '/v2/sites/1/categories/2',
            method => 'PUT',
            params => {
                category => { label => 'update-test-api-permission-category' }
            },
            setup => sub {
                my $cat = MT->model('category')->load(1);
                $cat->parent(0);
                $cat->save;
            },
            code => 409,
            error =>
                'Save failed: The category name \'update-test-api-permission-category\' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.'
                . "\n",
        },
        {    # Non-existent site.
            path   => '/v2/sites/1/categories/4',
            method => 'PUT',
            params => {
                category =>
                    { label => 'update-test-api-permission-category-2' }
            },
            code => 404,
        },
        {    # Not category (folder).
            path   => '/v2/sites/1/categories/20',
            method => 'PUT',
            params => {
                category => { label => 'update-test-api-permission-folder' },
            },
            code  => 404,
            error => 'Category not found',
        },
        {    # Invalid parent (folder).
            path   => '/v2/sites/1/categories/1',
            method => 'PUT',
            params => { category => { parent => 20 } },
            code   => 409,
            error  => 'Parent category (ID:20) not found.' . "\n",
        },
        {    # Invalid parent (non-existent category).
            path   => '/v2/sites/1/categories/1',
            method => 'PUT',
            params => { category => { parent => 100 } },
            code   => 409,
            error  => 'Parent category (ID:100) not found.' . "\n",
        },

        # list_categories_for_entry - normal tests
        {   path      => '/v2/sites/1/entries/6/categories',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.category',
                    count => 2,
                },
            ],
            result => sub {
                $app->user($author);
                my $cat = $app->model('category')->load(1);
                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};
                return +{
                    'totalResults' => '1',
                    'items' => mt::DataAPI::Resource->from_object( [$cat] ),
                };
            },
        },
        {   path      => '/v2/sites/1/entries/5/categories',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.category',
                    count => 1,
                },
            ],
            result => sub {
                return +{
                    totalResults => 0,
                    items        => [],
                };
            },
        },

        # list_categories_for_entry - irregular tests
        {    # Non-existent entry.
            path   => '/v2/sites/1/entries/10/categories',
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/entries/6/categories',
            method => 'GET',
            code   => 404,
        },
        {    # Other site.
            path   => '/v2/sites/2/entries/6/categories',
            method => 'GET',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v2/sites/0/entries/6/categories',
            method => 'GET',
            code   => 404,
        },

        # list_parent_categories - irregular tests
        {    # Non-existent category.
            path   => '/v2/sites/1/categories/100/parents',
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/categories/3/parents',
            method => 'GET',
            code   => 404,
        },
        {    # Other site.
            path   => '/v2/sites/2/categories/3/parents',
            method => 'GET',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v2/sites/0/categories/3/parents',
            method => 'GET',
            code   => 404,
        },
        {    # Not category (folder).
            path   => '/v2/sites/1/categories/22/parents',
            method => 'GET',
            code   => 404,
        },

        # list_parent_categories - normal tests
        {   path   => '/v2/sites/1/categories/3/parents',
            method => 'GET',
            result => sub {
                $app->user($author);
                my $cat = $app->model('category')->load(1);
                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};
                return +{
                    'totalResults' => '1',
                    'items' => mt::DataAPI::Resource->from_object( [$cat] ),
                };
            },
        },

        # list_sibling_categories - irregular tests
        {    # Non-existent category.
            path   => '/v2/sites/1/categories/100/siblings',
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/categories/3/siblings',
            method => 'GET',
            code   => 404,
        },
        {    # Other site.
            path   => '/v2/sites/2/categories/3/siblings',
            method => 'GET',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v2/sites/0/categories/3/siblings',
            method => 'GET',
            code   => 404,
        },
        {    # Not category (folder).
            path   => '/v2/sites/1/categories/22/siblings',
            method => 'GET',
            code   => 404,
        },

        # list_sibling_categories - normal tests
        {    # Non-top.
            path   => '/v2/sites/1/categories/3/siblings',
            method => 'GET',
            result => sub {
                $app->user($author);
                my $cat = $app->model('category')->load(24);
                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};
                return +{
                    'totalResults' => '1',
                    'items' => mt::DataAPI::Resource->from_object( [$cat] ),
                };
            },
        },
        {    # Top.
            path   => '/v2/sites/1/categories/1/siblings',
            method => 'GET',
            result => sub {
                $app->user($author);
                my @cats
                    = map { $app->model('category')->load($_) } qw/ 2 23 /;
                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};
                return +{
                    'totalResults' => '2',
                    'items' => MT::DataAPI::Resource->from_object( \@cats ),
                };
            },
        },

        # list_child_categories - irregular tests
        {    # Non-existent category.
            path   => '/v2/sites/1/categories/100/children',
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/categories/1/children',
            method => 'GET',
            code   => 404,
        },
        {    # Other site.
            path   => '/v2/sites/2/categories/1/children',
            method => 'GET',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v2/sites/0/categories/1/children',
            method => 'GET',
            code   => 404,
        },
        {    # Not category (folder).
            path   => '/v2/sites/1/categories/22/children',
            method => 'GET',
            code   => 404,
        },

        # list_child_categories - nomal tests
        {   path   => '/v2/sites/1/categories/1/children',
            method => 'GET',
            result => sub {
                $app->user($author);
                my @cats
                    = $app->model('category')->load( { id => [ 3, 24 ] } );
                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};
                return +{
                    totalResults => 2,
                    items => MT::DataAPI::Resource->from_object( \@cats ),
                };
            },
        },

        # permutate_categories - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/5/categories/permutate',
            method => 'POST',
            code   => 404,
        },
        {    # System.
            path   => '/v2/sites/0/categories/permutate',
            method => 'POST',
            code   => 404,
        },
        {    # No categories parameter.
            path   => '/v2/sites/1/categories/permutate',
            method => 'POST',
            code   => 400,
            result => sub {
                return +{
                    error => {
                        code    => 400,
                        message => 'A parameter "categories" is required.',
                    },
                };
            },
        },
        {    # Insufficient categories.
            path   => '/v2/sites/1/categories/permutate',
            method => 'POST',
            params =>
                { categories => [ map { +{ id => $_ } } qw/ 24 23 1 2 / ], },
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A parameter "categories" is invalid.',
                    },
                };
            },
        },

        # permutate_categories - normal tests
        {   path   => '/v2/sites/1/categories/permutate',
            method => 'POST',
            params => {
                categories => [ map { +{ id => $_ } } qw/ 24 23 1 2 3 / ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_post_bulk_save.category',
                    count => 1,
                },
            ],
            result => sub {
                my $site = $app->model('blog')->load(1);
                my @category_order = split ',', $site->category_order;

                $app->user($author);
                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};

                return MT::DataAPI::Resource->from_object(
                    [   map { $app->model('category')->load($_) }
                            @category_order
                    ]
                );
            },
        },

        # delete_category - normal tests
        {   path      => '/v2/sites/1/categories/1',
            method    => 'DELETE',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.category',
                    count => 1,
                },
                {   name => 'MT::App::DataAPI::data_api_post_delete.category',
                    count => 1,
                },
            ],
            complete => sub {
                my $deleted = MT->model('category')->load(1);
                is( $deleted, undef, 'deleted' );
            },
        },

        # delete_category - irregular tests
        {    # Non-existent category.
            path   => '/v2/sites/1/categories/1',
            method => 'DELETE',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/categories/2',
            method => 'DELETE',
            code   => 404,
        },
        {    # Other site.
            path   => '/v2/sites/2/categories/2',
            method => 'DELETE',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v2/sites/0/categories/2',
            method => 'DELETE',
            code   => 404,
        },
        {    # Not category (folder).
            path   => '/v2/sites/1/categories/22',
            method => 'DELETE',
            code   => 404,
        },
    ];
}

