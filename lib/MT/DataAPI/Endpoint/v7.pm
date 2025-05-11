# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::v7;

use warnings;
use strict;

sub endpoints {
    [
        {
            id              => 'export_site_theme',
            route           => '/sites/:site_id/export_theme',
            verb            => 'POST',
            version         => 7,
            handler         => '$Core::MT::DataAPI::Endpoint::v7::Theme::export',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v7::Theme::export_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to export the requested theme.',
            },
        },
        {
            id              => 'list_stats_pageviews_for_path',
            route           => '/sites/:site_id/stats/path/pageviews',
            version         => 7,
            handler         => '$Core::MT::DataAPI::Endpoint::v7::Stats::screenpageviews_for_path',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v7::Stats::screenpageviews_for_path_openapi_spec',
        },
        {
            id              => 'list_stats_visits_for_path',
            route           => '/sites/:site_id/stats/path/visits',
            version         => 7,
            handler         => '$Core::MT::DataAPI::Endpoint::v7::Stats::sessions_for_path',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v7::Stats::sessions_for_path_openapi_spec',
        },
        {
            id              => 'list_stats_pageviews_for_date',
            route           => '/sites/:site_id/stats/date/pageviews',
            version         => 7,
            handler         => '$Core::MT::DataAPI::Endpoint::v7::Stats::screenpageviews_for_date',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v7::Stats::screenpageviews_for_date_openapi_spec',
        },
        {
            id              => 'list_stats_visits_for_date',
            route           => '/sites/:site_id/stats/date/visits',
            version         => 7,
            handler         => '$Core::MT::DataAPI::Endpoint::v7::Stats::sessions_for_date',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v7::Stats::sessions_for_date_openapi_spec',
        },
        {
            id              => 'list_stats_screenpageviews_for_path',
            route           => '/sites/:site_id/stats/path/screenPageViews',
            version         => 7,
            handler         => '$Core::MT::DataAPI::Endpoint::v7::Stats::screenpageviews_for_path',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v7::Stats::screenpageviews_for_path_openapi_spec',
        },
        {
            id              => 'list_stats_sessions_for_path',
            route           => '/sites/:site_id/stats/path/sessions',
            version         => 7,
            handler         => '$Core::MT::DataAPI::Endpoint::v7::Stats::sessions_for_path',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v7::Stats::sessions_for_path_openapi_spec',
        },
        {
            id              => 'list_stats_screenpageviews_for_date',
            route           => '/sites/:site_id/stats/date/screenPageViews',
            version         => 7,
            handler         => '$Core::MT::DataAPI::Endpoint::v7::Stats::screenpageviews_for_date',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v7::Stats::screenpageviews_for_date_openapi_spec',
        },
        {
            id              => 'list_stats_screenpageviews_for_yearweek',
            route           => '/sites/:site_id/stats/yearWeek/screenPageViews',
            version         => 7,
            handler         => '$Core::MT::DataAPI::Endpoint::v7::Stats::screenpageviews_for_yearweek',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v7::Stats::screenpageviews_for_yearweek_openapi_spec',
        },
        {
            id              => 'list_stats_screenpageviews_for_yearmonth',
            route           => '/sites/:site_id/stats/yearMonth/screenPageViews',
            version         => 7,
            handler         => '$Core::MT::DataAPI::Endpoint::v7::Stats::screenpageviews_for_yearmonth',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v7::Stats::screenpageviews_for_yearmonth_openapi_spec',
        },
        {
            id              => 'list_stats_screenpageviews_for_year',
            route           => '/sites/:site_id/stats/year/screenPageViews',
            version         => 7,
            handler         => '$Core::MT::DataAPI::Endpoint::v7::Stats::screenpageviews_for_year',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v7::Stats::screenpageviews_for_year_openapi_spec',
        },
        {
            id              => 'list_stats_sessions_for_date',
            route           => '/sites/:site_id/stats/date/sessions',
            version         => 7,
            handler         => '$Core::MT::DataAPI::Endpoint::v7::Stats::sessions_for_date',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v7::Stats::sessions_for_date_openapi_spec',
        },
        {
            id              => 'list_stats_sessions_for_yearweek',
            route           => '/sites/:site_id/stats/yearWeek/sessions',
            version         => 7,
            handler         => '$Core::MT::DataAPI::Endpoint::v7::Stats::sessions_for_yearweek',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v7::Stats::sessions_for_yearweek_openapi_spec',
        },
        {
            id              => 'list_stats_sessions_for_yearmonth',
            route           => '/sites/:site_id/stats/yearMonth/sessions',
            version         => 7,
            handler         => '$Core::MT::DataAPI::Endpoint::v7::Stats::sessions_for_yearmonth',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v7::Stats::sessions_for_yearmonth_openapi_spec',
        },
        {
            id              => 'list_stats_sessions_for_year',
            route           => '/sites/:site_id/stats/year/sessions',
            version         => 7,
            handler         => '$Core::MT::DataAPI::Endpoint::v7::Stats::sessions_for_year',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v7::Stats::sessions_for_year_openapi_spec',
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v7 - Movable Type class for v6 endpoint definition.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut

