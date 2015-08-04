# Movable Type (r) (C) 2001-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Asset::oEmbed::Flickr;

use strict;
use base qw( MT::Asset::oEmbed );

__PACKAGE__->install_properties(
    {   class_type    => 'flickr',
        provider_type => 'flickr',
        endpoint      => 'http://www.flickr.com/services/oembed/',
        api_endpoint  => 'https://api.flickr.com/services/rest/',
        column_defs   => {
            'html'               => 'vclob meta',
            'width'              => 'integer meta',
            'height'             => 'integer meta',
            'web_page'           => 'vclob meta',
            'web_page_short_url' => 'vclob meta',
            'license'            => 'vchar meta',
            'license_id'         => 'integer meta',
        },
        child_of => [ 'MT::Blog', 'MT::Website', ],
    }
);

sub domains {
    return [ qr/flickr\.com/i, qr/flic\.kr/i ];
}

sub class_label {
    MT->translate('Flickr');
}

sub class_label_plural {
    MT->translate('Flickr');
}

sub image_height {
    my $asset = shift;
    my $height = $asset->meta( 'height', @_ );
    return $height if $height || @_;

}

sub image_width {
    my $asset = shift;
    my $width = $asset->meta( 'width', @_ );
    return $width if $width || @_;

}

sub has_thumbnail {
    my $asset = shift;

    $asset->type eq 'photo'
        ? $asset->url
            ? 1
            : 0
        : $asset->provider_thumbnail_url ? 1
        :                                  0;
}

sub get_original_mod_time {
    my $asset = shift;
    my ($param) = @_;

    my $app    = MT->instance;
    my $plugin = $app->component("MTAssetoEmbed");
    my $blog   = $app->blog;

    return unless $blog;

    my $scope      = 'blog:' . $blog->id;
    my $config     = $plugin->get_config_hash($scope);
    my $token_data = $config->{flickr_token_data};

    return unless $token_data;

    my $request_method  = 'POST';
    my $consumer_key    = $token_data->{consumer_key};
    my $consumer_secret = $token_data->{consumer_secret};
    my $token           = $token_data->{access_token};
    my $token_secret    = $token_data->{access_token_secret};
    my $endpoint        = $asset->properties->{api_endpoint};

    my $photo_id = $asset->file_name;
    $photo_id =~ s/^(\d*).*$/$1/;

    my $request = Net::OAuth->request("protected resource")->new(
        request_url      => $endpoint,
        nonce            => int( rand( 2**31 - 999999 + 1 ) ) + 999999,
        consumer_key     => $consumer_key,
        consumer_secret  => $consumer_secret,
        timestamp        => time,
        signature_method => 'HMAC-SHA1',
        version          => 1.0,
        token            => $token,
        token_secret     => $token_secret,
        request_method   => $request_method,
        extra_params     => {
            nojsoncallback => 1,
            method         => 'flickr.photos.getInfo',
            photo_id       => $photo_id,
            format         => 'json',
        },
    );
    $request->sign;

    my $ua = MT->new_ua();
    $ua->ssl_opts( verify_hostname => 0 );
    my $http_hdr = HTTP::Headers->new(
        'Content-type' => 'application/x-www-form-urlencoded',
        'User-Agent'   => 'MovableType/' . MT->version_id
    );
    my $http_req
        = HTTP::Request->new( $request_method, $endpoint, $http_hdr,
        $request->to_post_body );
    my $res = $ua->request($http_req);

    if ( $res->is_success ) {
        require JSON;
        my $json = JSON::from_json( $res->content() );
        return $json->{photo}{dates}{lastupdate};
    }
    else {
        return undef;
    }
}

1;

