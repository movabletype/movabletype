# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v2::WidgetSet;

use strict;
use warnings;

sub updatable_fields {
    [qw(
        name
        widgets
    )];
}

sub fields {
    [
        $MT::DataAPI::Resource::Common::fields{blog},
        $MT::DataAPI::Resource::Common::fields{createdBy},
        $MT::DataAPI::Resource::Common::fields{createdDate},
        $MT::DataAPI::Resource::Common::fields{modifiedDate},
        'id', 'name',
        {
            name   => 'widgets',
            schema => {
                type  => 'array',
                items => {
                    type       => 'object',
                    properties => {
                        id   => { type => 'string' },
                        name => { type => 'string' },
                    },
                },
            },
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::WidgetSet - Movable Type class for resources definitions of WidgetSet (MT::Template).

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
