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
        $value = undef unless $str;
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
        "An initial rows of '[_1]' ([_2]) must be a positive integer.",
        $label, $field_label )
        if $initial_rows and $initial_rows !~ /^\d+$/;

    my $initial_cols = $options->{initial_cols};
    return $app->translate(
        "An initial columns of '[_1]' ([_2]) must be a positive integer.",
        $label, $field_label )
        if $initial_cols and $initial_cols !~ /^\d+$/;

    return;
}

sub feed_value_handler {
    my ( $app, $field_data, $value ) = @_;
    return qq{<table border="1">$value</table>};
}

sub preview_handler {
    my ( $value, $field_id, $content_data ) = @_;
    return '' unless $value;
    return qq{<table border="1" cellpadding="3">$value</table>};
}

1;

