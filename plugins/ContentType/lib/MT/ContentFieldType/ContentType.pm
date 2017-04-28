package MT::ContentFieldType::ContentType;
use strict;
use warnings;

use MT::ContentField;
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
        my $edit_link = $ct_data->edit_link($app);

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
        $html .= qq{ (<a href="${edit_link}">edit</a>)};
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

sub html {
    my $prop = shift;
    my ( $content_data, $app, $opts ) = @_;

    my $child_cd_ids = $content_data->data->{ $prop->content_field_id } || [];

    my %child_cd = map { $_->id => $_ }
        MT::ContentData->load( { id => $child_cd_ids } );
    my @child_cd = map { $child_cd{$_} } @$child_cd_ids;

    my @cd_links;
    for my $cd (@child_cd) {
        my $label     = $cd->label;
        my $edit_link = $cd->edit_link($app);
        push @cd_links, qq{<a href="${edit_link}">${label}</a>};
    }

    join ', ', @cd_links;
}

1;

