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

    my $table = _table_with_headers( $field_data, $value );
    $table = "<table>\n${table}\n</table>";

    my $tok     = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $vars    = $ctx->{__stash}{vars} ||= {};
    local $vars->{__value__} = $table;
    $builder->build( $ctx, $tok, {%$cond} );
}

sub _table_with_headers {
    my ( $field_data, $value ) = @_;
    return $value unless $value;
    my $table_with_row_headers
        = _add_row_headers_to_table( $field_data, $value );
    my $column_headers = _create_column_headers( $field_data, $value );
    $column_headers =~ s/^(<tr>)/$1<th><\/th>/;
    "${column_headers}\n${table_with_row_headers}";
}

sub _create_column_headers {
    my ( $field_data, $value ) = @_;
    my @column_headers = split ',',
        ( $field_data->{options}{column_headers} || '' )
        or return '';
    my $column_count = _get_column_count($value) or return '';
    my $column_header = '';
    for my $i ( 0 .. $column_count - 1 ) {
        my $header = $column_headers[$i];
        $header = '' unless defined $header;
        $column_header .= "<th>${header}</th>";
    }
    "<tr>${column_header}</tr>";
}

sub _add_row_headers_to_table {
    my ( $field_data, $value ) = @_;
    return $value unless $value;
    my @row_headers = split ',', ( $field_data->{options}{row_headers} || '' )
        or return $value;
    my @table_rows = split "\n", $value;
    my @added_table_rows;
    for ( my $i = 0; $i < @table_rows; $i++ ) {
        my $row        = $table_rows[$i];
        my $row_header = $row_headers[$i];
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

1;

