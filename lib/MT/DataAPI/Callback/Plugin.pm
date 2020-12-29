# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Callback::Plugin;

use strict;
use warnings;

sub can_list {
    my ( $eh, $app ) = @_;
    return $app->can_do('manage_plugins');
}

sub can_view {
    can_list(@_);
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::Plugin - Movable Type class for Data API's callbacks about the MT::Plugin.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
