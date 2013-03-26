# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::API::Endpoint::User;

use warnings;
use strict;

use base qw(MT::API::Endpoint);

sub get {
    my ($app) = @_;

    my $user_id = $app->param('user_id');
    if ($user_id eq 'me') {
        $app->user;
    }
    else {
        $app->model('author')->load($user_id || 0)
            or return $app->json_error(404, 'User not found');
    }
}

1;
