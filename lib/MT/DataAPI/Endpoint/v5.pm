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
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v5 - Movable Type class for v5 endpoint definition.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
