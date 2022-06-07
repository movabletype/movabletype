# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::App::DataAPI;

use strict;
use warnings;
use base qw( MT::App );

use MT::DataAPI::Resource;
use MT::DataAPI::Format;
use MT::App::CMS;
use MT::App::CMS::Common;
use MT::App::Search;
use MT::App::Search::Common;
use MT::AccessToken;

our %endpoints = ();
our %schemas   = ();

sub id                 {'data_api'}
sub DEFAULT_VERSION () {4}
sub API_VERSION ()     {4.1}

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->{template_dir} = 'data_api';
    $app->{default_mode} = 'api';
    $app;
}

sub core_methods {
    my $app = shift;
    return { 'api' => \&api, };
}

sub core_endpoints {
    my $app = shift;
    return [{
            id              => 'openapi',
            route           => '/',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::OpenAPI::build_schema',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::OpenAPI::openapi_spec',
            requires_login  => 0,
        },
        {
            id              => 'version',
            route           => '/version',
            version         => 1,
            requires_login  => 0,
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Version::version_openapi_spec',
        },
        # version 1
        {
            id              => 'list_endpoints',
            route           => '/endpoints',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::Util::endpoints',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Util::endpoints_openapi_spec',
            requires_login  => 0,
        },
        {
            id              => 'authorize',
            route           => '/authorization',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::Auth::authorization',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Auth::authorization_openapi_spec',
            format          => 'html',
            requires_login  => 0,
        },
        {
            id              => 'authenticate',
            route           => '/authentication',
            verb            => 'POST',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::Auth::authentication',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Auth::authentication_openapi_spec',
            requires_login  => 0,
        },
        {
            id              => 'get_token',
            route           => '/token',
            verb            => 'POST',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::Auth::token',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Auth::token_openapi_spec',
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
            handler         => '$Core::MT::DataAPI::Endpoint::Auth::revoke_authentication',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Auth::revoke_authentication_openapi_spec',
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
            handler         => '$Core::MT::DataAPI::Endpoint::Auth::revoke_token',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Auth::revoke_token_openapi_spec',
        },
        {
            id              => 'get_user',
            route           => '/users/:user_id',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::User::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::User::get_openapi_spec',
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
            handler         => '$Core::MT::DataAPI::Endpoint::User::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::User::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update the requested user.',
            },
        },
        {
            id              => 'list_blogs_for_user',
            route           => '/users/:user_id/sites',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::Blog::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Blog::list_openapi_spec',
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
            handler         => '$Core::MT::DataAPI::Endpoint::Blog::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Blog::get_openapi_spec',
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
            handler         => '$Core::MT::DataAPI::Endpoint::Entry::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Entry::list_openapi_spec',
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
            handler         => '$Core::MT::DataAPI::Endpoint::Entry::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Entry::create_openapi_spec',
            default_params  => { save_revision => 1, },
            error_codes     => {
                403 => 'Do not have permission to create an entry.',
            },
        },
        {
            id              => 'get_entry',
            route           => '/sites/:site_id/entries/:entry_id',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::Entry::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Entry::get_openapi_spec',
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
            handler         => '$Core::MT::DataAPI::Endpoint::Entry::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Entry::update_openapi_spec',
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
            handler         => '$Core::MT::DataAPI::Endpoint::Entry::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Entry::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete an entry.',
            },
        },
        {
            id              => 'list_categories',
            route           => '/sites/:site_id/categories',
            verb            => 'GET',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::Category::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Category::list_openapi_spec',
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
            handler         => '$Core::MT::DataAPI::Endpoint::Asset::upload',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Asset::upload_openapi_spec',
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
            handler         => '$Core::MT::DataAPI::Endpoint::Permission::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Permission::list_openapi_spec',
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
            handler         => '$Core::MT::DataAPI::Endpoint::Publish::entries',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Publish::entries_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to publish.',
            },
        },
        {
            id              => 'get_stats_provider',
            route           => '/sites/:site_id/stats/provider',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::Stats::provider',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Stats::provider_openapi_spec',
        },
        {
            id              => 'list_stats_pageviews_for_path',
            route           => '/sites/:site_id/stats/path/pageviews',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::Stats::pageviews_for_path',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Stats::pageviews_for_path_openapi_spec',
        },
        {
            id              => 'list_stats_visits_for_path',
            route           => '/sites/:site_id/stats/path/visits',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::Stats::visits_for_path',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Stats::visits_for_path_openapi_spec',
        },
        {
            id              => 'list_stats_pageviews_for_date',
            route           => '/sites/:site_id/stats/date/pageviews',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::Stats::pageviews_for_date',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Stats::pageviews_for_date_openapi_spec',
        },
        {
            id              => 'list_stats_visits_for_date',
            route           => '/sites/:site_id/stats/date/visits',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::Stats::visits_for_date',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Stats::visits_for_date_openapi_spec',
        },

        # version 2
        # category endpoints
        {
            id              => 'list_categories',
            route           => '/sites/:site_id/categories',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Category::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Category::list_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'category,categories',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'user_custom',
                sortOrder    => 'descend',
                searchFields => 'label,basename',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of categories.',
            },
            requires_login => 0,
        },
        {
            id              => 'list_categories_for_entry',
            route           => '/sites/:site_id/entries/:entry_id/categories',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Category::list_for_entry',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Category::list_for_entry_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'category,categories',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'user_custom',
                sortOrder    => 'descend',
                searchFields => 'label,basename',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested categories for entry.',
            },
            requires_login => 0,
        },
        {
            id              => 'list_parent_categories',
            route           => '/sites/:site_id/categories/:category_id/parents',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Category::list_parents',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Category::list_parents_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes     => {
                403 => 'Do not have permission to retrieve the list of categories.',
            },
            requires_login => 0,
        },
        {
            id              => 'list_sibling_categories',
            route           => '/sites/:site_id/categories/:category_id/siblings',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Category::list_siblings',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Category::list_siblings_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'category,categories',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'user_custom',
                sortOrder    => 'descend',
                searchFields => 'label,basename',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of categories.',
            },
            requires_login => 0,
        },
        {
            id              => 'list_child_categories',
            route           => '/sites/:site_id/categories/:category_id/children',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Category::list_children',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Category::list_children_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes     => {
                403 => 'Do not have permission to retrieve the list of categories.',
            },
            requires_login => 0,
        },
        {
            id              => 'create_category',
            route           => '/sites/:site_id/categories',
            resources       => ['category'],
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Category::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Category::create_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to create a category.',
            },
        },
        {
            id              => 'get_category',
            route           => '/sites/:site_id/categories/:category_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Category::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Category::get_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested category.',
            },
            requires_login => 0,
        },
        {
            id              => 'update_category',
            route           => '/sites/:site_id/categories/:category_id',
            resources       => ['category'],
            verb            => 'PUT',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Category::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Category::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update a category.',
            },
        },
        {
            id              => 'delete_category',
            route           => '/sites/:site_id/categories/:category_id',
            verb            => 'DELETE',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Category::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Category::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a category.',
            },
        },
        {
            id              => 'permutate_categories',
            route           => '/sites/:site_id/categories/permutate',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Category::permutate',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Category::permutate_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to permutate categories.',
            },
        },

        # folder endpoints
        {
            id              => 'list_folders',
            route           => '/sites/:site_id/folders',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Folder::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Folder::list_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'folder,folders',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'user_custom',
                sortOrder    => 'ascend',
                searchFields => 'label,basename',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of folders.',
            },
            requires_login => 0,
        },
        {
            id              => 'list_parent_folders',
            route           => '/sites/:site_id/folders/:folder_id/parents',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Folder::list_parents',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Folder::list_parents_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes     => {
                403 => 'Do not have permission to retrieve the list of folders.',
            },
            requires_login => 0,
        },
        {
            id              => 'list_sibling_folders',
            route           => '/sites/:site_id/folders/:folder_id/siblings',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Folder::list_siblings',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Folder::list_siblings_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'folder,folders',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'user_custom',
                sortOrder    => 'ascend',
                searchFields => 'label,basename',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of folders.',
            },
            requires_login => 0,
        },
        {
            id              => 'list_child_folders',
            route           => '/sites/:site_id/folders/:folder_id/children',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Folder::list_children',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Folder::list_children_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes     => {
                403 => 'Do not have permission to retrieve the list of folders.',
            },
            requires_login => 0,
        },
        {
            id              => 'create_folder',
            route           => '/sites/:site_id/folders',
            resources       => ['folder'],
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Folder::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Folder::create_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to create a folder.',
            },
        },
        {
            id              => 'get_folder',
            route           => '/sites/:site_id/folders/:folder_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Folder::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Folder::get_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested folder.',
            },
            requires_login => 0,
        },
        {
            id              => 'update_folder',
            route           => '/sites/:site_id/folders/:folder_id',
            resources       => ['folder'],
            verb            => 'PUT',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Folder::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Folder::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update a folder.',
            },
        },
        {
            id              => 'delete_folder',
            route           => '/sites/:site_id/folders/:folder_id',
            verb            => 'DELETE',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Folder::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Folder::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a folder.',
            },
        },
        {
            id              => 'permutate_folders',
            route           => '/sites/:site_id/folders/permutate',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Folder::permutate',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Folder::permutate_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to permutate folders.',
            },
        },

        # asset endpoints
        {
            id              => 'list_assets',
            route           => '/sites/:site_id/assets',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Asset::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Asset::list_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
                filtered_list_ds_nouns => 'asset,assets',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'created_on',
                sortOrder    => 'descend',
                searchFields => 'label',
                filterKeys   => 'class',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested assets.',
            },
            requires_login => 0,
        },

        #        {   id             => 'list_all_assets',
        #            route          => '/assets',
        #            verb           => 'GET',
        #            version        => 2,
        #            handler        => "${pkg}v2::Asset::list",
        #            default_params => {
        #                limit        => 10,
        #                offset       => 0,
        #                sortBy       => 'created_on',
        #                sortOrder    => 'descend',
        #                searchFields => 'label',
        #                filterKeys   => 'class',
        #            },
        #            error_codes => {
        #                403 =>
        #                    'Do not have permission to retrieve the requested assets.',
        #            },
        #            requires_login => 0,
        #        },
        {
            id              => 'list_assets_for_entry',
            route           => '/sites/:site_id/entries/:entry_id/assets',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Asset::list_for_entry',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Asset::list_for_entry_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'asset,assets',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'created_on',
                sortOrder    => 'descend',
                searchFields => 'label',
                filterKeys   => 'class',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested assets for entry.',
            },
            requires_login => 0,
        },
        {
            id              => 'list_assets_for_page',
            route           => '/sites/:site_id/pages/:page_id/assets',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Asset::list_for_page',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Asset::list_for_page_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'asset,assets',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'created_on',
                sortOrder    => 'descend',
                searchFields => 'label',
                filterKeys   => 'class',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested assets for page.',
            },
            requires_login => 0,
        },

        #        {   id             => 'list_assets_for_tag',
        #            route          => '/tags/:tag_id/assets',
        #            version        => 2,
        #            handler        => "${pkg}v2::Asset::list_for_tag",
        #            default_params => {
        #                limit        => 10,
        #                offset       => 0,
        #                sortBy       => 'created_on',
        #                sortOrder    => 'descend',
        #                searchFields => 'label',
        #                filterKeys   => 'class',
        #            },
        #            error_codes => {
        #                403 =>
        #                    'Do not have permission to retrieve the requested assets for tag.',
        #            },
        #            requires_login => 0,
        #        },
        {
            id              => 'list_assets_for_site_and_tag',
            route           => '/sites/:site_id/tags/:tag_id/assets',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Asset::list_for_site_and_tag',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Asset::list_for_site_and_tag_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'asset,assets',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'created_on',
                sortOrder    => 'descend',
                searchFields => 'label',
                filterKeys   => 'class',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested assets for site and tag.',
            },
            requires_login => 0,
        },
        {    # Different from v1 upload_asset endpoint.
            id              => 'upload_asset',
            route           => '/assets/upload',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Asset::upload',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Asset::upload_openapi_spec',
            default_params  => {
                autoRenameIfExists   => 0,
                normalizeOrientation => 1,
            },
            error_codes => {
                403 => 'Do not have permission to upload.',
            },
        },
        {    # Same as v2 upload_asset.
            id              => 'upload_asset_for_site',
            route           => '/sites/:site_id/assets/upload',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::Asset::upload',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Asset::upload_v2_openapi_spec',
            default_params  => {
                autoRenameIfExists   => 0,
                normalizeOrientation => 1,
            },
            error_codes => {
                403 => 'Do not have permission to upload.',
            },
        },
        {
            id              => 'get_asset',
            route           => '/sites/:site_id/assets/:asset_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Asset::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Asset::get_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested asset.',
            },
            requires_login => 0,
        },
        {
            id              => 'update_asset',
            route           => '/sites/:site_id/assets/:asset_id',
            resources       => ['asset'],
            verb            => 'PUT',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Asset::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Asset::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update an asset.',
            },
        },
        {
            id              => 'delete_asset',
            route           => '/sites/:site_id/assets/:asset_id',
            verb            => 'DELETE',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Asset::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Asset::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete an asset.',
            },
        },
        {
            id              => 'get_thumbnail',
            route           => '/sites/:site_id/assets/:asset_id/thumbnail',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Asset::get_thumbnail',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Asset::get_thumbnail_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested thumbnail.',
            },
            requires_login => 0,
        },

        # entry endpoints
        {
            id              => 'list_entries_for_category',
            route           => '/sites/:site_id/categories/:category_id/entries',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Entry::list_for_category',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Entry::list_for_category_openapi_spec',
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
                403 => 'Do not have permission to retrieve the list of entries.',
            },
            requires_login => 0,
        },
        {
            id              => 'list_entries_for_asset',
            route           => '/sites/:site_id/assets/:asset_id/entries',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Entry::list_for_asset',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Entry::list_for_asset_openapi_spec',
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
                403 => 'Do not have permission to retrieve the list of entries.',
            },
            requires_login => 0,
        },

        #        {   id             => 'list_entries_for_tag',
        #            route          => '/tags/:tag_id/entries',
        #            version        => 2,
        #            handler        => "${pkg}v2::Entry::list_for_tag",
        #            default_params => {
        #                limit        => 10,
        #                offset       => 0,
        #                sortBy       => 'authored_on',
        #                sortOrder    => 'descend',
        #                searchFields => 'title,body,more,keywords,excerpt,basename',
        #                filterKeys   => 'status',
        #            },
        #            error_codes => {
        #                403 =>
        #                    'Do not have permission to retrieve the requested entries for tag.',
        #            },
        #            requires_login => 0,
        #        },
        {
            id              => 'list_entries_for_site_and_tag',
            route           => '/sites/:site_id/tags/:tag_id/entries',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Entry::list_for_site_and_tag',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Entry::list_for_site_and_tag_openapi_spec',
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
                403 => 'Do not have permission to retrieve the requested entries for site and tag.',
            },
            requires_login => 0,
        },
        {
            id              => 'create_entry',
            route           => '/sites/:site_id/entries',
            resources       => ['entry'],
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Entry::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Entry::create_openapi_spec',
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
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Entry::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Entry::update_openapi_spec',
            default_params  => { save_revision => 1, },
            error_codes     => {
                403 => 'Do not have permission to update an entry.',
            },
        },
        {
            id              => 'import_entries',
            route           => '/sites/:site_id/entries/import',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Entry::import',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Entry::import_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to import entries.',
            },
        },
        {
            id              => 'export_entries',
            route           => '/sites/:site_id/entries/export',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Entry::export',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Entry::export_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to export entries.',
            },
        },
        {
            id              => 'preview_entry_by_id',
            route           => '/sites/:site_id/entries/:entry_id/preview',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Entry::preview_by_id',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Entry::preview_by_id_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to preview entry.',
            },
        },
        {
            id              => 'preview_entry',
            route           => '/sites/:site_id/entries/preview',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Entry::preview',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Entry::preview_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to preview entry.',
            },
        },

        # page endpoints
        {
            id              => 'list_pages',
            route           => '/sites/:site_id/pages',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Page::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Page::list_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'page,pages',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'modified_on',
                sortOrder    => 'descend',
                searchFields => 'title,body,more,keywords,excerpt,basename',
                filterKeys   => 'status',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested pages.',
            },
            requires_login => 0,
        },
        {
            id              => 'list_pages_for_folder',
            route           => '/sites/:site_id/folders/:folder_id/pages',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Page::list_for_folder',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Page::list_for_folder_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'page,pages',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'modified_on',
                sortOrder    => 'descend',
                searchFields => 'title,body,more,keywords,excerpt,basename',
                filterKeys   => 'status',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested pages.',
            },
            requires_login => 0,
        },
        {
            id              => 'list_pages_for_asset',
            route           => '/sites/:site_id/assets/:asset_id/pages',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Page::list_for_asset',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Page::list_for_asset_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'page,pages',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'modified_on',
                sortOrder    => 'descend',
                searchFields => 'title,body,more,keywords,excerpt,basename',
                filterKeys   => 'status',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested pages.',
            },
            requires_login => 0,
        },

        #        {   id             => 'list_pages_for_tag',
        #            route          => '/tags/:tag_id/pages',
        #            verb           => 'GET',
        #            version        => 2,
        #            handler        => "${pkg}v2::Page::list_for_tag",
        #            default_params => {
        #                limit        => 10,
        #                offset       => 0,
        #                sortBy       => 'modified_on',
        #                sortOrder    => 'descend',
        #                searchFields => 'title,body,more,keywords,excerpt,basename',
        #                filterKeys   => 'status',
        #            },
        #            error_codes => {
        #                403 =>
        #                    'Do not have permission to retrieve the requested pages.',
        #            },
        #            requires_login => 0,
        #        },
        {
            id              => 'list_pages_for_site_and_tag',
            route           => '/sites/:site_id/tags/:tag_id/pages',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Page::list_for_site_and_tag',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Page::list_for_site_and_tag_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'page,pages',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'modified_on',
                sortOrder    => 'descend',
                searchFields => 'title,body,more,keywords,excerpt,basename',
                filterKeys   => 'status',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested pages.',
            },
            requires_login => 0,
        },
        {
            id              => 'create_page',
            route           => '/sites/:site_id/pages',
            resources       => ['page'],
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Page::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Page::create_openapi_spec',
            default_params  => { save_revision => 1, },
            error_codes     => {
                403 => 'Do not have permission to create a page.',
            },
        },
        {
            id              => 'get_page',
            route           => '/sites/:site_id/pages/:page_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Page::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Page::get_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested page.',
            },
            requires_login => 0,
        },
        {
            id              => 'update_page',
            route           => '/sites/:site_id/pages/:page_id',
            resources       => ['page'],
            verb            => 'PUT',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Page::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Page::update_openapi_spec',
            default_params  => { save_revision => 1, },
            error_codes     => {
                403 => 'Do not have permission to update a page.',
            },
        },
        {
            id              => 'delete_page',
            route           => '/sites/:site_id/pages/:page_id',
            verb            => 'DELETE',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Page::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Page::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a page.',
            },
        },
        {
            id              => 'preview_page_by_id',
            route           => '/sites/:site_id/pages/:page_id/preview',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Entry::preview_by_id',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Page::preview_by_id_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to preview page.',
            },
        },
        {
            id              => 'preview_page',
            route           => '/sites/:site_id/pages/preview',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Page::preview',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Page::preview_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to preview page.',
            },
        },

        # site endpoints
        {
            id              => 'list_sites',
            route           => '/sites',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Blog::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Blog::list_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'site,sites',
            },
            default_params => {
                limit        => 25,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of blogs.',
            },
            requires_login => 0,
        },
        {
            id              => 'get_blog',
            route           => '/sites/:site_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::Blog::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Blog::get_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested blog.',
            },
            requires_login => 0,
        },
        {
            id              => 'list_blogs_for_user',
            route           => '/users/:user_id/sites',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::Blog::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Blog::list_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
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
            id              => 'list_sites_by_parent',
            route           => '/sites/:site_id/children',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Blog::list_by_parent',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Blog::list_by_parent_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'site,sites',
            },
            default_params => {
                limit        => 25,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of blogs.',
            },
            requires_login => 0,
        },
        {
            id              => 'insert_new_blog',
            route           => '/sites/:site_id',
            resources       => ['blog'],
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Blog::insert_new_blog',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Blog::insert_new_blog_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to create a blog.',
            },
        },
        {
            id              => 'insert_new_website',
            route           => '/sites',
            resources       => ['website'],
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Blog::insert_new_website',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Blog::insert_new_website_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to create a website.',
            },
        },
        {
            id              => 'update_site',
            route           => '/sites/:site_id',
            verb            => 'PUT',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Blog::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Blog::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update a site.',
            },
        },
        {
            id              => 'delete_site',
            route           => '/sites/:site_id',
            verb            => 'DELETE',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Blog::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Blog::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a site.',
            },
        },

        # role endpoints
        {
            id              => 'list_roles',
            route           => '/roles',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Role::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Role::list_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'role,roles',
            },
            default_params => {
                limit        => 25,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name,description',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of roles.',
            },
        },
        {
            id              => 'create_role',
            route           => '/roles',
            resources       => ['role'],
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Role::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Role::create_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to create a role.',
            },
        },
        {
            id              => 'get_role',
            route           => '/roles/:role_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Role::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Role::get_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested role.',
            },
        },
        {
            id              => 'update_role',
            route           => '/roles/:role_id',
            resources       => ['role'],
            verb            => 'PUT',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Role::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Role::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update a role.',
            },
        },
        {
            id              => 'delete_role',
            route           => '/roles/:role_id',
            verb            => 'DELETE',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Role::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Role::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a role.',
            },
        },

        # permission endpoints
        {
            id              => 'list_permissions',
            route           => '/permissions',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Permission::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Permission::list_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'permission,permissions',
            },
            default_params => {
                limit      => 25,
                offset     => 0,
                sortBy     => 'blog_id',
                sortOrder  => 'ascend',
                filterKeys => 'blogIds',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of permissions.',
            },
        },
        {
            # update
            id              => 'list_permissions_for_user',
            route           => '/users/:user_id/permissions',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Permission::list_for_user',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Permission::list_for_user_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'permission,permissions',
            },
            default_params => {
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
            id              => 'list_permissions_for_site',
            route           => '/sites/:site_id/permissions',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Permission::list_for_site',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Permission::list_for_site_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'permission,permissions',
            },
            default_params => {
                limit     => 25,
                offset    => 0,
                sortBy    => 'id',
                sortOrder => 'ascend',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of permissions.',
            },
        },
        {
            id              => 'list_permissions_for_role',
            route           => '/roles/:role_id/permissions',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Permission::list_for_role',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Permission::list_for_role_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'permission,permissions',
            },
            default_params => {
                limit      => 25,
                offset     => 0,
                sortBy     => 'blog_id',
                sortOrder  => 'ascend',
                filterKeys => 'blogIds',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of permissions.',
            },
        },
        {
            id              => 'grant_permission_to_site',
            route           => '/sites/:site_id/permissions/grant',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Permission::grant_to_site',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Permission::grant_to_site_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to grant a permission.',
            },
        },
        {
            id              => 'grant_permission_to_user',
            route           => '/users/:user_id/permissions/grant',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Permission::grant_to_user',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Permission::grant_to_user_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to grant a permission.',
            },
        },
        {
            id              => 'revoke_permission_from_site',
            route           => '/sites/:site_id/permissions/revoke',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Permission::revoke_from_site',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Permission::revoke_from_site_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to revoke a permission.',
            },
        },
        {
            id              => 'revoke_permission_from_user',
            route           => '/users/:user_id/permissions/revoke',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Permission::revoke_from_user',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Permission::revoke_from_user_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to revoke a permission.',
            },
        },

        # search endpoints
        {
            id              => 'search',
            route           => '/search',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Search::search',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Search::search_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes     => {
                403 => 'Do not have permission to search objects.',
            },
            requires_login => 0,
        },

        # log endpoints
        {
            id              => 'list_logs',
            route           => '/sites/:site_id/logs',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Log::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Log::list_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'log,logs',
            },
            default_params => {
                limit        => 25,
                offset       => 0,
                sortBy       => 'created_on',
                sortOrder    => 'descend',
                searchFields => 'message,ip',
                filterKeys   => 'level',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of activity logs.',
            },
        },
        {
            id              => 'get_log',
            route           => '/sites/:site_id/logs/:log_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Log::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Log::get_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested log.',
            },
        },
        {
            id              => 'create_log',
            route           => '/sites/:site_id/logs',
            resources       => ['log'],
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Log::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Log::create_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to create a log.',
            },
        },
        {
            id              => 'update_log',
            route           => '/sites/:site_id/logs/:log_id',
            resources       => ['log'],
            verb            => 'PUT',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Log::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Log::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update a log.',
            },
        },
        {
            id              => 'delete_log',
            route           => '/sites/:site_id/logs/:log_id',
            verb            => 'DELETE',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Log::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Log::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a log.',
            },
        },
        {
            id              => 'reset_logs',
            route           => '/sites/:site_id/logs',
            verb            => 'DELETE',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Log::reset',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Log::reset_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to reset logs.',
            },
        },
        {
            id              => 'export_logs',
            route           => '/sites/:site_id/logs/export',
            verb            => 'GET',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Log::export',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Log::export_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to export logs.',
            },
        },

        # tag endpoints
        #        {   id             => 'list_tags',
        #            route          => '/tags',
        #            version        => 2,
        #            default_params => {
        #                limit        => 25,
        #                offset       => 0,
        #                sortBy       => 'name',
        #                sortOrder    => 'ascend',
        #                searchFields => 'name',
        #            },
        #            handler     => "${pkg}v2::Tag::list",
        #            error_codes => {
        #                403 => 'Do not have permission to retrieve the list of tags.',
        #            },
        #            requires_login => 0,
        #        },
        {
            id             => 'list_tags_for_site',
            route          => '/sites/:site_id/tags',
            version        => 2,
            default_params => {
                limit        => 25,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name',
            },
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Tag::list_for_site',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Tag::list_for_site_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'tag,tags',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of tags.',
            },
            requires_login => 0,
        },

        #        {   id          => 'get_tag',
        #            route       => '/tags/:tag_id',
        #            version     => 2,
        #            handler     => "${pkg}v2::Tag::get",
        #            error_codes => {
        #                403 =>
        #                    'Do not have permission to retrieve the requested tag.',
        #            },
        #            requires_login => 0,
        #        },
        {
            id              => 'get_tag_for_site',
            route           => '/sites/:site_id/tags/:tag_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Tag::get_for_site',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Tag::get_for_site_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested tag.',
            },
            requires_login => 0,
        },

        #        {   id      => 'rename_tag',
        #            route   => '/tags/:tag_id',
        #            verb    => 'PUT',
        #            version => 2,
        #            handler => "${pkg}v2::Tag::rename",
        #            error_codes =>
        #                { 403 => 'Do not have permission to rename a tag.', },
        #        },
        {
            id              => 'rename_tag_for_site',
            route           => '/sites/:site_id/tags/:tag_id',
            verb            => 'PUT',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Tag::rename_for_site',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Tag::rename_for_site_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to rename a tag.',
            },
        },

        #        {   id      => 'delete_tag',
        #            route   => '/tags/:tag_id',
        #            verb    => 'DELETE',
        #            version => 2,
        #            handler => "${pkg}v2::Tag::delete",
        #            error_codes =>
        #                { 403 => 'Do not have permission to delete a tag.', },
        #        },
        {
            id              => 'delete_tag_for_site',
            route           => '/sites/:site_id/tags/:tag_id',
            verb            => 'DELETE',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Tag::delete_for_site',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Tag::delete_for_site_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a tag.',
            },
        },

        # theme endpoints
        {
            id              => 'list_themes',
            route           => '/themes',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Theme::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Theme::list_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested themes.',
            },
        },
        {
            id              => 'list_themes_for_site',
            route           => '/sites/:site_id/themes',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Theme::list_for_site',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Theme::list_for_site_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested site\'s themes.',
            },
        },
        {
            id              => 'get_theme',
            route           => '/themes/:theme_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Theme::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Theme::get_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested theme.',
            },
        },
        {
            id              => 'get_theme_for_site',
            route           => '/sites/:site_id/themes/:theme_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Theme::get_for_site',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Theme::get_for_site_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested site\'s theme.',
            },
        },
        {
            id              => 'apply_theme_to_site',
            route           => '/sites/:site_id/themes/:theme_id/apply',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Theme::apply',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Theme::apply_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to apply the requested theme to site.',
            },
        },
        {
            id              => 'uninstall_theme',
            route           => '/themes/:theme_id',
            verb            => 'DELETE',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Theme::uninstall',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Theme::uninstall_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to uninstall the requested theme.',
            },
        },
        {
            id              => 'export_site_theme',
            route           => '/sites/:site_id/export_theme',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Theme::export',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Theme::export_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to export the requested theme.',
            },
        },

        # template endpoints
        {
            id              => 'list_templates',
            route           => '/sites/:site_id/templates',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Template::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Template::list_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'template,templates',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name,templateType,text',
                filterKeys   => 'type',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of templates.',
            },
        },

        #        {   id             => 'list_all_templates',
        #            route          => '/templates',
        #            version        => 2,
        #            handler        => "${pkg}v2::Template::list",
        #            default_params => {
        #                limit        => 10,
        #                offset       => 0,
        #                sortBy       => 'blog_id',
        #                sortOrder    => 'ascend',
        #                searchFields => 'name,templateType,text',
        #                filterKeys   => 'type',
        #            },
        #            error_codes => {
        #                403 =>
        #                    'Do not have permission to retrieve the list of templates.',
        #            },
        #        },
        {
            id              => 'get_template',
            route           => '/sites/:site_id/templates/:template_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Template::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Template::get_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested template.',
            },
        },
        {
            id              => 'create_template',
            route           => '/sites/:site_id/templates',
            resources       => ['template'],
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Template::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Template::create_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to create a template.',
            },
        },
        {
            id              => 'update_template',
            route           => '/sites/:site_id/templates/:template_id',
            resources       => ['template'],
            verb            => 'PUT',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Template::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Template::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update a template.',
            },
        },
        {
            id              => 'delete_template',
            route           => '/sites/:site_id/templates/:template_id',
            verb            => 'DELETE',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Template::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Template::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a template.',
            },
        },
        {
            id              => 'publish_template',
            route           => '/sites/:site_id/templates/:template_id/publish',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Template::publish',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Template::publish_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to publish a template.',
            },
        },
        {
            id              => 'refresh_template',
            route           => '/sites/:site_id/templates/:template_id/refresh',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Template::refresh',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Template::refresh_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to refresh a template.',
            },
        },
        {
            id              => 'refresh_templates_for_site',
            route           => '/sites/:site_id/refresh_templates',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Template::refresh_for_site',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Template::refresh_for_site_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to refresh templates of the request site.',
            },
        },
        {
            id              => 'clone_template',
            route           => '/sites/:site_id/templates/:template_id/clone',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Template::clone',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Template::clone_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to clone a template.',
            },
        },
        {
            id              => 'preview_template_by_id',
            route           => '/sites/:site_id/templates/:template_id/preview',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Template::preview_by_id',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Template::preview_by_id_openapi_spec',
            verb            => 'POST',
            error_codes     => {
                403 => 'Do not have permission to get template preview.',
            },
        },
        {
            id              => 'preview_template',
            route           => '/sites/:site_id/templates/preview',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Template::preview',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Template::preview_openapi_spec',
            verb            => 'POST',
            error_codes     => {
                403 => 'Do not have permission to get template preview.',
            },
        },

        # templatemap endpoints
        {
            id              => 'list_templatemaps',
            route           => '/sites/:site_id/templates/:template_id/templatemaps',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::TemplateMap::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::TemplateMap::list_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'templatemap,templatemaps',
            },
            default_params => {
                limit      => 10,
                offset     => 0,
                sortBy     => 'id',
                sortOrder  => 'ascend',
                filterKeys => 'archiveType,buildType,isPreferred',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of templatemaps.',
            },
        },
        {
            id              => 'get_templatemap',
            route           => '/sites/:site_id/templates/:template_id/templatemaps/:templatemap_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::TemplateMap::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::TemplateMap::get_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested templatemap.',
            },
        },
        {
            id              => 'create_templatemap',
            route           => '/sites/:site_id/templates/:template_id/templatemaps',
            resources       => ['templatemap'],
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::TemplateMap::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::TemplateMap::create_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to create a templatemap.',
            },
        },
        {
            id              => 'update_templatemap',
            route           => '/sites/:site_id/templates/:template_id/templatemaps/:templatemap_id',
            resources       => ['templatemap'],
            verb            => 'PUT',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::TemplateMap::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::TemplateMap::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update a templatemap.',
            },
        },
        {
            id              => 'delete_templatemap',
            route           => '/sites/:site_id/templates/:template_id/templatemaps/:templatemap_id',
            verb            => 'DELETE',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::TemplateMap::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::TemplateMap::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a templatemap.',
            },
        },

        # widgetset endpoints.
        {
            id              => 'list_widgetsets',
            route           => '/sites/:site_id/widgetsets',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::WidgetSet::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::WidgetSet::list_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'widgetset,widgetsets',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of widgetsets.',
            },
        },

        #        {   id             => 'list_all_widgetsets',
        #            route          => '/widgetsets',
        #            version        => 2,
        #            handler        => "${pkg}v2::WidgetSet::list_all",
        #            default_params => {
        #                limit        => 10,
        #                offset       => 0,
        #                sortBy       => 'blog_id',
        #                sortOrder    => 'ascend',
        #                searchFields => 'name',
        #            },
        #            error_codes => {
        #                403 =>
        #                    'Do not have permission to retrieve the list of widgetsets.',
        #            },
        #        },
        {
            id              => 'get_widgetset',
            route           => '/sites/:site_id/widgetsets/:widgetset_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::WidgetSet::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::WidgetSet::get_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested widgetset.',
            },
        },
        {
            id              => 'create_widgetset',
            route           => '/sites/:site_id/widgetsets',
            resources       => ['widgetset'],
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::WidgetSet::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::WidgetSet::create_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to create a widgetset.',
            },
        },
        {
            id              => 'update_widgetset',
            route           => '/sites/:site_id/widgetsets/:widgetset_id',
            resources       => ['widgetset'],
            verb            => 'PUT',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::WidgetSet::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::WidgetSet::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update a widgetset.',
            },
        },
        {
            id              => 'delete_widgetset',
            route           => '/sites/:site_id/widgetsets/:widgetset_id',
            verb            => 'DELETE',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::WidgetSet::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::WidgetSet::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a widgetset.',
            },
        },

        # widget endpoints.
        {
            id              => 'list_widgets',
            route           => '/sites/:site_id/widgets',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Widget::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Widget::list_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'widget,widgets',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name,text',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of widgets.',
            },
        },

        #        {   id             => 'list_all_widgets',
        #            route          => '/widgets',
        #            version        => 2,
        #            handler        => "${pkg}v2::Widget::list_all",
        #            default_params => {
        #                limit        => 10,
        #                offset       => 0,
        #                sortBy       => 'blog_id',
        #                sortOrder    => 'ascend',
        #                searchFields => 'name,text',
        #            },
        #            error_codes => {
        #                403 =>
        #                    'Do not have permission to retrieve the list of widgets.',
        #            },
        #        },
        {
            id              => 'list_widgets_for_widgetset',
            route           => '/sites/:site_id/widgetsets/:widgetset_id/widgets',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Widget::list_for_widgetset',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Widget::list_for_widgetset_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'widget,widgets',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name,text',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve widgets of the request widgetset.',
            },
        },
        {
            id              => 'get_widgets',
            route           => '/sites/:site_id/widgets/:widget_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Widget::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Widget::get_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested widget.',
            },
        },
        {
            id              => 'get_widget_for_widgetset',
            route           => '/sites/:site_id/widgetsets/:widgetset_id/widgets/:widget_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Widget::get_for_widgetset',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Widget::get_for_widgetset_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve a widget of the request widgetset.',
            },
        },
        {
            id              => 'create_widget',
            route           => '/sites/:site_id/widgets',
            resources       => ['widget'],
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Widget::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Widget::create_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to create a widget.',
            },
        },
        {
            id              => 'update_widget',
            route           => '/sites/:site_id/widgets/:widget_id',
            resources       => ['widget'],
            verb            => 'PUT',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Widget::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Widget::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update a widget.',
            },
        },
        {
            id              => 'delete_widget',
            route           => '/sites/:site_id/widgets/:widget_id',
            verb            => 'DELETE',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Widget::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Widget::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a widget.',
            },
        },

        {
            id              => 'refresh_widget',
            route           => '/sites/:site_id/widgets/:widget_id/refresh',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Widget::refresh',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Widget::refresh_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to refresh a widget.',
            },
        },
        {
            id              => 'clone_widget',
            route           => '/sites/:site_id/widgets/:widget_id/clone',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Widget::clone',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Widget::clone_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to clone a widget.',
            },
        },

        # user endpoints
        {
            id              => 'list_users',
            route           => '/users',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::User::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::User::list_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'user,users',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name,displayName,email,url',
                filterKeys   => 'status,lockout',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested users.',
            },
            requires_login => 0,
        },
        {
            id              => 'create_user',
            route           => '/users',
            version         => 2,
            verb            => 'POST',
            resources       => ['user'],
            handler         => '$Core::MT::DataAPI::Endpoint::v2::User::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::User::create_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to create a user.',
            },
        },
        {
            id              => 'delete_user',
            route           => '/users/:user_id',
            version         => 2,
            verb            => 'DELETE',
            handler         => '$Core::MT::DataAPI::Endpoint::v2::User::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::User::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a user.',
            },
        },
        {
            id              => 'unlock_user',
            route           => '/users/:user_id/unlock',
            version         => 2,
            verb            => 'POST',
            handler         => '$Core::MT::DataAPI::Endpoint::v2::User::unlock',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::User::unlock_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to unlock a user.',
            },
        },
        {
            id              => 'recover_password_for_user',
            route           => '/users/:user_id/recover_password',
            version         => 2,
            verb            => 'POST',
            handler         => '$Core::MT::DataAPI::Endpoint::v2::User::recover_password',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::User::recover_password_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to recover password for user.',
            },
        },
        {
            id              => 'recover_password',
            route           => '/recover_password',
            version         => 2,
            verb            => 'POST',
            handler         => '$Core::MT::DataAPI::Endpoint::v2::User::recover',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::User::recover_openapi_spec',
            requires_login  => 0,
        },

        # plugin endpoints
        {
            id              => 'list_plugins',
            route           => '/plugins',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Plugin::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Plugin::list_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the list of plugins.',
            },
        },
        {
            id              => 'get_plugin',
            route           => '/plugins/:plugin_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Plugin::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Plugin::get_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested plugin.',
            },
        },
        {
            id              => 'enable_plugin',
            route           => '/plugins/:plugin_id/enable',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Plugin::enable',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Plugin::enable_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to enable a plugin.',
            },
        },
        {
            id              => 'disable_plugin',
            route           => '/plugins/:plugin_id/disable',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Plugin::disable',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Plugin::disable_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to disable a plugin.',
            },
        },
        {
            id              => 'enable_all_plugins',
            route           => '/plugins/enable',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Plugin::enable_all',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Plugin::enable_all_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to enable all plugins.',
            },
        },
        {
            id              => 'disable_all_plugins',
            route           => '/plugins/disable',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Plugin::disable_all',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Plugin::disable_all_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to disable all plugins.',
            },
        },

        # back up and restore endpoints
        {
            id              => 'backup_site',
            route           => '/sites/:site_id/backup',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::BackupRestore::backup',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::BackupRestore::backup_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to back up the requested site.',
            },
        },

        #        {   id          => 'restore_site',
        #            route       => '/restore',
        #            verb        => 'POST',
        #            version     => 2,
        #            handler     => "${pkg}v2::BackupRestore::restore",
        #            error_codes => {
        #                403 =>
        #                    'Do not have permission to restore the requested site data.',
        #            },
        #        },

        # version 3
        {
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

        # version 4

        # category_set
        {
            id              => 'list_category_sets',
            route           => '/sites/:site_id/categorySets',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::CategorySet::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::CategorySet::list_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'category_set,category_sets',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of category sets.',
            },
            requires_login => 0,
        },
        {
            id              => 'create_category_set',
            route           => '/sites/:site_id/categorySets',
            resources       => ['category_set'],
            verb            => 'POST',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::CategorySet::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::CategorySet::create_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to create a category set.',
            },
        },
        {
            id              => 'get_category_set',
            route           => '/sites/:site_id/categorySets/:category_set_id',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::CategorySet::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::CategorySet::get_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested category set.',
            },
            requires_login => 0,
        },
        {
            id              => 'update_category_set',
            route           => '/sites/:site_id/categorySets/:category_set_id',
            resources       => ['category_set'],
            verb            => 'PUT',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::CategorySet::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::CategorySet::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update a category set.',
            },
        },
        {
            id              => 'delete_category_set',
            route           => '/sites/:site_id/categorySets/:category_set_id',
            verb            => 'DELETE',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::CategorySet::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::CategorySet::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a category set.',
            },
        },

        # category for category_set
        {
            id              => 'list_categories_for_category_set',
            route           => '/sites/:site_id/categorySets/:category_set_id/categories',
            verb            => 'GET',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Category::list_for_category_set',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Category::list_for_category_set_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'category,categories',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'user_custom',
                sortOrder    => 'descend',
                searchFields => 'label,basename',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested categories for category set. ',
            },
            requires_login => 0,
        },
        {
            id              => 'list_parent_categories_for_category_set',
            route           => '/sites/:site_id/categorySets/:category_set_id/categories/:category_id/parents',
            verb            => 'GET',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Category::list_parents_for_category_set',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Category::list_parents_for_category_set_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested categories for category set.',
            },
            requires_login => 0,
        },
        {
            id              => 'list_sibling_categories_for_category_set',
            route           => '/sites/:site_id/categorySets/:category_set_id/categories/:category_id/siblings',
            verb            => 'GET',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Category::list_siblings_for_category_set',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Category::list_siblings_for_category_set_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'category,categories',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'user_custom',
                sortOrder    => 'descend',
                searchFields => 'label,basename',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested categories for category set.',
            },
            requires_login => 0,
        },
        {
            id              => 'list_child_categories_for_category_set',
            route           => '/sites/:site_id/categorySets/:category_set_id/categories/:category_id/children',
            verb            => 'GET',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Category::list_children_for_category_set',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Category::list_children_for_category_set_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested categories for category set.',
            },
            requires_login => 0,
        },
        {
            id              => 'create_category_for_category_set',
            route           => '/sites/:site_id/categorySets/:category_set_id/categories',
            resources       => ['category'],
            verb            => 'POST',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Category::create_for_category_set',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Category::create_for_category_set_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to create a category for category set.',
            },
        },
        {
            id              => 'get_category_for_category_set',
            route           => '/sites/:site_id/categorySets/:category_set_id/categories/:category_id',
            verb            => 'GET',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Category::get_for_category_set',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Category::get_for_category_set_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested category for category set.',
            },
            requires_login => 0,
        },
        {
            id              => 'update_category_for_category_set',
            route           => '/sites/:site_id/categorySets/:category_set_id/categories/:category_id',
            resources       => ['category'],
            verb            => 'PUT',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Category::update_for_category_set',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Category::update_for_category_set_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update a category for category set.',
            },
        },
        {
            id              => 'delete_category_for_category_set',
            route           => '/sites/:site_id/categorySets/:category_set_id/categories/:category_id',
            verb            => 'DELETE',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Category::delete_for_category_set',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Category::delete_for_category_set_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a category for category set.',
            },
        },
        {
            id              => 'permutate_categories_for_category_set',
            route           => '/sites/:site_id/categorySets/:category_set_id/categories/permutate',
            verb            => 'POST',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Category::permutate_for_category_set',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Category::permutate_for_category_set_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to permutate categories for category set.',
            },
        },

        # content_type
        {
            id              => 'list_content_types',
            route           => '/sites/:site_id/contentTypes',
            verb            => 'GET',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentType::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentType::list_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'content_type,content_types',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'id',
                sortOrder    => 'ascend',
                searchFields => 'name,description',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of content types.',
            },
        },
        {
            id              => 'create_content_type',
            route           => '/sites/:site_id/contentTypes',
            resources       => ['content_type'],
            verb            => 'POST',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentType::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentType::create_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to create a content type.',
            },
        },
        {
            id              => 'get_content_type',
            route           => '/sites/:site_id/contentTypes/:content_type_id',
            verb            => 'GET',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentType::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentType::get_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested content type.',
            },
        },
        {
            id              => 'update_content_type',
            route           => '/sites/:site_id/contentTypes/:content_type_id',
            resources       => ['content_type'],
            verb            => 'PUT',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentType::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentType::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update a content type.',
            },
        },
        {
            id              => 'delete_content_type',
            route           => '/sites/:site_id/contentTypes/:content_type_id',
            verb            => 'DELETE',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentType::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentType::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a content type.',
            },
        },

        # content_field
        {
            id              => 'list_content_fields',
            route           => '/sites/:site_id/contentTypes/:content_type_id/fields',
            verb            => 'GET',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentField::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentField::list_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'content_field,content_fields',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'user_custom',
                sortOrder    => 'ascend',
                searchFields => 'label,description',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of content fields.',
            },
        },
        {
            id              => 'create_content_field',
            route           => '/sites/:site_id/contentTypes/:content_type_id/fields',
            resources       => ['content_field'],
            verb            => 'POST',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentField::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentField::create_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to create a content type.',
            },
        },
        {
            id              => 'get_content_field',
            route           => '/sites/:site_id/contentTypes/:content_type_id/fields/:content_field_id',
            verb            => 'GET',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentField::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentField::get_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested content field.',
            },
        },
        {
            id              => 'update_content_field',
            route           => '/sites/:site_id/contentTypes/:content_type_id/fields/:content_field_id',
            resources       => ['content_field'],
            verb            => 'PUT',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentField::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentField::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update a content field.',
            },
        },
        {
            id              => 'delete_content_field',
            route           => '/sites/:site_id/contentTypes/:content_type_id/fields/:content_field_id',
            verb            => 'DELETE',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentField::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentField::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a content field.',
            },
        },
        {
            id              => 'permutate_content_fields',
            route           => '/sites/:site_id/contentTypes/:content_type_id/fields/permutate',
            verb            => 'POST',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentField::permutate',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentField::permutate_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to permutate content fields.',
            },
        },

        # content_data
        {
            id              => 'list_content_data',
            route           => '/sites/:site_id/contentTypes/:content_type_id/data',
            verb            => 'GET',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentData::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentData::list_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'content_data,content_data',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'modified_on',
                sortOrder    => 'descend',
                searchFields => 'identifier',
                filterKeys   => 'status',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of content data.',
            },
            requires_login => 0,
        },
        {
            id              => 'create_content_data',
            route           => '/sites/:site_id/contentTypes/:content_type_id/data',
            resources       => ['content_data'],
            verb            => 'POST',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentData::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentData::create_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to create a content data.',
            },
        },
        {
            id              => 'get_content_data',
            route           => '/sites/:site_id/contentTypes/:content_type_id/data/:content_data_id',
            verb            => 'GET',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentData::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentData::get_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested content data.',
            },
            requires_login => 0,
        },
        {
            id              => 'update_content_data',
            route           => '/sites/:site_id/contentTypes/:content_type_id/data/:content_data_id',
            resources       => ['content_data'],
            verb            => 'PUT',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentData::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentData::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update a content data.',
            },
        },
        {
            id              => 'delete_content_data',
            route           => '/sites/:site_id/contentTypes/:content_type_id/data/:content_data_id',
            verb            => 'DELETE',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentData::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentData::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a content data.',
            },
        },
        {
            id              => 'preview_content_data_by_id',
            route           => '/sites/:site_id/contentTypes/:content_type_id/data/:content_data_id/preview',
            resources       => ['content_data'],
            verb            => 'POST',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentData::preview_by_id',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentData::preview_by_id_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to preview content data.',
            },
        },
        {
            id              => 'preview_content_data',
            route           => '/sites/:site_id/contentTypes/:content_type_id/data/preview',
            resources       => ['content_data'],
            verb            => 'POST',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentData::preview',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::ContentData::preview_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to preview content data.',
            },
        },
        {
            id              => 'publish_content_data',
            route           => '/publish/contentData',
            verb            => 'GET',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Publish::content_data',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Publish::content_data_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to publish content_data.',
            },
        },

        # search
        {
            id              => 'search',
            route           => '/search',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Search::search',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Search::search_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes     => {
                403 => 'Do not have permission to search objects.',
            },
            requires_login => 0,
        },

        # template
        {
            id              => 'list_templates',
            route           => '/sites/:site_id/templates',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Template::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Template::list_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'template,templates',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name,templateType,text',
                filterKeys   => 'type',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of templates.',
            },
        },
        {
            id              => 'get_template',
            route           => '/sites/:site_id/templates/:template_id',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Template::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Template::get_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested template.',
            },
        },
        {
            id              => 'update_template',
            route           => '/sites/:site_id/templates/:template_id',
            resources       => ['template'],
            verb            => 'PUT',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Template::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Template::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update a template.',
            },
        },
        {
            id              => 'delete_template',
            route           => '/sites/:site_id/templates/:template_id',
            verb            => 'DELETE',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Template::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Template::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a template.',
            },
        },

        {
            id              => 'publish_template',
            route           => '/sites/:site_id/templates/:template_id/publish',
            verb            => 'POST',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Template::publish',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Template::publish_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to publish a template.',
            },
        },
        {
            id              => 'refresh_template',
            route           => '/sites/:site_id/templates/:template_id/refresh',
            verb            => 'POST',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Template::refresh',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Template::refresh_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to refresh a template.',
            },
        },
        {
            id              => 'clone_template',
            route           => '/sites/:site_id/templates/:template_id/clone',
            verb            => 'POST',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::Template::clone',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::Template::clone_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to clone a template.',
            },
        },

        # templatemap endpoints
        {
            id              => 'list_templatemaps',
            route           => '/sites/:site_id/templates/:template_id/templatemaps',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::TemplateMap::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::TemplateMap::list_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'templatemap,templatemaps',
            },
            default_params => {
                limit      => 10,
                offset     => 0,
                sortBy     => 'id',
                sortOrder  => 'ascend',
                filterKeys => 'archiveType,buildType,isPreferred',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of templatemaps.',
            },
        },
        {
            id              => 'get_templatemap',
            route           => '/sites/:site_id/templates/:template_id/templatemaps/:templatemap_id',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::TemplateMap::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::TemplateMap::get_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to retrieve the requested templatemap.',
            },
        },
        {
            id              => 'create_templatemap',
            route           => '/sites/:site_id/templates/:template_id/templatemaps',
            resources       => ['templatemap'],
            verb            => 'POST',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::TemplateMap::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::TemplateMap::create_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to create a templatemap.',
            },
        },
        {
            id              => 'update_templatemap',
            route           => '/sites/:site_id/templates/:template_id/templatemaps/:templatemap_id',
            resources       => ['templatemap'],
            verb            => 'PUT',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::TemplateMap::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::TemplateMap::update_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to update a templatemap.',
            },
        },
        {
            id              => 'delete_templatemap',
            route           => '/sites/:site_id/templates/:template_id/templatemaps/:templatemap_id',
            verb            => 'DELETE',
            version         => 4,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::TemplateMap::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::TemplateMap::delete_openapi_spec',
            error_codes     => {
                403 => 'Do not have permission to delete a templatemap.',
            },
        },

        # group
        {
            id              => 'list_groups',
            route           => '/groups',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Group::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Group::list_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'group,groups',
            },
            default_params => {
                limit        => 25,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name,displayName,description',
                filterKeys   => 'status',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested groups.',
            },
        },
        {
            id              => 'list_groups_for_user',
            route           => '/users/:user_id/groups',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Group::list_for_user',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Group::list_for_user_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'group,groups',
            },
            default_params => {
                limit        => 25,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name,displayName,description',
                filterKeys   => 'status',
            },
            error_codes => {
                403 => "Do not have permission to retrieve the requested user's groups.",
            },
        },
        {
            id              => 'get_group',
            route           => '/groups/:group_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Group::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Group::get_openapi_spec',
            error_codes     => {
                403 => "Do not have permission to retrieve the requested group.",
            },
        },
        {
            id              => 'create_group',
            route           => '/groups',
            resources       => ['group'],
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Group::create',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Group::create_openapi_spec',
            error_codes     => {
                403 => "Do not have permission to create a group.",
            },
        },
        {
            id              => 'update_group',
            route           => '/groups/:group_id',
            resources       => ['group'],
            verb            => 'PUT',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Group::update',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Group::update_openapi_spec',
            error_codes     => {
                403 => "Do not have permission to update a group.",
            },
        },
        {
            id              => 'delete_group',
            route           => '/groups/:group_id',
            verb            => 'DELETE',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Group::delete',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Group::delete_openapi_spec',
            error_codes     => {
                403 => "Do not have permission to delete a group.",
            },
        },

        # permission
        {
            id             => 'list_permissions_for_group',
            route          => '/groups/:group_id/permissions',
            version        => 2,
            default_params => {
                limit      => 25,
                offset     => 0,
                sortBy     => 'blog_id',
                sortOrder  => 'ascend',
                filterKeys => 'blogIds',
            },
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Permission::list_for_group',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Permission::list_for_group_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'permission,permissions',
            },
            error_codes => {
                403 => "Do not have permission to retrieve the requested group's permissions.",
            },
        },
        {
            id              => 'grant_permission_to_group',
            route           => '/groups/:group_id/permissions/grant',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Permission::grant_to_group',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Permission::grant_to_group_openapi_spec',
            error_codes     => {
                403 => "Do not have permission to grant a permission.",
            },
        },
        {
            id              => 'revoke_permission_from_group',
            route           => '/groups/:group_id/permissions/revoke',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Permission::revoke_from_group',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Permission::revoke_from_group_openapi_spec',
            error_codes     => {
                403 => "Do not have permission to revoke a permission.",
            },
        },

        # group member
        {
            id              => 'list_members_for_group',
            route           => '/groups/:group_id/members',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Group::list_members_for_group',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Group::list_members_for_group_openapi_spec',
            openapi_options => {
                filtered_list_ds_nouns => 'user,users',
            },
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name,displayName,email,url',
                filterKeys   => 'status,lockout',
            },
            error_codes => {
                403 => "Do not have permission to retrieve the list of group members.",
            },
        },
        {
            id              => 'get_member_for_group',
            route           => '/groups/:group_id/members/:member_id',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Group::get_member',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Group::get_member_openapi_spec',
            error_codes     => {
                403 => "Do not have permission to retrieve the requested group member.",
            },
        },
        {
            id              => 'add_member_to_group',
            route           => '/groups/:group_id/members',
            verb            => 'POST',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Group::add_member',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Group::add_member_openapi_spec',
            error_codes     => {
                403 => "Do not have permission to add a member to group.",
            },
        },
        {
            id              => 'remove_member_from_group',
            route           => '/groups/:group_id/members/:member_id',
            verb            => 'DELETE',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v2::Group::remove_member',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v2::Group::remove_member_openapi_spec',
            error_codes     => {
                403 => "Do not have permission to remove a member from group.",
            },
        },
    ];
}

