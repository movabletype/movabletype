# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::DataAPI::Endpoint::Permission;

use warnings;
use strict;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list {
    my ( $app, $endpoint ) = @_;

    my $user = get_target_user(@_)
        or return;

    my $res;
    if ( $user->is_superuser ) {
        my $offset = $app->param('offset');
        my $limit  = $app->param('limit');

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

        my $permission_class = $app->model('permission');
        $res->{objects} = [
            map {
                my $obj = $permission_class->new;
                $obj->blog_id( $_->id );
                $obj;
            } @{ $res->{objects} }
        ];

        if ( !$offset ) {
            if ( $res->{count} >= $limit ) {
                pop @{ $res->{objects} };
            }

            unshift @{ $res->{objects} }, $permission_class->new;
        }

        $res->{count} += 1;
    }
    else {
        $res
            = filtered_list( $app, $endpoint, 'permission',
            { permissions => { not => '' } },
            undef, { user => $user } )
            or return;
    }

    +{  totalResults => $res->{count},
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

1;
