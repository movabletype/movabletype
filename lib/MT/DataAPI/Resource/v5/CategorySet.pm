# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v5::CategorySet;
use strict;
use warnings;

sub fields {
    [
        {
            name => 'categories',
            schema => {
                type  => 'array',
                items => {
                    type       => 'object',
                    properties => {
                        id       => { type => 'integer' },
                        parent   => { type => 'integer' },
                        label    => { type => 'string' },
                        basename => { type => 'string' },
                    },
                },
            },
        },
    ];
}

1;
