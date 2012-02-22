#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib', 'plugins/feeds-app-lite/lib';
use MT::Test qw( :app :db );
use MT::Test::Permission;
use Test::More;

### Make test data

# Website
my $website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog(
    parent_id => $website->id,
);
my $second_blog = MT::Test::Permission->make_blog(
    parent_id => $website->id,
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

my $admin = MT::Author->load(1);

# Role
my $create_post = MT::Test::Permission->make_role(
   name  => 'Create Post',
   permissions => "'create_post'",
);
my $edit_templates = MT::Test::Permission->make_role(
   name  => 'Edit Templates',
   permissions => "'edit_templates'",
);

require MT::Association;
MT::Association->link( $aikawa => $edit_templates => $blog );
MT::Association->link( $ichikawa => $create_post => $blog );
MT::Association->link( $ukawa => $edit_templates => $second_blog );

require MT::Permission;
my $p = MT::Permission->new;
$p->blog_id( 0);
$p->author_id( $egawa->id );
$p->permissions( "'edit_templates'" );
$p->save;

# Run
my ( $app, $out );

subtest 'mode = feedswidget_start' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'feedswidget_start',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_start" );
    ok( $out !~ m!permission=1!i, "feedswidget_start by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'feedswidget_start',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_start" );
    ok( $out !~ m!permission=1!i, "feedswidget_start by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'feedswidget_start',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_start" );
    ok( $out !~ m!permission=1!i, "feedswidget_start by permitted user (sys)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'feedswidget_start',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_start" );
    ok( $out =~ m!permission=1!i, "feedswidget_start by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'feedswidget_start',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_start" );
    ok( $out =~ m!permission=1!i, "feedswidget_start by other permission" );
};

subtest 'mode = feedswidget_select' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'feedswidget_select',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_select" );
    ok( $out !~ m!permission=1!i, "feedswidget_select by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'feedswidget_select',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_select" );
    ok( $out !~ m!permission=1!i, "feedswidget_select by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'feedswidget_select',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_select" );
    ok( $out !~ m!permission=1!i, "feedswidget_select by permitted user (sys)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'feedswidget_select',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_select" );
    ok( $out =~ m!permission=1!i, "feedswidget_select by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'feedswidget_select',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_select" );
    ok( $out =~ m!permission=1!i, "feedswidget_select by other permission" );
};

subtest 'mode = feedswidget_config' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'feedswidget_config',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_config" );
    ok( $out !~ m!permission=1!i, "feedswidget_config by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'feedswidget_config',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_config" );
    ok( $out !~ m!permission=1!i, "feedswidget_config by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'feedswidget_config',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_config" );
    ok( $out !~ m!permission=1!i, "feedswidget_config by permitted user (sys)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'feedswidget_config',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_config" );
    ok( $out =~ m!permission=1!i, "feedswidget_config by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'feedswidget_config',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_config" );
    ok( $out =~ m!permission=1!i, "feedswidget_config by other permission" );
};

subtest 'mode = feedswidget_save' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'feedswidget_save',
            blog_id          => $blog->id,
            uri              => 'http://sixapart.com',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_save" );
    ok( $out !~ m!permission=1!i, "feedswidget_save by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'feedswidget_save',
            blog_id          => $blog->id,
            uri              => 'http://sixapart.com',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_save" );
    ok( $out !~ m!permission=1!i, "feedswidget_save by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'feedswidget_save',
            blog_id          => $blog->id,
            uri              => 'http://sixapart.com',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_save" );
    ok( $out !~ m!permission=1!i, "feedswidget_save by permitted user (sys)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'feedswidget_save',
            blog_id          => $blog->id,
            uri              => 'http://sixapart.com',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_save" );
    ok( $out =~ m!permission=1!i, "feedswidget_save by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'feedswidget_save',
            blog_id          => $blog->id,
            uri              => 'http://sixapart.com',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: feedswidget_save" );
    ok( $out =~ m!permission=1!i, "feedswidget_save by other permission" );
};

done_testing();
