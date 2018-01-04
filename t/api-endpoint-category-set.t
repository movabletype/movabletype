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

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $user = MT->model('author')->load(1);
$user->email('melody@example.com');
$user->save;

$app->user($user);

my $site_id = 1;

normal_tests_for_create_category_set();
irregular_tests_for_create_category_set();

my $category_set
    = MT->model('category_set')->load( { name => 'create-category-set', } );
ok($category_set);

irregular_tests_for_get_category_set();
normal_tests_for_get_category_set();

irregular_tests_for_update_category_set();
normal_tests_for_update_category_set();

irregular_tests_for_list_category_sets();
normal_tests_for_list_category_sets();

irregular_tests_for_delete_category_sets();
normal_tests_for_delete_category_sets();

sub irregular_tests_for_create_category_set {
    test_data_api(
        {   note      => 'not logged in',
            path      => "/v4/sites/$site_id/category_sets",
            method    => 'POST',
            author_id => 0,
            params => { category_set => { name => 'create-category-set', }, },
            code   => 401,
        }
    );
    test_data_api(
        {   note   => 'invalid site',
            path   => '/v4/sites/1000/category_sets',
            method => 'POST',
            params => { category_set => { name => 'create-category-set', }, },
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'no resource',
            path   => "/v4/sites/$site_id/category_sets",
            method => 'POST',
            code   => 400,
        }
    );
    test_data_api(
        {   note   => 'no name',
            path   => "/v4/sites/$site_id/category_sets",
            method => 'POST',
            params => { category_set => {}, },
            code   => 409,
        }
    );
    test_data_api(
        {   note   => 'duplicated name',
            path   => "/v4/sites/$site_id/category_sets",
            method => 'POST',
            params => { category_set => { name => 'create-category-set', }, },
            code   => 409,
        }
    );
    test_data_api(
        {   note   => 'no permission',
            path   => "/v4/sites/$site_id/category_sets",
            method => 'POST',
            params =>
                { category_set => { name => 'create-category-set-3', }, },
            restrictions => { $site_id => ['save_category_set'], },
            code         => 403,
        }
    );
}

sub normal_tests_for_create_category_set {
    test_data_api(
        {   note   => 'non superuser',
            path   => "/v4/sites/$site_id/category_sets",
            method => 'POST',
            params => { category_set => { name => 'create-category-set', }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.category_set',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.category_set',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.category_set',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.category_set',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('category_set')->load(
                    {   blog_id => $site_id,
                        name    => 'create-category-set',
                    }
                );
            },
        }
    );
    test_data_api(
        {   note         => 'superuser',
            path         => "/v4/sites/$site_id/category_sets",
            is_superuser => 1,
            method       => 'POST',
            params =>
                { category_set => { name => 'create-category-set-2', }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.category_set',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.category_set',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.category_set',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.category_set',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('category_set')->load(
                    {   blog_id => $site_id,
                        name    => 'create-category-set-2',
                    }
                );
            },
        }
    );
}

sub irregular_tests_for_get_category_set {
    test_data_api(
        {   note   => 'invalid category_set id',
            path   => "/v4/sites/$site_id/category_sets/1000",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'other site',
            path   => "/v4/sites/2/category_sets/" . $category_set->id,
            method => 'GET',
            code   => 404,
        }
    );
}

sub normal_tests_for_get_category_set {
    test_data_api(
        {   note => 'not logged in',
            path => "/v4/sites/$site_id/category_sets/" . $category_set->id,
            author_id => 0,
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 1,
                },
            ],
            result => sub {
                MT::DataAPI::Resource->from_object(
                    $category_set,
                    [   qw( blog categories createdBy createdDate id modifiedBy modifiedDate name updatable )
                    ]
                );
            },
        }
    );
    test_data_api(
        {   note   => 'non superuser',
            path   => "/v4/sites/$site_id/category_sets/" . $category_set->id,
            method => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 1,
                },
            ],
            result => $category_set,
        }
    );
    test_data_api(
        {   note => 'superuser',
            path => "/v4/sites/$site_id/category_sets/" . $category_set->id,
            is_superuser => 1,
            method       => 'GET',
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.category_set',
                    count => 0,
                },
            ],
            result => $category_set,
        }
    );
}

sub irregular_tests_for_update_category_set {
    test_data_api(
        {   note   => 'not logged in',
            path   => "/v4/sites/$site_id/category_sets/" . $category_set->id,
            method => 'PUT',
            author_id => 0,
            params => { category_set => { name => 'update-category-set', }, },
            code   => 401,
        }
    );
    test_data_api(
        {   note   => 'invalid site_id',
            path   => '/v4/sites/1000/category_sets/' . $category_set->id,
            method => 'PUT',
            params => { category_set => { name => 'update-category-set', }, },
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'other site',
            path   => '/v4/sites/2/category_sets/' . $category_set->id,
            method => 'PUT',
            params => { category_set => { name => 'update-category-set', }, },
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'empty name',
            path   => "/v4/sites/$site_id/category_sets/" . $category_set->id,
            method => 'PUT',
            params => { category_set => { name => '', }, },
            code   => 409,
        }
    );
    test_data_api(
        {   note   => 'duplicated name',
            path   => "/v4/sites/$site_id/category_sets/" . $category_set->id,
            method => 'PUT',
            params =>
                { category_set => { name => 'create-category-set-2', }, },
            code => 409,
        }
    );
    test_data_api(
        {   note   => 'no permission',
            path   => "/v4/sites/$site_id/category_sets/" . $category_set->id,
            method => 'PUT',
            restrictions => { $site_id => ['save_category_set'], },
            params => { category_set => { name => 'update-category-set', }, },
            code   => 403,
        }
    );
}

