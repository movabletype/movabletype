# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package FormattedTextForTinyMCE6::App;

use strict;
use warnings;

use FormattedText::App;

sub view_text {
    my $app  = shift;
    my $user = $app->user;

    $app->validate_param({
        id => [qw/ID/],
    }) or return;

    my $formatted_text
        = MT->model('formatted_text')->load( scalar $app->param('id') )
        or return $app->error( $app->translate('Cannot load boilerplate.') );

    return $app->permission_denied()
        if ( !$user->is_superuser )
        && (
        !FormattedText::App::can_view_formatted_text(
            $app->permissions, $formatted_text, $app->user
        )
        );

    $app->{no_print_body} = 1;

    local $| = 1;
    $app->set_header( 'Cache-Control' => 'no-cache' );
    $app->send_http_header('text/html');

    $app->print_encode( $formatted_text->text );
}

1;
