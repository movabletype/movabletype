#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Sites
    my $site       = MT::Test::Permission->make_website(name => 'my website');
    my $child_site = MT::Test::Permission->make_blog(
        name      => 'my child website',
        parent_id => $site->id,
    );

    my $sys_manage_user_group_user = MT::Test::Permission->make_author(
        name     => 'manage_user_group',
        nickname => 'Manager',
    );
    my $sys_non_manage_user_group_user = MT::Test::Permission->make_author(
        name     => 'non_manage_user_group',
        nickname => 'Not Manager',
    );
    my $aikawa = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );

    # Role
    my $edit_all_posts = MT::Test::Permission->make_role(
        name        => 'Edit All Posts',
        permissions => "'edit_all_posts'",
    );
});

### Loading test data
my $site                           = MT::Website->load({ name => 'my website' });
my $child_site                     = MT::Blog->load({ name => 'my child website' });
my $sys_manage_user_group_user     = MT::Author->load({ name => 'manage_user_group' });
my $sys_non_manage_user_group_user = MT::Author->load({ name => 'non_manage_user_group' });
my $aikawa                         = MT::Author->load({ name => 'aikawa' });

### Make test data
$sys_manage_user_group_user->can_manage_users_groups(1);
$sys_manage_user_group_user->save;

$sys_non_manage_user_group_user->can_manage_users_groups(0);
$sys_manage_user_group_user->save;

require MT::Role;
my $edit_all_posts = MT::Role->load({ name => MT->translate('Edit All Posts') });

subtest 'mode = view (new)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($sys_manage_user_group_user);
    $app->post_ok({
        __mode  => 'view',
        _type   => 'author',
        blog_id => 0,
    });
    $app->has_no_permission_error("view by permitted user");

    $app->login($sys_non_manage_user_group_user);
    $app->post_ok({
        __mode  => 'view',
        _type   => 'author',
        blog_id => 0,
    });
    $app->has_permission_error("view by non permitted user");
};

subtest 'mode = view (edit)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($sys_manage_user_group_user);
    $app->post_ok({
        __mode  => 'view',
        _type   => 'author',
        blog_id => 0,
        id      => $aikawa->id
    });
    $app->has_no_permission_error("view by permitted user");

    $app->login($sys_non_manage_user_group_user);
    $app->post_ok({
        __mode  => 'view',
        _type   => 'author',
        blog_id => 0,
        id      => $aikawa->id
    });
    $app->has_permission_error("view by non permitted user");
};

subtest 'mode = save' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($sys_manage_user_group_user);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'author',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_no_permission_error("save by permitted user");

    $app->login($sys_non_manage_user_group_user);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'author',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_permission_error("save by non permitted user");

};

subtest 'mode = list' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($sys_manage_user_group_user);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'author',
        blog_id => 0,
    });
    $app->has_no_permission_error("list by permitted user");

    $app->login($sys_non_manage_user_group_user);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'author',
        blog_id => 0,
    });
    $app->has_permission_error("list by non permitted user");

};

subtest 'mode = disable_object' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($sys_manage_user_group_user);
    $app->post_ok({
        __mode  => 'disable_object',
        blog_id => 0,
        _type   => 'user',
        id      => $aikawa->id,
    });
    $app->has_no_permission_error("disable_object by permitted user");

    $app->login($sys_non_manage_user_group_user);
    $app->post_ok({
        __mode  => 'disable_object',
        blog_id => 0,
        _type   => 'user',
        id      => $aikawa->id,
    });
    $app->has_permission_error("disable_object by non permitted user");
};

subtest 'mode = enable_object' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($sys_manage_user_group_user);
    $app->post_ok({
        __mode  => 'enable_object',
        blog_id => 0,
        id      => $aikawa->id,
        _type   => 'user',
    });
    $app->has_no_permission_error("enable_object by ermitted user");

    $app->login($sys_non_manage_user_group_user);
    $app->post_ok({
        __mode  => 'enable_object',
        blog_id => 0,
        id      => $aikawa->id,
        _type   => 'user',
    });
    $app->has_permission_error("enable_object by non permitted user");
};

subtest 'mode = grant_role' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($sys_manage_user_group_user);
    $app->post_ok({
        __mode => 'grant_role',
        blog   => $site->id,
        author => $aikawa->id,
        role   => $edit_all_posts->id,
    });
    $app->has_no_permission_error("grant_role by permitted user");

    $app->login($sys_manage_user_group_user);
    $app->post_ok({
        __mode => 'grant_role',
        blog   => $child_site->id,
        author => $aikawa->id,
        role   => $edit_all_posts->id,
    });
    $app->has_no_permission_error("grant_role by permitted user on child site");

    $app->login($sys_non_manage_user_group_user);
    $app->post_ok({
        __mode => 'grant_role',
        blog   => $site->id,
        author => $aikawa->id,
        role   => $edit_all_posts->id,
    });
    $app->has_permission_error("grant_role by non permitted user");

    $app->login($sys_non_manage_user_group_user);
    $app->post_ok({
        __mode => 'grant_role',
        blog   => $child_site->id,
        author => $aikawa->id,
        role   => $edit_all_posts->id,
    });
    $app->has_permission_error("grant_role by non permitted user on child site");
};

subtest 'mode = remove_user_assoc' => sub {
    MT::Association->link($aikawa => $edit_all_posts => $site);
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($sys_manage_user_group_user);
    $app->post_ok({
        __mode  => 'remove_user_assoc',
        blog_id => $site->id,
        id      => $aikawa->id,
    });
    $app->has_no_permission_error("remove_user_assoc by permitted user on site");

    MT::Association->link($aikawa => $edit_all_posts => $child_site);
    $app->login($sys_manage_user_group_user);
    $app->post_ok({
        __mode  => 'remove_user_assoc',
        blog_id => $child_site->id,
        id      => $aikawa->id,
    });
    $app->has_no_permission_error("remove_user_assoc by permitted user on child site");

    MT::Association->link($aikawa => $edit_all_posts => $site);
    $app->login($sys_non_manage_user_group_user);
    $app->post_ok({
        __mode  => 'remove_user_assoc',
        blog_id => $site->id,
        id      => $aikawa->id,
    });
    $app->has_permission_error("remove_user_assoc by no permitted user on site");

    MT::Association->link($aikawa => $edit_all_posts => $child_site);
    $app->login($sys_non_manage_user_group_user);
    $app->post_ok({
        __mode  => 'remove_user_assoc',
        blog_id => $child_site->id,
        id      => $aikawa->id,
    });
    $app->has_permission_error("remove_user_assoc by non permitted user on child site");
};

done_testing();
