# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Group;

use strict;
use warnings;

use MT::Association;
use MT::Log;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

use MT::Group;

sub list_openapi_spec {
    +{
        tags       => ['Groups'],
        summary    => 'Retrieve a list of groups',
        parameters => [
            { '$ref' => '#/components/parameters/group_search' },
            { '$ref' => '#/components/parameters/group_searchFields' },
            { '$ref' => '#/components/parameters/group_limit' },
            { '$ref' => '#/components/parameters/group_offset' },
            { '$ref' => '#/components/parameters/group_sortBy' },
            { '$ref' => '#/components/parameters/group_sortOrder' },
            { '$ref' => '#/components/parameters/group_fields' },
        ],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                totalResults => {
                                    type        => 'integer',
                                    description => ' The total number of groups.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of group resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/group',
                                    }
                                },
                            },
                        },
                    },
                },
            },
        },
    };
}

sub list {
    my ( $app, $endpoint ) = @_;

    my $res = filtered_list( $app, $endpoint, 'group' ) or return;

    return +{
        totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_for_user_openapi_spec {
    my $spec = __PACKAGE__->list_openapi_spec();
    $spec->{tags}           = ['Users', 'Groups'];
    $spec->{responses}{404} = {
        description => 'User not found.',
        content     => {
            'application/json' => {
                schema => {
                    '$ref' => '#/components/schemas/ErrorContent',
                },
            },
        },
    };
    return $spec;
}

sub list_for_user {
    my ( $app, $endpoint ) = @_;

    my ($user) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'author', $user->id, obj_promise($user) )
        or return;

    my %terms;
    my %args = (
        join => MT::Association->join_on(
            'group_id',
            {   author_id => $user->id,
                type      => MT::Association::USER_GROUP(),
            },
        ),
    );

    my $res = filtered_list( $app, $endpoint, 'group', \%terms, \%args )
        or return;

    return +{
        totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };

}

sub get_openapi_spec {
    +{
        tags       => ['Groups'],
        summary    => 'Retrieve single group by its ID',
        parameters => [
            { '$ref' => '#/components/parameters/group_fields' },
        ],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/group',
                        },
                    },
                },
            },
            404 => {
                description => 'Group not found.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ($group) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'group', $group->id, obj_promise($group) )
        or return;

    return $group;
}

sub create_openapi_spec {
    +{
        tags        => ['Groups'],
        summary     => 'Create a new group',
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            group => {
                                '$ref' => '#/components/schemas/group_updatable',
                            },
                        },
                    },
                },
            },
        },
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/group',
                        },
                    },
                },
            },
        },
    };
}

sub create {
    my ( $app, $endpoint ) = @_;

    my $cfg = $app->config;
    if (   $cfg->AuthenticationModule ne 'MT'
        && $cfg->ExternalGroupManagement )
    {
        return $app->error(
            $app->translate(
                'Creating group failed: ExternalGroupManagement is enabled.'),
            403
        );
    }

    my $orig_group = MT->model('group')->new;
    $orig_group->set_values(
        {   display_name => '',
            description  => '',
        }
    );

    my $new_group = $app->resource_object( 'group', $orig_group ) or return;

    _trim_name($new_group);

    save_object( $app, 'group', $new_group, $orig_group ) or return;

    return $new_group;
}

sub update_openapi_spec {
    +{
        tags        => ['Groups'],
        summary     => 'Update a group',
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            group => {
                                '$ref' => '#/components/schemas/group_updatable',
                            },
                        },
                    },
                },
            },
        },
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/group',
                        },
                    },
                },
            },
            404 => {
                description => 'Group not found.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ($orig_group) = context_objects(@_) or return;

    my $new_group = $app->resource_object( 'group', $orig_group ) or return;

    _trim_name($new_group);

    save_object(
        $app, 'group',
        $new_group,
        $orig_group,
        sub {
            my $user = $app->user;
            if ( $user && $user->id ) {
                $new_group->modified_by( $app->user->id );
            }

            $_[0]->();
        }
    ) or return;

    return $new_group;
}

sub delete_openapi_spec {
    +{
        tags      => ['Groups'],
        summary   => 'Delete a group',
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/group',
                        },
                    },
                },
            },
            404 => {
                description => 'Group not found.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ($group) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'group', $group )
        or return;

    $group->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $group->class_label,
            $group->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.group', $app, $group );

    return $group;
}

sub list_members_for_group_openapi_spec {
    +{
        tags       => ['Groups'],
        summary    => 'Retrieve a list of members for specified group',
        parameters => [
            { '$ref' => '#/components/parameters/group_search' },
            { '$ref' => '#/components/parameters/group_searchFields' },
            { '$ref' => '#/components/parameters/group_limit' },
            { '$ref' => '#/components/parameters/group_offset' },
            { '$ref' => '#/components/parameters/group_sortBy' },
            { '$ref' => '#/components/parameters/group_sortOrder' },
            { '$ref' => '#/components/parameters/group_fields' },
        ],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                totalResults => {
                                    type        => 'integer',
                                    description => ' The total number of members.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of member resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/user',
                                    }
                                },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Group not found.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

sub list_members_for_group {
    my ( $app, $endpoint ) = @_;

    my ($group) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'group', $group->id, obj_promise($group) )
        or return;

    my %terms;
    my %args = (
        join => MT::Association->join_on(
            'author_id',
            {   type     => MT::Association::USER_GROUP(),
                group_id => $group->id,
            },
        ),
    );

    my $res = filtered_list( $app, $endpoint, 'author', \%terms, \%args )
        or return;

    return +{
        totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub get_member_openapi_spec {
    +{
        tags       => ['Groups'],
        summary    => 'Retrieve single member by its ID for specified group',
        parameters => [
            { '$ref' => '#/components/parameters/group_fields' },
        ],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/user',
                        },
                    },
                },
            },
            404 => {
                description => 'Group or Member not found.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

sub get_member {
    my ( $app, $endpoint ) = @_;

    my ( $group, $member ) = _retrieve_group_and_member($app) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'author', $member->id, obj_promise($member) )
        or return;

    return $member;
}

