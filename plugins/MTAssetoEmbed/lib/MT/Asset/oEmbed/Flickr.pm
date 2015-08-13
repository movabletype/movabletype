# Movable Type (r) (C) 2001-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Asset::oEmbed::Flickr;

use strict;
use base qw( MT::Asset::oEmbed );

use MTAssetoEmbed;

__PACKAGE__->install_properties(
    {   class_type  => 'flickr',
        endpoint    => 'http://www.flickr.com/services/oembed/',
        url_schemes => [
            'http://*.flickr.com/photos/*', 'http://flic.kr/p/*',
            'http://*.staticflickr.com/*'
        ],
        column_defs => {
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

sub get_file_size {
    my $asset = shift;

    my $url = $asset->file_url;

    return unless $url;

    my $ua = new_ua();
    $ua->ssl_opts( verify_hostname => 0 );

    my $req = HTTP::Request->new( 'GET', $url );
    my $res = $ua->request($req);

    if ( $res->is_success ) {
        return $res->headers->content_length
            if $res->headers && $res->headers->content_length;
        return 0;
    }
    else {
        return 0;
    }
}

sub get_oembed {
    my $asset = shift;
    my ($url) = @_;

    $asset->SUPER::get_oembed(@_);

    $asset->url( $asset->web_page );

    return $asset;
}

sub get_token_data {
    my $asset = shift;

    my $app    = MT->instance;
    my $plugin = plugin();
    my $blog_id
        = $asset->blog_id ? $asset->blog_id : $app->blog ? $app->blog->id : 0;

    return undef unless $blog_id;

    my $scope       = 'blog:' . $blog_id;
    my $plugin_data = $plugin->get_config_obj($scope);
    my $token       = $plugin_data->data->{flickr_token_data};

    return undef unless $token;

    return $token;
}

sub get_file_url {
    my $asset = shift;
    my ($json) = @_;

    return $asset->get_original_source( $json->{url} );
}

sub _cache_key {
    return join ':', 'flickr', 'getSizes', $_[0];
}

sub get_original_source {
    my $asset = shift;
    my ($url) = @_;

    my $original_sizes = $asset->get_original_sizes(@_);

    return $original_sizes->{source};
}

sub get_original_sizes {
    my $asset = shift;
    my ($url) = @_;

    my $filename
        = $url =~ /.*\/(.*)/
        ? $1
        : $url;
    my ($photo_id) = split '_', $filename;

    my $cache_key = _cache_key($photo_id);
    my $cache     = MT->request->cache($cache_key);

    return $cache if $cache;

    my $token_data = $asset->get_token_data();
    return undef unless $token_data;

    my $request = Net::OAuth->request("protected resource")->new(
        consumer_key     => $token_data->{consumer_key},
        consumer_secret  => $token_data->{consumer_secret},
        request_url      => 'https://api.flickr.com/services/rest/',
        request_method   => 'GET',
        signature_method => 'HMAC-SHA1',
        timestamp        => time,
        nonce            => int( rand( 2**31 - 999999 + 1 ) ) + 999999,
        token            => $token_data->{access_token},
        token_secret     => $token_data->{access_token_secret},
        extra_params     => {
            method         => 'flickr.photos.getSizes',
            photo_id       => $photo_id,
            nojsoncallback => 1,
        },
    );
    $request->sign;
    my $ua = new_ua();
    $ua->ssl_opts( verify_hostname => 0 );
    my $res = $ua->get( $request->to_url . '&format=json' );

    if ( $res->is_success ) {
        my $data
            = MT::Util::from_json( Encode::decode( 'utf-8', $res->content ) );
        my @size = @{ $data->{sizes}{size} };
        foreach my $item (@size) {
            if ( $item->{label} eq 'Original' ) {
                MT::Request->instance->cache( $cache_key, $item );
                return $item;
            }
        }
    }
    else {
        return $asset->error(
            translate( 'Flickr getSizes error: ' . $res->status_line ) );
    }
}

sub thumbnail_basename {
    my $asset = shift;
    my $file
        = $asset->file_url =~ /.*\/(.*)/
        ? $1
        : $asset->file_url;
    my $ext
        = $file =~ /\.(\w+)$/
        ? $1
        : '';
    return ( $file, $ext );
}

1;

