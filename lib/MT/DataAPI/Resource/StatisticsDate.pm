# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::StatisticsDate;

use strict;
use warnings;

sub fields {
    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    return [{
            name   => 'date',
            schema => {
                type        => 'string',
                format      => 'date',
                description => 'The date of the target. The format is "YYYY-MM-DD".',
            },
        },
        {
            name   => 'pageviews',
            schema => {
                type        => 'string',
                description => 'The pageviews for the path. This property exists only if the metrics to retrieve is "pageviews"',
            },
        },
        {
            name   => 'visits',
            schema => {
                type        => 'string',
                description => 'The visits for the path. This property exists only if the metrics to retrieve is "visits"',
            },
        }];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::StatisticsDate - Resources definitions of the statistics API.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
