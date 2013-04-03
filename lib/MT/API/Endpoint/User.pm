# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::API::Endpoint::User;

use warnings;
use strict;

use MT::API::Endpoint::Common;

sub _get_user {
    my ($app) = @_;

    if ( $app->param('user_id') eq 'me' ) {
        $app->user;
    }
    else {
        my ($user) = context_objects(@_);
        $user;
    }
}

sub get {
    my ($app, $endpoint) = @_;

    my $user = _get_user($app)
        or return;

    run_permission_filter( $app,
        'cms_view_permission_filter.author', $user )
        or return;

    $user;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my $user = _get_user($app)
        or return;

    # TODO should return appropriate error
    my $new_user = $app->resource_object( 'user', $user )
        or return $app->error(resource_error('user'));

    my $perms = $app->permissions;
    if ( !$app->user->is_superuser ) {
        return $app->permission_denied()
            if !$perms && $user->id != $app->user->id;

        $app->run_callbacks( 'cms_save_permission_filter.author',
            $app, $user )
            || return $app->error(403);
    }

    save_object($app, $user)
        or return;

    $user;
}

1;
