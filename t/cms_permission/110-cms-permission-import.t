#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
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

subtest 'mode = import' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'import',
            blog_id          => $blog->id,
            import_as_me     => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: import" );
    ok( $out !~ m!permission=1!i, "import by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'import',
            blog_id          => $blog->id,
            import_as_me     => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: import" );
    ok( $out !~ m!permission=1!i, "import by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'import',
            blog_id          => $blog->id,
            import_as_me     => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: import" );
    ok( $out =~ m!permission=1!i, "import by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'import',
            blog_id          => $blog->id,
            import_as_me     => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: import" );
    ok( $out =~ m!permission=1!i, "import by other permission" );

    done_testing();
};

subtest 'mode = start_import' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'start_import',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_import" );
    ok( $out !~ m!permission=1!i, "start_import by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'start_import',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_import" );
    ok( $out !~ m!permission=1!i, "start_import by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'start_import',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_import" );
    ok( $out =~ m!permission=1!i, "start_import by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'start_import',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: start_import" );
    ok( $out =~ m!permission=1!i, "start_import by other permission" );

    done_testing();
};

done_testing();
