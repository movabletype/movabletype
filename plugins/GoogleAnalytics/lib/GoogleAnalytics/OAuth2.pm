# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package GoogleAnalytics::OAuth2;

use strict;
use warnings;

our @EXPORT = qw(authorize_url get_token get_profiles effective_token);
use base qw(Exporter);

use GoogleAnalytics;
use HTTP::Request::Common;

sub authorize_url {
    my ( $app, $client_id, $redirect_uri ) = @_;

    my $uri = URI->new('https://accounts.google.com/o/oauth2/auth');
    $uri->query_form(
        response_type => 'code',
        client_id     => $client_id,
        redirect_uri  => $redirect_uri,
        scope         => 'https://www.googleapis.com/auth/analytics.readonly',
        access_type   => 'offline',
        approval_prompt => 'force',
    );

    $uri->as_string;
}

sub get_token {
    my ( $app, $ua, $client_id, $client_secret, $redirect_uri, $code ) = @_;

    my $res = $ua->request(
        POST(
            'https://www.googleapis.com/oauth2/v4/token',
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

    my $username = get_username( $app, $ua, $token_data )
        or return;

    $token_data->{username} = $username;

    $token_data;
}

sub refresh_access_token {
    my ( $app, $ua, $refresh_token, $client_id, $client_secret ) = @_;

    my $res = $ua->request(
        POST(
            'https://www.googleapis.com/oauth2/v4/token',
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
            GoogleAnalytics::extract_response_error($res)
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

sub get_username {
    my ( $app, $ua, $token_data ) = @_;

    my $uri = URI->new(
        'https://www.googleapis.com/analytics/v3/management/accounts');
    $uri->query_form(
        access_token  => $token_data->{data}{access_token},
        'max-results' => 1,
        'start-index' => 1,
    );

    my $res = $ua->request( GET($uri) );

    return $app->error(
        translate(
            'An error occurred when getting accounts: [_1]: [_2]',
            GoogleAnalytics::extract_response_error($res)
        ),
        500
    ) unless $res->is_success;

    my $data
        = MT::Util::from_json( Encode::decode( 'utf-8', $res->content ) );

    return $data->{username};
}

sub get_profiles {
    my ( $app, $ua, $token_data ) = @_;

    my @list        = ();
    my $max_results = 1000;
    my $start_index = 1;

    while (1) {
        my $uri
            = URI->new(
            'https://www.googleapis.com/analytics/v3/management/accounts/~all/webproperties/~all/profiles'
            );
        $uri->query_form(
            access_token  => $token_data->{data}{access_token},
            'max-results' => $max_results,
            'start-index' => $start_index,
        );

        my $res = $ua->request( GET($uri) );

        return $app->error(
            translate(
                'An error occurred when getting profiles: [_1]: [_2]',
                GoogleAnalytics::extract_response_error($res)
            ),
            500
        ) unless $res->is_success;

        return $app->error(
            translate(
                'An error occurred when getting profiles: [_1]: [_2]',
                'Client-Aborted:' . $res->header("Client-Aborted"),
                500
            ),
            500
        ) if $res->header("Client-Aborted");

        my $data
            = MT::Util::from_json( Encode::decode( 'utf-8', $res->content ) );

        my @items = @{ $data->{items} }
            or last;
        push @list, @items;

        last if ( scalar(@list) >= $data->{totalResults} );

        $start_index += scalar(@items);
    }

    \@list;
}

sub effective_token {
    my ( $app, $plugindata ) = @_;

    return undef unless $plugindata;

    my $data       = $plugindata->data;
    my $token_data = $data->{token_data};

    if ( $token_data
        && ( time() - $token_data->{start} + 10 )
        > $token_data->{data}{expires_in} )
    {
        my $new_token_data = refresh_access_token(
            $app, new_ua(),
            $token_data->{data}{refresh_token},
            @$data{qw(client_id client_secret)}
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

sub plugin_data_pre_save {
    my ( $cb, $obj, $original ) = @_;
    my $app = MT->instance;

    # Should not save GoogleAnalytics's plugindata object at cfg_plugins
    return 0
        if ( $app->can('param')
        && lc( $app->param('plugin_sig') || '' ) eq plugin()->id );

    1;
}

1;

=head1 NAME

GoogleAnalytics::OAuth2 - OAuth2 request methods for Google Analytics.

=head1 METHODS

=head2 GoogleAnalytics::OAuth2::authorize_url($app, $client_id, $redirect_uri)

    Returns authorization URL embedded with C<$client_id> and C<$redirect_uri>.

=head2 GoogleAnalytics::OAuth2::get_token($app, $ua, $client_id, $client_secret, $redirect_uri, $code)

    Try to get new token.
    Returns new token if succeeded.

=head2 GoogleAnalytics::OAuth2::get_profiles($app, $ua, $token_data)

    Try to get profiles by useing C<$token_data>.
    Returns all the profiles which are related to a user of C<$token_data>.

=head2 GoogleAnalytics::OAuth2::effective_token($app, $plugindata)
    Extract an effective access token from C<$plugindata>.
    Update an access token by a refresh token if current access token was expired.
    Returns an access effective token if it can.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
