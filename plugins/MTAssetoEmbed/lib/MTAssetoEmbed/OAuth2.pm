# Movable Type (r) (C) 2006-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MTAssetoEmbed::OAuth2;

use strict;
use warnings;

our @EXPORT
    = qw(youtube_authorize_url youtube_get_token youtube_effective_token get_token_from_plugindata);
use base qw(Exporter);

use MTAssetoEmbed;
use HTTP::Request::Common;

sub youtube_authorize_url {
    my ( $app, $client_id, $redirect_uri ) = @_;

    my $uri = URI->new('https://accounts.google.com/o/oauth2/auth');
    $uri->query_form(
        response_type   => 'code',
        client_id       => $client_id,
        redirect_uri    => $redirect_uri,
        scope           => 'https://www.googleapis.com/auth/youtube.readonly',
        access_type     => 'offline',
        approval_prompt => 'force',
    );

    $uri->as_string;
}

sub youtube_get_token {
    my ( $app, $ua, $client_id, $client_secret, $redirect_uri, $code ) = @_;

    my $res = $ua->request(
        POST(
            'https://accounts.google.com/o/oauth2/token',
            {   code          => $code,
                client_id     => $client_id,
                client_secret => $client_secret,
                redirect_uri  => $redirect_uri,
                grant_type    => 'authorization_code',
            }
        )
    );

    return $app->error(
        translate(
            'An error occurred when getting token: [_1]: [_2]',
            GoogleAnalytics::extract_response_error($res)
        ),
        500
    ) unless $res->is_success;

    my $token_data = {
        start     => time(),
        client_id => $client_id,
        data =>
            MT::Util::from_json( Encode::decode( 'utf-8', $res->content ) ),
    };

    $token_data;
}

sub youtube_refresh_access_token {
    my ( $app, $ua, $refresh_token, $client_id, $client_secret ) = @_;

    my $res = $ua->request(
        POST(
            'https://accounts.google.com/o/oauth2/token',
            {   refresh_token => $refresh_token,
                client_id     => $client_id,
                client_secret => $client_secret,
                grant_type    => 'refresh_token',
            }
        )
    );

    return $app->error(
        translate(
            'An error occurred when refreshing access token: [_1]: [_2]',
            MTAssetoEmbed::extract_response_error($res)
        ),
        500
    ) unless $res->is_success;

    my $token_data = {
        start => time(),
        data =>
            MT::Util::from_json( Encode::decode( 'utf-8', $res->content ) ),
    };

    $token_data;
}

sub youtube_effective_token {
    my ( $app, $plugindata ) = @_;

    return undef unless $plugindata;

    my $data       = $plugindata->data;
    my $token_data = $data->{youtube_token_data};

    if ( $token_data
        && ( time() - $token_data->{start} + 10 )
        > $token_data->{data}{expires_in} )
    {
        my $new_token_data = youtube_refresh_access_token(
            $app, new_ua(),
            $token_data->{data}{refresh_token},
            @$data{qw(youtube_client_id youtube_client_secret)}
        ) or return undef;

        for my $k (qw(start)) {
            $token_data->{$k} = $new_token_data->{$k};
        }
        for my $k ( keys %{ $new_token_data->{data} } ) {
            $token_data->{data}{$k} = $new_token_data->{data}{$k};
        }

        my $plugindata_to_update
            = $app->model('plugindata')->load( { id => $plugindata->id } );
        my $data_to_update = $plugindata_to_update->data;
        $data_to_update->{token_data} = $token_data;
        $plugindata_to_update->data($data_to_update);
        $plugindata_to_update->save;
    }

    $token_data;
}

sub get_token_from_plugindata {
    my ( $app, $asset ) = @_;

    my $plugin = $app->component("MTAssetoEmbed");
    my $blog_id = $app->blog ? $app->blog->id : $asset
        && $asset->blog_id ? $asset->blog_id : 0;

    return undef unless $blog_id;

    my $scope       = 'blog:' . $blog_id;
    my $plugin_data = $plugin->get_config_obj($scope);
    my $token       = MTAssetoEmbed::OAuth2::youtube_effective_token( $app,
        $plugin_data );

    return undef unless $token;

    return $token;
}

1;
