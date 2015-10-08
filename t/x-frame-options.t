#!/usr/bin/perl
use strict;
use warnings;

use Test::More;

use HTTP::Request;
use Plack::Test;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib qw( lib extlib t/lib );
use MT::Test qw( :app :db );
use MT;
use MT::PSGI;

my $config = MT->instance->config;
my $user   = MT->model('author')->load(1);

{
    $config->XFrameOptions( 'SAMEORIGIN', 1 );
    $config->save_config;

    my $app = _run_app( 'MT::App::CMS', { __test_user => $user } );
    my $out = delete $app->{__test_output};
    ok( $out =~ /x-frame-options: sameorigin/i, 'SAMEORIGIN' );
}

{
    $config->XFrameOptions( 'DENY', 1 );
    $config->save_config;

    my $app = _run_app( 'MT::App::CMS', { __test_user => $user } );
    my $out = delete $app->{__test_output};
    ok( $out =~ /x-frame-options: deny/i, 'DENY' );
}

{
    $config->XFrameOptions( 'ALLOW-FROM https://example.com', 1 );
    $config->save_config;

    my $app = _run_app( 'MT::App::CMS', { __test_user => $user } );
    my $out = delete $app->{__test_output};
    ok( $out =~ m{x-frame-options: allow-from https://example\.com}i,
        'ALLOW-FROM' );
}

{
    $config->XFrameOptions( 'SAMEORIGIN', 1 );
    $config->save_config;

    my $app = _run_app( 'MT::App::DataAPI', { __test_user => $user } );
    my $out = delete $app->{__test_output};
    ok( $out =~ /API Version is required/,      'Data API' );
    ok( $out =~ /x-frame-options: sameorigin/i, 'Header is set' );
}

{
    my $app  = MT::PSGI->new->to_app;
    my $test = Plack::Test->create($app);

    my $req = HTTP::Request->new( GET => '/cgi-bin/mt.cgi' );
    my $res = $test->request($req);

    is( lc $res->header('X-Frame-Options'), 'sameorigin', 'PSGI' );
}

{
    $config->XFrameOptions( 'sameorigin', 1 );
    $config->save_config;

    my $app = _run_app( 'MT::App::CMS', { __test_user => $user } );
    my $out = delete $app->{__test_output};
    ok( $out =~ /x-frame-options: sameorigin/i, 'Lower case' );
}

{
    $config->XFrameOptions( 'invalid', 1 );
    $config->save_config;

    my $app = _run_app( 'MT::App::CMS', { __test_user => $user } );
    my $out = delete $app->{__test_output};
    ok( $out =~ /x-frame-options: sameorigin/i, 'Invalid value' );
}

{
    $config->XFrameOptions( 'sameorigin', 1 );
    $config->save_config;

    my $app = _run_app( 'MT::App::CMS',
        { __test_user => $user, __mode => 'invalid' } );
    my $out = delete $app->{__test_output};
    ok( $out =~ /An error occurred/,            'An error occurred' );
    ok( $out =~ /x-frame-options: sameorigin/i, 'Header is set' );
}

done_testing;
