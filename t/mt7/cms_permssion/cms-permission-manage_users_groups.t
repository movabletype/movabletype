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

### Prepare
MT::Test->init_app;

### Make test data
$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        # Sites
        my $site = MT::Test::Permission->make_website( name => 'my website' );
        my $child_site = MT::Test::Permission->make_blog(
            name      => 'my child website',
            parent_id => $site->id,
        );

        my $sys_manage_user_group_user = MT::Test::Permission->make_author(
            name     => 'manage_user_group',
            nickname => 'Manager',
        );
        my $sys_non_manage_user_group_user
            = MT::Test::Permission->make_author(
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
    }
);

### Loading test data
my $site = MT::Website->load( { name => 'my website' } );
my $child_site = MT::Blog->load( { name => 'my child website' } );
my $sys_manage_user_group_user
    = MT::Author->load( { name => 'manage_user_group' } );
my $sys_non_manage_user_group_user
    = MT::Author->load( { name => 'non_manage_user_group' } );
my $aikawa = MT::Author->load( { name => 'aikawa' } );

### Make test data
$sys_manage_user_group_user->can_manage_users_groups(1);
$sys_manage_user_group_user->save;

$sys_non_manage_user_group_user->can_manage_users_groups(0);
$sys_manage_user_group_user->save;

require MT::Role;
my $edit_all_posts = MT::Role->load( { name => 'Edit All Posts' } );

### Run
my ( $app, $out );

subtest 'mode = view (new)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'view',
            _type            => 'author',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view" );
    ok( $out !~ m!permission=1!i, "view by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_non_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'view',
            _type            => 'author',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view" );
    ok( $out =~ m!permission=1!i, "view by non permitted user" );
};

subtest 'mode = view (edit)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'view',
            _type            => 'author',
            blog_id          => 0,
            id               => $aikawa->id
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view" );
    ok( $out !~ m!permission=1!i, "view by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_non_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'view',
            _type            => 'author',
            blog_id          => 0,
            id               => $aikawa->id
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view" );
    ok( $out =~ m!permission=1!i, "view by non permitted user" );
};

subtest 'mode = save' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'author',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_non_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'author',
            blog_id          => 0,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by non permitted user" );

};

subtest 'mode = list' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'author',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out !~ m!permission=1!i, "list by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_non_manage_user_group_user,
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

subtest 'mode = disable_object' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'disable_object',
            blog_id          => 0,
            _type            => 'user',
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: disable_object" );
    ok( $out !~ m!permission=1!i, "disable_object by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_non_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'disable_object',
            blog_id          => 0,
            _type            => 'user',
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: disable_object" );
    ok( $out =~ m!permission=1!i, "disable_object by non permitted user" );
};

subtest 'mode = enable_object' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'enable_object',
            blog_id          => 0,
            id               => $aikawa->id,
            _type            => 'user',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: enable_object" );
    ok( $out !~ m!permission=1!i, "enable_object by ermitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_non_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'enable_object',
            blog_id          => 0,
            id               => $aikawa->id,
            _type            => 'user',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: enable_object" );
    ok( $out =~ m!permission=1!i, "enable_object by non permitted user" );
};

subtest 'mode = grant_role' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'grant_role',
            blog             => $site->id,
            author           => $aikawa->id,
            role             => $edit_all_posts->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: grant_role" );
    ok( $out !~ m!permission=1!i, "grant_role by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'grant_role',
            blog             => $child_site->id,
            author           => $aikawa->id,
            role             => $edit_all_posts->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: grant_role" );
    ok( $out !~ m!permission=1!i,
        "grant_role by permitted user on child site" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_non_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'grant_role',
            blog             => $site->id,
            author           => $aikawa->id,
            role             => $edit_all_posts->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: grant_role" );
    ok( $out =~ m!permission=1!i, "grant_role by non permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_non_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'grant_role',
            blog             => $child_site->id,
            author           => $aikawa->id,
            role             => $edit_all_posts->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: grant_role" );
    ok( $out =~ m!permission=1!i,
        "grant_role by non permitted user on child site" );
};

subtest 'mode = remove_user_assoc' => sub {
    MT::Association->link( $aikawa => $edit_all_posts => $site );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'remove_user_assoc',
            blog_id          => $site->id,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_user_assoc" );
    ok( $out !~ m!permission=1!i,
        "remove_user_assoc by permitted user on site" );

    MT::Association->link( $aikawa => $edit_all_posts => $child_site );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'remove_user_assoc',
            blog_id          => $child_site->id,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_user_assoc" );
    ok( $out !~ m!permission=1!i,
        "remove_user_assoc by permitted user on child site" );

    MT::Association->link( $aikawa => $edit_all_posts => $site );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_non_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'remove_user_assoc',
            blog_id          => $site->id,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_user_assoc" );
    ok( $out =~ m!permission=1!i,
        "remove_user_assoc by no permitted user on site" );

    MT::Association->link( $aikawa => $edit_all_posts => $child_site );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $sys_non_manage_user_group_user,
            __request_method => 'POST',
            __mode           => 'remove_user_assoc',
            blog_id          => $child_site->id,
            id               => $aikawa->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: remove_user_assoc" );
    ok( $out =~ m!permission=1!i,
        "remove_user_assoc by non permitted user on child site" );

};

done_testing();
