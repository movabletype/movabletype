# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Format::JSON;

use strict;
use warnings;

use MT::Util;

sub serialize {
    my $s = MT::Util::to_json( $_[0], { convert_blessed => 1, ascii => 1 } );
    $s =~ s/([<>\+])/sprintf("\\u%04x",ord($1))/eg;
    $s;
}

sub unserialize {
    MT::Util::from_json( $_[0] );
}

1;

__END__

=head1 NAME

MT::DataAPI::Format::JSON - Movable Type class for Data API's data formatter useing JSON.

=head1 METHODS

=head2 MT::DataAPI::Format::JSON::serialize($data)

Returns a JSON text which serialized C<$data>.

=head2 MT::DataAPI::Format::JSON::unserialize($json_text)

Returns a data which unserialized C<$json_text>.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
