# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ContentFieldIndex;

use strict;
use warnings;
use base qw( MT::Object );

my %IdxTypes = (
    varchar  => 1,
    text     => 1,
    blob     => 1,
    datetime => 1,
    integer  => 1,
    float    => 1,
    double   => 1,
);

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'               => 'integer not null auto_increment',
            'content_type_id'  => 'integer',
            'content_field_id' => 'integer',
            'content_data_id'  => 'integer',
            'value_varchar'    => 'string(255)',
            'value_text'       => 'text',
            'value_blob'       => 'blob',
            'value_datetime'   => 'datetime',
            'value_integer'    => 'integer',
            'value_float'      => 'float',
            'value_double'     => 'double',
        },
        indexes => {
            value_varchar  => 1,
            value_datetime => 1,
            value_integer  => 1,
            value_float    => 1,
            value_double   => 1,
        },
        datasource      => 'cf_idx',
        long_datasource => 'content_field_index',
        primary_key     => 'id',
        audit           => 1,
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

sub column_as_datetime {
    my $obj   = shift;
    my ($col) = @_;
    my $ts    = $obj->column($col) or return;
    my ( $y, $mo, $d, $h, $m, $s )
        = $ts
        =~ /(\d\d\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)[^\d]?(\d\d)/
        or return;

    my ($ct) = MT::ContentType->load( $obj->content_type_id );
    my $blog;
    if ( my $blog_id = $ct->blog_id ) {
        require MT::Blog;
        $blog = MT::Blog->load($blog_id);
    }
    require MT::DateTime;
    my $four_digit_offset;
    if ($blog) {
        $four_digit_offset = sprintf( '%.02d%.02d',
            int( $blog->server_offset ),
            60 * abs( $blog->server_offset - int( $blog->server_offset ) ) );
    }
    return new MT::DateTime(
        year      => $y,
        month     => $mo,
        day       => $d,
        hour      => $h,
        minute    => $m,
        second    => $s,
        time_zone => $four_digit_offset
    );
}

sub content_field {
    my $self = shift;
    $self->cache_property(
        'content_field',
        sub {
            MT->model('content_field')->load( $self->content_field_id || 0 );
        },
    );
}

sub content_data {
    my $self = shift;
    $self->cache_property(
        'content_data',
        sub {
            MT->model('content_data')->load( $self->content_data_id || 0 );
        },
    );
}

1;
