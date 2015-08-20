# Movable Type (r) (C) 2001-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Asset::oEmbed::Flickr;

use strict;
use base qw( MT::Asset::oEmbed );

use MTAssetoEmbed;
use MTAssetoEmbed::Flickr;

__PACKAGE__->install_properties(
    {   class_type  => 'flickr',
        endpoint    => 'http://www.flickr.com/services/oembed/',
        column_defs => {
            'html'               => 'vclob meta',
            'width'              => 'integer meta',
            'height'             => 'integer meta',
            'web_page'           => 'vclob meta',
            'web_page_short_url' => 'vclob meta',
            'license'            => 'vchar meta',
            'license_id'         => 'integer meta',
            'license_url'        => 'vclob meta',
        },
        child_of => [ 'MT::Blog', 'MT::Website', ],
    }
);

sub url_schemes {
    return [
        qr!https?://[0-9a-zA-Z\-]+\.flickr\.com\/photos\/[\;\/\?\:\@\&\=\+\$\,\[\]A-Za-z0-9\-_\.\!\~\*\'\(\)%]+!i,
        qr!https?://flic\.kr\/p\/[\;\/\?\:\@\&\=\+\$\,\[\]A-Za-z0-9\-_\.\!\~\*\'\(\)%]+!i,
        qr!https?://[0-9a-zA-Z\-]+\.staticflickr\.com\/[\;\/\?\:\@\&\=\+\$\,\[\]A-Za-z0-9\-_\.\!\~\*\'\(\)%]+!i,
    ];
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
        : $asset->embed_thumbnail_url ? 1
        :                               0;
}

sub get_file_size {
    my $asset = shift;

    my $url = $asset->original_file_url;

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

    my $app = MT->instance;
    return get_token( $app, $asset );
}

sub get_original_file_url {
    my $asset = shift;
    my ($json) = @_;

    return $asset->get_original_source( $json->{web_page} );
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

    my $photo_id
        = $url =~ /.*\/(.*)\//
        ? $1
        : $url;

    my $cache_key = _cache_key($photo_id);
    my $cache     = MT->request->cache($cache_key);

    return $cache if $cache;

    my $app = MT->instance;
    my $token = get_token( $app, $asset );
    return $asset->error( translate('Token data is not registered.') )
        unless $token;

    my $res = get_request( $app, $token, 'flickr.photos.getSizes',
        { photo_id => $photo_id } );

    if ( $res->is_success ) {
        my $data
            = MT::Util::from_json( Encode::decode( 'utf-8', $res->content ) );
        return $asset->error(
            translate( 'Flickr getSizes error: ' . $data->{message} ) )
            if ( $data->{stat} eq 'fail' );
        my @size      = @{ $data->{sizes}{size} };
        my $max_width = 0;
        my $max_size_item;
        foreach my $item (@size) {
            if ( $item->{label} eq 'Original' ) {
                MT::Request->instance->cache( $cache_key, $item );
                return $item;
            }
            else {
                if ( $max_width < $item->{width} ) {
                    $max_width     = $item->{width};
                    $max_size_item = $item;
                }
            }
            if ($max_size_item) {
                MT::Request->instance->cache( $cache_key, $max_size_item );
                return $max_size_item;
            }
            else {
                return $asset->error(
                    translate(
                        'Flickr getSizes error: Size parameter was not found.'
                    )
                );
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
        = $asset->original_file_url =~ /.*\/(.*)/
        ? $1
        : $asset->original_file_url;
    my $ext
        = $file =~ /\.(\w+)$/
        ? $1
        : '';
    return ( $file, $ext );
}

1;

