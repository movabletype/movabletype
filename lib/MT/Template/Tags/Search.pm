# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Template::Tags::Search;

use strict;
use warnings;

###########################################################################

=head2 SearchMaxResults

Returns the value of the C<SearchMaxResults> or C<MaxResults> configuration
setting. Use C<SearchMaxResults> because MaxResults is considered deprecated.

=for tags search, configuration

=cut

sub _hdlr_search_max_results {
    my ($ctx) = @_;
    return $ctx->{config}->SearchMaxResults;
}

1;
