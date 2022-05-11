# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Plugin;

use strict;
use warnings;

use boolean ();

use MT::App;
use MT::CMS::Plugin;
use MT::DataAPI::Endpoint::Common;

sub list_openapi_spec {
    +{
        tags      => ['Plugins'],
        summary   => 'Retrieve a list of plugins in the specified site',
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
                                    description => ' The total number of plugins.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of plugin resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/plugin',
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

    run_permission_filter( $app, 'data_api_list_permission_filter', 'plugin' )
        or return;

    my %param;
    MT::CMS::Plugin::build_plugin_table(
        $app,
        param => \%param,
        scope => 'system'
    );

    my $plugins = _to_object( $param{plugin_loop} );

    return +{
        totalResults => scalar(@$plugins) || 0,
        items => $plugins,
    };
}

sub get_openapi_spec {
    +{
        tags       => ['Plugins'],
        summary    => 'Retrieve single plugin by its ID',
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/plugin',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Plugin not found.',
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

    run_permission_filter( $app, 'data_api_view_permission_filter', 'plugin' )
        or return;

    return _retrieve_plugin($app);
}

sub enable_openapi_spec {
    +{
        tags      => ['Plugins'],
        summary   => 'Enable a plugin',
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
                description => 'Site or Plugin not found',
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

sub enable {
    my ( $app, $endpoint ) = @_;
    my $plugin = _retrieve_plugin($app) or return;
    _switch_plugin_state( $app, $plugin->{signature}, 'on' );
}

sub disable_openapi_spec {
    +{
        tags      => ['Plugins'],
        summary   => 'Disable a plugin',
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
                description => 'Site or Plugin not found',
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

sub disable {
    my ( $app, $endpoint ) = @_;
    my $plugin = _retrieve_plugin($app) or return;
    _switch_plugin_state( $app, $plugin->{signature}, 'off' );
}

sub enable_all_openapi_spec {
    +{
        tags      => ['Plugins'],
        summary   => 'Enable all plugins',
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
                description => 'Site or Plugin not found',
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

sub enable_all {
    my ( $app, $endpoint ) = @_;
    _switch_plugin_state( $app, '*', 'on' );
}

sub disable_all_openapi_spec {
    +{
        tags      => ['Plugins'],
        summary   => 'Disable all plugins',
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
                description => 'Site or Plugin not found',
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

sub disable_all {
    my ( $app, $endpoint ) = @_;
    _switch_plugin_state( $app, '*', 'off' );
}

sub _switch_plugin_state {
    my ( $app, $plugin_id, $state ) = @_;

    $app->param( 'plugin_sig', $plugin_id );
    $app->param( 'state',      $state );

    local $app->{return_args};
    local $app->{redirect};
    local $app->{redirect_use_meta};

    MT::CMS::Plugin::plugin_control($app);
    return if $app->errstr;

    return +{ status => 'success' };
}

sub _retrieve_plugin {
    my ($app) = @_;

    my $plugin_id = $app->param('plugin_id');
    if ( !defined $plugin_id || $plugin_id eq '' ) {
        return $app->error(
            $app->translate( 'A parameter "[_1]" is required.', 'plugin_id' ),
            400
        );
    }

    my %param;
    MT::CMS::Plugin::build_plugin_table(
        $app,
        param => \%param,
        scope => 'system'
    );

    my @plugin_loop = grep {
        ( defined $_->{plugin_id} ? $_->{plugin_id} : '' ) eq $plugin_id
            || ( defined $_->{plugin_sig} ? $_->{plugin_sig} : '' ) eq
            $plugin_id
    } @{ $param{plugin_loop} };

    my ($plugin) = @{ _to_object( \@plugin_loop ) }
        or return $app->error( $app->translate('Plugin not found'), 404 );

    return $plugin;
}

sub _to_object {
    my ($plugin_loop) = @_;

    my @plugins;
    my $plugin_set;

    for my $p (@$plugin_loop) {

        if ( $p->{plugin_folder} ) {
            $plugin_set = $p->{plugin_folder};
            next;
        }

        my %plugin = (
            id        => $p->{plugin_id},
            signature => $p->{plugin_sig},
            name      => $p->{plugin_name},
            icon      => $p->{plugin_icon},
            pluginSet => $plugin_set,
            status    => $p->{plugin_disabled} ? 'Disabled' : 'Enabled',
            !$p->{plugin_disabled}
            ? ( version      => $p->{plugin_version},
                description  => $p->{plugin_desc},
                pluginLink   => $p->{plugin_plugin_link},
                authorName   => $p->{plugin_author_name},
                authorLink   => $p->{plugin_author_link},
                documentLink => $p->{plugin_doc_link},
                configLink   => $p->{plugin_config_link},
                tags         => [ map { $_->{name} } @{ $p->{plugin_tags} } ],
                attributes =>
                    [ map { $_->{name} } @{ $p->{plugin_attributes} } ],
                textFilters =>
                    [ map { $_->{name} } @{ $p->{plugin_text_filters} } ],
                junkFilters =>
                    [ map { $_->{name} } @{ $p->{plugin_junk_filters} } ],
                $MT::DebugMode ? ( errors => $p->{compat_errors} ) : (),
                )
            : (),
        );

        push @plugins, \%plugin;
    }

    return \@plugins;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Plugin - Movable Type class for endpoint definitions about the MT::Plugin.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
