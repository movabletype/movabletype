package BlockEditor::BackupRestore;
use strict;
use warnings;

use MT::Util;

sub update_cd_block_editor_data {
    my $class = shift;
    my ( $cd, $all_objects ) = @_;

    my $old_data = eval { MT::Util::from_json( $cd->block_editor_data ) };
    return unless $old_data && ref $old_data eq 'HASH' && %$old_data;

    my %new_data;
    for my $old_field_key ( keys %$old_data ) {
        my ($old_field_id)
            = $old_field_key
            =~ /^editor-input-content-field-(\d+)-blockeditor$/;
        next unless $old_field_id;

        my $new_field = $all_objects->{"MT::ContentField#$old_field_id"}
            or next;

        my $new_field_key
            = 'editor-input-content-field-' . $new_field->id . '-blockeditor';
        $new_data{$new_field_key} = $old_data->{$old_field_key};
    }

    if (%new_data) {
        my $new_json_data = MT::Util::to_json( \%new_data );
        $cd->block_editor_data($new_json_data);
    }
}

1;

