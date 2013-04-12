package GoogleAnalytics::OAuth2;

use strict;
use warnings;

our @EXPORT = qw(authorize_url get_token get_profiles);
use base qw(Exporter);

use GoogleAnalytics;
use HTTP::Request::Common;

sub authorize_url {
    my ( $app, $client_id ) = @_;

    my $uri = URI->new('https://accounts.google.com/o/oauth2/auth');
    $uri->query_form(
        response_type => 'code',
        client_id     => $client_id,
        redirect_uri  => 'urn:ietf:wg:oauth:2.0:oob',
        scope         => 'https://www.googleapis.com/auth/analytics.readonly',
    );

    $uri->as_string;
}

sub get_token {
    my ( $app, $ua, $client_id, $client_secret, $code ) = @_;

    my $res = $ua->request(
        POST(
            'https://accounts.google.com/o/oauth2/token',
            {   code          => $code,
                client_id     => $client_id,
                client_secret => $client_secret,
                redirect_uri  => 'urn:ietf:wg:oauth:2.0:oob',
                grant_type    => 'authorization_code',
            }
        )
    );

    return $app->error(
        translate(
            'Error getting token: [_1]: [_2]',
            GoogleAnalytics::extract_response_error($res)
        ),
        500
    ) unless $res->is_success;

    my $token_data = {
        start => time(),
        data =>
            MT::Util::from_json( Encode::decode( 'utf-8', $res->content ) ),
    };

    $app->session->set( 'ga_token_data', $token_data );

    $token_data;
}

sub refresh_access_token {
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
            'Error refreshing access token: [_1]: [_2]',
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
                'Error getting profiles: [_1]: [_2]',
                GoogleAnalytics::extract_response_error($res)
            ),
            500
        ) unless $res->is_success;

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

    if ( time() - $token_data->{start} > $token_data->{data}{expires_in} ) {
        my $new_token_data = refresh_access_token(
            $app, $app->new_ua,
            $token_data->{data}{refresh_token},
            @$data{qw(client_id client_secret)}
        ) or return undef;

        for my $k (qw(start)) {
            $token_data->{$k} = $new_token_data->{$k};
        }
        for my $k ( keys %{ $new_token_data->{data} } ) {
            $token_data->{data}{$k} = $new_token_data->{data}{$k};
        }
        $plugindata->data($data);
        $plugindata->save;
    }

    $token_data->{data};
}

sub plugin_data_pre_save {
    my ( $cb, $obj, $original ) = @_;
    my $app = MT->instance;

    return 1
        if !( $app->can('session')
        && ( my $session = $app->session )
        && $app->can('param')
        && lc( $app->param('plugin_sig') || '' ) eq plugin()->id );
    return 1 unless $app->blog;

    my $data = $obj->data;

    if ( $data->{profile_id}
        && ( my $token = $session->get('ga_token_data') ) )
    {
        $data->{token_data} = $token;
        $obj->data($data);
    }
    else {
        delete $data->{$_} for qw(profile_id profile_name token_data);
        $obj->data($data);
    }

    $session->set( 'ga_token_data', undef );

    1;
}

1;
