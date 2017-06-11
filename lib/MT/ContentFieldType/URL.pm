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

1;

