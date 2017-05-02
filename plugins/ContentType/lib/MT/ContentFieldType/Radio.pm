package MT::ContentFieldType::Radio;
use strict;
use warnings;

use MT::ContentField;

sub field_html {
    my ( $app, $id, $value ) = @_;
    $value = '' unless defined $value;
    my $content_field = MT::ContentField->load($id);
    my $options = $content_field->options->{options} || '';
    my $options_delimiter
        = quotemeta(
        $app->registry('content_field_types')->{radio}{options_delimiter}
            || ',' );
    my @options = split $options_delimiter, $options;
    my $html    = '';
    my $count   = 1;

    foreach my $option (@options) {
        $html
            .= "<input type=\"radio\" name=\"content-field-$id\" id=\"content-field-$id-$count\" class=\"radio\" value=\"$option\"";
        $html .= ' checked="checked"' if $option eq $value;
        $html .= ' />';
        $html .= " <label for=\"content-field-$id-$count\">$option ";
        $count++;
    }
    return $html;
}

sub single_select_options {
    my $prop = shift;
    my $app = shift || MT->app;

    my $content_field_id = $prop->{content_field_id};
    my $content_field    = MT::ContentField->load($content_field_id);
    my $options_delimiter
        = quotemeta(
        $app->registry('content_field_types')->{radio}{options_delimiter}
            || ',' );
    my @options = split $options_delimiter,
        $content_field->options->{options} || '';

    [ map { +{ label => $_, value => $_ } } @options ];
}

1;

