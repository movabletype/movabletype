package MT::ContentFieldType::Checkbox;
use strict;
use warnings;

use MT;
use MT::ContentField;

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value};
    $value = ''       unless defined $value;
    $value = [$value] unless ref $value eq 'ARRAY';

    my %values;
    if ( ref $value eq 'ARRAY' ) {
        %values = map { $_ => 1 } @{$value};
    }
    else {
        $values{$value} = 1;
    }

    my $options = $field_data->{options};
    my $options_values = $options->{values} || [];
    @{$options_values} = map {
        {   k => $_->{key},
            v => $_->{value},
            $values{ $_->{value} } ? ( checked => 'checked="checked"' ) : (),
        }
    } @{$options_values};

    my $multiple       = '';
    my $multiple_class = '';
    if ( $options->{multiple} ) {
        my $max = $options->{max};
        my $min = $options->{min};
        $multiple = 'data-mt-multiple="1"';
        $multiple .= qq{ data-mt-max-select="${max}"} if $max;
        $multiple .= qq{ data-mt-min-select="${min}"} if $min;
        $multiple_class = 'multiple-checkbox';
    }

    my $required = $options->{required} ? 'data-mt-required="1"' : '';

    {   multiple       => $multiple,
        mutliple_class => $multiple_class,
        options_values => $options_values,
        required       => $required,
    };
}

sub field_html {
    my ( $app, $id, $value ) = @_;
    $value = ''       unless defined $value;
    $value = [$value] unless ref $value eq 'ARRAY';

    my $content_field  = MT::ContentField->load($id);
    my $options        = $content_field->options;
    my $options_values = $options->{values} || [];
    my $max            = $options->{max} || 0;
    my $min            = $options->{min} || 0;

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

    my $multiple = $options->{multiple} ? 'true' : 'false';
    my $required = $options->{required} ? 'true' : 'false';

    my $required_error
        = $app->translate('Please select one of these options.');
    my $not_multiple_error
        = $app->translate('Only 1 checkbox can be selected.');
    my $max_error = $app->translate(
        'Options less than or equal to [_1] must be selected.', $max );
    my $min_error = $app->translate(
        'Options greater than or equal to [_1]  must be selected.', $min );

    $html .= <<"__JS__";
<script>
(function () {
  var required = ${required};
  var multiple = ${multiple};
  var max      = ${max};
  var min      = ${min};

  var \$checkboxes = jQuery('input[name=content-field-${id}]');

  function validateCheckboxes () {
    var checkedLength = \$checkboxes.filter(':checked').length;
    if (required && checkedLength === 0) {
      \$checkboxes.get(0).setCustomValidity('${required_error}');
    } else if (!multiple && checkedLength >= 2) {
      \$checkboxes.get(0).setCustomValidity('${not_multiple_error}');
    } else if (multiple && max && checkedLength > max) {
      \$checkboxes.get(0).setCustomValidity('${max_error}');
    } else if (multiple && min && checkedLength < min) {
      \$checkboxes.get(0).setCustomValidity('${min_error}');
    } else {
      \$checkboxes.get(0).setCustomValidity('');
    }
  }

  \$checkboxes.on('change', validateCheckboxes);

  validateCheckboxes();
})();
</script>
__JS__

    return $html;
}

sub data_getter {
    my ( $app, $id ) = @_;
    my @data = $app->param("content-field-${id}");
    \@data;
}

sub ss_validator {
    my ( $app, $field_id ) = @_;
    my @values = $app->param("content-field-${field_id}");

    my $content_field = MT::ContentField->load($field_id);
    my $options       = $content_field->options;

    my $field_label = $options->{label};
    my $multiple    = $options->{multiple};
    my $max         = $options->{max};
    my $min         = $options->{min};

    if ($multiple) {
        if ( $max && @values > $max ) {
            return $app->errtrans(
                'Options less than or equal to [_1] must be selected in "[_2]" field.',
                $max, $field_label
            );
        }
        elsif ( $min && @values < $min ) {
            return $app->errtrans(
                'Options greater than or equal to [_1] must be selected in "[_2]" field.',
                $min, $field_label
            );
        }
    }
    else {
        if ( @values >= 2 ) {
            return $app->errtrans(
                'Only 1 checkbox can be selected in "[_1]" field.',
                $field_label );
        }
    }
}

1;

