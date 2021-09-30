## -*- mode: perl; coding: utf-8 -*-

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

$test_env->prepare_fixture('db_data');

my $blog_id       = 2;
my $other_blog_id = 1;
my $admin         = MT->model('author')->load(1) or die 'Cannot load author (ID:1)';

is(MT->model('content_type')->count, 0);

subtest 'can create content_type' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'content_type',
        blog_id => $blog_id,
        name    => 'test_content_type',
    });
    ok($app->last_location->query_param('saved'));

    is(
        MT->model('content_type')->count({ blog_id => $blog_id, name => 'test_content_type' }),
        1,
    );
};

subtest 'cannot create content_type with duplicated name in same site' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'content_type',
        blog_id => $blog_id,
        name    => 'test_content_type',
    });
    ok(!$app->last_location);
    ok($app->message_text =~ /Name 'test_content_type' is already used\./);

    is(
        MT->model('content_type')->count({ blog_id => $blog_id, name => 'test_content_type' }),
        1,
    );
};

subtest 'can create content_type with duplicated name in other site' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
            __mode  => 'save',
            _type   => 'content_type',
            blog_id => $other_blog_id,
            name    => 'test_content_type',
        },
    );
    ok($app->last_location->query_param('saved'));

    is(
        MT->model('content_type')->count({ blog_id => $other_blog_id, name => 'test_content_type' }),
        1,
    );
};

done_testing;

