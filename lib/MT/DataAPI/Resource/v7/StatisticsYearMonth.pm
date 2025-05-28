# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v7::StatisticsYearMonth;

use strict;
use warnings;
use MT::Stats qw(default_provider_has);

sub fields {
    my $fields = default_provider_has('fields_for_statistics_yearmonth') or return;
    return $fields;
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v7::StatisticsYearMonth - Resources definitions of the statistics API.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
