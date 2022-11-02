# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::v1::Permission;

use warnings;
use strict;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list_openapi_spec {
    +{
        tags        => ['Users', 'Permissions'],
        summary     => 'Retrieve a list of permissions for a user',
        description => <<'DESCRIPTION',
Retrieve a list of permissions for a user.

Authorization is required and can specify only 'me' (or user's own user ID) except for a super user.
DESCRIPTION
        parameters => [{
                'in'        => 'query',
                name        => 'blogIds',
                schema      => { type => 'string' },
                description => 'This is an optional parameter. The comma separated ID list of blogs to retrieve.',
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
                                    description => 'The total number of permissions found.',
                                },
                                items => {
                                    type  => 'array',
                                    items => {
                                        '$ref' => '#/components/schemas/permission',
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
    my $current_user = $app->user;

    return $app->error(403)
        if ( $user->id != $current_user->id && !$current_user->is_superuser );

    my $res;
    if ( $user->is_superuser ) {
        require MT::Permission;

        my $offset = $app->param('offset');
        my $limit  = $app->param('limit');

        return unless $app->has_valid_limit_and_offset( $limit, $offset );

        my $filter_keys = $app->param('filterKeys');
        my $blog_ids = $app->param('blogIds') || '';
        $filter_keys =~ s/blogIds/ids/ if $filter_keys;
        $app->param( 'filterKeys', $filter_keys );
        $app->param( 'ids',        $blog_ids );
        my @blog_ids = split ',', $blog_ids;

        $res = filtered_list(
            $app,
            $endpoint,
            'blog',
            { class => '*' },
            undef,
            {   user    => $user,
                offset  => $offset ? $offset - 1 : 0,
                sort_by => 'id'
            }
        ) or return;

        my $blog_perms       = MT::Permission::_all_perms('blog');
        my $permission_class = $app->model('permission');
        $res->{objects} = [
            map {
                my $obj = $permission_class->new;
                $obj->blog_id( $_->id );
                $obj->permissions($blog_perms);
                $obj;
            } @{ $res->{objects} }
        ];

        if ( !@blog_ids || grep { $_ eq '0' } @blog_ids ) {
            if ( !$offset ) {
                if ( $res->{count} >= $limit ) {
                    pop @{ $res->{objects} };
                }

                my $obj = $permission_class->new;
                $obj->permissions( MT::Permission::_all_perms('system') );
                unshift @{ $res->{objects} }, $obj;

            }
            $res->{count} += 1;
        }
    }
    else {
        $res
            = filtered_list( $app, $endpoint, 'permission',
            { permissions => { not => '' } },
            undef, { user => $user } )
            or return;
    }

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v1::Permission - Movable Type class for endpoint definitions about the MT::Permission.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
