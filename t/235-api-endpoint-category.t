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
                                { blog_id => 1 },
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
            params    => { sortBy => 'created_by' },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.category',
                    count => 2,
                }
            ],
            result => sub {
                +{  totalResults => 3,
                    items        => MT::DataAPI::Resource->from_object(
                        [   MT->model('category')->load(
                                { blog_id => 1 },
                                { sort    => 'created_by' },
                            )
                        ]
                    ),
                };
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
            params => { category => { label => 'foo' } },
            code   => 409,
            error =>
                'Save failed: The category name \'foo\' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.'
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
        {        # Not logged in.
            path   => '/v2/sites/1/categories',
            method => 'POST',
            params =>
                { category => { label => 'test-api-permission-category' }, },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {        # No permissions.
            path   => '/v2/sites/1/categories',
            method => 'POST',
            params =>
                { category => { label => 'test-api-permission-category' }, },
            restrictions => { 1 => [qw/ save_category /], },
            code         => 403,
            error => 'Do not have permission to create a category.',
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
            params => { category => { label => 'foo' } },
            setup  => sub {
                my $cat = MT->model('category')->load(1);
                $cat->parent(0);
                $cat->save;
            },
            code => 409,
            error =>
                'Save failed: The category name \'foo\' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.'
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
        {    # Not logged in.
            path   => '/v2/sites/1/categories/1',
            method => 'PUT',
            params => {
                category => { label => 'update-test-api-permission-category' }
            },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/1/categories/1',
            method => 'PUT',
            params => {
                category => { label => 'update-test-api-permission-category' }
            },
            restrictions => { 1 => [qw/ save_category /], },
            code         => 403,
            error => 'Do not have permission to update a category.',
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
        {    # Unpublished entry and not logged in.
            path      => '/v2/sites/1/entries/3/categories',
            method    => 'GET',
            author_id => 0,
            code      => 403,
            error =>
                'Do not have permission to retrieve the requested categories for entry.',
        },
        {    # Unpublished entry and no permissions.
            path   => '/v2/sites/1/entries/3/categories',
            method => 'GET',
            restrictions =>
                { 1 => [qw/ edit_all_entries edit_all_unpublished_entry /], },
            code => 403,
            error =>
                'Do not have permission to retrieve the requested categories for entry.',
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

                my @cat;
                my $parent     = $app->model('category')->load(3)->parent;
                my $parent_cat = $app->model('category')->load($parent);
                while ($parent_cat) {
                    push @cat, $parent_cat;
                    $parent_cat
                        = $parent_cat->parent
                        ? $app->model('category')->load( $parent_cat->parent )
                        : undef;
                }

                no warnings 'redefine';
                local *boolean::true  = sub {'true'};
                local *boolean::false = sub {'false'};
                return +{
                    'totalResults' => scalar @cat,
                    'items' => mt::DataAPI::Resource->from_object( \@cat ),
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
                my $cat
                    = $app->model('category')
                    ->load(
                    { id => { not => 3 }, blog_id => 1, parent => 1 } );
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
            path     => '/v2/sites/1/categories/2/siblings',
            method   => 'GET',
            complete => sub {
                my ( $data, $body ) = @_;

                my $got = $app->current_format->{unserialize}->($body);

                my $cat  = $app->model('category')->load(2);
                my @cats = $app->model('category')->load(
                    {   id      => { not => $cat->id },
                        blog_id => 1,
                        parent  => $cat->parent,
                    }
                );

                is( $got->{totalResults}, scalar @cats,
                    'Got ' . scalar(@cats) . ' categories.' );

                my @got_ids = sort( map { $_->{id} } @{ $got->{items} } );
                my @expected_ids = sort( map { $_->id } @cats );

                is_deeply( \@got_ids, \@expected_ids,
                          'Got categories\' ID are '
                        . join( ',', @got_ids )
                        . '.' );
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
                my @cats = $app->model('category')
                    ->load( { blog_id => 1, parent => 1 } );
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
            params => sub {
                my @cats = $app->model('category')->load( { blog_id => 1 },
                    { sort => 'id', direction => 'descend' } );
                my @cat_ids = map { { id => $_->id } } @cats;
                pop @cat_ids;
                { categories => \@cat_ids };
            },
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A parameter "categories" is invalid.',
                    },
                };
            },
        },
        {    # Not logged in.
            path   => '/v2/sites/1/categories/permutate',
            method => 'POST',
            params => sub {
                my @cats = $app->model('category')->load( { blog_id => 1 },
                    { sort => 'id', direction => 'descend' } );
                my @cat_ids = map { { id => $_->id } } @cats;
                { categories => \@cat_ids };
            },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites/1/categories/permutate',
            method => 'POST',
            params => sub {
                my @cats = $app->model('category')->load( { blog_id => 1 },
                    { sort => 'id', direction => 'descend' } );
                my @cat_ids = map { { id => $_->id } } @cats;
                { categories => \@cat_ids };
            },
            restrictions => { 1 => [qw/ edit_categories /], },
            code         => 403,
            error => 'Do not have permission to permutate categories.',
        },

        # permutate_categories - normal tests
        {   path   => '/v2/sites/1/categories/permutate',
            method => 'POST',
            params => sub {
                my @cats = $app->model('category')->load( { blog_id => 1 },
                    { sort => 'id', direction => 'descend' } );
                my @cat_ids = map { { id => $_->id } } @cats;
                { categories => \@cat_ids };
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

        # delete_category - irregular tests
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
        {    # Not logged in.
            path      => '/v2/sites/1/categories/1',
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/sites/1/categories/1',
            method       => 'DELETE',
            restrictions => { 1 => [qw/ delete_category /], },
            code         => 403,
            error        => 'Do not have permission to delete a category.',
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
    ];
}

