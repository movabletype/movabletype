# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::API::Endpoint::Entry;

use warnings;
use strict;

use base qw(MT::API::Endpoint);

sub list {
    my ($app) = @_;

    # TODO if offset ?
    my $entries = __PACKAGE__->filtered_list( $app, 'entry' );
    +{  totalResults => scalar @$entries,
        items        => $entries,
    };
}

1;
