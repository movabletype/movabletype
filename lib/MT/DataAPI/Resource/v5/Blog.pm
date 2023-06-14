# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v5::Blog;

use strict;
use warnings;

sub updatable_fields {
    [];    # Nothing. Same as v4.
}

sub fields {
    [
        {
            name => 'id',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        {
            name => 'basenameLimit',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        {
            name => 'junkFolderExpiry',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        {
            name => 'junkScoreThreshold',
            type => 'MT::DataAPI::Resource::DataType::Float',
        },
        {
            name => 'listOnIndex',
            type => 'MT::DataAPI::Resource::DataType::Integer',
            type_from_object => sub {
                my ($objs, $hashes, $f, $stash) = @_;
                my $name = $f->{name};
                for my $i (0 .. @$hashes - 1) {
                    my $hash = $hashes->[$i];
                    my $obj  = $objs->[$i];
                    $hash->{$name} = $obj->entries_on_index || $obj->days_on_index || 0;
                }
                return;
            },
            type_to_object => sub {
                my ($hashes, $objs, $f, $stash) = @_;
                for my $i (0 .. @$objs - 1) {
                    my $hash = $hashes->[$i];
                    my $obj  = $objs->[$i];
                    if ( $hash->{daysOrPosts} && $hash->{daysOrPosts} eq 'posts' ) {
                        $obj->entries_on_index( $hash->{listOnIndex} || 0 );
                        $obj->days_on_index(0);
                    } else {
                        $obj->entries_on_index(0);
                        $obj->days_on_index( $hash->{listOnIndex} || 0 );
                    }
                }
                return;
            },
        },
        {
            name => 'maxRevisionsEntry',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        {
            name => 'maxRevisionsTemplate',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        {
            name => 'parent',
            schema => {
                type       => 'object',
                properties => {
                    id   => { type => 'integer' },
                    name => { type => 'string' },
                },
            },
        },
        {
            name => 'smartReplace',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        {
            name => 'wordsInExcerpt',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v5::Blog - Movable Type class for resources definitions of the MT::Blog.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
