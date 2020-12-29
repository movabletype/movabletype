# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
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

    @$options_values = map {
        {   l => $_->{label},
            v => $_->{value},
            $values{ $_->{value} }
            ? ( selected => 'selected="selected"' )
            : (),
        }
    } @$options_values;

    my $required = $options->{required} ? 'required' : '';

    my $multiple       = '';
    my $multiple_class = '';
    if ( $options->{multiple} ) {
        my $max = $options->{max};
        my $min = $options->{min};
        $multiple = 'multiple';
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
        return $app->translate("A label for each value is required.")
            unless defined $value->{label};

        return $app->translate("A value for each label is required.")
            unless defined $value->{value};
    }

    my $multiple = $options->{multiple};
    if ($multiple) {
        my $min = $options->{min};
        return $app->translate(
            "A minimum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to 0.",
            $label,
            $field_label
            )
            if defined($min)
            and '' ne $min
            and $min !~ /^\d+$/;

        my $max = $options->{max};
        return $app->translate(
            "A maximum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to 1.",
            $label,
            $field_label
            )
            if defined($max)
            and '' ne $max
            and ( $max !~ /^\d+$/ or $max < 1 );

        return $app->translate(
            "A maximum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to the minimum selection number.",
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

sub ss_validator_multiple {
    my ( $app, $field_data, $data, $type_label, $type_label_plural ) = @_;

    if ( !defined $type_label_plural ) {
        if ( defined $type_label ) {
            $type_label_plural = $type_label;
        }
        else {
            $type_label        = 'option';
            $type_label_plural = 'options';
        }
    }

    my $options = $field_data->{options} || {};

    my $field_label = $options->{label};
    my $multiple    = $options->{multiple};
    my $required    = $options->{required};
    my $max         = $options->{max};
    my $min         = $options->{min};

    if ( $multiple && $max && @{$data} > $max ) {
        return $app->translate(
            '[_1] less than or equal to [_2] must be selected in "[_3]" field.',
            ucfirst($type_label_plural), $max, $field_label
        );
    }
    elsif ( $multiple && $min && @{$data} < $min ) {
        return $app->translate(
            '[_1] greater than or equal to [_2] must be selected in "[_3]" field.',
            ucfirst($type_label_plural), $min, $field_label
        );
    }
    if ( !$multiple && @{$data} >= 2 ) {
        return $app->translate(
            'Only 1 [_1] can be selected in "[_2]" field.',
            lc($type_label), $field_label );
    }

    # Special case
    # Select Box accepts empty value if this field is not required.
    return if !$required && @$data == 1 && $data->[0] eq '';

    require MT::ContentFieldType::Common;
    exists $options->{values}
        ? MT::ContentFieldType::Common::ss_validator_values(@_)
        : undef;
}

1;

