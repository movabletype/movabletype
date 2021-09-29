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
use MT::Test::Fixture::CmsPermission::Common1;
use MT::Test::App;

### Make test data
$test_env->prepare_fixture('cms_permission/common1');

my $website = MT::Website->load({ name => 'my website' });
my $blog    = MT::Blog->load({ name => 'my blog' });

my $aikawa = MT::Author->load({ name => 'aikawa' });
my $admin  = MT::Author->load(1);

# XXX: The following tests are to make sure permission items are not exposed by the listing framework
# Everything should be invalid or unknown

subtest 'mode = list' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'permission',
        blog_id => $blog->id,
    });
    $app->has_permission_error("list by admin");

    $app = MT::Test::App->new('MT::App::CMS');
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'permission',
        blog_id => $blog->id,
    });
    $app->has_permission_error("list by non permitted user");
};

subtest 'mode = save' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode    => 'save',
        _type     => 'permission',
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    });
    $app->has_invalid_request("save by admin");

    $app = MT::Test::App->new('MT::App::CMS');
    $app->login($aikawa);
    $app->post_ok({
        __mode    => 'save',
        _type     => 'permission',
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    });
    $app->has_invalid_request("save by non permitted user");
};

subtest 'mode = edit' => sub {
    my $perm = MT::Permission->load({
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    });
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'permission',
        blog_id => $blog->id,
        id      => $perm->id,
    });
    $app->has_invalid_request("edit by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'permission',
        blog_id => $blog->id,
        id      => $perm->id,
    });
    $app->has_invalid_request("edit by non permitted user");
};

subtest 'mode = delete' => sub {
    my $perm = MT::Permission->load({
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    });
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'permission',
        blog_id => $blog->id,
        id      => $perm->id,
    });
    $app->has_invalid_request("delete by admin");

    $perm = MT::Test::Permission->make_permission(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'permission',
        blog_id => $blog->id,
        id      => $perm->id,
    });
    $app->has_invalid_request("delete by non permitted user");
};

done_testing();
