package MT::ContentFieldType::Video;
use strict;
use warnings;

use MT::ContentFieldType::AssetCommon qw( data_getter_common );

sub data_getter {
    my ( $app, $field_id ) = @_;
    data_getter_common( $app, $field_id, 'video' );
}

1;

