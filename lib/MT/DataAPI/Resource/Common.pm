# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Common;

use strict;
use warnings;

our %fields = (
    blog => {
        name        => 'blog',
        from_object => sub {
            my ($obj) = @_;
            $obj->blog_id ? +{ id => $obj->blog_id, } : undef;
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
                $obj->set_tags( @{ $hash->{tags} } );
            }
            return;
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
