# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Search;

use strict;
use warnings;

use MT::App::Search;
use MT::DataAPI::Endpoint::Common;

sub search_openapi_spec {
    +{
        tags       => ['Search'],
        summary    => 'Searching entries',
        parameters => [{
                required    => JSON::true,
                in          => 'query',
                name        => 'search',
                schema      => { type => 'string' },
                description => <<'DESCRIPTION',
The search term.

You can specify search term, like [foo], [foo AND bar], 'foo NOT bar'.

Also, you can specify category filter, like [category:foo], [category:"hoge OR 'foo bar'"]

Also, you can specify author filter, like [author:Melody]

Also, you can specify Custom Fields filter, like [field:address:akasaka] in this case, address is basename of Custom Fields. akasaka is filter value.
DESCRIPTION
            },
            {
                in          => 'query',
                name        => 'blog_id',
                schema      => { type => 'integer' },
                description => 'The site ID for search. If you want to specify multiple site ID, you must use IncludeBlogs.',
            },
            {
                in          => 'query',
                name        => 'IncludeBlogs',
                schema      => { type => 'string' },
                description => 'The list of the site ID that will be included in the search it should be separated by comma.',
            },
            {
                in          => 'query',
                name        => 'ExcludeBlogs',
                schema      => { type => 'string' },
                description => 'The list of the site ID will be excluded from the search it should be separated by comma.',
            },
            {
                in          => 'query',
                name        => 'limit',
                schema      => { type => 'integer' },
                description => <<'DESCRIPTION',
Maximum number of entries to retrieve.

**Default**: 20
DESCRIPTION
            },
            {
                in          => 'query',
                name        => 'offset',
                schema      => { type => 'integer' },
                description => <<'DESCRIPTION',
0-indexed offset.

**Default**: 0
DESCRIPTION
            },
            {
                in     => 'query',
                name   => 'SearchSortBy',
                schema => {
                    type => 'string',
                    enum => [
                        'created_on',
                        'title',
                    ],
                },
                description => <<'DESCRIPTION',
The sort column for the search results. Available values are as follows.

#### created_on

Will sort the entries by the authored on date.

#### title

Will sort the entries by title.
DESCRIPTION
            },
            {
                in     => 'query',
                name   => 'SearchResultDisplay',
                schema => {
                    type => 'string',
                    enum => [
                        'ascend',
                        'descend',
                    ],
                    default     => 'ascend',
                },
                description => <<'DESCRIPTION',
Defines the sort order search results. Available values are as follows.

#### ascend

will list the entries in chronological order (oldest entry at the top)

#### descend

will list the entries in reverse chronological order (newest entry at the top).

**Default**: ascend
DESCRIPTION
            },
            {
                in          => 'query',
                name        => 'SearchMaxResults',
                schema      => { type => 'integer' },
                description => <<'DESCRIPTION',
Maximum number of entries to retrieve.

NOTE: By default, "SearchMaxResults" override is disabled.

**Default**: 20
DESCRIPTION
            },
        ],
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                totalResults => {
                                    type        => 'integer',
                                    description => ' The total number of entries.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of Entries resource. ',
                                    items       => {
                                        '$ref' => '#/components/schemas/entry',
                                    }
                                },
                            },
                        },
                    },
                },
            },
        },
    };
}

sub search {
    my ( $app, $endpoint ) = @_;

    my $tag_search = $app->param('tagSearch') ? 1 : 0;

    local $app->{mode} = $tag_search ? 'tag' : 'default';

    # Check "search" parameter.
    my $search;
    if ($tag_search) {
        $search = $app->param('tag') || $app->param('search');
    }
    else {
        $search = $app->param('search');
    }
    if ( !( defined $search && $search ne '' ) ) {
        return $app->error(
            $app->translate(
                'A parameter "[_1]" is required.',
                ( $tag_search ? 'tag' : 'search' )
            ),
            400
        );
    }

    my $search_class
        = $app->param('freeText')
        ? 'MT::App::Search::FreeText'
        : 'MT::App::Search';
    local @MT::App::DataAPI::ISA = ($search_class);

    MT::App::Search::init_request($app);
    return $app->error( $app->errstr, 400 ) if $app->errstr;

    $app->param( 'format', 'data_api' );
    local *MT::App::Search::renderdata_api = \&_renderdata_api;

    my $result;
    if ($tag_search) {
        require MT::App::Search::TagSearch;
        $result = MT::App::Search::TagSearch::process($app);
    }
    else {
        $result = MT::App::Search::process($app);
    }

    MT::App::Search::takedown($app);

    return if !$result;

    # Output JSON data here.
    # This makes post_run_data_api.search have no data.
    $app->send_http_header( $app->current_format->{mime_type} );
    $app->{no_print_body} = 1;
    $app->print_encode($result);

    return;
}

sub _renderdata_api {
    my $app = shift;
    my ( $count, $iter ) = @_;

    my @objects;
    if ($iter) {
        while ( my $obj = $iter->() ) {
            push @objects, $obj;
        }
    }

    require MT::DataAPI::Resource;
    my $result = {
        totalResults => $count + 0,
        items => MT::DataAPI::Resource->from_object( \@objects ),
    };

    my $json = $app->current_format->{serialize}->($result);
    return $json;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Search - Movable Type class for endpoint definitions about the MT::App::Search.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
