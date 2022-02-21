# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Endpoint;

use strict;
use warnings;

sub fields {
    return [
        'id', 'route', 'verb', 'version', 'format',
        {
            name   => 'component',
            schema => {
                type       => 'object',
                properties => {
                    id   => { type => 'string' },
                    name => { type => 'string' },
                },
            },
        },
        {
            name   => 'resources',
            schema => {
                type  => 'array',
                items => {
                    type => 'string',
                },
            },
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::Endpoint - Resources definitions of the /endpoints API.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
