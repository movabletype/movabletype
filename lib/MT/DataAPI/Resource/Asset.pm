# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Asset;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [   qw(
            label
            description
            tags
            )
    ];
}

sub fields {
    [   qw(
            id
            label
            url
            description
            mimeType
            ),
        {   name  => 'filename',
            alias => 'file_name',
        },
        $MT::DataAPI::Resource::Common::fields{tags},
    ];
}

1;
