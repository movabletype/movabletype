# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v5::ContentData;
use strict;
use warnings;

sub fields {
    [
        {
            name   => 'author',
            schema => {
                type       => 'object',
                properties => {
                    id          => { type => 'integer' },
                    displayName => { type => 'string' },
                    userpicUrl  => { type => 'string' },
                },
            },
        },
        {
            name   => 'data',
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
                        id    => $fid + 0,
                        data  => $obj->data->{$fid},
                        label => $options->{label},
                        type  => $field->{type},
                        };
                }
                \@data;
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
                    id    => { type => 'integer' },
                    label => { type => 'string' },
                    type  => { type => 'string' },
                },
            },
        },
    ];
}

1;
