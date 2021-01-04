# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ObjectAsset;

use strict;
use warnings;
use MT::Blog;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            id        => 'integer not null auto_increment',
            blog_id   => 'integer',
            object_id => 'integer not null',
            object_ds => 'string(50) not null',
            asset_id  => 'integer not null',
            embedded => 'boolean',            # Deprecated (case #112321).
            cf_id    => 'integer not null',
        },
        indexes => {
            blog_obj =>
                { columns => [ 'blog_id', 'object_ds', 'object_id' ], },

            id_ds    => { columns => [ 'object_id', 'object_ds' ], },
            asset_id => 1,
        },
        defaults => {
            embedded => 0,
            cf_id    => 0,
        },
        child_of    => 'MT::Blog',
        datasource  => 'objectasset',
        primary_key => 'id',
        cacheable   => 0,
    }
);

sub class_label {
    MT->translate("Asset Placement");
}

__PACKAGE__->add_callback(
    'post_remove',
    5,
    MT->component('core'),
    sub {
        my ( $cb, $obj, $orig ) = @_;
        MT->model('content_data')->remove_asset_from_asset_field($obj);
    },
);

__PACKAGE__->add_callback(
    'pre_direct_remove',
    5,
    MT->component('core'),
    sub {
        my ( $cb, $class, $terms, $args ) = @_;
        my @objassets = $class->load( $terms, $args );
        for my $objasset (@objassets) {
            MT->model('content_data')
                ->remove_asset_from_asset_field($objasset);
        }
    },
);

1;
