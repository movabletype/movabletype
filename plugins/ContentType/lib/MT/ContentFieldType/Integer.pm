package MT::ContentFieldType::Integer;
use strict;
use warnings;

sub ss_validator {
    my ( $app, $field_data, $data ) = @_;
    return undef
        unless defined $data
        && $data ne '';    # Do not check empty value here.

    my $options = $field_data->{options} || {};

    my $field_label = $options->{label};
    my $max_value   = $options->{max_value};
    my $min_value   = $options->{min_value};

    if ( $data !~ /^[+\-]?\d+$/ ) {
        return $app->translate( '"[_1]" field value must be integer.',
            $field_label );
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

    undef;
}

1;

