# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v6::Stats;

use strict;
use warnings;

use URI;
use MT::Stats qw(readied_provider);
use MT::DataAPI::Endpoint::v1::Stats;
use MT::DataAPI::Resource;

sub _invoke {
    my ( $app, $endpoint ) = @_;

    ( my $method = ( caller 1 )[3] ) =~ s/.*:://;

    my $provider = readied_provider( $app, $app->blog )
        or return $app->error( 'Readied provider is not found', 404 );

    my $params = {
        startDate => scalar( $app->param('startDate') ),
        endDate   => scalar( $app->param('endDate') ),
        limit     => scalar( $app->param('limit') || 50 ),
        offset    => scalar( $app->param('offset') ),
    };

    return
        unless $app->has_valid_limit_and_offset( $params->{limit},
        $params->{offset} );

    $params->{path} = do {
        if ( defined( my $path = $app->param('path') ) ) {
            $path;
        }
        else {
            URI->new( $app->blog->site_url )->path;
        }
    };

    $provider->$method( $app, $params );
}

sub pageviews_for_path_openapi_spec {
    my $spec = MT::DataAPI::Endpoint::v1::Stats::pageviews_for_path_openapi_spec();
    $spec->{parameters}[2]{schema} = { type => 'integer', default => 50 };
    $spec->{parameters}[2]{description} = 'This is an optional parameter. Maximum number of paths to retrieve. Default is 50.';
    return $spec;
}

sub pageviews_for_path {
    my ( $app, $endpoint ) = @_;
    _maybe_raw( MT::DataAPI::Endpoint::v1::Stats::fill_in_archive_info( _invoke(@_), $app->blog ) );
}

sub visits_for_path_openapi_spec {
    my $spec = MT::DataAPI::Endpoint::v1::Stats::visits_for_path_openapi_spec();
    $spec->{parameters}[2]{schema} = { type => 'integer', default => 50 };
    $spec->{parameters}[2]{description} = 'This is an optional parameter. Maximum number of paths to retrieve. Default is 50.';
    return $spec;
}

sub visits_for_path {
    my ( $app, $endpoint ) = @_;
    _maybe_raw( MT::DataAPI::Endpoint::v1::Stats::fill_in_archive_info( _invoke(@_), $app->blog ) );
}

sub pageviews_for_date_openapi_spec {
    my $spec = MT::DataAPI::Endpoint::v1::Stats::pageviews_for_date_openapi_spec();
    $spec->{parameters}[2]{schema} = { type => 'integer', default => 50 };
    $spec->{parameters}[2]{description} = 'This is an optional parameter. Maximum number of paths to retrieve. Default is 50.';
    return $spec;
}

sub pageviews_for_date {
    _maybe_raw( _invoke(@_) );
}

sub visits_for_date_openapi_spec {
    my $spec = MT::DataAPI::Endpoint::v1::Stats::visits_for_date_openapi_spec();
    $spec->{parameters}[2]{schema} = { type => 'integer', default => 50 };
    $spec->{parameters}[2]{description} = 'This is an optional parameter. Maximum number of paths to retrieve. Default is 50.';
    return $spec;
}

sub visits_for_date {
    _maybe_raw( _invoke(@_) );
}

sub _maybe_raw {
    $_[0] ? MT::DataAPI::Resource::Type::Raw->new( $_[0] ) : ();
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v6::Stats - Movable Type class for endpoint definitions about access stats.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
