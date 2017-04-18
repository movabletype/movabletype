package MT::ContentFieldType::ContentType;
use strict;
use warnings;

use MT::ContentField;
use MT::ContentType;
use MT::ContentData;

sub field_html {
    my ( $app, $id, $value ) = @_;
    my @values        = split ',', $value;
    my $content_field = MT::ContentField->load($id);
    my $ct_id         = $content_field->related_content_type_id;
    my $ct            = MT::ContentType->load($ct_id);
    my ($label_field) = grep { $_->{label} } @{ $ct->fields };
    my @ct_datas = MT::ContentData->load( { content_type_id => $ct_id } );
    my $html     = '';
    my $num      = 1;
    foreach my $ct_data (@ct_datas) {
        my $ct_data_id = $ct_data->id;
        my $label      = $ct_data->data->{ $label_field->{id} };
        $html .= '<div>';
        $html
            .= "<input type=\"checkbox\" name=\"content-field-$id\" id=\"content-field-$id-$num\" value=\"$ct_data_id\"";
        $html .=
            ( grep { $_ eq $ct_data_id } @values )
            ? ' checked="checked"'
            : '';
        $html .= " />";
        $html .= " <label for=\"content-field-$id-$num\">$label</label>";
        $html .= '</div>';
        $num++;
    }
    return $html;
}

sub data_getter {
    my ( $app, $id ) = @_;
    my $q     = $app->param;
    my @datas = $q->param( 'content-field-' . $id );
    return join ',', @datas;
}

1;

