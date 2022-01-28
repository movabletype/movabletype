#!/usr/bin/perl

use strict;
use warnings;
use Cwd;
use lib Cwd::realpath("./t/lib");
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
$test_env->prepare_fixture('db');

# Website
my $website = MT::Test::Permission->make_website();

my $second_website = MT::Test::Permission->make_website();

# Blog
my $blog        = MT::Test::Permission->make_blog(parent_id => $website->id,);
my $second_blog = MT::Test::Permission->make_blog(parent_id => $website->id,);

# Author
my $aikawa = MT::Test::Permission->make_author(
    name     => 'aikawa',
    nickname => 'Ichiro Aikawa',
);

my $ichikawa = MT::Test::Permission->make_author(
    name     => 'ichikawa',
    nickname => 'Jiro Ichikawa',
);

my $ukawa = MT::Test::Permission->make_author(
    name     => 'ukawa',
    nickname => 'Saburo Ukawa',
);

my $egawa = MT::Test::Permission->make_author(
    name     => 'egawa',
    nickname => 'Shiro Egawa',
);

my $ogawa = MT::Test::Permission->make_author(
    name     => 'ogawa',
    nickname => 'Goro Ogawa',
);

my $admin = MT::Author->load(1);

# Role
my $create_post = MT::Test::Permission->make_role(
    name        => 'Create Post',
    permissions => "'create_post'",
);

my $designer   = MT::Role->load({ name => MT->translate('Designer') });
my $site_admin = MT::Role->load({ name => MT->translate('Site Administrator') });

require MT::Association;
MT::Association->link($aikawa   => $site_admin => $blog);
MT::Association->link($ichikawa => $site_admin => $website);
MT::Association->link($ukawa    => $site_admin => $second_blog);
MT::Association->link($egawa    => $site_admin => $second_website);
MT::Association->link($ogawa    => $designer   => $blog);

$aikawa->can_manage_users_groups(1);
$aikawa->save();

# Group
my $grp = MT::Test::Permission->make_group(name => 'Group A',);

subtest 'mode = add_group' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'add_group',
        blog_id => 0,
    });
    $app->has_no_permission_error("add_group by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'add_group',
        blog_id => 0,
    });
    $app->has_no_permission_error("add_group by can_manage_user_group user");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'add_group',
        blog_id => 0,
    });
    $app->has_permission_error("add_group by non permitted user");
};

subtest 'mode = add_member' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'add_member',
        blog_id => 0,
    });
    $app->has_no_permission_error("add_member by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'add_member',
        blog_id => 0,
    });
    $app->has_no_permission_error("add_member by can_manage_user_group user");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'add_member',
        blog_id => 0,
    });
    $app->has_permission_error("add_member by non permitted user");
};

subtest 'mode = delete_group' => sub {
    my $grp = MT::Test::Permission->make_group(name => 'Group B',);
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete_group',
        _type   => 'group',
        blog_id => 0,
        id      => $grp->id,
    });
    $app->has_no_permission_error("delete_group by admin");

    $grp = MT::Test::Permission->make_group(name => 'Group C',);
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete_group',
        blog_id => 0,
        id      => $grp->id,
        _type   => 'group',
    });
    $app->has_no_permission_error("delete_group by can_manage_user_group user");

    $grp = MT::Test::Permission->make_group(name => 'Group D',);
    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'delete_group',
        blog_id => 0,
        id      => $grp->id,
        _type   => 'group',
    });
    $app->has_permission_error("delete_group by non permitted user");
};

subtest 'mode = dialog_grant_role' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'dialog_grant_role',
        blog_id => 0,
    });
    $app->has_no_permission_error("dialog_grant_role by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'dialog_grant_role',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("dialog_grant_role by permitted user (blog)");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'dialog_grant_role',
        blog_id => $website->id,
    });
    $app->has_no_permission_error("dialog_grant_role by permitted user (website)");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'dialog_grant_role',
        blog_id => $blog->id,
    });
    $app->has_permission_error("dialog_grant_role by non permitted user (blog)");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'dialog_grant_role',
        blog_id => $website->id,
    });
    $app->has_permission_error("dialog_grant_role by non permitted user (website)");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'dialog_grant_role',
        blog_id => 0,
    });
    $app->has_no_permission_error("dialog_grant_role by can_manage_user_group user (system)");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'dialog_grant_role',
        blog_id => $blog->id,
    });
    $app->has_permission_error("dialog_grant_role by other permission");
};

subtest 'mode = view_group' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'view_group',
        blog_id => 0,
    });
    $app->has_no_permission_error("view_group by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'view_group',
        blog_id => 0,
    });
    $app->has_no_permission_error("view_group by can_manage_user_group user");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'view_group',
        blog_id => 0,
    });
    $app->has_permission_error("view_group by non permitted user");
};

