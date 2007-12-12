# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Asset::Audio;

use strict;
use base qw( MT::Asset );

__PACKAGE__->install_properties( { class_type => 'audio', } );

# List of supported file extensions (to aid the stock 'can_handle' method.)
sub extensions { [qr/mp3/i, qr/ogg/i, qr/aiff?/i, qr/wav/i, qr/wma/i, qr/aac/i ] }

sub class_label {
    MT->translate('Audio');
}

sub class_label_plural {
    MT->translate('Audio');
}

1;

__END__

=head1 NAME

MT::Asset::Audio

=head1 AUTHOR & COPYRIGHT

Please see the L<MT/"AUTHOR & COPYRIGHT"> for author, copyright, and
license information.

=cut
