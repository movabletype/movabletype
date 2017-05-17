package MT::ContentFieldType::Float;
use strict;
use warnings;

use MT::ContentField;

sub field_html_params {
    my ( $app, $field_data ) = @_;

    my $options        = $field_data->{options};
    my $decimal_places = $options->{decimal_places} || 0;
    my $max_value      = $options->{max_value};
    my $min_value      = $options->{min_value};

    my $max
        = ( defined $max_value && $max_value ne '' )
        ? qq{max="${max_value}"}
        : '';
    my $min
        = ( defined $min_value && $min_value ne '' )
        ? qq{min="${min_value}"}
        : '';
    my $required = $options->{required} ? 'required' : '';
    my $step = $decimal_places ? ( 1 / 10**$decimal_places ) : 'any';

    {   max      => $max,
        min      => $min,
        required => $required,
        step     => $step,
    };
}

sub ss_validator {
    my ( $app, $field_id ) = @_;
    my $value = $app->param("content-field-${field_id}");
    return
        unless defined $value
        && $value ne '';    # Do not check empty value here.

    my $content_field = MT::ContentField->load($field_id);
    my $options       = $content_field->options;

    my $decimal_places = $options->{decimal_places} || 0;
    my $field_label    = $options->{label};
    my $max_value      = $options->{max_value};
    my $min_value      = $options->{min_value};

    if ( $value !~ /^[+\-]?\d+(\.\d+)?$/ ) {
        return $app->errtrans( '"[_1]" field value must be float.',
            $field_label );
    }

    if ($decimal_places) {
        my ( $int, $frac ) = split /\./, $value;
        if ( length $frac > $decimal_places ) {
            my $trimmed_frac = substr $frac, 0, $decimal_places;
            my $trimmed_value = "${int}.${trimmed_frac}";
            if ( $trimmed_value != $value ) {
                return $app->errtrans(
                    '"[_1]" field value has invalid precision.',
                    $field_label );
            }
        }
    }

    if ( defined $max_value && $max_value ne '' ) {
        if ( $value > $max_value ) {
            return $app->errtrans(
                '"[_1]" field value must be less than or equal to [_2].',
                $field_label, $max_value );
        }
    }

    if ( defined $min_value && $min_value ne '' ) {
        if ( $value < $min_value ) {
            return $app->errtrans(
                '"[_1]" field value must be greater than or equal to [_2]',
                $field_label, $min_value );
        }
    }
}

1;

