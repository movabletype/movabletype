use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
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

normal_tests_for_create();
irregular_tests_for_create();

irregular_tests_for_list();
normal_tests_for_list();

irregular_tests_for_get();
normal_tests_for_get();

irregular_tests_for_update();
normal_tests_for_update();

irregular_tests_for_delete();
normal_tests_for_delete();

sub normal_tests_for_create {
    test_data_api(
        {   note   => 'has system permission',
            path   => "/v4/sites/$site_id/contentTypes",
            method => 'POST',
            params => {
                content_type => {
                    name        => 'create-content-type',
                    description => 'description',
                },
            },
            restrictions => {
                $site_id =>
                    [ 'create_new_content_type', 'edit_all_content_types' ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_type',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_type')->load(
                    {   blog_id     => $site_id,
                        name        => 'create-content-type',
                        description => 'description',
                    }
                );
            },
        }
    );
    test_data_api(
        {   note   => 'has site permission',
            path   => "/v4/sites/$site_id/contentTypes",
            method => 'POST',
            params => {
                content_type => {
                    name        => 'create-content-type-2',
                    description => 'description',
                },
            },
            restrictions => {
                0 => [ 'create_new_content_type', 'edit_all_content_types' ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_type',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_type')->load(
                    {   blog_id     => $site_id,
                        name        => 'create-content-type-2',
                        description => 'description',
                    }
                );
            },
        }
    );
    test_data_api(
        {   note         => 'superuser',
            path         => "/v4/sites/$site_id/contentTypes",
            method       => 'POST',
            is_superuser => 1,
            params       => {
                content_type => {
                    name        => 'create-content-type-3',
                    description => 'description',
                },
            },
            restrictions => {
                0 => [ 'create_new_content_type', 'edit_all_content_types' ],
                $site_id =>
                    [ 'create_new_content_type', 'edit_all_content_types' ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_type',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_type',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_type')->load(
                    {   blog_id     => $site_id,
                        name        => 'create-content-type-3',
                        description => 'description',
                    }
                );
            },
        }
    );
}

sub irregular_tests_for_create {
    test_data_api(
        {   note      => 'not logged in',
            path      => "/v4/sites/$site_id/contentTypes",
            method    => 'POST',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note   => 'invalid site_id',
            path   => '/v4/sites/1000/contentTypes',
            method => 'POST',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'no content_type resource',
            path   => "/v4/sites/$site_id/contentTypes",
            method => 'POST',
            params => {},
            code   => 400,
        }
    );
    test_data_api(
        {   note   => 'no name',
            path   => "/v4/sites/$site_id/contentTypes",
            method => 'POST',
            params => { content_type => {}, },
            code   => 409,
        }
    );
    test_data_api(
        {   note   => 'duplicated name',
            path   => "/v4/sites/$site_id/contentTypes",
            method => 'POST',
            params => { content_type => { name => 'create-content-type', } },
            code   => 409,
        }
    );
    test_data_api(
        {   note         => 'no permission',
            path         => "/v4/sites/$site_id/contentTypes",
            method       => 'POST',
            restrictions => {
                0 => [ 'create_new_content_type', 'edit_all_content_types' ],
                $site_id =>
                    [ 'create_new_content_type', 'edit_all_content_types' ],
            },
            params => {
                content_type =>
                    { name => 'create-content-type-no-permission', },
            },
            code => 403,
        }
    );
}

sub irregular_tests_for_list {
    test_data_api(
        {   note      => 'not logged in',
            path      => "/v4/sites/$site_id/contentTypes",
            method    => 'GET',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note   => 'invalid site_id',
            path   => '/v4/sites/1000/contentTypes',
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note         => 'no permission',
            path         => "/v4/sites/$site_id/contentTypes",
            method       => 'GET',
            restrictions => {
                0        => ['manage_content_types'],
                $site_id => ['manage_content_types'],
            },
            code => 403,
        }
    );
    test_data_api(
        {   note   => 'system scope',
            path   => '/v4/sites/0/contentTypes',
            method => 'GET',
            code   => 404,
        }
    );
}

