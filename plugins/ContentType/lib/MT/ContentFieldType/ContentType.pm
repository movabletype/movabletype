package MT::ContentFieldType::ContentType;
use strict;
use warnings;

use MT::ContentField;
use MT::ContentType;
use MT::ContentData;

sub field_html {
    my ( $app, $field_id, $value ) = @_;
    if ( !defined $value ) {
        $value = [];
    }
    elsif ( ref $value ne 'ARRAY' ) {
        $value = [$value];
    }

    my $content_field = MT::ContentField->load($field_id);
    my $ct_id         = $content_field->related_content_type_id;
    my @ct_datas = MT::ContentData->load( { content_type_id => $ct_id } );
    my $html     = '';
    my $num      = 1;

    foreach my $ct_data (@ct_datas) {
        my $ct_data_id = $ct_data->id;
        my $label      = $ct_data->label;
        if ( !defined $label || $label eq '' ) {
            $label = "(id:${ct_data_id})";
        }

        $html .= '<div>';
        $html
            .= "<input type=\"checkbox\" name=\"content-field-$field_id\" id=\"content-field-$field_id-$num\" value=\"$ct_data_id\"";
        $html .=
            ( grep { $_ eq $ct_data_id } @$value )
            ? ' checked="checked"'
            : '';
        $html .= " />";
        $html
            .= " <label for=\"content-field-$field_id-$num\">$label</label>";
        $html .= '</div>';
        $num++;
    }
    return $html;
}

sub data_getter {
    my ( $app, $field_id ) = @_;
    my @data = $app->param( 'content-field-' . $field_id );
    \@data;
}

1;

