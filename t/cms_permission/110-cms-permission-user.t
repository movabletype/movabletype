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
use MT::Test::App;
use MT::Test::Image;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website(name => 'my website',);

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'my blog',
    );
    my $second_blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'second blog',
    );

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

    my $kagawa = MT::Test::Permission->make_author(
        name     => 'kagawa',
        nickname => 'Ichiro Kagawa',
    );

    my $kikkawa = MT::Test::Permission->make_author(
        name     => 'kikkawa',
        nickname => 'Jiro Kikkawa',
    );

    my $kumekawa = MT::Test::Permission->make_author(
        name     => 'Kumekawa',
        nickname => 'Saburo Kumekawa',
    );

    my $kemikawa = MT::Test::Permission->make_author(
        name     => 'kemikawa',
        nickname => 'Shiro Kemikawa',
    );

    my $komiya = MT::Test::Permission->make_author(
        name     => 'komiya',
        nickname => 'Goro Komiya',
    );

    my $admin = MT::Author->load(1);

    # Role
    my $manage_users = MT::Test::Permission->make_role(
        name        => 'Manage Users',
        permissions => "'manage_users'",
    );
    my $manage_pages = MT::Test::Permission->make_role(
        name        => 'Manage Pages',
        permissions => "'manage_pages'",
    );
    my $edit_all_posts = MT::Test::Permission->make_role(
        name        => 'Edit All Posts',
        permissions => "'edit_all_posts'",
    );
    my $designer = MT::Role->load({ name => MT->translate('Designer') });

    require MT::Association;
    MT::Association->link($aikawa   => $manage_users   => $blog);
    MT::Association->link($ichikawa => $manage_users   => $website);
    MT::Association->link($ukawa    => $manage_pages   => $blog);
    MT::Association->link($egawa    => $edit_all_posts => $blog);
    MT::Association->link($ogawa    => $designer       => $blog);
    MT::Association->link($kagawa   => $manage_users   => $second_blog);
    MT::Association->link($kikkawa  => $manage_pages   => $second_blog);
    MT::Association->link($kumekawa => $edit_all_posts => $second_blog);
});

my $website = MT::Website->load({ name => 'my website' });

my $blog = MT::Blog->load({ name => 'my blog' });

my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });
my $ukawa    = MT::Author->load({ name => 'ukawa' });
my $egawa    = MT::Author->load({ name => 'egawa' });
my $ogawa    = MT::Author->load({ name => 'ogawa' });
my $kagawa   = MT::Author->load({ name => 'kagawa' });
my $kikkawa  = MT::Author->load({ name => 'kikkawa' });
my $kumekawa = MT::Author->load({ name => 'Kumekawa' });
my $kemikawa = MT::Author->load({ name => 'kemikawa' });
my $komiya   = MT::Author->load({ name => 'komiya' });

my $admin = MT::Author->load(1);

require MT::Role;
my $manage_users   = MT::Role->load({ name => MT->translate('Manage Users') });
my $manage_pages   = MT::Role->load({ name => MT->translate('Manage Pages') });
my $edit_all_posts = MT::Role->load({ name => MT->translate('Edit All Posts') });

subtest 'mode = cfg_system_users' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'cfg_system_users',
        blog_id => 0,
    });
    $app->has_no_permission_error("cfg_system_users by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'cfg_system_users',
        blog_id => 0,
    });
    $app->has_permission_error("cfg_system_users by non permitted user");
};

subtest 'mode = dialog_grant_role' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'dialog_grant_role',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("dialog_grant_role by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'dialog_grant_role',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("dialog_grant_role by permitted user on blog");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'dialog_grant_role',
        blog_id => $website->id,
    });
    $app->has_no_permission_error("dialog_grant_role by permitted user on website");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'dialog_grant_role',
        blog_id => $website->id,
    });
    $app->has_permission_error("dialog_grant_role by non permitted user parent website");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'dialog_grant_role',
        blog_id => $blog->id,
    });
    $app->has_permission_error("dialog_grant_role by non permitted user child blog");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'dialog_grant_role',
        blog_id => $blog->id,
    });
    $app->has_permission_error("dialog_grant_role by other blog");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'dialog_grant_role',
        blog_id => $blog->id,
    });
    $app->has_permission_error("dialog_grant_role by other permision");
};

