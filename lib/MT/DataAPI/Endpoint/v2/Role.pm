# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Role;

use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list_openapi_spec {
    +{
        tags      => ['Roles'],
        summary   => 'Retrieve a list of roles',
        parameters => [
            { '$ref' => '#/components/parameters/role_search' },
            { '$ref' => '#/components/parameters/role_searchFields' },
            { '$ref' => '#/components/parameters/role_limit' },
            { '$ref' => '#/components/parameters/role_offset' },
            { '$ref' => '#/components/parameters/role_sortBy' },
            { '$ref' => '#/components/parameters/role_sortOrder' },
            { '$ref' => '#/components/parameters/role_fields' },
        ],
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                totalResults => {
                                    type        => 'integer',
                                    description => ' The total number of roles.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of role resource. ',
                                    items       => {
                                        '$ref' => '#/components/schemas/role',
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

    my $res = filtered_list( $app, $endpoint, 'role' ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub create_openapi_spec {
    +{
        tags        => ['Roles'],
        summary     => 'Create a new role',
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            role => {
                                '$ref' => '#/components/schemas/role_updatable',
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
                            '$ref' => '#/components/schemas/role',
                        },
                    },
                },
            },
            404 => {
                description => 'Site not found.',
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

sub create {
    my ( $app, $endpoint ) = @_;

    my $orig_role = $app->model('role')->new;

    my $new_role = $app->resource_object( 'role', $orig_role )
        or return;

    if ( defined $new_role->name ) {
        my $name = $new_role->name;
        $name =~ s/(^\s+|\s+$)//g;
        $new_role->name($name);
    }

    save_object(
        $app, 'role',
        $new_role,
        $orig_role,
        sub {
            if ( my $author = $app->user ) {
                $new_role->created_by( $author->id );
            }
            $_[0]->();
        }
    ) or return;

    $new_role;
}

sub get_openapi_spec {
    +{
        tags       => ['Roles'],
        summary    => 'Retrieve a single role by its ID',
        parameters => [
            { '$ref' => '#/components/parameters/role_fields' },
        ],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/role',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Role not found.',
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

    my ($role) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'role', $role->id, obj_promise($role) )
        or return;

    $role;
}

sub update_openapi_spec {
    +{
        tags        => ['Roles'],
        summary     => 'Update an existing role',
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            role => {
                                '$ref' => '#/components/schemas/role_updatable',
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
                            '$ref' => '#/components/schemas/role',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Role not found.',
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

    my ($orig_role) = context_objects(@_)
        or return;
    my $new_role = $app->resource_object( 'role', $orig_role )
        or return;

    save_object(
        $app, 'role',
        $new_role,
        $orig_role,
        sub {
            if ( my $author = $app->user ) {
                $new_role->modified_by( $author->id );
            }
            $_[0]->();
        }
    ) or return;

    $new_role;
}

sub delete_openapi_spec {
    +{
        tags      => ['Roles'],
        summary   => 'Delete an existing role',
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/role',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Role not found.',
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

    my ($role) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'role', $role )
        or return;

    $role->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $role->class_label,
            $role->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.role', $app, $role );

    $role;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Role - Movable Type class for endpoint definitions about the MT::Role.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
