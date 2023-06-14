# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::v6;

use warnings;
use strict;

sub endpoints {
    [
        {
            id              => 'list_stats_pageviews_for_path',
            route           => '/sites/:site_id/stats/path/pageviews',
            version         => 6,
            handler         => '$Core::MT::DataAPI::Endpoint::v6::Stats::pageviews_for_path',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v6::Stats::pageviews_for_path_openapi_spec',
        },
        {
            id              => 'list_stats_visits_for_path',
            route           => '/sites/:site_id/stats/path/visits',
            version         => 6,
            handler         => '$Core::MT::DataAPI::Endpoint::v6::Stats::visits_for_path',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v6::Stats::visits_for_path_openapi_spec',
        },
        {
            id              => 'list_stats_pageviews_for_date',
            route           => '/sites/:site_id/stats/date/pageviews',
            version         => 6,
            handler         => '$Core::MT::DataAPI::Endpoint::v6::Stats::pageviews_for_date',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v6::Stats::pageviews_for_date_openapi_spec',
        },
        {
            id              => 'list_stats_visits_for_date',
            route           => '/sites/:site_id/stats/date/visits',
            version         => 6,
            handler         => '$Core::MT::DataAPI::Endpoint::v6::Stats::visits_for_date',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v6::Stats::visits_for_date_openapi_spec',
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v6 - Movable Type class for v6 endpoint definition.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
