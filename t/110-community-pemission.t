#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib', 'addons/Community.pack/lib';
use MT::Test qw( :app :db );
use MT::Test::Permission;
use Test::More;

plan skip_all => 'Community Pack does not installed.'
    unless MT->instance->component('community');

### Make test data

# Website
my $website = MT::Test::Permission->make_website();
my $second_website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog(
    parent_id => $website->id,
);
my $second_blog = MT::Test::Permission->make_blog(
    parent_id => $second_website->id,
);

# Author
my $aikawa = MT::Test::Permission->make_author(
    name => 'aikawa',
    nickname => 'Ichiro Aikawa',
);

my $ichikawa = MT::Test::Permission->make_author(
    name => 'ichikawa',
    nickname => 'Jiro Ichikawa',
);

my $ukawa = MT::Test::Permission->make_author(
    name => 'ukawa',
    nickname => 'Saburo Ukawa',
);

my $egawa = MT::Test::Permission->make_author(
    name => 'egawa',
    nickname => 'Shiro Egawa',
);

my $ogawa = MT::Test::Permission->make_author(
    name => 'ogawa',
    nickname => 'Goro Ogawa',
);

my $kagawa = MT::Test::Permission->make_author(
    name => 'kagawa',
    nickname => 'Ichiro Kagawa',
);

my $kikkawa = MT::Test::Permission->make_author(
    name => 'kikkawa',
    nickname => 'Jiro Kikkawa',
);

my $kumekawa = MT::Test::Permission->make_author(
    name => 'kumekawa',
    nickname => 'Saburo Kumekawa',
);

my $admin = MT::Author->load(1);

# Role
my $create_post = MT::Test::Permission->make_role(
    name => 'Create Post',
    permissions => "'create_post'",
);
my $edit_all_posts = MT::Test::Permission->make_role(
    name => 'Edit All Posts',
    permissions => "'edit_all_posts'",
);
my $designer = MT::Role->load( { name => MT->translate( 'Designer' ) } );
my $blog_admin = MT::Role->load( { name => MT->translate( 'Blog Administrator' ) } );

require MT::Association;
MT::Association->link( $aikawa => $blog_admin => $blog );
MT::Association->link( $ichikawa => $blog_admin => $second_blog );
MT::Association->link( $ukawa => $designer => $blog );
MT::Association->link( $egawa => $create_post => $blog );
MT::Association->link( $ogawa => $edit_all_posts => $blog );
MT::Association->link( $kagawa => $create_post => $second_blog );
MT::Association->link( $kikkawa => $edit_all_posts => $second_blog );
MT::Association->link( $kumekawa => $create_post => $blog );

# Entry
my $entry = MT::Test::Permission->make_entry(
    blog_id => $blog->id,
    author_id => $egawa->id,
);

# Run
my ( $app, $out );

subtest 'mode = cfg_community_prefs' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'cfg_community_prefs',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: cfg_community_prefs" );
    ok( $out !~ m!Permission denied!i, "cfg_community_prefs by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'cfg_community_prefs',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: cfg_community_prefs" );
    ok( $out !~ m!Permission denied!i, "cfg_community_prefs by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'cfg_community_prefs',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: cfg_community_prefs" );
    ok( $out =~ m!Permission denied!i, "cfg_community_prefs by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'cfg_community_prefs',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: cfg_community_prefs" );
    ok( $out =~ m!Permission denied!i, "cfg_community_prefs by other permission" );
};

subtest 'mode = save_community_prefs' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save_community_prefs',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_community_prefs" );
    ok( $out !~ m!Permission denied!i, "save_community_prefs by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save_community_prefs',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_community_prefs" );
    ok( $out !~ m!Permission denied!i, "save_community_prefs by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save_community_prefs',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_community_prefs" );
    ok( $out =~ m!Permission denied!i, "save_community_prefs by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save_community_prefs',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_community_prefs" );
    ok( $out =~ m!Permission denied!i, "save_community_prefs by other permission" );
};

subtest 'mode = post' => sub {
    $app = _run_app(
        'MT::App::Community',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'post',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: post" );
    ok( $out !~ m!Permission denied!i, "post by admin" );

    $app = _run_app(
        'MT::App::Community',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'post',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: post" );
    ok( $out !~ m!Permission denied!i, "post by permitted user" );

    $app = _run_app(
        'MT::App::Community',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'post',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: post" );
    ok( $out =~ m!Permission denied!i, "post by non permitted user" );

    $app = _run_app(
        'MT::App::Community',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'post',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: post" );
    ok( $out =~ m!Permission denied!i, "post by other permission" );
};

subtest 'mode = unpublish' => sub {
    $app = _run_app(
        'MT::App::Community',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'unpublish',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: post" );
    ok( $out !~ m!Permission denied!i, "unpublish by admin" );

    $app = _run_app(
        'MT::App::Community',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'unpublish',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: post" );
    ok( $out !~ m!Permission denied!i, "unpublish by permitted user (create post)" );

    $app = _run_app(
        'MT::App::Community',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'unpublish',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: post" );
    ok( $out !~ m!Permission denied!i, "unpublish by permitted user (edit all posts)" );

    $app = _run_app(
        'MT::App::Community',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'unpublish',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: post" );
    ok( $out =~ m!Permission denied!i, "unpublish by non permitted user (create post)" );

    $app = _run_app(
        'MT::App::Community',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'unpublish',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: post" );
    ok( $out =~ m!Permission denied!i, "unpublish by non permitted user (edit all posts)" );

    $app = _run_app(
        'MT::App::Community',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'unpublish',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: post" );
    ok( $out =~ m!Permission denied!i, "unpublish by other permission" );

    $app = _run_app(
        'MT::App::Community',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'unpublish',
            blog_id          => $blog->id,
            id               => $entry->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: post" );
    ok( $out =~ m!Permission denied!i, "unpublish by other user" );
};

done_testing();
