# Movable Type (r) (C) 2001-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Asset::oEmbed::YouTube;

use strict;
use base qw( MT::Asset::oEmbed );

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

sub get_original_mod_time {
    my $asset = shift;
    my ($param) = @_;

    my $app    = MT->instance;
    my $plugin = $app->component("MTAssetoEmbed");
    my $blog   = $app->blog;

    return unless $blog;

    my $scope       = 'blog:' . $blog->id;
    my $plugin_data = $plugin->get_config_obj($scope);
    my $token_data  = MTAssetoEmbed::OAuth2::youtube_effective_token( $app,
        $plugin_data );

    return unless $token_data;

    my $id = $asset->url;
    $id =~ s!https://www\.youtube\.com/watch\?v=(.*)!$1!;

    my $uri = URI->new('https://www.googleapis.com/youtube/v3/videos');
    $uri->query_form(
        'access_token' => $token_data->{data}{access_token},
        'id'           => $id,
        'part'         => 'snippet',
        'fields'       => 'items(snippet(publishedAt))',
    );

    my $ua  = MT->new_ua();
    my $res = $ua->get( $uri->as_string );

    if ( $res->is_success ) {
        my $data
            = MT::Util::from_json( Encode::decode( 'utf-8', $res->content ) );

        my $publish_at = $data->{items}[0]{snippet}{publishedAt};

        return iso2epoch($publish_at);
    }
    else {
        return undef;
    }
}

sub iso2epoch {
    my ($ts) = @_;
    return
        unless $ts
        =~ /^(\d{4})(?:-?(\d{2})(?:-?(\d\d?)(?:T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(?:Z|([+-]\d{2}:\d{2}))?)?)?)?/;
    my ( $y, $mo, $d, $h, $m, $s, $zone )
        = ( $1, $2 || 1, $3 || 1, $4 || 0, $5 || 0, $6 || 0, $7 );

    use Time::Local;
    my $dt = timegm( $s, $m, $h, $d, $mo - 1, $y );
    if ( $zone && $zone ne 'Z' ) {
        require MT::DateTime;
        my $tz_secs = MT::DateTime->tz_offset_as_seconds($zone);
        $dt -= $tz_secs;
    }
    $dt;
}

1;
