# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Folder;

use strict;
use warnings;

sub edit {
    require MT::CMS::Category;
    return MT::CMS::Category::edit(@_);
}

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    my $author = $app->user;
    return unless $id;

    my $obj = $objp->force();
    return unless $obj;
    return if $obj->is_category;

    my $blog_id = $obj->blog_id;
    return $author->permissions($blog_id)->can_do('open_folder_edit_screen');
}

sub can_save {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();

    if ( $obj && !ref $obj ) {
        $obj = MT->model('folder')->load($obj)
            or return;
    }
    if ($obj) {
        return unless $obj->isa('MT::Folder');
    }

    my $blog_id = $obj ? $obj->blog_id : ( $app->blog ? $app->blog->id : 0 );
    return $author->permissions($blog_id)->can_do('save_folder');
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();

    if ( $obj && !ref $obj ) {
        $obj = MT->model('folder')->load($obj)
            or return;
    }
    if ($obj) {
        return unless $obj->isa('MT::Folder');
    }

    my $blog_id = $obj ? $obj->blog_id : ( $app->blog ? $app->blog->id : 0 );
    return $author->permissions($blog_id)->can_do('delete_folder');
}

sub pre_save {
    my $eh = shift;
    my ( $app, $obj ) = @_;
    return 1 unless defined $obj->basename;

    my $pkg      = $app->model('folder');
    my @siblings = $pkg->load(
        {   parent  => $obj->parent,
            blog_id => $obj->blog_id
        }
    );
    foreach (@siblings) {
        next if $obj->id && ( $_->id == $obj->id );
        return $eh->error(
            $app->translate(
                "The folder '[_1]' conflicts with another folder. Folders with the same parent must have unique basenames.",
                $_->basename
            )
        ) if $_->basename eq $obj->basename;
    }
    1;
}

sub post_save {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    if ( !$original->id ) {
        $app->log(
            {   message => $app->translate(
                    "Folder '[_1]' created by '[_2]'", $obj->label,
                    $app->user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'folder',
                category => 'new',
            }
        );
    }
    else {
        $app->log(
            {   message => $app->translate(
                    "Folder '[_1]' (ID:[_2]) edited by '[_3]'",
                    $obj->label, $obj->id, $app->user->name
                ),
                level    => MT::Log::NOTICE(),
                class    => $obj->class,
                category => 'edit',
                metadata => $obj->id,
            }
        );
    }

    1;
}

sub save_filter {
    my $eh    = shift;
    my ($app) = @_;
    my $label = $app->param('label') or return 1;
    return $app->errtrans( "The name '[_1]' is too long!", $label )
        if ( length($label) > 100 );
    return 1;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {   message => $app->translate(
                "Folder '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->label, $obj->id, $app->user->name
            ),
            level    => MT::Log::NOTICE(),
            class    => 'folder',
            category => 'delete'
        }
    );
}

1;
