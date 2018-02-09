# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v4::Publish;
use strict;
use warnings;

use MT::App::CMS;
use MT::DataAPI::Endpoint::Publish;

sub content_data {
    my ( $app, $endpoint ) = @_;
    MT::DataAPI::Endpoint::Publish::publish_common( $app, $endpoint,
        \&MT::App::CMS::rebuild_these_content_data );
}

1;

