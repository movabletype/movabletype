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

use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my %empty_response_headers = (
    'Access-Control-Allow-Origin'   => undef,
    'XDomainRequestAllowed'         => undef,
    'Access-Control-Allow-Methods'  => undef,
    'Access-Control-Allow-Headers'  => undef,
    'Access-Control-Expose-Headers' => undef,
);
my %full_response_headers = (
    'Access-Control-Allow-Origin'   => '*',
    'XDomainRequestAllowed'         => '1',
    'Access-Control-Allow-Methods'  => '*',
    'Access-Control-Allow-Headers'  => 'X-MT-Authorization, X-Requested-With',
    'Access-Control-Expose-Headers' => 'X-MT-Next-Phase-URL',
);

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[
        {   note             => 'Default',
            path             => '/v1/sites/1',
            method           => 'GET',
            author_id        => 2,
            response_headers => \%empty_response_headers,
        },
        {   note             => 'Allow: *',
            path             => '/v1/sites/1',
            method           => 'GET',
            author_id        => 2,
            config           => { DataAPICORSAllowOrigin => '*', },
            response_headers => \%full_response_headers,
        },
        {   note =>
                'Allow: http://www.example.com, Origin: http://www.example.com',
            path      => '/v1/sites/1',
            method    => 'GET',
            author_id => 2,
            config => { DataAPICORSAllowOrigin => 'http://www.example.com', },
            request_headers  => { Origin => 'http://www.example.com', },
            response_headers => {
                %full_response_headers,
                'Access-Control-Allow-Origin' => 'http://www.example.com',
            },
        },
        {   note =>
                'Allow: http://www.example.com, Origin: http://beta.example.com',
            path      => '/v1/sites/1',
            method    => 'GET',
            author_id => 2,
            config => { DataAPICORSAllowOrigin => 'http://www.example.com', },
            request_headers => { Origin => 'http://beta.example.com', },
            response_headers => \%empty_response_headers,
        },
        {   note =>
                'Allow: http://www.example.com and http://beta.example.com, Origin: http://beta.example.com',
            path      => '/v1/sites/1',
            method    => 'GET',
            author_id => 2,
            config    => {
                DataAPICORSAllowOrigin =>
                    'http://www.example.com, http://beta.example.com',
            },
            request_headers  => { Origin => 'http://beta.example.com', },
            response_headers => {
                %full_response_headers,
                'Access-Control-Allow-Origin' => 'http://beta.example.com',
            },
        },
        {   note      => 'Specify each CORS directives',
            path      => '/v1/sites/1',
            method    => 'GET',
            author_id => 2,
            config    => {
                DataAPICORSAllowOrigin  => '*',
                DataAPICORSAllowMethods => 'GET, POST, OPTIONS',
                DataAPICORSAllowHeaders =>
                    'X-MT-Authorization, X-Requested-With, X-Some-Request-Value',
                DataAPICORSExposeHeaders =>
                    'X-MT-Next-Phase-URL, X-Some-Response-Value',
            },
            response_headers => {
                %full_response_headers,
                'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS',
                'Access-Control-Allow-Headers' =>
                    'X-MT-Authorization, X-Requested-With, X-Some-Request-Value',
                'Access-Control-Expose-Headers' =>
                    'X-MT-Next-Phase-URL, X-Some-Response-Value',
            },
        },
    ];
}
