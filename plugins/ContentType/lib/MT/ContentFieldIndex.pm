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

sub load_or_new {
    my $class   = shift;
    my ($terms) = @_;

    my $cf_idx  = __PACKAGE__->load($terms);
    unless ($cf_idx) {
        $cf_idx = __PACKAGE__->new;
        $cf_idx->set_values($terms);
    }

    $cf_idx;
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

sub make_terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $string = $args->{string};
    my $query_string
        = $args->{option} eq 'contains'     ? { like     => "%$string%" }
        : $args->{option} eq 'not_contains' ? { not_like => "%$string%" }
        : $args->{option} eq 'equal'        ? $string
        : $args->{option} eq 'beginning'    ? { like     => "$string%" }
        : $args->{option} eq 'end'          ? { like     => "%$string" }
        :                                     '';

    my $idx_type = $prop->{idx_type};

    unless ( $db_args->{joins} ) {
        $db_args->{joins} ||= [];
    }

    push @{ $db_args->{joins} },
        __PACKAGE__->join_on(
        undef,
        {   content_data_id     => \'= content_data_id',
            "value_${idx_type}" => $query_string,
        },
        { alias => "index_${idx_type}" },
        );
}

1;
