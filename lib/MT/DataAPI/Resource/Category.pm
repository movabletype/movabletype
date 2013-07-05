# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Category;

use strict;
use warnings;

sub updatable_fields {
    [   qw(
            label
            description
            basename
            )
    ];
}

sub fields {
    [   $MT::DataAPI::Resource::Common::fields{blog},
        {   name => 'id',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        'class', 'label',
        'description',
        'parent',
        'basename',
    ];
}

1;
