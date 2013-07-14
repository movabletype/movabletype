# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::ObjectAsset;

use strict;
use MT::Blog;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            id        => 'integer not null auto_increment',
            blog_id   => 'integer',
            object_id => 'integer not null',
            object_ds => 'string(50) not null',
            asset_id  => 'integer not null',
            embedded  => 'boolean',
        },
        indexes => {
            blog_obj =>
                { columns => [ 'blog_id', 'object_ds', 'object_id' ], },

            id_ds    => { columns => [ 'object_id', 'object_ds' ], },
            asset_id => 1,
        },
        defaults    => { embedded => 0, },
        child_of    => 'MT::Blog',
        datasource  => 'objectasset',
        primary_key => 'id',
        cacheable   => 0,
    }
);

sub class_label {
    MT->translate("Asset Placement");
}

1;