sub normal_tests_for_list {
    test_data_api(
        {   note         => 'has system permission',
            path         => "/v4/sites/$site_id/contentTypes",
            method       => 'GET',
            restrictions => { $site_id => ['manage_content_types'], },
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_list_permission_filter.content_type',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.content_type',
                    count => 2,
                },
            ],
            result => sub {
                my @ct = MT->model('content_type')
                    ->load( { blog_id => $site_id } );
                +{  totalResults => scalar @ct,
                    items => MT::DataAPI::Resource->from_object( \@ct ),
                };
            },
        }
    );
    test_data_api(
        {   note         => 'has site permission',
            path         => "/v4/sites/$site_id/contentTypes",
            method       => 'GET',
            restrictions => { 0 => ['manage_content_types'], },
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_list_permission_filter.content_type',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.content_type',
                    count => 2,
                },
            ],
            result => sub {
                my @ct = MT->model('content_type')
                    ->load( { blog_id => $site_id } );
                +{  totalResults => scalar @ct,
                    items => MT::DataAPI::Resource->from_object( \@ct ),
                };
            },
        }
    );
    test_data_api(
        {   note         => 'superuser',
            path         => "/v4/sites/$site_id/contentTypes",
            method       => 'GET',
            is_superuser => 1,
            restrictions => {
                0        => ['manage_content_types'],
                $site_id => ['manage_content_types'],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_list_permission_filter.content_type',
                    count => 0,
                },
                {   name  => 'data_api_pre_load_filtered_list.content_type',
                    count => 2,
                },
            ],
            result => sub {
                my @ct = MT->model('content_type')
                    ->load( { blog_id => $site_id } );
                +{  totalResults => scalar @ct,
                    items => MT::DataAPI::Resource->from_object( \@ct ),
                };
            },
        }
    );
}

sub irregular_tests_for_get {
    my $ct = MT->model('content_type')->load( { blog_id => $site_id } );
    ok($ct);

    test_data_api(
        {   note      => 'not logged in',
            path      => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method    => 'GET',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note   => 'invalid site_id',
            path   => '/v4/sites/1000/contentTypes/' . $ct->id,
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'invalid content_type_id',
            path   => "/v4/sites/$site_id/contentTypes/1000",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'other site',
            path   => '/v4/sites/2/contentTypes/' . $ct->id,
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note         => 'no permission',
            path         => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method       => 'GET',
            restrictions => {
                0        => ['edit_all_content_types'],
                $site_id => ['edit_all_content_types'],
            },
            code => 403,
        }
    );
}

sub normal_tests_for_get {
    my $ct = MT->model('content_type')->load( { blog_id => $site_id } );
    ok($ct);

    test_data_api(
        {   note         => 'has system permission',
            path         => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method       => 'GET',
            restrictions => { $site_id => ['edit_all_content_types'], },
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.content_type',
                    count => 1,
                },
            ],
            result => sub { $ct; },
        }
    );
    test_data_api(
        {   note         => 'has site permission',
            path         => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method       => 'GET',
            restrictions => { 0 => ['edit_all_content_types'], },
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.content_type',
                    count => 1,
                },
            ],
            result => sub { $ct; },
        }
    );
    test_data_api(
        {   note         => 'superuser',
            path         => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method       => 'GET',
            is_superuser => 1,
            restrictions => {
                0        => ['edit_all_content_types'],
                $site_id => ['edit_all_content_types'],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.content_type',
                    count => 0,
                },
            ],
            result => sub { $ct; },
        }
    );
}

sub irregular_tests_for_update {
    my $ct = MT->model('content_type')->load( { blog_id => $site_id } );
    ok($ct);

    test_data_api(
        {   note      => 'not logged in',
            path      => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method    => 'PUT',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note   => 'invalid site_id',
            path   => '/v4/sites/1000/contentTypes/' . $ct->id,
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'invalid content_type_id',
            path   => "/v4/sites/$site_id/contentTypes/1000",
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'other site',
            path   => '/v4/sites/2/contentTypes/' . $ct->id,
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'no permission',
            path   => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method => 'PUT',
            params => { content_type => { name => $ct->name . ' update', }, },
            restrictions => {
                0        => ['edit_all_content_types'],
                $site_id => ['edit_all_content_types'],
            },
            code => 403,
        }
    );
    test_data_api(
        {   note   => 'no content_type resource',
            path   => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method => 'PUT',
            code   => 400,
        }
    );
    test_data_api(
        {   note   => 'empty name',
            path   => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method => 'PUT',
            params => { content_type => { name => '', }, },
            code   => 409,
        }
    );

    my $ct2 = MT->model('content_type')->load(
        {   id      => { not => $ct->id },
            blog_id => $ct->blog_id,
        }
    );
    ok($ct2);

    test_data_api(
        {   name   => 'duplicated name',
            path   => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method => 'PUT',
            params => { content_type => { name => $ct2->name, }, },
            code   => 409,
        }
    );
}

