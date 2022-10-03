# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::v3;

use warnings;
use strict;

sub endpoints {
    [{
            id              => 'authenticate',
            route           => '/authentication',
            verb            => 'POST',
            version         => 3,
            handler         => '$Core::MT::DataAPI::Endpoint::v3::Auth::authentication',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v3::Auth::authentication_openapi_spec',
            requires_login  => 0,
        },
        {
            id              => 'upload_asset',
            route           => '/assets/upload',
            verb            => 'POST',
            version         => 3,
            handler         => '$Core::MT::DataAPI::Endpoint::v3::Asset::upload',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v3::Asset::upload_openapi_spec',
            default_params  => {
                autoRenameIfExists   => 0,
                normalizeOrientation => 1,
            },
            error_codes => {
                403 => 'Do not have permission to upload.',
            },
        },
        {
            id              => 'upload_asset_for_site',
            route           => '/sites/:site_id/assets/upload',
            verb            => 'POST',
            version         => 3,
            handler         => '$Core::MT::DataAPI::Endpoint::v3::Asset::upload',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v3::Asset::upload_deprecated_openapi_spec',
            default_params  => {
                autoRenameIfExists   => 0,
                normalizeOrientation => 1,
            },
            error_codes => {
                403 => 'Do not have permission to upload.',
            },
        },
        {
            id              => 'create_entry',
            route           => '/sites/:site_id/entries',
            resources       => ['entry'],
            verb            => 'POST',
            version         => 3,
            handler         => '$Core::MT::DataAPI::Endpoint::v3::Entry::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v3::Entry::create_openapi_spec',
            default_params  => { save_revision => 1, },
            error_codes     => {
                403 => 'Do not have permission to create an entry.',
            },
        },
        {
            id              => 'update_entry',
            route           => '/sites/:site_id/entries/:entry_id',
            resources       => ['entry'],
            verb            => 'PUT',
            version         => 3,
            handler         => '$Core::MT::DataAPI::Endpoint::v3::Entry::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v3::Entry::update_openapi_spec',
            default_params  => { save_revision => 1, },
            error_codes     => {
                403 => 'Do not have permission to update an entry.',
            },
        },
        {
            id              => 'create_page',
            route           => '/sites/:site_id/pages',
            resources       => ['page'],
            verb            => 'POST',
            version         => 3,
            handler         => '$Core::MT::DataAPI::Endpoint::v3::Page::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v3::Page::create_openapi_spec',
            default_params  => { save_revision => 1, },
            error_codes     => {
                403 => 'Do not have permission to create a page.',
            },
        },
        {
            id              => 'update_page',
            route           => '/sites/:site_id/pages/:page_id',
            resources       => ['page'],
            verb            => 'PUT',
            version         => 3,
            handler         => '$Core::MT::DataAPI::Endpoint::v3::Page::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v3::Page::update_openapi_spec',
            default_params  => { save_revision => 1, },
            error_codes     => {
                403 => 'Do not have permission to update a page.',
            },
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v3 - Movable Type class for v3 endpoint definition.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
