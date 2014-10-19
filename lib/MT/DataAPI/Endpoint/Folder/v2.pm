# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::Folder::v2;

use strict;
use warnings;

use MT::Util;
use MT::DataAPI::Endpoint::Category::v2;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    my %terms;
    if ( $app->param('top') ) {
        %terms = ( parent => 0 );
    }

    my $res = filtered_list( $app, $endpoint, 'folder', \%terms ) or return;

    +{  totalResults => $res->{count},
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_parents {
    my ( $app, $endpoint ) = @_;

    my $folder = get( $app, $endpoint ) or return;

    my $max_depth = $app->param('maxDepth') || 0;
    my @parent_folders
        = MT::DataAPI::Endpoint::Category::v2::_get_all_parent_categories(
        $folder, $max_depth );

    for my $parent_folder (@parent_folders) {
        run_permission_filter( $app, 'data_api_view_permission_filter',
            'folder', $parent_folder->id, obj_promise($parent_folder) )
            or return;
    }

    if ( $app->param('includeCurrent') ) {
        unshift @parent_folders, $folder;
    }

    +{  totalResults => scalar @parent_folders,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( \@parent_folders ),
    };
}

sub list_siblings {
    my ( $app, $endpoint ) = @_;

    my $folder = get( $app, $endpoint ) or return;

    my %terms = (
        id      => { not => $folder->id },
        blog_id => $folder->blog_id,
        parent  => $folder->parent,
    );
    my $res = filtered_list( $app, $endpoint, 'folder', \%terms ) or return;

    +{  totalResults => $res->{count},
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_children {
    my ( $app, $endpoint ) = @_;

    my $folder = get( $app, $endpoint ) or return;

    my $max_depth = $app->param('maxDepth') || 0;
    my @child_folders
        = MT::DataAPI::Endpoint::Category::v2::_get_all_child_categories(
        $folder, $max_depth );

    for my $child_folder (@child_folders) {
        run_permission_filter( $app, 'data_api_view_permission_filter',
            'folder', $child_folder->id, obj_promise($child_folder) )
            or return;
    }

    if ( $app->param('includeCurrent') ) {
        unshift @child_folders, $folder;
    }

    +{  totalResults => scalar @child_folders,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( \@child_folders ),
    };
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ( $site, $folder ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'folder', $folder->id, obj_promise($folder) )
        or return;

    $folder;
}

sub create {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_);
    return unless $site && $site->id;

    my $author = $app->user;

    my $orig_folder = $app->model('folder')->new;
    $orig_folder->set_values(
        {   blog_id   => $site->id,
            author_id => $author->id,
        }
    );

    my $new_folder = $app->resource_object( 'folder', $orig_folder )
        or return;

    if (   !defined( $new_folder->basename )
        || $new_folder->basename eq ''
        || $app->model('folder')->exist(
            { blog_id => $site->id, basename => $new_folder->basename }
        )
        )
    {
        $new_folder->basename(
            MT::Util::make_unique_category_basename($new_folder) );
    }

    save_object( $app, 'folder', $new_folder )
        or return;

    $new_folder;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $site, $orig_folder ) = context_objects(@_)
        or return;
    my $new_folder = $app->resource_object( 'folder', $orig_folder )
        or return;

    save_object(
        $app, 'folder',
        $new_folder,
        $orig_folder,
        sub {
            $new_folder->modified_by( $app->user->id );
            $_[0]->();
        }
    ) or return;

    $new_folder;
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ( $site, $folder ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'folder', $folder )
        or return;

    require MT::CMS::Category;
    MT::CMS::Category::pre_delete( $app, $folder )
        or return;

    $folder->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $folder->class_label,
            $folder->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.folder', $app, $folder );

    $folder;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::Folder::v2 - Movable Type class for endpoint definitions about the MT::Folder.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
