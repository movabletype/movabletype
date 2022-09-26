# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v5::ContentData;
use strict;
use warnings;

use MT::ContentStatus;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;
use MT::Util qw( archive_file_for );

sub list_openapi_spec {
    +{
        tags        => ['Content Types', 'Content Data'],
        summary     => 'Content Data Collection',
        description => <<'DESCRIPTION',
Retrieve list of content data of specified content type in the specified site.

Authentication required if you want to retrieve unpublished content data. Required pemissions are as follows.

- Manage Content Data (site, system, each content type)
- Publish Content Data (each content type)
- Edit All Content Data (each content type)
DESCRIPTION
        parameters => [
            { '$ref' => '#/components/parameters/content_data_limit' },
            { '$ref' => '#/components/parameters/content_data_offset' },
            {
                in     => 'query',
                name   => 'sortBy',
                schema => {
                    type => 'string',
                    enum => [
                        'id',
                        'uniqueID',
                        'authored_on',
                        'created_on',
                        'modified_on',
                    ],
                    default => 'id',
                },
                description => <<'DESCRIPTION',
The field name for sort. You can specify one of following values.
- id
- uniqueID
- authored_on
- created_on
- modified_on
DESCRIPTION
            },
            { '$ref' => '#/components/parameters/content_data_sortOrder' },
            { '$ref' => '#/components/parameters/content_data_fields' },
            { '$ref' => '#/components/parameters/content_data_includeIds' },
            { '$ref' => '#/components/parameters/content_data_excludeIds' },
            { '$ref' => '#/components/parameters/entry_no_text_filter' },
        ],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                totalResults => {
                                    type => 'integer',
                                },
                                items => {
                                    type  => 'array',
                                    items => {
                                        '$ref' => '#/components/schemas/cd',
                                    }
                                },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Content_type not found.',
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

