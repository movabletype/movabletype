# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Folder;

use strict;
use warnings;
use base qw( MT::Category );

__PACKAGE__->install_properties(
    {   class_type    => 'folder',
        child_of      => 'MT::Blog',
        child_classes => [ 'MT::Placement', 'MT::FileInfo' ],
    }
);

sub class_label {
    return MT->translate("Folder");
}

sub class_label_plural {
    MT->translate("Folders");
}

sub contents_label {
    MT->translate("Page");
}

sub contents_label_plural {
    MT->translate("Pages");
}

sub list_props {
    return {
        id          => { base => 'category.id', },
        label       => { base => 'category.label', },
        basename    => 'Basename',
        parent      => { base => 'category.parent', },
        entry_count => { base => 'category.entry_count', },
        custom_sort => {
            class => 'folder',
            base  => 'category.custom_sort',
        },
        user_custom => {
            base    => 'folder.custom_sort',
            display => 'none',
        },
        blog_id => {
            auto            => 1,
            col             => 'blog_id',
            display         => 'none',
            filter_editable => 0,
        },
    };
}

sub basename_prefix {
    "folder";
}

sub category_set_id {0}

sub save {
    my $self = shift;
    $self->column( 'category_set_id', 0 );
    $self->SUPER::save(@_);
}

sub remove {
    my $folder                  = shift;
    my $delete_files_at_rebuild = MT->config('DeleteFilesAtRebuild');
    my $rebuild_at_delete       = MT->config('RebuildAtDelete');
    my @moving_pages;
    if ( ref $folder && $rebuild_at_delete && $delete_files_at_rebuild ) {
        my $search_pages;
        $search_pages = sub {
            my $folder = shift;
            my $join   = MT::Placement->join_on(
                'entry_id',
                { category_id => $folder->id, },
                { unique      => 1 },
            );
            push @moving_pages,
                MT->model('page')->load( undef, { join => $join } );
            my @children = $folder->children_categories;
            for my $child (@children) {
                $search_pages->($child);
            }
        };
        $search_pages->($folder);
        require MT::WeblogPublisher;
        for my $page (@moving_pages) {
            MT::WeblogPublisher->remove_entry_archive_file(
                Entry       => $page,
                ArchiveType => 'Page',
            );
        }
    }

    if ( ref $folder ) {

        # Cache of the children folder is cleared.
        $folder->{__children} = undef;
    }

    $folder->SUPER::remove(@_)
        or return $folder->errstr;

    if ( ref $folder && $rebuild_at_delete ) {
        for my $page (@moving_pages) {
            $page->clear_cache();
            MT->rebuild_entry( Entry => $page );
        }
    }
    1;
}

1;