sub init_plugins {
    my $app = shift;

    # This has to be done prior to plugin initialization since we
    # may have plugins that register themselves using some of the
    # older callback names. The callback aliases are declared
    # in init_core_callbacks.
    MT::App::CMS::Common::init_core_callbacks($app);
    MT::App::Search::Common::init_core_callbacks($app);

    my $pkg = $app->id . '_';
    my $pfx = '$Core::MT::DataAPI::Callback::';
    $app->_register_core_callbacks(
        {

            # entry callbacks
            $pkg
                . 'pre_load_filtered_list.entry' =>
                "${pfx}Entry::cms_pre_load_filtered_list",
            $pkg . 'list_permission_filter.entry' => "${pfx}Entry::can_list",
            $pkg . 'view_permission_filter.entry' => "${pfx}Entry::can_view",
            $pkg . 'save_filter.entry' => "${pfx}Entry::save_filter",

            # page callbacks
            $pkg
                . 'pre_load_filtered_list.page' =>
                "${pfx}Page::cms_pre_load_filtered_list",
            $pkg . 'list_permission_filter.page' => "${pfx}Page::can_list",
            $pkg . 'view_permission_filter.page' => "${pfx}Page::can_view",
            $pkg . 'save_filter.page'            => "${pfx}Page::save_filter",

            # user callbacks
            $pkg
                . 'pre_load_filtered_list.author' =>
                "${pfx}User::pre_load_filtered_list",
            $pkg . 'view_permission_filter.author' => "${pfx}User::can_view",
            $pkg . 'save_filter.author' => "${pfx}User::save_filter",

            # permission callbacks
            $pkg
                . 'pre_load_filtered_list.permission' =>
                "${pfx}Permission::cms_pre_load_filtered_list",
            $pkg
                . 'list_permission_filter.permission' =>
                "${pfx}Permission::can_list",

            # category callbacks
            $pkg
                . 'view_permission_filter.category' =>
                "${pfx}Category::can_view",
            $pkg . 'save_filter.category' => "${pfx}Category::save_filter",
            $pkg
                . 'save_permission_filter.category' =>
                "${pfx}Category::can_save",

            # folder callbacks
            $pkg
                . 'view_permission_filter.folder' => "${pfx}Folder::can_view",
            $pkg . 'save_filter.folder' => "${pfx}Folder::save_filter",

            # asset callbacks
            $pkg
                . 'pre_load_filtered_list.asset' =>
                "${pfx}Asset::cms_pre_load_filtered_list",
            $pkg . 'pre_save.asset' => "${pfx}Asset::pre_save",

            # blog callbacks
            $pkg
                . 'pre_load_filtered_list.blog' =>
                "${pfx}Blog::cms_pre_load_filtered_list",
            $pkg . 'save_filter.blog' => "${pfx}Blog::save_filter",

            # website callbacks
            $pkg . 'save_filter.website' => "${pfx}Website::save_filter",

            # role callbacks
            $pkg . 'save_filter.role'            => "${pfx}Role::save_filter",
            $pkg . 'view_permission_filter.role' => "${pfx}Role::can_view",

            # log callbacks
            $pkg . 'view_permission_filter.log'   => "${pfx}Log::can_view",
            $pkg . 'save_permission_filter.log'   => "${pfx}Log::can_save",
            $pkg . 'save_filter.log'              => "${pfx}Log::save_filter",
            $pkg . 'delete_permission_filter.log' => "${pfx}Log::can_delete",
            $pkg . 'post_delete.log'              => "${pfx}Log::post_delete",

            # tag callbacks
            $pkg
                . 'pre_load_filtered_list.tag' =>
                "${pfx}Tag::cms_pre_load_filtered_list",
            $pkg . 'view_permission_filter.tag'   => "${pfx}Tag::can_view",
            $pkg . 'save_permission_filter.tag'   => "${pfx}Tag::can_save",
            $pkg . 'delete_permission_filter.tag' => "${pfx}Tag::can_delete",

            # template callbacks
            $pkg
                . 'list_permission_filter.template' =>
                "${pfx}Template::can_list",
            $pkg
                . 'view_permission_filter.template' =>
                "${pfx}Template::can_view",
            $pkg . 'save_filter.template' => "${pfx}Template::save_filter",

            # widget callbacks
            $pkg
                . 'save_permission_filter.widget' =>
                '$Core::MT::CMS::Template::can_save',
            $pkg . 'save_filter.widget' => "${pfx}Widget::save_filter",
            $pkg . 'pre_save.widget' => '$Core::MT::CMS::Template::pre_save',
            $pkg
                . 'post_save.widget' => '$Core::MT::CMS::Template::post_save',

            # widgetset callbacks
            $pkg
                . 'save_permission_filter.widgetset' =>
                '$Core::MT::CMS::Template::can_save',
            $pkg . 'save_filter.widgetset' => "${pfx}WidgetSet::save_filter",
            $pkg
                . 'pre_save.widgetset' =>
                '$Core::MT::CMS::Template::pre_save',
            $pkg
                . 'post_save.widgetset' =>
                '$Core::MT::CMS::Template::post_save',

            # templatemap callbacks
            $pkg
                . 'list_permission_filter.templatemap' =>
                "${pfx}TemplateMap::can_list",
            $pkg
                . 'view_permission_filter.templatemap' =>
                "${pfx}TemplateMap::can_view",
            $pkg
                . 'save_permission_filter.templatemap' =>
                "${pfx}TemplateMap::can_save",
            $pkg
                . 'save_filter.templatemap' =>
                "${pfx}TemplateMap::save_filter",
            $pkg . 'pre_save.templatemap'  => "${pfx}TemplateMap::pre_save",
            $pkg . 'post_save.templatemap' => "${pfx}TemplateMap::post_save",
            $pkg
                . 'delete_permission_filter.templatemap' =>
                "${pfx}TemplateMap::can_delete",
            $pkg
                . 'post_delete.templatemap' =>
                "${pfx}TemplateMap::post_delete",

            # plugin callbacks
            $pkg
                . 'list_permission_filter.plugin' => "${pfx}Plugin::can_list",
            $pkg
                . 'view_permission_filter.plugin' => "${pfx}Plugin::can_view",

            # category_set callbacks
            $pkg
                . 'save_filter.category_set' =>
                "${pfx}CategorySet::save_filter",

            # content_type callbacks
            $pkg
                . 'save_filter.content_type' =>
                "${pfx}ContentType::save_filter",

            # content_field callbacks
            $pkg
                . 'save_filter.content_field' =>
                "${pfx}ContentField::save_filter",

            # content_data callbacks
            $pkg
                . 'list_permission_filter.content_data' =>
                "${pfx}ContentData::can_list",
            $pkg
                . 'view_permission_filter.content_data' =>
                "${pfx}ContentData::can_view",
            $pkg
                . 'pre_load_filtered_list.content_data' =>
                "${pfx}ContentData::cms_pre_load_filtered_list",
            $pkg
                . 'save_filter.content_data' =>
                "${pfx}ContentData::save_filter",

            # group callbacks
            $pkg . 'save_filter.group' => "${pfx}Group::save_filter",

        }
    );

    $app->SUPER::init_plugins(@_);
}

