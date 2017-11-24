# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Auth::AIM;

use strict;
use warnings;
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
