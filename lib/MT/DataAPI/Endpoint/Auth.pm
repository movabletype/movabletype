# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::Auth;

use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;

use URI;
use boolean ();
use MT::Session;
use MT::Util;

sub APP_HOST ()  {'app'}
sub BLOG_HOST () {'blog'}

sub mt_data_api_login_magic_token_cookie_name {
    'mt_data_api_login_magic_token';
}

sub make_access_token {
    my ( $app, $session ) = @_;
    my $token = $app->model('accesstoken')->new;
    $token->set_values(
        {   id         => $app->make_magic_token,
            session_id => $session->id,
            start      => time,
        }
    );
    $token->save;

    $token;
}

sub check_redirect_url {
    my ( $app, $redirect_url ) = @_;
    my $redirect_host = URI->new( $redirect_url, 'http' )->host || '';
    return APP_HOST
        if ( URI->new( $app->base, 'http' )->host || '' ) eq $redirect_host;

    my $iter = $app->model('blog')->load_iter( { class => '*' } );
    while ( my $b = $iter->() ) {
        return BLOG_HOST
            if ( URI->new( $b->site_url, 'http' )->host || '' ) eq
            $redirect_host;
    }

    return undef;
}

sub authorization_openapi_spec {
    +{
        tags        => ['Authentication'],
        summary     => 'Return authorization(login) form as HTML',
        description => 'Return authorization(login) form as HTML.',
        parameters  => [{
                'in'        => 'query',
                name        => 'redirectUrl',
                schema      => { type => 'string' },
                description => 'This is required. When you succeed in login, you are redirected to the redirectUrl with "#_login". ',
                required    => JSON::true,
            },
            {
                'in'        => 'query',
                name        => 'clientId',
                schema      => { type => 'string' },
                description => 'This is required. the client ID of the application.',
                required    => JSON::true,
            },
        ],
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'text/html' => {
                        schema => { type => 'string' },
                    },
                },
            },
        },
    };
}

sub authorization {
    my ($app) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    my $token = $app->make_magic_token;

    my $redirect_url = $app->param('redirectUrl') || '';
    my $redirect_type = check_redirect_url( $app, $redirect_url )
        or return $app->errtrans('Invalid parameter.');
    my $client_id = $app->current_client_id
        or return $app->errtrans('Invalid parameter.');

    my %param = (
        client_id                     => $client_id,
        redirect_url                  => $redirect_url,
        redirect_type                 => $redirect_type,
        api_version                   => $app->current_api_version,
        mt_data_api_login_magic_token => $token,
    );

    if ( $redirect_type eq BLOG_HOST ) {

        # Do nothing
    }
    elsif ( my $session = _current_session($app) ) {
        my $access_token = make_access_token( $app, $session );

        $param{access_token} = {
            accessToken => $access_token->id,
            expiresIn   => MT::AccessToken::ttl(),
        };
    }
    else {
        $app->bake_cookie(
            -name  => mt_data_api_login_magic_token_cookie_name(),
            -value => $token,
            -path  => $app->config->CookiePath || $app->mt_path,
        );
    }

    # Clear login error
    $app->error(undef);

    $app->show_login( \%param );
}

sub authentication_openapi_spec {
    +{
        tags        => ['Authentication'],
        summary     => 'Create new session and access token. This is like login',
        description => 'Create new session and access token. This is like login.',
        requestBody => {
            required => JSON::true,
            content  => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            username => {
                                type        => 'string',
                                description => 'The username to authenticate.',
                            },
                            password => {
                                type        => 'string',
                                format      => 'password',
                                description => 'The password of the user.',
                            },
                            clientId => {
                                type        => 'string',
                                description => 'This is not required if you specify session id via "X-MT-Authorization" request header. You can create new access token if you have a session id related to this clientId, although you do not have an access token. ',
                            },
                            remember => {
                                type        => 'integer',
                                description => 'If true (generally, "1" is specified.), a new session will be created as a persistent session. If you want to specify false, you can pass "" or "0" to this parameter.',
                                enum => [0, 1],
                            },
                            mtDataApiLoginMagicToken => {
                                type        => 'string',
                                description => 'This is not required if you authenticate except via browser. If this parameter is passed and valid the MT will set cookie in order to start a session. ',
                            },
                        },
                    },
                },
            },
        },
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                sessionId => {
                                    type        => 'string',
                                    description => 'Session ID. This value is included only when mtDataApiLoginMagicToken is not passed. If mtDataApiLoginMagicToken is passed (and is valid value), sessionId is stored in httponly-cookie.',
                                },
                                accessToken => {
                                    type        => 'string',
                                    description => 'Access token',
                                },
                                expiresIn => {
                                    type        => 'integer',
                                    description => 'This access token will be invalidated automatically after the number of seconds specified here.',
                                },
                                remember => {
                                    type        => 'boolean',
                                    description => 'If true, a new session has been created as a persistent session.',
                                },
                            },
                        },
                    },
                },
            },
        },
    };
}

