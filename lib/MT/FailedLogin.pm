# Movable Type (r) Open Source (C) 2001-2011 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::FailedLogin;

use strict;

use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'        => 'integer not null auto_increment',
            'author_id' => 'integer',
            'remote_ip' => 'string(60)',
            'start'     => 'integer not null',
        },
        indexes => {
            author_id    => 1,
            remote_ip    => 1,
            start        => 1,
            author_start => { columns => [ 'author_id', 'start' ], },
            ip_start     => { columns => [ 'remote_ip', 'start' ], },
        },
        datasource  => 'failedlogin',
        primary_key => 'id'
    }
);

sub cleanup {
    my $class = shift;
    my ($app) = @_;

    return
        if !$app->config->IPLockoutLimit
            && !$app->config->UserLockoutLimit;

    my $ip_duration     = $app->config->IPLockoutDuration;
    my $author_duration = $app->config->UserLockoutDuration;
    my $duration
        = $ip_duration > $author_duration ? $ip_duration : $author_duration;

    $class->remove( { start => [ undef, time - $duration ] },
        { range => { start => 1, } } );
}

1;
