# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::v4;

use warnings;
use strict;

sub endpoints {
    [
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
            error_codes => {
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
            error_codes => {
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
            error_codes => {
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
            error_codes => {
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
            error_codes => {
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
            error_codes => {
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
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v4 - Movable Type class for v4 endpoint definition.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
