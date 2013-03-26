package MT::API::Endpoint::Auth;

use strict;
use warnings;
  
use base qw(MT::API::Endpoint);

use URI;

sub mt_api_login_magic_token_cookie_name {
    'mt_api_login_magic_token';
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
    my ( $app, $redirect_uri ) = @_;
    eval { URI->new( $app->base )->host eq URI->new($redirect_uri)->host; }
        or undef($@);
}

sub authorization {
    my ($app) = @_;

    my $token = $app->make_magic_token;

    my $redirect_uri = $app->param('redirect_uri') || '';
    is_valid_redirect_url( $app, $redirect_uri ) or die;

    my %param = (
        redirect_uri             => $redirect_uri,
        api_version              => $app->api_version,
        mt_api_login_magic_token => $token,
    );

    # TODO if redirect_uri is not specified

    $app->bake_cookie(
        -name  => mt_api_login_magic_token_cookie_name(),
        -value => $token,
        -path  => $app->config->CookiePath || $app->mt_path,
    );
    $app->show_login( \%param );
}

sub authentication {
    my ($app) = @_;

    my ( $author, $new_login ) = $app->login;
    my $session = $app->{session}
        or die;

    # TODO if not loggined

    if ( $app->cookie_val( mt_api_login_magic_token_cookie_name() ) eq
        ( $app->param('mt_api_login_magic_token') || '' ) )
    {
        my $remember = $session->get('remember');
        my %arg      = (
            -name  => $app->user_cookie,
            -value => Encode::encode(
                $app->charset,
                join( '::', $author->name, $session->id, $remember )
            ),
            -path => $app->config->CookiePath || $app->mt_path,
            -httponly => 1,
        );
        $arg{-expires} = '+10y' if $remember;
        $app->bake_cookie(%arg);

        $app->bake_cookie(
            -name    => mt_api_login_magic_token_cookie_name(),
            -value   => '',
            -path    => $app->config->CookiePath || $app->mt_path,
            -expires => '-1y',
        );
    }

    my $access_token = make_access_token( $app, $session );

    +{  session_id   => $session->id,
        access_token => $access_token->id,
        expires_in   => MT::AccessToken::ttl(),
    };
}

sub token {
    my ($app) = @_;

    my ( $author, $new_login ) = $app->login;
    my $session = $app->{session}
        or die;

    # TODO if not loggined

    my $access_token = make_access_token( $app, $session );

    +{  session_id   => $session->id,
        access_token => $access_token->id,
        expires_in   => MT::AccessToken::ttl(),
    };
}

1;
