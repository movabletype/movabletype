# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Auth::Yahoo;

use strict;
use base qw( MT::Auth::OpenID );

sub url_for_userid {
    my $class = shift;
    my ($uid) = @_;
    return "https://me.yahoo.com/$uid";
};

sub get_nickname {
    my $class = shift;
    my ($vident, $blog_id) = @_;

    my $url = $vident->url;
    if ( $url =~ m(^https?://me.yahoo.com/([^/]+)/?$) ) {
        return $1;
    }

    return $class->SUPER::get_nickname(@_);
}

1;
