# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ObjectCategory;

use strict;
use warnings;

use MT;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'          => 'integer not null auto_increment',
            'blog_id'     => 'integer',
            'object_id'   => 'integer not null',
            'object_ds'   => 'string(50) not null',
            'category_id' => 'integer not null',
            'is_primary'  => 'boolean not null',
            'cf_id'       => 'integer not null',
        },
        indexes => {
            object_id   => 1,
            category_id => 1,
            object_ds   => 1,
            is_primary  => 1,

            # For MTCategories
            blog_ds_tag =>
                { columns => [ 'blog_id', 'object_ds', 'category_id' ], },

            # For category count
            blog_ds_obj => {
                columns =>
                    [ 'blog_id', 'object_ds', 'object_id', 'category_id' ],
            },
        },
        child_of    => 'MT::Blog',
        datasource  => 'objectcategory',
        primary_key => 'id',
        cacheable   => 0,
        defaults    => { cf_id => 0 },
    }
);

sub class_label {
    MT->translate("Category Placement");
}

sub class_label_plural {
    MT->translate("Category Placements");
}

__PACKAGE__->add_callback(
    'post_remove',
    5,
    MT->component('core'),
    sub {
        my ( $cb, $obj, $orig ) = @_;
        MT->model('content_data')
            ->remove_category_from_categories_field($obj);
    },
);

__PACKAGE__->add_callback(
    'pre_direct_remove',
    5,
    MT->component('core'),
    sub {
        my ( $cb, $class, $terms, $args ) = @_;
        my @objcats = $class->load( $terms, $args );
        for my $objcat (@objcats) {
            MT->model('content_data')
                ->remove_category_from_categories_field($objcat);
        }
    },
);

1;
__END__

=head1 NAME

MT::ObjectCategory

=head1 METHODS

    = head2 MT::ObjectCategory->class_label

    Returns the localized descriptive name for this class .

=head2 MT::ObjectCategory->class_label_plural

Returns the localized, plural descriptive name for this class.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut

