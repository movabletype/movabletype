# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::v1::Blog;

use warnings;
use strict;

use MT::DataAPI::Endpoint::Common;

sub list_openapi_spec {
    +{
        tags        => ['Users', 'Sites'],
        summary     => 'Retrieve a list of blogs by user',
        description => 'Retrieve a list of blogs by user.',
        parameters  => [{
                'in'        => 'query',
                name        => 'limit',
                schema      => { type => 'integer' },
                description => 'This is an optional parameter. Maximum number of blogs to retrieve. Default is 25. ',
            },
            {
                'in'        => 'query',
                name        => 'offset',
                schema      => { type => 'integer' },
                description => 'This is an optional parameter. 0-indexed offset. Default is 0.',
            },
            {
                'in'   => 'query',
                name   => 'sortBy',
                schema => {
                    type => 'string',
                    enum => [
                        'name',
                        'created_on',
                    ],
                },
                description => <<'DESCRIPTION',
This is an optional parameter.

#### name

(default) Sort by the name of each blogs.

#### created_on

Sort by the created time of each blogs.
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

(default) Return blogs in ascending order. For the date, it means from oldest to newset.

#### descend

Return blogs in descending order. For the date, it means from newest to oldest.
DESCRIPTION
            },
            {
                'in'        => 'query',
                name        => 'includeIds',
                schema      => { type => 'string' },
                description => 'This is an optional parameter. The comma separated ID list of blogs to include to result. ',
            },
            {
                'in'        => 'query',
                name        => 'excludeIds',
                schema      => { type => 'string' },
                description => 'This is an optional parameter. The comma separated ID list of blogs to exclude from result. ',
            },
            {
                'in'        => 'query',
                name        => 'fields',
                schema      => { type => 'string' },
                description => 'This is an optional parameter. the field list to retrieve as part of the Blogs resource. That list should be separated by comma. If this parameter is not specified, All fields will be returned.',
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
                                    description => 'The total number of blogs found. ',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of Blogs resource. The list will sorted descending by blog name. ',
                                    items       => {
                                        '$ref' => '#/components/schemas/blog',
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

    my $user = get_target_user(@_)
        or return;

    my $res = filtered_list(
        $app, $endpoint, 'blog', { class => '*' },
        undef, { user => $user }
    ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub get_openapi_spec {
    +{
        tags       => ['Sites'],
        summary    => 'Retrieve a single blog by its ID',
        parameters => [{
                'in'        => 'query',
                name        => 'fields',
                schema      => { type => 'string' },
                description => 'This is an optional parameter. The field list to retrieve as part of the Entries resource. If this parameter is not specified, All fields will be returned.',
            },
        ],
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/blog',
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

sub get {
    my ( $app, $endpoint ) = @_;

    my ($blog) = context_objects(@_);
    return unless $blog && $blog->id;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'blog', $blog->id, obj_promise($blog) )
        or return;

    $blog;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v1::Blog - Movable Type class for endpoint definitions about the MT::Blog.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
