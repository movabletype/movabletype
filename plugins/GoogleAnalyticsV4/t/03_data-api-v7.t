#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval { require Test::LWP::UserAgent }
        or plan skip_all => 'Test::LWP::UserAgent is not installed';
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}
$test_env->prepare_fixture('db_data');

use HTTP::Request::Common;

my $useragent = Test::LWP::UserAgent->new();

my $dummy_res = {
    dimensionHeaders => [{
        name => 'Dummy',
    }],
    metricHeaders => [{
        name => 'Dummy',
    }],
    rows => [{
        dimensionValues => [{
            value => 'Dummy',
        }],
        metricValues => [{
            value => 1,
        }]
    }],
    rowCount => 1,
};

my $dummy_json     = MT::Util::to_json($dummy_res);
my $dummy_response = HTTP::Response->new('200', 'OK', ['Content-Type' => 'application/json'], '');
$dummy_response->content($dummy_json);

$useragent->map_response('accounts.google.com',           HTTP::Response->new('200', 'OK', ['Content-Type' => 'application/json'], ''));
$useragent->map_response('oauth2.googleapis.com',         HTTP::Response->new('200', 'OK', ['Content-Type' => 'application/json'], ''));
$useragent->map_response('www.googleapis.com',            HTTP::Response->new('200', 'OK', ['Content-Type' => 'application/json'], ''));
$useragent->map_response('analyticsadmin.googleapis.com', HTTP::Response->new('200', 'OK', ['Content-Type' => 'application/json'], ''));
$useragent->map_response('analyticsdata.googleapis.com',  $dummy_response);

my $ga4_mock = Test::MockModule->new('GoogleAnalyticsV4');
$ga4_mock->mock('new_ua', sub { $useragent });

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $user = MT->model('author')->load(1);
$app->user($user);

my $plugin_data = $app->model('plugindata')->new;
$plugin_data->plugin('GoogleAnalyticsV4');
$plugin_data->key('configuration:blog:1');
$plugin_data->data({
    profile_web_property_id => 'Dummy',
    profile_id              => 'Dummy',
    client_id               => 'Dummy',
    client_secret           => 'Dummy',
    measurement_id          => 'Dummy',
    token_data              => {
        start => time(),
        data  => {
            expires_in   => 3600,
            token_type   => 'Bearer',
            access_token => 'Dummy',
        },
    },
});
$plugin_data->save;

diag "test";

