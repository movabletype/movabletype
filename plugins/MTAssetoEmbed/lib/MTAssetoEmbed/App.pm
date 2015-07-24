# Movable Type (r) (C) 2006-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MTAssetoEmbed::App;

use strict;
use warnings;

use MTAssetoEmbed;
use MTAssetoEmbed::OAuth2;

sub _is_youtube_effective_plugindata {
    my ( $app, $plugindata ) = @_;

    my $result
        = $plugindata
        && $plugindata->data->{youtube_client_id}
        && youtube_effective_token( $app, $plugindata );
    $app->error(undef);

    $result;
}

sub _get_session_token_data_key {
    my ($app) = @_;
    my $blog = $app->blog;
    'youtube_token_data_' . ( $blog ? $blog->id : 'system' );
}

sub _get_session_token_data {
    my ($app) = @_;
    $app->session->get( _get_session_token_data_key(@_) );
}

sub _set_session_token_data {
    my ( $app, $data ) = @_;
    $app->session->set( _get_session_token_data_key(@_), $data );
}

sub _clear_session_token_data {
    my ($app) = @_;
    $app->session->set( _get_session_token_data_key(@_), undef );
}

sub config_tmpl {
    my $app    = MT->instance;
    my $user   = $app->user;
    my $plugin = plugin();
    my $blog   = $app->blog;

    return unless $blog;

    my $scope  = 'blog:' . $blog->id;
    my $config = $plugin->get_config_hash($scope);
    my $configured
        = _is_youtube_effective_plugindata( $app, $plugin->get_config_obj($scope) );

    $plugin->load_tmpl(
        'web_service_config.tmpl',
        {
            blog_id => $blog ? $blog->id : 0,
            youtube_redirect_uri => $app->uri( mode => 'youtube_oauth2callback' ),
            youtube_authorize_url =>
                youtube_authorize_url( $app, '__client_id__', '__redirect_uri__' ),
            ( map { ( "$_" => $config->{$_} || '' ) } keys(%$config) ),
            youtube_dialog_url => $app->uri(
                mode => 'youtube_get_token_data',
                ( $blog ? ( args => { blog_id => $app->blog->id, } ) : () ),
            ),
            (   $configured
                ? ( youtube_configured_client_id     => $config->{youtube_client_id},
                    youtube_configured_client_secret => $config->{youtube_client_secret},
                    )
                : ()
            ),
        }
    )->build;
}

sub save_config {
    my $eh = shift;
    my ( $app, $obj ) = @_;
    my $plugin = plugin();

    return unless $obj;

    my $scope = 'blog:' . $obj->id;
    my $config = $plugin->get_config_hash($scope);

    for my $k (
        qw(
        flickr_consumer_key
        flickr_consumer_secret
        youtube_client_id
        youtube_client_secret
        youtube_code
        )
        )
    {
        $config->{$k} = $app->param($k);
    }

    my $token = _get_session_token_data($app);
    if (   $token
        && $token->{client_id} eq ( $config->{youtube_client_id} || '' ) )
    {
        $config->{youtube_token_data} = $token;
    }

    if ( ( !$config->{youtube_client_id} && !$config->{youtube_parent_client_id} )
        || !$config->{youtube_profile_id} )
    {
        delete @$config{
            qw(youtube_token_data youtube_profile_id)
        };
    }

    $plugin->save_config( $config, $scope );

    _clear_session_token_data($app);
}

sub youtube_oauth2callback {
    my $app = shift;

    my $params = { code => scalar $app->param('code'), };

    plugin()->load_tmpl( 'youtube_oauth2callback.tmpl', $params );
}

sub _render_api_error {
    my ( $app, $params ) = @_;
    $params ||= {};

    plugin()->load_tmpl( 'api_error.tmpl', $params );
}

sub youtube_get_token_data {
    my $app = shift;

    my $client_id = $app->param('client_id')
        or
        return $app->error( translate('You did not specify a client ID.') );

    my $client_secret = $app->param('client_secret');

    my $code = $app->param('code')
        or return $app->error( translate('You did not specify a code.') );

    my $ua = new_ua();
    my $token_data
        = youtube_get_token( $app, $ua, $client_id, $client_secret,
        scalar $app->param('redirect_uri'), $code )
        or return _render_api_error( $app, { error => $app->errstr } );

    _set_session_token_data( $app, $token_data );

    my $params = {
        youtube_code => scalar $app->param('code'),
        youtube_client_id => scalar $app->param('client_id'),
        youtube_client_secret => scalar $app->param('client_secret'),
    };

    plugin()->load_tmpl( 'youtube_get_token_data.tmpl', $params );
}

1;
