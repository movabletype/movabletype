# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v3::User;

use strict;
use warnings;

use boolean ();

use MT::Author;
use MT::DataAPI::Resource::Common;
use MT::DataAPI::Resource::v1::User;

sub updatable_fields {
    [ qw( apiPassword ), ];
}

sub fields {
    [   apiPassword => {
            name        => 'apiPassword',
            alias       => 'api_password',
            from_object => sub { },          # Display nothing.
            to_object   => sub {
                my ( $hash, $obj ) = @_;
                my $pass = $hash->{apiPassword};
                if ( length $pass ) {
                    $obj->api_password($pass);
                }
                return;
            },
        },
    ];
}

1;