sub _compile_endpoints {
    my ( $app, $version ) = @_;

    my %hash = ();
    my %tree = ();
    my @list = ();

    my @components = MT::Component->select();
    for my $c (@components) {
        my $endpoints
            = $c->registry( 'applications', 'data_api', 'endpoints' );
        next unless defined $endpoints;

        foreach my $e (@$endpoints) {
            $e->{component} = $c;
            $e->{id}          ||= $e->{route};
            $e->{version}     ||= 1;
            $e->{verb}        ||= 'GET';
            $e->{error_codes} ||= {};

            if ( !exists( $e->{requires_login} ) ) {
                $e->{requires_login} = 1;
            }

            next if $e->{version} > $version;

            $e->{_vars} = [];

            my $cur = \%tree;
            ( my $route = $e->{route} ) =~ s#^/+##;
            foreach my $p ( split m#(?=/|\.)|(?<=/|\.)#o, $route ) {
                if ( $p =~ /^:([a-zA-Z_-]+)/ ) {
                    $cur = $cur->{':v'} ||= {};
                    push @{ $e->{_vars} }, $1;
                }
                else {
                    $cur = $cur->{$p} ||= {};
                }
            }

            $cur->{':e'} ||= {};
            if (  !$cur->{':e'}{ lc $e->{verb} }
                || $cur->{':e'}{ lc $e->{verb} }{version} < $e->{version} )
            {
                $cur->{':e'}{ lc $e->{verb} } = $e;
            }

            $hash{ $e->{id} } = $e;
            push @list, $e;
        }
    }

    +{  hash => \%hash,
        tree => \%tree,
        list => \@list,
    };
}

