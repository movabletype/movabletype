# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v5::TextFilter;
use strict;
use warnings;

sub list_openapi_spec {
    +{
        tags      => ['System'],
        summary   => 'Retrieve a list of text filters',
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                totalResults => {
                                    type        => 'integer',
                                    description => ' The total number of text filters.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of text filters.',
                                    items       => {
                                        type       => 'object',
                                        properties => {
                                            key => {
                                                type        => 'string',
                                                description => 'The key name of the text filter',
                                            },
                                            label => {
                                                type        => 'string',
                                                description => 'The display name of the text filter',
                                            },
                                        },
                                    }
                                },
                            },
                        },
                    },
                },
            },
        },
    };
}

sub list {
    my ($app, $endpoint) = @_;
    my $filters = $app->all_text_filters;
    my @res;
    for my $filter (keys %$filters) {
        my $label = $filters->{$filter}{label};
        if ('CODE' eq ref($label)) {
            $label = $label->();
        }
        push @res, {
            key   => $filter || '',
            label => $label  || '',
        };
    }
    unshift @res, {
        key   => '0',
        label => $app->translate('None'),
    };

    +{
        totalResults => scalar(@res),
        items        => \@res,
    };
}

1;

