# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v5::Log;

use strict;
use warnings;

sub updatable_fields {
    [];    # Nothing. Same as v2.
}

sub fields {
    [
        {
            name => 'by',
            schema => {
                type       => 'object',
                properties => {
                    id          => { type => 'integer' },
                    displayName => { type => 'string' },
                    userpicUrl  => { type => 'string' },
                },
            },
        },
        {
            name => 'id',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v5::Log - Movable Type class for resources definitions of the MT::Log.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