sub endpoints {
    my ( $app, $version ) = @_;
    $endpoints{$version} ||= $app->_compile_endpoints($version);
}

sub fields_to_schema {
    my ($app, $resource_name) = @_;
    my $schema = {
        type => 'object',
    };
    my $resource = MT::DataAPI::Resource->resource($resource_name);
    for my $field (@{ $resource->{fields} }) {
        if ($field->{schema}) {
            $schema->{properties}{ $field->{name} } = {
                %{ $field->{schema} },
            };
        } elsif (defined $field->{type} && $field->{type} =~ m/MT::DataAPI::Resource::DataType::Object\z/) {
            $schema->{properties}{ $field->{name} }{type} = 'object';
            for my $key (@{ $field->{fields} }) {
                $schema->{properties}{ $field->{name} }{properties}{$key} = {
                    type => 'string',
                };
            }
        } elsif (defined $field->{type} && $field->{type} =~ m/MT::DataAPI::Resource::DataType::/) {
            my $type_schema = $app->handler_to_coderef($field->{type} . '::schema')->();
            $schema->{properties}{ $field->{name} } = {
                %$type_schema,
            };
        } elsif (defined $field->{type}) {
            $schema->{properties}{ $field->{name} } = {
                type => $field->{type},
            };
        } else {
            $schema->{properties}{ $field->{name} } = {
                type => 'string',
            };
        }
    }
    my $updatable_schema;
    if (scalar(@{ $resource->{updatable_fields} })) {
        $schema->{description} = 'Updatable fields are ' . join(', ', map { $_->{name} } @{ $resource->{updatable_fields} });
        $updatable_schema->{type} = 'object';
        for my $f (@{ $resource->{updatable_fields} }) {
            my $field_name = $f->{name};
            if (exists $schema->{properties}{$field_name}) {
                $updatable_schema->{properties}{$field_name} = $schema->{properties}{$field_name};
            }
        }
    }
    return ($schema, $updatable_schema);
}

