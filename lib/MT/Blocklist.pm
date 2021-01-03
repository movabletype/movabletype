# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Blocklist;
use strict;
use warnings;

use MT::Object;
@MT::Blocklist::ISA = qw( MT::Object );
__PACKAGE__->install_properties(
    {   columns => [ 'id', 'blog_id', 'text', 'action' ],
        indexes => {
            blog_id => 1,
            text    => 1,
        },
        audit       => 1,
        datasource  => 'blocklist',
        primary_key => 'id',
    }
);

# valid 'action' values:
#  * discard
#  * moderate
#  * nothing

sub block_these {
    my $class = shift;
    my ( $blog_id, $action, @urls ) = @_;
    foreach my $url (@urls) {
        next if $class->exist( { blog_id => $blog_id, text => $url } );
        my $this = $class->new();
        $this->set_values(
            {   blog_id => $blog_id,
                text    => $url,
                action  => $action
            }
        );
        $this->save() or return $class->error( $this->errstr() );
    }
    1;
}

1;

__END__

=head1 NAME

MT::Blocklist - MT object class for storing rules for filtering content.

=head1 METHODS

=head2 MT::Blocklist->block_these($blog_id, $action, @urls)

Adds the specified URLs to the blocklist table with the specified I<$action>
and for the specified I<$blog_id>.

=head1 LICENSE

The license that applies is the one you agreed to when downloading
Movable Type.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
