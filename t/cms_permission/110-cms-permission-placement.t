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

my $blog = MT::Blog->load( { name => 'my blog' } );

my $aikawa = MT::Author->load( { name => 'aikawa' } );

my $admin = MT::Author->load(1);

# Run
my ( $app, $out );

subtest 'mode = list' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'placement',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: list" );
    ok( $out =~ m!Unknown Action!i, "list by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'placement',
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
            _type            => 'placement',
            blog_id          => $blog->id,
            category_id      => 1,
            entry_id         => 1,
            is_primary       => 1
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
            _type            => 'placement',
            blog_id          => $blog->id,
            category_id      => 1,
            entry_id         => 1,
            is_primary       => 1
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save by non permitted user" );
};

subtest 'mode = edit' => sub {
    my $place = MT::Test::Permission->make_placement(
        blog_id     => $blog->id,
        category_id => 1,
        entry_id    => 1,
        is_primary  => 1
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'placement',
            blog_id          => $blog->id,
            id               => $place->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit by admin" );

    $place = MT::Test::Permission->make_placement(
        blog_id     => $blog->id,
        category_id => 1,
        entry_id    => 1,
        is_primary  => 1
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'placement',
            blog_id          => $blog->id,
            id               => $place->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit by non permitted user" );
};

subtest 'mode = delete' => sub {
    my $place = MT::Test::Permission->make_placement(
        blog_id     => $blog->id,
        category_id => 1,
        entry_id    => 1,
        is_primary  => 1
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'placement',
            blog_id          => $blog->id,
            id               => $place->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: delete" );
    ok( $out =~ m!Invalid Request!i, "delete by admin" );

    $place = MT::Test::Permission->make_placement(
        blog_id     => $blog->id,
        category_id => 1,
        entry_id    => 1,
        is_primary  => 1
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'placement',
            blog_id          => $blog->id,
            id               => $place->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: delete" );
    ok( $out =~ m!Invalid Request!i, "delete by non permitted user" );
};

done_testing();
