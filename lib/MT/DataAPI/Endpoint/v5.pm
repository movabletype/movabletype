# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::v5;

use warnings;
use strict;

sub endpoints {
    [{
            # The difference between v4 and v5 is that v5 has default_params property.
            # There is no difference in other properties. Therefore handlers use v4 endpoint.
            id              => 'list_category_sets',
            route           => '/sites/:site_id/categorySets',
            version         => 5,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::CategorySet::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v4::CategorySet::list_openapi_spec',
            openapi_options => {
                can_use_access_token   => 1,
                filtered_list_ds_nouns => 'category_set,category_sets',
            },
            default_params => {
                limit        => 25,
                offset       => 0,
                sortBy       => 'name',
                sortOrder    => 'ascend',
                searchFields => 'name',
            },
            error_codes => {
                403 => 'Do not have permission to retrieve the list of category sets.',
            },
            requires_login => 0,
        },
        {
            # The difference between v4 and v5 is that v5 has new openapi_handler property.
            # There is no difference in other properties. Therefore handler uses v4 endpoint.
            id              => 'list_content_data',
            route           => '/sites/:site_id/contentTypes/:content_type_id/data',
            verb            => 'GET',
            version         => 5,
            handler         => '$Core::MT::DataAPI::Endpoint::v4::ContentData::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v5::ContentData::list_openapi_spec',
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
            id              => 'list_text_filters',
            route           => '/textFilters',
            version         => 5,
            handler         => '$Core::MT::DataAPI::Endpoint::v5::TextFilter::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v5::TextFilter::list_openapi_spec',
            requires_login  => 0,
        },
        {
            # The difference between v1 and v5 is that v5 has new openapi_handler property.
            # There is no difference in other properties. Therefore handlers use v1 endpoint.
            id              => 'list_entries',
            route           => '/sites/:site_id/entries',
            verb            => 'GET',
            version         => 5,
            handler         => '$Core::MT::DataAPI::Endpoint::v1::Entry::list',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::v5::Entry::list_openapi_spec',
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
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v5 - Movable Type class for v5 endpoint definition.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
