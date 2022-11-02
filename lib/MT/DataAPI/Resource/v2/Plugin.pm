# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v2::Plugin;

use strict;
use warnings;

sub fields {
    [
        {
            name   => 'attributes',
            schema => {
                type  => 'array',
                items => {
                    type => 'string',
                },
            },
        },
        'authorLink',
        'authorName',
        'configLink',
        'description',
        'documentLink',
        'icon',
        'id',
        {
            name   => 'junkFilters',
            schema => {
                type  => 'array',
                items => {
                    type => 'string',
                },
            },
        },
        'name',
        'pluginLink',
        'pluginSet',
        'signature',
        'status',
        {
            name   => 'tags',
            schema => {
                type  => 'array',
                items => {
                    type => 'string',
                },
            },
        },
        {
            name   => 'textFilters',
            schema => {
                type  => 'array',
                items => {
                    type => 'string',
                },
            },
        },
        'version',
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::Plugin - Movable Type class for resources definitions of the MT::Plugin.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut

