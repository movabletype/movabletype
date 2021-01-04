# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package GoogleAnalytics::Provider;

use strict;
use warnings;

use base qw(MT::Stats::Provider);

use HTTP::Request::Common;
use GoogleAnalytics;
use GoogleAnalytics::OAuth2 qw(effective_token);

sub is_ready {
    my $class = shift;
    my ( $app, $blog ) = @_;
    GoogleAnalytics::current_plugindata(@_) ? 1 : 0;
}

sub snipet {
    my $self = shift;
    my ( $ctx, $args ) = @_;
    my $app = MT->instance;
    my $plugindata = GoogleAnalytics::current_plugindata( $app, $self->blog )
        or return q();

    if($args->{gtag}){
        return <<__HTML__;
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=@{[ $plugindata->data->{profile_web_property_id} ]}"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', '@{[ $plugindata->data->{profile_web_property_id} ]}');
</script>
__HTML__
    }

    return <<__HTML__;
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', '@{[ $plugindata->data->{profile_web_property_id} ]}']);
  _gaq.push(['_trackPageview']);
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>
__HTML__
}

sub _name {
    my %aliases = qw(
        pagepath path
        pagetitle title
    );

    ( my $n = lc( $_[0] ) ) =~ s/\Aga://;
    $aliases{$n} || $n;
}

sub _normalize_date {
    my ($str) = @_;
    if ( $str =~ m/(\d+)\D+(\d+)\D+(\d+)/ ) {
        sprintf( '%04d-%02d-%02d', $1, $2, $3 );
    }
    else {
        $str;
    }
}

sub _extract_default_params {
    my ($params) = @_;

    (   'start-date'  => _normalize_date( $params->{startDate} ),
        'end-date'    => _normalize_date( $params->{endDate} ),
        'start-index' => ( $params->{offset} || 0 ) + 1,
        (   defined( $params->{limit} )
            ? ( 'max-results' => $params->{limit} )
            : ()
        ),
        (   $params->{path} ? ( filters => 'ga:pagePath=~' . $params->{path} )
            : ()
        ),
    );
}

sub _request {
    my $self = shift;
    my ( $app, $params, $retry_count ) = @_;

    require GoogleAnalytics::OAuth2;
    my $plugindata = GoogleAnalytics::current_plugindata( $app, $self->blog );
    my $token = effective_token( $app, $plugindata )
        or return;

    my $config = $plugindata->data;
    $params->{ids} = 'ga:' . $config->{profile_id};

    my $uri = URI->new('https://www.googleapis.com/analytics/v3/data/ga');
    $uri->query_form($params);

    my $ua  = new_ua();
    my $res = $ua->request(
        GET($uri,
            Authorization =>
                "$token->{data}{token_type} $token->{data}{access_token}"
        )
    );

    if ( $res->code == 401 && !$retry_count ) {
        return $self->_request( @_, 1 );
    }

    return $app->error(
        translate(
            'An error occurred when retrieving statistics data: [_1]: [_2]',
            GoogleAnalytics::extract_response_error($res)
        ),
        500
    ) unless $res->is_success;

    my $data
        = MT::Util::from_json( Encode::decode( 'utf-8', $res->content ) );

    my @headers = map { _name( $_->{name} ) } @{ $data->{columnHeaders} };
    my $date_index = undef;
    for ( my $i = 0; $i <= $#headers; $i++ ) {
        if ( $headers[$i] eq 'date' ) {
            $date_index = $i;
            last;
        }
    }

    +{  totalResults => $data->{totalResults},
        totals       => {
            map { _name($_) => $data->{totalsForAllResults}{$_} }
                keys %{ $data->{totalsForAllResults} }
        },
        items => [
            map {
                my @row = @$_;
                if ( defined($date_index) ) {
                    $row[$date_index] =~ s/(\d{4})(\d{2})/$1-$2-/;
                }
                +{ map { $headers[$_] => $row[$_], } ( 0 .. $#headers ) }
            } @{ $data->{rows} }
        ],
        (   $MT::DebugMode
            ? ( debug => { query => $params, rawData => $data }, )
            : ()
        )
    };
}

sub pageviews_for_path {
    my $self = shift;
    my ( $app, $params ) = @_;

    $self->_request(
        $app,
        {   dimensions => $app->param('uniquePath')
            ? 'ga:pagePath'
            : 'ga:pagePath,ga:pageTitle',
            metrics => 'ga:Pageviews',
            sort    => '-ga:Pageviews',
            _extract_default_params($params),
        }
    );
}

sub visits_for_path {
    my $self = shift;
    my ( $app, $params ) = @_;

    $self->_request(
        $app,
        {   dimensions => $app->param('uniquePath')
            ? 'ga:pagePath'
            : 'ga:pagePath,ga:pageTitle',
            metrics => 'ga:visits',
            sort    => '-ga:visits',
            _extract_default_params($params),
        }
    );
}

sub pageviews_for_date {
    my $self = shift;
    my ( $app, $params ) = @_;

    $self->_request(
        $app,
        {   dimensions => 'ga:date',
            metrics    => 'ga:Pageviews',
            sort       => 'ga:date',
            _extract_default_params($params),
        }
    );
}

sub visits_for_date {
    my $self = shift;
    my ( $app, $params ) = @_;

    $self->_request(
        $app,
        {   dimensions => 'ga:date',
            metrics    => 'ga:visits',
            sort       => 'ga:date',
            _extract_default_params($params),
        }
    );
}

1;

=head1 NAME

GoogleAnalytics::Provider - An implementation class of L<MT::Stats::Provider> for Google Analytics.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
