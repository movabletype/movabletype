# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Callback::ContentType;
use strict;
use warnings;

sub save_filter {
    my ( $eh, $app, $obj, $original ) = @_;

    if ( $obj->is_name_empty ) {
        return $app->error(
            $app->translate( 'A parameter "[_1]" is required.', 'name' ) );
    }

    if ( $obj->exist_same_name_in_site ) {
        return $app->error(
            $app->translate(
                'Name "[_1]" is used in the same site.',
                $obj->name
            )
        );
    }

    1;
}

1;

