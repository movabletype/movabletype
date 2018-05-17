#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

### Make test data
$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        # Website
        my $website
            = MT::Test::Permission->make_website( name => 'my website', );

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
        my $designer
            = MT::Role->load( { name => MT->translate('Designer') } );

        require MT::Association;
        MT::Association->link( $aikawa   => $manage_users   => $blog );
        MT::Association->link( $ichikawa => $manage_users   => $website );
        MT::Association->link( $ukawa    => $manage_pages   => $blog );
        MT::Association->link( $egawa    => $edit_all_posts => $blog );
        MT::Association->link( $ogawa    => $designer       => $blog );
        MT::Association->link( $kagawa   => $manage_users   => $second_blog );
        MT::Association->link( $kikkawa  => $manage_pages   => $second_blog );
        MT::Association->link( $kumekawa => $edit_all_posts => $second_blog );
    }
);

my $website = MT::Website->load( { name => 'my website' } );

my $blog = MT::Blog->load( { name => 'my blog' } );

my $aikawa   = MT::Author->load( { name => 'aikawa' } );
my $ichikawa = MT::Author->load( { name => 'ichikawa' } );
my $ukawa    = MT::Author->load( { name => 'ukawa' } );
my $egawa    = MT::Author->load( { name => 'egawa' } );
my $ogawa    = MT::Author->load( { name => 'ogawa' } );
my $kagawa   = MT::Author->load( { name => 'kagawa' } );
my $kikkawa  = MT::Author->load( { name => 'kikkawa' } );
my $kumekawa = MT::Author->load( { name => 'Kumekawa' } );
my $kemikawa = MT::Author->load( { name => 'kemikawa' } );
my $komiya   = MT::Author->load( { name => 'komiya' } );

my $admin = MT::Author->load(1);

require MT::Role;
my $manage_users   = MT::Role->load( { name => 'Manage Users' } );
my $manage_pages   = MT::Role->load( { name => 'Manage Pages' } );
my $edit_all_posts = MT::Role->load( { name => 'Edit All Posts' } );

# Run
my ( $app, $out );

subtest 'mode = cfg_system_users' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'cfg_system_users',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_system_users" );
    ok( $out !~ m!permission=1!i, "cfg_system_users by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'cfg_system_users',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_system_users" );
    ok( $out =~ m!permission=1!i, "cfg_system_users by non permitted user" );
};

subtest 'mode = dialog_grant_role' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'dialog_grant_role',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: dialog_grant_role" );
    ok( $out !~ m!permission=1!i, "dialog_grant_role by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'dialog_grant_role',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_grant_role" );
    ok( $out !~ m!permission=1!i,
        "dialog_grant_role by permitted user on blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'dialog_grant_role',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_grant_role" );
    ok( $out !~ m!permission=1!i,
        "dialog_grant_role by permitted user on website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'dialog_grant_role',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_grant_role" );
    ok( $out =~ m!permission=1!i,
        "dialog_grant_role by non permitted user parent website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'dialog_grant_role',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_grant_role" );
    ok( $out =~ m!permission=1!i,
        "dialog_grant_role by non permitted user child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'dialog_grant_role',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: dialog_grant_role" );
    ok( $out =~ m!permission=1!i, "dialog_grant_role by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'dialog_grant_role',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: dialog_grant_role" );
    ok( $out =~ m!permission=1!i, "dialog_grant_role by other permision" );
};

