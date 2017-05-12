package MT::ContentFieldType::Float;
use strict;
use warnings;

use MT::ContentField;

sub field_html {
    my ( $app, $field_id, $value ) = @_;
    $value = '' unless defined $value;

    my $content_field  = MT::ContentField->load($field_id);
    my $options        = $content_field->options;
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

    qq{<input type="number" step="${step}" name="content-field-${field_id}" class="text short" value="${value}" mt:watch-change="1" mt:raw-name="1" ${required} ${max} ${min} style="width: 8em"/>};
}

1;

