package MT::ContentFieldType::Float;
use strict;
use warnings;

use MT::ContentFieldType::Common;

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
    my ( $app, $field_data, $data ) = @_;
    return undef
        unless defined $data
        && $data ne '';    # Do not check empty value here.

    my $options = $field_data->{options} || {};

    my $decimal_places = $options->{decimal_places} || 0;
    my $field_label = $options->{label};

    if ( $data !~ /^[+\-]?\d+(\.\d+)?$/ ) {
        return $app->translate( '"[_1]" field value must be float.',
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

    MT::ContentFieldType::Common::ss_validator_common(@_);
}

1;

