package MT::ContentFieldType::SelectBox;
use strict;
use warnings;

use MT;
use MT::ContentField;
use MT::ContentFieldIndex;

sub terms {
    my $prop = shift;
    my ( $args, $base_terms, $base_args, $opts ) = @_;

    my $val = $args->{value};
    if ( $args->{option} && $args->{option} eq 'is_not' ) {
        $val = { not => $val };
    }

    $base_args->{joins} ||= [];

    push @{ $base_args->{joins} },
        MT::ContentFieldIndex->join_on(
        undef,
        {   content_data_id  => \'= cd_id',
            content_field_id => $prop->{content_field_id},
            value_varchar    => $val,
        }
        );
}

sub filter_tmpl {
    return <<'__TMPL__';
<mt:setvarblock name="select_options">
<select class="<mt:var name="type">-option">
  <option value="is"><__trans phrase="is" escape="js"></option>
  <option value="is_not"><__trans phrase="is not" escape="js"></option>
</select>
</mt:setvarblock>
<__trans phrase="[_1] [_3] [_2]"
         params="<mt:var name="label" escape="js">%%
                 <select class="<mt:var name="type">-value">
                 <mt:loop name="single_select_options">
                   <option value="<mt:var name="value">"><mt:var name="label" encode_html="1" encode_js="1" encode_html="1" ></option>
                 </mt:loop>
                 </select>%%<mt:var name="select_options">">
__TMPL__
}

sub field_html {
    my ( $app, $id, $value ) = @_;

    my %values;
    if ( ref $value eq 'ARRAY' ) {
        %values = map { $_ => 1 } @$value;
    }
    else {
        $values{$value} = 1;
    }

    my $content_field = MT::ContentField->load($id);

    my $options = $content_field->options;
    my $options_delimiter
        = quotemeta(
        $app->registry('content_field_types')->{select_box}{options_delimiter}
            || ',' );
    my @options = split $options_delimiter, $options;

    # TODO: Fix $content_field->options
    my $multiple = eval { $content_field->options->{multiple} };

    my $html
        = '<select name="content-field-'
        . $id
        . '" id="content-field-'
        . $id
        . '" class="select"';
    $html .= ' multiple style="min-width: 5em; min-height: 5em;"'
        if $multiple;
    $html .= '>';
    foreach my $option (@options) {
        $html .= '<option value="' . $option . '"';
        $html .= ' selected="selected"'
            if $values{$option};
        $html .= '>' . $option . '</option>';
    }
    $html .= '</select>';

    return $html;
}

sub single_select_options {
    my $prop = shift;
    my $app = shift || MT->app;

    my $content_field_id = $prop->{content_field_id};
    my $content_field    = MT::ContentField->load($content_field_id);
    my $options_delimiter
        = quotemeta(
        $app->registry('content_field_types')->{select_box}{options_delimiter}
            || ',' );
    my @options = split $options_delimiter, $content_field->options;

    [ map { +{ label => $_, value => $_ } } @options ];
}

sub data_getter {
    my ( $app, $id ) = @_;
    my @options       = $app->param("content-field-${id}");
    my $content_field = MT::ContentField->load($id);

    # TODO: Fix $content_field->options
    my $multiple = eval { $content_field->options->{multiple} };

    $multiple ? \@options : @options ? $options[0] : undef;
}

1;

