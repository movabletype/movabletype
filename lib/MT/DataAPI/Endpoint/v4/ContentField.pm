# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v4::ContentField;
use strict;
use warnings;

use Hash::Merge::Simple;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list_openapi_spec {
    +{
        tags        => ['Content Fields', 'Content Types'],
        summary     => 'Content Field Collection',
        description => <<'DESCRIPTION',
**Authentication required**

Retrieve a list of Content Fields of the specified Content Type. This endpoint requires following permission.

- Manage Content Types
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/content_field_limit' },
            { '$ref' => '#/components/parameters/content_field_offset' },
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
            { '$ref' => '#/components/parameters/content_field_sortOrder' },
            { '$ref' => '#/components/parameters/content_field_fields' },
            { '$ref' => '#/components/parameters/content_field_includeIds' },
            { '$ref' => '#/components/parameters/content_field_excludeIds' },
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
                                        '$ref' => '#/components/schemas/cf',
                                    }
                                },
                            },
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

sub list {
    my ( $app, $endpoint ) = @_;

    my ( $site, $content_type ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'content_type', $content_type->id, obj_promise($content_type) )
        or return;

    my $res = filtered_list(
        $app,
        $endpoint,
        'content_field',
        {   blog_id         => $content_type->blog_id,
            content_type_id => $content_type->id,
        }
    ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub create_openapi_spec {
    +{
        tags        => ['Content Types', 'Content Fields'],
        summary     => 'Create Content Field',
        description => <<'DESCRIPTION',
**Authentication required**

Create a new Content Field. This endpoint requires following permission.

- Manage Content Types

Post form data is as follows.

- content_field (required, ContentField) - Single Content Field resource
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            content_field => {
                                '$ref' => '#/components/schemas/cf_updatable',
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
                            '$ref' => '#/components/schemas/cf',
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

sub create {
    my ( $app, $endpoint ) = @_;

    my ( $site, $content_type ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_save_permission_filter',
        'content_type', $content_type->id )
        or return;

    my $orig_content_field = $app->model('content_field')->new(
        blog_id         => $content_type->blog_id,
        content_type_id => $content_type->id,
    );

    my $new_content_field
        = $app->resource_object( 'content_field', $orig_content_field )
        or return;

    save_object( $app, 'content_field', $new_content_field,
        $orig_content_field,
        _build_around_filter( $app, $content_type, $new_content_field ),
    ) or return;

    $new_content_field;
}

sub _build_around_filter {
    my ( $app, $content_type, $new_content_field ) = @_;
    return sub {
        my $save_method = shift;
        $save_method->() or return;

        my $fields = $content_type->fields;
        my ($field)
            = grep { ( $_->{id} || 0 ) eq $new_content_field->id } @$fields;
        unless ($field) {
            $field = { id => $new_content_field->id };
            push @$fields, $field;
        }
        $field->{options} ||= {};
        $field->{options}{label}       = $new_content_field->name;
        $field->{options}{description} = $new_content_field->description;

        $field->{type}      = $new_content_field->type;
        $field->{unique_id} = $new_content_field->unique_id;
        my $content_field_types = $app->registry('content_field_types');
        my $type_label = $content_field_types->{ $field->{type} }->{label};
        $type_label = $type_label->() if 'CODE' eq ref $type_label;
        $field->{type_label} = $type_label;
        $field->{order}      = scalar @$fields || 0;

        my $hashes = $app->request('data_api_content_field_hashes_for_save');
        if ( my $hash = shift @{ $hashes || [] } ) {
            $field->{options} = Hash::Merge::Simple->merge( $field->{options},
                $hash->{options} );
        }

        $content_type->fields($fields);
        $content_type->save
            or return $new_content_field->error( $content_type->errstr );
    };
}

sub get_openapi_spec {
    +{
        tags        => ['Content Types', 'Content Fields'],
        summary     => 'Fetch single Content Field',
        description => <<'DESCRIPTION',
**Authentication required**

Fetch single content field. This endpoint requires following permission.

- Manage Content Types
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/content_field_fields' },
        ],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/cf',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Content_type or Content_field not found.',
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

    my ( $site, $content_type, $content_field ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'content_type', $content_type->id, obj_promise($content_type) )
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'content_field', $content_field->id, obj_promise($content_field) )
        or return;

    $content_field;
}

sub update_openapi_spec {
    +{
        tags        => ['Content Types', 'Content Fields'],
        summary     => 'Update Content Field',
        description => <<'DESCRIPTION',
**Authentication required**

Update content field. This endpoint requires following permission.

- Manage Content Types

If you want to update label, description and required, should be use options field. (e.g, {“options”:{“label”:“foo”}})
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            content_field => {
                                '$ref' => '#/components/schemas/cf_updatable',
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
                            '$ref' => '#/components/schemas/cf',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Content_type or Content_field not found.',
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

    my ( $site, $content_type, $orig_content_field ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_save_permission_filter',
        'content_type', $content_type->id )
        or return;

    my $new_content_field
        = $app->resource_object( 'content_field', $orig_content_field );

    save_object(
        $app, 'content_field', $new_content_field, undef,
        _build_around_filter( $app, $content_type, $new_content_field ),

    ) or return;

    $new_content_field;
}

sub delete_openapi_spec {
    +{
        tags        => ['Content Types', 'Content Fields'],
        summary     => 'Delete Content Field',
        description => <<'DESCRIPTION',
**Authentication required**

Delete content field from specified content type. This endpoint requires following permission.

- Manage Content Types
DESCRIPTION
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/cf',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Content_type or Content_field not found.',
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

    my ( $site, $content_type, $content_field ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_save_permission_filter',
        'content_type', $content_type )
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'content_field', $content_field )
        or return;

    $content_field->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $content_field->class_label,
            $content_field->errstr
        ),
        500,
        );

    $app->run_callbacks( 'data_api_post_delete.content_field',
        $app, $content_field );

    $content_field;
}

sub permutate_openapi_spec {
    +{
        tags        => ['Content Types', 'Content Fields'],
        summary     => 'Save hierarchical content field order',
        description => <<'DESCRIPTION',
**Authentication required.**

Rearranges content field order in specified content type. This endpoint need folllowing permissions.

- Manage Content Types

This method returns rearranged ContentField collection.

Post form data is following:

- content_fields (array[ContentField]) - Array of content fields resource that were rearranged.
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
                    #        content_fields => {
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
                    #    content_fields => {
                    #        contentType => 'application/json',
                    #    },
                    #},
                    schema => {
                        type       => 'object',
                        properties => {
                            content_fields => {
                                type    => 'string',
                                example => <<'EXAMPLE',
[
  { "id": 0 },
  { "id": 1 } 
]
EXAMPLE
                                description => 'Array of content fields resource that were rearranged.',
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
                                '$ref' => '#/components/schemas/cf',
                            },
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

sub permutate {
    my ( $app, $endpoint ) = @_;

    my ( $site, $content_type ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_save_permission_filter',
        'content_type', $content_type )
        or return;

    my $content_fields_json = $app->param('content_fields')
        or return $app->error(
        $app->translate('A parameter "content_fields" is required.'), 400 );

    my $content_fields_array
        = $app->current_format->{unserialize}->($content_fields_json);
    return _invalid_error($app) if ref $content_fields_array ne 'ARRAY';

    my @content_field_ids = map { $_->{id} } @$content_fields_array;
    my @content_fields    = MT->model('content_field')->load(
        {   id              => \@content_field_ids,
            content_type_id => $content_type->id,
        }
    );
    my %content_fields_hash = map { $_->id => $_ } @content_fields;
    @content_fields = map { $content_fields_hash{$_} } @content_field_ids;

    my $sorted_orig_ids = join ',',
        sort map { $_->{id} } @{ $content_type->fields };
    my $sorted_param_ids = join ',', sort map { $_->id } @content_fields;
    return _invalid_error($app) if $sorted_orig_ids ne $sorted_param_ids;

    my $order         = 1;
    my %fields_hash   = map { $_->{id} => $_ } @{ $content_type->fields };
    my @sorted_fields = map { $fields_hash{$_} } @content_field_ids;
    $_->{order} = $order++ for @sorted_fields;
    $content_type->fields( \@sorted_fields );
    $content_type->save
        or return $app->error(
        $app->translate(
            'Saving object failed: [_1]', $content_type->errstr
        )
        );

    return MT::DataAPI::Resource->from_object( \@content_fields );
}

sub _invalid_error {
    my $app = shift;
    $app->error( $app->translate('A parameter "content_fields" is invalid.'),
        400 );
}

1;