subtest 'mode = dialog_select_author' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'dialog_select_author',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: dialog_select_author" );
    ok( $out !~ m!permission=1!i, "dialog_select_author by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'dialog_select_author',
            blog_id          => $blog->id,
            entry_type       => 'page',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_select_author" );
    ok( $out !~ m!permission=1!i,
        "dialog_select_author by permitted user (page)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'dialog_select_author',
            blog_id          => $blog->id,
            entry_type       => 'entry',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_select_author" );
    ok( $out !~ m!permission=1!i,
        "dialog_select_author by permitted user (entry)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'dialog_select_author',
            blog_id          => $blog->id,
            entry_type       => 'page',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_select_author" );
    ok( $out =~ m!permission=1!i,
        "dialog_select_author by other blog (page)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'dialog_select_author',
            blog_id          => $blog->id,
            entry_type       => 'entry',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_select_author" );
    ok( $out =~ m!permission=1!i,
        "dialog_select_author by other blog (entry)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'dialog_select_author',
            blog_id          => $blog->id,
            entry_type       => 'entry',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_select_author" );
    ok( $out =~ m!permission=1!i,
        "dialog_select_author by other permission" );
};

subtest 'mode = dialog_select_sysadmin' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'dialog_select_sysadmin',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: dialog_select_sysadmin" );
    ok( $out !~ m!permission=1!i, "dialog_select_sysadmin by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'dialog_select_sysadmin',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_select_sysadmin" );
    ok( $out =~ m!permission=1!i,
        "dialog_select_sysadmin by non permitted user" );
};

subtest 'mode = disable_object' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'disable_object',
            blog_id          => 0,
            _type            => 'user',
            id               => $kemikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: disable_object" );
    ok( $out !~ m!permission=1!i, "disable_object by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'disable_object',
            blog_id          => 0,
            _type            => 'user',
            id               => $kemikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: disable_object" );
    ok( $out =~ m!permission=1!i, "disable_object by non permitted user" );
};

subtest 'mode = edit_role' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit_role',
            blog_id          => 0,
            id               => $manage_users->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit_role" );
    ok( $out !~ m!permission=1!i, "edit_role by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit_role',
            blog_id          => 0,
            id               => $manage_users->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit_role" );
    ok( $out =~ m!permission=1!i, "edit_role by non permitted user" );
};

subtest 'mode = enable_object' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'enable_object',
            blog_id          => 0,
            id               => $kemikawa->id,
            _type            => 'user',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: enable_object" );
    ok( $out !~ m!permission=1!i, "enable_object by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'enable_object',
            blog_id          => 0,
            id               => $kemikawa->id,
            _type            => 'user',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: enable_object" );
    ok( $out =~ m!permission=1!i, "enable_object by non permitted user" );
};

subtest 'mode = list' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'author',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out !~ m!permission=1!i, "list by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'author',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out =~ m!permission=1!i, "list by non permitted user" );
};

subtest 'mode = grant_role' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'grant_role',
            blog             => $blog->id,
            author           => $kemikawa->id,
            role             => $edit_all_posts->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: grant_role" );
    ok( $out !~ m!permission=1!i, "grant_role by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'grant_role',
            blog             => $blog->id,
            author           => $kemikawa->id,
            role             => $edit_all_posts->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: grant_role" );
    ok( $out !~ m!permission=1!i, "grant_role by permitted user on blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'grant_role',
            blog             => $website->id,
            author           => $kemikawa->id,
            role             => $manage_pages->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: grant_role" );
    ok( $out !~ m!permission=1!i, "grant_role by permitted user on website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'grant_role',
            blog             => $website->id,
            author           => $kemikawa->id,
            role             => $edit_all_posts->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: grant_role" );
    ok( $out =~ m!permission=1!i,
        "grant_role by non permitted user parent website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'grant_role',
            blog             => $blog->id,
            author           => $kemikawa->id,
            role             => $edit_all_posts->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: grant_role" );
    ok( $out =~ m!permission=1!i,
        "grant_role by non permitted user child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'grant_role',
            blog             => $blog->id,
            author           => $kemikawa->id,
            role             => $edit_all_posts->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: grant_role" );
    ok( $out =~ m!permission=1!i, "grant_role by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'grant_role',
            blog             => $blog->id,
            author           => $kemikawa->id,
            role             => $edit_all_posts->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: grant_role" );
    ok( $out =~ m!permission=1!i, "grant_role by other permision" );
};

subtest 'mode = list (member)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'member',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out !~ m!permission=1!i, "list member by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'member',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out !~ m!permission=1!i, "list member by permitted user on blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'member',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out !~ m!permission=1!i,
        "list member by permitted user on website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'member',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out =~ m!permission=1!i,
        "list member by non permitted user parent website" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'member',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list" );
    ok( $out =~ m!permission=1!i,
        "list member by non permitted user child blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'member',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out =~ m!permission=1!i, "list member by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'member',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out =~ m!permission=1!i, "list member by other permision" );
};

subtest 'mode = list (role)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'role',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out !~ m!permission=1!i, "list role by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'role',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out =~ m!permission=1!i, "list role by non permitted user" );
};

subtest 'mode = recover_profile_password' => sub {
    plan skip_all => 'deprecated';

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'recover_profile_password',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: recover_profile_password" );
    ok( $out !~ m!permission=1!i, "recover_profile_password by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'recover_profile_password',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: recover_profile_password" );
    ok( $out =~ m!permission=1!i,
        "recover_profile_password by non permitted user" );
};

subtest 'mode = remove_user_assoc' => sub {
    MT::Association->link( $kemikawa => $edit_all_posts => $blog );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'remove_user_assoc',
            blog_id          => $blog->id,
            id               => $kemikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: remove_user_assoc" );
    ok( $out !~ m!permission=1!i, "remove_user_assoc by admin" );

    MT::Association->link( $kemikawa => $edit_all_posts => $blog );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'remove_user_assoc',
            blog_id          => $blog->id,
            id               => $kemikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_user_assoc" );
    ok( $out !~ m!permission=1!i,
        "remove_user_assoc by permitted user on blog" );

    MT::Association->link( $kemikawa => $manage_pages => $website );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'remove_user_assoc',
            blog_id          => $website->id,
            id               => $kemikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_user_assoc" );
    ok( $out !~ m!permission=1!i,
        "remove_user_assoc by permitted user on website" );

    MT::Association->link( $kemikawa => $manage_pages => $website );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'remove_user_assoc',
            blog_id          => $website->id,
            id               => $kemikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_user_assoc" );
    ok( $out =~ m!permission=1!i,
        "remove_user_assoc by non permitted user parent website" );

    MT::Association->link( $kemikawa => $edit_all_posts => $blog );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'remove_user_assoc',
            blog_id          => $blog->id,
            id               => $kemikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_user_assoc" );
    ok( $out =~ m!permission=1!i,
        "remove_user_assoc by non permitted user child blog" );

    MT::Association->link( $kemikawa => $edit_all_posts => $blog );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'remove_user_assoc',
            blog_id          => $blog->id,
            id               => $kemikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: remove_user_assoc" );
    ok( $out =~ m!permission=1!i, "remove_user_assoc by other blog" );

    MT::Association->link( $kemikawa => $edit_all_posts => $blog );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'remove_user_assoc',
            blog_id          => $blog->id,
            id               => $kemikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: remove_user_assoc" );
    ok( $out =~ m!permission=1!i, "remove_user_assoc by other permision" );
};

subtest 'mode = remove_userpic' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'remove_userpic',
            blog_id          => 0,
            user_id          => $kemikawa->id
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: remove_userpic" );
    ok( $out !~ m!permission=1!i, "remove_userpic by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'remove_userpic',
            blog_id          => 0,
            user_id          => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: remove_userpic" );
    ok( $out !~ m!permission=1!i, "remove_userpic by myself" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'remove_userpic',
            blog_id          => 0,
            user_id          => $ichikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: remove_userpic" );
    ok( $out =~ m!permission=1!i, "remove_userpic by other user" );
};

subtest 'mode = upload_userpic' => sub {

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __test_upload    => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME}, "t", 'images', 'test.jpg'
                ),
            ],
            __mode  => 'upload_userpic',
            blog_id => 0,
            user_id => $kemikawa->id
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: upload_userpic" );
    ok( $out !~ m!permission=1!i, "upload_userpic by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __test_upload    => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME}, "t", 'images', 'test.jpg'
                ),
            ],
            __mode  => 'upload_userpic',
            blog_id => 0,
            user_id => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: upload_userpic" );
    ok( $out !~ m!permission=1!i, "upload_userpic by myself" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __test_upload    => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME}, "t", 'images', 'test.jpg'
                ),
            ],
            __mode  => 'upload_userpic',
            blog_id => 0,
            user_id => $ichikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: upload_userpic" );
    ok( $out =~ m!permission=1!i, "upload_userpic by other user" );
};

