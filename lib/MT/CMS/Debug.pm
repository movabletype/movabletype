package MT::CMS::Debug;
use strict;
use warnings;

use MT::Debug::GitInfo;

sub svn_revision {
    my $app = shift;

    unless ( $app->request_method eq 'POST' ) {
        return $app->json_error( $app->translate('Invalid request.'), 400 );
    }

    $app->json_result( { svn_revision => MT::Debug::GitInfo->svn_revision } );
}

1;

