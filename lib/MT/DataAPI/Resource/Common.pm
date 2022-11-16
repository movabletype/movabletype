# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Common;

use strict;
use warnings;

use MT::DataAPI::Resource;

our %fields = (
    blog => {
        name        => 'blog',
        from_object => sub {
            my ($obj) = @_;
            my $app = MT->instance;
            if ( $app->current_api_version == 1 ) {
                return $obj->blog_id ? +{ id => $obj->blog_id, } : undef;
            }
            else {
                # $app->current_api_version > 1
                return defined( $obj->blog_id )
                    ? +{ id => $obj->blog_id, }
                    : undef;
            }
        },
        schema => {
            type => 'object',
            properties => {
                id => { type => 'integer' },
            },
        },
    },
    tags => {
        name        => 'tags',
        from_object => sub {
            my ($obj) = @_;
            [ $obj->tags ];
        },
        to_object => sub {
            my ( $hash, $obj ) = @_;
            if ( ref $hash->{tags} eq 'ARRAY' ) {
                $obj->set_tags( @{ $hash->{tags} }, { force => 1 } );
            }
            return;
        },
        schema => {
            type => 'array',
            items => {
                type => 'string',
            },
        },
    },
    status => {
        name        => 'status',
        from_object => sub {
            my ($obj) = @_;
            $obj->get_status_text;
        },
        to_object => sub {
            my ( $hash, $obj ) = @_;
            $obj->set_status_by_text( $hash->{status} );
            return;
        },
        schema => {
            type => 'string',
        },
    },
    createdDate => {
        name  => 'createdDate',
        alias => 'created_on',
        type  => 'MT::DataAPI::Resource::DataType::ISO8601',
    },
    modifiedDate => {
        name  => 'modifiedDate',
        alias => 'modified_on',
        type  => 'MT::DataAPI::Resource::DataType::ISO8601',
    },
    createdBy => {
        name             => 'createdBy',
        bulk_from_object => sub {
            my ( $objs, $hashes ) = @_;

            my @author_ids = grep {$_} map { $_->created_by } @$objs;
            my %authors = ();
            my @authors
                = @author_ids
                ? MT->model('author')->load( { id => \@author_ids, } )
                : ();
            $authors{ $_->id } = $_ for @authors;

            my $size = scalar(@$objs);
            for ( my $i = 0; $i < $size; $i++ ) {
                my $obj = $objs->[$i];
                my $author = $authors{ $obj->created_by || 0 } or next;
                $hashes->[$i]{createdBy}
                    = MT::DataAPI::Resource->from_object( $author,
                    [qw(id displayName userpicUrl)] );
            }
        },
        schema => {
            type       => 'object',
            properties => {
                displayName => { type => 'string' },
                id          => { type => 'integer' },
                userpicUrl  => { type => 'string' },
            },
        },
    },
    modifiedBy => {
        name             => 'modifiedBy',
        bulk_from_object => sub {
            my ( $objs, $hashes ) = @_;

            my @author_ids = grep {$_} map { $_->modified_by } @$objs;
            my %authors = ();
            my @authors
                = @author_ids
                ? MT->model('author')->load( { id => \@author_ids, } )
                : ();
            $authors{ $_->id } = $_ for @authors;

            my $size = scalar(@$objs);
            for ( my $i = 0; $i < $size; $i++ ) {
                my $obj = $objs->[$i];
                my $author = $authors{ $obj->modified_by || 0 } or next;
                $hashes->[$i]{modifiedBy}
                    = MT::DataAPI::Resource->from_object( $author,
                    [qw(id displayName userpicUrl)] );
            }
        },
        schema => {
            type       => 'object',
            properties => {
                displayName => { type => 'string' },
                id          => { type => 'integer' },
                userpicUrl  => { type => 'string' },
            },
        },
    },
);

1;

=head1 NAME

MT::DataAPI::Resource::Common - Movable Type common definitions for Data API's resources.

=head1 FIELDS

=over 4

=item blog

    A blog field. $obj should have the "blog_id" field.

=item tags

    A tags field. $obj should an instance of MT::Taggable.

=item status

    A status field. $obj should have the "set_status_by_text" method and the "get_status_text" method.

=back

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
