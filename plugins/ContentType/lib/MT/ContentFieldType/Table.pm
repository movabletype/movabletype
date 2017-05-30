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

1;

