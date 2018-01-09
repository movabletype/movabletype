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

normal_tests();

irregular_tests_for_min_length();
irregular_tests_for_max_length();
irregular_tests_for_initial_value();

done_testing;

sub normal_tests {
    test_data_api(
        {   path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_fields",
            method => 'POST',
            params => {
                content_field => {
                    type    => 'single_line_text',
                    label   => 'single line text',
                    options => {
                        description   => 'desc',
                        required      => 1,
                        max_length    => 10,
                        min_length    => 3,
                        initial_value => 'abcde',
                    },
                },
            },
            result => sub {
                MT->model('content_field')->load(
                    {   content_type_id => $content_type_id,
                        type            => 'single_line_text',
                        name            => 'single line text',
                    }
                );
            },
        }
    );
}

sub irregular_tests_for_min_length {
    test_data_api(
        {   note => 'with non-number min_length',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_fields",
            method => 'POST',
            params => {
                content_field => {
                    type    => 'single_line_text',
                    label   => '1',
                    options => { min_length => 'abc' },
                },
            },
            code => 409,
        }
    );
    test_data_api(
        {   note => 'with negative min_length',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_fields",
            method => 'POST',
            params => {
                content_field => {
                    type    => 'single_line_text',
                    label   => '1',
                    options => { min_length => -1 },
                },
            },
            code => 409,
        }
    );
    test_data_api(
        {   note => 'with big min_length',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_fields",
            method => 'POST',
            params => {
                content_field => {
                    type    => 'single_line_text',
                    label   => '1',
                    options => { min_length => 1025 },
                },
            },
            code => 409,
        }
    );
}

sub irregular_tests_for_max_length {
    test_data_api(
        {   note => 'with non-number max_length',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_fields",
            method => 'POST',
            params => {
                content_field => {
                    type    => 'single_line_text',
                    label   => '1',
                    options => { max_length => 'abc' },
                },
            },
            code => 409,
        }
    );
    test_data_api(
        {   note => 'with small max_length',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_fields",
            method => 'POST',
            params => {
                content_field => {
                    type    => 'single_line_text',
                    label   => '1',
                    options => { max_length => 0 },
                },
            },
            code => 409,
        }
    );
    test_data_api(
        {   note => 'with big max_length',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_fields",
            method => 'POST',
            params => {
                content_field => {
                    type    => 'single_line_text',
                    label   => '1',
                    options => { max_length => 1025 },
                },
            },
            code => 409,
        }
    );
}

sub irregular_tests_for_initial_value {
    test_data_api(
        {   note => 'with big initial_value',
            path =>
                "/v4/sites/$site_id/content_types/$content_type_id/content_fields",
            method => 'POST',
            params => {
                content_field => {
                    type    => 'single_line_text',
                    label   => '1',
                    options => { max_length => 3, initial_value => 'abcde' },
                },
            },
            code => 409,
        }
    );
}

