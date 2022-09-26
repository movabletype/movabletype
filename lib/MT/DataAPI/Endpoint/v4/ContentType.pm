# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v4::ContentType;
use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list_openapi_spec {
    +{
        tags        => ['Content Types'],
        summary     => 'Content Type Collection',
        description => <<'DESCRIPTION',
Authentication required

Retrieve a list of Content Types. This endpoint requires following permission.

- Manage Content Types
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/content_type_limit' },
            { '$ref' => '#/components/parameters/content_type_offset' },
            {
                in     => 'query',
                name   => 'sortBy',
                schema => {
                    type => 'string',
                    enum => [
                        'name',
                        'dataLabel',
                        'uniqueID',
                        'modified_on',
                    ],
                },
                description => <<'DESCRIPTION',
The field name for sort. You can specify one of following values.
- name
- dataLabel
- uniqueID
- modified_on
DESCRIPTION
            },
            { '$ref' => '#/components/parameters/content_type_sortOrder' },
            { '$ref' => '#/components/parameters/content_type_fields' },
            { '$ref' => '#/components/parameters/content_type_includeIds' },
            { '$ref' => '#/components/parameters/content_type_excludeIds' },
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
                                        '$ref' => '#/components/schemas/content_type',
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

    return $app->error( $app->translate('Site not found'), 404 )
        unless $app->blog;

    my $res = filtered_list( $app, $endpoint, 'content_type' ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub create_openapi_spec {
    +{
        tags        => ['Content Types'],
        summary     => 'Create Content Type',
        description => <<'DESCRIPTION',
**Authentication required**

Create a new Content Type. This endpoint requires following permission.

- Manage Content Types

Post form data is as follows.

- content_type (required, ContentType) - Single Content Type resource
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            content_type => {
                                '$ref' => '#/components/schemas/content_type_updatable',
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
                            '$ref' => '#/components/schemas/content_type',
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

    my ($site) = context_objects(@_) or return;

    my $orig_content_type
        = $app->model('content_type')->new( blog_id => $site->id );

    my $new_content_type
        = $app->resource_object( 'content_type', $orig_content_type )
        or return;

    save_object( $app, 'content_type', $new_content_type ) or return;

    $new_content_type;
}

sub get_openapi_spec {
    +{
        tags        => ['Content Types'],
        summary     => 'Fetch single Content Type',
        description => <<'DESCRIPTION',
**Authentication required**

Fetch single content type. This endpoint requires following permission.

- Manage Content Types
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/content_type_fields' },
        ],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/content_type',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Content_type not found.',
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

    my ( $site, $content_type ) = context_objects(@_);
    return unless $content_type;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'content_type', $content_type->id, obj_promise($content_type) )
        or return;

    $content_type;
}

sub update_openapi_spec {
    +{
        tags        => ['Content Types'],
        summary     => 'Update Content Type',
        description => <<'DESCRIPTION',
**Authentication required**

Update content type. This endpoint requires following permission.

- Manage Content Types
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            content_type => {
                                '$ref' => '#/components/schemas/content_type_updatable',
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
                            '$ref' => '#/components/schemas/content_type',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Content_type not found.',
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

    my ( $site, $orig_content_type ) = context_objects(@_);
    return unless $orig_content_type;

    my $new_content_type
        = $app->resource_object( 'content_type', $orig_content_type )
        or return;

    save_object( $app, 'content_type', $new_content_type ) or return;

    $new_content_type;
}

sub delete_openapi_spec {
    +{
        tags        => ['Content Types'],
        summary     => 'Delete Content Type',
        description => <<'DESCRIPTION',
**Authentication required**

Delete content type. This endpoint requires following permission.

- Manage Content Types
DESCRIPTION
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/content_type',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Content_type not found.',
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

    my ( $site, $content_type ) = context_objects(@_);
    return unless $content_type;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'content_type', $content_type )
        or return;

    $content_type->remove()
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $content_type->class_label,
            $content_type->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.content_type',
        $app, $content_type );

    $content_type;
}

1;

