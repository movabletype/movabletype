# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::Asset::v2;

use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    my $res = filtered_list( $app, $endpoint, 'asset' )
        or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $asset ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'asset', $asset->id, obj_promise($asset) )
        or return;

    $asset;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $orig_asset ) = context_objects(@_)
        or return;
    my $new_asset = $app->resource_object( 'asset', $orig_asset )
        or return;

    save_object( $app, 'asset', $new_asset, $orig_asset, ) or return;

    $new_asset;
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $asset ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'asset', $asset )
        or return;

    $asset->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $asset->class_label,
            $asset->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.asset', $app, $asset );

    $asset;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::Asset::v2 - Movable Type class for endpoint definitions about the MT::Asset.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
