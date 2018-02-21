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

use MT::ContentStatus;

my $user = MT->model('author')->load(1);
$user->email('melody@example.com');
$user->save;

$app->user($user);

my $site_id = 1;

my $content_type
    = MT::Test::Permission->make_content_type( blog_id => $site_id );
my $content_type_id = $content_type->id;

my $single_field = MT::Test::Permission->make_content_field(
    blog_id         => $content_type->blog_id,
    content_type_id => $content_type->id,
    name            => 'single',
    type            => 'single_line_text',
);

my $fields = [
    {   id        => $single_field->id,
        order     => 1,
        type      => $single_field->type,
        options   => { label => $single_field->name },
        unique_id => $single_field->unique_id,
    }
];
$content_type->fields($fields);
$content_type->save or die $content_type->errstr;

my $other_content_type
    = MT::Test::Permission->make_content_type( blog_id => $site_id );
my $other_content_type_id = $other_content_type->id;

$user->permissions(0)->rebuild;
$user->permissions($site_id)->rebuild;

irregular_tests_for_create();
normal_tests_for_create();

normal_tests_for_list();
irregular_tests_for_list();

irregular_tests_for_get();
normal_tests_for_get();

irregular_tests_for_update();
normal_tests_for_update();

irregular_tests_for_delete();
normal_tests_for_delete();

done_testing;

