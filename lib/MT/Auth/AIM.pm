# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Auth::AIM;

use strict;
use base qw( MT::Auth::OpenID );

sub url_for_userid {
    my $class = shift;
    my ($uid) = @_;
    return "http://openid.aol.com/$uid";
}

sub get_nickname {
    my $class = shift;
    my ( $vident, $blog_id ) = @_;
    my $url = $vident->url;
    if ( $url =~ m(^http://openid\.aol\.com\/([^/]+).*$) ) {
        return $1;
    }
    return $class->SUPER::get_nickname(@_);
}

1;
