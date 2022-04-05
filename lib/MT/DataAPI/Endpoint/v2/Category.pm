# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Category;

use strict;
use warnings;

use MT::Util;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list_openapi_spec {
    +{
        tags       => ['Categories'],
        summary    => 'Retrieve categories in the specified site',
        parameters => [
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
#### user_custom

Sort order you specified on the Manage Categories screen.

#### created_by

Sort by the ID of user who created each category.

#### id

Sort by the ID of each category.

#### basename
Sort by the basename of each category.

#### label

Sort by the label of each category.

**Default**: user_custom
DESCRIPTION
            },
            { '$ref' => '#/components/parameters/category_sortOrder' },
            { '$ref' => '#/components/parameters/category_fields' },
            {
                in     => 'query',
                name   => 'top',
                schema => {
                    type    => 'integer',
                    enum    => [0, 1],
                    default => 0,
                },
                description => <<'DESCRIPTION',
If set to 1, retrieves only top level categories. New in v2

**Default**: 0
DESCRIPTION
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
    return list_common( $app, $endpoint, 'category' );
}

sub list_common {
    my ( $app, $endpoint, $class ) = @_;

    my %terms = ( category_set_id => 0 );
    if ( $app->param('top') ) {
        %terms = ( parent => 0 );
    }

    my $res = filtered_list( $app, $endpoint, $class, \%terms ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub _get_all_parent_categories {
    my ( $cat, $max_depth, $current_depth ) = @_;

    $current_depth ||= 1;
    if ( $max_depth > 0 && $current_depth > $max_depth ) {
        return;
    }

    my $parent_cat = $cat->parent_category;
    if ( !$parent_cat ) {
        return;
    }

    return (
        $parent_cat,
        _get_all_parent_categories(
            $parent_cat, $max_depth, $current_depth + 1
        )
    );
}

sub _get_all_child_categories {
    my ( $cat, $max_depth, $current_depth ) = @_;

    $current_depth ||= 1;
    if ( $max_depth > 0 && $current_depth > $max_depth ) {
        return;
    }

    my @child_cats     = $cat->children_categories;
    my @all_child_cats = map {
        (   $_,
            _get_all_child_categories( $_, $max_depth, $current_depth + 1 )
            )
    } @child_cats;

    return @all_child_cats;
}

sub list_parents_openapi_spec {
    +{
        tags       => ['Categories'],
        summary    => 'Retrieve parent categories from the specified category',
        parameters => [{
                in          => 'query',
                name        => 'maxDepth',
                schema      => { type => 'integer' },
                description => <<'DESCRIPTION',
The depth of retrieving parent categories.

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

The list does not include current category.

#### 0

The list includes current category.

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
                                        '$ref' => '#/components/schemas/category',
                                    }
                                },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Category not found.',
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

sub list_parents {
    my ( $app, $endpoint ) = @_;
    return list_parents_common( $app, $endpoint, 'category' );
}

sub list_parents_common {
    my ( $app, $endpoint, $class ) = @_;

    my $cat = get_common( $app, $endpoint, $class ) or return;

    my $max_depth = $app->param('maxDepth') || 0;
    my @parent_cats = _get_all_parent_categories( $cat, $max_depth );

    for my $parent_cat (@parent_cats) {
        run_permission_filter( $app, 'data_api_view_permission_filter',
            $class, $parent_cat->id, obj_promise($parent_cat) )
            or return;
    }

    if ( $app->param('includeCurrent') ) {
        unshift @parent_cats, $cat;
    }

    +{  totalResults => scalar @parent_cats,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( \@parent_cats ),
    };
}

sub list_siblings_openapi_spec {
    +{
        tags       => ['Categories'],
        summary    => 'Retrieve siblings categories from the specified category',
        parameters => [
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
#### user_custom

Sort order you specified on the Manage Categories screen.

#### created_by

Sort by the ID of user who created each category.

#### id

Sort by the ID of each category.

#### basename

Sort by the basename of each category.

#### label

Sort by the label of each category.

**Default**: user_custom
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
                description => <<'DESCRIPTION',
If set to 1, retrieves only top level categories. New in v2

**Default**: 0
DESCRIPTION
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
                description => 'Site or Category not found.',
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

sub list_siblings {
    my ( $app, $endpoint ) = @_;
    return list_siblings_common( $app, $endpoint, 'category' );
}

sub list_siblings_common {
    my ( $app, $endpoint, $class ) = @_;

    my $cat = get_common( $app, $endpoint, $class ) or return;

    my %terms = (
        id              => { not => $cat->id },
        blog_id         => $cat->blog_id,
        parent          => $cat->parent,
        category_set_id => 0,
    );
    my $res = filtered_list( $app, $endpoint, $class, \%terms ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_children_openapi_spec {
    +{
        tags       => ['Categories'],
        summary    => 'Retrieve child categories from the specified category',
        parameters => [{
                in          => 'query',
                name        => 'maxDepth',
                schema      => { type => 'integer' },
                description => <<'DESCRIPTION',
The depth of retrieving parent categories.

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

The list does not include current category.

#### 0

The list includes current category.

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
                                        '$ref' => '#/components/schemas/category',
                                    }
                                },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Category not found.',
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

sub list_children {
    my ( $app, $endpoint ) = @_;
    return list_children_common( $app, $endpoint, 'category' );
}

sub list_children_common {
    my ( $app, $endpoint, $class ) = @_;

    my $cat = get_common( $app, $endpoint, $class ) or return;

    my $max_depth = $app->param('maxDepth') || 0;
    my @child_cats = _get_all_child_categories( $cat, $max_depth );

    for my $child_cat (@child_cats) {
        run_permission_filter( $app, 'data_api_view_permission_filter',
            $class, $child_cat->id, obj_promise($child_cat) )
            or return;
    }

    if ( $app->param('includeCurrent') ) {
        unshift @child_cats, $cat;
    }

    +{  totalResults => scalar @child_cats,
        items => MT::DataAPI::Resource::Type::ObjectList->new( \@child_cats ),
    };
}

sub create_openapi_spec {
    +{
        tags        => ['Categories'],
        summary     => 'Create a new category',
        description => <<'DESCRIPTION',
Authorization is required.

#### Permission

- Manage Categories
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
    return create_common( $app, $endpoint, 'category' );
}

sub create_common {
    my ( $app, $endpoint, $class ) = @_;

    my ($blog) = context_objects(@_);
    return unless $blog && $blog->id;

    my $author = $app->user;

    my $orig_category = $app->model($class)->new;
    $orig_category->set_values(
        {   blog_id   => $blog->id,
            author_id => $author->id,
        }
    );

    my $new_category = $app->resource_object( $class, $orig_category )
        or return;

    if (   !defined( $new_category->basename )
        || $new_category->basename eq ''
        || $app->model($class)->exist(
            { blog_id => $blog->id, basename => $new_category->basename }
        )
        )
    {
        $new_category->basename(
            MT::Util::make_unique_category_basename($new_category) );
    }

    save_object( $app, $class, $new_category )
        or return;

    $new_category;
}

sub get_openapi_spec {
    +{
        tags       => ['Categories'],
        summary    => 'Retrieve single category by its ID',
        parameters => [
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

sub get {
    my ( $app, $endpoint ) = @_;
    return get_common( $app, $endpoint, 'category' );
}

sub get_common {
    my ( $app, $endpoint, $class ) = @_;

    my ( $blog, $category ) = context_objects(@_)
        or return;

    if ( $category->category_set_id ) {
        return $app->error(
            $app->translate( '[_1] not found', $category->class_label ),
            404, );
    }

    run_permission_filter( $app, 'data_api_view_permission_filter',
        $class, $category->id, obj_promise($category) )
        or return;

    $category;
}

sub update_openapi_spec {
    +{
        tags        => ['Categories'],
        summary     => 'Update an existing category',
        description => <<'DESCRIPTION',
- Authorization is required.

#### Permission

- Manage Categories
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
                description => 'Site or Category not found.',
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
    return update_common( $app, $endpoint, 'category' );
}

sub update_common {
    my ( $app, $endpoint, $class ) = @_;

    my ( $blog, $orig_category ) = context_objects(@_)
        or return;

    if ( $orig_category->category_set_id ) {
        return $app->error(
            $app->translate( '[_1] not found', $orig_category->class_label ),
            404,
        );
    }

    my $new_category = $app->resource_object( $class, $orig_category )
        or return;

    save_object(
        $app, $class,
        $new_category,
        $orig_category,
        sub {
            $new_category->modified_by( $app->user->id );
            $_[0]->();
        }
    ) or return;

    $new_category;
}

sub delete_openapi_spec {
    +{
        tags        => ['Categories'],
        summary     => 'Delete an existing category',
        description => <<'DESCRIPTION',
- Authorization is required.
- This method returns deleted Category resource.

#### Permission

- Manage Categories
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
                description => 'Site or Category not found.',
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

    my ( $blog, $category ) = context_objects(@_)
        or return;

    if ( $category->category_set_id ) {
        return $app->error(
            $app->translate( '[_1] not found', $category->class_label ),
            404, );
    }

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'category', $category )
        or return;

    require MT::CMS::Category;
    MT::CMS::Category::pre_delete( $app, $category )
        or return;

    $category->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $category->class_label,
            $category->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.category', $app, $category );

    $category;
}

sub list_for_entry_openapi_spec {
    +{
        tags        => ['Categories'],
        summary     => 'Retrieve categories in the specified entry',
        description => <<'DESCRIPTION',
#### Permissions

- edit_entry
  - If you want to retrieve the non-published entry's categories.

DESCRIPTION
        parameters => [
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
#### user_custom

Sort order you specified on the Manage Categories screen.

#### created_by

Sort by the ID of user who created each category.

#### id

Sort by the ID of each category.

#### basename

Sort by the basename of each category.

#### label

Sort by the label of each category.

**Default**: user_custom
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
                description => <<'DESCRIPTION',
If set to 1, retrieves only top level categories. New in v2

**Default**: 0
DESCRIPTION
            },
            { '$ref' => '#/components/parameters/category_includeIds' },
            { '$ref' => '#/components/parameters/category_excludeIds' },
            {
                in     => 'query',
                name   => 'type',
                schema => {
                    type => 'string',
                    enum => [
                        'primary',
                        'secondary',
                    ],
                },
                description => <<'DESCRIPTION',
#### primary

Retrieve primary category only

#### secondary

Retrieve secondary categories only
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
                description => 'Site or Entry not found.',
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

sub list_for_entry {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $entry ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'entry', $entry->id, obj_promise($entry) )
        or return;

    my $rows = $entry->__load_category_data or return;

    my $type = $app->param('type') || '';
    if ( $type eq 'primary' ) {
        @$rows = grep { $_->[1] } @$rows;    # primary only
    }
    elsif ( $type eq 'secondary' ) {
        @$rows = grep { !$_->[1] } @$rows;    # secondary only
    }
    else {
        # primary and secondary
        @$rows
            = ( ( grep { $_->[1] } @$rows ), ( grep { !$_->[1] } @$rows ) );
    }

    my %terms = (
        id => @$rows ? [ map { $_->[0] } @$rows ] : 0,
        category_set_id => 0,
    );
    my $res = filtered_list( $app, $endpoint, 'category', \%terms ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub permutate_openapi_spec {
    +{
        tags        => ['Categories'],
        summary     => 'Rearrange existing categories in a new order',
        description => <<'DESCRIPTION',
- Authorization is required.
- This method returns rearranged Categories resource.

#### Permission

- Manage Categories
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

    if ( !$app->can_do('edit_categories') ) {
        return $app->error(403);
    }

    return permutate_common( $app, $endpoint, $site, 'category' );
}

sub permutate_common {
    my ( $app, $endpoint, $site, $class, $category_set_id ) = @_;

    $category_set_id ||= 0;
    my $class_plural = ( $class eq 'category' ) ? 'categories' : 'folders';

    my $categories_json = $app->param($class_plural)
        or return $app->error(
        $app->translate( 'A parameter "' . $class_plural . '" is required.' ),
        400
        );

    my $invalid_error = sub {
        $app->error(
            $app->translate(
                'A parameter "' . $class_plural . '" is invalid.'
            ),
            400
        );
    };

    my $categories_array
        = $app->current_format->{unserialize}->($categories_json);
    if ( ref $categories_array ne 'ARRAY' ) {
        return $invalid_error->();
    }

    my @categories;
    for my $c (@$categories_array) {
        if ( ref $c ne 'HASH' || !exists $c->{id} ) {
            return $invalid_error->();
        }

        my $cat = $app->model($class)->load(
            {   id              => $c->{id},
                class           => $class,
                category_set_id => $category_set_id
            }
        ) or return $invalid_error->();

        push @categories, $cat;
    }

    my $parameter_ids
        = join( ',', sort { $a <=> $b } map { $_->{id} } @$categories_array );
    my $exist_ids = join(
        ',',
        sort    { $a <=> $b }
            map { $_->id } (
            $app->model($class)->load(
                { blog_id => $site->id, category_set_id => $category_set_id }
            )
            )
    );
    if ( ( $parameter_ids || '' ) ne ( $exist_ids || '' ) ) {
        return $invalid_error->();
    }

    my $category_order = join( ',', map { $_->id } @categories );

    if ($category_set_id) {
        my $category_set = MT->model('category_set')->load($category_set_id)
            or return $app->error(
            $app->translate(
                'Loading object failed: [_1]',
                MT->model('category_set')->errstr
            ),
            500
            );
        $category_set->order($category_order);
        $category_set->save
            or return $app->error(
            $app->translate(
                'Saving object failed: [_1]',
                $category_set->errstr
            ),
            500
            );
    }
    else {
        my $column = $class . '_order';
        $site->$column($category_order);
        $site->save
            or return $app->error(
            $app->translate( 'Saving object failed: [_1]', $site->errstr ),
            500 );
    }

    $app->run_callbacks( 'data_api_post_bulk_save.' . $class,
        $app, \@categories );

    return MT::DataAPI::Resource->from_object( \@categories );

}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Category - Movable Type class for endpoint definitions about the MT::Category.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut

