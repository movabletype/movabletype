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

MT::Test->init_app;

sub make_id {
    my @alpha = ( 'a' .. 'z', 'A' .. 'Z', 0 .. 9 );
    my $token = join '', map $alpha[ rand @alpha ], 1 .. 40;
    $token;
}

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website();

    # Blog
    my $blog = MT::Test::Permission->make_blog( parent_id => $website->id, );

    # Author
    my $aikawa = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );

    my $admin = MT::Author->load(1);

    # Role
    require MT::Role;
    my $site_admin
        = MT::Role->load( { name => MT->translate('Site Administrator') } );

    require MT::Association;
    MT::Association->link( $aikawa => $site_admin => $blog );
});

my $aikawa = MT::Author->load( { name => 'aikawa' } );

my $admin = MT::Author->load(1);

# Run
my ( $app, $out, $sess );

subtest 'mode = list' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'session',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: list" );
    ok( $out =~ m!Unknown Action!i, "list by admin" );

    $sess = MT::Test::Permission->make_session(
        start => time,
        id    => make_id(),
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'session',
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
            _type            => 'session',
            start            => time,
            id               => make_id(),
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
            _type            => 'session',
            start            => time,
            id               => make_id(),
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save by non permitted user" );
};

subtest 'mode = edit' => sub {
    my $sess = MT::Test::Permission->make_session(
        start => time,
        id    => make_id(),
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'session',
            id               => $sess->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit by admin" );

    $sess = MT::Test::Permission->make_session(
        start => time,
        id    => make_id(),
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'session',
            id               => $sess->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit by non permitted user" );
};

subtest 'mode = delete' => sub {
    my $sess = MT::Test::Permission->make_session(
        start => time,
        id    => make_id(),
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'session',
            id               => $sess->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: delete" );
    ok( $out =~ m!Invalid Request!i, "delete by admin" );

    $sess = MT::Test::Permission->make_session(
        start => time,
        id    => make_id(),
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'session',
            id               => $sess->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: delete" );
    ok( $out =~ m!Invalid Request!i, "delete by non permitted user" );
};

done_testing();
