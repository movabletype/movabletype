# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package GoogleAnalyticsV4::Provider;

use strict;
use warnings;

use base qw(MT::Stats::Provider);

use HTTP::Request::Common;
use GoogleAnalyticsV4;
use GoogleAnalyticsV4::OAuth2 qw(effective_token);
use MT::Util::Encode;

sub is_ready {
    my $class = shift;
    my ($app, $blog) = @_;
    GoogleAnalyticsV4::current_plugindata(@_) ? 1 : 0;
}

sub snippet {
    my $self = shift;
    my ($ctx, $args) = @_;
    my $app        = MT->instance;
    my $plugindata = GoogleAnalyticsV4::current_plugindata($app, $self->blog)
        or return q();

        return <<__HTML__;
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=@{[ $plugindata->data->{measurement_id} ]}"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', '@{[ $plugindata->data->{measurement_id} ]}');
</script>
__HTML__
}

sub _normalize_date {
    my ($str) = @_;
    if ($str =~ m/(\d+)\D+(\d+)\D+(\d+)/) {
        sprintf('%04d-%02d-%02d', $1, $2, $3);
    } else {
        $str;
    }
}

sub _extract_default_params {
    my ($params) = @_;
    my $pagePath = $params->{pagePath} || $params->{path};

    (
        'dateRanges' => [{
            'startDate' => _normalize_date($params->{startDate}),
            'endDate'   => _normalize_date($params->{endDate}),
        }],
        (
            defined($params->{limit})
            ? ('limit' => $params->{limit})
            : ()
        ),
        (
            $pagePath
            ? (
                'dimensionFilter' => {
                    'filter' => {
                        'stringFilter' => {
                            'matchType' => "PARTIAL_REGEXP",
                            'value'     => $pagePath,
                        },
                        'fieldName' => 'pagePath'
                    }
                },
                )
            : ()
        ),
    );
}

