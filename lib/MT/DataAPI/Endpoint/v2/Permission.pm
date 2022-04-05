# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Permission;

use strict;
use warnings;

use MT::Association;
use MT::Permission;
use MT::Role;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list_for_user_openapi_spec {
    +{
        tags        => ['Users', 'Permissions'],
        summary     => 'Retrieve a list of permissions for user',
        description => <<'DESCRIPTION',
- Authentication is required
- If you want to get others list, you should have Administer privilege.
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/permission_limit' },
            { '$ref' => '#/components/parameters/permission_offset' },
            { '$ref' => '#/components/parameters/permission_sortBy' },
            { '$ref' => '#/components/parameters/permission_sortOrder' },
            { '$ref' => '#/components/parameters/permission_fields' },
            { '$ref' => '#/components/parameters/permission_blogIds' },
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
                                    description => ' The total number of permissions.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of permission resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/permission',
                                    }
                                },
                            },
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

sub list_for_user {
    my ( $app, $endpoint ) = @_;

    my $user = get_target_user(@_)
        or return;
    my $current_user = $app->user;

    return $app->error(403)
        if ( $user->id != $current_user->id && !$current_user->is_superuser );

    my %terms = ( permissions => { not => '' }, );
    my %args;
    my %options = ( user => $user );

    my $res
        = filtered_list( $app, $endpoint, 'permission', \%terms, \%args,
        \%options )
        or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_openapi_spec {
    +{
        tags        => ['Permissions'],
        summary     => 'Retrieve a list of permissions',
        description => <<'DESCRIPTION',
- Authentication is required
- Need Administer privilege.
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/permission_limit' },
            { '$ref' => '#/components/parameters/permission_offset' },
            { '$ref' => '#/components/parameters/permission_sortBy' },
            { '$ref' => '#/components/parameters/permission_sortOrder' },
            { '$ref' => '#/components/parameters/permission_fields' },
            { '$ref' => '#/components/parameters/permission_blogIds' },
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
                                    description => ' The total number of permissions.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of permission resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/permission',
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
    my $user = $app->user or return;

    my %terms = (
        author_id   => { not => 0 },
        permissions => { not => '' },
    );
    my %args;
    my %options = ( $user->is_superuser ? () : ( user => $user ), );

    my $res
        = filtered_list( $app, $endpoint, 'permission', \%terms, \%args,
        \%options )
        or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects}, ),
    };
}

