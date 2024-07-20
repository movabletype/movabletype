package CopyThisContentData::Callback;
use strict;
use warnings;

use JSON ();

use MT::Serialize;

sub pre_run {
    my ( $cb, $app ) = @_;
    return
        unless ( $app->param('__mode') || '' ) eq 'view'
        && ( $app->param('_type') || '' ) eq 'content_data';

    my $orig_id = $app->param('origin') or return;
    my $origin = $app->model('content_data')->load($orig_id) or return;

    $app->param( 'reedit', 1 );

    my $serialized_data = JSON::encode_json( $origin->data );
    $app->param( 'serialized_data', $serialized_data );

    if (my $convert_breaks = MT::Serialize->unserialize($origin->convert_breaks)) {
        for my $content_field_id (keys %{$$convert_breaks}) {
            my $key = "content-field-${content_field_id}_convert_breaks";
            $app->param($key, $$convert_breaks->{$content_field_id});
        }
    }
}

1;

