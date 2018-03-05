# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v4::ContentType;
use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    return $app->error( $app->translate('Site not found'), 404 )
        unless $app->blog;

    my $res = filtered_list( $app, $endpoint, 'content_type' ) or return;

    +{  totalResults => $res->{count} || 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub create {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_) or return;

    my $orig_content_type
        = $app->model('content_type')->new( blog_id => $site->id );

    my $new_content_type
        = $app->resource_object( 'content_type', $orig_content_type )
        or return;

    save_object( $app, 'content_type', $new_content_type ) or return;

    $new_content_type;
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ( $site, $content_type ) = context_objects(@_);
    return unless $content_type;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'content_type', $content_type->id, obj_promise($content_type) )
        or return;

    $content_type;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $site, $orig_content_type ) = context_objects(@_);
    return unless $orig_content_type;

    my $new_content_type
        = $app->resource_object( 'content_type', $orig_content_type )
        or return;

    save_object( $app, 'content_type', $new_content_type ) or return;

    $new_content_type;
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ( $site, $content_type ) = context_objects(@_);
    return unless $content_type;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'content_type', $content_type )
        or return;

    $content_type->remove()
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $content_type->class_label,
            $content_type->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.content_type',
        $app, $content_type );

    $content_type;
}

1;

