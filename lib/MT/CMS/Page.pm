# Movable Type (r) Open Source (C) 2001-2011 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::CMS::Page;

use strict;
use MT::CMS::Entry;

sub edit {
    require MT::CMS::Entry;
    MT::CMS::Entry::edit(@_);
}

sub save_pages {
    my $app = shift;
    return $app->forward('save_entries');
}

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    my $perms = $app->permissions;
    if (   !$id
        && !$perms->can_do('create_new_page') )
    {
        return 0;
    }
    if ($id) {
        my $obj = $objp->force();
        return 0 if $obj->is_entry;
        if ( !$app->user->permissions( $obj->blog_id )->can_do('open_page_edit_screen') ) {
            return 0;
        }
    }
    1;
}

sub can_save {
    my ( $eh, $app, $id ) = @_;
    unless ( ref $id ) {
        $id = MT->model('page')->load($id)
            or return;
    }
    return unless $id->isa('MT::Page');

    my $author = $app->user;
    return $author->permissions($id->blog_id)->can_do('save_page');

}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();

    unless ( ref $obj ) {
        $obj = MT->model('page')->load($obj)
            or return;
    }
    return unless $obj->isa('MT::Page');

    my $perms = $app->permissions;
    if ( !$perms || $perms->blog_id != $obj->blog_id ) {
        $perms = $author->permissions( $obj->blog_id );
    }
    return $perms && $perms->can_do('delete_page');
}

sub pre_save {
    require MT::CMS::Entry;
    MT::CMS::Entry::pre_save(@_);
}

sub post_save {
    require MT::CMS::Entry;
    MT::CMS::Entry::post_save(@_);
}


sub post_delete {
    require MT::CMS::Entry;
    MT::CMS::Entry::post_delete(@_);
}

sub CMSPostSave_page {
    require MT::CMS::Entry;
    MT::CMS::Entry::post_save(@_);
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    my $user = $app->user;
    return if $user->is_superuser;

    my $load_blog_ids = $load_options->{blog_ids} || undef;

    require MT::Permission;
    my $iter = MT::Permission->load_iter(
        {   author_id => $user->id,
            (   $load_blog_ids
                ? ( blog_id => $load_blog_ids )
                : ( blog_id => { 'not' => 0 } )
            ),
        }
    );

    my $blog_ids;
    while ( my $perm = $iter->() ) {
        if ( $perm->can_do('manage_pages') ) {
            push @$blog_ids, $perm->blog_id;
        }
    }

    my $terms = $load_options->{terms} || {};
    $terms->{blog_id} = $blog_ids
        if $blog_ids;
    $load_options->{terms} = $terms;
}

1;
