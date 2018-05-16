# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v4::Category;
use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Endpoint::v2::Category;
use MT::DataAPI::Resource;

sub list_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'category_set', $category_set->id, obj_promise($category_set) )
        or return;

    my $res = filtered_list(
        $app,
        $endpoint,
        'category',
        {   blog_id         => $category_set->blog_id,
            category_set_id => $category_set->id,
        }
    ) or return;

    +{  totalResults => $res->{count} || 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_parents_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set, $category ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'category_set', $category_set->id, obj_promise($category_set) )
        or return;

    my $max_depth = $app->param('maxDepth') || 0;
    my @parent_cats
        = MT::DataAPI::Endpoint::v2::Category::_get_all_parent_categories(
        $category, $max_depth );

    for my $parent_cat (@parent_cats) {
        run_permission_filter( $app, 'data_api_view_permission_filter',
            'category', $parent_cat->id, obj_promise($parent_cat) )
            or return;
    }

    if ( $app->param('includeCurrent') ) {
        unshift @parent_cats, $category;
    }

    +{  totalResults => scalar @parent_cats,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( \@parent_cats ),
    };
}

sub list_siblings_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set, $category ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'category_set', $category_set->id, obj_promise($category_set) )
        or return;

    my %terms = (
        id              => { not => $category->id },
        blog_id         => $category->blog_id,
        parent          => $category->parent,
        category_set_id => $category->category_set_id,
    );
    my $res = filtered_list( $app, $endpoint, 'category', \%terms ) or return;

    +{  totalResults => $res->{count} || 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_children_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set, $category ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'category_set', $category_set->id, obj_promise($category_set) )
        or return;

    my $max_depth = $app->param('maxDepth') || 0;
    my @child_cats
        = MT::DataAPI::Endpoint::v2::Category::_get_all_child_categories(
        $category, $max_depth );

    for my $child_cat (@child_cats) {
        run_permission_filter( $app, 'data_api_view_permission_filter',
            'category', $child_cat->id, obj_promise($child_cat) )
            or return;
    }

    if ( $app->param('includeCurrent') ) {
        unshift @child_cats, $category;
    }

    +{  totalResults => scalar @child_cats,
        items => MT::DataAPI::Resource::Type::ObjectList->new( \@child_cats ),
    };
}

sub create_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_save_permission_filter',
        'category_set', $category_set->id )
        or return;

    my $orig_category = $app->model('category')->new(
        blog_id         => $category_set->blog_id,
        category_set_id => $category_set->id,
    );

    my $new_category = $app->resource_object( 'category', $orig_category )
        or return;

    save_object( $app, 'category', $new_category ) or return;

    $new_category;
}

sub get_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set, $category ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'category_set', $category_set->id, obj_promise($category_set) )
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'category', $category->id, obj_promise($category) )
        or return;

    $category;
}

sub update_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set, $orig_category ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_save_permission_filter',
        'category_set', $category_set->id )
        or return;

    my $new_category = $app->resource_object( 'category', $orig_category );

    save_object( $app, 'category', $new_category ) or return;

    $new_category;
}

sub delete_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set, $category ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_save_permission_filter',
        'category_set', $category_set )
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'category', $category )
        or return;

    $category->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $category->class_label,
            $category->errstr
        ),
        500,
        );

    $app->run_callbacks( 'data_api_post_delete.category', $app, $category );

    $category;
}

sub permutate_for_category_set {
    my ( $app, $endpoint ) = @_;

    my ( $site, $category_set ) = context_objects(@_) or return;

    run_permission_filter( $app, 'data_api_save_permission_filter',
        'category_set', $category_set->id )
        or return;

    if ( !$app->can_do('edit_categories') ) {
        return $app->error(403);
    }

    MT::DataAPI::Endpoint::v2::Category::permutate_common( $app, $endpoint,
        $site, 'category', $category_set->id );
}

1;

