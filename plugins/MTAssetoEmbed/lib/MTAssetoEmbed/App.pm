# Movable Type (r) (C) 2006-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MTAssetoEmbed::App;

use strict;
use warnings;

use URI;
use Net::OAuth;
$Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0A;
use MTAssetoEmbed;
use MTAssetoEmbed::OAuth2;
use MTAssetoEmbed::Flickr;

sub post_init {
    my ( $cb, $app ) = @_;
    my $oembed_classes = $app->registry('oembed_classes');
    my $component;
    my $oembed_class;
    foreach my $key ( keys %$oembed_classes ) {
        if ( $oembed_classes->{$key} =~ m!^\$! ) {
            $oembed_class = $oembed_classes->{$key};
            if ( $oembed_class =~ s/^\$(\w+)::// ) {
                $component = $1;
            }
        }
        eval "require $oembed_class";
        if ($@) {
            warn $@;
        }
    }
}

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
    my ( $app, $prefix ) = @_;
    my $blog = $app->blog;
    $prefix . '_token_data_' . ( $blog ? $blog->id : 'system' );
}

sub _get_session_token_data {
    my ($app) = @_;
    $app->session->get( _get_session_token_data_key(@_) );
}

sub _set_session_token_data {
    my ( $app, $prefix, $data ) = @_;
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

    my $scope             = 'blog:' . $blog->id;
    my $config            = $plugin->get_config_hash($scope);
    my $flickr_configured = $config->{flickr_token_data} ? 1 : 0;
    my $youtube_configured
        = _is_youtube_effective_plugindata( $app,
        $plugin->get_config_obj($scope) );

    $plugin->load_tmpl(
        'web_service_config.tmpl',
        {   ( map { ( "$_" => $config->{$_} || '' ) } keys(%$config) ),
            blog_id => $blog ? $blog->id : 0,
            flickr_redirect_uri =>
                $app->uri( mode => 'flickr_oauth_callback' ),
            flickr_get_token_url => $app->uri(
                mode => 'flickr_oauth_success',
                ( $blog ? ( args => { blog_id => $app->blog->id, } ) : () ),
            ),
            (   $flickr_configured
                ? ( flickr_configured_consumer_key =>
                        $config->{flickr_consumer_key},
                    flickr_configured_consumer_secret =>
                        $config->{flickr_consumer_secret},
                    )
                : ()
            ),
            youtube_redirect_uri =>
                $app->uri( mode => 'youtube_oauth2callback' ),
            youtube_authorize_url => youtube_authorize_url(
                $app, '__client_id__', '__redirect_uri__'
            ),
            youtube_dialog_url => $app->uri(
                mode => 'youtube_get_token_data',
                ( $blog ? ( args => { blog_id => $app->blog->id, } ) : () ),
            ),
            (   $youtube_configured
                ? ( youtube_configured_client_id =>
                        $config->{youtube_client_id},
                    youtube_configured_client_secret =>
                        $config->{youtube_client_secret},
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

    my $scope  = 'blog:' . $obj->id;
    my $config = $plugin->get_config_hash($scope);

    for my $k (
        qw(
        flickr_consumer_key
        flickr_consumer_secret
        flickr_configured_consumer_key
        flickr_configured_consumer_secret
        youtube_client_id
        youtube_client_secret
        youtube_code
        )
        )
    {
        $config->{$k} = $app->param($k);
    }

    # Flickr

    my $flickr_token = _get_session_token_data( $app, 'flickr' );
    if (   $flickr_token
        && $flickr_token->{consumer_key} eq
        ( $config->{flickr_consumer_key} || '' ) )
    {
        $config->{flickr_token_data} = $flickr_token;
    }

    if (   !$config->{flickr_consumer_key}
        || !$config->{flickr_consumer_secret}
        || ( $config->{flickr_consumer_key} ne
            $config->{flickr_configured_consumer_key} )
        || ( $config->{flickr_consumer_secret} ne
            $config->{flickr_configured_consumer_secret} )
        )
    {
        delete @$config{qw(flickr_token_data)};
    }

    # YouTube

    my $youtube_token = _get_session_token_data( $app, 'youtube' );
    if (   $youtube_token
        && $youtube_token->{client_id} eq
        ( $config->{youtube_client_id} || '' ) )
    {
        $config->{youtube_token_data} = $youtube_token;
    }

    if ((   !$config->{youtube_client_id} && !$config->{youtube_client_secret}
        )
        || !$config->{youtube_code}
        )
    {
        delete @$config{qw(youtube_token_data youtube_code)};
    }

    $plugin->save_config( $config, $scope );

    _clear_session_token_data( $app, 'flickr' );
    _clear_session_token_data( $app, 'youtube' );
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

    _set_session_token_data( $app, 'youtube', $token_data );

    my $params = {
        youtube_code          => scalar $app->param('code'),
        youtube_client_id     => scalar $app->param('client_id'),
        youtube_client_secret => scalar $app->param('client_secret'),
    };

    plugin()->load_tmpl( 'youtube_get_token_data.tmpl', $params );
}

sub flickr_oauth_request {
    my $app = shift;

    my $request_token_url
        = 'https://www.flickr.com/services/oauth/request_token';
    my $authorize_url   = 'https://www.flickr.com/services/oauth/authorize';
    my $request_method  = 'GET';
    my $consumer_key    = $app->param('consumer_key');
    my $consumer_secret = $app->param('consumer_secret');

    my $request = Net::OAuth->request("request token")->new(
        consumer_key     => $consumer_key,
        consumer_secret  => $consumer_secret,
        request_url      => $request_token_url,
        request_method   => $request_method,
        signature_method => 'HMAC-SHA1',
        timestamp        => time,
        nonce            => int( rand( 2**31 - 999999 + 1 ) ) + 999999,
        callback => $app->base . $app->uri( mode => 'flickr_oauth_callback' ),
    );
    $request->sign;
    my $ua = new_ua();
    #$ua->ssl_opts( verify_hostname => 0 );
    my $http_hdr = HTTP::Headers->new(
        'Authorization' => $request->to_authorization_header );
    my $http_req = HTTP::Request->new( $request_method, $request_token_url,
        $http_hdr );
    my $res                  = $ua->request($http_req);
    my $request_token        = '';
    my $request_token_secret = '';

    if ( $res->is_success ) {
        my $response = Net::OAuth->response('request token')
            ->from_post_body( $res->content );
        if ( defined $response->token ) {
            $request_token        = $response->token;
            $request_token_secret = $response->token_secret;
        }
    }
    else {
        return $app->error(
            translate( 'Flickr authorization error: ' . $res->status_line ) );
    }

    _set_session_token_data( $app, 'flickr',
        { request_token_secret => $request_token_secret } );

    return $app->redirect(
        $authorize_url . '?oauth_token=' . $request_token . '&perms=read' );
}

sub flickr_oauth_callback {
    my $app = shift;

    my $params = {
        oauth_token    => scalar $app->param('oauth_token'),
        oauth_verifier => scalar $app->param('oauth_verifier'),
    };

    plugin()->load_tmpl( 'flickr_oauth_callback.tmpl', $params );
}

sub flickr_oauth_success {
    my $app = shift;

    my $access_token_url
        = 'https://www.flickr.com/services/oauth/access_token';
    my $request_method  = 'GET';
    my $consumer_key    = $app->param('consumer_key');
    my $consumer_secret = $app->param('consumer_secret');
    my $oauth_token     = $app->param('oauth_token');
    my $oauth_verifier  = $app->param('oauth_verifier');

    my $flickr_token = _get_session_token_data( $app, 'flickr' );
    my $request_token_secret
        = $flickr_token && $flickr_token->{request_token_secret}
        ? $flickr_token->{request_token_secret}
        : '';

    my $request = Net::OAuth->request("access token")->new(
        consumer_key     => $consumer_key,
        consumer_secret  => $consumer_secret,
        request_url      => $access_token_url,
        request_method   => $request_method,
        signature_method => 'HMAC-SHA1',
        timestamp        => time,
        nonce            => int( rand( 2**31 - 999999 + 1 ) ) + 999999,
        token            => $oauth_token,
        verifier         => $oauth_verifier,
        token_secret     => $request_token_secret,
    );
    $request->sign;
    my $ua = new_ua();
    #$ua->ssl_opts( verify_hostname => 0 );
    my $http_hdr = HTTP::Headers->new(
        'Authorization' => $request->to_authorization_header );
    my $http_req
        = HTTP::Request->new( $request_method, $access_token_url, $http_hdr );
    my $res        = $ua->request($http_req);
    my $token_data = {};

    if ( $res->is_success ) {
        my $response = Net::OAuth->response('access token')
            ->from_post_body( $res->content );
        $token_data->{consumer_key}        = $consumer_key;
        $token_data->{consumer_secret}     = $consumer_secret;
        $token_data->{access_token}        = $response->token;
        $token_data->{access_token_secret} = $response->token_secret;
        $token_data->{user_nsid} = $response->extra_params->{user_nsid};
    }
    else {
        return $app->error(
            translate( 'Flickr authorization error: ' . $res->status_line ) );
    }

    _set_session_token_data( $app, 'flickr', $token_data );

    my $params = {
        consumer_key    => $app->param('consumer_key'),
        consumer_secret => $app->param('consumer_secret'),
        oauth_token     => $app->param('oauth_token'),
        oauth_verifier  => $app->param('oauth_verifier'),
    };

    plugin()->load_tmpl( 'flickr_oauth_finish.tmpl', $params );
}

sub start_flickr {
    my ( $app, $param ) = @_;
    my $q      = $app->param;
    my $plugin = $app->component("MTAssetoEmbed");
    my $cfg    = $app->config;

    my $token = get_token($app);
    return $app->error( translate('Token data is not registered.') )
        unless $token;

    my $res = get_request( $app, $token, 'flickr.photosets.getList',
        { user_id => $token->{user_nsid}, } );

    if ( $res->is_success ) {
        my $data
            = MT::Util::from_json( Encode::decode( 'utf-8', $res->content ) );
        my $photosets = $data->{photosets}{photoset};
        my @photosets;
        foreach my $photoset (@$photosets) {
            push @photosets,
                {
                id    => $photoset->{id},
                title => $photoset->{title}{_content},
                };
        }
        $param->{photosets} = \@photosets;
    }
    else {
        return $app->error(
            translate( 'Flickr getSizes error: ' . $res->status_line ) );
    }

    $app->build_page( $plugin->load_tmpl('start_flickr.tmpl'), $param );
}

sub get_flickr_list {
    my ($app)  = @_;
    my $q      = $app->param;
    my $plugin = $app->component("MTAssetoEmbed");
    my $cfg    = $app->config;
    my $blog   = $app->blog;
    my $param  = {};

    my $token = get_token($app);
    return $app->error( translate('Token data is not registered.') )
        unless $token;

    my $method;
    my $extra_params = {
        privacy_filter => 1,
        per_page       => 10,
        page           => $q->param('page') || 1,
    };
    if ( $q->param('method') eq 'search' ) {
        $method = 'flickr.photos.search';
        $extra_params->{user_id} = $token->{user_nsid};
        $extra_params->{text} = $q->param('param') if $q->param('param');
        $extra_params->{'sort'} = 'date-posted-desc';
    }
    else {
        $method                      = 'flickr.photosets.getPhotos';
        $extra_params->{user_id}     = $token->{user_nsid};
        $extra_params->{photoset_id} = $q->param('param');
    }

    my $res = get_request( $app, $token, $method, $extra_params );

    if ( $res->is_success ) {
        my $data
            = MT::Util::from_json( Encode::decode( 'utf-8', $res->content ) );
        my $key = $q->param('method') eq 'search' ? 'photos' : 'photoset';
        my $photos = $data->{$key}{photo};
        if ($photos) {
            my @photos = map {
                my $hash = { title => $_->{title}, id => $_->{id} };
                $hash;
            } @$photos;
            $param->{photos} = \@photos;
            $param->{page}   = $data->{$key}{page};
            $param->{pages}  = $data->{$key}{pages};
        }
    }
    else {
        return $app->error(
            translate( 'Flickr getSizes error: ' . $res->status_line ) );
    }

    $param->{success} = 1;
    return $app->json_result($param);
}

sub get_flickr_thumbnail {
    my ($app)  = @_;
    my $q      = $app->param;
    my $plugin = $app->component("MTAssetoEmbed");
    my $cfg    = $app->config;
    my $blog   = $app->blog;
    my $param  = {};

    my $token = get_token($app);
    return $app->error( translate('Token data is not registered.') )
        unless $token;

    my $res
        = get_request( $app, $token, 'flickr.photos.getSizes',
        { photo_id => $q->param("photo_id"), },
        );
    if ( $res->is_success ) {
        my $data
            = MT::Util::from_json( Encode::decode( 'utf-8', $res->content ) );
        my $sizes = $data->{sizes}{size};
        foreach my $size (@$sizes) {
            if ( $size->{label} eq 'Large Square' ) {
                $param->{thumbnail} = $size->{source};
            }
        }
    }
    else {
        return $app->error(
            translate( 'Flickr search error: ' . $res->status_line ) );
    }

    $param->{success} = 1;
    return $app->json_result($param);
}

sub start_youtube {
    my ( $app, $param ) = @_;
    my $q      = $app->param;
    my $plugin = $app->component("MTAssetoEmbed");
    my $cfg    = $app->config;

    $app->build_page( $plugin->load_tmpl('start_youtube.tmpl'), $param );
}

sub get_youtube_list {
    my ($app)  = @_;
    my $q      = $app->param;
    my $plugin = $app->component("MTAssetoEmbed");
    my $cfg    = $app->config;
    my $blog   = $app->blog;
    my $param  = {};

    my $token = get_token_from_plugindata($app);

    return unless $token;

    my $uri = URI->new('https://www.googleapis.com/youtube/v3/search');
    $uri->query_form(
        'access_token' => $token->{data}{access_token},
        'forMine'      => 'true',
        'type'         => 'video',
        'part'         => 'id,snippet',
        'pageToken'    => $q->param('page_token') || '',
        'q'            => $q->param('text') || '',
    );

    my $ua  = new_ua();
    my $req = HTTP::Request->new( 'GET', $uri );
    my $res = $ua->request($req);

    if ( $res->is_success ) {
        my $data
            = MT::Util::from_json( Encode::decode( 'utf-8', $res->content ) );
        my @videos;
        foreach my $item ( @{ $data->{items} } ) {
            my $tumbnail = $item->{snippet}{thumbnails}{default}{url};
            push @videos,
                {
                title     => $item->{snippet}{title},
                id        => $item->{id}{videoId},
                thumbnail => $item->{snippet}{thumbnails}{default}{url},
                };
        }
        $param->{videos}          = \@videos;
        $param->{next_page_token} = $data->{nextPageToken}
            if $data->{nextPageToken};
        $param->{prev_page_token} = $data->{prevPageToken}
            if $data->{prevPageToken};
    }

    return $app->json_result($param);
}

1;
