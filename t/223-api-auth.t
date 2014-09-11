#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

BEGIN {
    use Test::More;
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

use lib qw(lib extlib t/lib);

eval(
    $ENV{SKIP_REINITIALIZE_DATABASE}
    ? "use MT::Test qw(:app);"
    : "use MT::Test qw(:app :db :data);"
);
die $@ if $@;

use MT::App::DataAPI;
use MT::DataAPI::Endpoint::Auth;
use MT::AccessToken;

my $app    = MT::App::DataAPI->new;
my $author = MT->model('author')->load(2);
{
    ( my $base = __FILE__ ) =~ s/\.t$/.d/;
    $app->_init_plugins_core( {}, 1,
        [ File::Spec->join( $base, 'plugins' ) ] );
}

my $app_host    = 'http://mt.example.com';
my $magic_token = "Sticky magic token $$";

my $mock_author = Test::MockModule->new('MT::Author');
$mock_author->mock( 'is_superuser', sub {0} );
my $mock_app_api = Test::MockModule->new('MT::App::DataAPI');
$mock_app_api->mock( 'authenticate', $author );
$mock_app_api->mock( 'base',         $app_host );

my $blog = $app->model('blog')->load(1);

my @suite = (
    {   path     => '/v1/authorization',
        method   => 'GET',
        params   => { clientId => 'test', },
        complete => sub {
            my ( $data, $body ) = @_;
            like( $body, qr/Invalid parameter/, q{Got "Invalid parameter"} );
            }
    },
    {   path     => '/v1/authorization',
        method   => 'GET',
        params   => { redirectUrl => $app_host . '/app', },
        complete => sub {
            my ( $data, $body ) = @_;
            like( $body, qr/Invalid parameter/, q{Got "Invalid parameter"} );
            }
    },
    {   path   => '/v1/authorization',
        method => 'GET',
        params => {
            clientId    => 'test',
            redirectUrl => 'http://invalid.example.com/app',
        },
        complete => sub {
            my ( $data, $body ) = @_;
            like( $body, qr/Invalid parameter/, q{Got "Invalid parameter"} );
            }
    },
    {   path   => '/v1/authorization',
        method => 'GET',
        params => {
            clientId    => 'test',
            redirectUrl => $app_host . '/app',
        },
        complete => sub {
            my ( $data, $body ) = @_;
            unlike( $body, qr/Invalid parameter/, q{Got form successfully} );
            }
    },
    {   path   => '/v1/authorization',
        method => 'GET',
        params => {
            clientId    => 'test',
            redirectUrl => $blog->site_url . '/app',
        },
        complete => sub {
            my ( $data, $body ) = @_;
            unlike( $body, qr/Invalid parameter/, q{Got form successfully} );
        },
    },
    {   path   => '/v1/authentication',
        method => 'POST',
        params => {
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
        method          => 'POST',
        request_headers => {
            'X_MT_AUTHORIZATION' => qq{MTAuth oneTimeToken="$magic_token"},
        },
        result => {
            sessionId   => $magic_token,
            accessToken => $magic_token,
            expiresIn   => MT::AccessToken::ttl(),
            remember    => 'true',
        },
    },
    {   note            => 'Get token from oneTimeToken again',
        path            => '/v1/token',
        method          => 'POST',
        request_headers => {
            'X_MT_AUTHORIZATION' => qq{MTAuth oneTimeToken="$magic_token"},
        },
        code => 401,
    },
);

my %callbacks = ();
my $mock_mt   = Test::MockModule->new('MT');
$mock_mt->mock(
    'run_callbacks',
    sub {
        my ( $app, $meth, @param ) = @_;
        $callbacks{$meth} ||= [];
        push @{ $callbacks{$meth} }, \@param;
        $mock_mt->original('run_callbacks')->(@_);
    }
);

my $format = MT::DataAPI::Format->find_format('json');

for my $data (@suite) {
    $data->{setup}->($data) if $data->{setup};

    my $path = $data->{path};
    $path
        =~ s/:(?:(\w+)_id)|:(\w+)/ref $data->{$1} ? $data->{$1}->id : $data->{$2}/ge;

    my $params
        = ref $data->{params} eq 'CODE'
        ? $data->{params}->($data)
        : $data->{params};

    my $note = $path;
    if ( lc $data->{method} eq 'get' && $data->{params} ) {
        $note .= '?'
            . join( '&',
            map { $_ . '=' . $data->{params}{$_} }
                keys %{ $data->{params} } );
    }
    $note .= ' ' . $data->{method};
    $note .= ' ' . $data->{note} if $data->{note};
    note($note);

    if ( $data->{config} ) {
        for my $k ( keys %{ $data->{config} } ) {
            $app->config->$k( $data->{config}{$k} );
        }
    }
    if ( $data->{request_headers} ) {
        for my $k ( keys %{ $data->{request_headers} } ) {
            $ENV{ 'HTTP_' . uc $k } = $data->{request_headers}{$k};
        }
    }

    %callbacks = ();
    _run_app(
        'MT::App::DataAPI',
        {   __path_info      => $path,
            __request_method => $data->{method},
            ( $data->{upload} ? ( __test_upload => $data->{upload} ) : () ),
            (   $params
                ? map {
                    $_ => ref $params->{$_}
                        ? MT::Util::to_json( $params->{$_} )
                        : $params->{$_};
                    }
                    keys %{$params}
                : ()
            ),
        }
    );
    my $out = delete $app->{__test_output};
    my ( $headers, $body ) = split /^\s*$/m, $out, 2;
    my %headers = map {
        my ( $k, $v ) = split /\s*:\s*/, $_, 2;
        $v =~ s/(\r\n|\r|\n)\z//;
        lc $k => $v
        }
        split /\n/, $headers;
    my $expected_status = $data->{code} || 200;
    is( $headers{status}, $expected_status, 'Status ' . $expected_status );
    if ( $data->{next_phase_url} ) {
        like(
            $headers{'x-mt-next-phase-url'},
            $data->{next_phase_url},
            'X-MT-Next-Phase-URL'
        );
    }
    if ( $data->{response_headers} ) {
        for my $k ( keys %{ $data->{response_headers} } ) {
            is( $headers{ lc $k }, $data->{response_headers}{$k}, $k );
        }
    }

    foreach my $cb ( @{ $data->{callbacks} } ) {
        my $params_list = $callbacks{ $cb->{name} } || [];
        if ( my $params = $cb->{params} ) {
            for ( my $i = 0; $i < scalar(@$params); $i++ ) {
                is_deeply( $params_list->[$i], $cb->{params}[$i] );
            }
        }

        if ( my $c = $cb->{count} ) {
            is( @$params_list, $c,
                $cb->{name} . ' was called ' . $c . ' time(s)' );
        }
    }

    if ( my $expected_result = $data->{result} ) {
        $expected_result = $expected_result->( $data, $body )
            if ref $expected_result eq 'CODE';
        if ( UNIVERSAL::isa( $expected_result, 'MT::Object' ) ) {
            MT->instance->user($author);
            $expected_result = $format->{unserialize}->(
                $format->{serialize}->(
                    MT::DataAPI::Resource->from_object($expected_result)
                )
            );
        }

        my $result = $format->{unserialize}->($body);
        is_deeply( $result, $expected_result, 'result' );
    }

    if ( my $complete = $data->{complete} ) {
        $complete->( $data, $body );
    }
}

done_testing();
