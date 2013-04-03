# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::API::Endpoint::Entry;

use warnings;
use strict;

use MT::API::Endpoint::Common;

sub list {
    my ( $app, $endpoint ) = @_;

    my $res = filtered_list( $app, $endpoint, 'entry' );

    +{  totalResults => $res->{count},
        items        => $res->{objects},
    };
}

sub create {
    my ( $app, $endpoint ) = @_;

    my ($blog) = context_objects(@_)
        or return;

    my $new_entry = $app->resource_object('entry')
        or return $app->error( resource_error('entry') );

    run_permission_filter( $app,
        'cms_save_permission_filter.entry', $new_entry )
        or return;

    save_object($app, $new_entry)
        or return;

    $new_entry;
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $entry ) = context_objects(@_)
        or return;

    run_permission_filter( $app,
        'cms_view_permission_filter.entry', $entry )
        or return;

    $entry;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $entry ) = context_objects(@_)
        or return;
    my $new_entry = $app->resource_object( 'entry', $entry )
        or return $app->error( resource_error('entry') );

    run_permission_filter( $app,
        'cms_save_permission_filter.entry', $new_entry )
        or return;

    save_object($app, $new_entry)
        or return;

    $new_entry;
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $entry ) = context_objects(@_)
        or return;

    run_permission_filter( $app,
        'cms_delete_permission_filter.entry', $entry )
        or return;

    remove_object($app, $entry)
        or return;

    $entry;
}

1;