sub authentication {
    my ($app) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    _authentication( $app, sub { $_[0]->login } );
}

sub _authentication {
    my ( $app, $login ) = @_;

    $app->current_client_id
        or return $app->error(400);

    my ( $author, $new_login ) = $login->($app);
    my $session = $app->{session};
    if ( !$author or !$session ) {
        delete $app->{redirect};
        return $app->error( 'Invalid login', 401 );
    }

    # Check user permission
    if ( !$author->can_sign_in_data_api ) {
        $app->log(
            {   message => $app->translate(
                    "Failed login attempt by user who does not have sign in permission via data api. '[_1]' (ID:[_2])",
                    $author->name,
                    $author->id,
                ),
                level    => MT::Log::SECURITY(),
                category => 'login_user',
                class    => 'author',
            }
        );

        # Invalidate user session
        if ( my $session = $app->session ) {
            $session->remove;
        }
        $app->clear_login_cookie;

        return $app->error( 'Invalid login', 401 );
    }

    my $access_token = make_access_token( $app, $session );

    my $response = {
        sessionId   => $session->id,
        accessToken => $access_token->id,
        expiresIn   => MT::AccessToken::ttl(),
        remember    => $session->get('remember')
        ? boolean::true()
        : boolean::false(),
    };

    my $magic_token_cookie
        = $app->cookie_val( mt_data_api_login_magic_token_cookie_name() );
    if (   $magic_token_cookie
        && $magic_token_cookie eq
        ( $app->param('mtDataApiLoginMagicToken') || '' ) )
    {
        my $remember = $session->get('remember') || '';
        my %arg = (
            -name  => $app->user_cookie,
            -value => Encode::encode(
                $app->charset,
                join( '::', $author->name, $session->id, $remember )
            ),
            -httponly => 1,
        );
        $arg{-expires} = '+10y' if $remember;
        $app->bake_cookie(%arg);

        $app->bake_cookie(
            -name    => mt_data_api_login_magic_token_cookie_name(),
            -value   => '',
            -expires => '-1y',
        );

        delete $response->{sessionId};
    }

    if ( ( $app->param('redirect_type') || '' ) eq BLOG_HOST ) {
        my $ott = MT->model('session')->new();
        $ott->kind('OT');    # One time Token
        $ott->id( $app->make_magic_token() );
        $ott->start(time);
        $ott->duration( time + 5 * 60 );
        $ott->set( response =>
                MT::Util::to_json( $response, { convert_blessed => 1 } ) );
        $ott->save
            or return $app->error(
            $app->translate(
                "The login could not be confirmed because of a database error ([_1])",
                $ott->errstr
            )
            );
        $response = { oneTimeToken => $ott->id, };
    }

    $app->log({
        message  => $app->translate(
            "User '[_1]' (ID:[_2]) logged in successfully via data api.",
            $author->name, $author->id
        ),
        level    => MT::Log::INFO(),
        class    => 'author',
        category => 'login_user',
    });

    $response;
}

sub _load_token_by_ott {
    my ($app) = @_;

    my $data = $app->mt_authorization_data;
    if ( $data && $data->{MTAuth}{oneTimeToken} ) {
        if (my $ott = MT::Session::get_unexpired_value(
                5 * 60, { id => $data->{MTAuth}{oneTimeToken}, kind => 'OT' }
            )
            )
        {
            my $response = MT::Util::from_json( $ott->get('response') );
            $ott->remove();
            return $response;
        }
        else {
            return undef;
        }
    }

    return qw();
}

