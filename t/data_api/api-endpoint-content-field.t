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
use MT::Test::Permission;

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $user = MT->model('author')->load(1);
$user->email('melody@example.com');
$user->save;

$app->user($user);

my $site_id = 1;

my $content_type
    = MT::Test::Permission->make_content_type( blog_id => $site_id );
my $content_type_id = $content_type->id;

my $other_content_type = MT::Test::Permission->make_content_type(
    blog_id => $site_id,
    name    => 'Other Content Type'
);
my $other_content_type_id = $other_content_type->id;

normal_tests_for_create();
irregular_tests_for_create();

irregular_tests_for_list();
normal_tests_for_list();

irregular_tests_for_get();
normal_tests_for_get();

irregular_tests_for_update();
normal_tests_for_update();

irregular_tests_for_permutate();
normal_tests_for_permutate();

irregular_tests_for_delete();
normal_tests_for_delete();

sub normal_tests_for_create {
    test_data_api(
        {   note => 'has system permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields",
            method       => 'POST',
            restrictions => { $site_id => ['edit_all_content_types'], },
            params       => {
                content_field => {
                    type  => 'single_line_text',
                    label => 'create-content-field',
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_field',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_field')->load(
                    {   content_type_id => $content_type_id,
                        name            => 'create-content-field',
                    }
                );
            },
            complete => sub {
                my $cf = MT->model('content_field')->load(
                    {   content_type_id => $content_type_id,
                        name            => 'create-content-field',
                    }
                );
                is( $cf->options->{label}, 'create-content-field' );
            },
        }
    );
    test_data_api(
        {   note => 'has site permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields",
            method       => 'POST',
            restrictions => { 0 => ['edit_all_content_types'], },
            params       => {
                content_field => {
                    type    => 'multi_line_text',
                    label   => 'create-content-field-2',
                    options => { display => 'force', },
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_field',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_field')->load(
                    {   content_type_id => $content_type_id,
                        name            => 'create-content-field-2',
                    }
                );
            },
        }
    );
    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields",
            method       => 'POST',
            is_superuser => 1,
            restrictions => {
                0        => ['edit_all_content_types'],
                $site_id => ['edit_all_content_types'],
            },
            params => {
                content_field => {
                    type    => 'number',
                    label   => 'create-content-field-3',
                    options => { display => 'optional', },
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_type',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_field',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_field',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_field')->load(
                    {   content_type_id => $content_type_id,
                        name            => 'create-content-field-3',
                    }
                );
            },
        }
    );
}

sub irregular_tests_for_create {
    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields",
            method    => 'POST',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/contentTypes/$content_type_id/fields",
            method => 'POST',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'invalid content_type_id',
            path   => "/v4/sites/$site_id/contentTypes/1000/fields",
            method => 'POST',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path =>
                "/v4/sites/2/content_types/$content_type_id/fields",
            method => 'POST',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'no permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields",
            method => 'POST',
            params => {
                content_field =>
                    { label => 'create-content-field-without-permission', },
            },
            restrictions => {
                0        => ['edit_all_content_types'],
                $site_id => ['edit_all_content_types'],
            },
            code => 403,
        }
    );
    test_data_api(
        {   note => 'no content_field resource',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields",
            method => 'POST',
            code   => 400,
        }
    );
    test_data_api(
        {   note => 'no type field',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields",
            method => 'POST',
            params => {
                content_field => {
                    label   => 'field',
                    options => { display => 'default' },
                },
            },
            code => 409,
        }
    );
    test_data_api(
        {   note => 'no label field',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields",
            method => 'POST',
            params => {
                content_field => {
                    type    => 'number',
                    options => { display => 'default' },
                },
            },
            code => 409,
        }
    );
    test_data_api(
        {   note => 'invalid type field',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields",
            method => 'POST',
            params => {
                content_field => {
                    type    => 'invalid_type',
                    label   => 'field',
                    options => { display => 'default' },
                },
            },
            code => 409,
        }
    );
    test_data_api(
        {   note => 'invalid options{display} field',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields",
            method => 'POST',
            params => {
                content_field => {
                    type    => 'number',
                    label   => 'field',
                    options => { display => 'invalid' },
                },
            },
            code => 409,
        }
    );
    test_data_api(
        {   note => 'invalid options key',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields",
            method => 'POST',
            params => {
                content_field => {
                    type    => 'number',
                    label   => 'field',
                    options => { invalid => 1 },
                },
            },
            code => 409,
        }
    );
}

