# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v4::Category;
use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Endpoint::v2::Category;
use MT::DataAPI::Resource;

sub list_for_category_set_openapi_spec {
    +{
        tags        => ['Categories', 'Category Sets'],
        summary     => 'Category Collection for category set',
        description => 'Retrieve list of categories of the specified category set.',
        parameters  => [{
                in          => 'query',
                name        => 'maxDepth',
                schema      => { type => 'integer' },
                description => 'The depth of retrieving parent categories.',
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
- 1: The list does not include current category.
- 0: The list includes current category.
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
                                        '$ref' => '#/components/schemas/category',
                                    }
                                },
                            },
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

sub list_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'category_set', $category_set->id, obj_promise($category_set) )
        or return;

    my $res = filtered_list(
        $app,
        $endpoint,
        'category',
        {   blog_id         => $category_set->blog_id,
            category_set_id => $category_set->id,
        }
    ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_parents_for_category_set_openapi_spec {
    +{
        tags        => ['Categories', 'Category Sets'],
        summary     => 'Category Collection of parent categories for category set',
        description => 'Retrieve list of parent categories of the specified category set.',
        parameters  => [{
                in          => 'query',
                name        => 'maxDepth',
                schema      => { type => 'integer' },
                description => 'The depth of retrieving parent categories.',
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
- 1: The list does not include current category.
- 0: The list includes current category.
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
                                        '$ref' => '#/components/schemas/category',
                                    }
                                },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Category_set or Category not found.',
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

sub list_parents_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set, $category ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'category_set', $category_set->id, obj_promise($category_set) )
        or return;

    my $max_depth = $app->param('maxDepth') || 0;
    my @parent_cats
        = MT::DataAPI::Endpoint::v2::Category::_get_all_parent_categories(
        $category, $max_depth );

    for my $parent_cat (@parent_cats) {
        run_permission_filter( $app, 'data_api_view_permission_filter',
            'category', $parent_cat->id, obj_promise($parent_cat) )
            or return;
    }

    if ( $app->param('includeCurrent') ) {
        unshift @parent_cats, $category;
    }

    +{  totalResults => scalar @parent_cats,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( \@parent_cats ),
    };
}

sub list_siblings_for_category_set_openapi_spec {
    +{
        tags        => ['Categories', 'Category Sets'],
        summary     => 'Category Collection of sibling categories for category set',
        description => 'Retrieve list of sibling categories of the specified category set.',
        parameters  => [
            { '$ref' => '#/components/parameters/category_search' },
            { '$ref' => '#/components/parameters/category_searchFields' },
            { '$ref' => '#/components/parameters/category_limit' },
            { '$ref' => '#/components/parameters/category_offset' },
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
- user_custom: Sort order you specified on the Manage Categories screen.
- created_by: Sort by the ID of user who created each category.
- id: Sort by the ID of each category.
- basename: Sort by the basename of each category.
- label: Sort by the label of each category.
DESCRIPTION
            },
            { '$ref' => '#/components/parameters/category_sortOrder' },
            { '$ref' => '#/components/parameters/category_fields' },
            {
                in          => 'query',
                name        => 'top',
                schema => {
                    type    => 'integer',
                    enum    => [0, 1],
                    default => 0,
                },
                description => 'If set to 1, retrieves only top level categories. New in v2',
            },
            { '$ref' => '#/components/parameters/category_includeIds' },
            { '$ref' => '#/components/parameters/category_excludeIds' },
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
                                        '$ref' => '#/components/schemas/category',
                                    }
                                },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Category_set or Category not found.',
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

sub list_siblings_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set, $category ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'category_set', $category_set->id, obj_promise($category_set) )
        or return;

    my %terms = (
        id              => { not => $category->id },
        blog_id         => $category->blog_id,
        parent          => $category->parent,
        category_set_id => $category->category_set_id,
    );
    my $res = filtered_list( $app, $endpoint, 'category', \%terms ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_children_for_category_set_openapi_spec {
    +{
        tags        => ['Categories', 'Category Sets'],
        summary     => 'Category Collection of child categories for category set',
        description => 'Retrieve list of child categories of the specified category set.',
        parameters  => [{
                in          => 'query',
                name        => 'maxDepth',
                schema      => { type => 'integer' },
                description => 'The depth of retrieving parent categories.',
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
- 1: The list does not include current category.
- 0: The list includes current category.
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
                                        '$ref' => '#/components/schemas/category',
                                    }
                                },
                            },
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

sub list_children_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set, $category ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'category_set', $category_set->id, obj_promise($category_set) )
        or return;

    my $max_depth = $app->param('maxDepth') || 0;
    my @child_cats
        = MT::DataAPI::Endpoint::v2::Category::_get_all_child_categories(
        $category, $max_depth );

    for my $child_cat (@child_cats) {
        run_permission_filter( $app, 'data_api_view_permission_filter',
            'category', $child_cat->id, obj_promise($child_cat) )
            or return;
    }

    if ( $app->param('includeCurrent') ) {
        unshift @child_cats, $category;
    }

    +{  totalResults => scalar @child_cats,
        items => MT::DataAPI::Resource::Type::ObjectList->new( \@child_cats ),
    };
}

