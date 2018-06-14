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

use MT::Test qw( :app :db );
use MT::Test::Permission;

MT::Test->init_app;

### Make test data
MT::Test->init_db;

# Website
my $website = MT::Test::Permission->make_website();

my $second_website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );
my $second_blog
    = MT::Test::Permission->make_blog( parent_id => $website->id, );

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

my $designer = MT::Role->load( { name => MT->translate('Designer') } );
my $site_admin
    = MT::Role->load( { name => MT->translate('Site Administrator') } );

require MT::Association;
MT::Association->link( $aikawa   => $site_admin => $blog );
MT::Association->link( $ichikawa => $site_admin => $website );
MT::Association->link( $ukawa    => $site_admin => $second_blog );
MT::Association->link( $egawa    => $site_admin => $second_website );
MT::Association->link( $ogawa    => $designer   => $blog );

# Group
my $grp = MT::Test::Permission->make_group( name => 'Group A', );

# Run
my ( $app, $out );

subtest 'mode = add_group' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'add_group',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: add_group" );
    ok( $out !~ m!permission=1!i, "add_group by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'add_group',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: add_group" );
    ok( $out =~ m!permission=1!i, "add_group by non permitted user" );
};

subtest 'mode = add_member' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'add_member',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: add_member" );
    ok( $out !~ m!permission=1!i, "add_member by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'add_member',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: add_member" );
    ok( $out =~ m!permission=1!i, "add_member by non permitted user" );
};

subtest 'mode = delete_group' => sub {
    $grp = MT::Test::Permission->make_group( name => 'Group B', );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete_group',
            _type            => 'group',
            blog_id          => 0,
            id               => $grp->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete_group" );
    ok( $out !~ m!permission=1!i, "delete_group by admin" );

    $grp = MT::Test::Permission->make_group( name => 'Group C', );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete_group',
            blog_id          => 0,
            id               => $grp->id,
            _type            => 'group',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete_group" );
    ok( $out =~ m!permission=1!i, "delete_group by non permitted user" );
};

subtest 'mode = dialog_grant_role' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'dialog_grant_role',
            blog_id          => 0,
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
        "dialog_grant_role by permitted user (blog)" );

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
        "dialog_grant_role by permitted user (website)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'dialog_grant_role',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_grant_role" );
    ok( $out =~ m!permission=1!i,
        "dialog_grant_role by non permitted user (blog)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'dialog_grant_role',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_grant_role" );
    ok( $out =~ m!permission=1!i,
        "dialog_grant_role by non permitted user (website)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'dialog_grant_role',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: dialog_grant_role" );
    ok( $out =~ m!permission=1!i,
        "dialog_grant_role by non permitted user (system)" );

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
    ok( $out =~ m!permission=1!i, "dialog_grant_role by other permission" );
};

subtest 'mode = view_group' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'view_group',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view_group" );
    ok( $out !~ m!permission=1!i, "view_group by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'view_group',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view_group" );
    ok( $out =~ m!permission=1!i, "view_group by non permitted user" );
};

subtest 'mode = grant_role' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'grant_role',
            blog_id          => 0,
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
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: grant_role" );
    ok( $out !~ m!permission=1!i, "grant_role by permitted user (blog)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'grant_role',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: grant_role" );
    ok( $out !~ m!permission=1!i, "grant_role by permitted user (website)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'grant_role',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: grant_role" );
    ok( $out =~ m!permission=1!i, "grant_role by non permitted user (blog)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'grant_role',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: grant_role" );
    ok( $out =~ m!permission=1!i,
        "grant_role by non permitted user (website)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'grant_role',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: grant_role" );
    ok( $out =~ m!permission=1!i, "grant_role by other permission" );
};

subtest 'mode = list_group_member' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'group_member',
            blog_id          => 0,
            group_id         => $grp->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list_group_member" );
    ok( $out !~ m!permission=1!i, "list_group_member by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'group_member',
            blog_id          => 0,
            group_id         => $grp->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list_group_member" );
    ok( $out =~ m!permission=1!i, "list_group_member by non permitted user" );
};

subtest 'mode = remove_group' => sub {
    $grp = MT::Test::Permission->make_group( name => 'Group D', );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'remove_group',
            blog_id          => 0,
            id               => $grp->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: remove_group" );
    ok( $out !~ m!permission=1!i, "remove_group by admin" );

    $grp = MT::Test::Permission->make_group( name => 'Group E', );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'remove_group',
            blog_id          => 0,
            id               => $grp->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: remove_group" );
    ok( $out =~ m!permission=1!i, "remove_group by non permitted user" );
};

subtest 'mode = remove_member' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'remove_member',
            blog_id          => 0,
            id               => $grp->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: remove_member" );
    ok( $out !~ m!permission=1!i, "remove_member by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'remove_member',
            blog_id          => 0,
            id               => $grp->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: remove_member" );
    ok( $out =~ m!permission=1!i, "remove_member by non permitted user" );
};

subtest 'mode = view_role' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'view_role',
            blog_id          => 0,
            id               => $grp->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view_role" );
    ok( $out !~ m!permission=1!i, "view_role by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'view_role',
            blog_id          => 0,
            id               => $grp->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: view_role" );
    ok( $out =~ m!permission=1!i, "view_role by non permitted user" );
};

subtest 'mode = delete' => sub {
    $grp = MT::Test::Permission->make_group( name => 'Group F', );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => 0,
            id               => $grp->id,
            _type            => 'group',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out !~ m!permission=1!i, "delete by admin" );

    $grp = MT::Test::Permission->make_group( name => 'Group G', );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            blog_id          => 0,
            id               => $grp->id,
            _type            => 'group',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: delete" );
    ok( $out =~ m!permission=1!i, "delete by non permitted user" );
};

subtest 'mode = edit' => sub {
    $grp = MT::Test::Permission->make_group( name => 'Group H', );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'group',
            blog_id          => 0,
            id               => $grp->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit by admin" );

    $grp = MT::Test::Permission->make_group( name => 'Group I', );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'group',
            blog_id          => 0,
            id               => $grp->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit by non permitted user" );
};

subtest 'mode = save' => sub {
    $grp = MT::Test::Permission->make_group( name => 'Group J', );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'group',
            blog_id          => 0,
            id               => $grp->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save by admin" );

    $grp = MT::Test::Permission->make_group( name => 'Group K', );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'group',
            blog_id          => 0,
            id               => $grp->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save by non permitted user" );

};

done_testing();
