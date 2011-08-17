#!/usr/bin/perl

use strict;
use warnings;

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
my $website_admin = MT::Role->load( { name => MT->translate( 'Website Administrator' ) } );

require MT::Association;
MT::Association->link( $aikawa => $website_admin => $website );

# Run
my ( $app, $out );

subtest 'mode = reset_rpt_log' => sub {
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
    ok( $out !~ m!Permission denied!i, "reset_rpt_log by admin" );

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
    ok( $out =~ m!Permission denied!i, "reset_rpt_log by non permitted user" );

    done_testing();
};

subtest 'mode = view_rpt_log' => sub {
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
    ok( $out !~ m!Permission denied!i, "view_rpt_log by admin" );

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
    ok( $out =~ m!Permission denied!i, "view_rpt_log by non permitted user" );

    done_testing();
};

done_testing();
