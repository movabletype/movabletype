# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v4::CategorySet;
use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list_openapi_spec {
    +{
        tags        => ['Category Sets'],
        summary     => 'Category Set Collection',
        description => <<'DESCRIPTION',
Retrieve list of category set in the specified site. Authentication required if you want retrieve private field in categorySet resource. Required permissions are as follows.

- Manage Category Set
- If you use search parameter, you must specify search parameter with searchFields parameter. (This will be fixed in a future release.)
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/category_set_search' },
            { '$ref' => '#/components/parameters/category_set_searchFields' },
            { '$ref' => '#/components/parameters/category_set_limit' },
            { '$ref' => '#/components/parameters/category_set_offset' },
            {
                in     => 'query',
                name   => 'sortBy',
                schema => {
                    type => 'string',
                    enum => [
                        'id',
                        'name',
                        'created_on',
                        'modified_on',
                        'content_type_count',
                    ],
                    default => 'name',
                },
                description => <<'DESCRIPTION',
The field name for sort. You can specify one of following values.

- id
- name
- created_on
- modified_on
- content_type_count
DESCRIPTION
            },
            { '$ref' => '#/components/parameters/category_set_sortOrder' },
            { '$ref' => '#/components/parameters/category_set_fields' },
            { '$ref' => '#/components/parameters/category_set_includeIds' },
            { '$ref' => '#/components/parameters/category_set_excludeIds' },
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
                                        '$ref' => '#/components/schemas/category_set',
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

    my $res = filtered_list( $app, $endpoint, 'category_set' ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub create_openapi_spec {
    +{
        tags        => ['Category Sets'],
        summary     => 'Create a new category set',
        description => <<'DESCRIPTION',
**Authentication Required**

Create a new category set. This endpoint requires following permissions.

- Manage Category Set

Post form data is following

- category_set (CategorySet) - Single CategorySet resource
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            category_set => {
                                '$ref' => '#/components/schemas/category_set_updatable',
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
                            '$ref' => '#/components/schemas/category_set',
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

    my $orig_category_set
        = $app->model('category_set')->new( blog_id => $site->id );

    my $new_category_set
        = $app->resource_object( 'category_set', $orig_category_set )
        or return;

    save_object( $app, 'category_set', $new_category_set ) or return;

    $new_category_set;
}

sub get_openapi_spec {
    +{
        tags        => ['Category Sets'],
        summary     => 'Fetch single category set',
        description => <<'DESCRIPTION',
Fetch a single category set. Authentication required if you want retrieve private field in categorySet resource. Required permissions are as follows.

- Manage Category Set
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/category_set_fields' },
        ],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/category_set',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Category_set not found.',
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

    my ( $site, $category_set ) = context_objects(@_);
    return unless $category_set;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'category_set', $category_set->id, obj_promise($category_set) )
        or return;

    $category_set;
}

sub update_openapi_spec {
    +{
        tags        => ['Category Sets'],
        summary     => 'Update category set',
        description => <<'DESCRIPTION',
**Authentication required** Update single category set. This endpoint requires following permissions.

- Manage Category Set

Cannot update/insert/delete categories by this endpoint. If you want to manage categories in category set, please use Categories API.
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            category_set => {
                                '$ref' => '#/components/schemas/category_set_updatable',
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
                            '$ref' => '#/components/schemas/category_set',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Category_set not found.',
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

    my ( $site, $orig_category_set ) = context_objects(@_);
    return unless $orig_category_set;

    my $new_category_set
        = $app->resource_object( 'category_set', $orig_category_set )
        or return;

    save_object( $app, 'category_set', $new_category_set ) or return;

    $new_category_set;
}

sub delete_openapi_spec {
    +{
        tags        => ['Category Sets'],
        summary => 'Delete category set',
        description => <<'DESCRIPTION',
**Authentication required** Delete a single category set. This endpoint requires following permissions.

- Manage Category Set
DESCRIPTION
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/category_set',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Category_set not found.',
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

    my ( $site, $category_set ) = context_objects(@_);
    return unless $category_set;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'category_set', $category_set )
        or return;

    $category_set->remove()
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $category_set->class_label,
            $category_set->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.category_set',
        $app, $category_set );

    $category_set;
}

1;

