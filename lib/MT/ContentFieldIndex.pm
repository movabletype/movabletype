# Movable Type (r) (C) 2006-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ContentFieldIndex;

use strict;
use base qw( MT::Object );

my %IdxTypes = (
    varchar  => 1,
    blob     => 1,
    datetime => 1,
    integer  => 1,
    float    => 1,
);

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'               => 'integer not null auto_increment',
            'content_type_id'  => 'integer',
            'content_field_id' => 'integer',
            'content_data_id'  => 'integer',
            'value_varchar'    => 'string(255)',
            'value_blob'       => 'blob',
            'value_datetime'   => 'datetime',
            'value_integer'    => 'integer',
            'value_float'      => 'float',
        },
        indexes => {
            value_varchar  => 1,
            value_datetime => 1,
            value_integer  => 1,
            value_float    => 1
        },
        datasource  => 'cf_idx',
        primary_key => 'id',
        audit       => 1,
    }
);

sub class_label {
    MT->translate("Content Field Index");
}

sub class_label_plural {
    MT->translate("Content Field Indexes");
}

sub _is_valid_idx_type {
    $IdxTypes{ shift || '' };
}

sub set_value {
    my $self = shift;
    my ( $idx_type, $value ) = @_;

    return unless _is_valid_idx_type($idx_type);

    my $field = "value_${idx_type}";
    $self->$field($value);

    1;
}

1;
