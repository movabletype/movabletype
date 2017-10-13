#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}


BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib', 'plugins/MultiBlog/lib';
use MT::Test qw( :app :db );
use MT::Test::Permission;
use Test::More;

### Make test data

# Website
my $website        = MT::Test::Permission->make_website();
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
my $site_admin
    = MT::Role->load( { name => MT->translate('Site Administrator') } );

require MT::Association;
MT::Association->link( $aikawa   => $site_admin  => $blog );
MT::Association->link( $ichikawa => $site_admin  => $website );
MT::Association->link( $ukawa    => $site_admin  => $second_blog );
MT::Association->link( $egawa    => $site_admin  => $second_website );
MT::Association->link( $ogawa    => $create_post => $blog );

# Run
my ( $app, $out );

subtest 'mode = multiblog_add_trigger' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'multiblog_add_trigger',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                          "Request: multiblog_add_trigger" );
    ok( $out !~ m!Permission denied!i, "multiblog_add_trigger by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'multiblog_add_trigger',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: multiblog_add_trigger" );
    ok( $out !~ m!Permission denied!i,
        "multiblog_add_trigger by permitted user (blog)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'multiblog_add_trigger',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: multiblog_add_trigger" );
    ok( $out !~ m!Permission denied!i,
        "multiblog_add_trigger by permitted user (website)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'multiblog_add_trigger',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: multiblog_add_trigger" );
    ok( $out =~ m!Permission denied!i,
        "multiblog_add_trigger by non permitted user (blog)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'multiblog_add_trigger',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: multiblog_add_trigger" );
    ok( $out =~ m!Permission denied!i,
        "multiblog_add_trigger by non permitted user (website)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'multiblog_add_trigger',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: multiblog_add_trigger" );
    ok( $out =~ m!Permission denied!i,
        "multiblog_add_trigger by other permission" );
};

done_testing();
