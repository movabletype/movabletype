package MT::ContentFieldType::MultiLineText;
use strict;
use warnings;

sub theme_data_import_handler {
    my ( $theme, $blog, $ct, $cf_type, $field, $field_data, $data,
        $convert_breaks )
        = @_;

    if ( ref $field_data eq 'HASH' ) {
        $convert_breaks->{ $field->{id} } = $field_data->{convert_breaks};
    }
}

1;
