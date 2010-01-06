# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Auth::Yahoo;

use strict;
use base qw( MT::Auth::OpenID );

sub get_nickname {
    my $class = shift;
    my ($vident) = @_;

    my $url = $vident->url;
    if ( $url =~ m(^https?://me.yahoo.com/([^/]+)/?$) ) {
        return $1;
    }
    elsif ( $url =~ m(^http://www.flickr.com/photos/(.+)$) ) {
        return $1;
    }

    return $class->SUPER::get_nickname(@_);
}

1;
