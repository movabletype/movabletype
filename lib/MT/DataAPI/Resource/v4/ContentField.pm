# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v4::ContentField;
use strict;
use warnings;

use Storable ();

use MT::DataAPI::Resource;
use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [ 'type', 'label', 'description', 'options' ];
}

sub fields {
    [   'id',
        'description',
        {   name              => 'options',
            to_object         => sub { },
            to_object_default => +{ options => { display => 'default' } },
            type_to_object    => sub {
                my ( $hashes, $objs ) = @_;
                my $app = MT->instance;
                $app->request( 'data_api_content_field_hashes_for_callback',
                    Storable::dclone($hashes) );
                $app->request( 'data_api_content_field_hashes_for_save',
                    Storable::dclone($hashes) );
            },
            schema => {
                type        => 'object',
                description => 'This schema shows only common options',
                properties  => {
                    label       => { type => 'string' },
                    description => { type => 'string' },
                    required    => { type => 'string' },
                    display     => { type => 'string' },
                },
            },
        },
        {   name      => 'type',
            to_object => sub {
                my ( $hash, $obj ) = @_;
                $obj->type( $hash->{type} ) unless $obj->type;
            },
        },
        {   name  => 'label',
            alias => 'name',
        },
        {   name  => 'uniqueID',
            alias => 'unique_id',
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

