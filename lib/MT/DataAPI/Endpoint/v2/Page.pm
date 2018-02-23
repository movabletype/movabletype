# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Page;

use strict;
use warnings;

use MT::Util;
use MT::DataAPI::Endpoint::Entry;
use MT::DataAPI::Endpoint::v2::Entry;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    my $res = filtered_list( $app, $endpoint, 'page' ) or return;

    return +{
        totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_for_folder {
    my ( $app, $endpoint ) = @_;
    MT::DataAPI::Endpoint::v2::Entry::list_for_category_common( $app,
        $endpoint, 'page' );
}

sub list_for_asset {
    my ( $app, $endpoint ) = @_;
    MT::DataAPI::Endpoint::v2::Entry::list_for_asset_common( $app, $endpoint,
        'page' );
}

sub list_for_tag {
    my ( $app, $endpoint ) = @_;
    MT::DataAPI::Endpoint::v2::Entry::list_for_tag_common( $app, $endpoint,
        'page' );
}

sub list_for_site_and_tag {
    my ( $app, $endpoint ) = @_;
    MT::DataAPI::Endpoint::v2::Entry::list_for_site_and_tag_common( $app,
        $endpoint, 'page' );
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ( $site, $page ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'page', $page->id, obj_promise($page) )
        or return;

    return $page;
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
        = MT::DataAPI::Endpoint::Entry::build_post_save_sub( $app, $site,
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

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $site, $orig_page ) = context_objects(@_)
        or return;
    my $new_page = $app->resource_object( 'page', $orig_page )
        or return;

    my $post_save
        = MT::DataAPI::Endpoint::Entry::build_post_save_sub( $app, $site,
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