sub _current_session_from_authorization_data {
    my ($app) = @_;

    my $data = $app->mt_authorization_data;
    if ( $data && $data->{MTAuth}{sessionId} ) {
        MT::Session->load(
            {   id => $data->{MTAuth}{sessionId} || '',
                kind => $app->session_kind,
            }
        ) or undef;
    }
}

sub _current_session {
    my ($app) = @_;

    my $data = $app->mt_authorization_data;
    if ( $data && $data->{MTAuth}{sessionId} ) {
        _current_session_from_authorization_data($app);
    }
    else {
        my ( $author, $new_login ) = $app->login;
        $app->{session};
    }
}

sub token_openapi_spec {
    +{
        tags        => ['Authentication'],
        summary     => 'Create new access token related to current session',
        description => <<'DESCRIPTION',
Create new access token related to current session.

In order to create new access token, in the case of a web browser, it is necessary to create session via authentication endpoints beforehand.

In the case of other than a browser, it is necessary to send a sessionId that is retrieved via authentication endpoints in MTAuth request header.

`MTAuth sessionId={retrieved sessionId}`
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            clientId => {
                                type        => 'string',
                                description => 'This is not required if you specify session id via "X-MT-Authorization" request header. You can create new access token if you have a session id related to this clientId, although you do not have an access token. ',
                            },
                        },
                    },
                },
            },
        },
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                accessToken => {
                                    type        => 'string',
                                    description => 'Access token',
                                },
                                expiresIn => {
                                    type        => 'integer',
                                    description => 'This access token will be invalidated automatically after the number of seconds specified here.',
                                },
                            },
                        },
                    },
                },
            },
        },
    };
}

sub token {
    my ($app) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    if ( my ($response) = _load_token_by_ott($app) ) {
        return $response || $app->error(401);
    }

    my $session = _current_session($app)
        or return $app->error(401);

    my $access_token = make_access_token( $app, $session );

    +{  accessToken => $access_token->id,
        expiresIn   => MT::AccessToken::ttl(),
    };
}

sub revoke_authentication_openapi_spec {
    +{
        tags        => ['Authentication'],
        summary     => 'Invalidate current access token. This is not logout',
        description => <<'DESCRIPTION',
Invalidate current session. This is like logout. All access tokens related to that session are invalidated too.

Authorization is required. but if there is an effective session, user can revoke by the following methods.

In the case of a web browser, can be authorized by httponly-cookie.

In the case of other than a browser, can be authorized by sending a sessionId that is retrieved via authentication endpoints in MTAuth request header.

`MTAuth sessionId={retrieved sessionId}`
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            clientId => {
                                type        => 'string',
                                description => 'This is not required if you specify session id via "X-MT-Authorization" request header. You can create new access token if you have a session id related to this clientId, although you do not have an access token. ',
                            },
                        },
                    },
                },
            },
        },
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                status => {
                                    type        => 'string',
                                    description => 'The value of this parameter is always "success".',
                                },
                            },
                        },
                    },
                },
            },
        },
    };
}

sub revoke_authentication {
    my ($app) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    my $session
        = $app->session || _current_session_from_authorization_data($app)
        or return $app->error(401);

    if ( my $user
        = $app->model('author')->load( $session->get('author_id') ) )
    {
        $app->log(
            {   message => $app->translate(
                    "User '[_1]' (ID:[_2]) logged out", $user->name,
                    $user->id
                ),
                level    => MT::Log::INFO(),
                class    => 'author',
                category => 'logout_user',
            }
        );
    }

    $session->remove;
    $app->model('accesstoken')->remove( { session_id => $session->id } );
    $app->clear_login_cookie;

    +{ status => 'success' };
}

sub revoke_token_openapi_spec {
    +{
        tags        => ['Authentication'],
        summary     => 'Invalidate current session. This is like logout',
        description => <<'DESCRIPTION',
Invalidate current access token. This is not logout. If the browser has active session id, new access token can be obtained easily.

Authorization is required.
DESCRIPTION
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                status => {
                                    type        => 'string',
                                    description => 'The value of this parameter is always "success".',
                                },
                            },
                        },
                    },
                },
            },
        },
    };
}

sub revoke_token {
    my ($app) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    if ( my $data = $app->mt_authorization_data ) {
        $app->model('accesstoken')
            ->remove( { id => $data->{MTAuth}{accessToken} } );
    }

    +{ status => 'success' };
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::Auth - Movable Type class for endpoint definitions about authentication.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
