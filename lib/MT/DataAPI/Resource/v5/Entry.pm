# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v5::Entry;

use strict;
use warnings;

sub fields {
    [
        {
            name   => 'author',
            schema => {
                type       => 'object',
                properties => {
                    id          => { type => 'integer' },
                    displayName => { type => 'string' },
                    userpicUrl  => { type => 'string' },
                },
            },
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v5::Entry - Movable Type class for resources definitions of the MT::Entry.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
