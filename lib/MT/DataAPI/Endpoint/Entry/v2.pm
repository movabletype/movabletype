# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::Entry::v2;

use strict;
use warnings;

use MT::Entry;
use MT::Util;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Endpoint::Entry;
use MT::DataAPI::Resource;

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
        = MT::DataAPI::Endpoint::Entry::build_post_save_sub( $app, $blog,
        $new_entry, $orig_entry );

    # Check whether or not assets can attach.
    my $entry_json = $app->param('entry');
    my $entry_hash = $app->current_format->{unserialize}->($entry_json);

    my @attach_cats;
    if ( exists $entry_hash->{categories} ) {
        my $cats_hash = $entry_hash->{categories};
        $cats_hash = [$cats_hash] if ref $cats_hash ne 'ARRAY';

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
    }

    my @attach_assets;
    if ( exists $entry_hash->{assets} ) {
        my $assets_hash = $entry_hash->{assets};
        $assets_hash = [$assets_hash] if ref $assets_hash ne 'ARRAY';

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

    $new_entry;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $orig_entry ) = context_objects(@_)
        or return;
    my $new_entry = $app->resource_object( 'entry', $orig_entry )
        or return;

    my $post_save
        = MT::DataAPI::Endpoint::Entry::build_post_save_sub( $app, $blog,
        $new_entry, $orig_entry );

    # Check whether or not assets can attach/detach.
    my $entry_json = $app->param('entry');
    my $entry_hash = $app->current_format->{unserialize}->($entry_json);

    my @update_cats;
    if ( exists $entry_hash->{categories} ) {
        my $cats_hash = $entry_hash->{categories};
        $cats_hash = [$cats_hash] if ref $cats_hash ne 'ARRAY';

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
    }

    my @update_assets;
    if ( exists $entry_hash->{assets} ) {
        my $assets_hash = $entry_hash->{assets};
        $assets_hash = [$assets_hash] if ref $assets_hash ne 'ARRAY';

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
    if (@update_cats) {
        $new_entry->update_categories(@update_cats)
            or return $app->error( $new_entry->errstr );
    }
    if (@update_assets) {
        $new_entry->update_assets(@update_assets)
            or return $app->error( $new_entry->errstr );
    }

    $post_save->();

    $new_entry;
}

sub list_for_category {
    my ( $app, $endpoint ) = @_;
    list_for_category_common( $app, $endpoint, 'entry' );
}

sub list_for_category_common {
    my ( $app, $endpoint, $class ) = @_;

    my ( $blog, $cat ) = context_objects(@_)
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

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
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

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_for_tag {
    my ( $app, $endpoint ) = @_;
    list_for_tag_common( $app, $endpoint, 'entry' );
}

sub list_for_tag_common {
    my ( $app, $endpoint, $class ) = @_;

    require MT::DataAPI::Endpoint::Tag::v2;
    my $tag = MT::DataAPI::Endpoint::Tag::v2::_retrieve_tag($app) or return;

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

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_for_site_and_tag {
    my ( $app, $endpoint ) = @_;
    list_for_site_and_tag_common( $app, $endpoint, 'entry' );
}

sub list_for_site_and_tag_common {
    my ( $app, $endpoint, $class ) = @_;

    require MT::DataAPI::Endpoint::Tag::v2;
    my ( $tag, $site_id )
        = MT::DataAPI::Endpoint::Tag::v2::_retrieve_tag_related_to_site($app)
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

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::Entry::v2 - Movable Type class for endpoint definitions about the MT::Entry.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