sub create_for_category_set_openapi_spec {
    +{
        tags        => ['Categories', 'Category Sets'],
        summary     => 'Create a new category for category set',
        description => <<'DESCRIPTION',
**Authentication required.**

Create a new category in category set. This endpoint needs following permissions.

- Manage Category Set

Post form data is following:

- category (Category) - Category resource
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            category => {
                                '$ref' => '#/components/schemas/category_updatable',
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
                            '$ref' => '#/components/schemas/category',
                        },
                    },
                },
            },
            404 => {
                description => 'Site pr Category_set not found.',
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

sub create_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_save_permission_filter',
        'category_set', $category_set->id )
        or return;

    my $orig_category = $app->model('category')->new(
        blog_id         => $category_set->blog_id,
        category_set_id => $category_set->id,
    );

    my $new_category = $app->resource_object( 'category', $orig_category )
        or return;

    save_object( $app, 'category', $new_category ) or return;

    $new_category;
}

sub get_for_category_set_openapi_spec {
    +{
        tags        => ['Categories', 'Category Sets'],
        summary     => 'Fetch single category in category set',
        description => 'Retrieve a single category by its ID.',
        parameters  => [
            { '$ref' => '#/components/parameters/category_fields' },
        ],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/category',
                        },
                    },
                },
            },
            404 => {
                description => 'Category or site not found.',
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

sub get_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set, $category ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'category_set', $category_set->id, obj_promise($category_set) )
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'category', $category->id, obj_promise($category) )
        or return;

    $category;
}

sub update_for_category_set_openapi_spec {
    +{
        tags        => ['Categories', 'Category Sets'],
        summary     => 'Update single category in category set',
        description => <<'DESCRIPTION',
**Authentication required.**

Update an existing category. This endpoint need folllowing permissions.

- Manage Categoy Set

Post form data is following:

- category (Category) - Category resource
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            category => {
                                '$ref' => '#/components/schemas/category_updatable',
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
                            '$ref' => '#/components/schemas/category',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Category_set or Category not found.',
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

sub update_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set, $orig_category ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_save_permission_filter',
        'category_set', $category_set->id )
        or return;

    my $new_category = $app->resource_object( 'category', $orig_category );

    save_object( $app, 'category', $new_category ) or return;

    $new_category;
}

sub delete_for_category_set_openapi_spec {
    +{
        tags        => ['Categories', 'Category Sets'],
        summary     => 'Delete single category in category set',
        description => <<'DESCRIPTION',
**Authentication required.**

Update an existing category. This endpoint need folllowing permissions.

- Manage Category Set
DESCRIPTION
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/category',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Category_set or Category not found.',
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

sub delete_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set, $category ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_save_permission_filter',
        'category_set', $category_set )
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'category', $category )
        or return;

    $category->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $category->class_label,
            $category->errstr
        ),
        500,
        );

    $app->run_callbacks( 'data_api_post_delete.category', $app, $category );

    $category;
}

sub permutate_for_category_set_openapi_spec {
    +{
        tags        => ['Categories', 'Category Sets'],
        summary     => 'Save hierarchical categories order in category set',
        description => <<'DESCRIPTION',
**Authentication required.**

Save hierarchical categories order. This endpoint need folllowing permissions.

- Manage Category Set

This method returns rearranged Categories collection.

Post form data is following:

- categories (array[Category]) - Array of Categories resource that were rearranged.

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
                    #        categories => {
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
                    #    categories => {
                    #        contentType => 'application/json',
                    #    },
                    #},
                    schema => {
                        type       => 'object',
                        properties => {
                            categories => {
                                type    => 'string',
                                example => <<'EXAMPLE',
[
  { "id": 0 },
  { "id": 1 } 
]
EXAMPLE
                                description => 'Array of category resource that were rearranged.',
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
                                '$ref' => '#/components/schemas/category',
                            },
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

sub permutate_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_save_permission_filter',
        'category_set', $category_set->id )
        or return;

    if ( !$app->can_do('edit_categories') ) {
        return $app->error(403);
    }

    MT::DataAPI::Endpoint::v2::Category::permutate_common( $app, $endpoint,
        $site, 'category', $category_set->id );
}

1;