subtest 'mode = dialog_select_author' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'dialog_select_author',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("dialog_select_author by admin");

    $app->login($ukawa);
    $app->post_ok({
        __mode     => 'dialog_select_author',
        blog_id    => $blog->id,
        entry_type => 'page',
    });
    $app->has_no_permission_error("dialog_select_author by permitted user (page)");

    $app->login($egawa);
    $app->post_ok({
        __mode     => 'dialog_select_author',
        blog_id    => $blog->id,
        entry_type => 'entry',
    });
    $app->has_no_permission_error("dialog_select_author by permitted user (entry)");

    $app->login($kikkawa);
    $app->post_ok({
        __mode     => 'dialog_select_author',
        blog_id    => $blog->id,
        entry_type => 'page',
    });
    $app->has_permission_error("dialog_select_author by other blog (page)");

    $app->login($kumekawa);
    $app->post_ok({
        __mode     => 'dialog_select_author',
        blog_id    => $blog->id,
        entry_type => 'entry',
    });
    $app->has_permission_error("dialog_select_author by other blog (entry)");

    $app->login($ogawa);
    $app->post_ok({
        __mode     => 'dialog_select_author',
        blog_id    => $blog->id,
        entry_type => 'entry',
    });
    $app->has_permission_error("dialog_select_author by other permission");
};

subtest 'mode = dialog_select_sysadmin' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'dialog_select_sysadmin',
        blog_id => 0,
    });
    $app->has_no_permission_error("dialog_select_sysadmin by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'dialog_select_sysadmin',
        blog_id => 0,
    });
    $app->has_permission_error("dialog_select_sysadmin by non permitted user");
};

subtest 'mode = disable_object' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'disable_object',
        blog_id => 0,
        _type   => 'user',
        id      => $kemikawa->id,
    });
    $app->has_no_permission_error("disable_object by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'disable_object',
        blog_id => 0,
        _type   => 'user',
        id      => $kemikawa->id,
    });
    $app->has_permission_error("disable_object by non permitted user");
};

subtest 'mode = edit_role' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit_role',
        blog_id => 0,
        id      => $manage_users->id,
    });
    $app->has_no_permission_error("edit_role by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit_role',
        blog_id => 0,
        id      => $manage_users->id,
    });
    $app->has_permission_error("edit_role by non permitted user");
};

subtest 'mode = enable_object' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'enable_object',
        blog_id => 0,
        id      => $kemikawa->id,
        _type   => 'user',
    });
    $app->has_no_permission_error("enable_object by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'enable_object',
        blog_id => 0,
        id      => $kemikawa->id,
        _type   => 'user',
    });
    $app->has_permission_error("enable_object by non permitted user");
};

subtest 'mode = list' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'author',
        blog_id => 0,
    });
    $app->has_no_permission_error("list by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'author',
        blog_id => 0,
    });
    $app->has_permission_error("list by non permitted user");
};

subtest 'mode = grant_role' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode => 'grant_role',
        blog   => $blog->id,
        author => $kemikawa->id,
        role   => $edit_all_posts->id,
    });
    $app->has_no_permission_error("grant_role by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode => 'grant_role',
        blog   => $blog->id,
        author => $kemikawa->id,
        role   => $edit_all_posts->id,
    });
    $app->has_no_permission_error("grant_role by permitted user on blog");

    $app->login($ichikawa);
    $app->post_ok({
        __mode => 'grant_role',
        blog   => $website->id,
        author => $kemikawa->id,
        role   => $manage_pages->id,
    });
    $app->has_no_permission_error("grant_role by permitted user on website");

    $app->login($aikawa);
    $app->post_ok({
        __mode => 'grant_role',
        blog   => $website->id,
        author => $kemikawa->id,
        role   => $edit_all_posts->id,
    });
    $app->has_permission_error("grant_role by non permitted user parent website");

    $app->login($ichikawa);
    $app->post_ok({
        __mode => 'grant_role',
        blog   => $blog->id,
        author => $kemikawa->id,
        role   => $edit_all_posts->id,
    });
    $app->has_permission_error("grant_role by non permitted user child blog");

    $app->login($kagawa);
    $app->post_ok({
        __mode => 'grant_role',
        blog   => $blog->id,
        author => $kemikawa->id,
        role   => $edit_all_posts->id,
    });
    $app->has_permission_error("grant_role by other blog");

    $app->login($ogawa);
    $app->post_ok({
        __mode => 'grant_role',
        blog   => $blog->id,
        author => $kemikawa->id,
        role   => $edit_all_posts->id,
    });
    $app->has_permission_error("grant_role by other permision");
};

