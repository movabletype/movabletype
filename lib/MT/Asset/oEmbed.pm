# Movable Type (r) (C) 2001-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Asset::oEmbed;

use strict;
use base qw( MT::Object );
@MT::Asset::oEmbed::ISA = qw( MT::Object );

use URI::Escape;

__PACKAGE__->install_properties(
    {   class_type    => 'oembed',
        provider_type => 'oembed',
        column_defs   => {
            'id'               => 'integer not null auto_increment',
            'blog_id'          => 'integer not null',
            'url'              => 'text',
            'type'             => 'string(255)',
            'version'          => 'string(10)',
            'title'            => 'string(255)',
            'author_name'      => 'string(255)',
            'author_url'       => 'text',
            'provider_name'    => 'string(255)',
            'provider_url'     => 'text',
            'cache_age'        => 'integer',
            'thumbnail_url'    => 'text',
            'thumbnail_width'  => 'integer',
            'thumbnail_height' => 'integer',
        },
        indexes => {
            type        => 1,
            title       => 1,
            author_name => 1,
            created_by  => 1,
            created_on  => 1,
        },
        audit       => 1,
        meta        => 1,
        datasource  => 'asset_oembed',
        primary_key => 'id',
    }
);

sub install_properties {
    my $class = shift;
    my ($props) = @_;

    my $super_props = $class->SUPER::properties();
    if ($super_props) {
        if ( $super_props->{provider_type} ) {

            # copy reference of class_to_provider/provider_to_class hashes
            $props->{__class_to_provider}
                = $super_props->{__class_to_provider};
            $props->{__provider_to_class}
                = $super_props->{__provider_to_class};
        }
    }

    if ( my $type = $props->{provider_type} ) {
        $props->{__class_to_provider}{$class} = $type;
        $props->{__provider_to_class}{$type}  = $class;
    }

    $class->SUPER::install_properties($props);

    return $props;
}

sub can_handle {
    my ( $pkg, $url ) = @_;

    my $domains = $pkg->domains || [];
    foreach my $domain (@$domains) {
        return 1 if ( $url =~ /$domain/ );
    }
    return 0;
}

sub get_embed {
    my $asset = shift;
    my ($url) = @_;

    $url = $url || $asset->url();

    return undef unless $url;

    $url = Encode::encode_utf8($url) unless Encode::is_utf8($url);
    my $param = uri_escape_utf8($url);

    my $ua       = MT->new_ua();
    my $endpoint = $asset->properties->{endpoint};
    my $res      = $ua->get( $endpoint . '?url=' . $param . '&format=json' );

    if ( $res->is_success ) {
        require JSON;
        my $json = JSON::from_json( $res->content() );
        for my $k (
            qw(
            url type version title author_name
            author_url provider_name provider_url
            cache_age thumbnail_url
            thumbnail_width thumbnail_height
            )
            )
        {
            $asset->$k( $json->{$k} ) if $json->{$k};
        }
    }
    else {
        return $asset->error(
            MT->translate( "Error embed: [_1]", $res->msg ) );
    }
    return $asset;
}

sub domains { [] }

1;