sub list_for_site_openapi_spec {
    +{
        tags        => ['Sites', 'Permissions'],
        summary     => 'Retrieve a list of permissions for site',
        description => <<'DESCRIPTION',
- Authentication is required

#### Permissions

- Administer
- Website Administrator for websites
- Blog Administrator for blog
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/permission_limit' },
            { '$ref' => '#/components/parameters/permission_offset' },
            { '$ref' => '#/components/parameters/permission_sortBy' },
            { '$ref' => '#/components/parameters/permission_sortOrder' },
            { '$ref' => '#/components/parameters/permission_fields' },
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
                                    description => ' The total number of permissions.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of permission resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/permission',
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

sub list_for_site {
    my ( $app, $endpoint ) = @_;
    my $user = $app->user or return;

    my ($site) = context_objects(@_) or return;
    if ( !$site->id ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    my %terms = (
        blog_id     => $site->id,
        author_id   => { not => 0 },
        permissions => { not => '' },
    );
    my %args;
    my %options = ( $user->is_superuser ? () : ( user => $user ), );

    my $res
        = filtered_list( $app, $endpoint, 'permission', \%terms, \%args,
        \%options )
        or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_for_role_openapi_spec {
    +{
        tags        => ['Roles', 'Permissions'],
        summary     => 'Retrieve a list of permissions by role',
        description => <<'DESCRIPTION',
- Authentication is required

#### Permissions

- Administer
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/permission_limit' },
            { '$ref' => '#/components/parameters/permission_offset' },
            { '$ref' => '#/components/parameters/permission_sortBy' },
            { '$ref' => '#/components/parameters/permission_sortOrder' },
            { '$ref' => '#/components/parameters/permission_fields' },
            { '$ref' => '#/components/parameters/permission_blogIds' },
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
                                    description => ' The total number of permissions.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of permission resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/permission',
                                    }
                                },
                            },
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

sub list_for_role {
    my ( $app, $endpoint ) = @_;
    my $user = $app->user or return;

    my ($role) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'role', $role->id, obj_promise($role) )
        or return;

    my %terms = (
        author_id   => { not => 0 },
        permissions => { not => '' },
    );
    my %args = (
        join => MT->model('association')->join_on(
            undef,
            {   author_id => \'= permission_author_id',
                blog_id   => \'= permission_blog_id',
                role_id   => $role->id,
            },
        ),
    );
    my %options = ( $user->is_superuser ? () : ( user => $user ), );

    my $res
        = filtered_list( $app, $endpoint, 'permission', \%terms, \%args,
        \%options )
        or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub _can_grant {
    my ( $app, $site, $role ) = @_;
    my $login_user = $app->user or return;
    my $perms = $login_user->permissions( $site->id );

    return 1 if $login_user->is_superuser;

    if ( !$perms->can_do('grant_administer_role') ) {
        return if !$perms->can_do('grant_role_for_blog');
        return if $role->has('administer_site');
    }

    return 1;
}

sub _exists_administer_blog_role {

    # Load permission which has admiister_blog
    my @admin_roles = MT::Role->load_by_permission("administer_site");
    my $admin_role;
    foreach my $r (@admin_roles) {
        next if $r->permissions =~ m/\'administer_site\'/;
        return 1;
    }
    return;
}

sub _grant {
    my ( $app, $param_user, $role, $site ) = @_;

    MT::Association->link( $param_user, $role, $site )
        or return $app->error(
        $app->translate(
            'Granting permission failed: [_1]',
            MT::Association->errstr
        ),
        500
        );

    if (  !$site->is_blog
        && $site->has_blog
        && $role->has('administer_site')
        && _exists_administer_blog_role() )
    {
# Load Blog Administrator role. If no roles found, should be return successfully.
        my @admin_roles = MT::Role->load_by_permission("administer_site");
        return 1 unless @admin_roles;
        my $admin_role = $admin_roles[0];

        for my $blog ( @{ $site->blogs } ) {
            MT::Association->link( $param_user, $admin_role, $blog )
                or return $app->error(
                $app->translate(
                    'Granting permission failed: [_1]',
                    MT::Association->errstr
                ),
                500
                );
        }
    }

    return 1;
}

sub _retrieve_user_from_param {
    my ($app) = @_;

    my $user_id = $app->param('user_id');
    if ( !defined $user_id ) {
        return $app->error(
            $app->translate( 'A parameter "[_1]" is required.', 'user_id' ),
            400 );
    }

    my $user = $app->model('author')->load($user_id)
        or return $app->error( $app->translate( 'User not found', $user_id ),
        404 );

    return $user;
}

sub _retrieve_role_from_param {
    my ($app) = @_;

    my $role_id = $app->param('role_id');
    if ( !defined $role_id ) {
        return $app->error(
            $app->translate( 'A parameter "[_1]" is required.', 'role_id' ),
            400 );
    }

    my $role = $app->model('role')->load($role_id)
        or return $app->error( $app->translate( 'Role not found', $role_id ),
        404 );

    return $role;
}

sub grant_to_site_openapi_spec {
    +{
        tags        => ['Sites', 'Permissions'],
        summary     => 'Grant permissions to site',
        description => <<'DESCRIPTION',
- Authentication is required
- You should have grant_administer_role or grant_role_for_blog (Need grant_administer_role when granting role having administer_blog)
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            role_id => {
                                type        => 'integer',
                                description => 'The role ID',
                            },
                            user_id => {
                                type        => 'integer',
                                description => 'The user ID',
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
                                status => { type => 'string' },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Role or User not found',
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

sub grant_to_site {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_) or return;
    if ( !$site->id ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    my $param_user = _retrieve_user_from_param($app) or return;
    my $role       = _retrieve_role_from_param($app) or return;

    if ( !_can_grant( $app, $site, $role ) ) {
        return $app->error(403);
    }

    _grant( $app, $param_user, $role, $site ) or return;

    return +{ status => 'success' };
}

sub _can_revoke {
    my ( $app, $site, $role ) = @_;
    my $login_user = $app->user or return;
    my $perms = $login_user->permissions( $site->id );

    return 1 if $login_user->is_superuser;

    return if !$perms->can_do('revoke_role');
    return
        if !$perms->can_do('revoke_administer_role')
        && $role->has('administer_site');

    return 1;
}

sub revoke_from_site_openapi_spec {
    +{
        tags        => ['Sites', 'Permissions'],
        summary     => 'Revoke permissions from site',
        description => <<'DESCRIPTION',
- Authentication is required
- You should have revoke_role(Need revoke_administer_role when granting role having administer_blog )
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            role_id => {
                                type        => 'integer',
                                description => 'The role ID',
                            },
                            user_id => {
                                type        => 'integer',
                                description => 'The user ID',
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
                                status => { type => 'string' },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Role or User not found',
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

sub revoke_from_site {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_) or return;
    if ( !$site->id ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    my $param_user = _retrieve_user_from_param($app) or return;
    my $role       = _retrieve_role_from_param($app) or return;

    if ( !_can_revoke( $app, $site, $role ) ) {
        return $app->error(403);
    }

    MT::Association->unlink( $site, $role, $param_user )
        or return $app->error(
        $app->translate(
            'Revoking permission failed: [_1]',
            MT::Association->errstr
        ),
        500
        );

    return +{ status => 'success' };
}

sub _retrieve_site_from_param {
    my ($app) = @_;

    my $site_id = $app->param('site_id');
    if ( !defined $site_id ) {
        return $app->error(
            $app->translate( 'A parameter "[_1]" is required.', 'site_id' ),
            400 );
    }

    my $site = $app->model('blog')->load($site_id);
    if ( !( $site && $site->id ) ) {
        return $app->error( $app->translate( 'Site not found', $site_id ),
            404 );
    }

    return $site;
}

sub grant_to_user_openapi_spec {
    +{
        tags        => ['Users', 'Permissions'],
        summary     => 'Grant permissions to user',
        description => <<'DESCRIPTION',
- Authentication is required
- You should have revoke_role(Need revoke_administer_role when granting role having administer_blog )
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            role_id => {
                                type        => 'integer',
                                description => 'The role ID',
                            },
                            site_id => {
                                type        => 'integer',
                                description => 'The site ID',
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
                                status => { type => 'string' },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Role or User not found',
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

sub grant_to_user {
    my ( $app, $endpoint ) = @_;

    my ($param_user) = context_objects(@_);
    return if !( $param_user && $param_user->id );

    my $site = _retrieve_site_from_param($app) or return;
    my $role = _retrieve_role_from_param($app) or return;

    if ( !_can_grant( $app, $site, $role ) ) {
        return $app->error(403);
    }

    _grant( $app, $param_user, $role, $site ) or return;

    return +{ status => 'success' };
}

sub revoke_from_user_openapi_spec {
    +{
        tags        => ['Users', 'Permissions'],
        summary     => 'Revoke permissions from user',
        description => <<'DESCRIPTION',
- Authentication is required
- You should have revoke_role(Need revoke_administer_role when granting role having administer_blog )
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            role_id => {
                                type        => 'integer',
                                description => 'The role ID',
                            },
                            site_id => {
                                type        => 'integer',
                                description => 'The site ID',
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
                                status => { type => 'string' },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Role or User not found',
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

sub revoke_from_user {
    my ( $app, $endpoint ) = @_;

    my ($param_user) = context_objects(@_);
    return if !( $param_user && $param_user->id );

    my $site = _retrieve_site_from_param($app) or return;
    my $role = _retrieve_role_from_param($app) or return;

    if ( !_can_revoke( $app, $site, $role ) ) {
        return $app->error(403);
    }

    MT::Association->unlink( $site, $role, $param_user )
        or return $app->error(
        $app->translate(
            'Revoking permission failed: [_1]',
            MT::Association->errstr
        ),
        500
        );

    return +{ status => 'success' };
}

sub list_for_group_openapi_spec {
    +{
        tags        => ['Groups', 'Permissions'],
        summary     => 'Retrieve a list of permissions for group',
        description => <<'DESCRIPTION',
- Authentication is required
- If you want to get others list, you should have Administer privilege.
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/permission_limit' },
            { '$ref' => '#/components/parameters/permission_offset' },
            { '$ref' => '#/components/parameters/permission_sortBy' },
            { '$ref' => '#/components/parameters/permission_sortOrder' },
            { '$ref' => '#/components/parameters/permission_fields' },
            { '$ref' => '#/components/parameters/permission_blogIds' },
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
                                    description => ' The total number of permissions.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of permission resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/association',
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

sub list_for_group {
    my ( $app, $endpoint ) = @_;

    my ($group) = context_objects(@_) or return;

    my %terms = ( group_id => $group->id, );

    my $res = filtered_list( $app, $endpoint, 'association', \%terms )
        or return;

    return +{
        totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub grant_to_group_openapi_spec {
    +{
        tags        => ['Groups', 'Permissions'],
        summary     => 'Grant permissions to group',
        description => <<'DESCRIPTION',
- Authentication is required
- You should have grant_administer_role or grant_role_for_blog (Need grant_administer_role when granting role having administer_blog)
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            role_id => {
                                type        => 'integer',
                                description => 'The role ID',
                            },
                            site_id => {
                                type        => 'integer',
                                description => 'The site ID',
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
                                status => { type => 'string' },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Group not found',
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

sub grant_to_group {
    my ( $app, $endpoint ) = @_;

    # Check parameters.
    my ($group) = context_objects(@_) or return;
    my $site = _retrieve_site_from_param($app)
        or return;
    my $role = _retrieve_role_from_param($app)
        or return;

    $app->param( 'blog_id', $site->id );

    local $app->{return_args};
    local $app->{redirect};
    local $app->{redirect_use_meta};

    require MT::CMS::User;
    MT::CMS::User::grant_role($app);

    return if $app->errstr;

    if ( !$app->{return_args} ) {
        return $app->error(
            $app->translate('Granting permission failed: [_1]'), 500 );
    }

    return +{ status => 'success' };
}

sub revoke_from_group_openapi_spec {
    +{
        tags        => ['Groups', 'Permissions'],
        summary     => 'Revoke permissions from group',
        description => <<'DESCRIPTION',
- Authentication is required
- You should have revoke_role(Need revoke_administer_role when granting role having administer_blog )
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            role_id => {
                                type        => 'integer',
                                description => 'The role ID',
                            },
                            site_id => {
                                type        => 'integer',
                                description => 'The site ID',
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
                                status => { type => 'string' },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Group not found',
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

sub revoke_from_group {
    my ( $app, $endpoint ) = @_;

    my ($group) = context_objects(@_) or return;

    my $site = _retrieve_site_from_param($app)
        or return;

    my $role = _retrieve_role_from_param($app)
        or return;

    my $assoc = $app->model('association')->load(
        {   blog_id  => $site->id,
            role_id  => $role->id,
            group_id => $group->id,
        }
    );
    if ( !$assoc ) {
        return $app->error( $app->translate('Association not found'), 404 );
    }

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'association', $assoc )
        or return;

    $assoc->remove
        or return $app->error(
        $app->translate( 'Revoking permission failed: [_1]', $assoc->errstr ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.association', $app, $assoc );

    return +{ status => 'success' };
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Permission - Movable Type class for endpoint definitions about the MT::Permission.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