sub irregular_tests_for_list {
    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields",
            method    => 'GET',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/content_types/$content_type_id/fields",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'invalid content_type_id',
            path   => "/v4/sites/$site_id/contentTypes/1000/content_fields",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path =>
                "/v4/sites/2/contentTypes/$content_type_id/fields",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'no permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields",
            method       => 'GET',
            restrictions => {
                0        => ['edit_all_content_types'],
                $site_id => ['edit_all_content_types'],
            },
            code => 403,
        }
    );
}

sub normal_tests_for_list {
    test_data_api(
        {   note => 'has system permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields",
            method       => 'GET',
            restrictions => { $site_id => ['edit_all_content_types'], },
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_list_permission_filter.content_field',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.content_field',
                    count => 2,
                },
            ],
            result => sub {
                my @cf = MT->model('content_field')
                    ->load( { content_type_id => $content_type_id } );
                +{  totalResults => scalar @cf,
                    items => MT::DataAPI::Resource->from_object( \@cf ),
                };
            },
        }
    );
    test_data_api(
        {   note => 'has site permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields",
            method       => 'GET',
            restrictions => { 0 => ['edit_all_content_types'], },
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_list_permission_filter.content_field',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.content_field',
                    count => 2,
                },
            ],
            result => sub {
                my @cf = MT->model('content_field')
                    ->load( { content_type_id => $content_type_id } );
                +{  totalResults => scalar @cf,
                    items => MT::DataAPI::Resource->from_object( \@cf ),
                };
            },
        }
    );
    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields",
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
                {   name =>
                        'MT::App::DataAPI::data_api_list_permission_filter.content_field',
                    count => 0,
                },
                {   name  => 'data_api_pre_load_filtered_list.content_field',
                    count => 2,
                },
            ],
            result => sub {
                my @cf = MT->model('content_field')
                    ->load( { content_type_id => $content_type_id } );
                +{  totalResults => scalar @cf,
                    items => MT::DataAPI::Resource->from_object( \@cf ),
                };
            },
        }
    );
}

sub irregular_tests_for_get {
    my $cf = MT->model('content_field')
        ->load( { content_type_id => $content_type_id } );
    ok($cf);

    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method    => 'GET',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid content_type_id',
            path => "/v4/sites/$site_id/contentTypes/1000/fields/"
                . $cf->id,
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid content_field_id',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/1000",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path =>
                "/v4/sites/2/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other content_type',
            path =>
                "/v4/sites/$site_id/contentTypes/$other_content_type_id/fields/"
                . $cf->id,
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'no permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/"
                . $cf->id,
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
    my $cf = MT->model('content_field')
        ->load( { content_type_id => $content_type_id } );
    ok($cf);

    test_data_api(
        {   note => 'has system permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method       => 'GET',
            restrictions => { $site_id => ['edit_all_content_types'], },
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.content_field',
                    count => 1,
                },
            ],
            result => sub {
                $cf;
            },
        }
    );
    test_data_api(
        {   note => 'has site permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method       => 'GET',
            restrictions => { 0 => ['edit_all_content_types'], },
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.content_field',
                    count => 1,
                },
            ],
            result => sub {
                $cf;
            },
        }
    );
    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/"
                . $cf->id,
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
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.content_field',
                    count => 0,
                },
            ],
            result => sub {
                $cf;
            },
        }
    );
}

