# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::AccessToken;

use warnings;
use strict;

use MT::Session;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'         => 'string(80) not null',
            'session_id' => 'string(80) not null',
            'start'      => 'integer not null',
        },
        indexes => {
            'session_id' => 1,
            'start'      => 1,
        },
        datasource  => 'accesstoken',
        primary_key => 'id',
    }
);

sub class_label {
    MT->translate('AccessToken');
}

sub load_session {
    my $class = shift;
    my ($token) = @_;
    MT::Session->load(
        undef,
        {   'join' => $class->join_on(
                'session_id',
                {   id    => $token,
                    start => [ time() - $class->ttl ],
                },
                { range_incl => { 'start' => 1, } }
            )
        }
    );
}

sub ttl {
    int( MT->config->AccessTokenTTL );
}

sub purge {
    my $class = shift;

    $class->remove( { start => [ undef, time() - $class->ttl ] },
        { range => { start => 1, } } );

    1;
}

1;
