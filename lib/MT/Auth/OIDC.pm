# Movable Type (r) (C) 2001-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Auth::OIDC;
use strict;
use OIDC::Lite::Client::WebServer;
use OIDC::Lite::Model::IDToken;
use JSON qw/encode_json decode_json/;
use MT::Util;

my $authorization_endpoint = 'http://localhost:5001/authorize';
my $token_endpoint         = 'http://localhost:5001/token';
my $userinfo_endpoint      = 'http://localhost:5001/userinfo';
my $scope                  = 'openid email profile phone address';
my $client_id = 'sample_client_id';
my $client_scr = 'sample_client_secret';

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

    return $app->redirect( $class->_uri_to_authorizatin_endpoint($app,$blog) );

}

sub handle_sign_in {
    my $class = shift;
    my ( $app, $auth_type ) = @_;
    my $q = $app->{query};

    my $state = decode_json( MT::Util::decode_url( $q->param('state') ) );
    $app->param( 'blog_id', $state->{blog_id} );
    $app->param( 'static',  $state->{static} );

    my $blog  = $app->model('blog')->load( $state->{blog_id} );

    my $state_session = $state->{onetimetoken};
    if (my $state_session = MT::Session::get_unexpired_value(
            5 * 60, { id => $state_session, kind => 'OT' }
        )
        )
    {
        $state_session->remove();
    }
    else {
        return $app->error(
            'The state parameter is missing or not matched with session.');
    }

    # code
    my $code = $q->param('code');
    unless ($code) {

        # invalid state
        return $app->error('The code parameter is missing.');
    }

    my $client = $class->_client($app,$blog);

    # get_access_token
    my $token = $client->get_access_token(
        code         => $code,
        redirect_uri => _create_return_url($app,$blog),
    );
    my $res          = $client->last_response;
    my $request_body = $res->request->content;
    $request_body =~ s/client_secret=[^\&]+/client_secret=(hidden)/;

    unless ($token) {
        return $app->error('Failed to get access token response');
    }
    my $info = {
        token_request  => $request_body,
        token_response => $res->content,
    };

    # ID Token validation
    my $id_token = OIDC::Lite::Model::IDToken->load( $token->id_token );
    $info->{'id_token'} = {
        header  => encode_json( $id_token->header ),
        payload => encode_json( $id_token->payload ),
        string  => $id_token->token_string,
    };

    # get_user_info
    my $userinfo_res = $class->_get_userinfo( $token->access_token );
    unless ( $userinfo_res->is_success ) {
        return $app->error('Failed to get userinfo response');
    }
    my $user_info    = $userinfo_res->content;
    my $user_info    = decode_json($user_info);
    my $nickname     = $user_info->{name};
    my $sub          = $user_info->{sub};
    my $author_class = $app->model('author');
    my $cmntr        = $author_class->load(
        {   name      => $sub,
            type      => $author_class->COMMENTER(),
            auth_type => $auth_type,
        }
    );
    if ( not $cmntr ) {
        $cmntr = $app->make_commenter(
            name        => $sub,
            nickname    => $nickname,
            auth_type   => $auth_type,
            external_id => $sub,
            url         => $user_info->{profile},
        );
    }

    # __get_userpic($cmntr);

    my $session = $app->make_commenter_session($cmntr);
    unless ($session) {
        $app->error( $app->errstr()
                || $app->translate("Could not save the session") );
        return 0;
    }

    return ( $cmntr, $session );
}

sub _get_userinfo {
    my ( $class, $access_token ) = @_;

    my $req = HTTP::Request->new( GET => $userinfo_endpoint );
    $req->header( Authorization => sprintf( q{Bearer %s}, $access_token ) );
    return LWP::UserAgent->new->request($req);
}

sub _uri_to_authorizatin_endpoint {
    my $class = shift;
    my $app = shift;
    my $blog = shift;
    my $q     = $app->param;
    my $blog_id = $blog->id || '';

    my $static = $q->param('static') || '';
    $static = MT::Util::encode_url($static)
        if $static =~ m/[^a-zA-Z0-9_.~%-]/;

    my $state_session = MT->model('session')->new();
    $state_session->kind('OT');    # One time Token
    $state_session->id( MT::App::make_magic_token() );
    $state_session->start(time);
    $state_session->duration( time + 5 * 60 );
    $state_session->save
        or return $app->error(
        $app->translate(
            "The login could not be confirmed because of a database error ([_1])",
            $state_session->errstr
        )
        );

    my $state = {
        'blog_id'      => $blog_id,
        'static'       => $static,
        'onetimetoken' => $state_session->id
    };
    my $state_string = encode_json($state);

    my $client = $class->_client($app,$blog);
    $client->uri_to_redirect(
        redirect_uri => _create_return_url( $app, $blog ),
        scope        => $scope,
        state        => $state_string,
        extra => { access_type => q{offline}, },
    );
}

sub _client {
    my $class   = shift;
    my $app = shift;
    my $blog = shift;
    my $config_scope  = $blog ? ( 'blog:' . $blog->id ) : 'system';
    my $plugin  = plugin();
    my $config = $plugin->get_config_hash($config_scope);

    my $google_client_id  = $config->{"client_id"};
    my $google_client_secret = $config->{"client_secret"};


    return OIDC::Lite::Client::WebServer->new(
        id               => $google_client_id,
        secret           => $google_client_secret,
        authorize_uri    => $authorization_endpoint,
        access_token_uri => $token_endpoint,
    );

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

    my $blog_id = $blog->id || '';

    my $static = $q->param('static') || '';
    $static = MT::Util::encode_url($static)
        if $static =~ m/[^a-zA-Z0-9_.~%-]/;

    my $key = $q->param('key') || '';
    $key = MT::Util::encode_url($key)
        if $key =~ m/[^a-zA-Z0-9_.~%-]/;

    my $entry_id = $q->param('entry_id') || '';
    $entry_id =~ s/\D//g;

    my $return_to = $path . '?__mode=handle_sign_in' . '&key=' . $key;

    $return_to .= '&entry_id=' . $entry_id
        if $entry_id;

    return $return_to;

}

1;