sub _compile_schemas {
    my ($app, $version) = @_;
    my %hash       = ();
    my @components = MT::Component->select();
    for my $c (@components) {
        my $resources = $c->registry('applications', 'data_api', 'resources');
        next unless defined $resources;
        for my $key (keys %$resources) {
            if (ref($resources->{$key}) eq 'ARRAY') {
                for my $v (@{ $resources->{$key} }) {
                    $v->{version} ||= 1;
                    next if $v->{version} > $version;
                    ($hash{$key}, my $updatable_schema) = $app->fields_to_schema($key);
                    if ($updatable_schema) {
                        $hash{"${key}_updatable"} = $updatable_schema;
                    }
                }
            } else {
                # alias
                next;
            }
        }
    }
    return \%hash;
}

sub schemas {
    my ($app, $version) = @_;
    $schemas{$version} ||= $app->_compile_schemas($version);
}

sub current_endpoint {
    my $app = shift;
    $app->request( 'data_api_current_endpoint', @_ ? $_[0] : () );
}

sub current_api_version {
    my $app = shift;
    $app->request( 'data_api_current_version', @_ ? $_[0] : () );
}

sub find_endpoint_by_id {
    my ( $app, $version, $id ) = @_;
    $app->endpoints($version)->{hash}{$id};
}