subtest 'mode = save_cfg_system_users' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save_cfg_system_users',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_cfg_system_users" );
    ok( $out !~ m!permission=1!i, "save_cfg_system_users by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save_cfg_system_users',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_cfg_system_users" );
    ok( $out =~ m!permission=1!i,
        "save_cfg_system_users by non permitted user" );
};

subtest 'mode = save_role' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save_role',
            blog_id          => 0,
            id               => $manage_users->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_role" );
    ok( $out !~ m!permission=1!i, "save_role by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save_role',
            blog_id          => 0,
            id               => $manage_users->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save_role" );
    ok( $out =~ m!permission=1!i, "save_role by non permitted user" );
};

subtest 'mode = save' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'author',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'author',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save own record" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'author',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_system_users" );
    ok( $out =~ m!permission=1!i, "save by others" );
};

subtest 'mode = save (type is commenter)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'commenter',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: save" );
    ok( $out =~ m!Invalid request!i, "save by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'commenter',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save own record" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'commenter',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: cfg_system_users" );
    ok( $out =~ m!Invalid request!i, "save by others" );
};

subtest 'mode = save (type is user)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'user',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: save" );
    ok( $out =~ m!Invalid request!i, "save by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'user',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save own record" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'user',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: cfg_system_users" );
    ok( $out =~ m!Invalid request!i, "save by others" );
};

