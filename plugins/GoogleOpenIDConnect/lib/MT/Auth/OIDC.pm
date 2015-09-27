# Movable Type (r) (C) 2001-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Auth::OIDC;
use strict;
use JSON qw/encode_json decode_json/;
use MT::Util;

my $scope = 'openid email profile phone address';

BEGIN {
    eval {
        require OIDC::Lite::Client::WebServer;
        require OIDC::Lite::Model::IDToken;
    };
    die $@ if $@;
}

sub login {
    my $class    = shift;
    my ($app)    = @_;
    my $q        = $app->param;
    my $blog     = $app->model('blog')->load( scalar $q->param('blog_id') );
    my $identity = $q->param('openid_url');
    if (   !$identity
        && ( my $u = $q->param('openid_userid') )
        && $class->can('url_for_userid') )
    {
        $identity = $class->url_for_userid($u);
    }

    return $app->redirect(
        $class->_uri_to_authorization_endpoint( $app, $blog ) );

}

sub handle_sign_in {
    my $class = shift;
    my ( $app, $auth_type ) = @_;
    my $q        = $app->{query};
    my $INTERVAL = 60 * 60 * 24 * 7;

    if ( $q->param("error") ) {
        return $app->error(
            $app->translate(
                "Authentication failure: [_1]",
                $q->param("error")
            )
        );
    }
    my $state_session_id = $q->param('state');
    my $state_session;
    my $blog_id;
    my $static;
    if ($state_session = MT::Session::get_unexpired_value(
            5 * 60, { id => $state_session_id, kind => 'OT' }
        )
        )
    {
        $blog_id = $state_session->get('blog_id');
        $static  = $state_session->get('static');
        $state_session->remove();
    }
    else {
        return $app->error(
            'The state parameter is missing or not matched with session.');
    }
    $app->param( 'blog_id', $blog_id );
    $app->param( 'static',  $static );
    my $blog = $app->model('blog')->load($blog_id);

    # code
    my $code = $q->param('code');
    unless ($code) {

        # invalid code
        return $app->error('The code parameter is missing.');
    }

    my $client = $class->_client( $app, $blog );

    # get_access_token
    my $token = $client->get_access_token(
        code         => $code,
        redirect_uri => _create_return_url( $app, $blog ),
    );
    unless ($token) {
        return $app->error('Failed to get access token response');
    }

    # ID Token validation
    my $id_token      = OIDC::Lite::Model::IDToken->load( $token->id_token );
    my $config        = $class->_get_client_info( $app, $blog );
    my $authenticator = _get_commenter_authenticator($app);
    $config->{iss} = $authenticator->{issuer_identifier};
    if ( my $error
        = $class->_validate_id_token( $id_token->payload, $config, ) )
    {
        return $app->error($error);
    }

    # get_user_info
    my $userinfo_res = $class->_get_userinfo( $app, $token->access_token );
    unless ( $userinfo_res->is_success ) {
        return $app->error( $userinfo_res->message );
    }
    my $user_info = $userinfo_res->content;
    $user_info = decode_json($user_info);
    my $nickname     = $user_info->{name};
    my $sub          = $user_info->{sub};
    my $author_class = $app->model('author');
    my $cmntr        = $author_class->load(
        {   name      => $sub,
            type      => $author_class->COMMENTER(),
            auth_type => $auth_type,
        }
    );

    if ($cmntr) {
        unless (
            (   $cmntr->modified_on
                && ( MT::Util::ts2epoch( $blog, $cmntr->modified_on )
                    > time - $INTERVAL )
            )
            || ($cmntr->created_on
                && ( MT::Util::ts2epoch( $blog, $cmntr->created_on )
                    > time - $INTERVAL )
            )
            )
        {
            $class->set_commenter_properties( $cmntr, $user_info );
            $cmntr->save or return 0;
        }

    }
    else {
        $cmntr = $app->make_commenter(
            name        => $sub,
            nickname    => $nickname,
            auth_type   => $auth_type,
            external_id => $sub,
            url         => $user_info->{profile},
        );
        if ($cmntr) {
            $class->set_commenter_properties( $cmntr, $user_info );
            $cmntr->save or return 0;
        }
    }

    my $session = $app->make_commenter_session($cmntr);
    unless ($session) {
        $app->error( $app->errstr()
                || $app->translate("Could not save the session") );
        return 0;
    }
    return ( $cmntr, $session );
}

