# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package FormattedText::DataAPI::Endpoint::v2::FormattedText;

use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list_openapi_spec {
    +{
        tags       => ['FormattedText'],
        summary    => 'Retrieve a list of formatted_texts in the specified site',
        parameters => [
            { '$ref' => '#/components/parameters/formatted_text_search' },
            { '$ref' => '#/components/parameters/formatted_text_searchFields' },
            { '$ref' => '#/components/parameters/formatted_text_limit' },
            { '$ref' => '#/components/parameters/formatted_text_offset' },
            { '$ref' => '#/components/parameters/formatted_text_sortBy' },
            { '$ref' => '#/components/parameters/formatted_text_sortOrder' },
            { '$ref' => '#/components/parameters/formatted_text_fields' },
            { '$ref' => '#/components/parameters/formatted_text_includeIds' },
            { '$ref' => '#/components/parameters/formatted_text_excludeIds' },
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
                                    description => ' The total number of formatted_texts found that by the request.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of formatted_texts resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/formatted_text',
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

    my $res = filtered_list( $app, $endpoint, 'formatted_text' ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub get_openapi_spec {
    +{
        tags       => ['FormattedText'],
        summary    => 'Retrieve single formatted_text by its ID',
        parameters => [
            { '$ref' => '#/components/parameters/formatted_text_fields' },
        ],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/formatted_text',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or FormattedText not found.',
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

    my ( $site, $ft ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'formatted_text', $ft->id, obj_promise($ft) )
        or return;

    $ft;
}

sub create_openapi_spec {
    +{
        tags        => ['FormattedText'],
        summary     => 'Create a new formatted_text',
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            formatted_text => {
                                '$ref' => '#/components/schemas/formatted_text_updatable',
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
                            '$ref' => '#/components/schemas/formatted_text',
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

    my ($site) = context_objects(@_)
        or return;
    if ( !$site->id ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    my $orig_ft = $app->model('formatted_text')->new;
    $orig_ft->set_values( { blog_id => $site->id, } );

    my $new_ft = $app->resource_object( 'formatted_text', $orig_ft )
        or return;

    save_object( $app, 'formatted_text', $new_ft, $orig_ft, ) or return;

    $new_ft;
}

sub update_openapi_spec {
    +{
        tags        => ['FormattedText'],
        summary     => 'Update a formatted_text',
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            formatted_text => {
                                '$ref' => '#/components/schemas/formatted_text_updatable',
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
                            '$ref' => '#/components/schemas/formatted_text',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or FormattedText not found.',
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

    my ( $site, $orig_ft ) = context_objects(@_)
        or return;

    my $new_ft = $app->resource_object( 'formatted_text', $orig_ft )
        or return;

    save_object(
        $app,
        'formatted_text',
        $new_ft, $orig_ft,
        sub {
            $new_ft->modified_by( $app->user->id ) if $app->user;
            $_[0]->();
        }
    ) or return;

    $new_ft;
}

sub delete_openapi_spec {
    +{
        tags      => ['FormattedText'],
        summary   => 'Delete a formatted_text',
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/formatted_text',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or FormattedText not found.',
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

    my ( $site, $ft ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'formatted_text', $ft )
        or return;

    $ft->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]',
            $ft->class_label, $ft->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.formatted_text', $app, $ft );

    $ft;
}

1;

__END__

=head1 NAME

FormattedText::DataAPI::Endpoint::v2::FormattedText - Movable Type class for endpoint definitions
about the FormattedText::FormattedText.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