sub irregular_tests_for_create {
    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method    => 'POST',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/contentTypes/$content_type_id/data",
            method => 'POST',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'invalid content_type_id',
            path   => "/v4/sites/$site_id/contentTypes/1000/data",
            method => 'POST',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'no permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method       => 'POST',
            params       => { content_data => {} },
            restrictions => {
                0 => [
                    'create_new_content_data', 'publish_all_content_data',
                ],
                $site_id => [
                    'create_new_content_data',
                    'create_new_content_data_' . $content_type->unique_id,
                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );
    test_data_api(
        {   note => 'not draft content_data without publish permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method       => 'POST',
            params       => { content_data => { status => 'Publish' } },
            restrictions => {
                0 => [

                    # 'create_new_content_data',
                    'publish_all_content_data',
                ],
                $site_id => [

                    # 'create_new_content_data',
                    # 'create_new_content_data_' . $content_type->unique_id,
                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );
}

sub normal_tests_for_create {
    test_data_api(
        {   note => 'system permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => {
                content_data => {
                    data => [
                        {   id   => $single_field->id,
                            data => 'single',
                        },
                    ],
                },
            },
            restrictions => {

                # 0 => [
                #     'create_new_content_data', 'publish_all_content_data',
                # ],
                $site_id => [
                    'create_new_content_data',
                    'create_new_content_data_' . $content_type->unique_id,
                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
        }
    );

    test_data_api(
        {   note => 'system permission and draft content_data',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method       => 'POST',
            params       => { content_data => { status => 'Draft', }, },
            restrictions => {
                0 => [

                    # 'create_new_content_data',
                    'publish_all_content_data',
                ],
                $site_id => [
                    'create_new_content_data',
                    'create_new_content_data_' . $content_type->unique_id,
                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
        }
    );

    test_data_api(
        {   note => 'blog.manage_content_data',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method       => 'POST',
            params       => { content_data => {}, },
            restrictions => {
                0 => [
                    'create_new_content_data', 'publish_all_content_data',
                ],
                $site_id => [

                    # 'create_new_content_data',
                    'create_new_content_data_' . $content_type->unique_id,

                    # 'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
        }
    );

    test_data_api(
        {   note => 'blog.manage_content_data and draft content_data',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method       => 'POST',
            params       => { content_data => { status => 'Draft', }, },
            restrictions => {
                0 => [
                    'create_new_content_data', 'publish_all_content_data',
                ],
                $site_id => [

                    # 'create_new_content_data',
                    'create_new_content_data_' . $content_type->unique_id,

                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
        }
    );

    test_data_api(
        {   note => 'blog.manage_content_data:???',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method       => 'POST',
            params       => { content_data => {}, },
            restrictions => {
                0 => [
                    'create_new_content_data', 'publish_all_content_data',
                ],
                $site_id => [

                    'create_new_content_data',

                    # 'create_new_content_data_' . $content_type->unique_id,

                    'publish_all_content_data',

                    # 'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
        }
    );

    test_data_api(
        {   note => 'blog.manage_content_data:??? and own content_data',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method       => 'POST',
            params       => { content_data => {}, },
            restrictions => {
                0 => [
                    'create_new_content_data', 'publish_all_content_data',
                ],
                $site_id => [

                    'create_new_content_data',

                    # 'create_new_content_data_' . $content_type->unique_id,

                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,

                    # 'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
        }
    );

    test_data_api(
        {   note => 'blog.manage_content_data:??? and draft content_data',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method       => 'POST',
            params       => { content_data => { status => 'Draft' }, },
            restrictions => {
                0 => [
                    'create_new_content_data', 'publish_all_content_data',
                ],
                $site_id => [

                    'create_new_content_data',

                    # 'create_new_content_data_' . $content_type->unique_id,

                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
        }
    );

    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method       => 'POST',
            is_superuser => 1,
            restrictions => {
                0 => [
                    'create_new_content_data', 'publish_all_content_data',
                ],
                $site_id => [
                    'create_new_content_data',
                    'create_new_content_data_' . $content_type->unique_id,
                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            params    => { content_data => {}, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
        }
    );
}

sub irregular_tests_for_list {
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/contentTypes/$content_type_id/data",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'invalid content_type_id',
            path   => "/v4/sites/$site_id/contentTypes/1000/data",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path => "/v4/sites/2/contentTypes/$content_type_id/data",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'system scope',
            path => "/v4/sites/0/contentTypes/$content_type_id/data",
            method => 'GET',
            code   => 404,
        }
    );
}

sub normal_tests_for_list {
    my $exists_draft = MT->model('content_data')->exist(
        {   content_type_id => $content_type_id,
            status          => MT::ContentStatus::HOLD(),
        }
    );
    unless ($exists_draft) {
        MT::Test::Permission->make_content_data(
            blog_id         => $site_id,
            content_type_id => $content_type_id,
            status          => MT::ContentStatus::HOLD(),
        );
    }
    my $exists_others = MT->model('content_data')->exist(
        {   content_type_id => $other_content_type_id,
            status          => MT::ContentStatus::RELEASE(),
        }
    );
    unless ( $exists_others ) {
        MT::Test::Permission->make_content_data(
            blog_id         => $site_id,
            content_type_id => $other_content_type_id,
            status          => MT::ContentStatus::RELEASE(),
        );
    }

    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method    => 'GET',
            author_id => 0,
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_list_permission_filter.content_data',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.content_data',
                    count => 2,
                },
            ],
            result => sub {
                my @cd = MT->model('content_data')->load(
                    {   content_type_id => $content_type_id,
                        status          => MT::ContentStatus::RELEASE(),
                    },
                    { sort => 'modified_on', direction => 'descend', },
                );
                +{  totalResults => scalar @cd,
                    items => MT::DataAPI::Resource->from_object( \@cd ),
                };
            },
        }
    );

    test_data_api(
        {   note => 'logged in',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_list_permission_filter.content_data',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.content_data',
                    count => 2,
                },
            ],
            result => sub {
                my @cd = MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    { sort => 'modified_on', direction => 'descend', },
                );
                +{  totalResults => scalar @cd,
                    items => MT::DataAPI::Resource->from_object( \@cd ),
                };
            },
        }
    );
}

sub irregular_tests_for_get {
    my $cd
        = MT->model('content_data')
        ->load( { content_type_id => $content_type_id } )
        or die;

    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/contentTypes/$content_type_id/data/"
                . $cd->id,
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid content_type_id',
            path => "/v4/sites/$site_id/contentTypes/1000/data/"
                . $cd->id,
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid content_data_id',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/1000",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path => "/v4/sites/2/contentTypes/$content_type_id/data/"
                . $cd->id,
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other content_type',
            path =>
                "/v4/sites/$site_id/contentTypes/$other_content_type_id/data/"
                . $cd->id,
            method => 'GET',
            code   => 404,
        }
    );

    $cd->status( MT::ContentStatus::HOLD() );
    $cd->save or die;
    test_data_api(
        {   note => 'draft content_data without permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'GET',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );

    test_data_api(
        {   note => 'draft content_data when not logged in',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method    => 'GET',
            author_id => 0,
            code      => 403,
        }
    );

}

sub normal_tests_for_get {
    my $cd
        = MT->model('content_data')
        ->load( { content_type_id => $content_type_id } )
        or die;

    $cd->status( MT::ContentStatus::RELEASE() );
    $cd->save or die;
    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            author_id => 0,
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.content_data',
                    count => 1,
                },
            ],
            result => sub {$cd},
        }
    );

    test_data_api(
        {   note => 'permitted user',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.content_data',
                    count => 1,
                },
            ],
            result => sub {$cd},
        }
    );

    $cd->status( MT::ContentStatus::HOLD() );
    $cd->save or die;
    test_data_api(
        {   note => 'draft content_data by permitted user',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'GET',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,

                    # 'edit_own_unpublished_content_data_'
                    # . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.content_data',
                    count => 1,
                },
            ],
            result => sub {$cd},
        }
    );
}

sub irregular_tests_for_update {
    my $cd
        = MT->model('content_data')
        ->load( { content_type_id => $content_type_id } )
        or die;

    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method    => 'PUT',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/contentTypes/$content_type_id/data/"
                . $cd->id,
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid content_type_id',
            path => "/v4/sites/$site_id/contentTypes/1000/data/"
                . $cd->id,
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid content_data_id',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/1000",
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path =>
                "/v4/sites/2/contentTypes/$content_type_id/data/"
                . $cd->id,
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other content_type',
            path =>
                "/v4/sites/$site_id/contentTypes/$other_content_type_id/data/"
                . $cd->id,
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'no permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {} },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );

    $cd->status( MT::ContentStatus::HOLD() );
    $cd->save or die;
    test_data_api(
        {   note => 'published permissions and draft content_data',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {} },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,

                    # 'edit_own_published_content_data_'
                    #     . $content_type->unique_id,
                    # 'edit_all_published_content_data_'
                    #     . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );

    $cd->status( MT::ContentStatus::RELEASE() );
    $cd->save or die;
    test_data_api(
        {   note => 'unpublished permissions and published content_data',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {} },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,

                    # 'edit_own_unpublished_content_data_'
                    # . $content_type->unique_id,
                    # 'edit_all_unpublished_content_data_'
                    # . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );

    $cd->author_id(2);
    $cd->save or die;
    test_data_api(
        {   note => 'own permissions and other content_data',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {} },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,

                    # 'edit_own_published_content_data_'
                    #    . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,

                    #  'edit_own_unpublished_content_data_'
                    # . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );
}

sub normal_tests_for_update {
    my $cd
        = MT->model('content_data')
        ->load( { content_type_id => $content_type_id } )
        or die;

    $cd->status( MT::ContentStatus::HOLD() );
    $cd->save or die;
    test_data_api(
        {   note => 'system permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {}, },
            restrictions => {

                # 0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                $cd = MT->model('content_data')->load( $cd->id );
            },
        }
    );

    test_data_api(
        {   note => 'blog permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {}, },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [

                    # 'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                $cd = MT->model('content_data')->load( $cd->id );
            },
        }
    );

    test_data_api(
        {   note => 'content_type permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {}, },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',

                    # 'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                $cd = MT->model('content_data')->load( $cd->id );
            },
        }
    );

    $cd->author_id(2);
    $cd->save or die;
    test_data_api(
        {   note => 'content_type edit_all_unpublished permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {}, },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,

                    # 'edit_all_unpublished_content_data_'
                    # . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                $cd = MT->model('content_data')->load( $cd->id );
            },
        }
    );

    $cd->status( MT::ContentStatus::RELEASE() );
    $cd->save or die;
    test_data_api(
        {   note => 'content_type edit_all published permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {}, },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,

                    # 'edit_all_published_content_data_'
                    # . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                $cd = MT->model('content_data')->load( $cd->id );
            },
        }
    );

    $cd->author_id(1);
    $cd->status( MT::ContentStatus::HOLD() );
    $cd->save or die;
    test_data_api(
        {   note => 'content_type edit_own_unpublished permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {}, },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,

                    # 'edit_own_unpublished_content_data_'
                    # . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                $cd = MT->model('content_data')->load( $cd->id );
            },
        }
    );

    $cd->status( MT::ContentStatus::RELEASE() );
    $cd->save or die;
    test_data_api(
        {   note => 'content_type edit_own_published permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {}, },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,

                    # 'edit_own_published_content_data_'
                    #    . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                $cd = MT->model('content_data')->load( $cd->id );
            },
        }
    );

    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {}, },
            is_superuser => 1,
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                $cd = MT->model('content_data')->load( $cd->id );
            },
        }
    );
}

