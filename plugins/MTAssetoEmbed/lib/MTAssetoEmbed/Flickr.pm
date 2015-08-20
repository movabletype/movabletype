# Movable Type (r) (C) 2006-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MTAssetoEmbed::Flickr;

use strict;
use warnings;

our @EXPORT = qw(get_token get_request);
use base qw(Exporter);

use MTAssetoEmbed;

sub get_token {
    my ( $app, $asset ) = @_;

    my $plugin = $app->component("MTAssetoEmbed");
    my $blog_id
        = $app->blog       ? $app->blog->id  : $asset
        && $asset->blog_id ? $asset->blog_id : 0;

    return undef unless $blog_id;

    my $scope       = 'blog:' . $blog_id;
    my $plugin_data = $plugin->get_config_obj($scope);
    my $token       = $plugin_data->data->{flickr_token_data};

    return undef unless $token;

    return $token;
}

sub get_request {
    my ( $app, $token, $method, $params ) = @_;

    $params->{method}         = $method;
    $params->{format}         = 'json';
    $params->{nojsoncallback} = 1;

    my $request = Net::OAuth->request("protected resource")->new(
        consumer_key     => $token->{consumer_key},
        consumer_secret  => $token->{consumer_secret},
        request_url      => 'https://api.flickr.com/services/rest/',
        request_method   => 'GET',
        signature_method => 'HMAC-SHA1',
        timestamp        => time,
        nonce            => int( rand( 2**31 - 999999 + 1 ) ) + 999999,
        token            => $token->{access_token},
        token_secret     => $token->{access_token_secret},
        extra_params     => $params,
    );
    $request->sign;
    my $ua  = new_ua();
    my $res = $ua->get( $request->to_url );

    return $res;
}

1;
