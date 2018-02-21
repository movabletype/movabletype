# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Folder;

use strict;
use warnings;

use MT::DataAPI::Endpoint::v2::Category;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;
    return MT::DataAPI::Endpoint::v2::Category::list_common( $app, $endpoint,
        'folder' );
}

sub list_parents {
    my ( $app, $endpoint ) = @_;
    return MT::DataAPI::Endpoint::v2::Category::list_parents_common( $app,
        $endpoint, 'folder' );
}

sub list_siblings {
    my ( $app, $endpoint ) = @_;
    return MT::DataAPI::Endpoint::v2::Category::list_siblings_common( $app,
        $endpoint, 'folder' );
}

sub list_children {
    my ( $app, $endpoint ) = @_;
    return MT::DataAPI::Endpoint::v2::Category::list_children_common( $app,
        $endpoint, 'folder' );
}

sub get {
    my ( $app, $endpoint ) = @_;
    return MT::DataAPI::Endpoint::v2::Category::get_common( $app, $endpoint,
        'folder' );
}

sub create {
    my ( $app, $endpoint ) = @_;
    return MT::DataAPI::Endpoint::v2::Category::create_common( $app,
        $endpoint, 'folder' );
}

sub update {
    my ( $app, $endpoint ) = @_;
    return MT::DataAPI::Endpoint::v2::Category::update_common( $app,
        $endpoint, 'folder' );
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ( $site, $folder ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'folder', $folder )
        or return;

    $folder->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $folder->class_label,
            $folder->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.folder', $app, $folder );

    $folder;
}

sub permutate {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_) or return;
    if ( !$site->id ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    if ( !$app->can_do('save_folder') ) {
        return $app->error(403);
    }

    return MT::DataAPI::Endpoint::v2::Category::permutate_common( $app,
        $endpoint, $site, 'folder' );

}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Folder - Movable Type class for endpoint definitions about the MT::Folder.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