use MT::Test::DataAPI;
my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[{
            path   => '/v7/sites/1/stats/provider',
            method => 'GET',
            code   => 200,
            result => sub {
                +{ id => "GoogleAnalyticsV4" };
            }
        },
        {
            path   => '/v7/sites/1/stats/path/visits',
            params => { startDate => '2022-03-01', endDate => '2022-04-01', path => '/' },
            method => 'GET',
            code   => 200,
            setup  => sub {
                $dummy_res->{dimensionHeaders}->[0]->{name} = 'pagePath';
                $dummy_res->{metricHeaders}->[0]->{name}    = 'sessions';
                my $dummy_json = MT::Util::to_json($dummy_res);
                $dummy_response->content($dummy_json);
            },
        },
        {
            path   => '/v7/sites/1/stats/path/visits',
            params => { startDate => '2022-03-01', endDate => '2022-04-01', pagePath => '/' },
            method => 'GET',
            code   => 200,
            setup  => sub {
                $dummy_res->{dimensionHeaders}->[0]->{name} = 'pagePath';
                $dummy_res->{metricHeaders}->[0]->{name}    = 'sessions';
                my $dummy_json = MT::Util::to_json($dummy_res);
                $dummy_response->content($dummy_json);
            },
        },
        {
            path   => '/v7/sites/1/stats/date/visits',
            params => { startDate => '2022-03-01', endDate => '2022-04-01' },
            method => 'GET',
            code   => 200,
            setup  => sub {
                $dummy_res->{dimensionHeaders}->[0]->{name} = 'date';
                $dummy_res->{metricHeaders}->[0]->{name}    = 'sessions';
                my $dummy_json = MT::Util::to_json($dummy_res);
                $dummy_response->content($dummy_json);
            },
        },
        {
            path   => '/v7/sites/1/stats/path/pageviews',
            params => { startDate => '2022-03-01', endDate => '2022-04-01', path => '/' },
            method => 'GET',
            code   => 200,
            setup  => sub {
                $dummy_res->{dimensionHeaders}->[0]->{name} = 'pagePath';
                $dummy_res->{metricHeaders}->[0]->{name}    = 'screenPageViews';
                my $dummy_json = MT::Util::to_json($dummy_res);
                $dummy_response->content($dummy_json);
            },
        },
        {
            path   => '/v7/sites/1/stats/path/pageviews',
            params => { startDate => '2022-03-01', endDate => '2022-04-01', pagePath => '/' },
            method => 'GET',
            code   => 200,
            setup  => sub {
                $dummy_res->{dimensionHeaders}->[0]->{name} = 'pagePath';
                $dummy_res->{metricHeaders}->[0]->{name}    = 'screenPageViews';
                my $dummy_json = MT::Util::to_json($dummy_res);
                $dummy_response->content($dummy_json);
            },
        },
        {
            path   => '/v7/sites/1/stats/date/pageviews',
            params => { startDate => '2022-03-01', endDate => '2022-04-01' },
            method => 'GET',
            code   => 200,
            setup  => sub {
                $dummy_res->{dimensionHeaders}->[0]->{name} = 'date';
                $dummy_res->{metricHeaders}->[0]->{name}    = 'screenPageViews';
                my $dummy_json = MT::Util::to_json($dummy_res);
                $dummy_response->content($dummy_json);
            },
        },
        {
            path   => '/v7/sites/1/stats/path/sessions',
            params => { startDate => '2022-03-01', endDate => '2022-04-01', pagePath => '/' },
            method => 'GET',
            code   => 200,
            setup  => sub {
                $dummy_res->{dimensionHeaders}->[0]->{name} = 'pagePath';
                $dummy_res->{metricHeaders}->[0]->{name}    = 'sessions';
                my $dummy_json = MT::Util::to_json($dummy_res);
                $dummy_response->content($dummy_json);
            },
        },
        {
            path   => '/v7/sites/1/stats/path/sessions',
            params => { startDate => '2022-03-01', endDate => '2022-04-01', page => '/' },
            method => 'GET',
            code   => 200,
            setup  => sub {
                $dummy_res->{dimensionHeaders}->[0]->{name} = 'pagePath';
                $dummy_res->{metricHeaders}->[0]->{name}    = 'sessions';
                my $dummy_json = MT::Util::to_json($dummy_res);
                $dummy_response->content($dummy_json);
            },
        },
        {
            path   => '/v7/sites/1/stats/date/sessions',
            params => { startDate => '2022-03-01', endDate => '2022-04-01' },
            method => 'GET',
            code   => 200,
            setup  => sub {
                $dummy_res->{dimensionHeaders}->[0]->{name} = 'date';
                $dummy_res->{metricHeaders}->[0]->{name}    = 'sessions';
                my $dummy_json = MT::Util::to_json($dummy_res);
                $dummy_response->content($dummy_json);
            },
        },
        {
            path   => '/v7/sites/1/stats/path/screenpageviews',
            params => { startDate => '2022-03-01', endDate => '2022-04-01', pagePath => '/' },
            method => 'GET',
            code   => 200,
            setup  => sub {
                $dummy_res->{dimensionHeaders}->[0]->{name} = 'pagePath';
                $dummy_res->{metricHeaders}->[0]->{name}    = 'screenPageViews';
                my $dummy_json = MT::Util::to_json($dummy_res);
                $dummy_response->content($dummy_json);
            },
        },
        {
            path   => '/v7/sites/1/stats/path/screenpageviews',
            params => { startDate => '2022-03-01', endDate => '2022-04-01', path => '/' },
            method => 'GET',
            code   => 200,
            setup  => sub {
                $dummy_res->{dimensionHeaders}->[0]->{name} = 'pagePath';
                $dummy_res->{metricHeaders}->[0]->{name}    = 'screenPageViews';
                my $dummy_json = MT::Util::to_json($dummy_res);
                $dummy_response->content($dummy_json);
            },
        },
        {
            path   => '/v7/sites/1/stats/date/screenpageviews',
            params => { startDate => '2022-03-01', endDate => '2022-04-01' },
            method => 'GET',
            code   => 200,
            setup  => sub {
                $dummy_res->{dimensionHeaders}->[0]->{name} = 'date';
                $dummy_res->{metricHeaders}->[0]->{name}    = 'screenPageViews';
                my $dummy_json = MT::Util::to_json($dummy_res);
                $dummy_response->content($dummy_json);
            },
        }

    ];
}
