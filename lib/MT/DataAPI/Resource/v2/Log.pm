# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Resource::v2::Log;

use strict;
use warnings;

use MT::Util;
use MT::DataAPI::Resource;
use MT::DataAPI::Resource::Common;
use MT::DataAPI::Callback::Log;

my %level_table = (
    INFO     => 1,
    WARNING  => 2,
    ERROR    => 4,
    SECURITY => 8,
    DEBUG    => 16,
);
my %reversed_level_table = reverse %level_table;

sub updatable_fields {
    [   qw(
            class
            message
            level
            metadata
            category
            by
            ),
    ];
}

sub fields {
    [   qw(
            id
            ip
            class
            message
            category
            ),
        {   name        => 'level',
            from_object => sub {
                my ($obj) = @_;
                return $reversed_level_table{ $obj->level };
            },
            to_object => sub {
                my ($hash) = @_;
                return if !exists $hash->{level};
                if ( $hash->{level} =~ m/^\d+$/ ) {
                    return $hash->{level};
                }
                else {
                    return $level_table{ $hash->{level} };
                }
            },
        },
        {   name        => 'metadata',
            from_object => sub {
                my ($obj) = @_;

                my $desc;
                if ( 'MT::Log' eq ref $obj ) {
                    $desc = MT::Util::encode_html( $obj->metadata ) || '';
                }
                else {
                    $desc = $obj->description;
                }
                $desc = $desc->() if ref $desc eq 'CODE';

                return $desc;
            },
        },
        {   name        => 'updatable',
            type        => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object => sub {
                my ($obj) = @_;
                my $app  = MT->instance or return;
                my $user = $app->user   or return;
                return MT::DataAPI::Callback::Log::can_save( undef, $app,
                    $obj );
            },
        },
        {   name             => 'by',
            bulk_from_object => sub {
                my ( $objs, $hashes ) = @_;

                my @author_ids = grep {$_} map { $_->author_id } @$objs;
                my %authors = ();
                my @authors
                    = @author_ids
                    ? MT->model('author')->load( { id => \@author_ids, } )
                    : ();
                $authors{ $_->id } = $_ for @authors;

                my $size = scalar(@$objs);
                for ( my $i = 0; $i < $size; $i++ ) {
                    my $obj = $objs->[$i];
                    my $author = $authors{ $obj->author_id || 0 } or next;
                    $hashes->[$i]{by}
                        = MT::DataAPI::Resource->from_object( $author,
                        [qw(id displayName userpicUrl)] );
                }
            },
            to_object => sub {

                # Do nothing.
            },
            type_to_object => sub {
                my ( $hashes, $objs ) = @_;
                for my $i ( 0 .. ( scalar(@$hashes) - 1 ) ) {
                    if ( ref( $hashes->[$i]->{by} ) eq 'HASH'
                        && exists( $hashes->[$i]->{by}{id} ) )
                    {
                        $objs->[$i]->author_id( $hashes->[$i]->{by}{id} );
                    }
                }
            },
            schema => {
                type       => 'object',
                properties => {
                    id          => { type => 'string' },
                    displayName => { type => 'string' },
                    userpicUrl  => { type => 'string' },
                },
            },
        },
        {   name  => 'date',
            alias => 'created_on',
            type  => 'MT::DataAPI::Resource::DataType::ISO8601',
        },
        $MT::DataAPI::Resource::Common::fields{blog},
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::Log - Movable Type class for resources definitions of the MT::Log.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
