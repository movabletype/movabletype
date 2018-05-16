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

use lib 'plugins/MultiBlog/lib';
use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website        = MT::Test::Permission->make_website(
        name => 'my website',
    );
    my $second_website = MT::Test::Permission->make_website(
        name => 'second website',
    );

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name => 'my blog',
    );
    my $second_blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name => 'second blog',
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
});

my $website = MT::Website->load( { name => 'my website' } );

my $blog = MT::Blog->load( { name => 'my blog' } );

my $aikawa   = MT::Author->load( { name => 'aikawa' } );
my $ichikawa = MT::Author->load( { name => 'ichikawa' } );
my $ukawa    = MT::Author->load( { name => 'ukawa' } );
my $egawa    = MT::Author->load( { name => 'egawa' } );
my $ogawa    = MT::Author->load( { name => 'ogawa' } );

my $admin = MT::Author->load(1);

# Run
my ( $app, $out );

subtest 'mode = add_rebuild_trigger' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'add_rebuild_trigger',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                          "Request: add_rebuild_trigger" );
    ok( $out !~ m!permission=1!i, "add_rebuild_trigger by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'add_rebuild_trigger',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_rebuild_trigger" );
    ok( $out !~ m!permission=1!i,
        "add_rebuild_trigger by permitted user (blog)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'add_rebuild_trigger',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_rebuild_trigger" );
    ok( $out !~ m!permission=1!i,
        "add_rebuild_trigger by permitted user (website)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'add_rebuild_trigger',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_rebuild_trigger" );
    ok( $out =~ m!permission=1!i,
        "add_rebuild_trigger by non permitted user (blog)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'add_rebuild_trigger',
            blog_id          => $website->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_rebuild_trigger" );
    ok( $out =~ m!permission=1!i,
        "add_rebuild_trigger by non permitted user (website)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'add_rebuild_trigger',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: add_rebuild_trigger" );
    ok( $out =~ m!permission=1!i,
        "add_rebuild_trigger by other permission" );
};

done_testing();
