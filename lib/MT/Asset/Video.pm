# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Asset::Video;

use strict;
use warnings;
use base qw( MT::Asset );
use MT::Blog;
use MT::Website;

__PACKAGE__->install_properties(
    { class_type => 'video', child_of => [ 'MT::Blog', 'MT::Website' ] } );

# List of supported file extensions (to aid the stock 'can_handle' method.)
sub extensions {
    my $pkg = shift;
    return $pkg->SUPER::extensions(
        [   qr/mov/i, qr/avi/i, qr/3gp/i, qr/asf/i, qr/mp4/i, qr/qt/i,
            qr/wmv/i, qr/asx/i, qr/mpe?g/i, qr/flv/i, qr/mkv/i, qr/ogm/i, qr/webm/i,
        ]
    );
}

sub class_label {
    MT->translate('Video');
}

sub class_label_plural {
    MT->translate('Videos');
}

# translate('video')

1;

__END__

=head1 NAME

MT::Asset::Video

=head1 METHODS

=head2 MT::Asset::Video->extensions

An internal function used by can_handle to decide if this module can handle a specific file.

=head2 MT::Asset::Video->class_label

Returns the localized descriptive name for this class.

=head2 MT::Asset::Video->class_label_plural

Returns the localized, plural descriptive name for this class.

=head1 AUTHOR & COPYRIGHT

Please see the L<MT/"AUTHOR & COPYRIGHT"> for author, copyright, and
license information.

=cut
