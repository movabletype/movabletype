# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v2::Group;

use strict;
use warnings;

use MT::Association;
use MT::DataAPI::Resource::Common;

use MT::Group;

sub updatable_fields {
    [   qw(
            status
            ),
        {   name      => 'name',
            condition => sub {
                _create_or_update_with_active()
                    && !_external_group_management();
            },
        },
        {   name      => 'displayName',
            contition => sub {
                _create_or_update_with_active()
                    && !_ldap_external_group_management();
            },
        },
        {   name      => 'description',
            condition => \&_create_or_update_with_active,
        },
    ];
}

sub fields {
    [   qw(
            id
            name
            ),
        {   name                => 'displayName',
            alias               => 'display_name',
            from_object_default => '',
        },
        {   name                => 'description',
            from_object_default => '',
        },
        {   name        => 'status',
            from_object => sub {
                my ($obj) = @_;
                return if !defined( $obj->status );

                if ( $obj->status == MT::Group::ACTIVE() ) {
                    return 'Enabled';
                }
                elsif ( $obj->status == MT::Group::INACTIVE() ) {
                    return 'Disabled';
                }

                return;
            },
            to_object => sub {
                my ($hash) = @_;

                my $status = $hash->{status};
                return if !defined($status);

                if ( $status eq 'Enabled' ) {
                    return MT::Group::ACTIVE();
                }
                elsif ( $status eq 'Disabled' ) {
                    return MT::Group::INACTIVE();
                }

                # This is Invalid value.
                # Filtered at save_filter callback.
                return 0;
            },
        },
        {   name      => 'externalId',
            alias     => 'external_id',
            condition => sub {
                my $app = MT->instance or return;
                my $cfg = $app->config or return;
                return $cfg->AuthenticationModule ne 'MT'
                    && $cfg->ExternalGroupManagement;
            },
        },
        {   name                => 'memberCount',
            alias               => 'user_count',
            from_object_default => 0,
        },
        {   name        => 'permissionCount',
            from_object => sub {
                my ($obj) = @_;
                my $count = MT::Association->count(
                    {   group_id => $obj->id,
                        type     => MT::Association::GROUP_BLOG_ROLE(),
                    }
                );
                return $count + 0;
            },
            from_object_default => 0,
        },
        {   name             => 'updatable',
            bulk_from_object => sub {
                my ( $objs, $hashes ) = @_;
                my $app = MT->instance;
                my $user = $app->user or return;

                if ( $user->is_superuser ) {
                    $_->{updatable} = 1 for @$hashes;
                }
            },
            from_object_default => 0,
            type                => 'MT::DataAPI::Resource::DataType::Boolean',
        },
        $MT::DataAPI::Resource::Common::fields{createdDate},
        $MT::DataAPI::Resource::Common::fields{modifiedDate},
        $MT::DataAPI::Resource::Common::fields{createdBy},
        $MT::DataAPI::Resource::Common::fields{modifiedBy},
    ];
}

sub _create_or_update_with_active {
    my $app = MT->instance or return;

    # Can change when current endpoint is create_group.
    my $group_id = $app->param('group_id') or return 1;

    # Return cache.
    my $can_change_group = $app->request('can_change_group');
    return $can_change_group if defined $can_change_group;

    my $json_group = $app->param('group') or return;
    my $resource_group = $app->current_format->{unserialize}->($json_group);
    return if !$resource_group || ref($resource_group) ne 'HASH';

    my $status;
    if ( exists $resource_group->{status} ) {
        $status
            = (    $resource_group->{status}
                && $resource_group->{status} eq 'Enabled' )
            ? MT::Group::ACTIVE()
            : MT::Group::INACTIVE();
    }
    else {
        my $group = $app->model('group')->load($group_id) or return;
        $status = $group->status;
    }

    return $app->request( 'can_change_group',
        ( $status == MT::Group::ACTIVE() ) ? 1 : 0 );
}

sub _external_group_management {
    my $app = MT->instance or return;
    my $cfg = $app->config or return;
    return $cfg->ExternalGroupManagement;
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::Group - Movable Type class for resources definitions of the MT::Group.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
