# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
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

sub id {'data_api'}

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
    my $pkg = '$Core::MT::DataAPI::Endpoint::';
    return [
        # version 1
        {   id             => 'list_endpoints',
            route          => '/endpoints',
            version        => 1,
            handler        => "${pkg}Util::endpoints",
            requires_login => 0,
        },
        {   id             => 'authorize',
            route          => '/authorization',
            version        => 1,
            handler        => "${pkg}Auth::authorization",
            format         => 'html',
            requires_login => 0,
        },
        {   id             => 'authenticate',
            route          => '/authentication',
            verb           => 'POST',
            version        => 1,
            handler        => "${pkg}Auth::authentication",
            requires_login => 0,
        },
        {   id             => 'get_token',
            route          => '/token',
            verb           => 'POST',
            version        => 1,
            handler        => "${pkg}Auth::token",
            requires_login => 0,
        },
        {   id             => 'revoke_authentication',
            route          => '/authentication',
            verb           => 'DELETE',
            version        => 1,
            handler        => "${pkg}Auth::revoke_authentication",
            requires_login => 0,
        },
        {   id      => 'revoke_token',
            route   => '/token',
            verb    => 'DELETE',
            version => 1,
            handler => "${pkg}Auth::revoke_token",
        },
        {   id          => 'get_user',
            route       => '/users/:user_id',
            version     => 1,
            handler     => "${pkg}User::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested user.',
            },
            requires_login => 0,
        },
        {   id          => 'update_user',
            route       => '/users/:user_id',
            resources   => ['user'],
            verb        => 'PUT',
            version     => 1,
            handler     => "${pkg}User::update",
            error_codes => {
                403 => 'Do not have permission to update the requested user.',
            },
        },
        {   id             => 'list_blogs_for_user',
            route          => '/users/:user_id/sites',
            version        => 1,
            handler        => "${pkg}Blog::list",
            default_params => {
                limit     => 25,
                offset    => 0,
                sortBy    => 'name',
                sortOrder => 'ascend',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of blogs.',
            },
            requires_login => 0,
        },
        {   id          => 'get_blog',
            route       => '/sites/:blog_id',
            version     => 1,
            handler     => "${pkg}Blog::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested blog.',
            },
            requires_login => 0,
        },
        {   id             => 'list_entries',
            route          => '/sites/:site_id/entries',
            verb           => 'GET',
            version        => 1,
            handler        => "${pkg}Entry::list",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'authored_on',
                sortOrder    => 'descend',
                searchFields => 'title,body,more,keywords,excerpt,basename',
                filterKeys   => 'status',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested entries.',
            },
            requires_login => 0,
        },
        {   id        => 'create_entry',
            route     => '/sites/:site_id/entries',
            resources => ['entry'],
            verb      => 'POST',
            version   => 1,
            handler   => "${pkg}Entry::create",
            default_params => { save_revision => 1, },
            error_codes =>
                { 403 => 'Do not have permission to create an entry.', },
        },
        {   id          => 'get_entry',
            route       => '/sites/:site_id/entries/:entry_id',
            version     => 1,
            handler     => "${pkg}Entry::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested entry.',
            },
            requires_login => 0,
        },
        {   id        => 'update_entry',
            route     => '/sites/:site_id/entries/:entry_id',
            resources => ['entry'],
            verb      => 'PUT',
            version   => 1,
            handler   => "${pkg}Entry::update",
            default_params => { save_revision => 1, },
            error_codes =>
                { 403 => 'Do not have permission to update an entry.', },
        },
        {   id      => 'delete_entry',
            route   => '/sites/:site_id/entries/:entry_id',
            verb    => 'DELETE',
            version => 1,
            handler => "${pkg}Entry::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete an entry.', },
        },
        {   id             => 'list_categories',
            route          => '/sites/:site_id/categories',
            verb           => 'GET',
            version        => 1,
            handler        => "${pkg}Category::list",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'user_custom',
                sortOrder    => 'ascend',
                searchFields => 'label,basename',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of categories.',
            },
            requires_login => 0,
        },
        {   id             => 'list_comments',
            route          => '/sites/:site_id/comments',
            verb           => 'GET',
            version        => 1,
            handler        => "${pkg}Comment::list",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'id',
                sortOrder    => 'descend',
                searchFields => 'body',
                filterKeys   => 'status,entryStatus',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of comments.',
            },
            requires_login => 0,
        },
        {   id             => 'list_comments_for_entry',
            route          => '/sites/:site_id/entries/:entry_id/comments',
            verb           => 'GET',
            version        => 1,
            handler        => "${pkg}Comment::list_for_entry",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'id',
                sortOrder    => 'descend',
                searchFields => 'body',
                filterKeys   => 'status',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of comments.',
            },
            requires_login => 0,
        },
        {   id        => 'create_comment',
            route     => '/sites/:site_id/entries/:entry_id/comments',
            resources => ['comment'],
            verb      => 'POST',
            version   => 1,
            handler   => "${pkg}Comment::create",
            error_codes =>
                { 403 => 'Do not have permission to create a comment.', },
        },
        {   id => 'create_reply_comment',
            route =>
                '/sites/:site_id/entries/:entry_id/comments/:comment_id/replies',
            resources   => ['comment'],
            verb        => 'POST',
            version     => 1,
            handler     => "${pkg}Comment::create_reply",
            error_codes => {
                403 =>
                    'Do not have permission to create a reply to the requested comment.',
            },
        },
        {   id          => 'get_comment',
            route       => '/sites/:site_id/comments/:comment_id',
            version     => 1,
            handler     => "${pkg}Comment::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested comment.',
            },
            requires_login => 0,
        },
        {   id        => 'update_comment',
            route     => '/sites/:site_id/comments/:comment_id',
            resources => ['comment'],
            verb      => 'PUT',
            version   => 1,
            handler   => "${pkg}Comment::update",
            error_codes =>
                { 403 => 'Do not have permission to update a comment.', },
        },
        {   id      => 'delete_comment',
            route   => '/sites/:site_id/comments/:comment_id',
            verb    => 'DELETE',
            version => 1,
            handler => "${pkg}Comment::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete a comment.', },
        },
        {   id             => 'list_trackbacks',
            route          => '/sites/:site_id/trackbacks',
            verb           => 'GET',
            version        => 1,
            handler        => "${pkg}Trackback::list",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'id',
                sortOrder    => 'descend',
                searchFields => 'title,excerpt,blogName',
                filterKeys   => 'status',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of trackbacks.',
            },
            requires_login => 0,
        },
        {   id             => 'list_trackbacks_for_entry',
            route          => '/sites/:site_id/entries/:entry_id/trackbacks',
            verb           => 'GET',
            version        => 1,
            handler        => "${pkg}Trackback::list_for_entry",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'id',
                sortOrder    => 'descend',
                searchFields => 'title,excerpt,blogName',
                filterKeys   => 'status',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of trackbacks.',
            },
            requires_login => 0,
        },
        {   id          => 'get_trackback',
            route       => '/sites/:site_id/trackbacks/:ping_id',
            version     => 1,
            handler     => "${pkg}Trackback::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested trackback.',
            },
            requires_login => 0,
        },
        {   id        => 'update_trackback',
            route     => '/sites/:site_id/trackbacks/:ping_id',
            resources => ['trackback'],
            verb      => 'PUT',
            version   => 1,
            handler   => "${pkg}Trackback::update",
            error_codes =>
                { 403 => 'Do not have permission to update a trackback.', },
        },
        {   id      => 'delete_trackback',
            route   => '/sites/:site_id/trackbacks/:ping_id',
            verb    => 'DELETE',
            version => 1,
            handler => "${pkg}Trackback::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete a trackback.', },
        },
        {   id             => 'upload_asset',
            route          => '/sites/:site_id/assets/upload',
            verb           => 'POST',
            version        => 1,
            handler        => "${pkg}Asset::upload",
            default_params => {
                autoRenameIfExists   => 0,
                normalizeOrientation => 1,
            },
            error_codes => { 403 => 'Do not have permission to upload.', },
        },
        {   id             => 'list_permissions_for_user',
            route          => '/users/:user_id/permissions',
            version        => 1,
            handler        => "${pkg}Permission::list",
            default_params => {
                limit      => 25,
                offset     => 0,
                sortBy     => 'blog_id',
                sortOrder  => 'ascend',
                filterKeys => 'blogIds',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested user\'s permissions.',
            },
        },
        {   id      => 'publish_entries',
            route   => '/publish/entries',
            verb    => 'GET',
            version => 1,
            handler => "${pkg}Publish::entries",
            error_codes => { 403 => 'Do not have permission to publish.', },
        },
        {   id      => 'get_stats_provider',
            route   => '/sites/:site_id/stats/provider',
            version => 1,
            handler => "${pkg}Stats::provider",
        },
        {   id      => 'list_stats_pageviews_for_path',
            route   => '/sites/:site_id/stats/path/pageviews',
            version => 1,
            handler => "${pkg}Stats::pageviews_for_path",
        },
        {   id      => 'list_stats_visits_for_path',
            route   => '/sites/:site_id/stats/path/visits',
            version => 1,
            handler => "${pkg}Stats::visits_for_path",
        },
        {   id      => 'list_stats_pageviews_for_date',
            route   => '/sites/:site_id/stats/date/pageviews',
            version => 1,
            handler => "${pkg}Stats::pageviews_for_date",
        },
        {   id      => 'list_stats_visits_for_date',
            route   => '/sites/:site_id/stats/date/visits',
            version => 1,
            handler => "${pkg}Stats::visits_for_date",
        },

        # version 2
        # category endpoints
        {   id             => 'list_categories',
            route          => '/sites/:site_id/categories',
            verb           => 'GET',
            version        => 2,
            handler        => "${pkg}Category::v2::list",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'user_custom',
                sortOrder    => 'ascend',
                searchFields => 'label,basename',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of categories.',
            },
            requires_login => 0,
        },
        {   id          => 'list_parent_categories',
            route       => '/sites/:site_id/categories/:category_id/parents',
            verb        => 'GET',
            version     => 2,
            handler     => "${pkg}Category::v2::list_parents",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of categories.',
            },
            requires_login => 0,
        },
        {   id      => 'list_sibling_categories',
            route   => '/sites/:site_id/categories/:category_id/siblings',
            verb    => 'GET',
            version => 2,
            handler => "${pkg}Category::v2::list_siblings",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'user_custom',
                sortOrder    => 'ascend',
                searchFields => 'label,basename',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of categories.',
            },
            requires_login => 0,
        },
        {   id          => 'list_child_categories',
            route       => '/sites/:site_id/categories/:category_id/children',
            verb        => 'GET',
            version     => 2,
            handler     => "${pkg}Category::v2::list_children",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of categories.',
            },
            requires_login => 0,
        },
        {   id        => 'create_category',
            route     => '/sites/:site_id/categories',
            resources => ['category'],
            verb      => 'POST',
            version   => 2,
            handler   => "${pkg}Category::v2::create",
            error_codes =>
                { 403 => 'Do not have permission to create a category.', },
        },
        {   id          => 'get_category',
            route       => '/sites/:site_id/categories/:category_id',
            version     => 2,
            handler     => "${pkg}Category::v2::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested category.',
            },
            requires_login => 0,
        },
        {   id        => 'update_category',
            route     => '/sites/:site_id/categories/:category_id',
            resources => ['category'],
            verb      => 'PUT',
            version   => 2,
            handler   => "${pkg}Category::v2::update",
            error_codes =>
                { 403 => 'Do not have permission to update a category.', },
        },
        {   id      => 'delete_category',
            route   => '/sites/:site_id/categories/:category_id',
            verb    => 'DELETE',
            version => 2,
            handler => "${pkg}Category::v2::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete a category.', },
        },

        # folder endpoints
        {   id             => 'list_folders',
            route          => '/sites/:site_id/folders',
            verb           => 'GET',
            version        => 2,
            handler        => "${pkg}Folder::v2::list",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'user_custom',
                sortOrder    => 'ascend',
                searchFields => 'label,basename',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of folders.',
            },
            requires_login => 0,
        },
        {   id          => 'list_parent_folders',
            route       => '/sites/:site_id/folders/:folder_id/parents',
            verb        => 'GET',
            version     => 2,
            handler     => "${pkg}Folder::v2::list_parents",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of folders.',
            },
            requires_login => 0,
        },
        {   id             => 'list_sibling_folders',
            route          => '/sites/:site_id/folders/:folder_id/siblings',
            verb           => 'GET',
            version        => 2,
            handler        => "${pkg}Folder::v2::list_siblings",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'user_custom',
                sortOrder    => 'ascend',
                searchFields => 'label,basename',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of folders.',
            },
            requires_login => 0,
        },
        {   id          => 'list_child_folders',
            route       => '/sites/:site_id/folders/:folder_id/children',
            verb        => 'GET',
            version     => 2,
            handler     => "${pkg}Folder::v2::list_children",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of folders.',
            },
            requires_login => 0,
        },
        {   id        => 'create_folder',
            route     => '/sites/:site_id/folders',
            resources => ['folder'],
            verb      => 'POST',
            version   => 2,
            handler   => "${pkg}Folder::v2::create",
            error_codes =>
                { 403 => 'Do not have permission to create a folder.', },
        },
        {   id          => 'get_folder',
            route       => '/sites/:site_id/folders/:folder_id',
            version     => 2,
            handler     => "${pkg}Folder::v2::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested folder.',
            },
            requires_login => 0,
        },
        {   id        => 'update_folder',
            route     => '/sites/:site_id/folders/:folder_id',
            resources => ['folder'],
            verb      => 'PUT',
            version   => 2,
            handler   => "${pkg}Folder::v2::update",
            error_codes =>
                { 403 => 'Do not have permission to update a folder.', },
        },
        {   id      => 'delete_folder',
            route   => '/sites/:site_id/folders/:folder_id',
            verb    => 'DELETE',
            version => 2,
            handler => "${pkg}Folder::v2::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete a folder.', },
        },

        # asset endpoints
        {   id             => 'list_assets',
            route          => '/sites/:site_id/assets',
            verb           => 'GET',
            version        => 2,
            handler        => "${pkg}Asset::v2::list",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'id',
                sortOrder    => 'descend',
                searchFields => 'label',
                filterKeys   => 'class',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested assets.',
            },
            requires_login => 0,
        },
        {   id             => 'list_all_assets',
            route          => '/assets',
            verb           => 'GET',
            version        => 2,
            handler        => "${pkg}Asset::v2::list",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'id',
                sortOrder    => 'descend',
                searchFields => 'label',
                filterKeys   => 'class',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested assets.',
            },
            requires_login => 0,
        },
        {   id             => 'upload_asset_v2',
            route          => '/assets/upload',
            verb           => 'POST',
            version        => 2,
            handler        => "${pkg}Asset::v2::upload",
            default_params => {
                autoRenameIfExists   => 0,
                normalizeOrientation => 1,
            },
            error_codes => { 403 => 'Do not have permission to upload.', },
        },
        {   id      => 'list_entries_for_category',
            route   => '/sites/:site_id/categories/:category_id/entries',
            verb    => 'GET',
            version => 2,
            handler => "${pkg}Entry::v2::list_for_category",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'authored_on',
                sortOrder    => 'descend',
                searchFields => 'title,body,more,keywords,excerpt,basename',
                filterKeys   => 'status',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of entries.',
            },
            requires_login => 0,
        },
        {   id             => 'list_entries_for_asset',
            route          => '/sites/:site_id/assets/:asset_id/entries',
            verb           => 'GET',
            version        => 2,
            handler        => "${pkg}Entry::v2::list_for_asset",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'authored_on',
                sortOrder    => 'descend',
                searchFields => 'title,body,more,keywords,excerpt,basename',
                filterKeys   => 'status',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of entries.',
            },
            requires_login => 0,
        },
        {   id          => 'get_asset',
            route       => '/sites/:site_id/assets/:asset_id',
            version     => 2,
            handler     => "${pkg}Asset::v2::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested asset.',
            },
            requires_login => 0,
        },
        {   id        => 'update_asset',
            route     => '/sites/:site_id/assets/:asset_id',
            resources => ['asset'],
            verb      => 'PUT',
            version   => 2,
            handler   => "${pkg}Asset::v2::update",
            error_codes =>
                { 403 => 'Do not have permission to update an asset.', },
        },
        {   id      => 'delete_asset',
            route   => '/sites/:site_id/assets/:asset_id',
            verb    => 'DELETE',
            version => 2,
            handler => "${pkg}Asset::v2::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete an asset.', },
        },
        {   id          => 'get_thumbnail',
            route       => '/sites/:site_id/assets/:asset_id/thumbnail',
            version     => 2,
            handler     => "${pkg}Asset::v2::get_thumbnail",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested thumbnail.',
            },
            requires_login => 0,
        },

        # entry endpoints
        {   id        => 'create_entry',
            route     => '/sites/:site_id/entries',
            resources => ['entry'],
            verb      => 'POST',
            version   => 2,
            handler   => "${pkg}Entry::v2::create",
            default_params => { save_revision => 1, },
            error_codes =>
                { 403 => 'Do not have permission to create an entry.', },
        },
        {   id        => 'update_entry',
            route     => '/sites/:site_id/entries/:entry_id',
            resources => ['entry'],
            verb      => 'PUT',
            version   => 2,
            handler   => "${pkg}Entry::v2::update",
            default_params => { save_revision => 1, },
            error_codes =>
                { 403 => 'Do not have permission to update an entry.', },
        },
        {   id             => 'list_categories_for_entry',
            route          => '/sites/:site_id/entries/:entry_id/categories',
            verb           => 'GET',
            version        => 2,
            handler        => "${pkg}Category::v2::list_for_entry",
            default_params => {
                limit        => 10,
                offset       => 0,
                searchFields => 'label,basename',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested categories for entry.',
            },
            requires_login => 0,
        },
        {   id             => 'list_assets_for_entry',
            route          => '/sites/:site_id/entries/:entry_id/assets',
            verb           => 'GET',
            version        => 2,
            handler        => "${pkg}Asset::v2::list_for_entry",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'id',
                sortOrder    => 'descend',
                searchFields => 'label',
                filterKeys   => 'class',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested assets for entry.',
            },
            requires_login => 0,
        },
        {   id             => 'list_trackbacks_for_page',
            route          => '/sites/:site_id/pages/:page_id/trackbacks',
            verb           => 'GET',
            version        => 2,
            handler        => "${pkg}Trackback::list_for_entry",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'id',
                sortOrder    => 'descend',
                searchFields => 'title,excerpt,blogName',
                filterKeys   => 'status',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of trackbacks.',
            },
            requires_login => 0,
        },

        # page endpoints
        {   id             => 'list_pages',
            route          => '/sites/:site_id/pages',
            verb           => 'GET',
            version        => 2,
            handler        => "${pkg}Page::v2::list",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'authored_on',
                sortOrder    => 'descend',
                searchFields => 'title,body,more,keywords,excerpt,basename',
                filterKeys   => 'status',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested pages.',
            },
            requires_login => 0,
        },
        {   id        => 'create_page',
            route     => '/sites/:site_id/pages',
            resources => ['page'],
            verb      => 'POST',
            version   => 2,
            handler   => "${pkg}Page::v2::create",
            default_params => { save_revision => 1, },
            error_codes =>
                { 403 => 'Do not have permission to create a page.', },
        },
        {   id          => 'get_page',
            route       => '/sites/:site_id/pages/:page_id',
            version     => 1,
            handler     => "${pkg}Page::v2::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested page.',
            },
            requires_login => 0,
        },
        {   id        => 'update_page',
            route     => '/sites/:site_id/pages/:page_id',
            resources => ['page'],
            verb      => 'PUT',
            version   => 2,
            handler   => "${pkg}Page::v2::update",
            default_params => { save_revision => 1, },
            error_codes =>
                { 403 => 'Do not have permission to update a page.', },
        },
        {   id      => 'delete_page',
            route   => '/sites/:site_id/pages/:page_id',
            verb    => 'DELETE',
            version => 2,
            handler => "${pkg}Page::v2::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete a page.', },
        },
        {   id             => 'list_assets_for_page',
            route          => '/sites/:site_id/pages/:page_id/assets',
            verb           => 'GET',
            version        => 2,
            handler        => "${pkg}Asset::v2::list_for_page",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'id',
                sortOrder    => 'descend',
                searchFields => 'label',
                filterKeys   => 'class',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested assets for page.',
            },
            requires_login => 0,
        },
        {   id             => 'list_comments_for_page',
            route          => '/sites/:site_id/pages/:page_id/comments',
            verb           => 'GET',
            version        => 2,
            handler        => "${pkg}Comment::list_for_entry",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'id',
                sortOrder    => 'descend',
                searchFields => 'body',
                filterKeys   => 'status',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of comments.',
            },
            requires_login => 0,
        },

        # site endpoints
        {   id             => 'list_sites',
            route          => '/sites',
            verb           => 'GET',
            version        => 2,
            handler        => "${pkg}Blog::v2::list",
            default_params => {
                limit        => 25,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of blogs.',
            },
            requires_login => 0,
        },
        {   id             => 'list_sites_by_parent',
            route          => '/sites/:site_id/children',
            verb           => 'GET',
            version        => 2,
            handler        => "${pkg}Blog::v2::list_by_parent",
            default_params => {
                limit        => 25,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of blogs.',
            },
            requires_login => 0,
        },
        {   id        => 'insert_new_blog',
            route     => '/sites/:site_id',
            resources => ['blog'],
            verb      => 'POST',
            version   => 2,
            handler   => "${pkg}Blog::v2::insert_new_blog",
            error_codes =>
                { 403 => 'Do not have permission to create a blog.', },
        },
        {   id        => 'insert_new_website',
            route     => '/sites',
            resources => ['website'],
            verb      => 'POST',
            version   => 2,
            handler   => "${pkg}Blog::v2::insert_new_website",
            error_codes =>
                { 403 => 'Do not have permission to create a website.', },
        },
        {   id      => 'update_site',
            route   => '/sites/:site_id',
            verb    => 'PUT',
            version => 2,
            handler => "${pkg}Blog::v2::update",
            error_codes =>
                { 403 => 'Do not have permission to update a site.', },
        },
        {   id      => 'delete_site',
            route   => '/sites/:site_id',
            verb    => 'DELETE',
            version => 2,
            handler => "${pkg}Blog::v2::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete a site.', },
        },

        # role endpoints
        {   id             => 'list_roles',
            route          => '/roles',
            verb           => 'GET',
            version        => 2,
            handler        => "${pkg}Role::v2::list",
            default_params => {
                limit        => 25,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of roles.',
            },
        },
        {   id        => 'create_role',
            route     => '/roles',
            resources => ['role'],
            verb      => 'POST',
            version   => 2,
            handler   => "${pkg}Role::v2::create",
            error_codes =>
                { 403 => 'Do not have permission to create a role.', },
        },
        {   id      => 'get_role',
            route   => '/roles/:role_id',
            version => 2,
            handler => "${pkg}Role::v2::get",
            error_codes =>
                { 403 => 'Do not have permission to create a role.', },
        },
        {   id          => 'update_role',
            route       => '/roles/:role_id',
            resources   => ['role'],
            verb        => 'PUT',
            version     => 2,
            handler     => "${pkg}Role::v2::update",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested role.',
            },
        },
        {   id      => 'delete_role',
            route   => '/roles/:role_id',
            verb    => 'DELETE',
            version => 2,
            handler => "${pkg}Role::v2::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete a role.', },
        },

        # permission endpoints
        {   id             => 'list_permissions',
            route          => '/permissions',
            version        => 2,
            handler        => "${pkg}Permission::v2::list",
            default_params => {
                limit      => 25,
                offset     => 0,
                sortBy     => 'blog_id',
                sortOrder  => 'ascend',
                filterKeys => 'blogIds',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of permissions.',
            },
        },
        {
            # update
            id             => 'list_permissions_for_user',
            route          => '/users/:user_id/permissions',
            version        => 2,
            handler        => "${pkg}Permission::v2::list_for_user",
            default_params => {
                limit      => 25,
                offset     => 0,
                sortBy     => 'blog_id',
                sortOrder  => 'ascend',
                filterKeys => 'blogIds',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested user\'s permissions.',
            },
        },
        {   id             => 'list_permissions_for_site',
            route          => '/sites/:site_id/permissions',
            version        => 2,
            handler        => "${pkg}Permission::v2::list_for_site",
            default_params => {
                limit     => 25,
                offset    => 0,
                sortBy    => 'blog_id',
                sortOrder => 'ascend',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of permissions.',
            },
        },
        {   id             => 'list_permissions_for_role',
            route          => '/roles/:role_id/permissions',
            version        => 2,
            handler        => "${pkg}Permission::v2::list_for_role",
            default_params => {
                limit      => 25,
                offset     => 0,
                sortBy     => 'blog_id',
                sortOrder  => 'ascend',
                filterKeys => 'blogIds',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of permissions.',
            },
        },
        {   id      => 'grant_permission_to_site',
            route   => '/sites/:site_id/permissions/grant',
            verb    => 'POST',
            version => 2,
            handler => "${pkg}Permission::v2::grant_to_site",
            error_codes =>
                { 403 => 'Do not have permission to grant a permission', },
        },
        {   id      => 'grant_permission_to_user',
            route   => '/users/:user_id/permissions/grant',
            verb    => 'POST',
            version => 2,
            handler => "${pkg}Permission::v2::grant_to_user",
            error_codes =>
                { 403 => 'Do not have permission to grant a permission', },
        },
        {   id      => 'revoke_permission_from_site',
            route   => '/sites/:site_id/permissions/revoke',
            verb    => 'POST',
            version => 2,
            handler => "${pkg}Permission::v2::revoke_from_site",
            error_codes =>
                { 403 => 'Do not have permission to revoke a permission', },
        },
        {   id      => 'revoke_permission_from_user',
            route   => '/users/:user_id/permissions/revoke',
            verb    => 'POST',
            version => 2,
            handler => "${pkg}Permission::v2::revoke_from_user",
            error_codes =>
                { 403 => 'Do not have permission to revoke a permission', },
        },

        # search endpoints
        {   id      => 'search',
            route   => '/search',
            version => 2,
            handler => "${pkg}Search::v2::search",
            error_codes =>
                { 403 => 'Do not have permission to search objects', },
            requires_login => 0,
        },

        # log endpoints
        {   id             => 'list_logs',
            route          => '/sites/:site_id/logs',
            version        => 2,
            handler        => "${pkg}Log::v2::list",
            default_params => {
                limit     => 25,
                offset    => 0,
                sortBy    => 'created_on',
                sortOrder => 'descend',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of activity logs.',
            },
            requires_login => 0,
        },
        {   id          => 'get_log',
            route       => '/sites/:site_id/logs/:log_id',
            version     => 2,
            handler     => "${pkg}Log::v2::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested log.',
            },
            requires_login => 0,
        },
        {   id      => 'create_log',
            route   => '/sites/:site_id/logs',
            verb    => 'POST',
            version => 2,
            handler => "${pkg}Log::v2::create",
            error_codes =>
                { 403 => 'Do not have permission to create a log.', },
        },
        {   id      => 'update_log',
            route   => '/sites/:site_id/logs/:log_id',
            verb    => 'PUT',
            version => 2,
            handler => "${pkg}Log::v2::update",
            error_codes =>
                { 403 => 'Do not have permission to update a log.', },
        },
        {   id      => 'delete_log',
            route   => '/sites/:site_id/logs/:log_id',
            verb    => 'DELETE',
            version => 2,
            handler => "${pkg}Log::v2::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete a log.', },
        },
        {   id      => 'reset_logs',
            route   => '/sites/:site_id/logs',
            verb    => 'DELETE',
            version => 2,
            handler => "${pkg}Log::v2::reset",
            error_codes =>
                { 403 => 'Do not have permission to reset logs.', },
        },

        # tag endpoints
        {   id             => 'list_tags',
            route          => '/tags',
            version        => 2,
            default_params => {
                limit        => 25,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name',
            },
            handler     => "${pkg}Tag::v2::list",
            error_codes => {
                403 => 'Do not have permission to retrieve the list of tags.',
            },
            requires_login => 0,
        },
        {   id             => 'list_tags_for_site',
            route          => '/sites/:site_id/tags',
            version        => 2,
            default_params => {
                limit        => 25,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name',
            },
            handler     => "${pkg}Tag::v2::list_for_site",
            error_codes => {
                403 => 'Do not have permission to retrieve the list of tags.',
            },
            requires_login => 0,
        },
        {   id          => 'get_tag',
            route       => '/tags/:tag_name',
            version     => 2,
            handler     => "${pkg}Tag::v2::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested tag.',
            },
            requires_login => 0,
        },
        {   id          => 'get_tag_for_site',
            route       => '/sites/:site_id/tags/:tag_name',
            version     => 2,
            handler     => "${pkg}Tag::v2::get_for_site",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested tag.',
            },
            requires_login => 0,
        },
        {   id      => 'rename_tag',
            route   => '/tags/:tag_name',
            verb    => 'PUT',
            version => 2,
            handler => "${pkg}Tag::v2::rename",
            error_codes =>
                { 403 => 'Do not have permission to rename a tag.', },
        },
        {   id      => 'rename_tag_for_site',
            route   => '/sites/:site_id/tags/:tag_name',
            verb    => 'PUT',
            version => 2,
            handler => "${pkg}Tag::v2::rename_for_site",
            error_codes =>
                { 403 => 'Do not have permission to rename a tag.', },
        },
        {   id      => 'delete_tag',
            route   => '/tags/:tag_name',
            verb    => 'DELETE',
            version => 2,
            handler => "${pkg}Tag::v2::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete a tag.', },
        },
        {   id      => 'delete_tag_for_site',
            route   => '/sites/:site_id/tags/:tag_name',
            verb    => 'DELETE',
            version => 2,
            handler => "${pkg}Tag::v2::delete_for_site",
            error_codes =>
                { 403 => 'Do not have permission to delete a tag.', },
        },
        {   id             => 'list_entries_for_tag',
            route          => '/tags/:tag_name/entries',
            version        => 2,
            handler        => "${pkg}Entry::v2::list_for_tag",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'authored_on',
                sortOrder    => 'descend',
                searchFields => 'title,body,more,keywords,excerpt,basename',
                filterKeys   => 'status',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested entries for tag.',
            },
            requires_login => 0,
        },
        {   id             => 'list_entries_for_site_and_tag',
            route          => '/sites/:site_id/tags/:tag_name/entries',
            version        => 2,
            handler        => "${pkg}Entry::v2::list_for_site_and_tag",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'authored_on',
                sortOrder    => 'descend',
                searchFields => 'title,body,more,keywords,excerpt,basename',
                filterKeys   => 'status',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested entries for site and tag.',
            },
            requires_login => 0,
        },
        {   id             => 'list_assets_for_tag',
            route          => '/tags/:tag_name/assets',
            version        => 2,
            handler        => "${pkg}Asset::v2::list_for_tag",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'id',
                sortOrder    => 'descend',
                searchFields => 'label',
                filterKeys   => 'class',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested assets for tag.',
            },
            requires_login => 0,
        },
        {   id             => 'list_assets_for_site_and_tag',
            route          => '/sites/:site_id/tags/:tag_name/assets',
            version        => 2,
            handler        => "${pkg}Asset::v2::list_for_site_and_tag",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'id',
                sortOrder    => 'descend',
                searchFields => 'label',
                filterKeys   => 'class',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested assets for site and tag.',
            },
            requires_login => 0,
        },

        # theme endpoints
        {   id          => 'list_themes',
            route       => '/themes',
            version     => 2,
            handler     => "${pkg}Theme::v2::list",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested themes.',
            },
        },
        {   id          => 'list_themes_for_site',
            route       => '/sites/:site_id/themes',
            version     => 2,
            handler     => "${pkg}Theme::v2::list_for_site",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested site\'s themes.',
            },
        },
        {   id          => 'get_theme',
            route       => '/themes/:theme_id',
            version     => 2,
            handler     => "${pkg}Theme::v2::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested theme.',
            },
        },
        {   id          => 'get_theme_for_site',
            route       => '/sites/:site_id/themes/:theme_id',
            version     => 2,
            handler     => "${pkg}Theme::v2::get_for_site",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested site\'s theme.',
            },
        },
        {   id          => 'apply_theme_to_site',
            route       => '/sites/:site_id/themes/:theme_id/apply',
            verb        => 'POST',
            version     => 2,
            handler     => "${pkg}Theme::v2::apply",
            error_codes => {
                403 =>
                    'Do not have permission to apply the requested theme to site.',
            },
        },
        {   id          => 'refresh_templates_for_site',
            route       => '/sites/:site_id/refresh_templates',
            verb        => 'POST',
            version     => 2,
            handler     => "${pkg}Theme::v2::refresh_templates",
            error_codes => {
                403 =>
                    'Do not have permission to refresh templates of the request site.',
            },
        },
        {   id          => 'uninstall_theme',
            route       => '/themes/:theme_id',
            verb        => 'DELETE',
            version     => 2,
            handler     => "${pkg}Theme::v2::uninstall",
            error_codes => {
                403 =>
                    'Do not have permission to uninstall the requested theme.',
            },
        },
        {   id          => 'export_site_theme',
            route       => '/sites/:site_id/export_theme',
            verb        => 'POST',
            version     => 2,
            handler     => "${pkg}Theme::v2::export",
            error_codes => {
                403 =>
                    'Do not have permission to export the requested theme.',
            },
        },

        # template endpoints
        {   id             => 'list_templates',
            route          => '/sites/:site_id/templates',
            version        => 2,
            handler        => "${pkg}Template::v2::list",
            default_params => {
                limit  => 10,
                offset => 0,

                #    sortBy       => 'name',
                #    sortOrder    => 'ascend',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of templates.',
            },
        },
        {   id          => 'get_template',
            route       => '/sites/:site_id/templates/:template_id',
            version     => 2,
            handler     => "${pkg}Template::v2::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested template.',
            },
        },
        {   id      => 'create_template',
            route   => '/sites/:site_id/templates',
            verb    => 'POST',
            version => 2,
            handler => "${pkg}Template::v2::create",
            error_codes =>
                { 403 => 'Do not have permission to create a template.', },
        },
        {   id      => 'update_template',
            route   => '/sites/:site_id/templates/:template_id',
            verb    => 'PUT',
            version => 2,
            handler => "${pkg}Template::v2::update",
            error_codes =>
                { 403 => 'Do not have permission to update a template.', },
        },
        {   id      => 'delete_tempalte',
            route   => '/sites/:site_id/templates/:template_id',
            verb    => 'DELETE',
            version => 2,
            handler => "${pkg}Template::v2::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete a template.', },
        },

        {   id      => 'publish_template',
            route   => '/sites/:site_id/templates/:template_id/publish',
            verb    => 'POST',
            version => 2,
            handler => "${pkg}Template::v2::publish",
            error_codes =>
                { 403 => 'Do not have permission to publish a template.', },
        },
        {   id      => 'refresh_template',
            route   => '/sites/:site_id/templates/:template_id/refresh',
            verb    => 'POST',
            version => 2,
            handler => "${pkg}Template::v2::refresh",
            error_codes =>
                { 403 => 'Do not have permission to refresh a template.', },
        },
        {   id      => 'clone_template',
            route   => '/sites/:site_id/templates/:template_id/clone',
            verb    => 'POST',
            version => 2,
            handler => "${pkg}Template::v2::clone",
            error_codes =>
                { 403 => 'Do not have permission to clone a template.', },
        },

        # templatemap endpoints
        {   id      => 'list_templatemaps',
            route   => '/sites/:site_id/templates/:template_id/templatemaps',
            version => 2,
            handler => "${pkg}TemplateMap::v2::list",
            default_params => {
                limit  => 10,
                offset => 0,
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of templatemaps.',
            },
        },
        {   id => 'get_templatemap',
            route =>
                '/sites/:site_id/templates/:template_id/templatemaps/:templatemap_id',
            version     => 2,
            handler     => "${pkg}TemplateMap::v2::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested templatemap.',
            },
        },
        {   id      => 'create_templatemap',
            route   => '/sites/:site_id/templates/:template_id/templatemaps',
            verb    => 'POST',
            version => 2,
            handler => "${pkg}TemplateMap::v2::create",
            error_codes =>
                { 403 => 'Do not have permission to create a templatemap.', },
        },
        {   id => 'update_templatemap',
            route =>
                '/sites/:site_id/templates/:template_id/templatemaps/:templatemap_id',
            verb    => 'PUT',
            version => 2,
            handler => "${pkg}TemplateMap::v2::update",
            error_codes =>
                { 403 => 'Do not have permission to update a templatemap.', },
        },
        {   id => 'delete_templatemap',
            route =>
                '/sites/:site_id/templates/:template_id/templatemaps/:templatemap_id',
            verb    => 'DELETE',
            version => 2,
            handler => "${pkg}TemplateMap::v2::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete a templatemap.', },
        },

        # widgetset endpoints.
        {   id             => 'list_widgetsets',
            route          => '/sites/:site_id/widgetsets',
            version        => 2,
            handler        => "${pkg}WidgetSet::v2::list",
            default_params => {
                limit  => 25,
                offset => 0,
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of widgetsets.',
            },
        },
        {   id          => 'get_widgetset',
            route       => '/sites/:site_id/widgetsets/:widgetset_id',
            version     => 2,
            handler     => "${pkg}WidgetSet::v2::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested widgetset.',
            },
        },
        {   id      => 'create_widgetset',
            route   => '/sites/:site_id/widgetsets',
            verb    => 'POST',
            version => 2,
            handler => "${pkg}WidgetSet::v2::create",
            error_codes =>
                { 403 => 'Do not have permission to create a widgetset.', },
        },
        {   id      => 'update_widgetset',
            route   => '/sites/:site_id/widgetsets/:widgetset_id',
            verb    => 'PUT',
            version => 2,
            handler => "${pkg}WidgetSet::v2::update",
            error_codes =>
                { 403 => 'Do not have permission to update a widgetset.', },
        },
        {   id      => 'delete_widgetset',
            route   => '/sites/:site_id/widgetsets/:widgetset_id',
            verb    => 'DELETE',
            version => 2,
            handler => "${pkg}WidgetSet::v2::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete a widgetset.', },
        },

        {   id             => 'list_widgets',
            route          => '/sites/:site_id/widgets',
            version        => 2,
            handler        => "${pkg}Widget::v2::list",
            default_params => {
                limit  => 25,
                offset => 0,
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of widgets.',
            },
        },
        {   id          => 'get_widgets',
            route       => '/sites/:site_id/widgets/:widget_id',
            version     => 2,
            handler     => "${pkg}Widget::v2::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested widget.',
            },
        },
        {   id      => 'create_widget',
            route   => '/sites/:site_id/widgets',
            verb    => 'POST',
            version => 2,
            handler => "${pkg}Widget::v2::create",
            error_codes =>
                { 403 => 'Do not have permission to create a widget.', },
        },
        {   id      => 'update_widget',
            route   => '/sites/:site_id/widgets/:widget_id',
            verb    => 'PUT',
            version => 2,
            handler => "${pkg}Widget::v2::update",
            error_codes =>
                { 403 => 'Do not have permission to update a widget.', },
        },
        {   id      => 'delete_widget',
            route   => '/sites/:site_id/widgets/:widget_id',
            verb    => 'DELETE',
            version => 2,
            handler => "${pkg}Widget::v2::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete a widget.', },
        },

        {   id      => 'refresh_widget',
            route   => '/sites/:site_id/widgets/:widget_id/refresh',
            verb    => 'POST',
            version => 2,
            handler => "${pkg}Widget::v2::refresh",
            error_codes =>
                { 403 => 'Do not have permission to refresh a widget.', },
        },
        {   id      => 'clone_widget',
            route   => '/sites/:site_id/widgets/:widget_id/clone',
            verb    => 'POST',
            version => 2,
            handler => "${pkg}Widget::v2::clone",
            error_codes =>
                { 403 => 'Do not have permission to clone a widget.', },
        },

        {   id      => 'list_widgets_for_widgetset',
            route   => '/sites/:site_id/widgetsets/:widgetset_id/widgets',
            version => 2,
            handler => "${pkg}Widget::v2::list_for_widgetset",
            default_params => {
                limit  => 25,
                offset => 0,
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve widgets of the request widgetset.',
            },
        },
        {   id => 'get_widget_for_widgetset',
            route =>
                '/sites/:site_id/widgetsets/:widgetset_id/widgets/:widget_id',
            version     => 2,
            handler     => "${pkg}Widget::v2::get_for_widgetset",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve a widget of the request widgetset.',
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

            # page callbacks
            $pkg
                . 'pre_load_filtered_list.page' =>
                "${pfx}Page::cms_pre_load_filtered_list",
            $pkg . 'list_permission_filter.page' => "${pfx}Page::can_list",
            $pkg . 'view_permission_filter.page' => "${pfx}Page::can_view",

            # user callbacks
            $pkg . 'view_permission_filter.author' => "${pfx}User::can_view",

            # comment callbacks
            $pkg
                . 'view_permission_filter.comment' =>
                "${pfx}Comment::can_view",
            $pkg
                . 'pre_load_filtered_list.comment' =>
                "${pfx}Comment::cms_pre_load_filtered_list",

            # ping callbacks
            $pkg
                . 'view_permission_filter.ping' =>
                "${pfx}Trackback::can_view",
            $pkg
                . 'pre_load_filtered_list.ping' =>
                "${pfx}Trackback::cms_pre_load_filtered_list",

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
            $pkg
                . 'pre_load_filtered_list.log' =>
                "${pfx}Log::cms_pre_load_filtered_list",
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
            $pkg . 'delete_permission_filter.tag' => "${pfx}Tag::can_delete",

            # template callbacks
            $pkg . 'save_filter.template' => "${pfx}Template::save_filter",

            # widget callbacks
            $pkg
                . 'save_permission_filter.widget' =>
                '$Core::MT::CMS::Template::can_save',
            $pkg . 'save_filter.widget' => "${pfx}Widget::save_filter",
            $pkg . 'pre_save.widget' => '$Core::MT::CMS::Template::pre_save',
            $pkg
                . 'post_save.widget' => '$Core::MT::CMS::Template::post:save',

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
                '$Core::MT::CMS::Template::post:save',

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

    if ( UNIVERSAL::can( $res, 'to_resource' ) ) {
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

    my $header
        = $app->get_header('X-MT-Authorization')
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
    my $sess = new MT::Session;
    $sess->id( $app->make_magic_token() );
    $sess->kind( $app->session_kind );
    $sess->start(time);
    $sess->set( 'author_id', $auth->id );
    $sess->set( 'client_id', $app->current_client_id );
    $sess->set( 'remember',  1 ) if $remember;
    $sess->save;
    $sess;
}

sub session_user {
    my $app = shift;
    my ( $author, $session_id, %opt ) = @_;
    return undef unless $author && $session_id;
    if ( $app->{session} ) {
        if ( $app->{session}->get('author_id') == $author->id ) {
            return $author;
        }
    }

    require MT::Session;
    my $timeout
        = $opt{permanent}
        ? ( 360 * 24 * 365 * 10 )
        : $app->config->UserSessionTimeout;
    my $sess = MT::Session::get_unexpired_value(
        $timeout,
        {   id   => $session_id,
            kind => $app->session_kind,
        }
    );
    $app->{session} = $sess;

    return undef if !$sess;
    if ( $sess && ( $sess->get('author_id') == $author->id ) ) {
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

    $app->set_header( 'X-Content-Type' => 'nosniff' );
    $app->set_header( 'Cache-Control'  => 'no-cache' );

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

    if ( my $id = $params->{site_id} ) {
        $app->blog( scalar $app->model('blog')->load($id) )
            or return $app->print_error( 'Site not found', 404 );
        $app->param( 'blog_id', $id );

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
        my $request_param = $app->param->Vars;
        foreach my $k (%$default_params) {
            if ( !exists( $request_param->{$k} ) ) {
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
        || UNIVERSAL::can( $response, 'to_resource' ) )
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

# MT::App::CMS

sub load_entry_prefs {
    MT::App::CMS::load_entry_prefs(@_);
}

sub _parse_entry_prefs {
    MT::App::CMS::_parse_entry_prefs(@_);
}

# MT::App::Search

sub first_blog_id {
    MT::App::Search::first_blog_id(@_);
}

sub generate_cache_keys {
    MT::App::Search::generate_cache_keys(@_);
}

sub init_cache_driver {
    MT::App::Search::init_cache_driver(@_);
}

sub create_blog_list {
    MT::App::Search::create_blog_list(@_);
}

sub throttle_control {
    MT::App::Search::throttle_control(@_);
}

sub throttle_response {
    MT::App::Search::throttle_response(@_);
}

sub check_cache {
    MT::App::Search::check_cache(@_);
}

sub search_terms {
    my ($app) = @_;
    if ( $app->param('tagSearch') ) {
        require MT::App::Search::TagSearch;
        return MT::App::Search::TagSearch::search_terms(@_);
    }
    else {
        return MT::App::Search::search_terms(@_);
    }
}

sub query_parse {
    my ($app) = @_;
    if ( $app->param('freeText') ) {
        require MT::App::Search::FreeText;
        return MT::App::Search::FreeText::query_parse(@_);
    }
    else {
        return MT::App::Search::query_parse(@_);
    }
}

sub _query_parse_core {
    MT::App::Search::_query_parse_core(@_);
}

sub execute {
    MT::App::Search::execute(@_);
}

sub count {
    MT::App::Search::count(@_);
}

sub render {
    my $app = shift;
    my ( $count, $iter ) = @_;

    my @objects;
    if ($iter) {
        while ( my $obj = $iter->() ) {
            push @objects, $obj;
        }
    }

    my $result = {
        totalResults => ( $count || 0 ),
        items => MT::DataAPI::Resource->from_object( \@objects ),
    };

    my $json = $app->current_format->{serialize}->($result);
    return $json;
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