sub irregular_tests_for_update {
    my $cf = MT->model('content_field')
        ->load( { content_type_id => $content_type_id } );
    ok($cf);

    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method    => 'PUT',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid content_type_id',
            path => "/v4/sites/$site_id/contentTypes/1000/fields/"
                . $cf->id,
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid content_field_id',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/1000",
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path =>
                "/v4/sites/2/content_types/$content_type_id/fields/"
                . $cf->id,
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other content_type',
            path =>
                "/v4/sites/$site_id/contentTypes/$other_content_type_id/fields/"
                . $cf->id,
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'no permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method => 'PUT',
            params => {
                content_field =>
                    { label => 'update-content-field-without-permission', },
            },
            restrictions => {
                0        => ['edit_all_content_types'],
                $site_id => ['edit_all_content_types'],
            },
            code => 403,
        }
    );
    test_data_api(
        {   note => 'invalid options{display} field',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method => 'PUT',
            params =>
                { content_field => { options => { display => 'invalid' } }, },
            code => 409,
        }
    );
    test_data_api(
        {   note => 'invalid options key',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method => 'PUT',
            params => { content_field => { options => { invalid => 1 } }, },
            code   => 409,
        }
    );
}

sub normal_tests_for_update {
    my $cf = MT->model('content_field')
        ->load( { content_type_id => $content_type_id } );
    ok($cf);
    my $original_label = $cf->name;

    test_data_api(
        {   note => 'has system permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method => 'PUT',
            params => {
                content_field => {
                    type    => 'url',
                    label   => $cf->name . ' update',
                    options => { display => 'default', },
                },
            },
            restrictions => { $site_id => ['edit_all_content_types'], },
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_field',
                    count => 1,
                },
            ],
            result => sub {
                $cf
                    = MT->model('content_field')
                    ->load(
                    { id => $cf->id, name => $cf->name . ' update' } );
            },
            complete => sub {
                ok( $cf->type ne 'url' );
                ok( !MT->model('content_field')->load(
                        {   id   => $cf->id,
                            name => $original_label,
                        }
                    )
                );
            },
        }
    );
    test_data_api(
        {   note => 'has site permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method => 'PUT',
            params => {
                content_field => {
                    label   => $cf->name . ' update',
                    options => { display => 'optional', },
                },
            },
            restrictions => { 0 => ['edit_all_content_types'], },
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_field',
                    count => 1,
                },
            ],
            result => sub {
                $cf
                    = MT->model('content_field')
                    ->load(
                    { id => $cf->id, name => $cf->name . ' update' } );
            },
            complete => sub {
                ok( !MT->model('content_field')->load(
                        {   id   => $cf->id,
                            name => $original_label,
                        }
                    )
                );
            },
        }
    );
    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method => 'PUT',
            params => {
                content_field => {
                    label   => $cf->name . ' update',
                    options => { display => 'none', },
                },
            },
            is_superuser => 1,
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
                        'MT::App::DataAPI::data_api_save_permission_filter.content_field',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_field',
                    count => 1,
                },
            ],
            result => sub {
                $cf
                    = MT->model('content_field')
                    ->load(
                    { id => $cf->id, name => $cf->name . ' update' } );
            },
            complete => sub {
                ok( !MT->model('content_field')->load(
                        {   id   => $cf->id,
                            name => $original_label,
                        }
                    )
                );
            },
        }
    );
}

sub irregular_tests_for_permutate {
    my @cf = MT->model('content_field')
        ->load( { content_type_id => $content_type_id } );
    my @cf_ids = map { $_->id } @cf;
    @cf     = reverse @cf;
    @cf_ids = reverse @cf_ids;

    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/permutate",
            method    => 'POST',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/contentTypes/$content_type_id/fields/permutate",
            method => 'POST',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid content_type_id',
            path =>
                "/v4/sites/$site_id/contentTypes/1000/content_fields/permutate",
            method => 'POST',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path =>
                "/v4/sites/2/contentTypes/$content_type_id/fields/permutate",
            method => 'POST',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'no parameter',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/permutate",
            params => { content_fields => [], },
            method => 'POST',
            code   => 400,
        }
    );
    test_data_api(
        {   note => 'invalid parameter',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/permutate",
            params => {
                content_fields => [ map { +{ id => $_ } } @cf_ids[ 0, 1 ], ],
            },
            method => 'POST',
            code   => 400,
        }
    );
}

