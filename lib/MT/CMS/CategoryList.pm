package MT::CMS::CategoryList;
use strict;
use warnings;

use MT::CategoryList;

sub view {
    my $app = shift;

    return $app->permission_denied
        unless $app->can_do('edit_category_list');

    if ( my $list_id = $app->param('id') ) {
        unless ( MT::CategoryList->exist($list_id) ) {
            return $app->errtrans( 'Invalid category_list_id: [_1]',
                $list_id );
        }
    }

    $app->param( '_type',            'category' );
    $app->param( 'is_category_list', 1 );
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
            permit_action => 'delete_category_list',
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
            if $p->can_do('access_to_category_list_list');
    }
    return $cond ? 1 : 0;
}

sub can_delete {
    my ( $eh, $app, $list ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();

    if ( $list && !ref $list ) {
        $list = MT::CategoryList->load($list)
            or return;
    }

    my $blog_id
        = $list ? $list->blog_id : ( $app->blog ? $app->blog->id : 0 );
    return $author->permissions($blog_id)->can_do('delete_category_list');
}

1;

