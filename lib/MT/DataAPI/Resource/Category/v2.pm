# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Category::v2;

use strict;
use warnings;

use MT::DataAPI::Resource::Category;

sub updatable_fields {
    [ @{ MT::DataAPI::Resource::Category::updatable_fields() }, 'parent', ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::Category::v2 - Movable Type class for resources definitions of the MT::Category.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
