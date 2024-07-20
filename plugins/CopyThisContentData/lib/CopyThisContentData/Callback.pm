package CopyThisContentData::Callback;
use strict;
use warnings;

use JSON ();

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
}

1;

