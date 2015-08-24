package GoogleOpenIDConnect::OIDC;

use strict;

use base qw( MT::Auth::OIDC );
use GoogleOpenIDConnect;
use OIDC::Lite::Client::WebServer;
use OIDC::Lite::Model::IDToken;
use JSON qw/encode_json decode_json/;
use MT::Util;

my $authorization_endpoint = 'https://accounts.google.com/o/oauth2/auth';
my $token_endpoint         = 'https://accounts.google.com/o/oauth2/token';
my $userinfo_endpoint      = 'https://www.googleapis.com/oauth2/v3/userinfo';

sub _login_form {
    my $class = shift;
    my $app   = shift;
    return $app->build_page('comment/auth_oidc.tmpl');
}

sub condition {
    my ( $blog, $reason ) = @_;
    return 1 unless $blog;
    my $plugin  = plugin();
    my $blog_id = $blog->id;
    my $app     = MT->instance;
    my $google_client_id
        = $plugin->get_config_value( 'client_id', "blog:$blog_id" );
    my $google_client_secret
        = $plugin->get_config_value( 'client_secret', "blog:$blog_id" );
    return 1 if $google_client_id && $google_client_secret;
    $$reason
        = '<a href="?__mode=cfg_web_services&amp;blog_id='
        . $blog->id . '">'
        . $plugin->translate('Set up GoogleOpenIDConnect') . '</a>';
    return 0;
}

sub commenter_auth_params {
    my ( $key, $blog_id, $entry_id, $static ) = @_;
    require MT::Util;
    if ( $static =~ m/^https?%3A%2F%2F/ ) {
        $static = MT::Util::decode_url($static);
    }
    my $params = {
        blog_id => $blog_id,
        static  => $static,
    };
    $params->{entry_id} = $entry_id if defined $entry_id;
    return $params;
}

sub _get_userinfo {
    my ( $class, $access_token ) = @_;

    my $req = HTTP::Request->new( GET => $userinfo_endpoint );
    $req->header( Authorization => sprintf( q{Bearer %s}, $access_token ) );
    return LWP::UserAgent->new->request($req);
}

sub _client {
    my $class        = shift;
    my $app          = shift;
    my $blog         = shift;
    my $config_scope = $blog ? ( 'blog:' . $blog->id ) : 'system';
    my $plugin       = plugin();
    my $config       = $plugin->get_config_hash($config_scope);

    my $google_client_id     = $config->{"client_id"};
    my $google_client_secret = $config->{"client_secret"};

    return OIDC::Lite::Client::WebServer->new(
        id               => $google_client_id,
        secret           => $google_client_secret,
        authorize_uri    => $authorization_endpoint,
        access_token_uri => $token_endpoint,
    );

}

sub set_commenter_properties {
    my $class = shift;
    my ( $commenter, $user_info ) = @_;
    my $nickname     = $user_info->{name};
    my $sub          = $user_info->{sub};
    my $email          = $user_info->{email};

    $commenter->nickname( $nickname || $user_info->url );
    $commenter->email( $email   || '' );
}
1;
