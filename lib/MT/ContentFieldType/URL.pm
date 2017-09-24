package MT::ContentFieldType::URL;
use strict;
use warnings;

use MT::Util ();

sub ss_validator {
    my ( $app, $field_data, $data ) = @_;

    my $options = $field_data->{options} || {};
    my $field_label = $options->{label};

    unless ( !defined $data || $data eq '' || MT::Util::is_url($data) ) {
        return $app->translate( 'Invalid URL in "[_1]" field.',
            $field_label );
    }

    undef;
}

sub options_validation_handler {
    my ( $app, $type, $label, $field_label, $options ) = @_;

    my $initial_value = $options->{initial_value};
    if ( defined $initial_value and $initial_value ne '' ) {
        return $app->translate(
            "An initial value of '[_1]' ([_2]) must be shorter than 2000 characters",
            $label, $field_label
        ) if length($initial_value) > 2000;

        return $app->translate(
            "An initial value of '[_1]' ([_2]) is invalid URL.",
            $label, $field_label
        ) if !MT::Util::is_url($initial_value);
    }

    return;
}

1;

