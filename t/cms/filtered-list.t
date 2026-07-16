#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use JSON qw( encode_json );
use Test::More;
use MT::Test::Env;

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::App;

### Make test data
$test_env->prepare_fixture('db');

my $admin = MT->model('author')->load(1);
my $blog  = MT->model('blog')->load(1);

my $app = MT::Test::App->new('MT::App::CMS');
local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
$app->login($admin);

subtest 'Filtered list ' => sub {
    subtest 'valid request' => sub {
        $app->post_ok({
            __request_method => 'POST',
            __mode           => 'filtered_list',
            datasource       => 'entry',
            blog_id          => $blog->id,
        });
        my $json = $app->json;
        ok($json->{result}, 'json is returned');
        is($json->{error}, undef, 'no error');
    };

    subtest 'invalid request' => sub {
        subtest 'no type' => sub {
            $app->post_ok({
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $blog->id,
                items            => encode_json([{ args => {} }]),
            });
            my $json = $app->json;
            is($json->{error}, 'Invalid type');
        };

        subtest 'invalid type' => sub {
            $app->post_ok({
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'entry',
                blog_id          => $blog->id,
                items            => encode_json([{ type => 'invalid_type', args => {} }]),
            });
            my $json = $app->json;
            is($json->{error}, 'Invalid type');
        };
    };
};

done_testing();