sub _request {
    my $self = shift;
    my ($app, $params, $retry_count) = @_;

    require GoogleAnalyticsV4::OAuth2;
    my $plugindata = GoogleAnalyticsV4::current_plugindata($app, $self->blog);
    my $token      = effective_token($app, $plugindata)
        or return;

    my $config = $plugindata->data;

    my $uri = URI->new("https://analyticsdata.googleapis.com/v1beta/$config->{profile_id}:runReport");

    my $ua = GoogleAnalyticsV4::new_ua();

    my $res = $ua->request(
        POST $uri,
        Authorization => "$token->{data}{token_type} $token->{data}{access_token}",
        Content_Type  => 'application/json',
        Content       => MT::Util::to_json($params),
    );

    if ($res->code == 401 && !$retry_count) {
        return $self->_request(@_, 1);
    }

    return $app->error(
        translate(
            'An error occurred when retrieving statistics data: [_1]: [_2]',
            GoogleAnalyticsV4::extract_response_error($res)
        ),
        500
    ) unless $res->is_success;

    my $data = MT::Util::from_json(MT::Util::Encode::decode('utf-8', $res->content));

    my @d_headers = map { $_->{name} } @{ $data->{dimensionHeaders} };
    my @m_headers = map { $_->{name} } @{ $data->{metricHeaders} };

    for my $i (0 .. $#d_headers) {
        if ($d_headers[$i] eq 'date') {
            $_->{dimensionValues}->[$i]->{value} =~ s/(\d{4})(\d{2})/$1-$2-/ for @{ $data->{rows} };
        } elsif ($d_headers[$i] eq 'yearWeek') {
            $_->{dimensionValues}->[$i]->{value} =~ s/(\d{4})(\d{2})/$1-W$2/ for @{ $data->{rows} };
        } elsif ($d_headers[$i] eq 'yearMonth') {
            $_->{dimensionValues}->[$i]->{value} =~ s/(\d{4})(\d{2})/$1-$2/ for @{ $data->{rows} };
        }
    }
    for my $i (0 .. $#m_headers) {
        if ($m_headers[$i] eq 'date') {
            $_->{metricValues}->[$i]->{value} =~ s/(\d{4})(\d{2})/$1-$2-/ for @{ $data->{rows} };
        } elsif ($m_headers[$i] eq 'yearWeek') {
            $_->{metricValues}->[$i]->{value} =~ s/(\d{4})(\d{2})/$1-W$2/ for @{ $data->{rows} };
        } elsif ($m_headers[$i] eq 'yearMonth') {
            $_->{metricValues}->[$i]->{value} =~ s/(\d{4})(\d{2})/$1-$2/ for @{ $data->{rows} };
        }
    }

    my %totals = ();
    if (exists $data->{totals}) {
        %totals = map { $data->{metricHeaders}->[$_]->{name} => $data->{totals}->[0]->{metricValues}->[$_]->{value} } 0 .. $#m_headers;
    } else {
        my @metric_totals;
        for my $i (0 .. $#m_headers) {
            $metric_totals[$i] = 0;
            $metric_totals[$i] += $_->{metricValues}->[$i]->{value} for @{ $data->{rows} };
        }
        %totals = map { $data->{metricHeaders}->[$_]->{name} => $metric_totals[$_] } 0 .. $#m_headers;
    }

    +{
        totalResults => $data->{rowCount},
        totals       => \%totals,
        headers      => [@d_headers, @m_headers],
        colLength    => ($#d_headers + $#m_headers),
        items        => [
            map {
                my $row = $_;
                my %item;
                $item{ $d_headers[$_] } = $row->{dimensionValues}->[$_]->{value} for (0 .. $#d_headers);
                $item{ $m_headers[$_] } = $row->{metricValues}->[$_]->{value}    for (0 .. $#m_headers);
                \%item;
            } @{ $data->{rows} }
        ],
        (
            $MT::DebugMode
            ? (debug => { query => $params, rawData => $data },)
            : ()) };
}

sub pageviews_for_path {
    my $self = shift;
    my ($app, $params) = @_;

    $self->_request(
        $app,
        {
            dimensions => $app->param('uniquePath')
            ? [{ name => 'pagePath' }]
            : [
                { name => 'pagePath' },
                { name => 'pageTitle' }
            ],
            metrics  => [{ name => 'screenPageViews' }],
            orderBys => [{
                desc   => \1,
                metric => { metricName => 'screenPageViews' }
            }],
            _extract_default_params($params),
        });
}

sub screenpageviews_for_path { pageviews_for_path(@_) }

sub visits_for_path {
    my $self = shift;
    my ($app, $params) = @_;

    $self->_request(
        $app,
        {
            dimensions => $app->param('uniquePath')
            ? [{ name => 'pagePath' }]
            : [
                { name => 'pagePath' },
                { name => 'pageTitle' }
            ],
            metrics  => [{ name => 'sessions' }],
            orderBys => [{
                desc   => \1,
                metric => { metricName => 'sessions' }
            }],
            _extract_default_params($params),
        });
}

sub sessions_for_path { visits_for_path(@_) }

sub _get_statistics_by_dimension_and_metric {
    my $self = shift;
    my ($app, $params, $dimension, $metric) = @_;

    $self->_request(
        $app,
        {
            dimensions => [{ name      => $dimension }],
            metrics    => [{ name      => $metric }],
            orderBys   => [{ dimension => { dimensionName => $dimension } }],
            _extract_default_params($params),
        });
}

sub pageviews_for_date { screenpageviews_for_date(@_) }

sub screenpageviews_for_date {
    my $self = shift;
    my ($app, $params) = @_;
    $self->_get_statistics_by_dimension_and_metric($app, $params, 'date', 'screenPageViews');
}

sub screenpageviews_for_yearweek {
    my $self = shift;
    my ($app, $params) = @_;
    $self->_get_statistics_by_dimension_and_metric($app, $params, 'yearWeek', 'screenPageViews');
}

sub screenpageviews_for_yearmonth {
    my $self = shift;
    my ($app, $params) = @_;
    $self->_get_statistics_by_dimension_and_metric($app, $params, 'yearMonth', 'screenPageViews');
}

sub screenpageviews_for_year {
    my $self = shift;
    my ($app, $params) = @_;
    $self->_get_statistics_by_dimension_and_metric($app, $params, 'year', 'screenPageViews');
}

sub visits_for_date { sessions_for_date(@_) }

sub sessions_for_date {
    my $self = shift;
    my ($app, $params) = @_;
    $self->_get_statistics_by_dimension_and_metric($app, $params, 'date', 'sessions');
}

sub sessions_for_yearweek {
    my $self = shift;
    my ($app, $params) = @_;
    $self->_get_statistics_by_dimension_and_metric($app, $params, 'yearWeek', 'sessions');
}

sub sessions_for_yearmonth {
    my $self = shift;
    my ($app, $params) = @_;
    $self->_get_statistics_by_dimension_and_metric($app, $params, 'yearMonth', 'sessions');
}

sub sessions_for_year {
    my $self = shift;
    my ($app, $params) = @_;
    $self->_get_statistics_by_dimension_and_metric($app, $params, 'year', 'sessions');
}

sub path_key { 'pagePath' }

sub metric_spec_for_pageviews {
    return {
        screenPageViews => {
            type        => 'integer',
            description => 'The sum total of the screenPageViews in the specified period.',
        },
    };
}

sub metric_spec_for_visits {
    return {
        sessions => {
            type        => 'integer',
            description => 'The sum total of the sessions in the specified period.',
        },
    };
}

sub fields_for_statistics_date {
    return [{
            name   => 'date',
            schema => {
                type        => 'string',
                format      => 'date',
                description => 'The date of the target. The format is "YYYY-MM-DD".',
            },
        },
        {
            name   => 'screenPageViews',
            schema => {
                type        => 'integer',
                description => 'The number of screenPageViews for the path. This property exists only if the metrics to retrieve is "screenPageViews"',
            },
        },
        {
            name   => 'sessions',
            schema => {
                type        => 'integer',
                description => 'The number of sessions for the path. This property exists only if the metrics to retrieve is "sessions"',

            },
        },
    ];
}

sub fields_for_statistics_yearweek {
    return [{
            name   => 'yearWeek',
            schema => {
                type        => 'string',
                description => 'The year and week of the target. The format is "YYYY-Www".',
            },
        },
        {
            name   => 'screenPageViews',
            schema => {
                type        => 'integer',
                description => 'The number of screenPageViews for the path. This property exists only if the metrics to retrieve is "screenPageViews"',
            },
        },
        {
            name   => 'sessions',
            schema => {
                type        => 'integer',
                description => 'The number of sessions for the path. This property exists only if the metrics to retrieve is "sessions"',

            },
        },
    ];
}

sub fields_for_statistics_yearmonth {
    return [{
            name   => 'yearMonth',
            schema => {
                type        => 'string',
                description => 'The year and month of the target. The format is "YYYY-MM".',
            },
        },
        {
            name   => 'screenPageViews',
            schema => {
                type        => 'integer',
                description => 'The number of screenPageViews for the path. This property exists only if the metrics to retrieve is "screenPageViews"',
            },
        },
        {
            name   => 'sessions',
            schema => {
                type        => 'integer',
                description => 'The number of sessions for the path. This property exists only if the metrics to retrieve is "sessions"',

            },
        },
    ];
}

sub fields_for_statistics_year {
    return [{
            name   => 'year',
            schema => {
                type        => 'string',
                description => 'The year of the target. The format is "YYYY".',
            },
        },
        {
            name   => 'screenPageViews',
            schema => {
                type        => 'integer',
                description => 'The number of screenPageViews for the path. This property exists only if the metrics to retrieve is "screenPageViews"',
            },
        },
        {
            name   => 'sessions',
            schema => {
                type        => 'integer',
                description => 'The number of sessions for the path. This property exists only if the metrics to retrieve is "sessions"',

            },
        },
    ];
}

sub fields_for_statistics_path {
    return [{
            name   => 'pagePath',
            schema => {
                type        => 'string',
                description => 'The relative path of the target.',
            },
        },
        {
            name   => 'pageTitle',
            schema => {
                type        => 'string',
                description => 'The title for the path.',
            },
        },
        {
            name   => 'screenPageViews',
            schema => {
                type        => 'integer',
                description => 'The number of screenPageViews for the path. This property exists only if the metrics to retrieve is "screenPageViews"',
            },
        },
        {
            name   => 'sessions',
            schema => {
                type        => 'integer',
                description => 'The number of sessions for the path. This property exists only if the metrics to retrieve is "sessions"',

            },
        },
    ];
}

1;
