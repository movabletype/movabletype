# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::DataAPI::Endpoint::User;

use warnings;
use strict;

use MT::DataAPI::Endpoint::Common;

sub get {
    my ( $app, $endpoint ) = @_;

    my $user = get_target_user(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'author', $user->id )
        or return;

    $user;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my $user = get_target_user($app)
        or return;

    my $new_user = $app->resource_object( 'user', $user )
        or return;

    run_permission_filter( $app, 'data_api_save_permission_filter',
        'author', $user->id )
        or return $app->error(403);

    save_object( $app, 'author', $new_user, $user )
        or return;

    $new_user;
}

1;
