# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Blog;

use strict;
use warnings;

sub updatable_fields {
    [];
}

sub fields {
    [   qw(id class name description archiveUrl),
        {   name  => 'url',
            alias => 'site_url',
        },
    ];
}

1;