subtest 'mode = view' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'view',
            _type            => 'author',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view" );
    ok( $out !~ m!permission=1!i, "view by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'view',
            _type            => 'author',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view" );
    ok( $out !~ m!permission=1!i, "view own record" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'view',
            _type            => 'author',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view" );
    ok( $out =~ m!permission=1!i, "view by others" );
};

subtest 'mode = view (type is commenter)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'view',
            _type            => 'commenter',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view" );
    ok( $out !~ m!permission=1!i, "view by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'view',
            _type            => 'commenter',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: view" );
    if ( $app->has_plugin('Comments') ) {
        ok( $out =~ m!permission=1!, "view by others" );
    }
    else {
        ok( $out =~ m!Invalid request!i, "view by others" );
    }
};

subtest 'mode = view (type is user)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'view',
            _type            => 'user',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: view" );
    ok( $out =~ m!Invalid request!i, "view by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'view',
            _type            => 'user',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: view" );
    ok( $out =~ m!Invalid Request!i, "view own record" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'view',
            _type            => 'user',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: viwe" );
    ok( $out =~ m!Invalid request!i, "view by others" );
};

subtest 'mode = delete' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'author',
            blog_id          => 0,
            id               => $komiya->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out !~ m!permission=1!i, "delete by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'author',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete own record" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'author',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: cfg_system_users" );
    ok( $out =~ m!permission=1!i, "delete by others" );
};

subtest 'mode = delete (type is commenter' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'commenter',
            blog_id          => 0,
            id               => $komiya->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: delete" );
    ok( $out =~ m!Invalid request!i, "delete by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'commenter',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: delete" );
    ok( $out =~ m!Invalid request!i, "delete own record" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'commenter',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: cfg_system_users" );
    ok( $out =~ m!Invalid request!i, "delete by others" );
};

subtest 'mode = delete (type is user' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'user',
            blog_id          => 0,
            id               => $komiya->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: delete" );
    ok( $out =~ m!Invalid request!i, "delete by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'user',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: delete" );
    ok( $out =~ m!Invalid request!i, "delete own record" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'user',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: cfg_system_users" );
    ok( $out =~ m!Invalid request!i, "delete by others" );
};

subtest 'action = recover_passwords' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user            => $admin,
            __request_method       => 'POST',
            __mode                 => 'itemset_action',
            _type                  => 'author',
            action_name            => 'recover_passwords',
            itemset_action_input   => '',
            return_args            => '__mode%3Dlist_author%26blog_id%3D0',
            plugin_action_selector => 'recover_passwords',
            id                     => $aikawa->id,
            plugin_action_selector => 'recover_passwords',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: recover_passwords" );
    ok( $out !~ m!not implemented!i, "recover_passwords by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user            => $aikawa,
            __request_method       => 'POST',
            __mode                 => 'itemset_action',
            _type                  => 'author',
            action_name            => 'recover_passwords',
            itemset_action_input   => '',
            return_args            => '__mode%3Dlist_author%26blog_id%3D0',
            plugin_action_selector => 'recover_passwords',
            id                     => $aikawa->id,
            plugin_action_selector => 'recover_passwords',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: recover_passwords" );
    ok( $out =~ m!not implemented!i,
        "recover_passwords by non permitted user" );
};

subtest 'action = delete_user' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user            => $admin,
            __request_method       => 'POST',
            __mode                 => 'itemset_action',
            _type                  => 'author',
            action_name            => 'delete_user',
            itemset_action_input   => '',
            return_args            => '__mode%3Dlist_author%26blog_id%3D0',
            plugin_action_selector => 'delete_user',
            id                     => $aikawa->id,
            plugin_action_selector => 'delete_user',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: delete_user" );
    ok( $out !~ m!not implemented!i, "delete_user by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user            => $ichikawa,
            __request_method       => 'POST',
            __mode                 => 'itemset_action',
            _type                  => 'author',
            action_name            => 'delete_user',
            itemset_action_input   => '',
            return_args            => '__mode%3Dlist_author%26blog_id%3D0',
            plugin_action_selector => 'delete_user',
            id                     => $ukawa->id,
            plugin_action_selector => 'delete_user',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: delete_user" );
    ok( $out =~ m!not implemented!i, "delete_user by non permitted user" );
};

done_testing();
