# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::API::Endpoint::Entry;

use warnings;
use strict;

use MT::API::Endpoint::Common;
use MT::API::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    my $res = filtered_list( $app, $endpoint, 'entry' );

    +{  totalResults => $res->{count},
        items => MT::API::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub create {
    my ( $app, $endpoint ) = @_;

    my ($blog) = context_objects(@_)
        or return;

    my $orig_entry = $app->model('entry')->new;
    $orig_entry->set_values(
        {   blog_id   => $blog->id,
            author_id => $app->user->id,
        }
    );

    my $new_entry = $app->resource_object( 'entry', $orig_entry )
        or return $app->error( resource_error('entry') );

    save_object( $app, 'entry', $new_entry )
        or return;

    $new_entry;
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $entry ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'cms_view_permission_filter', 'entry',
        $entry )
        or return;

    $entry;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $entry ) = context_objects(@_)
        or return;
    my $new_entry = $app->resource_object( 'entry', $entry )
        or return $app->error( resource_error('entry') );

    save_object( $app, 'entry', $new_entry, $entry )
        or return;

    $new_entry;
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $entry ) = context_objects(@_)
        or return;

    remove_object( $app, 'entry', $entry )
        or return;

    $entry;
}

1;
