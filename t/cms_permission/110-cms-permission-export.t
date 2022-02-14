#!/usr/bin/perl

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
use MT::Test::Fixture::CmsPermission::Imexport;
use MT::Test::App;

### Make test data
$test_env->prepare_fixture('cms_permission/Imexport');

my $blog = MT::Blog->load({ name => 'my blog' });

my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });
my $ukawa    = MT::Author->load({ name => 'ukawa' });

my $admin = MT::Author->load(1);

subtest 'mode = export' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'export',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("export by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'export',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("export by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'export',
        blog_id => $blog->id,
    });
    $app->has_permission_error("export by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'export',
        blog_id => $blog->id,
    });
    $app->has_permission_error("export by other permission");
};

subtest 'mode = start_export' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'start_export',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("start_export by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'start_export',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("start_export by permitted user");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'start_export',
        blog_id => $blog->id,
    });
    $app->has_permission_error("start_export by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'start_export',
        blog_id => $blog->id,
    });
    $app->has_permission_error("start_export by other permission");
};

done_testing();
