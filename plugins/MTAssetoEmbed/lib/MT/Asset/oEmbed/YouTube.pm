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

1;