sub endpoint_url {
    my ( $app, $endpoint, $params ) = @_;
    $endpoint
        = $app->find_endpoint_by_id( $app->current_api_version, $endpoint )
        unless ref $endpoint;
    return '' unless $endpoint;

    my $replace = sub {
        my ( $whole, $key ) = @_;
        if ( exists $params->{$key} ) {
            my $v = delete $params->{$key};
            $v->can('id') ? $v->id : $v;
        }
        else {
            $whole;
        }
    };

    my $url = $endpoint->{route};
    $url =~ s{(?:(?<=^)|(?<=/|\.))(:([a-zA-Z_-]+))}{$replace->($1, $2)}ge;

    $url . $app->uri_params( args => $params || {} );
}

sub find_endpoints_by_path {
    my $app = shift;
    $app->find_endpoint_by_path( '*', @_ );
}

sub find_endpoint_by_path {
    my ( $app, $verb, $version, $path ) = @_;
    $verb = lc($verb);

    my $endpoints = $app->endpoints($version)->{tree};

    my $handler     = $endpoints;
    my @vars        = ();
    my $auto_format = '';

    $path =~ s#^/+##;
    my @paths = split m#(?=/|\.)|(?<=/|\.)#o, $path;
    while (@paths) {
        my $p = shift @paths;
        if ( $handler->{$p} ) {
            $handler = $handler->{$p};
        }
        elsif ( $handler->{':v'} ) {
            $handler = $handler->{':v'};
            push @vars, $p;
        }
        elsif ( $p eq '.' && scalar(@paths) == 1 ) {
            $auto_format = shift @paths;
        }
        else {
            return;
        }
    }

    if ( $verb eq '*' ) {
        return $handler->{':e'};
    }

    my $e = $handler->{':e'}{$verb}
        or return;

    my %params = ();
    for ( my $i = 0; $i < scalar( @{ $e->{_vars} } ); $i++ ) {
        $params{ $e->{_vars}[$i] } = $vars[$i];
    }
    $params{format} = $auto_format if $auto_format && !$e->{format};

    $e, \%params;
}

