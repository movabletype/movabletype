# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
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
        my $initial_cols = $field_data->{options}{initial_cols} || 1;
        my $initial_rows = $field_data->{options}{initial_rows} || 1;
        $value = _create_empty_table( $initial_rows, $initial_cols );
    }

    { table_value => $value };
}

sub _create_empty_table {
    my ( $initial_rows, $initial_cols ) = @_;
    my $row = '<tr>' . ( '<td></td>' x $initial_cols ) . '</tr>';
    join "\n", ( map {$row} ( 1 .. $initial_rows ) );
}

sub data_load_handler {
    my ( $app, $field_data ) = @_;
    my $field_id = $field_data->{id};
    my $value    = $app->param( 'content-field-' . $field_id );
    if ( defined $value && $value ne '' ) {
        my $str = MT::Util::remove_html($value);
        $str =~ s/(\s|\r|\n)//g;
        $value = undef unless defined $str && $str ne '';
    }
    else {
        $value = undef;
    }
    return $value;
}

sub tag_handler {
    my ( $ctx, $args, $cond, $field_data, $value ) = @_;

    unless ( defined $value ) {
        $value = '';
    }
    my $table = "<table>\n${value}\n</table>";

    my $tok     = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $vars    = $ctx->{__stash}{vars} ||= {};
    local $vars->{__value__} = $table;
    $builder->build( $ctx, $tok, {%$cond} );
}

sub options_validation_handler {
    my ( $app, $type, $label, $field_label, $options ) = @_;

    my $initial_rows = $options->{initial_rows};
    return $app->translate(
        "Initial number of rows for '[_1]' ([_2]) must be a positive integer.",
        $label, $field_label
    ) if $initial_rows and $initial_rows !~ /^\d+$/;

    my $initial_cols = $options->{initial_cols};
    return $app->translate(
        "Initial number of columns for '[_1]' ([_2]) must be a positive integer.",
        $label, $field_label
    ) if $initial_cols and $initial_cols !~ /^\d+$/;

    return;
}

sub feed_value_handler {
    my ( $app, $field_data, $value ) = @_;
    $value = '' unless defined $value && $value ne '';
    return qq{<table border="1">$value</table>};
}

sub preview_handler {
    my ( $field_data, $value, $content_data ) = @_;
    return '' unless $value;
    return qq{<table border="1" cellpadding="3">$value</table>};
}

sub search_handler {
    my ( $search_regex, $field_data, $table_body, $content_data ) = @_;
    return 0 unless defined $table_body;
    $table_body =~ s/>\s+</></g;
    $table_body =~ s/\A\s*//g;
    $table_body =~ s/\s*\z//g;
    my @cell = split /<tr>|<\/tr>|<th[^>]*>|<\/th>|<td[^>]*>|<\/td>/,
        $table_body;
    ( grep {/$search_regex/} @cell ) ? 1 : 0;
}

1;

