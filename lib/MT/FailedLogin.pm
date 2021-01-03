# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::FailedLogin;

use strict;
use warnings;

use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'        => 'integer not null auto_increment',
            'author_id' => 'integer',
            'remote_ip' => 'string(60)',
            'start'     => 'integer not null',
            'ip_locked' => 'boolean',
        },
        indexes => {
            author_id    => 1,
            remote_ip    => 1,
            start        => 1,
            author_start => { columns => [ 'author_id', 'start' ], },
            ip_start     => { columns => [ 'remote_ip', 'start' ], },
            ip_locked    => 1,
        },
        defaults    => { ip_locked => 0, },
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

    my $ip_interval     = $app->config->IPLockoutInterval;
    my $author_interval = $app->config->UserLockoutInterval;
    my $interval
        = $ip_interval > $author_interval ? $ip_interval : $author_interval;

    $class->remove( { start => [ undef, time - $interval ] },
        { range => { start => 1, } } );
}

1;

__END__

=head1 NAME

MT::FailedLogin - Movable Type failed login log record

=head1 SYNOPSIS

    use MT::FailedLogin;
    MT::FailedLogin->cleanup;


=head1 DATA ACCESS METHODS

The I<MT::FailedLogin> object holds the following pieces of data. These fields
can be accessed and set using the standard data access methods described in
the I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the template.

=item * author_id

The numeric ID of the author who tried to login.

=item * remote_ip

The remote IP address which tried to login.

=item * start

The failed time in the UNIX epoch.

=back


=head1 METHODS

=head2 MT::FailedLogin->cleanup;

Clean up all expired failed login log.


=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