sub add_member_openapi_spec {
    +{
        tags        => ['Groups'],
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            member => {
                                type       => 'object',
                                properties => {
                                    id => { type => 'integer' },
                                },
                            },
                        },
                    },
                },
            },
        },
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/user',
                        },
                    },
                },
            },
            404 => {
                description => 'Group or Member not found.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

sub add_member {
    my ( $app, $endpoint ) = @_;
    my $user = $app->user;
    my $cfg  = $app->config;

    if ( $cfg->ExternalGroupManagement || !$user->is_superuser ) {
        return $app->error(403);
    }

    my ($group) = context_objects(@_) or return;
    if ( $group->status == MT::Group::INACTIVE() ) {
        return $app->error(
            $app->translate('Cannot add member to inactive group.'), 403 );
    }

    my $member = _retrieve_member($app) or return;

    $group->add_user($member)
        or return $app->error(
        $app->translate(
            'Adding member to group failed: [_1]',
            $group->errstr
        ),
        500
        );

    $app->log(
        {   message => $app->translate(
                "User '[_1]' (ID:[_2]) was added to group '[_3]' (ID:[_4]) by '[_5]'",
                $member->name, $member->id, $group->name,
                $group->id,    $user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'add_group_member'
        }
    );

    return $member;
}

sub remove_member_openapi_spec {
    +{
        tags        => ['Groups'],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/user',
                        },
                    },
                },
            },
            404 => {
                description => 'Group or Member not found.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

sub remove_member {
    my ( $app, $endpoint ) = @_;
    my $user = $app->user;
    my $cfg  = $app->config;

    if ( $cfg->ExternalGroupManagement || !$user->is_superuser ) {
        return $app->error(403);
    }

    my ( $group, $member ) = _retrieve_group_and_member($app) or return;

    $group->remove_user($member)
        or return $app->error(
        $app->translate(
            'Removing member from group failed: [_1]',
            $group->errstr
        ),
        500
        );

    $app->log(
        {   message => $app->translate(
                "User '[_1]' (ID:[_2]) removed from group '[_3]' (ID:[_4]) by '[_5]'",
                $member->name, $member->id, $group->name,
                $group->id,    $user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'remove_group_member'
        }
    );

    return $member;
}

sub _trim_name {
    my ($group) = @_;
    my $name = $group->name;
    if ( defined $name ) {
        $name =~ s/(^\s+|\s+$)//g;
        $group->name($name);
    }
}

sub _retrieve_group_and_member {
    my ($app) = @_;

    my $group;
    if ( my $group_id = $app->param('group_id') ) {
        $group = $app->model('group')->load($group_id);
    }
    if ( !$group ) {
        return $app->error( $app->translate('Group not found'), 404 );
    }

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'group', $group->id, obj_promise($group) )
        or return;

    my $member;
    if ( my $member_id = $app->param('member_id') ) {
        my %terms = ( id => $member_id );
        my %args = (
            join => MT::Association->join_on(
                'author_id',
                {   type     => MT::Association::USER_GROUP(),
                    group_id => $group->id,
                },
            ),
        );
        $member = $app->model('author')->load( \%terms, \%args );
    }
    if ( !$member ) {
        return $app->error( $app->translate('Member not found'), 404 );
    }

    return ( $group, $member );
}

sub _retrieve_member {
    my ( $app, $group ) = @_;

    my $member_json = $app->param('member');
    if ( !$member_json ) {
        return $app->error(
            $app->translate('A resource "member" is required.'), 400 );
    }
    my $hash_member = $app->current_format->{unserialize}->($member_json);
    if ( ref($hash_member) ne 'HASH' || !exists( $hash_member->{id} ) ) {
        return $app->error(
            $app->translate( 'A parameter "[_1]" is required.', 'id' ), 400 );
    }
    my $member;
    if ($group) {
        my %terms = ( id => $hash_member->{id} );
        my %args = (
            join => MT::Association->join_on(
                'author_id',
                {   type     => MT::Association::USER_GROUP(),
                    group_id => $group->id,
                },
            ),
        );
        $member = $app->model('author')->load( \%terms, \%args );
    }
    else {
        $member = $app->model('author')->load( $hash_member->{id} );
    }
    if ( !$member ) {
        return $app->error( $app->translate('Member not found'), 404 );
    }

    return $member;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Group - Movable Type class for endpoint definitions about the MT::Group.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