sub normal_tests_for_update_category_set {
    test_data_api(
        {   note   => 'no superuser',
            path   => "/v4/sites/$site_id/category_sets/" . $category_set->id,
            method => 'PUT',
            params => { category_set => { name => 'update-category-set', }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.category_set',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.category_set',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.category_set',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.category_set',
                    count => 1,
                },
            ],
            result => sub {
                ok( !MT->model('category_set')
                        ->exist( { name => 'create-category-set' } ) );
                $category_set = MT->model('category_set')->load(
                    {   id   => $category_set->id,
                        name => 'update-category-set'
                    }
                );
            },
        }
    );
    test_data_api(
        {   note   => 'superuser',
            path   => "/v4/sites/$site_id/category_sets/" . $category_set->id,
            method => 'PUT',
            is_superuser => 1,
            params =>
                { category_set => { name => 'update-category-set-2', }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.category_set',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.category_set',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.category_set',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.category_set',
                    count => 1,
                },
            ],
            result => sub {
                ok( !MT->model('category_set')
                        ->exist( { name => 'update-category-set' } ) );
                $category_set = MT->model('category_set')->load(
                    {   id   => $category_set->id,
                        name => 'update-category-set-2'
                    }
                );
            },
        }
    );
}

sub irregular_tests_for_list_category_sets {
    test_data_api(
        {   note   => 'invalid site_id',
            path   => '/v4/sites/1000/category_sets',
            method => 'GET',
            code   => 404,
        }
    );
}

sub normal_tests_for_list_category_sets {
    test_data_api(
        {   note      => 'not logged in',
            path      => "/v4/sites/$site_id/category_sets",
            method    => 'GET',
            author_id => 0,
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.category_set',
                    count => 2,
                },
            ],
            result => sub {
                +{  totalResults => 2,
                    items        => MT::DataAPI::Resource->from_object(
                        [   MT->model('category_set')
                                ->load( { blog_id => $site_id } )
                        ],
                        [   qw( blog categories createdBy createdDate id modifiedBy modifiedDate name updatable )
                        ],
                    ),
                };
            },

        }
    );
    test_data_api(
        {   note      => 'non superuser',
            path      => "/v4/sites/$site_id/category_sets",
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.category_set',
                    count => 2,
                },
            ],
            result => sub {
                +{  totalResults => 2,
                    items        => MT::DataAPI::Resource->from_object(
                        [   MT->model('category_set')
                                ->load( { blog_id => $site_id } )
                        ]
                    ),
                };
            },
        }
    );
    test_data_api(
        {   note         => 'superuser',
            path         => "/v4/sites/$site_id/category_sets",
            method       => 'GET',
            is_superuser => 1,
            callbacks    => [
                {   name  => 'data_api_pre_load_filtered_list.category_set',
                    count => 2,
                },
            ],
            result => sub {
                +{  totalResults => 2,
                    items        => MT::DataAPI::Resource->from_object(
                        [   MT->model('category_set')
                                ->load( { blog_id => $site_id } )
                        ]
                    ),
                };
            },
        }
    );
}

sub irregular_tests_for_delete_category_sets {
    test_data_api(
        {   note   => 'not logged in',
            path   => "/v4/sites/$site_id/category_sets/" . $category_set->id,
            method => 'DELETE',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note   => 'invalid site_id',
            path   => '/v4/sites/1000/category_sets/' . $category_set->id,
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'invalid category_set_id',
            path   => "/v4/sits/$site_id/category_sets/1000",
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'other site',
            path   => '/v4/sites/2/category_sets/' . $category_set->id,
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'no permission',
            path   => "/v4/sites/$site_id/category_sets/" . $category_set->id,
            method => 'DELETE',
            restrictions => { $site_id => ['delete_category_set'], },
            code         => 403,
        }
    );
}

sub normal_tests_for_delete_category_sets {
    test_data_api(
        {   note   => 'non superuser',
            path   => "/v4/sites/$site_id/category_sets/" . $category_set->id,
            method => 'DELETE',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.category_set',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.category_set',
                    count => 1,
                },
            ],
            result => sub {
                $category_set;
            },
            complete => sub {
                ok( !MT->model('category_set')->load( $category_set->id ) );
            },
        }
    );

    my $cs = MT->model('category_set')->load;
    ok($cs);

    test_data_api(
        {   note         => 'superuser',
            path         => "/v4/sites/$site_id/category_sets/" . $cs->id,
            method       => 'DELETE',
            is_superuser => 1,
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.category_set',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.category_set',
                    count => 1,
                },
            ],
            result => sub {
                $cs;
            },
            complete => sub {
                ok( !MT->model('category_set')->exist );
            },
        }
    );
}

done_testing;

