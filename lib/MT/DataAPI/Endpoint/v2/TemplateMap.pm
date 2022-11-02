# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::TemplateMap;

use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list_openapi_spec {
    +{
        tags       => ['Templates', 'TemplateMaps'],
        summary    => 'Retrieve a list of templatemaps in the specified site',
        parameters => [
            { '$ref' => '#/components/parameters/templatemap_search' },
            { '$ref' => '#/components/parameters/templatemap_searchFields' },
            { '$ref' => '#/components/parameters/templatemap_limit' },
            { '$ref' => '#/components/parameters/templatemap_offset' },
            { '$ref' => '#/components/parameters/templatemap_sortBy' },
            { '$ref' => '#/components/parameters/templatemap_sortOrder' },
            { '$ref' => '#/components/parameters/templatemap_fields' },
            { '$ref' => '#/components/parameters/templatemap_includeIds' },
            { '$ref' => '#/components/parameters/templatemap_excludeIds' },
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
                                    description => ' The total number of templatemaps.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of templatemap resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/templatemap',
                                    }
                                },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Template not found.',
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

    my ( $site, $tmpl ) = context_objects(@_) or return;

    return if !_is_archive_template( $app, $tmpl );

    my %terms = (
        blog_id     => $site->id,
        template_id => $tmpl->id,
    );

    my $res = filtered_list( $app, $endpoint, 'templatemap', \%terms )
        or return;

    return +{
        totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub get_openapi_spec {
    +{
        tags       => ['Templates', 'TemplateMaps'],
        summary    => 'Retrieve a single templatemap by its ID',
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/templatemap',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Template or TemplateMap not found.',
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

    my ( $site, $tmpl, $map ) = context_objects(@_) or return;

    return if !_is_archive_template( $app, $tmpl );

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'templatemap', $map->id, obj_promise($map) )
        or return;

    return $map;
}

sub create_openapi_spec {
    +{
        tags        => ['Templates', 'TemplateMaps'],
        summary     => 'Create a new templatemap',
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            templatemap => {
                                '$ref' => '#/components/schemas/templatemap_updatable',
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
                            '$ref' => '#/components/schemas/templatemap',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Template not found.',
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

    my ( $site, $tmpl ) = context_objects(@_) or return;

    return if !_is_archive_template( $app, $tmpl );

    my $orig_map = $app->model('templatemap')->new;
    $orig_map->set_values(
        {   blog_id      => $tmpl->blog_id,
            template_id  => $tmpl->id,
            is_preferred => 0,
        }
    );

    my $new_map = $app->resource_object( 'templatemap', $orig_map ) or return;

    save_object( $app, 'templatemap', $new_map ) or return;

    return $new_map;
}

sub update_openapi_spec {
    +{
        tags        => ['Templates', 'TemplateMaps'],
        summary     => 'Update an existing templatemap',
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            templatemap => {
                                '$ref' => '#/components/schemas/templatemap_updatable',
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
                            '$ref' => '#/components/schemas/templatemap',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Template or TemplateMap not found.',
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

    my ( $site, $tmpl, $orig_map ) = context_objects(@_) or return;

    return if !_is_archive_template( $app, $tmpl );

    my $new_map = $app->resource_object( 'templatemap', $orig_map ) or return;

    save_object( $app, 'templatemap', $new_map, $orig_map ) or return;

    return $new_map;
}

sub delete_openapi_spec {
    +{
        tags      => ['Templates', 'TemplateMaps'],
        summary   => 'Delete an existing templatemap',
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/templatemap',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Template or TemplateMap not found.',
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

    my ( $site, $tmpl, $map ) = context_objects(@_) or return;

    return if !_is_archive_template( $app, $tmpl );

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'templatemap', $map )
        or return;

    $map->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]',
            $map->class_label, $map->errstr
        ),
        500,
        );

    $app->run_callbacks( 'data_api_post_delete.templatemap', $app, $map );

    return $map;
}

sub _is_archive_template {
    my ( $app, $tmpl ) = @_;

    if (!(  grep { $tmpl->type eq $_ } qw/ individual page category archive /
        )
        )
    {
        return $app->error(
            $app->translate(
                'Template "[_1]" is not an archive template.',
                $tmpl->name
            ),
            400
        );
    }

    return 1;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::TemplateMap - Movable Type class for endpoint definitions about the MT::TemplateMap.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
