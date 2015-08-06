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
    {   class_type    => 'flickr',
        provider_type => 'flickr',
        endpoint      => 'http://www.flickr.com/services/oembed/',
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

1;

