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

use MT::Test::DataAPI;

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app    = MT::App::DataAPI->new;
my $author = MT->model('author')->load(2);
$author->set_password('bass');
$author->api_password('seecret');
$author->save or die $author->errstr;

my $disabled_user = MT->model('author')->new;
$disabled_user->set_values(
    {   name             => 'disabled',
        nickname         => 'Disabled',
        email            => 'disabled_user@example.com',
        url              => 'http://disabled_user.com/',
        userpic_asset_id => 3,
        api_password     => 'seecret',
        auth_type        => 'MT',
        created_on       => '19780131074500',
    }
);
$disabled_user->set_password('disabled');
$disabled_user->type( MT::Author::AUTHOR() );
$disabled_user->id(99);
$disabled_user->is_superuser(0);
$disabled_user->save()
    or die "Couldn't save author record 99: " . $disabled_user->errstr;
$disabled_user->can_sign_in_data_api(0);
$disabled_user->save()
    or die "Couldn't save author record 99: " . $disabled_user->errstr;

use MT::DataAPI::Endpoint::Auth;
use MT::AccessToken;

{
    ( my $base = __FILE__ ) =~ s/\.t$/.d/;
    $app->_init_plugins_core( {}, 1,
        [ File::Spec->join( $base, 'plugins' ) ] );
}

my $app_host    = 'http://mt.example.com';
my $magic_token = "Sticky magic token $$";

my $mock_app_api = Test::MockModule->new('MT::App::DataAPI');
$mock_app_api->mock( 'base', $app_host );

my $blog = $app->model('blog')->load(1);

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[
        {   path      => '/v1/authorization',
            method    => 'GET',
            author_id => 2,
            params    => { clientId => 'test', },
            complete  => sub {
                my ( $data, $body ) = @_;
                like(
                    $body,
                    qr/Invalid parameter/,
                    q{Got "Invalid parameter"}
                );
            }
        },
        {   path      => '/v1/authorization',
            method    => 'GET',
            author_id => 2,
            params    => { redirectUrl => $app_host . '/app', },
            complete  => sub {
                my ( $data, $body ) = @_;
                like(
                    $body,
                    qr/Invalid parameter/,
                    q{Got "Invalid parameter"}
                );
            }
        },
        {   path      => '/v1/authorization',
            method    => 'GET',
            author_id => 2,
            params    => {
                clientId    => 'test',
                redirectUrl => 'http://invalid.example.com/app',
            },
            complete => sub {
                my ( $data, $body ) = @_;
                like(
                    $body,
                    qr/Invalid parameter/,
                    q{Got "Invalid parameter"}
                );
            }
        },
        {   path      => '/v1/authorization',
            method    => 'GET',
            author_id => 2,
            params    => {
                clientId    => 'test',
                redirectUrl => $app_host . '/app',
            },
            complete => sub {
                my ( $data, $body ) = @_;
                unlike(
                    $body,
                    qr/Invalid parameter/,
                    q{Got form successfully}
                );
            }
        },
        {   path      => '/v1/authorization',
            method    => 'GET',
            author_id => 2,
            params    => {
                clientId    => 'test',
                redirectUrl => $blog->site_url . '/app',
            },
            complete => sub {
                my ( $data, $body ) = @_;
                unlike(
                    $body,
                    qr/Invalid parameter/,
                    q{Got form successfully}
                );
            },
        },
        {   path      => '/v1/authentication',
            method    => 'POST',
            author_id => 2,
            params    => {
                clientId      => 'test',
                redirect_type => MT::DataAPI::Endpoint::Auth::BLOG_HOST(),
            },
            setup => sub {
                $mock_app_api->mock(
                    'login',
                    sub {
                        my $app = shift;
                        $app->start_session( $author, 1 );
                        return $author, 1;
                    }
                );
                $mock_app_api->mock(
                    'make_magic_token',
                    sub {
                        return $magic_token;
                    }
                );
            },
            result   => { oneTimeToken => $magic_token, },
            complete => sub {
                $mock_app_api->unmock( 'login', 'make_magic_token' );
            },
        },
        {   note            => 'Get token from oneTimeToken',
            path            => '/v1/token',
            author_id       => 2,
            method          => 'POST',
            request_headers => {
                'X_MT_AUTHORIZATION' =>
                    qq{MTAuth oneTimeToken="$magic_token"},
            },
            result => {
                sessionId   => $magic_token,
                accessToken => $magic_token,
                expiresIn   => MT::AccessToken::ttl(),
                remember    => $JSON::true,
            },
        },
        {   note            => 'Get token from oneTimeToken again',
            path            => '/v1/token',
            author_id       => 2,
            method          => 'POST',
            request_headers => {
                'X_MT_AUTHORIZATION' =>
                    qq{MTAuth oneTimeToken="$magic_token"},
            },
            code => 401,
        },

        {   note   => 'Disabled user cannot sign in',
            path   => '/v1/authentication',
            method => 'POST',
            params => {
                clientId => 'test',
                username => 'disabled',
                password => 'secret',
            },
            code => 401,
        },

        # version 2
        {   note   => 'v2 Disabled user cannot sign in',
            path   => '/v2/authentication',
            method => 'POST',
            params => {
                clientId => 'test',
                username => 'disabled',
                password => 'secret',
            },
            code => 401,
        },

        # version 3
        {   note   => 'v3 authentication with user password is failed',
            path   => '/v3/authentication',
            method => 'POST',
            params => {
                clientId => 'test',
                username => 'Chuck D',
                password => 'bass',
            },
            code => 401,
        },
        {   note =>
                'v3 authentication with user web service password is succeeded',
            path   => '/v3/authentication',
            method => 'POST',
            params => {
                clientId => 'test',
                username => 'Chuck D',
                password => 'seecret',
            },
        },

        {   note   => 'v3 Disabled user cannot sign in',
            path   => '/v3/authentication',
            method => 'POST',
            params => {
                clientId => 'test',
                username => 'disabled',
                password => 'secret',
            },
            code => 401,
        },

        # version 4
        {   note   => 'v4 Disabled user cannot sign in',
            path   => '/v4/authentication',
            method => 'POST',
            params => {
                clientId => 'test',
                username => 'disabled',
                password => 'secret',
            },
            code => 401,
        },

    ];
}

