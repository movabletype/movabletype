#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use HTTP::Request;
use HTTP::Response;
use GoogleAnalyticsV4::OAuth2;

my @request_log;    # we might test multiple requests in the future.

sub Dummy::LWP::UserAgent::request {
    my ($self, $req) = @_;
    push @request_log, $req;
    my $res     = HTTP::Response->new(200);
    my $content = "{}";
    $res->content($content);
    $res->content_type('application/json');
    return $res;
}

sub reset_req_log {
    @request_log = ();
}

sub test_access_token_in_request {
    my ($access_token) = @_;
    my $ret            = {};
    my $req            = shift @request_log;
    return {} unless $req;

    $ret->{query_param}   = $req->uri =~ /access_token/                                     ? 1 : 0;
    $ret->{bearer_header} = ($req->header('Authorization') // '') eq "Bearer $access_token" ? 1 : 0;

    reset_req_log();

    return $ret;
}

my $app = MT->instance;
my $ua  = bless {}, 'Dummy::LWP::UserAgent';

subtest 'authorization_header' => sub {
    my $token = {
        data => {
            token_type   => 'Bearer',
            access_token => 'DUMMY_ACCESS_TOKEN',
        } };

    my $header = GoogleAnalyticsV4::authorization_header($token);
    is $header, "Bearer DUMMY_ACCESS_TOKEN", 'token_type is Bearer';

    delete $token->{data}->{token_type};
    $token->{data}->{access_token} = 'DUMMY_ACCESS_TOKEN2';

    $header = GoogleAnalyticsV4::authorization_header($token);
    is $header, "Bearer DUMMY_ACCESS_TOKEN2", 'default token_type is Bearer';
};

subtest 'get_username' => sub {
    my $token = {
        data => {
            token_type   => 'Bearer',
            access_token => 'ACCESS_TOKEN_XXXX',
        } };

    GoogleAnalyticsV4::OAuth2::get_username($app, $ua, $token);

    my $ret = test_access_token_in_request($token->{data}->{access_token});
    is_deeply $ret, { query_param => 0, bearer_header => 1 };
};

subtest 'get_profiles' => sub {
    my $token = {
        data => {
            token_type   => 'Bearer',
            access_token => 'ACCESS_TOKEN_YYYY',
        } };

    GoogleAnalyticsV4::OAuth2::get_profiles($app, $ua, $token);

    my $ret = test_access_token_in_request($token->{data}->{access_token});
    is_deeply $ret, { query_param => 0, bearer_header => 1 };
};

subtest 'get_webstream' => sub {
    my $token = {
        data => {
            token_type   => 'Bearer',
            access_token => 'ACCESS_TOKEN_ZZZZ',
        } };

    GoogleAnalyticsV4::OAuth2::get_webstream($app, $ua, $token, 'properties/xxxxxxxx');

    my $ret = test_access_token_in_request($token->{data}->{access_token});
    is_deeply $ret, { query_param => 0, bearer_header => 1 };
};

done_testing;
