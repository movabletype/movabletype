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

use lib 't/lib', 'lib', 'extlib';
use MT::Test qw( :app :db );
use MT::Test::Permission;
use Test::More;

### Make test data

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

# Run
my ( $app, $out );

subtest 'mode = list' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'fileinfo',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: list" );
    ok( $out =~ m!Unknown action!i, "list by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list',
            _type            => 'config',
            _type            => 'fileinfo',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: list" );
    ok( $out =~ m!Unknown action!i, "list by non permitted user" );
};

subtest 'mode = save' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'fileinfo',
            blog_id          => $blog->id,
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
            _type            => 'config',
            _type            => 'fileinfo',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save by non permitted user" );
};

subtest 'mode = edit' => sub {
    my $fi = MT::Test::Permission->make_fileinfo( blog_id => $blog->id );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'config',
            _type            => 'fileinfo',
            blog_id          => $blog->id,
            id               => $fi->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit by admin" );

    $fi = MT::Test::Permission->make_fileinfo( blog_id => $blog->id );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            _type            => 'config',
            _type            => 'fileinfo',
            blog_id          => $blog->id,
            id               => $fi->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit by non permitted user" );
};

subtest 'mode = delete' => sub {
    my $fi = MT::Test::Permission->make_fileinfo( blog_id => $blog->id );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'config',
            _type            => 'fileinfo',
            blog_id          => $blog->id,
            id               => $fi->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: delete" );
    ok( $out =~ m!Invalid Request!i, "delete by admin" );

    $fi = MT::Test::Permission->make_fileinfo( blog_id => $blog->id );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'delete',
            _type            => 'config',
            _type            => 'fileinfo',
            blog_id          => $blog->id,
            id               => $fi->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: delete" );
    ok( $out =~ m!Invalid Request!i, "delete by non permitted user" );
};

done_testing();
