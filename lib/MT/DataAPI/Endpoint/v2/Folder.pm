# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Folder;

use strict;
use warnings;

use MT::DataAPI::Endpoint::v2::Category;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list_openapi_spec {
    +{
        tags        => ['Folders'],
        summary     => 'Retrieve a list of folders',
        description => 'Authentication required if you want to get private properties.',
        parameters  => [
            { '$ref' => '#/components/parameters/folder_search' },
            { '$ref' => '#/components/parameters/folder_searchFields' },
            { '$ref' => '#/components/parameters/folder_limit' },
            { '$ref' => '#/components/parameters/folder_offset' },
            {
                in     => 'query',
                name   => 'sortBy',
                schema => {
                    type => 'string',
                    enum => [
                        'user_custom',
                        'created_by',
                        'id',
                        'basename',
                        'label',
                    ],
                    default => 'user_custom',
                },
                description => <<'DESCRIPTION',
#### user_custom

Sort order you specified on the Manage Folders screen.

#### created_by

Sort by the ID of creator.

#### id

Sort by its own ID.

#### basename

Sort by the basename of each folders.

#### label

Sort by the label of each folders.

**Default**: user_custom
DESCRIPTION
            },
            { '$ref' => '#/components/parameters/folder_sortOrder' },
            { '$ref' => '#/components/parameters/folder_fields' },
            { '$ref' => '#/components/parameters/folder_includeIds' },
            { '$ref' => '#/components/parameters/folder_excludeIds' },
            {
                in     => 'query',
                name   => 'top',
                schema => {
                    type    => 'integer',
                    enum    => [0, 1],
                    default => 0,
                },
                description => <<'DESCRIPTION',
If set to 1, retrieves only top level folders.

**Default**: 0
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
                                    type => 'integer',
                                },
                                items => {
                                    type  => 'array',
                                    items => {
                                        '$ref' => '#/components/schemas/folder',
                                    },
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
    return MT::DataAPI::Endpoint::v2::Category::list_common( $app, $endpoint,
        'folder' );
}

sub list_parents_openapi_spec {
    +{
        tags        => ['Folders'],
        summary     => 'Retrieve a list of parent folders of the requested folder',
        description => 'Authentication required if you want to get private properties.',
        parameters  => [{
                in          => 'query',
                name        => 'maxDepth',
                schema      => { type => 'integer' },
                description => <<'DESCRIPTION',
The depth of retrieving parent folders.

**Default**: 0
DESCRIPTION
            },
            {
                in     => 'query',
                name   => 'includeCurrent',
                schema => {
                    type    => 'integer',
                    enum    => [0, 1],
                    default => 0,
                },
                description => <<'DESCRIPTION',
#### 1

The results includes current folder.

#### 0

The results do not include current folder.

**Default**: 0
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
                                    type => 'integer',
                                },
                                items => {
                                    type  => 'array',
                                    items => {
                                        '$ref' => '#/components/schemas/folder',
                                    },
                                },
                            },
                        },
                    },
                },
            },
        },
    };
}

sub list_parents {
    my ( $app, $endpoint ) = @_;
    return MT::DataAPI::Endpoint::v2::Category::list_parents_common( $app,
        $endpoint, 'folder' );
}

sub list_siblings_openapi_spec {
    +{
        tags        => ['Folders'],
        summary     => 'Retrieve a list of sibling folders of the requested folder',
        description => 'Authentication required if you want to get private properties.',
        parameters  => [
            { '$ref' => '#/components/parameters/folder_search' },
            { '$ref' => '#/components/parameters/folder_searchFields' },
            { '$ref' => '#/components/parameters/folder_limit' },
            { '$ref' => '#/components/parameters/folder_offset' },
            {
                in     => 'query',
                name   => 'sortBy',
                schema => {
                    type => 'string',
                    enum => [
                        'user_custom',
                        'created_by',
                        'id',
                        'basename',
                        'label',
                    ],
                    default => 'user_custom',
                },
                description => <<'DESCRIPTION',
#### user_custom

Sort order you specified on the Manage Folders screen.

#### created_by

Sort by the ID of creator.

#### id

Sort by its own ID.

#### basename

Sort by the basename of each folders.

#### label

Sort by the label of each folders.

**Default**: user_custom
DESCRIPTION
            },
            { '$ref' => '#/components/parameters/folder_sortOrder' },
            { '$ref' => '#/components/parameters/folder_fields' },
            { '$ref' => '#/components/parameters/folder_includeIds' },
            { '$ref' => '#/components/parameters/folder_excludeIds' },
            {
                in     => 'query',
                name   => 'top',
                schema => {
                    type    => 'integer',
                    enum    => [0, 1],
                    default => 0,
                },
                description => <<'DESCRIPTION',
Default: 0

If set to 1, retrieves only top level folders.
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
                                    type => 'integer',
                                },
                                items => {
                                    type  => 'array',
                                    items => {
                                        '$ref' => '#/components/schemas/folder',
                                    },
                                },
                            },
                        },
                    },
                },
            },
        },
    };
}

