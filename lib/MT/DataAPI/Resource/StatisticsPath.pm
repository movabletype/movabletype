# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::StatisticsPath;

use strict;
use warnings;

sub fields {
    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    return [{
            name   => 'path',
            schema => {
                type        => 'string',
                description => 'The relative path of the target.',
            },
        },
        {
            name   => 'pageviews',
            schema => {
                type        => 'string',
                description => 'The pageviews for the path. This property exists only if the metrics to retrieve is "pageviews"',
            },
        },
        {
            name   => 'visits',
            schema => {
                type        => 'string',
                description => 'The visits for the path. This property exists only if the metrics to retrieve is "visits"',
            },
        },
        {
            name   => 'archiveType',
            schema => {
                type        => 'string',
                description => 'The archive type of the path. This property is null if the path is not managed by MT.',
            },
        },
        {
            name   => 'entry',
            schema => {
                type        => 'object',
                description => 'This property is null if "archiveType" is not "Individual".',
                properties  => {
                    id => {
                        type        => 'integer',
                        description => 'The ID of entry.',
                    },
                },
            },
        },
        {
            name   => 'author',
            schema => {
                type        => 'object',
                description => 'This property is null if "archiveType" is neither "Author" nor "Author-∗".',
                properties  => {
                    id => {
                        type        => 'integer',
                        description => 'The ID of author.',
                    },
                },
            },
        },
        {
            name   => 'category',
            schema => {
                type        => 'object',
                description => 'This property is null if "archiveType" is neither "Category" nor "Category-∗".',
                properties  => {
                    id => {
                        type        => 'integer',
                        description => 'The ID of category.',
                    },
                },
            },
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::StatisticsPath - Resources definitions of the statistics API.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
