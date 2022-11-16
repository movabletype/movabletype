# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Page;

use strict;
use warnings;

use MT::Util;
use MT::DataAPI::Endpoint::v1::Entry;
use MT::DataAPI::Endpoint::v2::Entry;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list_openapi_spec {
    +{
        tags        => ['Pages'],
        summary     => 'Retrieve a list of pages in the specified site',
        description => <<'DESCRIPTION',
- Authorization is required to include unpublished pages.

#### Permissions

- manage_pages
  - to retrieve unpublished page
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/page_search' },
            { '$ref' => '#/components/parameters/page_searchFields' },
            { '$ref' => '#/components/parameters/page_limit' },
            { '$ref' => '#/components/parameters/page_offset' },
            { '$ref' => '#/components/parameters/page_sortBy' },
            { '$ref' => '#/components/parameters/page_sortOrder' },
            { '$ref' => '#/components/parameters/page_fields' },
            { '$ref' => '#/components/parameters/page_includeIds' },
            { '$ref' => '#/components/parameters/page_excludeIds' },
            { '$ref' => '#/components/parameters/page_status' },
            { '$ref' => '#/components/parameters/page_maxComments' },
            { '$ref' => '#/components/parameters/page_maxTrackbacks' },
            { '$ref' => '#/components/parameters/page_no_text_filter' },
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
                                    description => ' The total number of pages.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of page resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/page',
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

    my $res = filtered_list( $app, $endpoint, 'page' ) or return;

    return +{
        totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_for_folder_openapi_spec {
    +{
        tags        => ['Pages', 'Folders'],
        summary     => 'Retrieve a list of pages by specific folder',
        description => <<'DESCRIPTION',
- Authorization is required to include unpublished pages.

#### Permissions

- manage_pages
  - to retrieve unpublished page
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/page_search' },
            { '$ref' => '#/components/parameters/page_searchFields' },
            { '$ref' => '#/components/parameters/page_limit' },
            { '$ref' => '#/components/parameters/page_offset' },
            { '$ref' => '#/components/parameters/page_sortBy' },
            { '$ref' => '#/components/parameters/page_sortOrder' },
            { '$ref' => '#/components/parameters/page_fields' },
            { '$ref' => '#/components/parameters/page_includeIds' },
            { '$ref' => '#/components/parameters/page_excludeIds' },
            { '$ref' => '#/components/parameters/page_status' },
            { '$ref' => '#/components/parameters/page_maxComments' },
            { '$ref' => '#/components/parameters/page_maxTrackbacks' },
            { '$ref' => '#/components/parameters/page_no_text_filter' },
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
                                    description => ' The total number of pages.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of page resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/page',
                                    }
                                },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Folder not found.',
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

sub list_for_folder {
    my ( $app, $endpoint ) = @_;
    MT::DataAPI::Endpoint::v2::Entry::list_for_category_common( $app,
        $endpoint, 'page' );
}

sub list_for_asset_openapi_spec {
    +{
        tags        => ['Pages', 'Assets'],
        summary     => 'Retrieve a list of pages that related with specific asset',
        description => <<'DESCRIPTION',
- Authorization is required to include unpublished pages.

#### Permissions

- manage_pages
  - to retrieve unpublished page
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/page_search' },
            { '$ref' => '#/components/parameters/page_searchFields' },
            { '$ref' => '#/components/parameters/page_limit' },
            { '$ref' => '#/components/parameters/page_offset' },
            { '$ref' => '#/components/parameters/page_sortBy' },
            { '$ref' => '#/components/parameters/page_sortOrder' },
            { '$ref' => '#/components/parameters/page_fields' },
            { '$ref' => '#/components/parameters/page_includeIds' },
            { '$ref' => '#/components/parameters/page_excludeIds' },
            { '$ref' => '#/components/parameters/page_status' },
            { '$ref' => '#/components/parameters/page_maxComments' },
            { '$ref' => '#/components/parameters/page_maxTrackbacks' },
            { '$ref' => '#/components/parameters/page_no_text_filter' },
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
                                    description => ' The total number of pages.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of page resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/page',
                                    }
                                },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Asset not found.',
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

sub list_for_asset {
    my ( $app, $endpoint ) = @_;
    MT::DataAPI::Endpoint::v2::Entry::list_for_asset_common( $app, $endpoint,
        'page' );
}

sub list_for_tag {
    my ( $app, $endpoint ) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    MT::DataAPI::Endpoint::v2::Entry::list_for_tag_common( $app, $endpoint,
        'page' );
}

sub list_for_site_and_tag_openapi_spec {
    +{
        tags        => ['Pages', 'Tags'],
        summary     => 'Retrieve a list of pages that related with specific tag.',
        description => <<'DESCRIPTION',
- Authorization is required to include unpublished pages.

#### Permissions

- manage_pages
  - to retrieve unpublished page
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/page_search' },
            { '$ref' => '#/components/parameters/page_searchFields' },
            { '$ref' => '#/components/parameters/page_limit' },
            { '$ref' => '#/components/parameters/page_offset' },
            { '$ref' => '#/components/parameters/page_sortBy' },
            { '$ref' => '#/components/parameters/page_sortOrder' },
            { '$ref' => '#/components/parameters/page_fields' },
            { '$ref' => '#/components/parameters/page_includeIds' },
            { '$ref' => '#/components/parameters/page_excludeIds' },
            { '$ref' => '#/components/parameters/page_status' },
            { '$ref' => '#/components/parameters/page_maxComments' },
            { '$ref' => '#/components/parameters/page_maxTrackbacks' },
            { '$ref' => '#/components/parameters/page_no_text_filter' },
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
                                    description => ' The total number of pages.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of page resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/page',
                                    }
                                },
                            },
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

sub list_for_site_and_tag {
    my ( $app, $endpoint ) = @_;
    MT::DataAPI::Endpoint::v2::Entry::list_for_site_and_tag_common( $app,
        $endpoint, 'page' );
}

sub get_openapi_spec {
    +{
        tags        => ['Pages'],
        summary     => 'Retrieve a single page by its ID',
        description => <<'DESCRIPTION',
- Authorization is required if the page status is "unpublished". If the page status is "published", then this method can be called without authorization.
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/page_fields' },
        ],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/page',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Page not found.',
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

    my ( $site, $page ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'page', $page->id, obj_promise($page) )
        or return;

    return $page;
}

sub create_openapi_spec {
    +{
        tags        => ['Pages'],
        summary     => 'Create a new page',
        description => <<'DESCRIPTION',
- Authorization is required.

#### Update in v2.0

- You can attach folder and assets in one request.

#### Permissions

- manage_post
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            page => {
                                '$ref' => '#/components/schemas/page_updatable',
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
                            '$ref' => '#/components/schemas/page',
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
    return $app->error( $app->translate('Site not found'), 404 )
        if !$site->id;

    my $author = $app->user or return;

    my $orig_page = $app->model('page')->new;
    $orig_page->set_values(
        {   blog_id        => $site->id,
            author_id      => $author->id,
            allow_comments => $site->allow_comments_default,
            allow_pings    => $site->allow_pings_default,
            convert_breaks => $site->convert_paras,
            status         => $site->status_default,
        }
    );

    my $new_page = $app->resource_object( 'page', $orig_page )
        or return;

    if (  !$new_page->basename
        || $app->model('page')
        ->exist( { blog_id => $site->id, basename => $new_page->basename } ) )
    {
        $new_page->basename( MT::Util::make_unique_basename($new_page) );
    }
    MT::Util::translate_naughty_words($new_page);

    my $post_save
        = MT::DataAPI::Endpoint::v1::Entry::build_post_save_sub( $app, $site,
        $new_page, $orig_page );

    # Check whether or not folder and assets can attach.
    my $page_json = $app->param('page');
    my $page_hash = $app->current_format->{unserialize}->($page_json);

    my $attach_folder;
    if (   exists( $page_hash->{folder} )
        && ref( $page_hash->{folder} ) eq 'HASH'
        && exists( $page_hash->{folder}{id} ) )
    {
        my $folder_hash = $page_hash->{folder};

        $attach_folder = MT->model('folder')->load(
            {   id      => $page_hash->{folder}{id},
                blog_id => $site->id,
                class   => 'folder',
            }
        );

        return $app->error( $app->translate("'folder' parameter is invalid."),
            400 )
            if !$attach_folder;
    }

    my @attach_assets;
    if ( exists $page_hash->{assets} ) {
        my $assets_hash = $page_hash->{assets};
        $assets_hash = [$assets_hash] if ref $assets_hash ne 'ARRAY';

        if ( scalar @$assets_hash > 0 ) {
            my @asset_ids = map { $_->{id} }
                grep { ref $_ eq 'HASH' && $_->{id} } @$assets_hash;
            my @blog_ids = ( $site->id );
            if ( !$site->is_blog ) {
                my @child_blogs = @{ $site->blogs };
                my @child_blog_ids = map { $_->id } @child_blogs;
                push @blog_ids, @child_blog_ids;
            }
            @attach_assets = MT->model('asset')->load(
                {   id      => \@asset_ids,
                    blog_id => \@blog_ids,
                }
            );

            return $app->error( "'assets' parameter is invalid.", 400 )
                if scalar @$assets_hash == 0
                || scalar @$assets_hash != scalar @attach_assets;
        }
    }

    save_object( $app, 'page', $new_page )
        or return;

    # Attach folder and assets.
    if ($attach_folder) {
        $new_page->attach_categories($attach_folder)
            or return $app->error( $new_page->errstr );
    }
    if (@attach_assets) {
        $new_page->attach_assets(@attach_assets)
            or return $app->error( $new_page->errstr );
    }

    $post_save->();

    # Remove autosave object
    remove_autosave_session_obj( $app, $new_page->class );

    return $new_page;
}

sub update_openapi_spec {
    +{
        tags        => ['Pages'],
        summary     => 'Update an existing page',
        description => <<'DESCRIPTION',
- Authorization is required.

#### Update in v2.0

- You can attach/detach folder and assets in one request.

#### Permissions

- manage_pages
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            page => {
                                '$ref' => '#/components/schemas/page_updatable',
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
                            '$ref' => '#/components/schemas/page',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Page not found.',
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

    my ( $site, $orig_page ) = context_objects(@_)
        or return;
    my $new_page = $app->resource_object( 'page', $orig_page )
        or return;

    my $post_save
        = MT::DataAPI::Endpoint::v1::Entry::build_post_save_sub( $app, $site,
        $new_page, $orig_page );

    # Check whether or not folder and assets can attach/detach.
    my $page_json = $app->param('page');
    my $page_hash = $app->current_format->{unserialize}->($page_json);

    my $update_folder;
    if ( exists( $page_hash->{folder} ) ) {
        my $folder_hash = $page_hash->{folder};

        if ( exists $folder_hash->{id} ) {
            $update_folder = MT->model('folder')->load(
                {   id      => $page_hash->{folder}{id},
                    blog_id => $site->id,
                    class   => 'folder',
                }
            );

            return $app->error( "'folder' parameter is invalid.", 400 )
                if !$update_folder;
        }
    }

    my @update_assets;
    my $do_update_assets;
    if ( exists $page_hash->{assets} ) {
        my $assets_hash = $page_hash->{assets};
        $assets_hash = [$assets_hash] if ref $assets_hash ne 'ARRAY';

        if ( scalar @$assets_hash == 0 ) {
            $do_update_assets = 1;
        }
        else {
            my @asset_ids = map { $_->{id} }
                grep { ref $_ eq 'HASH' && $_->{id} } @$assets_hash;
            my @blog_ids = ( $site->id );
            if ( !$site->is_blog ) {
                my @child_blogs = @{ $site->blogs };
                my @child_blog_ids = map { $_->id } @child_blogs;
                push @blog_ids, @child_blog_ids;
            }
            @update_assets = MT->model('asset')->load(
                {   id      => \@asset_ids,
                    blog_id => \@blog_ids,
                }
            );

            return $app->error( "'assets' parameter is invalid.", 400 )
                if scalar @$assets_hash == 0
                || scalar @$assets_hash != scalar @update_assets;

            $do_update_assets = 1;
        }
    }

    save_object(
        $app, 'page',
        $new_page,
        $orig_page,
        sub {
          # Setting modified_by updates modified_on which we want to do before
          # a save but after pre_save callbacks fire.
            $new_page->modified_by( $app->user->id ) if $app->user;

            $_[0]->();
        }
    ) or return;

    # Update categories and assets.
    $new_page->update_categories( $update_folder ? $update_folder : () )
        or return $app->error( $new_page->errstr );
    if ($do_update_assets) {
        $new_page->update_assets(@update_assets)
            or return $app->error( $new_page->errstr );
    }

    $post_save->();

    # Remove autosave object
    remove_autosave_session_obj( $app, $new_page->class, $new_page->id );

    return $new_page;
}

sub delete_openapi_spec {
    +{
        tags        => ['Pages'],
        summary     => 'Delete an existing page',
        description => <<'DESCRIPTION',
- Authorization is required.

#### Permissions

- edit_entry
DESCRIPTION
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/page',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Page not found.',
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

    my ( $site, $page ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'page', $page )
        or return;

    if ( $app->config('DeleteFilesAtRebuild') ) {
        $app->publisher->remove_entry_archive_file(
            Entry       => $page,
            ArchiveType => 'Page'
        );
    }

    $page->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $page->class_label,
            $page->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.page', $app, $page );

    $app->run_callbacks( 'rebuild', $site );

    return $page;
}

sub preview_by_id_openapi_spec {
    +{
        tags        => ['Pages'],
        summary     => 'Make a preview for a page with existing data',
        description => <<'DESCRIPTION',
- Authorization is required.
- **This endpoint has been available since Movable Type 6.1.2.**
- **page** parameter is required. If you just want to get preview page from existing data, you should provide page parameter with empty json.

#### Permissions

- manage_post
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
                            page => {
                                '$ref' => '#/components/schemas/page',
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
                description => 'Site or Page not found',
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

sub preview_openapi_spec {
    my $spec = __PACKAGE__->preview_by_id_openapi_spec();
    $spec->{summary} = 'Make a preview for a page';
    $spec->{description} = <<'DESCRIPTION';
- Authorization is required.
- **This endpoint has been available since Movable Type 6.1.2.**

#### Permissions

- manage_pages
DESCRIPTION
    return $spec;
}

sub preview {
    my ( $app, $endpoint ) = @_;

    my ($blog) = context_objects(@_)
        or return;
    my $author = $app->user;

    # Create dummy new object
    my $orig_page = $app->model('page')->new;
    $orig_page->set_values(
        {   blog_id        => $blog->id,
            author_id      => $author->id,
            allow_comments => $blog->allow_comments_default,
            allow_pings    => $blog->allow_pings_default,
            convert_breaks => $blog->convert_paras,
            status         => MT::Entry::RELEASE(),
        }
    );
    my $page = $app->resource_object( 'page', $orig_page )
        or return;
    $page->id(-1);    # fake out things like MT::Taggable::__load_tags

    # Update for preview
    my $page_json = $app->param('page');
    my $page_hash = $app->current_format->{unserialize}->($page_json);

    my $names = $page->column_names;
    foreach my $name (@$names) {
        if ( exists $page_hash->{$name} ) {
            $page->$name( $page_hash->{$name} );
        }
    }

    if ( exists $page_hash->{folder} ) {
        my $folder_hash = $page_hash->{folder};
        $app->param( 'category_ids', $folder_hash->{id} );
    }

    require MT::DataAPI::Endpoint::v2::Entry;
    return MT::DataAPI::Endpoint::v2::Entry::_preview_common( $app, $page );
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Page - Movable Type class for endpoint definitions about the MT::Page.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
