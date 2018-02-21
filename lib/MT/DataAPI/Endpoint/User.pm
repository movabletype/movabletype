# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::User;

use warnings;
use strict;

use MT::DataAPI::Endpoint::Common;

sub get {
    my ( $app, $endpoint ) = @_;

    my $user = get_target_user(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'author', $user->id, obj_promise($user) )
        or return;

    $user;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my $user = get_target_user(@_)
        or return;

    my $new_user = $app->resource_object( 'user', $user )
        or return;

    save_object( $app, 'author', $new_user, $user )
        or return;

    $new_user;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::User - Movable Type class for endpoint definitions about the MT::Author.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
