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

MT::Test->init_app;

### Make test data
require "$FindBin::Bin/common-fixture.pl";

my $admin = MT::Author->load(1);
my $blog = MT::Blog->load( {name => 'my blog' } );
my $aikawa = MT::Author->load( { name => 'aikawa' } );

# Run
my ( $app, $out );

subtest 'mode = list' => sub {
    my $os = MT::Test::Permission->make_objectasset( blog_id => $blog->id );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'objectasset',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: list" );
    ok( $out =~ m!Unknown Action!i, "list by admin" );

    $os = MT::Test::Permission->make_objectasset( blog_id => $blog->id );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'objectasset',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: list" );
    ok( $out =~ m!Unknown Action!i, "list by non permitted user" );
};

subtest 'mode = save' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'objectasset',
            blog_id          => $blog->id,
            object_id        => 1,
            object_ds        => 'entry',
            asset_id         => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'objectasset',
            blog_id          => $blog->id,
            object_id        => 1,
            object_ds        => 'entry',
            asset_id         => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save by non permitted user" );
};

subtest 'mode = edit' => sub {
    my $os = MT::Test::Permission->make_objectasset( blog_id => $blog->id );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'objectasset',
            blog_id          => $blog->id,
            id               => $os->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit by admin" );

    $os = MT::Test::Permission->make_objectasset( blog_id => $blog->id );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'objectasset',
            blog_id          => $blog->id,
            id               => $os->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit by non permitted user" );
};

subtest 'mode = delete' => sub {
    my $os = MT::Test::Permission->make_objectasset( blog_id => $blog->id );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'objectasset',
            blog_id          => $blog->id,
            id               => $os->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: delete" );
    ok( $out =~ m!Invalid Request!i, "delete by admin" );

    $os = MT::Test::Permission->make_objectasset( blog_id => $blog->id );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'objectasset',
            blog_id          => $blog->id,
            id               => $os->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: delete" );
    ok( $out =~ m!Invalid Request!i, "delete by non permitted user" );
};

done_testing();
