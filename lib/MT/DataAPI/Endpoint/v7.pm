# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::v7;

use warnings;
use strict;

sub endpoints {
    [
        {
            id              => 'export_site_theme',
            route           => '/sites/:site_id/export_theme',
            verb            => 'POST',
            version         => 7,
            handler         => '$Core::MT::DataAPI::Endpoint::v7::Theme::export',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v7::Theme::export_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to export the requested theme.',
            },
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v7 - Movable Type class for v6 endpoint definition.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut

