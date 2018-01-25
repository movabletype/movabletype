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

subtest 'without initial_value' => sub {
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

    $user->permissions(0)->rebuild;
    $user->permissions($site_id)->rebuild;

    my $cd;

    test_data_api(
        {   note => 'with permission',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_data",
            method => 'POST',
            params => {
                content_data => {
                    data => [
                        {   id   => $single_field->id,
                            data => 'abcde',
                        },
                    ],
                },
            },
            result => sub {
                $cd = MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
            complete => sub {
                is( $cd->data->{ $single_field->id }, 'abcde' );
            },
        }
    );

    test_data_api(
        {   note => 'without permission',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_data",
            method       => 'POST',
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
                    'content_type:'
                        . $content_type->unique_id
                        . '-content_field:'
                        . $single_field->unique_id,
                ],
            },
            params => {
                content_data => {
                    data => [
                        {   id   => $single_field->id,
                            data => 'abcde',
                        },
                    ],
                },
            },
            result => sub {
                $cd = MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
            complete => sub {
                ok( !$cd->data->{ $single_field->id } );
            },
        }
    );
};

subtest 'with initial_value' => sub {
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
        {   id    => $single_field->id,
            order => 1,
            type  => $single_field->type,
            options =>
                { label => $single_field->name, initial_value => '12345', },
            unique_id => $single_field->unique_id,
        }
    ];
    $content_type->fields($fields);
    $content_type->save or die $content_type->errstr;

    $user->permissions(0)->rebuild;
    $user->permissions($site_id)->rebuild;

    my $cd;

    test_data_api(
        {   note => 'with permission',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_data",
            method => 'POST',
            params => {
                content_data => {
                    data => [
                        {   id   => $single_field->id,
                            data => 'abcde',
                        },
                    ],
                },
            },
            result => sub {
                $cd = MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
            complete => sub {
                is( $cd->data->{ $single_field->id }, 'abcde' );
            },
        }
    );

    test_data_api(
        {   note => 'without permission',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_data",
            method       => 'POST',
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
                    'content_type:'
                        . $content_type->unique_id
                        . '-content_field:'
                        . $single_field->unique_id,
                ],
            },
            params => {
                content_data => {
                    data => [
                        {   id   => $single_field->id,
                            data => 'abcde',
                        },
                    ],
                },
            },
            result => sub {
                $cd = MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
            complete => sub {
                is( $cd->data->{ $single_field->id }, 12345 );
            },
        }
    );
};

done_testing;

