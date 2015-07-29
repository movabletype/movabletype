# Movable Type (r) (C) 2001-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Asset::oEmbed;

use strict;
use base qw( MT::Asset );

use URI::Escape;

__PACKAGE__->install_properties(
    {   class_type    => 'oembed',
        provider_type => 'oembed',
        column_defs   => {
            'type'                      => 'vchar meta',
            'version'                   => 'vchar meta',
            'title'                     => 'vchar meta',
            'author_name'               => 'vchar meta',
            'author_url'                => 'vclob meta',
            'provider_name'             => 'vchar meta',
            'provider_url'              => 'vclob meta',
            'cache_age'                 => 'integer meta',
            'provider_thumbnail_url'    => 'vclob meta',
            'provider_thumbnail_width'  => 'integer meta',
            'provider_thumbnail_height' => 'integer meta',
        },
        child_of => [ 'MT::Blog', 'MT::Website', ],
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
            qw( type version author_name author_url provider_name provider_url cache_age )
            )
        {
            $asset->$k( $json->{$k} ) if $json->{$k};
        }
        for my $k (qw( thumbnail_url thumbnail_width thumbnail_height )) {
            my $method = "provider_$k";
            $asset->$method( $json->{$k} ) if $json->{$k};
        }
        $asset->label( $json->{title} );
        $asset->file_path( $json->{url} );
    }
    else {
        return $asset->error(
            MT->translate( "Error embed: [_1]", $res->msg ) );
    }
    return $asset;
}

sub domains { [] }

sub thumbnail_path {
    my $asset = shift;
    my (%param) = @_;

    $asset->provider_thumbnail_url();
}

1;
