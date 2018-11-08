# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::CMS::Debug;
use strict;
use warnings;

use MT::Debug::GitInfo;

sub vcs_revision {
    my $app = shift;

    unless ( $app->request_method eq 'POST' ) {
        return $app->json_error( $app->translate('Invalid request.'), 400 );
    }

    $app->json_result( { vcs_revision => MT::Debug::GitInfo->vcs_revision } );
}

1;

