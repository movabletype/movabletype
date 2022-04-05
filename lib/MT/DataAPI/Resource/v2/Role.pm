# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v2::Role;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [   qw(
            name
            description
            permissions
            )
    ];
}

sub fields {
    [   {   name => 'id',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        $MT::DataAPI::Resource::Common::fields{createdDate},
        $MT::DataAPI::Resource::Common::fields{modifiedDate},
        $MT::DataAPI::Resource::Common::fields{createdBy},
        $MT::DataAPI::Resource::Common::fields{modifiedBy},
        {   name        => 'updatable',
            type        => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object => sub {

            },
            bulk_from_object => sub {
                my ( $objs, $hashs ) = @_;
                my $app  = MT->instance;
                my $user = $app->user;

                if ( $user->is_superuser || $app->can_do('save_role') ) {
                    $_->{updatable} = 1 for @$hashs;
                }

                return;
            },
        },

        qw(
            name
            description
            ),
        {   name        => 'permissions',
            from_object => sub {
                my ($obj) = @_;
                my $perms = $obj->permissions or return [];
                my @perms = split ',', $perms;
                $_ =~ s/^'|'$//g for @perms;
                return \@perms;
            },
            to_object => sub {
                my ( $hash, $obj ) = @_;
                return
                    if !( exists $hash->{permissions}
                    && ref( $hash->{permissions} ) eq 'ARRAY' );

                my @perms = @{ $hash->{permissions} };
                $obj->clear_full_permissions;
                $obj->set_these_permissions(@perms);

                return;
            },
            schema      => {
                type => 'array',
                items => {
                    type => 'string',
                },
            },
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::Role - Movable Type class for resources definitions of the MT::Role.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