subtest 'mode = list (member)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'member',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("list member by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'member',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("list member by permitted user on blog");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'member',
        blog_id => $website->id,
    });
    $app->has_no_permission_error("list member by permitted user on website");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'member',
        blog_id => $website->id,
    });
    $app->has_permission_error("list member by non permitted user parent website");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'member',
        blog_id => $blog->id,
    });
    $app->has_permission_error("list member by non permitted user child blog");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'member',
        blog_id => $blog->id,
    });
    $app->has_permission_error("list member by other blog");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'member',
        blog_id => $blog->id,
    });
    $app->has_permission_error("list member by other permision");
};

subtest 'mode = list (role)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'role',
        blog_id => 0,
    });
    $app->has_no_permission_error("list role by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'role',
        blog_id => 0,
    });
    $app->has_permission_error("list role by non permitted user");
};

subtest 'mode = remove_user_assoc' => sub {
    MT::Association->link($kemikawa => $edit_all_posts => $blog);
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'remove_user_assoc',
        blog_id => $blog->id,
        id      => $kemikawa->id,
    });
    $app->has_no_permission_error("remove_user_assoc by admin");

    MT::Association->link($kemikawa => $edit_all_posts => $blog);
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'remove_user_assoc',
        blog_id => $blog->id,
        id      => $kemikawa->id,
    });
    $app->has_no_permission_error("remove_user_assoc by permitted user on blog");

    MT::Association->link($kemikawa => $manage_pages => $website);
    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'remove_user_assoc',
        blog_id => $website->id,
        id      => $kemikawa->id,
    });
    $app->has_no_permission_error("remove_user_assoc by permitted user on website");

    MT::Association->link($kemikawa => $manage_pages => $website);
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'remove_user_assoc',
        blog_id => $website->id,
        id      => $kemikawa->id,
    });
    $app->has_permission_error("remove_user_assoc by non permitted user parent website");

    MT::Association->link($kemikawa => $edit_all_posts => $blog);
    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'remove_user_assoc',
        blog_id => $blog->id,
        id      => $kemikawa->id,
    });
    $app->has_permission_error("remove_user_assoc by non permitted user child blog");

    MT::Association->link($kemikawa => $edit_all_posts => $blog);
    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'remove_user_assoc',
        blog_id => $blog->id,
        id      => $kemikawa->id,
    });
    $app->has_permission_error("remove_user_assoc by other blog");

    MT::Association->link($kemikawa => $edit_all_posts => $blog);
    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'remove_user_assoc',
        blog_id => $blog->id,
        id      => $kemikawa->id,
    });
    $app->has_permission_error("remove_user_assoc by other permision");
};

subtest 'mode = remove_userpic' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'remove_userpic',
        blog_id => 0,
        user_id => $kemikawa->id
    });
    $app->has_no_permission_error("remove_userpic by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'remove_userpic',
        blog_id => 0,
        user_id => $aikawa->id,
    });
    $app->has_no_permission_error("remove_userpic by myself");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'remove_userpic',
        blog_id => 0,
        user_id => $ichikawa->id,
    });
    $app->has_permission_error("remove_userpic by other user");
};

subtest 'mode = upload_userpic' => sub {
    my ($guard, $file) = MT::Test::Image->tempfile(
        DIR    => $test_env->root,
        SUFFIX => '.jpg',
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __test_upload => ['file', $file],
        __mode        => 'upload_userpic',
        blog_id       => 0,
        user_id       => $kemikawa->id
    });
    $app->has_no_permission_error("upload_userpic by admin");

    ($guard, $file) = MT::Test::Image->tempfile(
        DIR    => $test_env->root,
        SUFFIX => '.jpg',
    );
    $app->login($aikawa);
    $app->post_ok({
        __test_upload => ['file', $file],
        __mode        => 'upload_userpic',
        blog_id       => 0,
        user_id       => $aikawa->id,
    });
    $app->has_no_permission_error("upload_userpic by myself");

    ($guard, $file) = MT::Test::Image->tempfile(
        DIR    => $test_env->root,
        SUFFIX => '.jpg',
    );
    $app->login($aikawa);
    $app->post_ok({
        __test_upload => ['file', $file],
        __mode        => 'upload_userpic',
        blog_id       => 0,
        user_id       => $ichikawa->id,
    });
    $app->has_permission_error("upload_userpic by other user");
};

