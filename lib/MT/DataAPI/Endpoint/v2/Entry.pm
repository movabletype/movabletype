# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Entry;

use strict;
use warnings;

use MT::I18N qw( const );
use MT::App;
use MT::App::CMS;
use MT::Entry;
use MT::Import;
use MT::Util;
use MT::CMS::Import;
use MT::CMS::Export;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Endpoint::v1::Entry;
use MT::DataAPI::Resource;

sub create_openapi_spec {
    my $spec = MT::DataAPI::Endpoint::v1::Entry::create_openapi_spec();
    $spec->{description} = <<'DESCRIPTION';
- Authorization is required.

#### Update in v2.0

- You can attach categories and assets in one request.

#### Permissions

- create_post
DESCRIPTION
    $spec->{responses}{404}{description} = 'Site not found.';
    return $spec;
}

sub create {
    my ( $app, $endpoint ) = @_;

    my ($blog) = context_objects(@_);
    return unless $blog && $blog->id;

    my $author = $app->user;

    my $orig_entry = $app->model('entry')->new;
    $orig_entry->set_values(
        {   blog_id        => $blog->id,
            author_id      => $author->id,
            allow_comments => $blog->allow_comments_default,
            allow_pings    => $blog->allow_pings_default,
            convert_breaks => $blog->convert_paras,
            status         => (
                (          $app->can_do('publish_own_entry')
                        || $app->can_do('publish_all_entry')
                )
                ? MT::Entry::RELEASE()
                : MT::Entry::HOLD()
            )
        }
    );

    my $new_entry = $app->resource_object( 'entry', $orig_entry )
        or return;

    if (  !$new_entry->basename
        || $app->model('entry')
        ->exist( { blog_id => $blog->id, basename => $new_entry->basename } )
        )
    {
        $new_entry->basename( MT::Util::make_unique_basename($new_entry) );
    }
    MT::Util::translate_naughty_words($new_entry);

    my $post_save
        = MT::DataAPI::Endpoint::v1::Entry::build_post_save_sub( $app, $blog,
        $new_entry, $orig_entry );

    # Check whether or not assets can attach.
    my $entry_json = $app->param('entry');
    my $entry_hash = $app->current_format->{unserialize}->($entry_json);

    my @attach_cats;
    if ( exists $entry_hash->{categories} ) {
        my $cats_hash = $entry_hash->{categories};
        $cats_hash = [$cats_hash] if ref $cats_hash ne 'ARRAY';

        if ( scalar @$cats_hash > 0 ) {
            my @cat_ids = map { $_->{id} }
                grep { ref $_ eq 'HASH' && $_->{id} } @$cats_hash;
            @attach_cats = MT->model('category')->load(
                {   id      => \@cat_ids,
                    blog_id => $blog->id,
                    class   => 'category',
                }
            );

            return $app->error( "'categories' parameter is invalid.", 400 )
                if scalar @$cats_hash == 0
                || scalar @$cats_hash != scalar @attach_cats;

            # Restore order.
            my %attach_cats_hash = map { +( $_->id => $_ ) } @attach_cats;
            @attach_cats = map { $attach_cats_hash{$_} } @cat_ids;
        }
    }

    my @attach_assets;
    if ( exists $entry_hash->{assets} ) {
        my $assets_hash = $entry_hash->{assets};
        $assets_hash = [$assets_hash] if ref $assets_hash ne 'ARRAY';

        if ( scalar @$assets_hash > 0 ) {
            my @asset_ids = map { $_->{id} }
                grep { ref $_ eq 'HASH' && $_->{id} } @$assets_hash;
            my @blog_ids = ( $blog->id );
            if ( !$blog->is_blog ) {
                my @child_blogs = @{ $blog->blogs };
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

    save_object( $app, 'entry', $new_entry )
        or return;

    # Attach categories and assets.
    if (@attach_cats) {
        $new_entry->attach_categories(@attach_cats)
            or return $app->error( $new_entry->errstr );
    }
    if (@attach_assets) {
        $new_entry->attach_assets(@attach_assets)
            or return $app->error( $new_entry->errstr );
    }

    $post_save->();

    # Remove autosave object
    remove_autosave_session_obj( $app, $new_entry->class );

    $new_entry;
}

sub update_openapi_spec {
    my $spec = MT::DataAPI::Endpoint::v1::Entry::update_openapi_spec();
    $spec->{sumamry} = 'Update an existing entry';
    $spec->{description} = <<'DESCRIPTION';
- Authorization is required.

#### Update in v2.0

- You can attach/detach categories and assets in one request.

#### Permissions

- edit_entry
  - to retrieve unpublished entry
DESCRIPTION
    $spec->{responses}{404}{description} = 'Site or Entry not found.';
    return $spec;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $orig_entry ) = context_objects(@_)
        or return;
    my $new_entry = $app->resource_object( 'entry', $orig_entry )
        or return;

    my $post_save
        = MT::DataAPI::Endpoint::v1::Entry::build_post_save_sub( $app, $blog,
        $new_entry, $orig_entry );

    # Check whether or not assets can attach/detach.
    my $entry_json = $app->param('entry');
    my $entry_hash = $app->current_format->{unserialize}->($entry_json);

    my @update_cats;
    my $do_update_cats;
    if ( exists $entry_hash->{categories} ) {
        my $cats_hash = $entry_hash->{categories};
        $cats_hash = [$cats_hash] if ref $cats_hash ne 'ARRAY';

        if ( scalar @$cats_hash == 0 ) {
            $do_update_cats = 1;
        }
        else {
            my @cat_ids = map { $_->{id} }
                grep { ref $_ eq 'HASH' && $_->{id} } @$cats_hash;
            @update_cats = MT->model('category')->load(
                {   id      => \@cat_ids,
                    blog_id => $blog->id,
                    class   => 'category',
                }
            );

            return $app->error( "'categories' parameter is invalid.", 400 )
                if scalar @$cats_hash == 0
                || scalar @$cats_hash != scalar @update_cats;

            # Restore order.
            my %update_cats_hash = map { +( $_->id => $_ ) } @update_cats;
            @update_cats = map { $update_cats_hash{$_} } @cat_ids;
            $do_update_cats = 1;
        }
    }

    my @update_assets;
    my $do_update_assets;
    if ( exists $entry_hash->{assets} ) {
        my $assets_hash = $entry_hash->{assets};
        $assets_hash = [$assets_hash] if ref $assets_hash ne 'ARRAY';

        if ( scalar @$assets_hash == 0 ) {
            $do_update_assets = 1;
        }
        else {
            my @asset_ids = map { $_->{id} }
                grep { ref $_ eq 'HASH' && $_->{id} } @$assets_hash;
            my @blog_ids = ( $blog->id );
            if ( !$blog->is_blog ) {
                my @child_blogs = @{ $blog->blogs };
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
        $app, 'entry',
        $new_entry,
        $orig_entry,
        sub {
          # Setting modified_by updates modified_on which we want to do before
          # a save but after pre_save callbacks fire.
            $new_entry->modified_by( $app->user->id );

            $_[0]->();
        }
    ) or return;

    # Update categories and assets.
    if ($do_update_cats) {
        $new_entry->update_categories(@update_cats)
            or return $app->error( $new_entry->errstr );
    }
    if ($do_update_assets) {
        $new_entry->update_assets(@update_assets)
            or return $app->error( $new_entry->errstr );
    }

    $post_save->();

    # Remove autosave object
    remove_autosave_session_obj( $app, $new_entry->class, $new_entry->id );

    $new_entry;
}

sub list_for_category_openapi_spec {
    +{
        tags        => ['Entries', 'Categories'],
        summary     => 'Retrieve a list of entries by specific category',
        description => <<'DESCRIPTION',
- Authorization is required to include unpublished entries.

#### Permissions

- edit_entry
  - to retrieve unpublished entry
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/entry_search' },
            { '$ref' => '#/components/parameters/entry_searchFields' },
            { '$ref' => '#/components/parameters/entry_limit' },
            { '$ref' => '#/components/parameters/entry_offset' },
            { '$ref' => '#/components/parameters/entry_sortBy' },
            { '$ref' => '#/components/parameters/entry_sortOrder' },
            { '$ref' => '#/components/parameters/entry_fields' },
            { '$ref' => '#/components/parameters/entry_includeIds' },
            { '$ref' => '#/components/parameters/entry_excludeIds' },
            { '$ref' => '#/components/parameters/entry_status' },
            { '$ref' => '#/components/parameters/entry_maxComments' },
            { '$ref' => '#/components/parameters/entry_maxTrackbacks' },
            { '$ref' => '#/components/parameters/entry_no_text_filter' },
        ],
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                totalResults => {
                                    type        => 'integer',
                                    description => ' The total number of entries.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of Entries resource. ',
                                    items       => {
                                        '$ref' => '#/components/schemas/entry',
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

sub list_for_category {
    my ( $app, $endpoint ) = @_;
    list_for_category_common( $app, $endpoint, 'entry' );
}

sub list_for_category_common {
    my ( $app, $endpoint, $class ) = @_;

    my ( $blog, $cat ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        $cat->class, $cat->id, obj_promise($cat) )
        or return;

    my %args = (
        join => MT->model('placement')->join_on(
            'entry_id',
            {   blog_id     => $cat->blog_id,
                category_id => $cat->id,
            },
        ),
    );
    my $res = filtered_list( $app, $endpoint, $class, undef, \%args );

    +{  totalResults => ( $res ? $res->{count} : 0 ) + 0,
        items => MT::DataAPI::Resource::Type::ObjectList->new(
            $res ? $res->{objects} : {}
        ),
    };
}

sub list_for_asset_openapi_spec {
    +{
        tags        => ['Entries', 'Assets'],
        summary     => 'Retrieve a list of entries that related with specific asset',
        description => <<'DESCRIPTION',
- Authorization is required to include unpublished entries.

#### Permissions

- edit_entry
  - to retrieve unpublished entry
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/entry_search' },
            { '$ref' => '#/components/parameters/entry_searchFields' },
            { '$ref' => '#/components/parameters/entry_limit' },
            { '$ref' => '#/components/parameters/entry_offset' },
            { '$ref' => '#/components/parameters/entry_sortBy' },
            { '$ref' => '#/components/parameters/entry_sortOrder' },
            { '$ref' => '#/components/parameters/entry_fields' },
            { '$ref' => '#/components/parameters/entry_includeIds' },
            { '$ref' => '#/components/parameters/entry_excludeIds' },
            { '$ref' => '#/components/parameters/entry_status' },
            { '$ref' => '#/components/parameters/entry_maxComments' },
            { '$ref' => '#/components/parameters/entry_maxTrackbacks' },
            { '$ref' => '#/components/parameters/entry_no_text_filter' },
        ],
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                totalResults => {
                                    type        => 'integer',
                                    description => ' The total number of entries.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of Entries resource. ',
                                    items       => {
                                        '$ref' => '#/components/schemas/entry',
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
    list_for_asset_common( $app, $endpoint, 'entry' );
}

sub list_for_asset_common {
    my ( $app, $endpoint, $class ) = @_;

    my ( $blog, $asset ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'asset', $asset->id, obj_promise($asset) )
        or return;

    my %args = (
        join => MT->model('objectasset')->join_on(
            undef,
            {   blog_id   => $asset->blog_id,
                object_ds => 'entry',
                object_id => \'= entry_id',
                asset_id  => $asset->id,
            },
        ),
    );
    my $res = filtered_list( $app, $endpoint, $class, undef, \%args );

    +{  totalResults => ( $res ? $res->{count} : 0 ) + 0,
        items => MT::DataAPI::Resource::Type::ObjectList->new(
            $res ? $res->{objects} : {}
        ),
    };
}

sub list_for_tag {
    my ( $app, $endpoint ) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    list_for_tag_common( $app, $endpoint, 'entry' );
}

sub list_for_tag_common {
    my ( $app, $endpoint, $class ) = @_;

    require MT::DataAPI::Endpoint::v2::Tag;
    my $tag = MT::DataAPI::Endpoint::v2::Tag::_retrieve_tag($app) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'tag', $tag->id, obj_promise($tag) )
        or return;

    my %args = (
        join => MT->model('objecttag')->join_on(
            undef,
            {   object_datasource => 'entry',
                object_id         => \'= entry_id',
                tag_id            => $tag->id,
            },
        ),
    );
    my $res = filtered_list( $app, $endpoint, $class, undef, \%args );

    +{  totalResults => ( $res ? $res->{count} : 0 ) + 0,
        items => MT::DataAPI::Resource::Type::ObjectList->new(
            $res ? $res->{objects} : {}
        ),
    };
}

sub list_for_site_and_tag_openapi_spec {
    +{
        tags        => ['Entries', 'Tags'],
        summary     => 'Retrieve a list of entries that related with specific tag',
        description => <<'DESCRIPTION',
- Authorization is required to include unpublished entries.

#### Permissions

- edit_entry
  - to retrieve unpublished entry
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/entry_search' },
            { '$ref' => '#/components/parameters/entry_searchFields' },
            { '$ref' => '#/components/parameters/entry_limit' },
            { '$ref' => '#/components/parameters/entry_offset' },
            { '$ref' => '#/components/parameters/entry_sortBy' },
            { '$ref' => '#/components/parameters/entry_sortOrder' },
            { '$ref' => '#/components/parameters/entry_fields' },
            { '$ref' => '#/components/parameters/entry_includeIds' },
            { '$ref' => '#/components/parameters/entry_excludeIds' },
            { '$ref' => '#/components/parameters/entry_status' },
            { '$ref' => '#/components/parameters/entry_maxComments' },
            { '$ref' => '#/components/parameters/entry_maxTrackbacks' },
            { '$ref' => '#/components/parameters/entry_no_text_filter' },
        ],
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                totalResults => {
                                    type        => 'integer',
                                    description => ' The total number of entries.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of Entries resource. ',
                                    items       => {
                                        '$ref' => '#/components/schemas/entry',
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
    list_for_site_and_tag_common( $app, $endpoint, 'entry' );
}

sub list_for_site_and_tag_common {
    my ( $app, $endpoint, $class ) = @_;

    require MT::DataAPI::Endpoint::v2::Tag;
    my ( $tag, $site_id )
        = MT::DataAPI::Endpoint::v2::Tag::_retrieve_tag_related_to_site($app)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'tag', $tag->id, obj_promise($tag) )
        or return;

    my %args = (
        join => MT->model('objecttag')->join_on(
            undef,
            {   object_datasource => 'entry',
                object_id         => \'= entry_id',
                tag_id            => $tag->id,
                blog_id           => $site_id,
            },
        ),
    );
    my $res = filtered_list( $app, $endpoint, $class, undef, \%args );

    +{  totalResults => ( $res ? $res->{count} : 0 ) + 0,
        items => MT::DataAPI::Resource::Type::ObjectList->new(
            $res ? $res->{objects} : {}
        ),
    };
}

sub _check_import_parameters {
    my ( $app, $endpoint ) = @_;

    # blog_id
    my ($site) = context_objects(@_) or return;
    if ( !$site->id ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    # import_as_me
    if ( !defined $app->param('import_as_me') ) {
        $app->param( 'import_as_me', 1 );
    }

    # password
    if ( !$app->param('import_as_me') ) {
        my $password = $app->param('password');
        if ( !defined $password || $password eq '' ) {
            return $app->error(
                $app->translate(
                    'You need to provide a parameter "password" if you are going to create new users for each user listed in your blog.'
                ),
                400,
            );
        }
        elsif ( my $error
            = $app->verify_password_strength( undef, $password ) )
        {
            return $app->error( $error, 400 );
        }
    }

    # import_type
    if ( !defined $app->param('import_type') ) {
        $app->param( 'import_type', 'import_mt' );
    }
    else {
        my $import_type = $app->param('import_type');
        my $imp         = MT::Import->new;
        my %keys        = map { $_ => 1 } $imp->importer_keys;
        if ( !$keys{$import_type} ) {
            return $app->error(
                $app->translate( 'Invalid import_type: [_1]', $import_type ),
                400
            );
        }
    }

    # default_status (when import_type is "import_mt_format").
    if ( ( $app->param('import_type') || '' ) eq 'import_mt_format'
        && !defined $app->param('default_status') )
    {
        $app->param( 'default_status', $app->blog->status_default );
    }

    # encoding
    if ( !defined $app->param('encoding') ) {
        $app->param( 'encoding', 'guess' );
    }
    else {
        my $encoding = $app->param('encoding');
        my %valid_encodings
            = map { $_->{name} => 1 } @{ const('ENCODING_NAMES') };
        if ( !$valid_encodings{$encoding} ) {
            return $app->error(
                $app->translate( 'Invalid encoding: [_1]', $encoding ), 400 );
        }
    }

    # convert_breaks
    my $text_filters
        = MT::App::CMS::load_text_filters( $app, $site->convert_paras,
        'entry' );
    if ( !defined $app->param('convert_breaks') ) {
        my $selected_key
            = map { $_->{key} } grep { $_->{selected} } @$text_filters;
        $app->param( 'convert_breaks', $selected_key );
    }
    else {
        my $convert_breaks = $app->param('convert_breaks');
        my %filter_keys = map { $_->{key} => 1 } @$text_filters;
        $filter_keys{1} = 1;
        if ( !$filter_keys{$convert_breaks} ) {
            return $app->error(
                $app->translate(
                    'Invalid convert_breaks: [_1]',
                    $convert_breaks
                ),
                400
            );
        }
    }

    # default_cat_id
    if ( my $default_cat_id = $app->param('default_cat_id') ) {
        if ( !$app->model('category')
            ->exist( { id => $default_cat_id, blog_id => $site->id } ) )
        {
            return $app->error(
                $app->translate(
                    'Invalid default_cat_id: [_1]',
                    $default_cat_id
                ),
                400
            );
        }
    }

    return 1;
}

sub import_openapi_spec {
    +{
        tags        => ['Entries'],
        summary     => 'Import entries',
        requestBody => {
            content => {
                'multipart/form-data' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            import_as_me => {
                                type        => 'integer',
                                enum        => [0, 1],
                                default     => 1,
                                description => <<'DESCRIPTION',
#### 0

Preserve original user

#### 1

Import as me

**Default**: 1
DESCRIPTION
                            },
                            password => {
                                type        => 'string',
                                description => 'If you choose import_as_me is 0, you must define a default password for those new accounts.',
                            },
                            import_type => {
                                type => 'string',
                            },
                            default_status => {
                                type        => 'string',
                                description => 'If you set import_type is "import_mt_format", also you can set default entry status.',
                            },
                            encoding => {
                                type => 'string',
                            },
                            convert_breaks => {
                                type => 'string',
                            },
                            default_cat_id => {
                                type => 'integer',
                            },
                            file => {
                                type   => 'string',
                                format => 'binary',
                            },
                        },
                    },
                },
            },
        },
        responses => {
            200 => {
                description => 'No Errors',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                status => {
                                    type => 'string',
                                },
                                message => {
                                    type => 'string',
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

sub import {
    my ( $app, $endpoint ) = @_;

    _check_import_parameters(@_) or return;

    local $app->{no_print_body};

    no warnings 'redefine';
    my $param;
    local *MT::build_page = sub { $param = $_[2] };
    local *MT::App::print = sub { };
    local *MT::App::send_http_header = sub { };

    MT::CMS::Import::do_import($app) or return;

    if ( !$param->{import_success} ) {
        chomp $param->{error};
        return $app->error(
            $app->translate(
                'An error occurred during the import process: [_1]. Please check your import file.',
                $param->{error}
            ),
            500
        );
    }

    return +{
        status => 'success',
        !$param->{import_upload}
        ? ( message => $app->translate(
                "Make sure that you remove the files that you imported from the 'import' folder, so that if/when you run the import process again, those files will not be re-imported."
            )
            )
        : (),
    };
}

sub export_openapi_spec {
    +{
        tags      => ['Entries'],
        summary   => 'Export entries',
        responses => {
            200 => {
                description => 'Text as Movable Type Import / Export Format',
                content     => {
                    'text/plain' => {
                        schema => { type => 'string' },
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

sub export {
    my ( $app, $endpoint ) = @_;

    if ( !$app->param('site_id') ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    MT::CMS::Export::export($app);

    return;
}

sub preview_by_id_openapi_spec {
    +{
        tags        => ['Entries'],
        summary     => 'Make a preview for a entry with existing data',
        description => <<'DESCRIPTION',
- Authorization is required.
- **This endpoint has been available since Movable Type 6.1.2.**
- **entry** parameter is required. If you just want to get preview entry from existing data, you should provide entry parameter with empty json.

#### Permissions

- create_post
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
                            entry => {
                                '$ref' => '#/components/schemas/entry',
                            },
                        },
                    },
                },
            },
        },
        responses => {
            200 => {
                description => 'OK',
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
                description => 'Site or Entry not found',
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

    my ( $blog, $entry ) = context_objects(@_)
        or return;

    # Update for preview
    my $entry_json = $app->param( $entry->class )
        or return $app->error(
        $app->translate(
            'A resource "[_1]" is required.',
            $entry->class_label
        ),
        400
        );
    my $entry_hash = $app->current_format->{unserialize}->($entry_json);

    $entry = $app->resource_object( $entry->class, $entry )
        or return;

    my $names = $entry->column_names;
    foreach my $name (@$names) {
        if ( exists $entry_hash->{$name} ) {
            $entry->$name( $entry_hash->{$name} );
        }
    }

    # Permission check
    return $app->error(403)
        unless $app->permissions->can_edit_entry( $entry, $app->user );

    # Set authored_on as a parameter
    my ( $yr, $mo, $dy, $hr, $mn, $sc )
        = unpack( 'A4A2A2A2A2A2', $entry->authored_on );
    my $authored_on_date = sprintf( "%04d-%02d-%02d", $yr, $mo, $dy );
    my $authored_on_time = sprintf( "%02d:%02d:%02d", $hr, $mn, $sc );
    $app->param( 'authored_on_date', $authored_on_date );
    $app->param( 'authored_on_time', $authored_on_time );

    if ( exists $entry_hash->{categories} ) {
        my $cats_hash = $entry_hash->{categories};
        $cats_hash = [$cats_hash] if ref $cats_hash ne 'ARRAY';

        my @cat_ids = map { $_->{id} }
            grep { ref $_ eq 'HASH' && $_->{id} } @$cats_hash;
        my $cat_ids = join ',', @cat_ids;
        $app->param( 'category_ids', $cat_ids );
    }

    return _preview_common( $app, $entry );
}

sub preview_openapi_spec {
    my $spec = __PACKAGE__->preview_by_id_openapi_spec();
    $spec->{summary} = 'Make a preview for a entry';
    $spec->{description} = <<'DESCRIPTION',
- Authorization is required.
- **This endpoint has been available since Movable Type 6.1.2.**

#### Permissions

- create_post
DESCRIPTION
    return $spec;
}

sub preview {
    my ( $app, $endpoint ) = @_;

    my ($blog) = context_objects(@_)
        or return;
    my $author = $app->user;

    # Create dummy new object
    my $orig_entry = $app->model('entry')->new;
    $orig_entry->set_values(
        {   blog_id        => $blog->id,
            author_id      => $author->id,
            allow_comments => $blog->allow_comments_default,
            allow_pings    => $blog->allow_pings_default,
            convert_breaks => $blog->convert_paras,
            status         => (
                (          $app->can_do('publish_own_entry')
                        || $app->can_do('publish_all_entry')
                )
                ? MT::Entry::RELEASE()
                : MT::Entry::HOLD()
            )
        }
    );
    my $entry = $app->resource_object( 'entry', $orig_entry )
        or return;
    $entry->id(-1);    # fake out things like MT::Taggable::__load_tags

    # Update for preview
    my $entry_json = $app->param('entry');
    my $entry_hash = $app->current_format->{unserialize}->($entry_json);

    my $names = $entry->column_names;
    foreach my $name (@$names) {
        if ( exists $entry_hash->{$name} ) {
            $entry->$name( $entry_hash->{$name} );
        }
    }

    # Set authored_on as a parameter
    if ( !$entry->authored_on ) {
        my @ts = MT::Util::offset_time_list( time, $blog );
        my $ts = sprintf '%04d%02d%02d%02d%02d%02d',
            $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];
        $entry->authored_on($ts);
    }

    my ( $yr, $mo, $dy, $hr, $mn, $sc )
        = unpack( 'A4A2A2A2A2A2', $entry->authored_on );
    my $authored_on_date = sprintf( "%04d-%02d-%02d", $yr, $mo, $dy );
    my $authored_on_time = sprintf( "%02d:%02d:%02d", $hr, $mn, $sc );
    $app->param( 'authored_on_date', $authored_on_date );
    $app->param( 'authored_on_time', $authored_on_time );

    if ( exists $entry_hash->{categories} ) {
        my $cats_hash = $entry_hash->{categories};
        $cats_hash = [$cats_hash] if ref $cats_hash ne 'ARRAY';

        my @cat_ids = map { $_->{id} }
            grep { ref $_ eq 'HASH' && $_->{id} } @$cats_hash;
        my $cat_ids = join ',', @cat_ids;
        $app->param( 'category_ids', $cat_ids );
    }

    return _preview_common( $app, $entry );
}

sub _preview_common {
    my ( $app, $entry ) = @_;

    # Set correct class type
    $app->param( '_type', $entry->class );

# TODO: Allow to make a preview content when Individual/Page mapping not found.
# Currently, we cannot make preview content when templatemap could not be found.
    require MT::TemplateMap;
    my $at = $entry->class eq 'page' ? 'Page' : 'Individual';
    my $tmpl_map = MT::TemplateMap->load(
        {   archive_type => $at,
            is_preferred => 1,
            blog_id      => $entry->blog_id,
        }
    );
    if ( !$tmpl_map ) {
        return $app->error(
            $app->translate(
                'Could not found archive template for [_1].',
                $entry->class_label
            ),
            400
        );
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

    # Make preview file
    require MT::CMS::Entry;
    my $preview = MT::CMS::Entry::_build_entry_preview( $app, $entry );

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
    my $sess = $session_class->load( { id => $preview_basename } );
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

MT::DataAPI::Endpoint::v2::Entry - Movable Type class for endpoint definitions about the MT::Entry.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