sub list_siblings {
    my ( $app, $endpoint ) = @_;
    return MT::DataAPI::Endpoint::v2::Category::list_siblings_common( $app,
        $endpoint, 'folder' );
}

sub list_children_openapi_spec {
    +{
        tags        => ['Folders'],
        summary     => 'Retrieve a list of child folders of the requested folder',
        description => 'Authentication required if you want to get private properties.',
        parameters  => [{
                in          => 'query',
                name        => 'maxDepth',
                schema      => { type => 'integer' },
                description => <<'DESCRIPTION',
The depth of retrieving child folders.

**Default**: 0
DESCRIPTION
            },
            {
                in     => 'query',
                name   => 'includeCurrent',
                schema => {
                    type    => 'integer',
                    enum    => [0, 1],
                    default => 0,
                },
                description => <<'DESCRIPTION',
#### 1

The results includes current folder.

#### 0

The results do not include current folder.

**Default**: 0
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
                                    type => 'integer',
                                },
                                items => {
                                    type  => 'array',
                                    items => {
                                        '$ref' => '#/components/schemas/folder',
                                    },
                                },
                            },
                        },
                    },
                },
            },
        },
    };
}

sub list_children {
    my ( $app, $endpoint ) = @_;
    return MT::DataAPI::Endpoint::v2::Category::list_children_common( $app,
        $endpoint, 'folder' );
}

sub get_openapi_spec {
    +{
        tags       => ['Folders'],
        summary    => 'Retrieve single folder by its ID',
        parameters => [
            { '$ref' => '#/components/parameters/folder_fields' },
        ],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/folder',
                        },
                    },
                },
            },
            404 => {
                description => 'Folder or site not found.',
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
    return MT::DataAPI::Endpoint::v2::Category::get_common( $app, $endpoint,
        'folder' );
}

sub create_openapi_spec {
    +{
        tags        => ['Folders'],
        summary     => 'Create a new folder.',
        description => <<'DESCRIPTION',
Authorization is required.

#### Permission

- Manage Pages
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            folder => {
                                '$ref' => '#/components/schemas/folder_updatable',
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
                            '$ref' => '#/components/schemas/folder',
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
    return MT::DataAPI::Endpoint::v2::Category::create_common( $app,
        $endpoint, 'folder' );
}

sub update_openapi_spec {
    +{
        tags        => ['Folders'],
        summary     => 'Update an existing folder',
        description => <<'DESCRIPTION',
- Authorization is required.

#### Permission

- Manage Pages
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            folder => {
                                '$ref' => '#/components/schemas/folder_updatable',
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
                            '$ref' => '#/components/schemas/folder',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Folder not found.',
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
    return MT::DataAPI::Endpoint::v2::Category::update_common( $app,
        $endpoint, 'folder' );
}

sub delete_openapi_spec {
    +{
        tags => ['Folders'],
        summary => 'Delete an existing folder',
        description => <<'DESCRIPTION',
- Authorization is required.
- This method returns deleted Folder resource.

#### Permission

- Manage Pages
DESCRIPTION
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/folder',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Folder not found.',
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

    my ( $site, $folder ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'folder', $folder )
        or return;

    $folder->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $folder->class_label,
            $folder->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.folder', $app, $folder );

    $folder;
}

sub permutate_openapi_spec {
    +{
        tags        => ['Folders'],
        summary     => 'Rearrange existing folders in a new order',
        description => <<'DESCRIPTION',
- Authorization is required.
- This method returns rearranged Folders resource.

#### Permission

- Manage Pages
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    # TODO: The schema will be like below.
                    # However, items are packed as strings instead objects in Swagger.
                    # As a workaround, categories parameter treats as string.
                    #schema => {
                    #    type => 'object',
                    #    properties => {
                    #        folders => {
                    #           type => 'array',
                    #           items => {
                    #               type => 'object',
                    #               properties => {
                    #                   id => {
                    #                       type => 'integer',
                    #                   },
                    #               },
                    #           },
                    #        },
                    #    },
                    #},
                    #encoding => {
                    #    folders => {
                    #        contentType => 'application/json',
                    #    },
                    #},
                    schema => {
                        type       => 'object',
                        properties => {
                            folders => {
                                type    => 'string',
                                example => <<'EXAMPLE',
[
  { "id": 0 },
  { "id": 1 } 
]
EXAMPLE
                                description => 'Array of folder resource that were rearranged.',
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
                            type  => 'array',
                            items => {
                                '$ref' => '#/components/schemas/folder',
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

sub permutate {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_) or return;
    if ( !$site->id ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    if ( !$app->can_do('save_folder') ) {
        return $app->error(403);
    }

    return MT::DataAPI::Endpoint::v2::Category::permutate_common( $app,
        $endpoint, $site, 'folder' );

}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Folder - Movable Type class for endpoint definitions about the MT::Folder.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
