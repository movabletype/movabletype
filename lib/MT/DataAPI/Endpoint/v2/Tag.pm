# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Tag;

use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    my $res = filtered_list( $app, $endpoint, 'tag' )
        or return;

    return +{
        totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_for_site_openapi_spec {
    +{
        tags       => ['Tags'],
        summary    => 'Retrieve a list of tags that related with specific site',
        parameters => [
            { '$ref' => '#/components/parameters/tag_search' },
            { '$ref' => '#/components/parameters/tag_searchFields' },
            { '$ref' => '#/components/parameters/tag_limit' },
            { '$ref' => '#/components/parameters/tag_offset' },
            { '$ref' => '#/components/parameters/tag_sortBy' },
            { '$ref' => '#/components/parameters/tag_sortOrder' },
            { '$ref' => '#/components/parameters/tag_fields' },
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
                                    description => ' The total number of tags.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of tag resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/tag',
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

    my ($site) = context_objects(@_) or return;

    my %terms = ( blog_id => $site->id );

    my $res = filtered_list( $app, $endpoint, 'tag', \%terms )
        or return;

    return +{
        totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub get {
    my ( $app, $endpoint ) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    my $tag = _retrieve_tag($app) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'tag', $tag->id, obj_promise($tag) )
        or return;

    return $tag;
}

sub get_for_site_openapi_spec {
    +{
        tags       => ['Tags'],
        summary    => 'Retrieve a single tag by its ID',
        parameters => [
            { '$ref' => '#/components/parameters/tag_fields' },
        ],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/tag',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Tag not found.',
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

sub get_for_site {
    my ( $app, $endpoint ) = @_;

    my ($tag) = _retrieve_tag_related_to_site($app) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'tag', $tag->id, obj_promise($tag) )
        or return;

    return $tag;
}

sub rename {
    my ( $app, $endpoint ) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    my ($orig_tag) = _retrieve_tag($app) or return;

    my $new_tag = $app->resource_object( 'tag', $orig_tag )
        or return;

    my $same_name_tag = MT->model('tag')
        ->load( { name => $new_tag->name }, { binary => { name => 1 } } );

    if ($same_name_tag) {
        run_permission_filter( $app, 'data_api_save_permission_filter',
            'tag' )
            or return;

        return $app->error(304) if $same_name_tag->id == $new_tag->id;

        my @ots = MT->model('objecttag')->load( { tag_id => $new_tag->id } );
        for my $ot (@ots) {
            $ot->tag_id( $same_name_tag->id );
            $ot->save
                or return $app->error(
                $app->translate( 'Saving object failed: [_1]', $ot->errstr ),
                500
                );
        }

        return $same_name_tag;
    }
    else {

        # Do not change IDs.
        save_object( $app, 'tag', $new_tag, $orig_tag, ) or return;
        return $new_tag;
    }
}

sub rename_for_site_openapi_spec {
    +{
        tags        => ['Tags'],
        summary     => 'Update an existing tag',
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            tag => {
                                '$ref' => '#/components/schemas/tag_updatable',
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
                            '$ref' => '#/components/schemas/tag',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Tag not found.',
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

sub rename_for_site {
    my ( $app, $endpoint ) = @_;

    my ( $orig_tag, $site_id ) = _retrieve_tag_related_to_site($app)
        or return;

    my $new_tag = $app->resource_object( 'tag', $orig_tag ) or return;

    my $same_name_tag = MT::Tag->load( { name => $new_tag->name },
        { binary => { name => 1 } } );
    if ($same_name_tag) {
        run_permission_filter( $app, 'data_api_save_permission_filter',
            'tag' )
            or return;

        return $app->error(304) if $same_name_tag->id == $new_tag->id;

        my @ots = MT::ObjectTag->load(
            {   blog_id => $site_id,
                tag_id  => $new_tag->id,
            }
        );
        for my $ot (@ots) {
            $ot->tag_id( $same_name_tag->id );
            $ot->save
                or return $app->error(
                $app->translate( 'Saving object failed: [_1]', $ot->errstr ),
                500
                );
        }

        return $same_name_tag;
    }
    else {

        # Do not change IDs.
        save_object( $app, 'tag', $new_tag, $orig_tag, ) or return;
        return $new_tag;
    }
}

sub delete {
    my ( $app, $endpoint ) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    my ($tag) = _retrieve_tag($app) or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'tag', $tag )
        or return;

    if ( $tag->is_private ) {
        my $exist = MT->model('objecttag')
            ->exist( { tag_id => $tag->id, blog_id => 0 }, );
        if ($exist) {
            return $app->error(
                $app->translate(
                    'Cannot delete private tag associated with objects in system scope.'
                ),
                403
            );
        }
    }

    # Remove relations too.
    $tag->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]',
            $tag->class_label, $tag->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.tag', $app, $tag );

    return $tag;
}

sub delete_for_site_openapi_spec {
    +{
        tags      => ['Tags'],
        summary   => 'Delete an existing tag',
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/tag',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Tag not found.',
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

sub delete_for_site {
    my ( $app, $endpoint ) = @_;

    my ( $tag, $site_id ) = _retrieve_tag_related_to_site($app) or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'tag', $tag )
        or return;

    if ( !$site_id && $tag->is_private ) {
        return $app->error(
            $app->translate('Cannot delete private tag in system scope.'),
            403 );
    }

    # Remove relations.
    my $ot_class = $app->model('objecttag');
    $ot_class->remove(
        {   blog_id => $site_id,
            tag_id  => $tag->id,
        }
        )
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $tag->class_label,
            $ot_class->errstr
        ),
        500
        );

    # If no relations, remove tag.
    if ( !$ot_class->exist( { tag_id => $tag->id } ) ) {
        $tag->remove
            or return $app->error(
            $app->translate(
                'Removing [_1] failed: [_2]', $tag->class_label,
                $tag->errstr
            ),
            500
            );
    }

    $app->run_callbacks( 'data_api_post_delete.tag', $app, $tag );

    return $tag;
}

sub _retrieve_tag {
    my ($app) = @_;

    my $tag_id = $app->param('tag_id')
        or return $app->error(
        $app->translate( 'A parameter "[_1]" is required.', 'tag_id' ), 400 );

    my $tag = MT->model('tag')->load($tag_id);
    if ( !$tag || MT->model('tag')->load( { n8d_id => $tag->id } ) ) {
        return $app->error( $app->translate('Tag not found'), 404 );
    }

    return $tag;
}

sub _retrieve_tag_related_to_site {
    my ($app) = @_;

    my $site_id = $app->param('site_id');
    if ( !defined($site_id) || $site_id eq '' ) {
        return $app->error(
            $app->translate( 'A parameter "[_1]" is required.', 'site_id' ),
            400 );
    }
    if ( $site_id && !MT->model('blog')->load($site_id) ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    my $tag_id = $app->param('tag_id')
        or return $app->error(
        $app->translate( 'A parameter "[_1]" is required.', 'tag_id' ), 400 );

    my $tag = MT->model('tag')->load(
        { id => $tag_id },
        {   join => MT->model('objecttag')->join_on(
                'tag_id',
                { blog_id => $site_id },
                { unique  => 1 },
            ),
        },
    );

    if ( !$tag || MT->model('tag')->load( { n8d_id => $tag->id } ) ) {
        return $app->error( $app->translate('Tag not found'), 404 );
    }

    return ( $tag, $site_id );
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Tag - Movable Type class for endpoint definitions about the MT::Tag.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
