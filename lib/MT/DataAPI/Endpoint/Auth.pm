package MT::DataAPI::Endpoint::Auth;

use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;

use URI;
use MT::Session;

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

sub is_valid_redirect_url {
    my ( $app, $redirect_url ) = @_;
    eval { URI->new( $app->base )->host eq URI->new($redirect_url)->host; }
        or undef($@);
}

sub authorization {
    my ($app) = @_;

    my $token = $app->make_magic_token;

    my $redirect_url = $app->param('redirectUrl') || '';
    is_valid_redirect_url( $app, $redirect_url )
        or return $app->errtrans('Invalid parameter.');
    my $client_id = $app->current_client_id
        or return $app->errtrans('Invalid parameter.');

    my %param = (
        client_id                     => $client_id,
        redirect_url                  => $redirect_url,
        api_version                   => $app->current_api_version,
        mt_data_api_login_magic_token => $token,
    );

    if ( my $session = _current_session($app) ) {
        my $access_token = make_access_token( $app, $session );

        $param{access_token} = {
            session_id   => $session->id,
            access_token => $access_token->id,
            expires_in   => MT::AccessToken::ttl(),
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

sub authentication {
    my ($app) = @_;

    $app->current_client_id
        or return $app->error(400);

    my ( $author, $new_login ) = $app->login;
    my $session = $app->{session}
        or return $app->error(401);

    if ( $app->cookie_val( mt_data_api_login_magic_token_cookie_name() ) eq
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
    }

    my $access_token = make_access_token( $app, $session );

    +{  session_id   => $session->id,
        access_token => $access_token->id,
        expires_in   => MT::AccessToken::ttl(),
    };
}

sub _current_session {
    my ($app) = @_;

    my $data = $app->mt_authorization_data;
    if ( $data && $data->{MTAuth}{session_id} ) {
        MT::Session->load(
            {   id => $data->{MTAuth}{session_id} || '',
                kind => $app->session_kind,
            }
        ) or undef;
    }
    else {
        my ( $author, $new_login ) = $app->login;
        $app->{session};
    }
}

sub token {
    my ($app) = @_;

    my $session = _current_session($app)
        or return $app->error(401);

    my $access_token = make_access_token( $app, $session );

    +{  access_token => $access_token->id,
        expires_in   => MT::AccessToken::ttl(),
    };
}

sub revoke_authentication {
    my ($app) = @_;

    my $session = $app->{session} || _current_session($app)
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

sub revoke_token {
    my ($app) = @_;

    if ( my $data = $app->mt_authorization_data ) {
        $app->model('accesstoken')
            ->remove( { id => $data->{MTAuth}{access_token} } );
    }

    +{ status => 'success' };
}

1;
