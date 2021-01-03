# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Callback::Role;

use strict;
use warnings;

sub save_filter {
    my ( $eh, $app, $obj, $original ) = @_;

    if ( !( defined $obj->name && $obj->name ne '' ) ) {
        return $app->errtrans( 'A parameter "[_1]" is required.', 'name' );
    }

    my $role_by_name = MT->model('role')->load( { name => $obj->name } );
    if ( $role_by_name && ( !$obj->id || ( $obj->id != $role_by_name->id ) ) )
    {
        return $app->errtrans("Another role already exists by that name.");
    }

    if ( !$obj->permissions ) {
        return $app->errtrans(
            "You cannot define a role without permissions.");
    }

    return 1;
}

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    return $app->can_do('edit_role');
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::Role - Movable Type class for Data API's callbacks about the MT::Role.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