subtest 'mode = grant_role' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'grant_role',
        blog_id => 0,
    });
    $app->has_no_permission_error("grant_role by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'grant_role',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("grant_role by permitted user (blog)");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'grant_role',
        blog_id => $website->id,
    });
    $app->has_no_permission_error("grant_role by permitted user (website)");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'grant_role',
        blog_id => $blog->id,
    });
    $app->has_permission_error("grant_role by non permitted user (blog)");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'grant_role',
        blog_id => $website->id,
    });
    $app->has_permission_error("grant_role by non permitted user (website)");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'grant_role',
        blog_id => $blog->id,
    });
    $app->has_permission_error("grant_role by other permission");
};

subtest 'mode = list_group_member' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode   => 'list',
        _type    => 'group_member',
        blog_id  => 0,
        group_id => $grp->id,
    });
    $app->has_no_permission_error("list_group_member by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode   => 'list',
        _type    => 'group_member',
        blog_id  => 0,
        group_id => $grp->id,
    });
    $app->has_no_permission_error("list_group_member by can_manage_user_group user");

    $app->login($ukawa);
    $app->post_ok({
        __mode   => 'list',
        _type    => 'group_member',
        blog_id  => 0,
        group_id => $grp->id,
    });
    $app->has_permission_error("list_group_member by non permitted user");
};

subtest 'mode = remove_group' => sub {
    my $grp = MT::Test::Permission->make_group(name => 'Group E',);
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'remove_group',
        blog_id => 0,
        id      => $grp->id,
    });
    $app->has_no_permission_error("remove_group by admin");

    $grp = MT::Test::Permission->make_group(name => 'Group F',);
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'remove_group',
        blog_id => 0,
        id      => $grp->id,
    });
    $app->has_no_permission_error("remove_group by can_manage_user_group user");

    $grp = MT::Test::Permission->make_group(name => 'Group G',);
    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'remove_group',
        blog_id => 0,
        id      => $grp->id,
    });
    $app->has_permission_error("remove_group by non permitted user");
};

subtest 'mode = remove_member' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'remove_member',
        blog_id => 0,
        id      => $grp->id,
    });
    $app->has_no_permission_error("remove_member by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'remove_member',
        blog_id => 0,
        id      => $grp->id,
    });
    $app->has_no_permission_error("remove_member by can_manage_user_group user");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'remove_member',
        blog_id => 0,
        id      => $grp->id,
    });
    $app->has_permission_error("remove_member by non permitted user");
};

subtest 'mode = view_role' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'view_role',
        blog_id => 0,
        id      => $grp->id,
    });
    $app->has_no_permission_error("view_role by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'view_role',
        blog_id => 0,
        id      => $grp->id,
    });
    $app->has_permission_error("view_role by non permitted user");
};

subtest 'mode = delete' => sub {
    my $grp = MT::Test::Permission->make_group(name => 'Group H',);
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => 0,
        id      => $grp->id,
        _type   => 'group',
    });
    $app->has_no_permission_error("delete by admin");

    $grp = MT::Test::Permission->make_group(name => 'Group I',);
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => 0,
        id      => $grp->id,
        _type   => 'group',
    });
    $app->has_no_permission_error("delete by can_manage_user_group user");

    $grp = MT::Test::Permission->make_group(name => 'Group J',);
    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'delete',
        blog_id => 0,
        id      => $grp->id,
        _type   => 'group',
    });
    $app->has_permission_error("delete by non permitted user");
};

subtest 'mode = edit' => sub {
    my $grp = MT::Test::Permission->make_group(name => 'Group K',);
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'group',
        blog_id => 0,
        id      => $grp->id,
    });
    $app->has_no_permission_error("edit by admin");

    $grp = MT::Test::Permission->make_group(name => 'Group L',);
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'group',
        blog_id => 0,
        id      => $grp->id,
    });
    $app->has_no_permission_error("edit by can_manage_user_group user");

    $grp = MT::Test::Permission->make_group(name => 'Group M',);
    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'group',
        blog_id => 0,
        id      => $grp->id,
    });
    $app->has_permission_error("edit by non permitted user");
};

subtest 'mode = save' => sub {
    my $grp = MT::Test::Permission->make_group(name => 'Group N',);
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'group',
        blog_id => 0,
        id      => $grp->id,
    });
    $app->has_no_permission_error("save by admin");

    $grp = MT::Test::Permission->make_group(name => 'Group O',);
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'group',
        blog_id => 0,
        id      => $grp->id,
    });
    $app->has_no_permission_error("save by can_manage_user_group user");

    $grp = MT::Test::Permission->make_group(name => 'Group P',);
    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'group',
        blog_id => 0,
        id      => $grp->id,
    });
    $app->has_permission_error("save by non permitted user");
};

done_testing();
