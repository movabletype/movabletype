# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v3::Page;

use strict;
use warnings;

use MT::Entry;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Endpoint::v1::Entry;
use MT::DataAPI::Endpoint::v2::Page;
use MT::DataAPI::Resource;

sub create_openapi_spec {
    my $spec = MT::DataAPI::Endpoint::v2::Page::create_openapi_spec();
    $spec->{requestBody}{content}{'application/x-www-form-urlencoded'}{schema}{properties}{publish} = {
        type        => 'integer',
        description => 'If this value is "0", the entry is not published',
        enum        => [0, 1],
    };
    return $spec;
}

sub create {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_);
    return $app->error( $app->translate('Site not found'), 404 )
        unless $site && $site->id;

    my $author = $app->user;

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
        ->exist( { blog_id => $site->id, basename => $new_page->basename } )
        )
    {
        $new_page->basename( MT::Util::make_unique_basename($new_page) );
    }
    MT::Util::translate_naughty_words($new_page);

    my $post_save
        = MT::DataAPI::Endpoint::v1::Entry::build_post_save_sub( $app, $site,
        $new_page, $orig_page );

    # Check whether or not assets can attach.
    my $page_json = $app->param('page');
    my $page_hash = $app->current_format->{unserialize}->($page_json);

    my $attach_folder;
    if ( exists $page_hash->{folder}
        && ref $page_hash->{folder} eq 'HASH'
        && exists $page_hash->{folder}{id} )
    {
        my $folder_hash = $page_hash->{folder};

        $attach_folder = MT->model('folder')->load(
            {   id      => $page_hash->{folder}{id},
                blog_id => $site->id,
                class   => 'folder',
            }
        );

        return $app->error( "'folder' parameter is invalid.", 400 )
            if !$attach_folder;
    }

    my @attach_assets;
    if ( exists $page_hash->{assets} ) {
        my $assets_hash = $page_hash->{assets};
        $assets_hash = [$assets_hash] if ref $assets_hash ne 'ARRAY';

        if ( scalar @$assets_hash > 0 ) {
            my @asset_ids = map { $_->{id} }
                grep { ref $_ eq 'HASH' && $_->{id} } @$assets_hash;
            my @site_ids = ( $site->id );
            if ( !$site->is_blog ) {
                my @child_sites = @{ $site->blogs };
                my @child_site_ids = map { $_->id } @child_sites;
                push @site_ids, @child_site_ids;
            }
            @attach_assets = MT->model('asset')->load(
                {   id      => \@asset_ids,
                    blog_id => \@site_ids,
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

    my $do_publish = $app->param('publish');
    $post_save->()
        if !defined $do_publish || $do_publish;

    # Remove autosave object
    remove_autosave_session_obj( $app, $new_page->class );

    $new_page;
}

sub update_openapi_spec {
    my $spec = MT::DataAPI::Endpoint::v2::Page::update_openapi_spec();
    $spec->{requestBody}{content}{'application/x-www-form-urlencoded'}{schema}{properties}{publish} = {
        type        => 'integer',
        description => 'If this value is "0", the entry is not published',
        enum        => [0, 1],
    };
    return $spec;
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

    # Check whether or not assets can attach/detach.
    my $page_json = $app->param('page');
    my $page_hash = $app->current_format->{unserialize}->($page_json);

    my $update_folder;
    if ( exists $page_hash->{folder} ) {
        my $folder_hash = $page_hash->{folder};

        if ( exists $folder_hash->{id} ) {
            $update_folder = MT->model('folder')->load(
                {   id      => $folder_hash->{id},
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
            my @site_ids = ( $site->id );
            if ( !$site->is_blog ) {
                my @child_sites = @{ $site->blogs };
                my @child_site_ids = map { $_->id } @child_sites;
                push @site_ids, @child_site_ids;
            }
            @update_assets = MT->model('asset')->load(
                {   id      => \@asset_ids,
                    blog_id => \@site_ids,
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
            $new_page->modified_by( $app->user->id );

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

    my $do_publish = $app->param('publish');
    $post_save->()
        if !defined $do_publish || $do_publish;

    # Remove autosave object
    remove_autosave_session_obj( $app, $new_page->class, $new_page->id );

    $new_page;
}

1;
