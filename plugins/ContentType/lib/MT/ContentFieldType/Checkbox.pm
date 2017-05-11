package MT::ContentFieldType::Checkbox;
use strict;
use warnings;

use MT;
use MT::ContentField;

sub field_html {
    my ( $app, $id, $value ) = @_;
    $value = ''       unless defined $value;
    $value = [$value] unless ref $value eq 'ARRAY';

    my $content_field = MT::ContentField->load($id);
    my $options_values = $content_field->options->{values} || [];

    my $html  = '';
    my $count = 1;

    foreach my $options_value ( @{$options_values} ) {
        $html
            .= "<input type=\"checkbox\" name=\"content-field-$id\" id=\"content-field-$id-$count\" class=\"radio\" value=\""
            . $options_value->{value} . "\"";
        $html .=
            ( grep { $_ eq $options_value->{value} } @$value )
            ? ' checked="checked"'
            : '';
        $html .= " mt:watch-change=\"1\" mt:raw-name=\"1\" />";
        $html .= " <label for=\"content-field-$id-$count\" >"
            . $options_value->{key};
        $html .= '</label>';
        $count++;
    }

    if ( $content_field->options->{required} ) {
        my $error_message
            = $app->translate('Please select one of these options.');
        $html .= <<"__JS__";
<script>
var \$checkboxes = jQuery('input[name=content-field-${id}]');

function validateCheckboxes () {
  if (\$checkboxes.filter(':checked').length === 0) {
    \$checkboxes.get(0).setCustomValidity('${error_message}');
  } else {
    \$checkboxes.get(0).setCustomValidity('');
  }
}

\$checkboxes.on('change', validateCheckboxes);

validateCheckboxes();
</script>
__JS__
    }

    return $html;
}

sub data_getter {
    my ( $app, $id ) = @_;
    my @data = $app->param("content-field-${id}");
    \@data;
}

1;