sub current_format {
    my ($app) = @_;
    MT::DataAPI::Format->find_format;
}

sub current_error_format {
    my ($app) = @_;
    my $format = $app->current_format;
    if ( my $invoke = $format->{error_format} ) {
        $format = MT::DataAPI::Format->find_format($invoke);
    }
    $format;
}

sub _request_method {
    my ($app) = @_;
    my $method = lc $app->request_method;
    if ( my $m = $app->param('__method') ) {
        if ( $method eq 'post' || $method eq lc $m ) {
            $method = lc $m;
        }
        else {
            return $app->print_error(
                "Request method is not '$m' or 'POST' with '__method=$m'",
                405 );
        }
    }
    $method;
}

sub _path {
    my ($app) = @_;
    my $path = $app->path_info;
    $path =~ s{.+(?=/v\d+/)}{};
    $path;
}

sub _version_path {
    my ($app) = @_;
    my $path = $app->_path;

    $path =~ s{\A/?v(\d+)}{};
    ( $1, $path );
}

sub resource_object {
    my ( $app, $name, $original ) = @_;

    my $data_text = $app->param($name)
        or return $app->error( qq{A resource "$name" is required.}, 400 );

    my $data = $app->current_format->{unserialize}->($data_text)
        or return $app->error( 'Invalid data format: ' . $name, 400 );

    my $obj = MT::DataAPI::Resource->to_object( $name, $data, $original );
    return $app->error( 'Failed to convert to the object: ' . $obj->errstr,
        400 )
        if ( $obj->errstr );

    $obj;
}

sub object_to_resource {
    my ( $app, $res, $fields ) = @_;
    my $ref = ref $res;

    if ( $ref && UNIVERSAL::can( $res, 'to_resource' ) ) {
        $res->to_resource($fields);
    }
    elsif ( UNIVERSAL::isa( $res, 'MT::Object' )
        || $ref eq 'MT::DataAPI::Resource::Type::ObjectList' )
    {
        MT::DataAPI::Resource->from_object( $res, $fields );
    }
    elsif ( $ref eq 'MT::DataAPI::Resource::Type::Raw' ) {
        $res->content;
    }
    elsif ( $ref eq 'HASH' ) {
        my %result = ();
        foreach my $k ( keys %$res ) {
            $result{$k} = $app->object_to_resource( $res->{$k}, $fields );
        }
        \%result;
    }
    elsif ( $ref eq 'ARRAY' ) {
        [ map { $app->object_to_resource( $_, $fields ) } @$res ];
    }
    else {
        $res;
    }
}