sub normal_tests_for_permutate {
    my @cf = MT->model('content_field')
        ->load( { content_type_id => $content_type_id } );
    my @cf_ids = map { $_->id } @cf;

    @cf     = reverse @cf;
    @cf_ids = reverse @cf_ids;
    test_data_api(
        {   note => 'has system permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/permutate",
            method       => 'POST',
            restrictions => { $site_id => ['edit_all_content_types'], },
            params =>
                { content_fields => [ map { +{ id => $_ } } @cf_ids ], },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_type',
                    count => 1,
                },
            ],
            result => sub {
                MT::DataAPI::Resource->from_object( \@cf );
            },
        }
    );

    @cf     = reverse @cf;
    @cf_ids = reverse @cf_ids;
    test_data_api(
        {   note => 'has site permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/permutate",
            method       => 'POST',
            restrictions => { 0 => ['edit_all_content_types'], },
            params =>
                { content_fields => [ map { +{ id => $_ } } @cf_ids ], },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_type',
                    count => 1,
                },
            ],
            result => sub {
                MT::DataAPI::Resource->from_object( \@cf );
            },
        }
    );

    @cf     = reverse @cf;
    @cf_ids = reverse @cf_ids;
    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/permutate",
            method       => 'POST',
            is_superuser => 1,
            restrictions => {
                0        => ['edit_all_content_types'],
                $site_id => ['edit_all_content_types'],
            },
            params =>
                { content_fields => [ map { +{ id => $_ } } @cf_ids ], },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_type',
                    count => 0,
                },
            ],
            result => sub {
                MT::DataAPI::Resource->from_object( \@cf );
            },
        }
    );
}

sub irregular_tests_for_delete {
    my $cf = MT->model('content_field')
        ->load( { content_type_id => $content_type_id } );
    ok($cf);

    test_data_api(
        {   note => 'not logged in',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note => 'invalid site_id',
            path =>
                "/v4/sites/1000/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid content_type_id',
            path => "/v4/sites/$site_id/contentTypes/1000/fields/"
                . $cf->id,
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid content_field_id',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/1000",
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path =>
                "/v4/sites/2/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other content_type',
            path =>
                "/v4/sites/$site_id/contentTypes/$other_content_type_id/content_fields/"
                . $cf->id,
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'no permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_types'],
                $site_id => ['edit_all_content_types'],
            },
            code => 403,
        }
    );
}

sub normal_tests_for_delete {
    my $cf = MT->model('content_field')
        ->load( { content_type_id => $content_type_id } );
    ok($cf);

    test_data_api(
        {   note => 'has system permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method       => 'DELETE',
            restrictions => { $site_id => ['edit_all_content_types'], },
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_field',
                    count => 1,
                },
            ],
            result   => sub { $cf; },
            complete => sub {
                ok( !MT->model('content_field')->load( $cf->id ) );
            },
        }
    );

    $cf = MT->model('content_field')
        ->load( { content_type_id => $content_type_id } );
    ok($cf);

    test_data_api(
        {   note => 'has site permission',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method       => 'DELETE',
            restrictions => { 0 => ['edit_all_content_types'], },
            callbacks    => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_type',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_field',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_field',
                    count => 1,
                },
            ],
            result   => sub { $cf; },
            complete => sub {
                ok( !MT->model('content_field')->load( $cf->id ) );
            },
        }
    );

    $cf = MT->model('content_field')
        ->load( { content_type_id => $content_type_id } );
    ok($cf);

    test_data_api(
        {   note => 'superuser',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/fields/"
                . $cf->id,
            method       => 'DELETE',
            is_superuser => 1,
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
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_field',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_field',
                    count => 1,
                },
            ],
            result   => sub { $cf; },
            complete => sub {
                ok( !MT->model('content_field')->load( $cf->id ) );
            },
        }
    );
}

done_testing;