sub _validate_id_token {
    my ( $class, $payload, $config ) = @_;

    # iss
    unless ( $payload->{iss} ) {
        return 'iss does not exist.';
    }

    unless ( $payload->{iss} eq $config->{iss} ) {
        return 'iss is not matched.';
    }

    # iat
    unless ( $payload->{iat} ) {
        return 'iat does not exist.';
    }
    my $now = time();
    unless ( $payload->{iat} <= $now ) {
        return 'iat is greater than current timestamp.';
    }

    # exp
    unless ( $payload->{exp} ) {
        return 'exp does not exist';
    }
    unless ( $payload->{exp} >= $now ) {
        return 'exp is not greater than current timestamp.';
    }

    # aud anz azp
    unless ( $payload->{aud} || $payload->{azp} ) {
        return 'aud does not exist';
    }
    unless ( $payload->{aud} eq $config->{client_id} ) {
        return 'aud does not match with this app\'s client_id.';
    }

    return undef;

}

sub _get_userinfo {
    my ( $class, $app, $access_token ) = @_;

    my $authenticator = _get_commenter_authenticator($app);

    my $userinfo_endpoint = $authenticator->{userinfo_endpoint};

    my $req = HTTP::Request->new( GET => $userinfo_endpoint );
    $req->header( Authorization => sprintf( q{Bearer %s}, $access_token ) );
    return LWP::UserAgent->new->request($req);
}

sub _uri_to_authorization_endpoint {
    my $class   = shift;
    my $app     = shift;
    my $blog    = shift;
    my $q       = $app->param;
    my $blog_id = $blog->id || '';

    my $static = $q->param('static') || '';

    my $state_session = MT->model('session')->new();
    $state_session->kind('OT');    # One time Token
    $state_session->id( MT::App::make_magic_token() );
    $state_session->start(time);
    $state_session->duration( time + 5 * 60 );
    $state_session->set( 'blog_id', $blog_id );
    $state_session->set( 'static',  $static );
    $state_session->save
        or return $app->error(
        $app->translate(
            "The login could not be confirmed because of a database error ([_1])",
            $state_session->errstr
        )
        );
    my $client = $class->_client( $app, $blog );
    $client->uri_to_redirect(
        redirect_uri => _create_return_url( $app, $blog ),
        scope        => $scope,
        state        => $state_session->id,
    );
}

sub _client {
    my $class = shift;
    my $app   = shift;
    my $blog  = shift;

    my $client = $class->_get_client_info( $app, $blog );
    return undef unless $client;
    my $authenticator = _get_commenter_authenticator($app);

    return OIDC::Lite::Client::WebServer->new(
        id               => $client->{client_id},
        secret           => $client->{client_secret},
        authorize_uri    => $authenticator->{authorization_endpoint},
        access_token_uri => $authenticator->{token_endpoint},
    );

}

sub set_commenter_properties {
    my $class = shift;
    my ( $commenter, $user_info ) = @_;
    my $nickname = $user_info->{name};
    my $sub      = $user_info->{sub};
    my $email    = $user_info->{email};

    $commenter->nickname( $nickname || $user_info->url );
    $commenter->email( $email || '' );
}

sub _create_return_url {
    my ( $app, $blog ) = @_;
    my $q = $app->param;

    my $path = MT->config->CGIPath;
    if ( $path =~ m!^/! ) {

        # relative path, prepend blog domain
        my ($blog_domain)
            = ( $blog ? $blog->archive_url : $app->base ) =~ m|(.+://[^/]+)|;
        $path = $blog_domain . $path;
    }
    $path .= '/' unless $path =~ m!/$!;
    $path .= MT->config->CommentScript;

    my $static = $q->param('static') || '';
    $static = MT::Util::encode_url($static)
        if $static =~ m/[^a-zA-Z0-9_.~%-]/;

    my $key = $q->param('key') || '';
    $key = MT::Util::encode_url($key)
        if $key =~ m/[^a-zA-Z0-9_.~%-]/;

    my $return_to = $path . '?__mode=handle_sign_in' . '&key=' . $key;

    return $return_to;

}

sub _get_commenter_authenticator {
    my $app = shift;
    return MT->commenter_authenticator( $app->param('key') );

}

1;
