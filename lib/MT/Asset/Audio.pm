# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Asset::Audio;

use strict;
use warnings;
use base qw( MT::Asset );
use MT::Blog;
use MT::Website;

__PACKAGE__->install_properties(
    { class_type => 'audio', child_of => [ 'MT::Blog', 'MT::Website' ], } );

# List of supported file extensions (to aid the stock 'can_handle' method.)
sub extensions {
    my $pkg = shift;
    return $pkg->SUPER::extensions(
        [   qr/mp3/i, qr/ogg/i, qr/aiff?/i, qr/wav/i,
            qr/wma/i, qr/aac/i, qr/flac/i,  qr/m4a/i
        ]
    );
}

sub class_label {
    MT->translate('Audio');
}

sub class_label_plural {
    MT->translate('Audio');
}

# translate('audio')

1;

__END__

=head1 NAME

MT::Asset::Audio

=head1 METHODS

=head2 MT::Asset::Audio->extensions

An internal function used by can_handle to decide if this module can handle a specific file.

=head2 MT::Asset::Audio->class_label

Returns the localized descriptive name for this class.

=head2 MT::Asset::Audio->class_label_plural

Returns the localized, plural descriptive name for this class.

=head1 AUTHOR & COPYRIGHT

Please see the L<MT/"AUTHOR & COPYRIGHT"> for author, copyright, and
license information.

=cut
