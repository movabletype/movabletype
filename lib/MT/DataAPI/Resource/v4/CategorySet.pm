# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v4::CategorySet;
use strict;
use warnings;

use MT::DataAPI::Resource;
use MT::DataAPI::Resource::Common;

sub updatable_fields {
    ['name'];
}

sub fields {
    [   'name',
        {   name => 'id',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        {   name      => 'content_type_count',
            bulk_from_object => sub {
                my ($objs, $hashes, $field) = @_;
                my $app      = MT->instance;
                my $ct_count = MT->model('category_set')->ct_count_by_blog($app->blog->id);
                for my $i (0 .. (@$objs - 1)) {
                    my $obj = $objs->[$i];
                    $hashes->[$i]{ $field->{name} } = $ct_count->{ $obj->id } || 0;
                }
            },
            condition => sub {
                my $app  = MT->instance or return;
                my $user = $app->user   or return;
                $user->id ? 1 : 0;
            },
        },
        {   name        => 'categories',
            from_object => sub {
                my ($obj) = @_;
                my $cats = $obj->categories;
                MT::DataAPI::Resource->from_object( $cats,
                    [ 'id', 'parent', 'label', 'basename' ] );
            },
            schema => {
                type  => 'array',
                items => {
                    type       => 'object',
                    properties => {
                        id       => { type => 'integer' },
                        parent   => { type => 'string' },
                        label    => { type => 'string' },
                        basename => { type => 'string' },
                    },
                },
            },
        },
        {   name             => 'updatable',
            type             => 'MT::DataAPI::Resource::DataType::Boolean',
            bulk_from_object => sub {
                my ( $objs, $hashes ) = @_;
                my $app = MT->instance;
                my $user = $app->user or return;

                if ( $user->is_superuser ) {
                    $_->{updatable} = 1 for @$hashes;
                    return;
                }

                my %cache;
                for my $i ( 0 .. ( @$objs - 1 ) ) {
                    my $obj = $objs->[$i];
                    $hashes->[$i]{updatable} = $cache{ $obj->blog_id }
                        ||= $user->permissions( $obj->blog_id )
                        ->has('manage_category_set');
                }
            },
        },
        $MT::DataAPI::Resource::Common::fields{blog},
        $MT::DataAPI::Resource::Common::fields{createdDate},
        $MT::DataAPI::Resource::Common::fields{modifiedDate},
        $MT::DataAPI::Resource::Common::fields{createdBy},
        $MT::DataAPI::Resource::Common::fields{modifiedBy},
    ];
}

1;