sub mt_authorization_data {
    my ($app) = @_;

    my $header = $app->get_header('X-MT-Authorization')
        || ( lc $app->request_method eq 'post'
        && $app->param('X-MT-Authorization') )
        or return undef;

    my %values = ();

    $header =~ s/\A\s+|\s+\z//g;

    my ( $type, $rest ) = split /\s+/, $header, 2;
    return undef unless $type;

    $values{$type} = {};

    while ( $rest =~ m/(\w+)=(?:("|')([^\2]*)\2|([^\s,]*))/g ) {
        $values{$type}{$1} = defined($3) ? $3 : $4;
    }

    \%values;
}

sub authenticate {
    my ($app) = @_;

    my $data = $app->mt_authorization_data;
    return MT::Author->anonymous
        unless $data
        && exists $data->{MTAuth}{accessToken};

    my $session
        = MT::AccessToken->load_session( $data->{MTAuth}{accessToken} || '' )
        or return undef;
    my $user = $app->model('author')->load( $session->get('author_id') )
        or return undef;

    return undef unless $user->is_active;

    $app->{session} = $session;

    $user;
}

sub current_client_id {
    my ($app) = @_;

    my $client_id = $app->request('data_api_current_client_id');
    return $client_id if defined $client_id;

    $client_id = $app->param('clientId') || '';
    $client_id = '' if $client_id !~ m/\A[\w-]+\z/;
    $app->request( 'data_api_current_client_id', $client_id );
}

sub user_cookie {
    my ($app) = @_;
    'mt_data_api_user_' . $app->current_client_id;
}

sub session_kind {
    'DS';    # DS == DataAPI Session
}

sub make_session {
    my ( $app, $auth, $remember ) = @_;
    require MT::Session;
    require MT::Util::UniqueID;
    my $new_id = MT::Util::UniqueID::create_session_id();
    my $token  = MT::Util::UniqueID::create_magic_token();
    my $sess = new MT::Session;
    $sess->id( $new_id );
    $sess->kind( $app->session_kind );
    $sess->start(time);
    $sess->set( 'author_id', $auth->id );
    $sess->set( 'client_id', $app->current_client_id );
    $sess->set( 'magic_token', $token );
    $sess->set( 'remember',  1 ) if $remember;
    $sess->save;
    $sess;
}

sub session_user {
    my $app = shift;
    my ( $author, $session_id, %opt ) = @_;
    return undef unless $author && $session_id;
    if ( !$app->{session} ) {
        require MT::Session;
        my $timeout
            = $opt{permanent}
            ? ( 360 * 24 * 365 * 10 )
            : $app->config->UserSessionTimeout;
        $app->{session} = MT::Session::get_unexpired_value(
            $timeout,
            {   id   => $session_id,
                kind => $app->session_kind,
            }
        );
    }
    my $sess = $app->{session} or return undef;

    if ( $sess->get('author_id') == $author->id ) {
        my $start = time;
        $sess->start($start);
        $sess->set(start => $start) unless $sess->get('start');
        $sess->save;
        return $author;
    }
    else {
        return undef;
    }
}

sub start_session {
    my $app = shift;
    my ( $user, $remember ) = @_;
    if ( !defined $user ) {
        $user = $app->user;
        my ( $x, $y );
        ( $x, $y, $remember )
            = split( /::/, $app->cookie_val( $app->user_cookie ) );
    }
    my $session = $app->make_session( $user, $remember );
    $app->{session} = $session;
}

sub purge_session_records {
    my $class = shift;

    require MT::Session;

    # remove expired user sessions
    MT::Core::purge_user_session_records( $class->session_kind,
        MT->config->UserSessionTimeout );

    # remove expired access tokens
    MT::AccessToken->purge;

    return '';
}

sub send_cors_http_header {
    my $app    = shift;
    my $config = $app->config;

    my $origin       = $app->get_header('Origin');
    my $allow_origin = $config->DataAPICORSAllowOrigin
        or return;

    if ( $allow_origin ne '*' ) {
        return unless $origin;

        my ($match_origin) = grep { $_ eq $origin } split /\s*,\s*/,
            $allow_origin;
        return unless $match_origin;
        $allow_origin = $match_origin;
    }

    $app->set_header( 'Access-Control-Allow-Origin' => $allow_origin );
    $app->set_header( 'XDomainRequestAllowed'       => 1 );
    $app->set_header(
        'Access-Control-Allow-Methods' => $config->DataAPICORSAllowMethods );
    $app->set_header(
        'Access-Control-Allow-Headers' => $config->DataAPICORSAllowHeaders );
    $app->set_header( 'Access-Control-Expose-Headers' =>
            $config->DataAPICORSExposeHeaders );
}

sub send_http_header {
    my $app = shift;

    $app->set_header( 'X-Content-Type-Options' => 'nosniff' );
    $app->set_header( 'Cache-Control'          => 'no-cache' );

    $app->send_cors_http_header(@_);

    return $app->SUPER::send_http_header(@_);
}

sub default_options_response {
    my $app = shift;

    my $endpoints = $app->find_endpoints_by_path( $app->_version_path )
        || {};

    $app->set_header( 'Allow' =>
            join( ', ', sort( map { uc $_ } keys %$endpoints ), 'OPTIONS' ) );
    $app->send_http_header();
    $app->{no_print_body} = 1;

    undef;
}

sub error {
    my $app  = shift;
    my @args = @_;

    if ( $_[0] && ( $_[0] =~ m/\A\d{3}\z/ || $_[1] ) ) {
        my ( $message, $code, $data ) = do {
            if ( scalar(@_) >= 2 ) {
                @_;
            }
            else {
                ( '', $_[0], undef );
            }
        };
        $app->request(
            'data_api_error_detail',
            {   code    => $code,
                message => $message,
                data    => $data,
            }
        );
        @args = join( ' ', reverse(@_) );
    }

    return $app->SUPER::error(@args);
}

sub print_error {
    my ( $app, $message, $status, $data ) = @_;

    if ( !$status && $message =~ m/\A\d{3}\z/ ) {
        $status  = $message;
        $message = '';
    }
    if ( !$message && $status ) {
        require HTTP::Status;
        $message = HTTP::Status::status_message($status);
    }

    my $format             = $app->current_error_format;
    my $http_response_code = $status;
    my $mime_type          = $format->{mime_type};

    if ( $app->requires_plain_text_result ) {
        $http_response_code = 200;
        $mime_type          = 'text/plain';
    }
    if ( $app->param('suppressResponseCodes') ) {
        $http_response_code = 200;
    }

    $app->response_code($http_response_code);
    $app->send_http_header($mime_type);

    $app->{no_print_body} = 1;
    $app->print_encode(
        $format->{serialize}->(
            {   error => {
                    code    => $status + 0,
                    message => $message,
                    ( $data ? ( data => $data ) : () ),
                }
            }
        )
    );

    return undef;
}

sub show_error {
    my $app      = shift;
    my ($param)  = @_;
    my $endpoint = $app->current_endpoint;
    my $error    = $app->request('data_api_error_detail');

    return $app->SUPER::show_error(@_)
        if ( !$error
        && $endpoint
        && ( $endpoint->{format} || '' ) eq 'html' );

    if ( !$error ) {
        $error = {
            code => $param->{status} || 500,
            message => $param->{error},
        };
    }

    return $app->print_error( $error->{message}
            || $endpoint->{error_codes}{ $error->{code} },
        $error->{code}, $error->{data} );
}

sub publish_error {
    require MT::App::CMS;
    MT::App::CMS::publish_error(@_);
}

sub permission_denied {
    my $app = shift;
    return $app->error(403);
}

sub set_next_phase_url {
    my $app = shift;
    my ($url) = @_;
    $app->set_header( 'X-MT-Next-Phase-URL', $url );
}

sub requires_plain_text_result {
    my $app = shift;
    lc $app->request_method eq 'post'
        && lc( $app->param('X-MT-Requested-Via') || '' ) eq 'iframe';
}

sub load_default_entry_prefs {
    MT::App::CMS::load_default_entry_prefs(@_);
}

sub load_default_page_prefs {
    MT::App::CMS::load_default_page_prefs(@_);
}

sub api {
    my ($app) = @_;
    my ( $version, $path ) = $app->_version_path;

    # Special handler for get version information.
    if ( $path eq '/version' ) {
        my $raw = {
            endpointVersion => 'v' . $app->DEFAULT_VERSION(),
            apiVersion      => $app->API_VERSION(),
        };
        my $format = $app->current_format;
        my $data   = $format->{serialize}->($raw);

        $app->send_http_header( $format->{mime_type} );
        $app->{no_print_body} = 1;
        $app->print_encode($data);
        return undef;
    }

    return $app->print_error( 'API Version is required', 400 )
        unless defined $version;

    my $request_method = $app->_request_method
        or return;
    my ( $endpoint, $params )
        = $app->find_endpoint_by_path( $request_method, $version, $path )
        or return
        lc($request_method) eq 'options'
        ? $app->default_options_response
        : $app->print_error( 'Unknown endpoint', 404 );
    my $user = $app->authenticate;

    if ( !$user || ( $endpoint->{requires_login} && $user->is_anonymous ) ) {
        return $app->print_error( 'Unauthorized', 401 );
    }
    $user ||= MT::Author->anonymous;
    $app->user($user);
    $app->permissions(undef);

    if ( defined $params->{site_id} ) {
        my $id = $params->{site_id};
        if ($id) {
            my $site = $app->blog( scalar $app->model('blog')->load($id) )
                or return $app->print_error( 'Site not found', 404 );
        }
        $app->param( 'blog_id', $id );

        require MT::CMS::Blog;
        if (   !$user->is_superuser
            && !MT::CMS::Blog::data_api_is_enabled( $app, $id ) )
        {
            return $app->print_error(403);
        }

        $app->permissions( $user->permissions($id) )
            unless $user->is_anonymous;
    }
    else {
        $app->param( 'blog_id', undef );
    }

    foreach my $k (%$params) {
        $app->param( $k, $params->{$k} );
    }
    if ( my $default_params = $endpoint->{default_params} ) {
        my %request_param_key = map { $_ => 1 } $app->multi_param;
        foreach my $k (%$default_params) {
            if ( !exists( $request_param_key{$k} ) ) {
                $app->param( $k, $default_params->{$k} );
            }
        }
    }

    $endpoint->{handler_ref}
        ||= $app->handler_to_coderef( $endpoint->{handler} )
        or return $app->print_error( 'Unknown endpoint', 404 );

    $app->current_endpoint($endpoint);
    $app->current_api_version($version);

    $app->run_callbacks( 'pre_run_data_api.' . $endpoint->{id},
        $app, $endpoint );
    my $response = $endpoint->{handler_ref}->( $app, $endpoint );
    $app->run_callbacks( 'post_run_data_api.' . $endpoint->{id},
        $app, $endpoint, $response );

    my $response_ref = ref $response;

    if (   UNIVERSAL::isa( $response, 'MT::Object' )
        || $response_ref =~ m/\A(?:HASH|ARRAY|MT::DataAPI::Resource::Type::)/
        || ($response_ref && UNIVERSAL::can( $response, 'to_resource' ) ) )
    {
        my $format   = $app->current_format;
        my $fields   = $app->param('fields') || '';
        my $resource = $app->object_to_resource( $response,
            $fields ? [ split ',', $fields ] : undef );
        my $data = $format->{serialize}->($resource);

        if ( $app->requires_plain_text_result ) {
            $app->send_http_header('text/plain');
        }
        else {
            $app->send_http_header( $format->{mime_type} );
        }

        $app->{no_print_body} = 1;
        $app->print_encode($data);
        undef;
    }
    elsif ( lc($request_method) eq 'options' && !$response ) {
        $app->send_http_header();
        $app->{no_print_body} = 1;
        undef;
    }
    else {
        $response;
    }
}

sub has_valid_limit_and_offset {
    my ($app) = shift;
    my ( $limit, $offset ) = @_;

    return $app->errtrans( '[_1] must be a number.', 'limit' )
        if ( defined $limit && $limit !~ /\A[0-9]+\z/ );
    return $app->errtrans( '[_1] must be a number.', 'offset' )
        if ( defined $offset && $offset !~ /\A[0-9]+\z/ );

    return $app->errtrans(
        '[_1] must be an integer and between [_2] and [_3].',
        'limit', 1, 2147483647 )
        if ( defined $limit && ( $limit < 1 || $limit > 2147483647 ) );
    return $app->errtrans(
        '[_1] must be an integer and between [_2] and [_3].',
        'offset', 0, 2147483647 )
        if ( defined $offset && ( $offset < 0 || $offset > 2147483647 ) );

    1;
}

# MT::App::CMS

sub load_entry_prefs {
    MT::App::CMS::load_entry_prefs(@_);
}

sub _parse_entry_prefs {
    MT::App::CMS::_parse_entry_prefs(@_);
}

sub validate_magic {
    my ($app) = @_;
    return $app->user && $app->user->id;
}

1;
__END__

=head1 NAME

MT::App::DataAPI

=head1 SYNOPSIS

    use MT::App::DataAPI;
    MT::DataAPI->current_endpoint;

=head1 DESCRIPTION

The I<MT::App::DataAPI> module is the application module for providing Data API.
This module provide the REST interface that is used to
manage blogs, entries, comments, trackbacks, templates, etc.

=head1 METHODS

=head2 MT::App::DataAPI->endpoints($version)

Returns the compiled endpoints data for specified $version.
The compiled endpoints data contains the following three type of values.

=over 4

=item hash

A hash map of ID-endpoint.

=item tree

A data of a tree structure built with the path of the I<route>

=item list

A list.

=back

=head2 MT::App::DataAPI->DEFAULT_VERSION

Returns the default version number.

=head2 MT::App::DataAPI->current_endpoint

Returns an endpoint of current request.

=head2 MT::App::DataAPI->current_api_version

Returns API version of current request.

=head2 MT::App::DataAPI->find_endpoint_by_id($version, $id)

Returns an endpoint whose ID is $id.

=head2 MT::App::DataAPI->find_endpoints_by_path($version, $path)

Returns all endpoints related to C<$path>.

=head2 MT::App::DataAPI->find_endpoint_by_path($verb, $version, $path)

Returns an endpoints related to C<$path> and C<$verb>.

=head2 MT::App::DataAPI->endpoint_url($endpoint[, $params])

Returns an URL for specified endpoint.

Both endpoint data and ID can be specified as C<$endpoint>.
If ID is specified, find endpoint by L<MT::App::DataAPI-E<gt>find_endpoint_by_id> with L<MT::App::DataAPI-E<gt>current_api_version>.

C<$params> is query parameter to a endpoint.

=head2 MT::App::DataAPI->current_format

Returns a format of current request.

=head2 MT::App::DataAPI->current_error_format

Returns a format to return error of current request.

=head2 MT::App::DataAPI->resource_object($name[, $original])

Returns an object that restored from request data.

C<$original> is optional parameter. The result object is cloned from C<$original>, then be overwritten by data that is restored from request.

=head2 MT::App::DataAPI->object_to_resource($objects[, $fields]);

Any data can be specified as C<$objects>.
If C<$objects> is a L<MT::Object>, converted to resource via L<MT::DataAPI::Resource-E<gt>from_object>.

=head2 $app->mt_authorization_data

Returns a hash map which extracted I<X-MT-Authorization> request header.

=head2 MT::App::DataAPI->current_client_id

Returns a client ID of current request.

=head2 MT::App::DataAPI->purge_session_records

Purge DataAPI's session records.

=head2 $app->error($message[, $code])

Set a error message and status code.

If only C<$message> is specified, simplly will be set error message to C<$app>,
If C<$code> is specified with C<$message>, will be set status code for response.
If only C<$code> is specified, will be set status code for response .

    $app->error( 'Invalid request'Bad Request', 400 );
    $app->error( 400 );

=head2 $app->print_error($message, $status[, $data]])

Print error message immediately.

If C<$message> is empty, C<$message> is automatically set up by C<$status>.

If C<$data> is specifyed, C<$data> will be printed as an optional data.

=head2 $app->set_next_phase_url($url)

Set an URL for redirecting to next phase.

=cut
