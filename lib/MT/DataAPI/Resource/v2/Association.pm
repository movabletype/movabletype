# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v2::Association;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [];
}

sub fields {
    [   $MT::DataAPI::Resource::Common::fields{blog},
        $MT::DataAPI::Resource::Common::fields{createdBy},
        $MT::DataAPI::Resource::Common::fields{createdDate},
        {   name   => 'user',
            fields => [qw( id displayName userpicUrl )],
            type   => 'MT::DataAPI::Resource::DataType::Object',
        },
        {   name   => 'role',
            fields => [qw( id name )],
            type   => 'MT::DataAPI::Resource::DataType::Object',
        },
        {   name        => 'permissions',
            from_object => sub {
                my ($obj) = @_;
                my $perms = $obj->role->permissions;
                my @perms = split ',', $perms;
                $_ =~ s/'([^']+)'/$1/ for @perms;
                return \@perms;
            },
            schema => {
                type  => 'array',
                items => { type => 'string' },
            },
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::Association - Movable Type class for resources definitions of the MT::Association.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
