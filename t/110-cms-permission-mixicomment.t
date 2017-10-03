#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib', 'plugins/mixiComment/lib';
use MT::Test qw( :app :db );
use MT::Test::Permission;
use Test::More;

### Make test data

# Website
my $website = MT::Test::Permission->make_website();
my $second_website = MT::Test::Permission->make_website();

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

my $ogawa = MT::Test::Permission->make_author(
    name => 'ogawa',
    nickname => 'Goro Ogawa',
);

my $admin = MT::Author->load(1);

# Role
my $create_post = MT::Test::Permission->make_role(
   name  => 'Create Post',
   permissions => "'create_post'",
);
my $site_admin = MT::Role->load({ name => MT->translate('Site Administrator') });

require MT::Association;
MT::Association->link( $aikawa => $site_admin => $blog );
MT::Association->link( $ichikawa => $site_admin => $website );
MT::Association->link( $ukawa => $site_admin => $second_blog );
MT::Association->link( $egawa => $site_admin => $second_website );
MT::Association->link( $ogawa => $create_post => $blog );

# Run
my ( $app, $out );

subtest 'mode = mixicomment_login_blog_owner' => sub {
    plan skip_all => 'https://movabletype.fogbugz.com/default.asp?106849';

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'mixicomment_login_blog_owner',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: mixicomment_login_blog_owner" );
    ok( $out !~ m!permission=1!i, "mixicomment_login_blog_owner by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'mixicomment_login_blog_owner',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: mixicomment_login_blog_owner" );
    ok( $out !~ m!permission=1!i, "mixicomment_login_blog_owner by permitted user (blog)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'mixicomment_login_blog_owner',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: mixicomment_login_blog_owner" );
    ok( $out !~ m!permission=1!i, "mixicomment_login_blog_owner by permitted user (website)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'mixicomment_login_blog_owner',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: mixicomment_login_blog_owner" );
    ok( $out =~ m!permission=1!i, "mixicomment_login_blog_owner by non permitted user (blog)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'mixicomment_login_blog_owner',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: mixicomment_login_blog_owner" );
    ok( $out =~ m!permission=1!i, "mixicomment_login_blog_owner by non permitted user (website)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'mixicomment_login_blog_owner',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: mixicomment_login_blog_owner" );
    ok( $out =~ m!permission=1!i, "mixicomment_login_blog_owner by other permission" );
};

subtest 'mode = mixicomment_verify_blog_owner' => sub {
    plan skip_all => 'https://movabletype.fogbugz.com/default.asp?106849';

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'mixicomment_verify_blog_owner',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: mixicomment_verify_blog_owner" );
    ok( $out !~ m!permission=1!i, "mixicomment_verify_blog_owner by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'mixicomment_verify_blog_owner',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: mixicomment_verify_blog_owner" );
    ok( $out !~ m!permission=1!i, "mixicomment_verify_blog_owner by permitted user (blog)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'mixicomment_verify_blog_owner',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: mixicomment_verify_blog_owner" );
    ok( $out !~ m!permission=1!i, "mixicomment_verify_blog_owner by permitted user (website)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'mixicomment_verify_blog_owner',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: mixicomment_verify_blog_owner" );
    ok( $out =~ m!permission=1!i, "mixicomment_verify_blog_owner by non permitted user (blog)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'mixicomment_verify_blog_owner',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: mixicomment_verify_blog_owner" );
    ok( $out =~ m!permission=1!i, "mixicomment_verify_blog_owner by non permitted user (website)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'mixicomment_verify_blog_owner',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: mixicomment_verify_blog_owner" );
    ok( $out =~ m!permission=1!i, "mixicomment_verify_blog_owner by other permission" );
};

done_testing();
