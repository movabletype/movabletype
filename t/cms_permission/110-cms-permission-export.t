#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',  ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::Fixture::CmsPermission::Imexport;

MT::Test->init_app;

### Make test data
$test_env->prepare_fixture('cms_permission/Imexport');

my $blog = MT::Blog->load( { name => 'my blog' } );

my $aikawa   = MT::Author->load( { name => 'aikawa' } );
my $ichikawa = MT::Author->load( { name => 'ichikawa' } );
my $ukawa    = MT::Author->load( { name => 'ukawa' } );

my $admin = MT::Author->load(1);

# Run
my ( $app, $out );

subtest 'mode = export' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'export',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                                           "Request: export" );
    ok( $out !~ m!You do not have export permissions!i, "export by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'export',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: export" );
    ok( $out !~ m!You do not have export permissions!i,
        "export by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'export',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: export" );
    ok( $out =~ m!permission=1!i, "export by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'export',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: export" );
    ok( $out =~ m!You do not have export permissions!i,
        "export by other permission" );
};

subtest 'mode = start_export' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'start_export',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_export" );
    ok( $out !~ m!permission=1!i, "start_export by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'start_export',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_export" );
    ok( $out !~ m!permission=1!i, "start_export by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'start_export',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_export" );
    ok( $out =~ m!permission=1!i, "start_export by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'start_export',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_export" );
    ok( $out =~ m!permission=1!i, "start_export by other permission" );
};

done_testing();
