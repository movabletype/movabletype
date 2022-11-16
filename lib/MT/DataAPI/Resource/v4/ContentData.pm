# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v4::ContentData;
use strict;
use warnings;

use MT::ContentStatus;
use MT::DataAPI::Resource;
use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [ 'basename', 'data', 'date', 'status', 'unpublishedDate', 'label' ];
}

sub fields {
    [   'permalink',
        {   name   => 'author',
            fields => [qw(id displayName userpicUrl)],
            type   => 'MT::DataAPI::Resource::DataType::Object',
        },
        {   name  => 'basename',
            alias => 'identifier',
        },
        {   name        => 'label',
            alias       => 'label',
            from_object => sub {
                my ($obj) = @_;
                $obj->label || MT->translate('No Label');
            },
            to_object => sub {
                my ( $hash, $obj ) = @_;
                my $ct = $obj->content_type;
                $ct->data_label ? undef : $hash->{label};
            },
        },
        {   name        => 'data',
            from_object => sub {
                my ($obj) = @_;
                my $content_type = $obj->content_type;
                my @field_ids = map { $_->{id} } @{ $content_type->fields };
                my @data;
                for my $fid (@field_ids) {
                    my $field = $content_type->get_field($fid) || {};
                    my $options = $field->{options} || {};
                    push @data,
                        +{
                        id    => $fid,
                        data  => $obj->data->{$fid},
                        label => $options->{label},
                        type  => $field->{type},
                        };
                }
                \@data;
            },
            to_object      => sub { },    # Do nothing.
            type_to_object => sub {
                my ( $hashes, $objs ) = @_;
                my $app  = MT->instance;
                my $user = $app->user;

                my %site_perms_cache;

                for my $i ( 0 .. scalar @$objs - 1 ) {
                    my $hash = $hashes->[$i];
                    my $obj  = $objs->[$i];

                    my $hash_data = $hash->{data};
                    $hash_data = [] unless ref $hash_data eq 'ARRAY';
                    my $obj_data              = $obj->data;
                    my $content_type          = $obj->content_type;
                    my $can_edit_content_data = $user->permissions(0)
                        ->can_edit_content_data( $obj, $user );
                    my $site_perms = $site_perms_cache{ $obj->blog_id }
                        ||= $user->permissions( $obj->blog_id );

                    for my $field ( @{ $content_type->fields } ) {
                        my $field_id = $field->{id};
                        my $options = $field->{options} || {};
                        my ($field_hash_data)
                            = grep { $_->{id} && $_->{id} == $field_id }
                            @$hash_data;
                        my $can_edit_field = $can_edit_content_data
                            || $site_perms->can_do( 'content_type:'
                                . $content_type->unique_id
                                . '-content_field:'
                                . $field->{unique_id} );
                        if (   $field_hash_data
                            && exists $field_hash_data->{data}
                            && $can_edit_field )
                        {
                            $obj_data->{$field_id} = $field_hash_data->{data};
                        }
                        elsif ( !defined $obj_data->{$field_id}
                            && defined $options->{initial_value} )
                        {
                            if ( $field->{type}
                                =~ /(?:date|time|date_and_time)/
                                and $options->{initial_value} =~ /(?:^ | $)/ )
                            {
                                # Fix broken initial values (MTC-26262)
                                $options->{initial_value} = undef;
                            }
                            $obj_data->{$field_id}
                                = $options->{initial_value};
                        }
                    }
                    $obj->data($obj_data);
                }
            },
            schema => {
                type       => 'object',
                properties => {
                    data => {
                        'oneOf' => [
                            { type => 'string' },
                            { type => 'array', items => { type => 'string' } },
                        ],
                    },
                    id    => { type => 'string' },
                    label => { type => 'string' },
                    type  => { type => 'string' },
                },
            },
        },
        {   name  => 'date',
            alias => 'authored_on',
            type  => 'MT::DataAPI::Resource::DataType::ISO8601',
        },
        {   name => 'id',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        {   name             => 'updatable',
            type             => 'MT::DataAPI::Resource::DataType::Boolean',
            bulk_from_object => sub {
                my ( $objs, $hashes ) = @_;
                my $app  = MT->instance or return;
                my $user = $app->user   or return;

                if ( $user->is_superuser ) {
                    $_->{updatable} = 1 for @$hashes;
                    return;
                }

                for my $i ( 0 .. scalar @$objs - 1 ) {
                    my $obj = $objs->[$i];
                    $hashes->[$i]{updatable} = $user->permissions(0)
                        ->can_edit_content_data( $obj, $user );
                }
            },
        },
        {   name        => 'status',
            from_object => sub {
                my ($obj) = @_;
                MT::ContentStatus::status_text( $obj->status );
            },
            to_object => sub {
                my ($hash) = @_;
                MT::ContentStatus::status_int( $hash->{status} );
            },
        },
        {   name      => 'unpublishedDate',
            alias     => 'unpublished_on',
            type      => 'MT::DataAPI::Resource::DataType::ISO8601',
            condition => \&_is_logged_in,
        },
        $MT::DataAPI::Resource::Common::fields{blog},
        $MT::DataAPI::Resource::Common::fields{createdDate},
        $MT::DataAPI::Resource::Common::fields{modifiedDate},
    ];
}

sub _is_logged_in {
    my $app  = MT->instance or return;
    my $user = $app->user   or return;
    $user->id ? 1 : 0;
}

1;

