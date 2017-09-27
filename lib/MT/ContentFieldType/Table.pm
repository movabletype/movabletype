# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType::Table;
use strict;
use warnings;

use MT::ContentField;

sub html {
    my $prop = shift;
    my ( $content_data, $app, $load_options ) = @_;

    my $field = MT::ContentField->load( $prop->content_field_id );
    my $value = $content_data->data->{ $prop->content_field_id } || '';
    qq{<table class="table-field">${value}</table>};
}

sub field_html_params {
    my ( $app, $field_data ) = @_;

    my $value = $field_data->{value};
    unless ($value) {
        my $initial_columns = $field_data->{options}{initial_columns} || 1;
        my $initial_rows    = $field_data->{options}{initial_rows}    || 1;
        $value = _create_empty_table( $initial_rows, $initial_columns );
    }

    { table_value => $value };
}

sub _create_empty_table {
    my ( $initial_rows, $initial_columns ) = @_;
    my $row = '<tr>' . ( '<td></td>' x $initial_columns ) . '</tr>';
    join "\n", ( map {$row} ( 1 .. $initial_rows ) );
}

sub tag_handler {
    my ( $ctx, $args, $cond, $field_data, $value ) = @_;

    my $table = _table_with_heading( $field_data, $value );
    $table = "<table>\n${table}\n</table>";

    my $tok     = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $vars    = $ctx->{__stash}{vars} ||= {};
    local $vars->{__value__} = $table;
    $builder->build( $ctx, $tok, {%$cond} );
}

sub _table_with_heading {
    my ( $field_data, $value ) = @_;
    return $value unless $value;
    my $table_with_row_heading
        = _add_row_heading_to_table( $field_data, $value );
    my $column_heading = _create_column_heading( $field_data, $value );
    $column_heading =~ s/^(<tr>)/$1<th><\/th>/;
    "${column_heading}\n${table_with_row_heading}";
}

sub _create_column_heading {
    my ( $field_data, $value ) = @_;
    my @column_heading = split ',',
        ( $field_data->{options}{column_heading} || '' )
        or return '';
    my $column_count = _get_column_count($value) or return '';
    my $column_header = '';
    for my $i ( 0 .. $column_count - 1 ) {
        my $header = $column_heading[$i];
        $header = '' unless defined $header;
        $column_header .= "<th>${header}</th>";
    }
    "<tr>${column_header}</tr>";
}

sub _add_row_heading_to_table {
    my ( $field_data, $value ) = @_;
    return $value unless $value;
    my @row_heading = split ',', ( $field_data->{options}{row_heading} || '' )
        or return $value;
    my @table_rows = split "\n", $value;
    my @added_table_rows;
    for ( my $i = 0; $i < @table_rows; $i++ ) {
        my $row        = $table_rows[$i];
        my $row_header = $row_heading[$i];
        $row_header = '' unless defined $row_header;
        $row_header = "<th>${row_header}</th>";
        $row =~ s/^(<tr>)/$1$row_header/;
        push @added_table_rows, $row;
    }
    join "\n", @added_table_rows;
}

sub _get_column_count {
    my $value = shift or return 0;
    my ($first_line) = split "\n", $value;
    my @td_tag = $first_line =~ /<td>/g;
    scalar @td_tag;
}

sub options_validation_handler {
    my ( $app, $type, $label, $field_label, $options ) = @_;

    my $initial_rows = $options->{initial_rows};
    return $app->translate(
        "An initial rows of '[_1]' ([_2]) must be a positive integer.",
        $label, $field_label )
        if $initial_rows and $initial_rows !~ /^\d+$/;

    my $initial_cols = $options->{initial_cols};
    return $app->translate(
        "An initial columns of '[_1]' ([_2]) must be a positive integer.",
        $label, $field_label )
        if $initial_cols and $initial_cols !~ /^\d+$/;

    my $row_heading = $options->{row_heading};
    return $app->translate(
        "A row heading of '[_1]' ([_2]) must be shorter than 255 characters",
        $label,
        $field_label
    ) if $row_heading and length($row_heading) > 255;

    my $col_heading = $options->{col_heading};
    return $app->translate(
        "A column heading of '[_1]' ([_2]) must be shorter than 255 characters",
        $label,
        $field_label
    ) if $col_heading and length($col_heading) > 255;

    return;
}

1;

