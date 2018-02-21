#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib', 'plugins/StyleCatcher/lib';
use MT::Test qw( :app :db );
use MT::Test::Permission;
use Test::More;

### Make test data

# Website
my $website = MT::Test::Permission->make_website();

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

my $admin = MT::Author->load(1);

# Role
my $create_post = MT::Test::Permission->make_role(
    name        => 'Create Post',
    permissions => "'create_post'",
);
my $edit_templates = MT::Test::Permission->make_role(
    name        => 'Edit Templates',
    permissions => "'edit_templates'",
);

require MT::Association;
MT::Association->link( $aikawa   => $edit_templates => $blog );
MT::Association->link( $ichikawa => $create_post    => $blog );
MT::Association->link( $ukawa    => $edit_templates => $second_blog );

require MT::Permission;
my $p = MT::Permission->new;
$p->blog_id(0);
$p->author_id( $egawa->id );
$p->permissions("'edit_templates'");
$p->save;

# Run
my ( $app, $out );

subtest 'mode = stylecatcher_theme' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'stylecatcher_theme',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: stylecatcher_theme" );
    ok( $out !~ m!permission=1!i, "stylecatcher_theme by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'stylecatcher_theme',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: stylecatcher_theme" );
    ok( $out !~ m!permission=1!i, "stylecatcher_theme by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'stylecatcher_theme',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: stylecatcher_theme" );
    ok( $out !~ m!permission=1!i,
        "stylecatcher_theme by permitted user (sys)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'stylecatcher_theme',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: stylecatcher_theme" );
    ok( $out =~ m!permission=1!i, "stylecatcher_theme by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'stylecatcher_theme',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: stylecatcher_theme" );
    ok( $out =~ m!permission=1!i, "stylecatcher_theme by other permission" );

    done_testing();
};

subtest 'mode = stylecatcher_js' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'stylecatcher_js',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                          "Request: stylecatcher_js" );
    ok( $out !~ m!permission denied!i, "stylecatcher_js by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'stylecatcher_js',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                          "Request: stylecatcher_js" );
    ok( $out !~ m!permission denied!i, "stylecatcher_js by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'stylecatcher_js',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: stylecatcher_js" );
    ok( $out !~ m!permission denied!i,
        "stylecatcher_js by permitted user (sys)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'stylecatcher_js',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: stylecatcher_js" );
    ok( $out =~ m!permission=1!i, "stylecatcher_js by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'stylecatcher_js',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: stylecatcher_js" );
    ok( $out =~ m!permission denied!i,
        "stylecatcher_js by other permission" );

    done_testing();
};

subtest 'mode = stylecatcher_apply' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'stylecatcher_apply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: stylecatcher_apply" );
    ok( $out !~ m!permission=1!i, "stylecatcher_apply by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'stylecatcher_apply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: stylecatcher_apply" );
    ok( $out !~ m!permission=1!i, "stylecatcher_apply by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'stylecatcher_apply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: stylecatcher_apply" );
    ok( $out !~ m!permission=1!i,
        "stylecatcher_apply by permitted user (sys)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'stylecatcher_apply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: stylecatcher_apply" );
    ok( $out =~ m!permission=1!i, "stylecatcher_apply by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'stylecatcher_apply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: stylecatcher_apply" );
    ok( $out =~ m!permission=1!i, "stylecatcher_apply by other permission" );

    done_testing();
};

done_testing();
