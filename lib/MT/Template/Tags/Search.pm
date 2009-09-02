# Movable Type (r) Open Source (C) 2001-2009 Six Apart Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: Search.pm 104967 2009-06-10 05:27:13Z ytakayama $
package MT::Template::Tags::Search;

use strict;

###########################################################################

=head2 SearchMaxResults

Returns the value of the C<SearchMaxResults> or C<MaxResults> configuration
setting. Use C<SearchMaxResults> because MaxResults is considered deprecated.

=for tags search, configuration

=cut

sub _hdlr_search_max_results {
    my ($ctx) = @_;
    return $ctx->{config}->MaxResults;
}

1;
