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
            'thumb_sizes'        => 'vblob meta',
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

    my $orig_src = $asset->get_original_source( $asset->web_page );
    my $name
        = $orig_src =~ /.*\/(.*\.\w+)$/
        ? $1
        : '';
    $asset->file_name($name);
    my $ext
        = $name =~ /.*\.(\w+)$/
        ? $1
        : '';
    $asset->file_ext($ext);

    return $asset;
}

sub get_token_data {
    my $asset = shift;

    my $app = MT->instance;
    return get_token( $app, $asset );
}

sub exist_access_token {
    my $asset = shift;

    my $app = MT->instance;
    my $token_data = get_token( $app, $asset );

    return $token_data->{access_token} ? 1 : 0;
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
        my @size = @{ $data->{sizes}{size} };

        my @thumb_sizes = grep {
                   ( $_->{width} <= 640 && $_->{height} <= 640 )
                && ( $_->{width} > 75 && $_->{height} > 75 )
        } @size;
        $asset->thumb_sizes( \@thumb_sizes );

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

sub insert_options {
    my $asset = shift;
    my ($param) = @_;

    my $app    = MT->instance;
    my $blog   = $asset->blog or return;
    my $plugin = plugin();

    $param->{ 'align_' . $_ }
        = ( $blog->image_default_align || 'none' ) eq $_ ? 1 : 0
        for qw(none left center right);

    $param->{thumb_sizes_loop} = $asset->thumb_sizes;

    return $app->build_page(
        $plugin->load_tmpl('cms/include/insert_options_flickr.tmpl'),
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

    my ( $width, $height ) = split ',', $param->{thumb_size};
    my $url = $asset->url;
    my $res = $asset->get_oembed_data( $url, $width, $height );
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

