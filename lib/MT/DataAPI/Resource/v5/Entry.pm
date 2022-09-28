# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v5::Entry;

use strict;
use warnings;

use MT::Category;
use MT::Template::Context;
use MT::DataAPI::Resource;

sub updatable_fields {
    [{
            name   => 'categories',
            schema => {
                type  => 'array',
                items => {
                    type       => 'object',
                    properties => {
                        id => { type => 'integer' },
                    },
                }
            },
        },
        {
            name   => 'assets',
            schema => {
                type  => 'array',
                items => {
                    type       => 'object',
                    properties => {
                        id => { type => 'integer' },
                    },
                }
            },
        },
    ];
}

sub fields {
    [{
            name        => 'assets',
            from_object => sub {
                my ($obj) = @_;
                MT::DataAPI::Resource->from_object($obj->assets);
            },
            to_object => sub {
                # See MT::DataAPI::Resource->to_object
                my ($hash, $obj, $field, $stash) = @_;
                return unless $obj->id;
                return ($hash->{ $field->{name} });
            },
            schema => {
                type  => 'array',
                items => { '$ref' => '#/components/schemas/asset' },
            },
        },
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
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v5::Entry - Movable Type class for resources definitions of the MT::Entry.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
