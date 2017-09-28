package MT::ContentFieldType::MultiLineText;
use strict;
use warnings;

use JSON ();

sub theme_data_import_handler {
    my ( $theme, $blog, $ct, $cf_type, $field, $field_data, $data,
        $convert_breaks )
        = @_;

    if ( ref $field_data eq 'HASH' ) {
        $convert_breaks->{ $field->{id} } = $field_data->{convert_breaks};
    }
}

sub data_load_handler {
    my ( $app, $field_data ) = @_;
    my $field_id = $field_data->{id};
    my $convert_breaks
        = $app->param("content-field-${field_id}_convert_breaks");
    $convert_breaks = '' unless defined $convert_breaks;

    if ( $convert_breaks eq 'blockeditor' ) {
        my $data_json = $app->param('blockeditor-data');
        my $data_obj;
        my $html = "";
        my @blockdata;
        if ($data_json) {
            $data_obj = JSON->new->utf8(0)->decode($data_json);
            my $editor_id = 'editor-input-content-field-' . $field_id;
            while ( my ( $block_id, $block_data )
                = each( %{ $data_obj->{$editor_id} } ) )
            {
                push( @blockdata, $block_data );
            }
            @blockdata = sort { $a->{order} <=> $b->{order} } @blockdata;
            foreach my $val (@blockdata) {
                $html .= $val->{html};
            }
        }
        return $html;
    }
    elsif ( $convert_breaks eq 'richtext' ) {
        return scalar $app->param("editor-input-content-field-$field_id");
    }
    else {
        return scalar $app->param("content-field-multi-$field_id");
    }

}

1;