sub irregular_tests_for_delete {
    my $cd
        = MT->model('content_data')
        ->load( { content_type_id => $content_type_id } )
        or die;

    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/contentTypes/$content_type_id/data/"
                . $cd->id,
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid content_type_id',
            path => "/v4/sites/$site_id/contentTypes/1000/data/"
                . $cd->id,
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid content_data_id',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/1000",
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path =>
                "/v4/sites/2/contentTypes/$content_type_id/data/"
                . $cd->id,
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other content_type',
            path =>
                "/v4/sites/$site_id/contentTypes/$other_content_type_id/data/"
                . $cd->id,
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'no permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );

    $cd->status( MT::ContentStatus::RELEASE() );
    $cd->save or die $cd->errstr;
    test_data_api(
        {   note =>
                'remove published content data with unpublished permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,

                    # 'edit_own_unpublished_content_data_'
                    # . $content_type->unique_id,
                    # 'edit_all_unpublished_content_data_'
                    # . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );

    $cd->status( MT::ContentStatus::HOLD() );
    $cd->save or die $cd->errstr;
    test_data_api(
        {   note =>
                'remove unpublished content data with published permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,

                    # 'edit_own_published_content_data_'
                    #     . $content_type->unique_id,
                    # 'edit_all_published_content_data_'
                    #     . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );

    $cd->status( MT::ContentStatus::RELEASE() );
    $cd->author_id(2);
    $cd->save or die $cd->errstr;
    test_data_api(
        {   note => 'remove other published content data without permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,

                    # 'edit_own_published_content_data_'
                    #     . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );

    $cd->status( MT::ContentStatus::HOLD() );
    $cd->author_id(2);
    $cd->save or die $cd->errstr;
    test_data_api(
        {   note =>
                'remove other unpublished content data without permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,

                    # 'edit_own_unpublished_content_data_'
                    # . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );
}

sub normal_tests_for_delete {
    my $cd;

    $cd = MT::Test::Permission->make_content_data(
        blog_id         => $site_id,
        content_type_id => $content_type_id,
    );
    test_data_api(
        {   note => 'system permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {

                # 0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_data',
                    count => 1,
                },
            ],
            result   => sub {$cd},
            complete => sub {
                ok( !MT->model('content_data')->load( $cd->id ) );
            },
        }
    );

    $cd = MT::Test::Permission->make_content_data(
        blog_id         => $site_id,
        content_type_id => $content_type_id,
    );
    test_data_api(
        {   note => 'site permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [

                    # 'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_data',
                    count => 1,
                },
            ],
            result   => sub {$cd},
            complete => sub {
                ok( !MT->model('content_data')->load( $cd->id ) );
            },
        }
    );

    $cd = MT::Test::Permission->make_content_data(
        blog_id         => $site_id,
        content_type_id => $content_type_id,
    );
    test_data_api(
        {   note => 'content_type permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [

                    'edit_all_content_data',

                    # 'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_data',
                    count => 1,
                },
            ],
            result   => sub {$cd},
            complete => sub {
                ok( !MT->model('content_data')->load( $cd->id ) );
            },
        }
    );

    $cd = MT::Test::Permission->make_content_data(
        blog_id         => $site_id,
        author_id       => 1,
        content_type_id => $content_type_id,
        status          => MT::ContentStatus::RELEASE(),
    );
    test_data_api(
        {   note => 'content_type edit_own_published permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,

                    # 'edit_own_published_content_data_'
                    #   . $content_type->unique_id,

                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            result   => sub {$cd},
            complete => sub {
                ok( !MT->model('content_data')->load( $cd->id ) );
            },
        }
    );

    $cd = MT::Test::Permission->make_content_data(
        blog_id         => $site_id,
        author_id       => 2,
        content_type_id => $content_type_id,
        status          => MT::ContentStatus::RELEASE(),
    );
    test_data_api(
        {   note => 'content_data edit_all_published permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,

                    'edit_own_published_content_data_'
                        . $content_type->unique_id,

                    # 'edit_all_published_content_data_'
                    # . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_data',
                    count => 1,
                },
            ],
            result   => sub {$cd},
            complete => sub {
                ok( !MT->model('content_data')->load( $cd->id ) );
            },
        }
    );

    $cd = MT::Test::Permission->make_content_data(
        blog_id         => $site_id,
        author_id       => 1,
        content_type_id => $content_type_id,
        status          => MT::ContentStatus::HOLD(),
    );
    test_data_api(
        {   note => 'content_type edit_own_unpublished permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,

                    # 'edit_own_unpublished_content_data_'
                    # . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_data',
                    count => 1,
                },
            ],
            result   => sub {$cd},
            complete => sub {
                ok( !MT->model('content_data')->load( $cd->id ) );
            },
        }
    );

    $cd = MT::Test::Permission->make_content_data(
        blog_id         => $site_id,
        author_id       => 2,
        content_type_id => $content_type_id,
        status          => MT::ContentStatus::HOLD(),
    );
    test_data_api(
        {   note => 'content_type edit_all_unpublished permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,

                    # 'edit_all_unpublished_content_data_'
                    #     . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_data',
                    count => 1,
                },
            ],
            result   => sub {$cd},
            complete => sub {
                ok( !MT->model('content_data')->load( $cd->id ) );
            },
        }
    );

    $cd = MT::Test::Permission->make_content_data(
        blog_id         => $site_id,
        content_type_id => $content_type_id,
    );
    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            is_superuser => 1,
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_data',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_data',
                    count => 1,
                },
            ],
            result   => sub {$cd},
            complete => sub {
                ok( !MT->model('content_data')->load( $cd->id ) );
            },
        }
    );
}

