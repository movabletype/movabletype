# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::v2;

use warnings;
use strict;

sub endpoints {
    [
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
            error_codes => {
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
            error_codes => {
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
            error_codes => {
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
            error_codes => {
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
            error_codes => {
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
            error_codes => {
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
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Asset::upload',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Asset::upload_v2_openapi_spec',
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
            error_codes => {
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
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Blog::get',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Blog::get_openapi_spec',
            openapi_options => {
                can_use_access_token => 1,
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the requested blog.',
            },
            requires_login => 0,
        },
        {
            id              => 'list_blogs_for_user',
            route           => '/users/:user_id/sites',
            version         => 2,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Blog::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v1::Blog::list_openapi_spec',
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
            error_codes => {
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

        # group member
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

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2 - Movable Type class for v2 endpoint definition.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
