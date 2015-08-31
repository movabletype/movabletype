# Movable Type (r) (C) 2006-2015 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package GoogleOpenIDConnect::OIDC;

use strict;
use base qw( MT::Auth::OIDC );

use GoogleOpenIDConnect;

sub authorization_endpoint {'https://accounts.google.com/o/oauth2/auth'}
sub token_endpoint         {'https://accounts.google.com/o/oauth2/token'}
sub userinfo_endpoint      {'https://www.googleapis.com/oauth2/v3/userinfo'}

sub client_id {
    my ( $class, $app, $blog ) = @_;
    $class->_client_common( $app, $blog, 'client_id' );
}

sub client_secret {
    my ( $class, $app, $blog ) = @_;
    $class->_client_common( $app, $blog, 'client_secret' );
}

sub _client_common {
    my ( $class, $app, $blog, $key ) = @_;
    my $config_scope
        = ( $blog && $blog->id ) ? ( 'blog:' . $blog->id ) : 'system';
    my $config           = get_plugindata($config_scope);
    my $google_client_id = $config->{$key};
}

1;

