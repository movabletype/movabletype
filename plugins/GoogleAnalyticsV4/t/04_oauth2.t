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

use HTTP::Request;
use HTTP::Response;
use GoogleAnalyticsV4::OAuth2;
use MT::App;
use MT::Util;

my $app = MT::App->instance;
my $ua  = Test::LWP::UserAgent->new;

my $ga4_mock = Test::MockModule->new('GoogleAnalyticsV4');
$ga4_mock->mock('new_ua', sub { $ua });

sub set_responses {
    my ($token, $args) = @_;
    my %header = GoogleAnalyticsV4::authorization_header($token);
    my %res;

    $ua->unmap_all(1);

    for my $path (keys %$args) {
        for my $arg (@{ $args->{$path} }) {
            my $code   = $arg->{code}   // 200;
            my $status = $arg->{status} // 'OK';
            my $result = $arg->{result} // {};
            push @{ $res{$path} }, HTTP::Response->new($code, $status, ['Content-Type' => 'application/json'], MT::Util::to_json($result));
        }
        $ua->map_response(
            qr/$path/ => sub {
                my ($req) = @_;
                diag("$path");
                ok $req->uri !~ qr/access_token/,
                    'No access_token in path_query : ' . $req->uri->path_query;
                is $req->header('Authorization'), $header{Authorization},
                    'Authorization header : ' . $req->header('Authorization');
                return shift @{ $res{$path} };
            });
    }
}

subtest 'authorization_header' => sub {
    my $token = {
        data => {
            token_type   => 'Bearer',
            access_token => 'DUMMY_ACCESS_TOKEN',
        } };

    my %header = GoogleAnalyticsV4::authorization_header($token);
    is $header{Authorization}, "Bearer DUMMY_ACCESS_TOKEN", 'token_type is Bearer';

    delete $token->{data}->{token_type};
    $token->{data}->{access_token} = 'DUMMY_ACCESS_TOKEN2';

    %header = GoogleAnalyticsV4::authorization_header($token);
    is $header{Authorization}, "Bearer DUMMY_ACCESS_TOKEN2", 'default token_type is Bearer';

    delete $token->{data}->{access_token};
    %header = GoogleAnalyticsV4::authorization_header($token);
    is scalar(%header), 0, 'No header without access_token';

    %header = GoogleAnalyticsV4::authorization_header();
    is scalar(%header), 0, 'No header with undef';
};

subtest 'get_username' => sub {
    my $token = {
        data => {
            token_type   => 'Bearer',
            access_token => 'ACCESS_TOKEN_XXXX',
        } };

    set_responses(
        $token, {
            '/v1beta/accounts' => [{
                    result => { accounts => [{ name => 'mt_user' }] },
                },
            ] });

    my $username = GoogleAnalyticsV4::OAuth2::get_username($app, $ua, $token);
    is $username, 'mt_user', 'usename';
};

subtest 'get_profiles & get_webstream' => sub {
    my $token = {
        data => {
            token_type   => 'Bearer',
            access_token => 'ACCESS_TOKEN_YYYY',
        } };

    set_responses(
        $token, {
            '/v1beta/accountSummaries' => [{
                    result => {
                        accountSummaries => [{
                            propertySummaries => [{
                                property => 'properties/xxxxxxxx',
                            }],
                        }],
                        nextPageToken => 'dummy',
                    },
                }, {
                    result => {
                        accountSummaries => [{
                            propertySummaries => [{
                                property => 'properties/yyyyyyyy',
                            }],
                        }],
                        nextPageToken => '',
                    },
                }
            ],
            '/v1beta/properties/xxxxxxxx/dataStreams' => [{
                result => {
                    dataStreams => [{
                        webStreamData => {
                            measurementId => 'G-XXXXXXXXXX',
                            defaultUri    => 'https://example.com',
                        },
                    }]
                },
            }],
            '/v1beta/properties/yyyyyyyy/dataStreams' => [{
                    result => {
                        dataStreams => [{
                            webStreamData => {    # use this
                                measurementId => 'G-YYYYYYYYY1',
                                defaultUri    => 'https://example.com',
                            },
                        }],
                        nextPageToken => 'dummy',
                    },
                }, {
                    result => {
                        dataStreams => [{
                            webStreamData => {
                                measurementId => 'G-YYYYYYYYY2',
                                defaultUri    => 'https://example.com',
                            },
                        }],
                        nextPageToken => '',
                    },
                }
            ],
        });

    my $res = GoogleAnalyticsV4::OAuth2::get_profiles($app, $ua, $token);
    is_deeply $res, [{
            'defaultUri'    => 'https://example.com',
            'property'      => 'properties/xxxxxxxx',
            'measurementId' => 'G-XXXXXXXXXX'
        }, {
            'defaultUri'    => 'https://example.com',
            'property'      => 'properties/yyyyyyyy',
            'measurementId' => 'G-YYYYYYYYY1'
        }
        ],
        'get_profiles result';
};

subtest 'request' => sub {
    my $blog        = MT::Blog->new(id => 1);
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

    $app->request('ga4_current_plugindata:blog:1' => $plugin_data);

    set_responses(
        $plugin_data->data->{token_data}, {
            '/v1beta/Dummy:runReport' => [
                { code => 401 },    # retry
                { code => 200 },
            ] });

    require GoogleAnalyticsV4::Provider;
    my $provider = GoogleAnalyticsV4::Provider->new(1 => $blog);
    $provider->_request($app, {});
};

subtest 'scope in authorize_url' => sub {
    my $uri   = MT::Util::decode_url(GoogleAnalyticsV4::OAuth2::authorize_url($app, 'dummy', 'dummy'));
    my %scope = map { $_ => 1 } split /\+/, ($uri =~ qr{scope=([^&]+)})[0];
    is_deeply \%scope, { 'https://www.googleapis.com/auth/analytics.readonly' => 1 }, 'scope';
};

done_testing;
