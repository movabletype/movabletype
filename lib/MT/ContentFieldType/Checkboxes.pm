# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType::Checkboxes;
use strict;
use warnings;

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value};

    my %values;
    if ( defined $value ) {
        if ( ref $value eq 'ARRAY' ) {
            %values = map { $_ => 1 } @{$value};
        }
        else {
            $values{$value} = 1;
        }
    }

    my $options = $field_data->{options};
    my $options_values = $options->{values} || [];

    @$options_values = map {
        {   l => $_->{label},
            v => $_->{value},
            $values{ $_->{value} }
            ? ( checked => 'checked="checked"' )
            : (),
        }
    } @$options_values;

    my $multiple = '';
    my $max      = $options->{max};
    my $min      = $options->{min};
    $multiple = 'data-mt-multiple="1"';
    $multiple .= qq{ data-mt-max-select="${max}"} if $max;
    $multiple .= qq{ data-mt-min-select="${min}"} if $min;

    my $required = $options->{required} ? 'data-mt-required="1"' : '';

    {   multiple       => $multiple,
        options_values => $options_values,
        required       => $required,
    };
}

sub options_validation_handler {
    my ( $app, $type, $label, $field_label, $options ) = @_;

    my $values = $options->{values};
    return $app->translate("You must enter at least one label-value pair.")
        unless $values;

    for my $value (@$values) {
        return $app->translate("A label for each value is required.")
            unless defined $value->{label};

        return $app->translate("A value for each label is required.")
            unless defined $value->{value};
    }

    my $min = $options->{min};
    return $app->translate(
        "A minimum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to 0.",
        $label, $field_label
    ) if '' ne $min and $min !~ /^\d+$/;

    my $max = $options->{max};
    return $app->translate(
        "A maximum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to 1.",
        $label,
        $field_label
    ) if '' ne $max and ( $max !~ /^\d+$/ or $max < 1 );

    return $app->translate(
        "A maximum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to the minimum selection number.",
        $label, $field_label
        )
        if '' ne $min
        and '' ne $max
        and $max < $min;

    return;
}

sub options_pre_save_handler {
    my ( $app, $type, $obj, $options ) = @_;

    $options->{multiple} = 1;    # Checkboxes is always enabeled.

    return;
}

1;

