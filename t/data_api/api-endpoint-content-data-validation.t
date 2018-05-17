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

use MT::ContentStatus;

my $user = MT->model('author')->load(1);
$user->email('melody@example.com');
$user->save;

$app->user($user);

my $site_id = 1;

subtest 'no validation' => sub {
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
            options   => { label => $single_field->name, },
            unique_id => $single_field->unique_id,
        }
    ];
    $content_type->fields($fields);
    $content_type->save or die $content_type->errstr;

    test_data_api(
        {   note => 'without data',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => { content_data => {}, },
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
        {   note => 'with data',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => {
                content_data => {
                    data => [
                        {   id   => $single_field->id,
                            data => 'abc',
                        },
                    ],
                },
            },
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

};

subtest 'required validation' => sub {
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
        {   id      => $single_field->id,
            order   => 1,
            type    => $single_field->type,
            options => {
                label    => $single_field->name,
                required => 1,
            },
            unique_id => $single_field->unique_id,
        }
    ];
    $content_type->fields($fields);
    $content_type->save or die $content_type->errstr;

    test_data_api(
        {   note => 'without data',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => { content_data => {}, },
            code   => 409,
        }
    );

    test_data_api(
        {   note => 'with data',
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
};

subtest 'required validation with initial_value' => sub {
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
        {   id      => $single_field->id,
            order   => 1,
            type    => $single_field->type,
            options => {
                label         => $single_field->name,
                required      => 1,
                initial_value => 'abcde',
            },
            unique_id => $single_field->unique_id,
        }
    ];
    $content_type->fields($fields);
    $content_type->save or die $content_type->errstr;

    my $cd;
    test_data_api(
        {   note =>
                'set initial_value when both parameter and data are empty',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => { content_data => {}, },
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

    my $data = $cd->data;
    $data->{ $single_field->id } = '12345';
    $cd->data($data);
    $cd->save or die $cd->errstr;
    test_data_api(
        {   note => 'do not set initial_value when data exists',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method => 'PUT',
            params => { content_data => {}, },
            result =>
                sub { $cd = MT->model('content_data')->load( $cd->id ) },
            complete => sub {
                is( $cd->data->{ $single_field->id }, '12345' );
            },
        }
    );

    test_data_api(
        {   note => 'do not set initial_value when parameter is set',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => {
                content_data => {
                    data =>
                        [ { id => $single_field->id, data => '12345', }, ],
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
                is( $cd->data->{ $single_field->id }, '12345' );
            },
        }
    );
};

subtest 'ss_validator' => sub {
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
        {   id      => $single_field->id,
            order   => 1,
            type    => $single_field->type,
            options => {
                label      => $single_field->name,
                max_length => 10,
                min_length => 5,
            },
            unique_id => $single_field->unique_id,
        }
    ];
    $content_type->fields($fields);
    $content_type->save or die $content_type->errstr;

    test_data_api(
        {   note => 'too short',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => {
                content_data => {
                    data => [
                        {   id   => $single_field->id,
                            data => 'abc',
                        },
                    ],
                },
            },
            code => 409,
        }
    );
    test_data_api(
        {   note => 'too long',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => {
                content_data => {
                    data => [
                        {   id   => $single_field->id,
                            data => 'abcdefghijklm',
                        },
                    ],
                },
            },
            code => 409,
        }
    );
    test_data_api(
        {   note => 'valid length',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => {
                content_data => {
                    data => [
                        {   id   => $single_field->id,
                            data => 'abcdef',
                        },
                    ],
                },
            },
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
};

done_testing;

