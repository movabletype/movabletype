# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::User;

use strict;
use warnings;

use MT::Lockout;
use MT::CMS::Tools;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list_openapi_spec {
    +{
        tags        => ['Users'],
        summary     => 'Retrieve a list of users in the specified site',
        description => <<'DESCRIPTION',
- Authentication is required to include non-active users or to get private properties.

#### Permissions

- administer
  - to retrieve non-active users
  - to read private properties
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/user_search' },
            { '$ref' => '#/components/parameters/user_searchFields' },
            { '$ref' => '#/components/parameters/user_limit' },
            { '$ref' => '#/components/parameters/user_offset' },
            {
                in     => 'query',
                name   => 'sortBy',
                schema => {
                    type => 'string',
                    enum => [
                        'id',
                        'name',
                    ],
                    default => 'name',
                },
                description => <<'DESCRIPTION',
The field name for sort. You can specify one of following values
- id
- name

**Default**: name
DESCRIPTION
            },
            { '$ref' => '#/components/parameters/user_sortOrder' },
            { '$ref' => '#/components/parameters/user_fields' },
            { '$ref' => '#/components/parameters/user_includeIds' },
            { '$ref' => '#/components/parameters/user_excludeIds' },
            {
                in     => 'query',
                name   => 'status',
                schema => {
                    type => 'string',
                    enum => [
                        'active',
                        'disabled',
                        'pending',
                    ],
                },
                description => <<'DESCRIPTION',
Filter by users's status.

#### active

status is Active

#### disabled

status is Disabled.

#### pending

status is Pending
DESCRIPTION
            },
            {
                in     => 'query',
                name   => 'lockout',
                schema => {
                    type => 'string',
                    enum => [
                        'locked_out',
                        'not_locked_out',
                    ],
                },
                description => <<'DESCRIPTION',
Filter by user's lockout status.

#### locked_out

Locked out user only

#### not_locked_out

Not locked out user only
DESCRIPTION
            },
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
                                    description => ' The total number of users.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of user resource.',
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

sub list {
    my ( $app, $endpoint ) = @_;

    my $res = filtered_list( $app, $endpoint, 'author' ) or return;

    return +{
        totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub create_openapi_spec {
    +{
        tags        => ['Users'],
        summary     => 'Create a new user',
        description => <<'DESCRIPTION',
- Authentication is required.

#### Permissions

- administer
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            user => {
                                '$ref' => '#/components/schemas/user_updatable',
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

    my $orig_user = $app->model('author')->new;

    $orig_user->set_values(
        {   auth_type   => $app->config->AuthenticationModule,
            nickname    => '',
            text_format => 0,
        }
    );

    my $new_user = $app->resource_object( 'user', $orig_user )
        or return;

    save_object( $app, 'author', $new_user, $orig_user ) or return;

    return $new_user;
}

sub delete_openapi_spec {
    +{
        tags        => ['Users'],
        summary     => 'Delete user',
        description => <<'DESCRIPTION',
- Authentication is required.
- Cannot delete oneself. Also, cannot delete system administrator user.

#### Permissions

- administer
DESCRIPTION
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
                description => 'Site or User not found.',
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

    my ($user) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'author', $user )
        or return;

    $user->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $user->class_label,
            $user->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.author', $app, $user );

    return $user;
}

sub unlock_openapi_spec {
    +{
        tags        => ['Users'],
        summary     => 'Unlock user account',
        description => <<'DESCRIPTION',
- Authentication is required.

#### Permissions

- administer
DESCRIPTION
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                status => { type => 'string' },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or User not found',
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

sub unlock {
    my ( $app, $endpoint ) = @_;

    return $app->error(403) if !$app->user->can_manage_users_groups();

    my ($user) = context_objects(@_) or return;

    MT::Lockout->unlock($user);
    $user->save
        or $app->error(
        $app->translate( 'Saving object failed: [_1]', $user->errstr ), 500 );

    return +{ status => 'success' };
}

sub recover_password_openapi_spec {
    +{
        tags        => ['Users'],
        summary     => 'Send the link for password recovery to specified user by email',
        description => <<'DESCRIPTION',
- Authentication is required.

#### Permissions

- administer
DESCRIPTION
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                status  => { type => 'string' },
                                message => { type => 'string' },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or User not found',
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

sub recover_password {
    my ( $app, $endpoint ) = @_;

    if (!(  $app->user->can_manage_users_groups()
            && MT::Auth->can_recover_password
        )
        )
    {
        return $app->error(403);
    }

    my ($user) = context_objects(@_) or return;

    require MT::App::CMS;
    my $cms = MT::App::CMS->new;
    my ( $rc, $res ) = MT::CMS::Tools::reset_password( $cms, $user );

    if ($rc) {
        return +{ status => 'success', message => $res };
    }
    else {
        return $app->error( $res, 500 );
    }
}

sub recover_openapi_spec {
    +{
        tags        => ['Users'],
        summary     => 'Send the link for password recovery to specified email',
        description => <<'DESCRIPTION',
- This method always returns successful code if it does not found a user, because security reason.
- Authentication is not required.

#### Permissions

- administer
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            email => {
                                type        => 'string',
                                description => 'Email address for user',
                            },
                            name => {
                                type        => 'string',
                                description => 'Name for user',
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
                            type       => 'object',
                            properties => {
                                status  => { type => 'string' },
                                message => { type => 'string' },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or User not found',
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

sub recover {
    my ( $app, $endpoint ) = @_;

    my $param;

    no warnings 'once';
    local *MT::App::DataAPI::start_recover = sub { $param = $_[1] };

    MT::CMS::Tools::recover_password($app);

    return if $app->errstr;
    return $app->error( $param->{error}, 400 ) if $param->{error};

    if ( $param->{not_unique_email} ) {
        return $app->error(
            $app->translate(
                'The email address provided is not unique. Please enter your username by "name" parameter.'
            ),
            409
        );
    }

    my $email   = $app->param('email');
    my $message = $app->translate(
        'An email with a link to reset your password has been sent to your email address ([_1]).',
        $email
    );
    return +{ status => 'success', message => $message };
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::User - Movable Type class for endpoint definitions about the MT::Author.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
