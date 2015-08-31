# Movable Type (r) (C) 2001-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Asset::oEmbed::YouTube;

use strict;
use base qw( MT::Asset::oEmbed );

use MTAssetoEmbed;
use MTAssetoEmbed::OAuth2;
use HTTP::Request::Common;

__PACKAGE__->install_properties(
    {   class_type  => 'youtube',
        endpoint    => 'http://www.youtube.com/oembed',
        column_defs => {
            'html'   => 'vclob meta',
            'width'  => 'integer meta',
            'height' => 'integer meta',
        },
        child_of => [ 'MT::Blog', 'MT::Website', ],
    }
);

sub url_schemes {
    return [
        qr!https?://[0-9a-zA-Z\-]+\.youtube\.com\/watch[\;\/\?\:\@\&\=\+\$\,\[\]A-Za-z0-9\-_\.\!\~\*\'\(\)%]+!i,
        qr!https?://youtu\.be\/[\;\/\?\:\@\&\=\+\$\,\[\]A-Za-z0-9\-_\.\!\~\*\'\(\)%]+!i,
    ];
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

    $asset->embed_thumbnail_url ? 1 : 0;
}

sub get_file_size {
    my $asset = shift;

    my $token = $asset->get_token_data();

    return unless $token;

    my $id = $asset->get_id;

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
        return undef unless $data;
        return $data->{items}[0]{fileDetails}{fileSize}
            if $data->{items}[0]{fileDetails}{fileSize};
    }
    return undef;
}

sub get_token_data {
    my $asset = shift;

    my $app = MT->instance;
    return get_token_from_plugindata( $app, $asset );
}

sub get_id {
    my $asset = shift;
    my $id    = $asset->url;
    $id =~ s!^https://www\.youtube\.com/watch\?v=([^&]*).*!$1!;
    return $id;
}

sub thumbnail_basename {
    my $asset = shift;
    my $id    = $asset->get_id;
    my $file
        = $asset->original_file_url =~ /.*\/(.*)/
        ? $1
        : $asset->original_file_url;
    my $ext
        = $file =~ /\.(\w+)$/
        ? $1
        : '';
    return ( $id, $ext );
}

sub insert_options {
    my $asset = shift;
    my ($param) = @_;

    my $app    = MT->instance;
    my $blog   = $asset->blog or return;
    my $plugin = plugin();

    $param->{ 'align_' . $_ }
        = ( $blog->image_default_align || 'none' ) eq $_ ? 1 : 0
        for qw(none left center right);

    $param->{embed_width}
        = $blog->image_default_width
        || $asset->image_width
        || 0;

    return $app->build_page(
        $plugin->load_tmpl('cms/include/insert_options_youtube.tmpl'),
        $param );
}

sub as_html {
    my $asset = shift;
    my ($param) = @_;

    $asset->html;
}

sub on_upload {
    my $asset = shift;
    my ($param) = @_;

    my $width = $param->{embed_width};
    my $url   = $asset->url;
    my $res   = $asset->get_oembed_data( $url, $width );
    if ( $res->is_success ) {
        require JSON;
        my $json = JSON::from_json( $res->content() );
        my $html = $json->{html};

        my $wrap_style = 'class="mt-image-' . $param->{align} . '" ';
        if ( $param->{align} eq 'none' ) {
            $wrap_style .= q{style=""};
        }
        elsif ( $param->{align} eq 'left' ) {
            $wrap_style .= q{style="float: left; margin: 0 20px 20px 0;"};
        }
        elsif ( $param->{align} eq 'right' ) {
            $wrap_style .= q{style="float: right; margin: 0 0 20px 20px;"};
        }
        elsif ( $param->{align} eq 'center' ) {
            $wrap_style
                .= q{style="text-align: center; display: block; margin: 0 auto 20px;"};
        }

        $asset->html( "<div " . $wrap_style . ">" . $html . "</div>" );
        $asset->save;
    }
    else {
        return $asset->error(
            MT->translate( "Error embed: [_1]", $res->content ) );
    }
}

1;
