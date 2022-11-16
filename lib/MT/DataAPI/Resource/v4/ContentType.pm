# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v4::ContentType;
use strict;
use warnings;

use MT::DataAPI::Resource;
use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [ 'name', 'description', 'userDisplayOption', 'dataLabel' ];
}

sub fields {
    [   'id', 'name',
        'description',
        {   name  => 'userDisplayOption',
            alias => 'user_disp_option',
            type  => 'MT::DataAPI::Resource::DataType::Boolean',
        },
        {   name  => 'uniqueID',
            alias => 'unique_id',
        },
        {   name        => 'contentFields',
            from_object => sub {
                my ( $obj, $hash ) = @_;
                MT::DataAPI::Resource->from_object( $obj->field_objs,
                    [ 'id', 'label', 'type', 'uniqueID' ] );
            },
            schema => {
                type  => 'array',
                items => {
                    type       => 'object',
                    properties => {
                        id       => { type => 'string' },
                        label    => { type => 'string' },
                        type     => { type => 'string' },
                        uniqueID => { type => 'string' },
                    },
                },
            },
        },
        {   name  => 'dataLabel',
            alias => 'data_label',
        },
        {   name             => 'updatable',
            type             => 'MT::DataAPI::Resource::DataType::Boolean',
            bulk_from_object => sub {
                my ( $objs, $hashes ) = @_;
                my $app = MT->instance;
                my $user = $app->user or return;

                return unless $app->blog;
                my $blog_perm = $user->permissions( $app->blog->id );

                if (   $user->is_superuser
                    || $user->can_manage_content_types
                    || (   $blog_perm
                        && $blog_perm->has('manage_content_types') )
                    )
                {
                    $_->{updatable} = 1 for @$hashes;
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

