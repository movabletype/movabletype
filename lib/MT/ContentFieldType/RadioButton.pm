# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType::RadioButton;
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

    my $options_values = $field_data->{options}{values} || [];

    @$options_values = map {
        {   l => $_->{label},
            v => $_->{value},
            $values{ $_->{value} }
            ? ( checked => 'checked="checked"' )
            : (),
        }
    } @$options_values;

    my $required = $field_data->{options}{required} ? 'required' : '';

    {   options_values => $options_values,
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
            unless defined $value->{label};

        return $app->translate("A value of values is required.")
            unless defined $value->{value};
    }

    return;
}

1;

