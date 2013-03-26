# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::API::Endpoint::Blog;

use warnings;
use strict;

use base qw(MT::API::Endpoint);

sub list {
    my ($app) = @_;

    # TODO if user_id ne "me"
    # TODO if offset ?
    my $blogs = __PACKAGE__->filtered_list($app, 'blog');
    +{  totalResults => scalar @$blogs,
        items        => $blogs,
    };
}

1;
