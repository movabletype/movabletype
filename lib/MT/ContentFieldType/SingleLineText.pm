# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType::SingleLineText;
use strict;
use warnings;

use MT::I18N qw( first_n_text const );

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $required = $field_data->{options}{required} ? 'required' : '';
    my $max_length = $field_data->{options}{max_length};
    if ( my $ml = $field_data->{options}{max_length} ) {
        $max_length = qq{maxlength="${ml}"};
    }
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

    my $options     = $field_data->{options} || {};
    my $max_length  = $options->{max_length};
    my $min_length  = $options->{min_length};
    my $field_label = $options->{label};

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

    my $min_length = $options->{min_length};
    if ( defined $min_length and $min_length ne '' ) {
        if (   $min_length !~ /^\d+$/
            or $min_length < 0
            or $min_length > 1024 )
        {
            return $app->translate(
                "A number of minimum length of '[_1]' ([_2]) must be a positive integer between 0 and 1024.",
                $label, $field_label
            );
        }
    }

    my $max_length = $options->{max_length};
    if ( defined $max_length and $max_length ne '' ) {
        if (   $max_length !~ /^\d+$/
            or $max_length < 1
            or $max_length > 1024 )
        {
            return $app->translate(
                "A number of maximum length of '[_1]' ([_2]) must be a positive integer between 1 and 1024.",
                $label, $field_label
            );
        }
    }

    my $initial_value = $options->{initial_value};
    if ($initial_value) {
        my $max = '' ne $max_length ? $max_length : 1024;
        if ( length($initial_value) > $max ) {
            return $app->translate(
                "An initial value of '[_1]' ([_2]) must be shorter than [_3] characters",
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

