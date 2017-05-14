package MT::ContentFieldType::Radio;
use strict;
use warnings;

use MT::ContentField;

sub field_html_params {
    my ( $app, $field_id, $value ) = @_;
    my $content_field = MT::ContentField->load($field_id);
    my $options_values = $content_field->options->{values} || [];
    @{$options_values}
        = map { { k => $_->{key}, v => $_->{value} } } @{$options_values};
    { options_values => $options_values };
}

1;

