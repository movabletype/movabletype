# Movable Type (r) (C) 2001-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Asset::oEmbed::YouTube;

use strict;
use base qw( MT::Asset::oEmbed );

use MTAssetoEmbed;
use HTTP::Request::Common;

__PACKAGE__->install_properties(
    {   class_type    => 'youtube',
        provider_type => 'youtube',
        endpoint      => 'http://www.youtube.com/oembed',
        column_defs   => {
            'html'   => 'vclob meta',
            'width'  => 'integer meta',
            'height' => 'integer meta',
        },
        child_of => [ 'MT::Blog', 'MT::Website', ],
    }
);

sub domains {
    return [ qr/youtube\.com/i, qr/youtu\.be/i ];
}

sub class_label {
    MT->translate('YouTube');
}

sub class_label_plural {
    MT->translate('YouTube');
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

    $asset->provider_thumbnail_url ? 1 : 0;
}

sub get_file_size {
    my $asset = shift;

    my $app     = MT->instance;
    my $plugin  = plugin();
    my $blog_id = $asset->blog_id || 1;

    my $scope       = 'blog:' . $blog_id;
    my $plugin_data = $plugin->get_config_obj($scope);
    my $token       = MTAssetoEmbed::OAuth2::youtube_effective_token( $app,
        $plugin_data );

    return unless $token;

    my $id = $asset->url;
    $id =~ s!^https://www\.youtube\.com/watch\?v=(.*)$!$1!;

    my $uri = URI->new('https://www.googleapis.com/youtube/v3/videos');
    $uri->query_form(
        'access_token' => $token->{data}{access_token},
        'id'           => $id,
        'part'         => 'fileDetails',
        'fields'       => 'items(fileDetails(fileSize))',
    );

    my $ua  = new_ua();
    my $res = $ua->request( GET($uri) );

    if ( $res->is_success ) {
        my $data
            = MT::Util::from_json( Encode::decode( 'utf-8', $res->content ) );
        return $data->{items}[0]{fileDetails}{fileSize}
            if $data && $data->{items}[0]{fileDetails}{fileSize};
        return 0;
    }
    else {
        return 0;
    }
}

1;
