# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Website::v2;

use strict;
use warnings;

use base qw(MT::DataAPI::Resource::Blog::v2);

sub updatable_fields {
    $_[0]->SUPER::updatable_fields();
}

sub fields {
    $_[0]->SUPER::fields();
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::Website::v2 - Movable Type class for resources definitions of the MT::Website.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
