package MT::ContentFieldType::Integer;
use strict;
use warnings;

use MT::ContentFieldType::Common;

sub ss_validator {
    my ( $app, $field_data, $data ) = @_;
    return undef
        unless defined $data
        && $data ne '';    # Do not check empty value here.

    my $options = $field_data->{options} || {};
    my $field_label = $options->{label};

    if ( $data !~ /^[+\-]?\d+$/ ) {
        return $app->translate( '"[_1]" field value must be integer.',
            $field_label );
    }

    MT::ContentFieldType::Common::ss_validator_number_common(@_);
}

1;

