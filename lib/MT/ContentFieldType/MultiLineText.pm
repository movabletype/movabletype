package MT::ContentFieldType::MultiLineText;
use strict;
use warnings;
use MT::Util ();
use JSON     ();
use Data::Dumper;

sub data_getter {
    my ( $app, $field_data ) = @_;
    my $field_id         = $field_data->{id};
    my $blockeditor_data = $app->param('blockeditor-data');
    my $data;
    my $html = "";
    if ($blockeditor_data) {
        $data = JSON::decode_json( MT::Util::decode_url($blockeditor_data) );
        my $editor_id = 'editor-input-content-field-' . $field_id;
        while (my ($block_id, $block_data) = each(%{$data->{ $editor_id }})){
            $html .= $block_data->{html};
        }
    }
    return $html;
}

1;

