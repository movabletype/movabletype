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

    my @attach_assets;
    if ( exists $entry_hash->{assets} ) {
        my $assets_hash = $entry_hash->{assets};
        $assets_hash = [$assets_hash] if ref $assets_hash ne 'ARRAY';

        my @asset_ids = map { $_->{id} }
            grep { ref $_ eq 'HASH' && $_->{id} } @$assets_hash;
        require MT::App::CMS;
        my @blog_ids = (
            @{ MT::App::CMS::_load_child_blog_ids( $app, $blog->id ) },
            $blog->id
        );
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
    if ( my $categories = $entry_hash->{categories} ) {
        $categories = [$categories] if ref $categories ne 'ARRAY';
        my @category_ids = map { $_->{id} }
            grep { ref $_ eq 'HASH' && $_->{id} } @$categories;
        $new_entry->attach_categories(@category_ids);
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

    my @update_assets;
    if ( exists $entry_hash->{assets} ) {
        my $assets_hash = $entry_hash->{assets};
        $assets_hash = [$assets_hash] if ref $assets_hash ne 'ARRAY';

        my @asset_ids = map { $_->{id} }
            grep { ref $_ eq 'HASH' && $_->{id} } @$assets_hash;
        require MT::App::CMS;
        my @blog_ids = (
            @{ MT::App::CMS::_load_child_blog_ids( $app, $blog->id ) },
            $blog->id
        );
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

    if ( my $categories = $entry_hash->{categories} ) {
        $categories = [$categories] if ref $categories ne 'ARRAY';
        my @category_ids = map { $_->{id} }
            grep { ref $_ eq 'HASH' && $_->{id} } @$categories;
        $new_entry->update_categories(@category_ids);
    }

    if (@update_assets) {
        $new_entry->update_assets(@update_assets)
            or return $app->error( $new_entry->errstr );
    }

    $post_save->();

    $new_entry;
}

sub list_categories {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $entry ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'entry', $entry->id, obj_promise($entry) )
        or return;

    my $rows = $entry->__load_category_data or return;
    my %terms = ( id => @$rows ? [ map { $_->[0] } @$rows ] : 0 );
    my $res = filtered_list( $app, $endpoint, 'category', \%terms ) or return;

    +{  totalResults => $res->{count},
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_assets {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $entry ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'entry', $entry->id, obj_promise($entry) )
        or return;

    my %terms = ( class => '*' );
    my %args = (
        join => MT->model('objectasset')->join_on(
            'asset_id',
            {   blog_id   => $blog->id,
                object_ds => 'entry',
                object_id => $entry->id,
            },
        ),
    );
    my $res = filtered_list( $app, $endpoint, 'asset', \%terms, \%args )
        or return;

    +{  totalResults => $res->{count},
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
