# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v3::Entry;

use strict;
use warnings;

use MT::Entry;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Endpoint::v1::Entry;
use MT::DataAPI::Endpoint::v2::Entry;
use MT::DataAPI::Resource;

sub create_openapi_spec {
    my $spec = MT::DataAPI::Endpoint::v2::Entry::create_openapi_spec();
    $spec->{requestBody}{content}{'application/x-www-form-urlencoded'}{schema}{properties}{publish} = {
        type        => 'integer',
        description => 'If this value is "0", the entry is not published',
        enum        => [0, 1],
    };
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

    my $do_publish = $app->param('publish');
    $post_save->()
        if !defined $do_publish || $do_publish;

    # Remove autosave object
    remove_autosave_session_obj( $app, $new_entry->class );

    $new_entry;
}

sub update_openapi_spec {
    my $spec = MT::DataAPI::Endpoint::v2::Entry::update_openapi_spec();
    $spec->{requestBody}{content}{'application/x-www-form-urlencoded'}{schema}{properties}{publish} = {
        type        => 'integer',
        description => 'If this value is "0", the entry is not published',
        enum        => [0, 1],
    };
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

    my $do_publish = $app->param('publish');
    $post_save->()
        if !defined $do_publish || $do_publish;

    # Remove autosave object
    remove_autosave_session_obj( $app, $new_entry->class, $new_entry->id );

    $new_entry;
}

1;
