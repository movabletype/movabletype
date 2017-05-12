package MT::ContentFieldType::URL;
use strict;
use warnings;

use MT;
use MT::ContentField;
use MT::Util ();

sub field_html {
    my ( $app, $field_id, $value ) = @_;
    $value = '' unless defined $value;

    my $content_field = MT::ContentField->load($field_id);
    my $options       = $content_field->options;
    my $field_label   = $options->{label};
    my $required      = $options->{required} ? 'required' : '';

    my $error_message
        = $app->translate( '"[_1]" field is invalid URL', $field_label );

    my $html
        = qq{<input type="text" name="content-field-${field_id}" class="text long" value="${value}" mt:watch-change="1" mt:raw-name="1" ${required}/>};

    $html .= <<"__JS__";
<script>
(function () {
  var url = jQuery('input[name=content-field-${field_id}]').get(0);

  function validateUrl () {
    if (jQuery.mtValidateRules['.url'](jQuery(url))) {
      url.setCustomValidity('');
    } else {
      url.setCustomValidity('${error_message}');
    }
  }

  jQuery(url).on('change', validateUrl);

  validateUrl();
})();
</script>
__JS__

    $html;
}

sub ss_validator {
    my ( $app, $id ) = @_;
    my $q   = $app->param;
    my $str = $q->param( 'content-field-' . $id );

    # TODO: should check "require" option here.
    if ( !defined $str || $str eq '' || MT::Util::is_url($str) ) {
        return $str;
    }
    else {
        my $err = MT->translate( "Invalid URL: '[_1]'", $str );
        return $app->error($err) if $err && $app;
    }
}

1;

