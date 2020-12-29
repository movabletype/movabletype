# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v2::Permission;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [];
}

sub fields {
    [   qw(
            id
            ),
        $MT::DataAPI::Resource::Common::fields{createdDate},
        $MT::DataAPI::Resource::Common::fields{createdBy},
        {   name   => 'user',
            fields => [qw(id displayName userpicUrl)],
            type   => 'MT::DataAPI::Resource::DataType::Object',
        },
        {   name        => 'roles',
            from_object => sub {
                my ($obj) = @_;
                my $author_id = $obj->author_id or return;

                my @roles = MT->model('role')->load(
                    undef,
                    {   join => MT->model('association')->join_on(
                            'role_id',
                            {   author_id => $author_id,
                                blog_id   => $obj->blog_id,
                            },
                        ),
                    }
                );

                return \@roles;
            },
            fields => [qw(id name)],
            type   => 'MT::DataAPI::Resource::DataType::Object',
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::Permission - Movable Type class for resources definitions of the MT::Permission.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
