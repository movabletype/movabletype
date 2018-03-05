# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v4::CategorySet;
use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    return $app->error( $app->translate('Site not found'), 404 )
        unless $app->blog;

    my $res = filtered_list( $app, $endpoint, 'category_set' ) or return;

    +{  totalResults => $res->{count} || 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub create {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_) or return;

    my $orig_category_set
        = $app->model('category_set')->new( blog_id => $site->id );

    my $new_category_set
        = $app->resource_object( 'category_set', $orig_category_set )
        or return;

    save_object( $app, 'category_set', $new_category_set ) or return;

    $new_category_set;
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set ) = context_objects(@_);
    return unless $category_set;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'category_set', $category_set->id, obj_promise($category_set) )
        or return;

    $category_set;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $site, $orig_category_set ) = context_objects(@_);
    return unless $orig_category_set;

    my $new_category_set
        = $app->resource_object( 'category_set', $orig_category_set )
        or return;

    save_object( $app, 'category_set', $new_category_set ) or return;

    $new_category_set;
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set ) = context_objects(@_);
    return unless $category_set;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'category_set', $category_set )
        or return;

    $category_set->remove()
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $category_set->class_label,
            $category_set->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.category_set',
        $app, $category_set );

    $category_set;
}

1;

