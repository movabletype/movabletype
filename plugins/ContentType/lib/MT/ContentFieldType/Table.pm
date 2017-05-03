package MT::ContentFieldType::Table;
use strict;
use warnings;

use MT::ContentField;
use MT::ContentType;

sub html {
    my $prop = shift;
    my ( $content_data, $app, $load_options ) = @_;

    my $field = MT::ContentField->load( $prop->content_field_id );

    my $value = $content_data->data->{ $prop->content_field_id } || '';

    _table2csv($value);
}

sub _table2csv {
    my $html = shift;

    $html =~ s/>\s+</></gm;
    $html =~ s/^\s*<tr>\s*|\s*<\/tr>\s*$//gm;
    my @rows = split '</tr><tr>', $html;

    for my $row (@rows) {
        $row =~ s/^\s*<td>\s*|\s*<\/td>\s*$//gm;
        $row =~ s/<\/td><td>/, /gm;
    }

    join '<br>', @rows;
}

sub field_html_params {
    my ( $app, $field_id, $value ) = @_;

    my $loaded_table_library = $app->request('loaded_table_library');
    $app->request( 'loaded_table_library', 1 ) unless $loaded_table_library;

    my $content_type_id = $app->param('content_type_id');
    my $content_type    = MT::ContentType->load($content_type_id);
    my $field           = $content_type->get_field($field_id);

    unless ($value) {
        my $initial_columns = $field->{options}{initial_columns} || 1;
        my $initial_rows    = $field->{options}{initial_rows}    || 1;
        $value = _create_empty_table( $initial_rows, $initial_columns );
    }

    my $changeable_columns
        = $field->{options}{changeable_columns}
        ? 'true'
        : 'false';
    my $changeable_rows
        = $field->{options}{changeable_rows}
        ? 'true'
        : 'false';

    {   changeable_columns   => $changeable_columns,
        changeable_rows      => $changeable_rows,
        field_id             => $field_id,
        loaded_table_library => $loaded_table_library,
        value                => $value,
    };
}

sub _create_empty_table {
    my ( $initial_rows, $initial_columns ) = @_;
    my $row = '<td></td>' x $initial_columns;
    $row = "<tr>${row}</tr>";
    join "\n", ( map {$row} ( 1 .. $initial_rows ) );
}

1;

