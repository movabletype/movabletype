# Movable Type (r) Open Source (C) 2001-2010 Six Apart Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
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
