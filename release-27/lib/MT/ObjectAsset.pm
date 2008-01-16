# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::ObjectAsset;

use strict;
use MT::Blog;
use base qw( MT::Object );

__PACKAGE__->install_properties({
    column_defs => {
        id => 'integer not null auto_increment',
        blog_id => 'integer',
        object_id => 'integer not null',
        object_ds => 'string(50) not null',
        asset_id => 'integer not null',
    },
    indexes => {
        blog_id => 1,
        object_id => 1,
        asset_id => 1,
        object_ds => 1,
    },
    child_of => 'MT::Blog',
    datasource => 'objectasset',
    primary_key => 'id',
});

sub class_label {
    MT->translate("Asset Placement");
}

1;