subtest 'mode = save_cfg_system_users' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save_cfg_system_users',
        blog_id => 0,
    });
    $app->has_no_permission_error("save_cfg_system_users by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save_cfg_system_users',
        blog_id => 0,
    });
    $app->has_permission_error("save_cfg_system_users by non permitted user");
};

subtest 'mode = save_role' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save_role',
        blog_id => 0,
        id      => $manage_users->id,
    });
    $app->has_no_permission_error("save_role by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save_role',
        blog_id => 0,
        id      => $manage_users->id,
    });
    $app->has_permission_error("save_role by non permitted user");
};

subtest 'mode = save' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'author',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_no_permission_error("save by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'author',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_no_permission_error("save own record");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'author',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_permission_error("save by others");
};

subtest 'mode = save (type is commenter)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'commenter',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_invalid_request("save by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'commenter',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_invalid_request("save own record");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'commenter',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_invalid_request("save by others");
};

subtest 'mode = save (type is user)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'user',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_invalid_request("save by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'user',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_invalid_request("save own record");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'user',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_invalid_request("save by others");
};

subtest 'mode = view' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'view',
        _type   => 'author',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_no_permission_error("view by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'view',
        _type   => 'author',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_no_permission_error("view own record");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'view',
        _type   => 'author',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_permission_error("view by others");
};

subtest 'mode = view (type is commenter)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'view',
        _type   => 'commenter',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_no_permission_error("view by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'view',
        _type   => 'commenter',
        blog_id => 0,
        id      => $aikawa->id,
    });
    if ($test_env->plugin_exists('Comments')) {
        $app->has_permission_error("view by others");
    } else {
        $app->has_invalid_request("view by others");
    }
};

subtest 'mode = view (type is user)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'view',
        _type   => 'user',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_invalid_request("view by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'view',
        _type   => 'user',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_invalid_request("view own record");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'view',
        _type   => 'user',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_invalid_request("view by others");
};

subtest 'mode = delete' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'author',
        blog_id => 0,
        id      => $komiya->id,
    });
    $app->has_no_permission_error("delete by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'author',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_permission_error("delete own record");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'author',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_permission_error("delete by others");
};

subtest 'mode = delete (type is commenter' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'commenter',
        blog_id => 0,
        id      => $komiya->id,
    });
    $app->has_invalid_request("delete by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'commenter',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_invalid_request("delete own record");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'commenter',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_invalid_request("delete by others");
};

subtest 'mode = delete (type is user' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'user',
        blog_id => 0,
        id      => $komiya->id,
    });
    $app->has_invalid_request("delete by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'user',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_invalid_request("delete own record");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'user',
        blog_id => 0,
        id      => $aikawa->id,
    });
    $app->has_invalid_request("delete by others");
};

subtest 'action = recover_passwords' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'author',
        action_name            => 'recover_passwords',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_author%26blog_id%3D0',
        id                     => $aikawa->id,
        plugin_action_selector => 'recover_passwords',
    });
    ok($app->generic_error !~ m!not implemented!i, "recover_passwords by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'author',
        action_name            => 'recover_passwords',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_author%26blog_id%3D0',
        id                     => $aikawa->id,
        plugin_action_selector => 'recover_passwords',
    });
    ok(
        $app->generic_error =~ m!not implemented!i,
        "recover_passwords by non permitted user"
    );
};

subtest 'action = delete_user' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'author',
        action_name            => 'delete_user',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_author%26blog_id%3D0',
        id                     => $aikawa->id,
        plugin_action_selector => 'delete_user',
    });
    ok($app->generic_error !~ m!not implemented!i, "delete_user by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'author',
        action_name            => 'delete_user',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_author%26blog_id%3D0',
        id                     => $ukawa->id,
        plugin_action_selector => 'delete_user',
    });
    ok($app->generic_error =~ m!not implemented!i, "delete_user by non permitted user");
};

done_testing();
