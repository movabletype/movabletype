package MT::ContentFieldType::SingleLineText;
use strict;
use warnings;

use MT::ContentField;

sub field_html {
    my ( $app, $field_id, $value ) = @_;
    $value = '' unless defined $value;

    my $content_field = MT::ContentField->load($field_id);

    my $max_length = $content_field->options->{max_length};
    $max_length = $max_length ? qq{maxlength="${max_length}"} : '';
    my $required = $content_field->options->{required} ? 'required' : '';

    my $html
        = qq{<input type="text" name="content-field-${field_id}" class="text long" value="${value}" mt:watch-change="1" mt:raw-name="1" ${required} ${max_length} />};

    if ( my $min_length = $content_field->options->{min_length} ) {
        $html .= <<"__JS__";
<script>
(function () {
  jQuery('input[name=content-field-${field_id}]').on('keyup', function () {
    if (this.value.length < ${min_length}) {
      this.setCustomValidity(`Please input ${min_length} characters or more.`);
    } else {
      this.setCustomValidity('');
    }
  });
})();
</script>
__JS__
    }

    $html;
}

sub ss_validator {
    my ( $app, $field_id ) = @_;
    my $value = $app->param("content-field-${field_id}");
    $value = '' unless defined $value;

    my $content_field = MT::ContentField->load($field_id);
    my $field_label   = $content_field->options->{label};

    if ( my $max_length = $content_field->options->{max_length} ) {
        if ( length $value > $max_length ) {
            return $app->errtrans( '"[_1]" field is too long.',
                $field_label );
        }
    }
    if ( my $min_length = $content_field->options->{min_length} ) {
        if ( length $value < $min_length ) {
            return $app->errtrans( '"[_1]" field is too short.',
                $field_label );
        }
    }
}

1;

