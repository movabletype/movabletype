# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::CategorySet;
use strict;
use warnings;

sub view {
    my $app = shift;

    $app->validate_param({
        id => [qw/ID/],
    }) or return;

    my $perm = $app->permissions
        or return $app->permission_denied;

    return $app->permission_denied
        if ( !$app->user->is_superuser()
        && !$perm->can_do('edit_category_set') );
    if ( my $set_id = $app->param('id') ) {
        my $category_set = $app->model('category_set')->load($set_id);
        return $app->errtrans( 'Invalid category_set_id: [_1]', $set_id )
            unless $category_set;
        my $blog_id = $app->blog ? $app->blog->id : 0;
        return $app->errtrans('Invalid request.')
            unless $category_set->blog_id == $blog_id;
    }

    $app->param( '_type',           'category' );
    $app->param( 'is_category_set', 1 );
    $app->forward('list');
}

sub list_actions {
    {   delete => {
            label      => 'Delete',
            code       => '$Core::MT::Common::delete',
            mode       => 'delete',
            order      => 100,
            js_message => 'delete',
            button     => 1,
            permission => 'manage_category_set',
        },
    };
}

sub can_list {
    my ( $eh, $app, $terms, $args, $options ) = @_;
    my $user = $app->user;
    return unless $user;

    return 1
        if ( $user->is_superuser() || $user->can_manage_content_types() );

    $user->permissions( $app->blog->id )
        ->can_do('access_to_category_set_list');
}

sub can_save {
    my ( $eh, $app, $id ) = @_;
    my $user = $app->user;
    return unless $user;

    return 1
        if ( $user->is_superuser() || $user->can_manage_content_types() );
    $app->can_do('save_category_set');
}

sub can_delete {
    my ( $eh, $app, $set ) = @_;
    my $author = $app->user;
    return 1
        if ( $author->is_superuser() || $author->can_manage_content_types() );

    if ( $set && !ref $set ) {
        $set = MT->model('category_set')->load($set)
            or return;
    }

    my $blog_id = $set ? $set->blog_id : ( $app->blog ? $app->blog->id : 0 );
    return $author->permissions($blog_id)->can_do('delete_category_set');
}

sub post_delete {
    my ($eh, $app, $set) = @_;

    $app->log({
        message  => $app->translate("Category Set '[_1]' (ID:[_2]) deleted by '[_3]'", $set->name, $set->id, $app->user->name),
        level    => MT::Log::NOTICE(),
        class    => 'category_set',
        category => 'delete'
    });
}

1;
