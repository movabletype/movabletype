# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v5::Website;

use strict;
use warnings;

use base qw(MT::DataAPI::Resource::v5::Blog);

sub fields {
    $_[0]->SUPER::fields();
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v5::Website - Movable Type class for resources definitions of the MT::Website.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
