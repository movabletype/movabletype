# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Callback::CategorySetCategory;
use strict;
use warnings;

sub can_save {
    my ( $eh, $app, $id, $obj, $original ) = @_;

    return unless $obj;
    return unless $obj->category_set;

    my $author = $app->user;
    return 1 if $author->is_superuser();

    my $blog_id = $obj ? $obj->blog_id : ( $app->blog ? $app->blog->id : 0 );

    $author->permissions($blog_id)->can_do('save_catefory_set_category')
        ? 1
        : 0;
}

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    my $obj = $objp->force;
    return $obj->category_set ? 1 : 0;
}

sub save_filter {
    require MT::DataAPI::Callback::Category;
    MT::DataAPI::Callback::Category::save_filter(@_);
}

1;

