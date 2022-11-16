# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DeleteFileInfo;
use strict;
use warnings;

use base qw(MT::Object);

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'         => 'integer not null auto_increment',
            'blog_id'    => 'integer not null',
            'file_path'  => 'text not null',
            'build_type' => 'smallint not null',
        },
        indexes     => { blog_id => 1, },
        datasource  => 'deletefileinfo',
        primary_key => 'id',
        cacheable   => 0,
    }
);

1;
