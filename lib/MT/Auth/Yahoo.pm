# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Auth::Yahoo;

use strict;
use base qw( MT::Auth::OpenID );

sub set_extension_args {
    my $class = shift;
    my ($claimed_identity) = @_;

    $claimed_identity->set_extension_args(
        MT::Auth::OpenID::NS_OPENID_AX(),
        {   'mode'          => 'fetch_request',
            'required'      => 'nickname',
            'type.nickname' => 'http://axschema.org/namePerson/friendly',
        }
    );
}

sub get_nickname {
    my $class = shift;
    my ($vident) = @_;

    # If AX data found, use that as nickname.
    my $fields
        = $vident->extension_fields( MT::Auth::OpenID::NS_OPENID_AX() );
    my $nick = $fields->{'value.nickname'};
    return $nick if $nick;

    # No, Profile URL as nickname
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
