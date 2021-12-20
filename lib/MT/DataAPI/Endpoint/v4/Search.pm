# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v4::Search;
use strict;
use warnings;

use MT::App::Search;
use MT::App::Search::ContentData;
use MT::DataAPI::Endpoint::v2::Search;

sub search_openapi_spec {
    my $spec = MT::DataAPI::Endpoint::v2::Search::search_openapi_spec;
    push @{ $spec->{parameters} }, ({
            in          => 'query',
            name        => 'class',
            schema      => { type => 'string' },
            description => <<'DESCRIPTION',
Class name of the object to be searched. Available values are as follows.

- entry: Search results will only contain entries.
- page: Search results will only contain pages.
DESCRIPTION
        },
        {
            in          => 'query',
            name        => 'cdSearch',
            schema      => { type => 'integer' },
            description => 'If 1 specified, searching content data only.',
        },
    );
    return $spec;
}

sub search {
    my ( $app, $endpoint ) = @_;

    my $content_data_search = $app->param('cdSearch') ? 1 : 0;
    return MT::DataAPI::Endpoint::v2::Search::search(@_)
        unless $content_data_search;

    my $search = $app->param('search');
    return $app->error(
        $app->translate( 'A parameter "[_1]" is required.', 'search' ) )
        unless defined $search && $search ne '';

    local $app->{mode} = 'default';
    local @MT::App::DataAPI::ISA = ('MT::App::Search::ContentData');

    $app->init_request;
    return $app->error( $app->errstr, 400 ) if $app->errstr;

    $app->param( 'format', 'data_api' );
    local *MT::App::Search::ContentData::renderdata_api
        = \&MT::DataAPI::Endpoint::v2::Search::_renderdata_api;

    my $result = $app->process;
    $app->takedown;
    return unless $result;

    # Output JSON data here.
    # This makes post_run_data_api.search have no data.
    $app->send_http_header( $app->current_format->{mime_type} );
    $app->{no_print_body} = 1;
    $app->print_encode($result);

    return;
}

1;

