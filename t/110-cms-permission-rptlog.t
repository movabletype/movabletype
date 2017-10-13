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

# Author
my $aikawa = MT::Test::Permission->make_author(
    name => 'aikawa',
    nickname => 'Ichiro Aikawa',
);

my $admin = MT::Author->load(1);

# Role
require MT::Role;
my $website_admin = MT::Role->load( { name => MT->translate( 'Site Administrator' ) } );

require MT::Association;
MT::Association->link( $aikawa => $website_admin => $website );

# Run
my ( $app, $out );

subtest 'mode = reset_rpt_log' => sub {
    plan skip_all => 'Not implemented';

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'reset_rpt_log',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reset_rpt_log" );
    ok( $out !~ m!permission=1!i, "reset_rpt_log by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'reset_rpt_log',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reset_rpt_log" );
    ok( $out =~ m!permission=1!i, "reset_rpt_log by non permitted user" );

    done_testing();
};

subtest 'mode = view_rpt_log' => sub {
    plan skip_all => 'Not implemented';

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'view_rpt_log',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: view_rpt_log" );
    ok( $out !~ m!permission=1!i, "view_rpt_log by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'view_rpt_log',
            blog_id          => 0,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: view_rpt_log" );
    ok( $out =~ m!permission=1!i, "view_rpt_log by non permitted user" );

    done_testing();
};

done_testing();
