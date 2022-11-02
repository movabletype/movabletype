# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v5::Entry;

use strict;
use warnings;

sub list_openapi_spec {
    +{
        tags        => ['Entries'],
        summary     => 'Retrieve a list of entries',
        description => <<'DESCRIPTION',
Retrieve a list of entries.

Authorization is required to include unpublished entries.
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/entry_search' },
            { '$ref' => '#/components/parameters/entry_searchFields' },
            { '$ref' => '#/components/parameters/entry_status' },
            { '$ref' => '#/components/parameters/entry_limit' },
            { '$ref' => '#/components/parameters/entry_offset' },
            { '$ref' => '#/components/parameters/entry_includeIds' },
            { '$ref' => '#/components/parameters/entry_excludeIds' },
            { '$ref' => '#/components/parameters/entry_sortBy' },
            { '$ref' => '#/components/parameters/entry_sortOrder' },
            { '$ref' => '#/components/parameters/entry_maxComments' },
            { '$ref' => '#/components/parameters/entry_maxTrackbacks' },
            { '$ref' => '#/components/parameters/entry_fields' },
            { '$ref' => '#/components/parameters/entry_no_text_filter' },
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
                                    description => 'An array of Entries resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/entry',
                                    }
                                },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Not Found',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v5::Entry - Movable Type class for endpoint definitions about the MT::Entry.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
