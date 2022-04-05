# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::Version;

use strict;
use warnings;

sub version_openapi_spec {
    +{
        tags      => ['Common API'],
        summary   => 'Get server API version',
        description => <<'DESCRIPTION',
Retrieves Data API version of the server.

**This endpoint has been available since Movable Type 6.2.4.**

This endpoint does not need /v3 or something API endpoint version identifier.
You can call like: `https://host/path/your-mt-data-api.cgi/version`
DESCRIPTION
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                apiVersion      => { type => 'number', format => 'float' },
                                endpointVersion => { type => 'string' },
                            }
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

MT::DataAPI::Endpoint::Version - Movable Type class for endpoint definitions about version.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
