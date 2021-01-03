# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType::Number;
use strict;
use warnings;

sub field_html_params {
    my ( $app, $field_data ) = @_;

    my $options = $field_data->{options};
    my $decimal_places = $options->{decimal_places} || 0;
    my $max_value
        = ( defined $options->{max_value} && $options->{max_value} ne '' )
        ? $options->{max_value}
        : $app->config->NumberFieldMaxValue;
    my $min_value
        = ( defined $options->{min_value} && $options->{min_value} ne '' )
        ? $options->{min_value}
        : $app->config->NumberFieldMinValue;

    my $required = $options->{required} ? 'required' : '';
    my $step = 1 / 10**$decimal_places;

    {   max      => qq{max="$max_value"},
        min      => qq{min="$min_value"},
        required => $required,
        step     => $step,
    };
}

sub ss_validator {
    my ( $app, $field_data, $data ) = @_;
    return undef
        unless defined $data
        && $data ne '';    # Do not check empty value here.

    my $options = $field_data->{options} || {};

    my $decimal_places = $options->{decimal_places} || 0;
    my $field_label = $options->{label};
    my $max_value
        = ( defined $options->{max_value} && $options->{max_value} ne '' )
        ? $options->{max_value}
        : $app->config->NumberFieldMaxValue;
    my $min_value
        = ( defined $options->{min_value} && $options->{min_value} ne '' )
        ? $options->{min_value}
        : $app->config->NumberFieldMinValue;

    if ( $data !~ /^[+\-]?\d+(\.\d+)?$/ ) {
        return $app->translate( '"[_1]" field value must be a number.',
            $field_label );
    }

    if ($decimal_places) {
        my ( $int, $frac ) = split /\./, $data;
        if ( length $frac > $decimal_places ) {
            my $trimmed_frac = substr $frac, 0, $decimal_places;
            my $trimmed_value = "${int}.${trimmed_frac}";
            if ( $trimmed_value != $data ) {
                return $app->translate(
                    '"[_1]" field value has invalid precision.',
                    $field_label );
            }
        }
    }
    else {
        if ( $data =~ /\./ ) {
            return $app->translate(
                '"[_1]" field value has invalid precision.', $field_label );
        }
    }

    if ( defined $max_value && $max_value ne '' ) {
        if ( $data > $max_value ) {
            return $app->translate(
                '"[_1]" field value must be less than or equal to [_2].',
                $field_label, $max_value );
        }
    }
    if ( defined $min_value && $min_value ne '' ) {
        if ( $data < $min_value ) {
            return $app->translate(
                '"[_1]" field value must be greater than or equal to [_2]',
                $field_label, $min_value );
        }
    }
}

sub options_validation_handler {
    my ( $app, $type, $label, $field_label, $options ) = @_;

    my $cfg_decimal_places = $app->config('NumberFieldDecimalPlaces');
    my $cfg_max_value      = $app->config('NumberFieldMaxValue');
    my $cfg_min_value      = $app->config('NumberFieldMinValue');

    my $decimal_places = $options->{decimal_places};
    if ($decimal_places) {
        return $app->translate(
            "Number of decimal places must be a positive integer.")
            unless $decimal_places =~ /^\d+$/;
        return $app->translate(
            "Number of decimal places must be a positive integer and between 0 and [_1].",
            $cfg_decimal_places
        ) if $decimal_places > $cfg_decimal_places;
    }

    my $valid_min;
    my $min_value = $options->{min_value};
    if ($min_value) {
        $min_value =~ /^[+\-]?\d+(\.\d+)?$/;

        return $app->translate(
            "A minimum value must be an integer, or must be set with decimal places to use decimal value."
        ) if !$decimal_places and defined $1;

        return $app->translate(
            "A minimum value must be an integer and between [_1] and [_2]",
            $cfg_min_value, $cfg_max_value )
            if $min_value < $cfg_min_value || $min_value > $cfg_max_value;

        $valid_min = $min_value;
    }

    my $valid_max;
    my $max_value = $options->{max_value};
    if ($max_value) {
        $max_value =~ /^[+\-]?\d+(\.\d+)?$/;

        return $app->translate(
            "A maximum value must be an integer, or must be set with decimal places to use decimal value."
        ) if !$decimal_places and defined $1;

        return $app->translate(
            "A maximum value must be an integer and between [_1] and [_2]",
            $cfg_min_value, $cfg_max_value )
            if $max_value < $cfg_min_value || $max_value > $cfg_max_value;

        $valid_max = $max_value;
    }

    if ( $valid_min and $valid_max and $valid_min > $valid_max ) {
        return $app->translate(
            '"[_1]" field value must be less than or equal to [_2].',
            $label, $valid_max );
    }

    my $initial_value = $options->{initial_value};
    if ($initial_value) {
        $initial_value =~ /^[+\-]?\d+(\.\d+)?$/;

        return $app->translate(
            "An initial value must be an integer, or must be set with decimal places to use decimal value."
        ) if !$decimal_places and defined $1;

        my $min = '' ne $min_value ? $min_value : $cfg_min_value;
        my $max = '' ne $max_value ? $max_value : $cfg_max_value;

        return $app->translate(
            "An initial value must be an integer and between [_1] and [_2]",
            $min, $max )
            if $initial_value < $min || $initial_value > $max;
    }

    return;
}

1;

