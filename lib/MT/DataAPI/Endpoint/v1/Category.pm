# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::v1::Category;

use warnings;
use strict;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list_openapi_spec {
    +{
        tags        => ['Categories'],
        summary     => 'Retrieve a list of categories',
        description => 'Retrieve a list of categories.',
        parameters  => [{
                'in'   => 'query',
                name   => 'sortBy',
                schema => {
                    type => 'string',
                    enum => [
                        'user_custom',
                        'label',
                    ],
                },
                description => <<'DESCRIPTION',
This is an optional parameter.

#### user_custom

(default) Sort order you specified on the Manage Categories screen.

#### label

Sort by the label of each categories.
DESCRIPTION
            },
            {
                'in'   => 'query',
                name   => 'sortOrder',
                schema => {
                    type => 'string',
                    enum => [
                        'ascend',
                        'descend',
                    ],
                },
                description => <<'DESCRIPTION',
This is an optional parameter.

#### ascend

(default) Return categories in ascending order.

#### descend

Return categories in descending order.
DESCRIPTION
            },
        ],
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                totalResults => {
                                    type        => 'integer',
                                    description => 'The total number of categories found.',
                                },
                                items => {
                                    type  => 'array',
                                    items => {
                                        '$ref' => '#/components/schemas/category',
                                    }
                                },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Not Found',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

sub list {
    my ( $app, $endpoint ) = @_;

    my $res
        = filtered_list( $app, $endpoint, 'category',
        { category_set_id => 0 } )
        or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v1::Category - Movable Type class for endpoint definitions about the MT::Category.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
