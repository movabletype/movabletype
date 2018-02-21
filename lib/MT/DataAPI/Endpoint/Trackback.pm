# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::Trackback;

use warnings;
use strict;

use MT::Util qw(remove_html);
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    my $res = filtered_list( $app, $endpoint, 'ping' ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_for_entry {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $entry ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        $entry->class, $entry->id, obj_promise($entry) )
        or return;

    my $res = filtered_list(
        $app,
        $endpoint,
        'ping', undef,
        {   joins => [
                MT->model('trackback')->join_on(
                    undef,
                    {   entry_id => $entry->id,
                        id       => \'= tbping_tb_id',
                    },
                )
            ],
        }
    );

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $trackback ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'ping', $trackback->id, obj_promise($trackback) )
        or return;

    $trackback;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $trackback ) = context_objects(@_)
        or return;
    my $new_trackback = $app->resource_object( 'trackback', $trackback )
        or return;

    save_object( $app, 'ping', $new_trackback, $trackback )
        or return;

    $new_trackback;
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $trackback ) = context_objects(@_)
        or return;

    remove_object( $app, 'ping', $trackback )
        or return;

    $trackback;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::Trackback - Movable Type class for endpoint definitions about the MT::TBPing.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
