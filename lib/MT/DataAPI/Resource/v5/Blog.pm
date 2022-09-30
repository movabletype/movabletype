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
