# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType::SelectBox;
use strict;
use warnings;

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value};

    my %values;
    if ( defined $value ) {
        if ( ref $value eq 'ARRAY' ) {
            %values = map { $_ => 1 } @$value;
        }
        else {
            $values{$value} = 1;
        }
    }

    my $options = $field_data->{options};
    my $options_values = $options->{values} || [];

    if (%values) {
        @$options_values = map {
            {   l => $_->{label},
                v => $_->{value},
                $values{ $_->{value} }
                ? ( selected => 'selected="selected"' )
                : (),
            }
        } @$options_values;
    }
    else {
        @{$options_values} = map {
            {   l => $_->{label},
                v => $_->{value},
                (   $_->{checked} ? ( selected => 'selected="selected"' ) : ()
                ),
            }
        } @{$options_values};
    }

    my $required = $options->{required} ? 'required' : '';

    my $multiple       = '';
    my $multiple_class = '';
    if ( $options->{multiple} ) {
        my $max = $options->{max};
        my $min = $options->{min};
        $multiple = 'multiple style="min-width: 10em; min-height: 10em"';
        $multiple .= qq{ data-mt-max-select="${max}"} if $max;
        $multiple .= qq{ data-mt-min-select="${min}"} if $min;
        $multiple_class = 'multiple-select';
    }

    {   multiple       => $multiple,
        multiple_class => $multiple_class,
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
        return $app->translate("A label of values is required.")
            unless $value->{label};

        return $app->translate("A value of values is required.")
            unless $value->{value};
    }

    my $multiple = $options->{multiple};
    if ($multiple) {
        my $min = $options->{min};
        return $app->translate(
            "A number of minimum selection of '[_1]' ([_2]) must be a positive integer greater than or equal to 0.",
            $label,
            $field_label
            )
            if defined($min)
            and '' ne $min
            and $min !~ /^\d+$/;

        my $max = $options->{max};
        return $app->translate(
            "A number of maximum selection of '[_1]' ([_2]) must be a positive integer greater than or equal to 1.",
            $label,
            $field_label
            )
            if defined($max)
            and '' ne $max
            and ( $max !~ /^\d+$/ or $max < 1 );

        return $app->translate(
            "A number of maximum selection of '[_1]' ([_2]) must be a positive integer greater than or equal to a number of minimum selection.",
            $label,
            $field_label
            )
            if defined($min)
            and defined($max)
            and '' ne $min
            and '' ne $max
            and $max < $min;
    }

    return;
}

1;

