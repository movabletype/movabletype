# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::v1;

use warnings;
use strict;

sub endpoints {
    [{
            id              => 'authorize',
            route           => '/authorization',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Auth::authorization',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Auth::authorization_openapi_spec',
            format          => 'html',
            requires_login  => 0,
        },
        {
            id              => 'authenticate',
            route           => '/authentication',
            verb            => 'POST',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Auth::authentication',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Auth::authentication_openapi_spec',
            requires_login  => 0,
        },
        {
            id              => 'get_token',
            route           => '/token',
            verb            => 'POST',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Auth::token',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Auth::token_openapi_spec',
            openapi_options => {
                can_use_session_id => 1,
            },
            requires_login => 0,
        },
        {
            id              => 'revoke_authentication',
            route           => '/authentication',
            verb            => 'DELETE',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Auth::revoke_authentication',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Auth::revoke_authentication_openapi_spec',
            openapi_options => {
                can_use_session_id => 1,
            },
            requires_login => 0,
        },
        {
            id              => 'revoke_token',
            route           => '/token',
            verb            => 'DELETE',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Auth::revoke_token',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Auth::revoke_token_openapi_spec',
        },
        {
            id              => 'get_user',
            route           => '/users/:user_id',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::User::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::User::get_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested user.',
            },
            requires_login => 0,
        },
        {
            id              => 'update_user',
            route           => '/users/:user_id',
            resources       => ['user'],
            verb            => 'PUT',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::User::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::User::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update the requested user.',
            },
        },
        {
            id              => 'list_blogs_for_user',
            route           => '/users/:user_id/sites',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Blog::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Blog::list_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'site,sites',
            },
            default_params => {
                limit     => 25,
                offset    => 0,
                sortBy    => 'name',
                sortOrder => 'ascend',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of blogs.',
            },
            requires_login => 0,
        },
        {
            id              => 'get_blog',
            route           => '/sites/:site_id',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Blog::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Blog::get_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested blog.',
            },
            requires_login => 0,
        },
        {
            id              => 'list_entries',
            route           => '/sites/:site_id/entries',
            verb            => 'GET',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Entry::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Entry::list_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'entry,entries',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'authored_on',
                sortOrder    => 'descend',
                searchFields => 'title,body,more,keywords,excerpt,basename',
                filterKeys   => 'status',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested entries.',
            },
            requires_login => 0,
        },
        {
            id              => 'create_entry',
            route           => '/sites/:site_id/entries',
            resources       => ['entry'],
            verb            => 'POST',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Entry::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Entry::create_openapi_spec',
            default_params  => { save_revision => 1, },
            error_codes     => {
                403 => 'Do not have permission to create an entry.',
            },
        },
        {
            id              => 'get_entry',
            route           => '/sites/:site_id/entries/:entry_id',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Entry::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Entry::get_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested entry.',
            },
            requires_login => 0,
        },
        {
            id              => 'update_entry',
            route           => '/sites/:site_id/entries/:entry_id',
            resources       => ['entry'],
            verb            => 'PUT',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Entry::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Entry::update_openapi_spec',
            default_params  => { save_revision => 1, },
            error_codes     => {
                403 => 'Do not have permission to update an entry.',
            },
        },
        {
            id              => 'delete_entry',
            route           => '/sites/:site_id/entries/:entry_id',
            verb            => 'DELETE',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Entry::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Entry::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete an entry.',
            },
        },
        {
            id              => 'list_categories',
            route           => '/sites/:site_id/categories',
            verb            => 'GET',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Category::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Category::list_openapi_spec',
            default_params  => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'user_custom',
                sortOrder    => 'ascend',
                searchFields => 'label,basename',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of categories.',
            },
            requires_login => 0,
        },
        {
            id              => 'upload_asset',
            route           => '/sites/:site_id/assets/upload',
            verb            => 'POST',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Asset::upload',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Asset::upload_openapi_spec',
            default_params  => {
                autoRenameIfExists   => 0,
                normalizeOrientation => 1,
            },
            error_codes => {
                403 => 'Do not have permission to upload.',
            },
        },
        {
            id              => 'list_permissions_for_user',
            route           => '/users/:user_id/permissions',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Permission::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Permission::list_openapi_spec',
            default_params  => {
                limit      => 25,
                offset     => 0,
                sortBy     => 'blog_id',
                sortOrder  => 'ascend',
                filterKeys => 'blogIds',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested user\'s permissions.',
            },
        },
        {
            id              => 'publish_entries',
            route           => '/publish/entries',
            verb            => 'GET',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Publish::entries',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Publish::entries_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to publish.',
            },
        },
        {
            id              => 'get_stats_provider',
            route           => '/sites/:site_id/stats/provider',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Stats::provider',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Stats::provider_openapi_spec',
        },
        {
            id              => 'list_stats_pageviews_for_path',
            route           => '/sites/:site_id/stats/path/pageviews',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Stats::pageviews_for_path',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Stats::pageviews_for_path_openapi_spec',
        },
        {
            id              => 'list_stats_visits_for_path',
            route           => '/sites/:site_id/stats/path/visits',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Stats::visits_for_path',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Stats::visits_for_path_openapi_spec',
        },
        {
            id              => 'list_stats_pageviews_for_date',
            route           => '/sites/:site_id/stats/date/pageviews',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Stats::pageviews_for_date',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Stats::pageviews_for_date_openapi_spec',
        },
        {
            id              => 'list_stats_visits_for_date',
            route           => '/sites/:site_id/stats/date/visits',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Stats::visits_for_date',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Stats::visits_for_date_openapi_spec',
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v1 - Movable Type class for v1 endpoint definition.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
