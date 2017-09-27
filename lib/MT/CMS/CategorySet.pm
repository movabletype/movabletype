# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::CategorySet;
use strict;
use warnings;

use MT::CategorySet;

sub view {
    my $app = shift;

    return $app->permission_denied
        unless $app->can_do('edit_category_set');

    if ( my $set_id = $app->param('id') ) {
        unless ( MT::CategorySet->exist($set_id) ) {
            return $app->errtrans( 'Invalid category_set_id: [_1]', $set_id );
        }
    }

    $app->param( '_type',           'category' );
    $app->param( 'is_category_set', 1 );
    $app->forward('list');
}

sub list_actions {
    {   delete => {
            label         => 'Delete',
            code          => '$Core::MT::Common::delete',
            mode          => 'delete',
            order         => 100,
            js_message    => 'delete',
            button        => 1,
            permit_action => 'delete_category_set',
        },
    };
}

sub manage_condition {
    my $app = MT->app;
    return 1 if $app->user->is_superuser;

    my $blog = $app->blog;
    my $blog_ids
        = !$blog         ? undef
        : $blog->is_blog ? [ $blog->id ]
        :                  [ $blog->id, map { $_->id } @{ $blog->blogs } ];

    require MT::Permission;
    my $iter = MT::Permission->load_iter(
        {   author_id => $app->user->id,
            (   $blog_ids
                ? ( blog_id => $blog_ids )
                : ( blog_id => { not => 0 } )
            ),
        }
    );

    my $cond;
    while ( my $p = $iter->() ) {
        $cond = 1, last
            if $p->can_do('access_to_category_set_list');
    }
    return $cond ? 1 : 0;
}

sub can_delete {
    my ( $eh, $app, $set ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();

    if ( $set && !ref $set ) {
        $set = MT::CategorySet->load($set)
            or return;
    }

    my $blog_id = $set ? $set->blog_id : ( $app->blog ? $app->blog->id : 0 );
    return $author->permissions($blog_id)->can_do('delete_category_set');
}

1;

