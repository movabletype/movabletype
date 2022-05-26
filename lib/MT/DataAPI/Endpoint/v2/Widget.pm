# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Widget;

use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list_openapi_spec {
    +{
        tags       => ['Widgets'],
        summary    => 'Retrieve a list of widgets in the specified site',
        parameters => [
            { '$ref' => '#/components/parameters/widget_search' },
            { '$ref' => '#/components/parameters/widget_searchFields' },
            { '$ref' => '#/components/parameters/widget_limit' },
            { '$ref' => '#/components/parameters/widget_offset' },
            { '$ref' => '#/components/parameters/widget_sortBy' },
            { '$ref' => '#/components/parameters/widget_sortOrder' },
            { '$ref' => '#/components/parameters/widget_fields' },
            { '$ref' => '#/components/parameters/widget_includeIds' },
            { '$ref' => '#/components/parameters/widget_excludeIds' },
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
                                    description => ' The total number of widgets.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of widget resource.',
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
        type    => 'widget',
    );

    my $res = filtered_list( $app, $endpoint, 'template', \%terms ) or return;

    return +{
        totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_all {
    my ( $app, $endpoint ) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    my %terms = ( type => 'widget', );

    my $res = filtered_list( $app, $endpoint, 'template', \%terms ) or return;

    return +{
        totalResults => ( $res->{count} || 0 ),
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_for_widgetset_openapi_spec {
    +{
        tags       => ['Widgets', 'WidgetSets'],
        summary    => 'Retrieve a list of widgets in the specified widgetset',
        parameters => [
            { '$ref' => '#/components/parameters/widget_search' },
            { '$ref' => '#/components/parameters/widget_searchFields' },
            { '$ref' => '#/components/parameters/widget_limit' },
            { '$ref' => '#/components/parameters/widget_offset' },
            { '$ref' => '#/components/parameters/widget_sortBy' },
            { '$ref' => '#/components/parameters/widget_sortOrder' },
            { '$ref' => '#/components/parameters/widget_fields' },
            { '$ref' => '#/components/parameters/widget_includeIds' },
            { '$ref' => '#/components/parameters/widget_excludeIds' },
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
                                    description => ' The total number of widgets.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of widget resource.',
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

sub list_for_widgetset {
    my ( $app, $endpoint ) = @_;

    my ( $site, $ws ) = _retrieve_site_and_widgetset($app) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'template', $ws->id, obj_promise($ws) )
        or return;

    my @widget_ids = split ',', $ws->modulesets;
    my %terms = (
        id   => \@widget_ids,
        type => 'widget',
    );

    my $res = filtered_list( $app, $endpoint, 'template', \%terms ) or return;

    return +{
        totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub get_openapi_spec {
    +{
        tags       => ['Widgets'],
        summary    => 'Retrieve a single widget by its ID',
        parameters => [
            { '$ref' => '#/components/parameters/widget_fields' },
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
                description => 'Site or Widget not found.',
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

    my ( $site, $widget ) = _retrieve_site_and_widget($app) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'template', $widget->id, obj_promise($widget) )
        or return;

    return $widget;
}

sub get_for_widgetset_openapi_spec {
    +{
        tags       => ['Widgets', 'WidgetSets'],
        summary    => 'Retrieve a single widget by widgetset ID',
        parameters => [
            { '$ref' => '#/components/parameters/widget_fields' },
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
                description => 'Site or Widget not found.',
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

sub get_for_widgetset {
    my ( $app, $endpoint ) = @_;

    my ( $site, $ws ) = _retrieve_site_and_widgetset($app) or return;

    my $widget_id = $app->param('widget_id');
    my $widget    = $app->model('template')->load(
        {   id   => $widget_id,
            type => 'widget',
        }
    );

    my @widget_ids = split /,/, $ws->modulesets;

    if ( !$widget || !( grep { $widget->id == $_ } @widget_ids ) ) {
        return $app->error( $app->translate('Widget not found'), 404 );
    }

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'template', $widget->id, obj_promise($widget) )
        or return;

    return $widget;
}

sub create_openapi_spec {
    +{
        tags        => ['Widgets'],
        summary     => 'Create a new widget',
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            widget => {
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

    my $orig_widget = $app->model('template')->new;
    $orig_widget->set_values(
        {   blog_id => $site->id || 0,
            type => 'widget',
        }
    );

    my $new_widget = $app->resource_object( 'widget', $orig_widget )
        or return;

    save_object( $app, 'widget', $new_widget, $orig_widget ) or return;

    return $new_widget;
}

sub update_openapi_spec {
    +{
        tags        => ['Widgets'],
        summary     => 'Update a widget',
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            widget => {
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
                description => 'Site or Widget not found.',
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

    my ( $site, $orig_widget ) = _retrieve_site_and_widget($app) or return;

    my $new_widget = $app->resource_object( 'widget', $orig_widget )
        or return;

    save_object( $app, 'widget', $new_widget, $orig_widget ) or return;

    return $new_widget;
}

sub delete_openapi_spec {
    +{
        tags      => ['Widgets'],
        summary   => 'Delete a widget',
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
                description => 'Site or Widget not found.',
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

    my ( $site, $widget ) = _retrieve_site_and_widget($app) or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'template', $widget )
        or return;

    $widget->remove
        or return $app->error(
        $app->translate( 'Removing Widget failed: [_1]', $widget->errstr ),
        500 );

    $app->run_callbacks( 'data_api_post_delete.template', $app, $widget );

    return $widget;
}

sub refresh_openapi_spec {
    +{
        tags      => ['Widgets'],
        summary   => 'Reset widget text to default',
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                status   => { type => 'string' },
                                messages => {
                                    type  => 'array',
                                    items => {
                                        type => 'string',
                                    },
                                },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Widget not found',
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

sub refresh {
    my ( $app, $endpoint ) = @_;

    my ( $site, $widget ) = _retrieve_site_and_widget($app) or return;

    my @messages;
    require MT::App::DataAPI;
    local *MT::App::DataAPI::build_page = sub {
        my ( $app, $page, $param ) = @_;
        @messages = map { $_->{message} } @{ $param->{message_loop} };
    };

    local $app->{mode};

    $app->param( 'id', $widget->id );

    require MT::CMS::Template;
    MT::CMS::Template::refresh_individual_templates($app);

    if ( $app->errstr ) {
        return $app->error(403);
    }

    return +{
        status   => 'success',
        messages => \@messages,
    };
}

sub clone_openapi_spec {
    +{
        tags        => ['Widgets'],
        summary     => 'Make a clone of a widget',
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                status => { type => 'string' },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Widget not found',
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

sub clone {
    my ( $app, $endpoint ) = @_;

    my ( $site, $widget ) = _retrieve_site_and_widget($app) or return;

    local $app->{return_args};
    local $app->{redirect};
    local $app->{redirect_use_meta};

    $app->param( 'id', $widget->id );

    require MT::CMS::Template;
    MT::CMS::Template::clone_templates($app);

    if ( $app->errstr ) {
        return $app->error(403);
    }

    return +{ status => 'success' };
}

sub _retrieve_site_and_widget {
    my ($app) = @_;

    my $site_id = $app->param('site_id');
    my $site;
    if ($site_id) {
        $site = $app->model('blog')->load($site_id)
            or return $app->error( $app->translate('Site not found'), 404 );
    }
    else {
        $site = $app->model('blog')->new;
        $site->id(0);
    }

    my $widget_id = $app->param('widget_id');
    my $widget    = $app->model('template')->load(
        {   id      => $widget_id,
            blog_id => $site->id,
            type    => 'widget',
        }
    );
    if ( !$widget ) {
        return $app->error( $app->translate('Widget not found'), 404 );
    }

    return ( $site, $widget );
}

sub _retrieve_site_and_widgetset {
    my ($app) = @_;

    my $site_id = $app->param('site_id');
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

MT::DataAPI::Endpoint::v2::Widget - Movable Type class for endpoint definitions about the Widget (MT::Template).

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
