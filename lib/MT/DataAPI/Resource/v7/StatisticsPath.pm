# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v7::StatisticsPath;

use strict;
use warnings;

sub fields {
    return [{
            name   => 'pagePath',
            alias  => 'path',
            schema => {
                type        => 'string',
                description => 'The relative path of the target.',
            },
        },
        {
            name   => 'screenPageViews',
            alias  => 'pageviews',
            schema => {
                type        => 'integer',
                description => 'The pageviews for the path. This property exists only if the metrics to retrieve is "screenPageViews"',
            },
        },
        {
            name   => 'sessions',
            alias  => 'visits',
            schema => {
                type        => 'integer',
                description => 'The number of sessions for the path. This property exists only if the metrics to retrieve is "sessions"',

            },
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v7::StatisticsPath - Resources definitions of the statistics API.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
