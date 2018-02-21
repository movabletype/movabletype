# Movable Type (r) (C) 2006-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package FormattedText::DataAPI::Endpoint::v2::FormattedText;

use strict;
use warnings;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    my $res = filtered_list( $app, $endpoint, 'formatted_text' ) or return;

    +{  totalResults => $res->{count},
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ( $site, $ft ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'formatted_text', $ft->id, obj_promise($ft) )
        or return;

    $ft;
}

sub create {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_)
        or return;
    if ( !$site->id ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    my $orig_ft = $app->model('formatted_text')->new;
    $orig_ft->set_values( { blog_id => $site->id, } );

    my $new_ft = $app->resource_object( 'formatted_text', $orig_ft )
        or return;

    save_object( $app, 'formatted_text', $new_ft, $orig_ft, ) or return;

    $new_ft;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $site, $orig_ft ) = context_objects(@_)
        or return;

    my $new_ft = $app->resource_object( 'formatted_text', $orig_ft )
        or return;

    save_object(
        $app,
        'formatted_text',
        $new_ft, $orig_ft,
        sub {
            $new_ft->modified_by( $app->user->id ) if $app->user;
            $_[0]->();
        }
    ) or return;

    $new_ft;
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ( $site, $ft ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'formatted_text', $ft )
        or return;

    $ft->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]',
            $ft->class_label, $ft->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.formatted_text', $app, $ft );

    $ft;
}

1;

__END__

=head1 NAME

FormattedText::DataAPI::Endpoint::v2::FormattedText - Movable Type class for endpoint definitions
about the FormattedText::FormattedText.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
