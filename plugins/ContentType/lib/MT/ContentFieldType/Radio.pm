package MT::ContentFieldType::Radio;
use strict;
use warnings;

use MT::ContentField;

sub field_html {
    my ( $app, $id, $value ) = @_;
    $value = '' unless defined $value;
    my $content_field = MT::ContentField->load($id);
    my $options_values = $content_field->options->{values} || [];

    my $html  = '';
    my $count = 1;

    foreach my $options_value ( @{$options_values} ) {
        $html
            .= "<input type=\"radio\" name=\"content-field-$id\" id=\"content-field-$id-$count\" class=\"radio\" value=\""
            . $options_value->{value} . "\"";
        $html .= ' checked="checked"' if $options_value->{value} eq $value;
        $html .= ' mt:watch-change="1" mt:raw-name="1" />';
        $html .= " <label for=\"content-field-$id-$count\">"
            . $options_value->{key};
        $count++;
    }
    return $html;
}

1;

