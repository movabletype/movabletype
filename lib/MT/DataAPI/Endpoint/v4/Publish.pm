# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v4::Publish;
use strict;
use warnings;

use MT::App::CMS;
use MT::DataAPI::Endpoint::v1::Publish;

sub content_data_openapi_spec {
    +{
        tags        => ['Content Data', 'Publish'],
        summary     => 'Publish Content Data',
        description => <<'DESCRIPTION',
**Authentication Required** Publish content data. This endpoint requires following permissions.

- Manage Content Data (site, sistem, each content type)
- Edit All Content Data (each content type)
DESCRIPTION
        parameters => [{
                in          => 'query',
                name        => 'blogId',
                schema      => { type => 'integer' },
                description => 'Target site ID. Either blogID or blogIds must be specified.',
            },
            {
                in          => 'query',
                name        => 'blogIds',
                schema      => { type => 'string' },
                description => 'The comma separated site ID list. Either blogID or blogIds must be specified.',
            },
            {
                in          => 'query',
                name        => 'ids',
                schema      => { type => 'string' },
                description => 'The comma separated content data ID list. You should specifiy this parameter to next call if this endpoint returns ‘Rebuilding’ status and you want to continue to publish.',
            },
            {
                in          => 'query',
                name        => 'startTime',
                schema      => { type => 'string' },
                description => 'The string of build start time. You should specifiy this parameter to next call if this endpoint returns ‘Rebuilding’ status and you want to continue to publish.',
            },
        ],
        responses => {
            200 => {
                description => 'No Errors',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                status => {
                                    type        => 'string',
                                    description => '"The result status of this call. `Rebuilding`: It means that there is still content that needs to be rebuilt. / `Complete`: Publishing process has been finished.',
                                },
                                startTime => {
                                    type        => 'string',
                                    description => "The string of build start time. You should specifiy this parameter to next call if this endpoint returns 'Rebuilding' status and you want to continue to publish.",
                                },
                                restIds => {
                                    type          => 'string',
                                    'description' => "The comma separated content data ID list. You should specifiy this parameter to next call if this endpoint returns 'Rebuilding' status and you want to continue to publish.",
                                },
                            },
                        },
                    },
                },
            },
        },
    };
}

sub content_data {
    my ( $app, $endpoint ) = @_;
    MT::DataAPI::Endpoint::v1::Publish::publish_common( $app, $endpoint,
        \&MT::App::CMS::rebuild_these_content_data );
}

1;

