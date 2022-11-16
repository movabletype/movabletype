# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::WidgetSet;

use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

my @fields
    = qw( id name updatable widgets blog createdBy createdDate modifiedBy modifiedDate );

sub list_openapi_spec {
    +{
        tags       => ['WidgetSets'],
        summary    => 'Retrieve a list of widgetsets in the specified site',
        parameters => [
            { '$ref' => '#/components/parameters/widgetset_search' },
            { '$ref' => '#/components/parameters/widgetset_searchFields' },
            { '$ref' => '#/components/parameters/widgetset_limit' },
            { '$ref' => '#/components/parameters/widgetset_offset' },
            { '$ref' => '#/components/parameters/widgetset_sortBy' },
            { '$ref' => '#/components/parameters/widgetset_sortOrder' },
            { '$ref' => '#/components/parameters/widgetset_fields' },
            { '$ref' => '#/components/parameters/widgetset_includeIds' },
            { '$ref' => '#/components/parameters/widgetset_excludeIds' },
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
                                    description => ' The total number of widgetsets.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of widgetset resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/template',
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

    my ($site) = context_objects(@_) or return;

    my %terms = (
        blog_id => $site->id,
        type    => 'widgetset',
    );

    my $res = filtered_list( $app, $endpoint, 'template', \%terms ) or return;

    return +{
        totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource->from_object( $res->{objects}, \@fields ),
    };
}

sub list_all {
    my ( $app, $endpoint ) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    my %terms = ( type => 'widgetset', );

    my $res = filtered_list( $app, $endpoint, 'template', \%terms ) or return;

    return +{
        totalResults => ( $res->{count} || 0 ),
        items =>
            MT::DataAPI::Resource->from_object( $res->{objects}, \@fields ),
    };
}

sub get_openapi_spec {
    +{
        tags       => ['WidgetSets'],
        summary    => 'Retrieve a single widgetset by its ID',
        parameters => [
            { '$ref' => '#/components/parameters/widgetset_fields' },
        ],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/template',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or WidgetSet not found.',
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

    my ( $site, $ws ) = _retrieve_site_and_widgetset($app) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'template', $ws->id, obj_promise($ws) )
        or return;

    return MT::DataAPI::Resource->from_object( $ws, \@fields );
}

sub create_openapi_spec {
    +{
        tags        => ['WidgetSets'],
        summary     => 'Create a new widgetset',
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            widgetset => {
                                '$ref' => '#/components/schemas/template_updatable',
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
                            '$ref' => '#/components/schemas/template',
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

    my $ws_json = $app->param('widgetset');
    my $ws_resource;
    if ($ws_json) {
        $ws_resource = $app->current_format->{unserialize}->($ws_json);
    }
    if ( !$ws_json || !$ws_resource ) {
        return $app->error(
            $app->translate('A resource "widgetset" is required.'), 400 );
    }

    my $orig_ws = $app->model('template')->new;
    $orig_ws->set_values(
        {   blog_id => $site->id,
            type    => 'widgetset',
        }
    );

    my $new_ws = $orig_ws->clone;
    if ( exists $ws_resource->{name} ) {
        $new_ws->name( $ws_resource->{name} );
    }
    if ( exists $ws_resource->{widgets}
        && ref( $ws_resource->{widgets} ) eq 'ARRAY' )
    {
        my @resource_widget_ids
            = map { $_->{id} } @{ $ws_resource->{widgets} };
        my @widgets = $app->model('template')->load(
            {   id   => \@resource_widget_ids,
                type => 'widget',
            }
        );
        my $widget_ids = join( ',', map { $_->id } @widgets );
        $new_ws->modulesets($widget_ids);
    }

    save_object( $app, 'widgetset', $new_ws, $orig_ws ) or return;

    return MT::DataAPI::Resource->from_object( $new_ws, \@fields );
}

sub update_openapi_spec {
    +{
        tags        => ['WidgetSets'],
        summary     => 'Update an existing widgetset',
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            widgetset => {
                                '$ref' => '#/components/schemas/template_updatable',
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
                            '$ref' => '#/components/schemas/template',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or WidgetSet not found.',
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

    my ( $site, $orig_ws ) = _retrieve_site_and_widgetset($app) or return;

    my $new_ws = $orig_ws->clone;

    my $ws_json = $app->param('widgetset')
        or return $app->error(
        $app->translate('A resource "widgetset" is required.'), 400 );
    my $ws_resource = $app->current_format->{unserialize}->($ws_json);

    if ( exists $ws_resource->{name} ) {
        $new_ws->name( $ws_resource->{name} );
    }
    if ( exists $ws_resource->{widgets}
        && ref( $ws_resource->{widgets} ) eq 'ARRAY' )
    {
        my @resource_widget_ids
            = map { $_->{id} } @{ $ws_resource->{widgets} };
        my @widgets = $app->model('template')->load(
            {   id   => \@resource_widget_ids,
                type => 'widget',
            }
        );
        my $widget_ids = join( ',', map { $_->id } @widgets );
        $new_ws->modulesets($widget_ids);
    }

    save_object( $app, 'widgetset', $new_ws, $orig_ws ) or return;

    return MT::DataAPI::Resource->from_object( $new_ws, \@fields );
}

sub delete_openapi_spec {
    +{
        tags      => ['WidgetSets'],
        summary   => 'Delete an existing widgetset',
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/template',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or WidgetSet not found.',
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

    my ( $site, $ws ) = _retrieve_site_and_widgetset($app) or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'template', $ws )
        or return;

    $ws->remove
        or return $app->error(
        $app->translate( 'Removing Widgetset failed: [_1]', $ws->errstr ),
        500 );

    $app->run_callbacks( 'data_api_post_delete.template', $app, $ws );

    return MT::DataAPI::Resource->from_object( $ws, \@fields );
}

sub _retrieve_site_and_widgetset {
    my ($app) = @_;

    my $site_id = $app->param('site_id') || 0;
    my $site;
    if ($site_id) {
        $site = $app->model('blog')->load($site_id)
            or return $app->error( $app->translate('Site not found'), 404 );
    }
    else {
        $site = $app->model('blog')->new;
        $site->id(0);
    }

    my $ws_id = $app->param('widgetset_id');
    my $ws    = $app->model('template')->load(
        {   id      => $ws_id,
            blog_id => $site->id,
            type    => 'widgetset',
        }
    );
    if ( !$ws ) {
        return $app->error( $app->translate('Widgetset not found'), 404 );
    }

    return ( $site, $ws );
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::WidgetSet - Movable Type class for endpoint definitions about the WidgetSet (MT::Template).

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