sub normal_tests_for_update {
    my $ct = MT->model('content_type')->load( { blog_id => $site_id } );
    ok($ct);
    my $original_name = $ct->name;

    test_data_api(
        {   note   => 'has system permission',
            path   => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method => 'PUT',
            params => { content_type => { name => $ct->name . ' update', }, },
            restrictions => { $site_id => ['edit_all_content_types'], },
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_type',
                    count => 1,
                },
            ],
            result => sub {
                $ct = MT->model('content_type')->load( { id => $ct->id } );
            },
            complete => sub {
                is( $ct->name, $original_name . ' update' );
                ok( !MT->model('content_type')->load(
                        {   blog_id => $site_id,
                            name    => $original_name,
                        }
                    )
                );
            },
        }
    );

    $original_name = $ct->name;
    test_data_api(
        {   note   => 'has site permission',
            path   => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method => 'PUT',
            params => { content_type => { name => $ct->name . ' update', }, },
            restrictions => { 0 => ['edit_all_content_types'], },
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_type',
                    count => 1,
                },
            ],
            result => sub {
                $ct = MT->model('content_type')->load( { id => $ct->id } );
            },
            complete => sub {
                is( $ct->name, $original_name . ' update' );
                ok( !MT->model('content_type')->load(
                        {   blog_id => $site_id,
                            name    => $original_name,
                        }
                    )
                );
            },
        }
    );

    $original_name = $ct->name;
    test_data_api(
        {   note         => 'superuser',
            path         => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method       => 'PUT',
            is_superuser => 1,
            params => { content_type => { name => $ct->name . ' update', }, },
            restrictions => {
                0        => ['edit_all_content_types'],
                $site_id => ['edit_all_content_types'],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_type',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_type',
                    count => 1,
                },
            ],
            result => sub {
                $ct = MT->model('content_type')->load( { id => $ct->id } );
            },
            complete => sub {
                is( $ct->name, $original_name . ' update' );
                ok( !MT->model('content_type')->load(
                        {   blog_id => $site_id,
                            name    => $original_name,
                        }
                    )
                );
            },
        }
    );
}

sub irregular_tests_for_delete {
    my $ct = MT->model('content_type')->load( { blog_id => $site_id } );
    ok($ct);

    test_data_api(
        {   note      => 'not logged in',
            path      => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note   => 'invalid site_id',
            path   => '/v4/sites/1000/contentTypes/' . $ct->id,
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'invalid content_type_id',
            path   => "/v4/sites/$site_id/contentTypes/1000",
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'other site',
            path   => '/v4/sites/2/contentTypes/' . $ct->id,
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note         => 'no permission',
            path         => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['delete_content_type'],
                $site_id => ['delete_content_type'],
            },
            code => 403,
        }
    );
}

sub normal_tests_for_delete {
    my $ct = MT->model('content_type')->load( { blog_id => $site_id } );
    ok($ct);

    test_data_api(
        {   note         => 'has system permission',
            path         => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method       => 'DELETE',
            restrictions => { $site_id => ['delete_content_type'], },
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_type',
                    count => 1,
                },
            ],
            result   => sub { $ct; },
            complete => sub {
                ok( !MT->model('content_type')->load( $ct->id ) );
            },
        }
    );

    $ct = MT->model('content_type')->load( { blog_id => $site_id } );
    ok($ct);

    test_data_api(
        {   note         => 'has site permission',
            path         => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method       => 'DELETE',
            restrictions => { 0 => ['delete_content_type'], },
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_type',
                    count => 1,
                },
            ],
            result   => sub { $ct; },
            complete => sub {
                ok( !MT->model('content_type')->load( $ct->id ) );
            },
        }
    );

    $ct = MT->model('content_type')->load( { blog_id => $site_id } );
    ok($ct);

    test_data_api(
        {   note         => 'superuser',
            path         => "/v4/sites/$site_id/contentTypes/" . $ct->id,
            method       => 'DELETE',
            is_superuser => 1,
            restrictions => {
                0        => ['delete_content_type'],
                $site_id => ['delete_content_type'],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_type',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_type',
                    count => 1,
                },
            ],
            result   => sub { $ct; },
            complete => sub {
                ok( !MT->model('content_type')->load( $ct->id ) );
            },
        }
    );

}

done_testing;

