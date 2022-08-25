# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::v1::User;

use warnings;
use strict;

use MT::DataAPI::Endpoint::Common;

sub get_openapi_spec {
    +{
        tags        => ['Users'],
        summary     => 'Retrieve a single user by its ID',
        description => <<'DESCRIPTION',
Retrieve a single user by its ID.

Authorization is required if you want to retrieve private properties.
DESCRIPTION
        parameters => [{
                'in'        => 'query',
                name        => 'fields',
                schema      => { type => 'string' },
                description => 'This is an optional parameter. The field list to retrieve as part of the Users resource. This list should be separated by comma. If this parameter is not specified, All fields will be returned.',
            },
        ],
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/user',
                        },
                    },
                },
            },
            404 => {
                description => 'Not Found',
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

    my $user = get_target_user(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'author', $user->id, obj_promise($user) )
        or return;

    $user;
}

sub update_openapi_spec {
    +{
        tags        => ['Users'],
        summary     => 'Update user data',
        description => <<'DESCRIPTION',
Update user data.

Authorization is required.
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
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/user',
                        },
                    },
                },
            },
            404 => {
                description => 'Not Found',
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

    my $user = get_target_user(@_)
        or return;

    my $new_user = $app->resource_object( 'user', $user )
        or return;

    save_object( $app, 'author', $new_user, $user )
        or return;

    $new_user;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v1::User - Movable Type class for endpoint definitions about the MT::Author.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
