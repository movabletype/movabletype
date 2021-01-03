# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Callback::Group;

use strict;
use warnings;

use MT::Group;

sub save_filter {
    my ( $eh, $app, $obj ) = @_;

    return 1 if $obj->status == MT::Group::INACTIVE();

    if ( !$obj->status ) {
        return $app->errtrans( 'A parameter "[_1]" is invalid.', 'status' );
    }

    if ( !defined( $obj->name ) || $obj->name eq '' ) {
        return $app->errtrans('Each group must have a name.');
    }
    return 1;
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::Group - Movable Type class for Data API's callbacks about the MT::Group.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
