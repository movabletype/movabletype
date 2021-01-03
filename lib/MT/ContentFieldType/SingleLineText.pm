# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType::SingleLineText;
use strict;
use warnings;

use MT::I18N qw( first_n_text const );

my $varchar_size = 255;

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $required = $field_data->{options}{required} ? 'required' : '';
    my $max_length = $field_data->{options}{max_length} ||= $varchar_size;
    $max_length = qq{maxlength="${max_length}"};
    my $min_length_class = '';
    my $min_length_data  = '';
    if ( my $ml = $field_data->{options}{min_length} ) {
        $min_length_class = 'min-length';
        $min_length_data  = qq{data-mt-min-length="${ml}"};
    }

    {   required         => $required,
        max_length       => $max_length,
        min_length_class => $min_length_class,
        min_length_data  => $min_length_data,
    };
}

sub ss_validator {
    my ( $app, $field_data, $data ) = @_;
    $data = '' unless defined $data && $data ne '';

    my $options    = $field_data->{options} || {};
    my $max_length = $options->{max_length} || $varchar_size;
    my $min_length = $options->{min_length};
    my $field_label = $options->{label};

    if ( defined $min_length && $min_length > $max_length ) {
        return $app->translate(
            '"[_1]" field value must be less than or equal to [_2].',
            $field_label, $max_length );
    }

    if ( $max_length && length $data > $max_length ) {
        return $app->translate( '"[_1]" field is too long.', $field_label );
    }
    if ( $min_length && length $data < $min_length ) {
        return $app->translate( '"[_1]" field is too short.', $field_label );
    }

    undef;
}

sub options_validation_handler {
    my ( $app, $type, $label, $field_label, $options ) = @_;

    my $valid_min;
    my $min_length = $options->{min_length};
    if ( defined $min_length and $min_length ne '' ) {
        if (   $min_length !~ /^\d+$/
            or $min_length < 0
            or $min_length > $varchar_size )
        {
            return $app->translate(
                "A minimum length number for '[_1]' ([_2]) must be a positive integer between 0 and [_3].",
                $label, $field_label, $varchar_size );
        }
        else {
            $valid_min = $min_length;
        }
    }

    my $valid_max;
    my $max_length = $options->{max_length};
    if ( defined $max_length and $max_length ne '' ) {
        if (   $max_length !~ /^\d+$/
            or $max_length < 1
            or $max_length > $varchar_size )
        {
            return $app->translate(
                "A maximum length number for '[_1]' ([_2]) must be a positive integer between 1 and [_3].",
                $label, $field_label, $varchar_size );
        }
        else {
            $valid_max = $max_length;
        }
    }

    if ( $valid_min and $valid_max and $valid_min > $valid_max ) {
        return $app->translate(
            '"[_1]" field value must be less than or equal to [_2].',
            $label, $valid_max );
    }

    my $initial_value = $options->{initial_value};
    if ($initial_value) {
        my $max = '' ne $max_length ? $max_length : $varchar_size;
        if ( length($initial_value) > $max ) {
            return $app->translate(
                "An initial value for '[_1]' ([_2]) must be shorter than [_3] characters",
                $label, $field_label, $max );
        }
    }

    return;
}

sub field_value_handler {
    my ( $ctx, $args, $cond, $field_data, $value ) = @_;
    return exists $args->{words}
        ? first_n_text( $value, $args->{words} )
        : $value;
}

1;

