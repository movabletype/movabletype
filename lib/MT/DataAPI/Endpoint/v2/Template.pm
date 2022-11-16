# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Template;

use strict;
use warnings;

use MT::CMS::Template;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

my %SupportedType
    = map { $_ => 1 } qw/ index archive individual page category /;

sub list_openapi_spec {
    +{
        tags        => ['Templates'],
        summary     => 'Retrieve a list of templates in the specified site',
        description => <<'DESCRIPTION',
- Authorization is required.

#### Permissions

- edit_templates
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/template_search' },
            { '$ref' => '#/components/parameters/template_searchFields' },
            { '$ref' => '#/components/parameters/template_limit' },
            { '$ref' => '#/components/parameters/template_offset' },
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
                        'created_by',
                        'modified_by',
                        'type',
                    ],
                    default => 'name',
                },
                description => <<'DESCRIPTION',
#### id

Sort by the ID of each template.

#### name

Sort by the name of each template.

#### created_on

Sort by the created time of each template.

#### modified_on

Sort by the modified time of each template.

#### created_by

Sort by the ID of user who created each template.

#### modified_by

Sort by the ID of user who modified each template.

#### type

Sort by the type of each template.

**Default**: name
DESCRIPTION
            },
            { '$ref' => '#/components/parameters/template_sortOrder' },
            { '$ref' => '#/components/parameters/template_fields' },
            { '$ref' => '#/components/parameters/template_includeIds' },
            { '$ref' => '#/components/parameters/template_excludeIds' },
            {
                in          => 'query',
                name        => 'type',
                schema      => { type => 'string' },
                description => 'Filter by template type. The list should be separated by commas. (e.g. archive, custom, index, individual, page etc...)',
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
                                    type        => 'integer',
                                    description => ' The total number of templates.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of template resource.',
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

    my %terms
        = ( type => { not => [qw/ ct ct_archive backup widget widgetset /] },
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
        tags        => ['Templates'],
        summary     => 'Retrieve single template by its ID',
        description => <<'DESCRIPTION',
- Authorization is required.

#### Permissions

- edit_templates
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/template_fields' },
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

sub get {
    my ( $app, $endpoint ) = @_;

    my ( $site, $tmpl ) = context_objects(@_) or return;

    if ( grep { $tmpl->type eq $_ } qw/ widget widgetset / ) {
        return $app->error( $app->translate('Template not found'), 404 );
    }

    if ( grep { $tmpl->type eq $_ } qw / ct ct_archive / ) {
        return $app->error(
            $app->translate( 'Cannot get [_1] template.', $tmpl->type ),
            400 );
    }

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'template', $tmpl->id, obj_promise($tmpl) )
        or return;

    return $tmpl;
}

sub create_openapi_spec {
    +{
        tags        => ['Templates'],
        summary     => 'Create a new template',
        description => <<'DESCRIPTION',
- Authorization is required.

#### Permissions

- edit_templates
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            template => {
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

    my $orig_tmpl = $app->model('template')->new;
    $orig_tmpl->set_values( { blog_id => $site->id || 0, } );

    my $new_tmpl = $app->resource_object( 'template', $orig_tmpl )
        or return;

    save_object( $app, 'template', $new_tmpl )
        or return;

    # Remove autosave object
    remove_autosave_session_obj( $app, 'template' );

    return $new_tmpl;
}

sub update_openapi_spec {
    +{
        tags        => ['Templates'],
        summary     => 'Update a template',
        description => <<'DESCRIPTION',
- Authorization is required.

#### Permissions

- edit_templates
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            template => {
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

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $site, $orig_tmpl ) = context_objects(@_) or return;

    if ( grep { $orig_tmpl->type eq $_ } qw/ widget widgetset / ) {
        return $app->error( $app->translate('Template not found'), 404 );
    }

    if ( grep { $orig_tmpl->type eq $_ } qw / ct ct_archive / ) {
        return $app->error(
            $app->translate(
                'Cannot update [_1] template.',
                $orig_tmpl->type,
            ),
            400,
        );
    }

    my $new_tmpl = $app->resource_object( 'template', $orig_tmpl )
        or return;

    save_object( $app, 'template', $new_tmpl )
        or return;

    # Remove autosave object
    remove_autosave_session_obj( $app, 'template', $new_tmpl->id );

    return $new_tmpl;
}

sub delete_openapi_spec {
    +{
        tags        => ['Templates'],
        summary     => 'Delete a template',
        description => <<'DESCRIPTION',
- Authorization is required.

#### Permissions

- edit_templates
DESCRIPTION
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

sub delete {
    my ( $app, $endpoint ) = @_;

    my ( $site, $tmpl ) = context_objects(@_) or return;

    if ( grep { $tmpl->type eq $_ } qw/ widget widgetset / ) {
        return $app->error( $app->translate('Template not found'), 404 );
    }

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'template', $tmpl )
        or return;

    if ( !$SupportedType{ $tmpl->type } and $tmpl->type ne 'custom' ) {
        return $app->error(
            $app->translate( 'Cannot delete [_1] template.', $tmpl->type ),
            403 );
    }

    $tmpl->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $tmpl->class_label,
            $tmpl->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.template', $app, $tmpl );

    return $tmpl;
}

sub publish_openapi_spec {
    +{
        tags        => ['Templates'],
        summary     => 'Publish a template',
        description => <<'DESCRIPTION',
- Authorization is required.
- Only available for following templates
  - index
  - archive
  - individual
  - page
  - category

#### Permissions

- rebuild
DESCRIPTION
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
                description => 'Site or Template not found',
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

sub publish {
    my ( $app, $endpoint ) = @_;

    my ( $site, $tmpl ) = context_objects(@_) or return;

    my $type = defined( $tmpl->type ) ? $tmpl->type : '';
    if ( !$SupportedType{$type} ) {
        return $app->error(
            $app->translate( 'Cannot publish [_1] template.', $type ), 400 );
    }

    local $app->{return_args};
    local $app->{redirect};
    local $app->{redirect_use_meta};

    $app->param( 'id', $tmpl->id );

    if ( $type eq 'index' ) {
        MT::CMS::Template::publish_index_templates($app);
    }
    else {
        $app->param( 'no_rebuilding_tmpl', 1 );
        MT::CMS::Template::publish_archive_templates($app);
    }

    if ( $app->errstr ) {
        return $app->error(403);
    }

    return +{ status => 'success' };
}

sub refresh_openapi_spec {
    +{
        tags        => ['Templates'],
        summary     => 'Reset template text to theme default or tempalte_set default',
        description => <<'DESCRIPTION',
- Authorization is required.

#### Permissions

- edit_templates
DESCRIPTION
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
                description => 'Site or Template not found',
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

    my ( $site, $tmpl ) = context_objects(@_) or return;

    if ( grep { $tmpl->type eq $_ } qw/ backup widget widgetset / ) {
        return $app->error( $app->translate('Template not found'), 404 );
    }
    if ( grep { $tmpl->type eq $_ } qw / ct ct_archive / ) {
        return $app->error(
            $app->translate( 'Cannot refresh [_1] template.', $tmpl->type ),
            400 );
    }

    my @messages;
    local *MT::App::DataAPI::build_page = sub {
        my ( $app, $page, $param ) = @_;
        @messages = map { $_->{message} } @{ $param->{message_loop} };
    };

    local $app->{mode};

    $app->param( 'id', $tmpl->id );

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

sub refresh_for_site_openapi_spec {
    +{
        tags        => ['Templates'],
        summary     => 'Reset all templates in the site',
        description => <<'DESCRIPTION',
- Authorization is required.

#### Permissions

- edit_templates
DESCRIPTION
        parameters => [{
                in     => 'query',
                name   => 'refresh_type',
                schema => {
                    type => 'string',
                    enum => [
                        'refresh',
                        'clean',
                    ],
                    default => 'refresh',
                },
                description => <<'DESCRIPTION',
The type of refresh mode.

#### refresh

Refresh all templates. However, A template that created by user will never refreshed and never removed from a site.

#### clean

Refresh all templates. In this mode, A template that created by user will removed from a site.

**Default**: refresh
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
                                status => { type => 'string' },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site not found',
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

sub refresh_for_site {
    my ( $app, $endpoint ) = @_;

    my $refresh_type = $app->param('refresh_type');
    if ( !defined($refresh_type) || $refresh_type eq '' ) {
        $refresh_type = 'refresh';
        $app->param( 'refresh_type', $refresh_type );
    }
    if ( $refresh_type ne 'refresh' && $refresh_type ne 'clean' ) {
        return $app->error(
            $app->translate(
                'A parameter "refresh_type" is invalid: [_1]',
                $refresh_type
            ),
            400
        );
    }

    local $app->{redirect};
    local $app->{redirect_use_meta};
    local $app->{return_args};

    require MT::CMS::Template;
    MT::CMS::Template::refresh_all_templates($app);

    if ( $app->errstr ) {
        return $app->error( $app->errstr, 500 );
    }

    if ( $app->{redirect} ) {
        return +{ status => 'success' };
    }
    else {
        return $app->error(403);
    }
}

sub clone_openapi_spec {
    +{
        tags        => ['Templates'],
        summary     => 'Make a clone of a template',
        description => <<'DESCRIPTION',
- Authorization is required.

#### Permissions

- edit_templates
DESCRIPTION
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
                description => 'Site or Template not found',
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

    my ( $site, $tmpl ) = context_objects(@_) or return;

    #    # Check permission.
    #    my %terms = (
    #        author_id => $app->user->id,
    #        $site->id ? ( blog_id => $site->id ) : (),
    #    );
    #    if ( !$app->model('permission')->count( \%terms ) ) {
    #        return $app->error(403);
    #    }
    #
    #    my $permitted;
    #    my $iter = $app->model('permission')->load_iter( \%terms );
    #    while ( my $p = $iter->() ) {
    #        $permitted = 1 if $p->can_do('copy_template_via_list');
    #    }
    #    if ( !$permitted ) {
    #        return $app->error( 403 );
    #    }

    # Check template type.
    my $type = defined( $tmpl->type ) ? $tmpl->type : '';
    if ( !$SupportedType{$type} ) {
        return $app->error(
            $app->translate( 'Cannot clone [_1] template.', $type ), 400 );
    }

    local $app->{return_args};
    local $app->{redirect};
    local $app->{redirect_use_meta};

    $app->param( 'id', $tmpl->id );

    MT::CMS::Template::clone_templates($app);

    if ( $app->errstr ) {
        return $app->error(403);
    }

    return +{ status => 'success' };
}

sub preview_by_id_openapi_spec {
    +{
        tags        => ['Templates'],
        summary     => 'Make a preview for a template with existing data',
        description => <<'DESCRIPTION',
- Authorization is required.
- **This endpoint has been available since Movable Type 6.1.2.**
- Only available for following templates
  - index
  - archive
  - individual
  - page
  - category
  - **template** parameter is required. If you just want to get preview template from existing data, you should provide **template** parameter with empty json.

#### Permissions

- edit_templates
DESCRIPTION
        parameters => [{
                in     => 'query',
                name   => 'raw',
                schema => {
                    type    => 'integer',
                    enum    => [0, 1],
                    default => 0,
                },
                description => 'If specify "1", will be returned preview contents.',
            },
        ],
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            template => {
                                '$ref' => '#/components/schemas/template',
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
                            type       => 'object',
                            properties => {
                                status  => { type => 'string' },
                                preview => { type => 'string' },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Template not found',
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

sub preview_by_id {
    my ( $app, $endpoint ) = @_;

    my ( $site, $tmpl ) = context_objects(@_) or return;

    if ( grep { $tmpl->type eq $_ } qw/ backup widget widgetset / ) {
        return $app->error( $app->translate('Template not found'), 404 );
    }

    if ( grep { $tmpl->type eq $_ } qw / ct ct_archive / ) {
        return $app->error(
            $app->translate( 'Cannot preview [_1] template.', $tmpl->type, ),
            400,
        );
    }

    $app->param( 'id', $tmpl->id );

    return preview( $app, $endpoint );
}

sub preview_openapi_spec {
    +{
        tags        => ['Templates'],
        summary     => 'Make a preview for a template',
        description => <<'DESCRIPTION',
- Authorization is required.
- **This endpoint has been available since Movable Type 6.1.2.**
- **type** parameter in the Templates resource is required.

#### Permissions

- edit_templates
DESCRIPTION
        parameters => [{
                in     => 'query',
                name   => 'raw',
                schema => {
                    type    => 'integer',
                    enum    => [0, 1],
                    default => 0,
                },
                description => 'If specify "1", will be returned preview contents.',
            },
        ],
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            template => {
                                '$ref' => '#/components/schemas/template',
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
                            type       => 'object',
                            properties => {
                                status  => { type => 'string' },
                                preview => { type => 'string' },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site not found',
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

sub preview {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_) or return;

    # Permission check
    my $perms = $app->blog ? $app->permissions : $app->user->permissions;
    return $app->error(403)
        unless $perms || $app->user->is_superuser;
    if ( $perms && !$perms->can_edit_templates ) {
        return $app->error(403);
    }

    # Set JSON to Param
    my $tmpl_json = $app->param('template')
        or return $app->error(
        $app->translate('A resource "template" is required.'), 400 );
    my $tmpl_hash = $app->current_format->{unserialize}->($tmpl_json);
    my $names     = MT->model('template')->column_names;
    foreach my $name (@$names) {
        if ( exists $tmpl_hash->{$name} ) {
            $app->param( $name, $tmpl_hash->{$name} );
        }
    }

    my $preview_basename;
    no warnings 'redefine';
    local *MT::App::DataAPI::preview_object_basename = sub {
        require MT::App::CMS;
        $preview_basename = MT::App::CMS::preview_object_basename(@_);
    };

    # TODO: PreviewInNewWindow cannot be changed
    # when Cloud.pack is installed and this value is saved in database.
    local $app->config->{__overwritable_keys}{previewinnewwindow};

    my $old = $app->config('PreviewInNewWindow');
    $app->config( 'PreviewInNewWindow', 1 );

    require MT::CMS::Template;
    MT::CMS::Template::preview($app);

    $app->config( 'PreviewInNewWindow', $old );

    if ( $app->errstr ) {
        return $app->error( $app->errstr, 500 );
    }

    my $redirect_to = delete $app->{redirect};
    if ( $redirect_to && !$app->param('raw') ) {
        return +{
            status  => 'success',
            preview => $redirect_to,
        };
    }

    my $session_class = MT->model('session');
    my $sess          = $session_class->load( { id => $preview_basename } );
    return $app->error( $app->translate('Preview data not found.'), 404 )
        unless $sess;

    require MT::FileMgr;
    my $fmgr    = MT::FileMgr->new('Local');
    my $content = $fmgr->get_data( $sess->name );

    $fmgr->delete( $sess->name );
    $sess->remove;

    return +{
        status  => 'success',
        preview => $content
    };
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Template - Movable Type class for endpoint definitions about the MT::Template.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
