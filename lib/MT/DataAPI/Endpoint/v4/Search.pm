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

sub _override_description {
    my ($spec, $name, $description) = @_;

    my ($param) = grep { $_->{name} eq $name } @{ $spec->{parameters} };
    return unless $param;

    $param->{description} = $description;
    return 1;
}

sub search_openapi_spec {
    my $spec = MT::DataAPI::Endpoint::v2::Search::search_openapi_spec;
    $spec->{summary} = 'Searching entries/pages/content data';

    _override_description($spec, 'limit', <<'DESCRIPTION');
Maximum number of entries/pages/content data to retrieve.

**Default**: 20
DESCRIPTION

    _override_description($spec, 'SearchSortBy', <<'DESCRIPTION');
The sort column for the search results. Available values are as follows.

#### created_on

Will sort the entries/pages/content data by the authored on date.

#### title

Will sort the entries/pages/content data by title.
DESCRIPTION

    _override_description($spec, 'SearchResultDisplay', <<'DESCRIPTION');
Defines the sort order search results. Available values are as follows.

#### ascend

will list the entries/pages/content data in chronological order (oldest entry/page/content data at the top)

#### descend

will list the entries/pages/content data in reverse chronological order (newest entry/page/content data at the top).

**Default**: ascend
DESCRIPTION

    _override_description($spec, 'SearchMaxResults', <<'DESCRIPTION');
Maximum number of entries/pages/content data to retrieve.

NOTE: By default, "SearchMaxResults" override is disabled.

**Default**: 20
DESCRIPTION

    push @{ $spec->{parameters} }, ({
            in          => 'query',
            name        => 'cdSearch',
            schema      => { type => 'integer' },
            description => 'If set to 1, searching content data only.',
        },
    );

    $spec->{responses} = {
        200 => {
            description => 'OK',
            content     => {
                'application/json' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            totalResults => {
                                type        => 'integer',
                                description => ' The total number of entries/pages/content data.',
                            },
                            items => {
                                type        => 'array',
                                description => 'An array of Entries/Pages/Content Data resource. ',
                                items       => {
                                    oneOf => [
                                        { '$ref' => '#/components/schemas/entry' },
                                        { '$ref' => '#/components/schemas/page' },
                                        { '$ref' => '#/components/schemas/cd' },
                                    ],
                                }
                            },
                        },
                    },
                },
            },
        },
    };
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

