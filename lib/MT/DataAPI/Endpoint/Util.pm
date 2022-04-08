# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::Util;

use warnings;
use strict;

sub endpoints_openapi_spec {
    +{
        tags        => ['Endpoints'],
        summary     => 'Retrieve a list of endpoints',
        description => 'Retrieve a list of endpoints.',
        parameters  => [{
                'in'        => 'query',
                name        => 'includeComponents',
                schema      => { type => 'string' },
                description => 'This is an optional parameter. The comma separated ID list of components (a.k.a plugin) to include to result. ',
            },
            {
                'in'        => 'query',
                name        => 'excludeComponents',
                schema      => { type => 'string' },
                description => 'This is an optional parameter. The comma separated ID list of components (a.k.a plugin) to exclude from result. ',
            },
        ],
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
                                    description => 'The total number of endpoints found.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of Endpoints resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/endpoint',
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

sub endpoints {
    my ( $app, $endpoint ) = @_;

    my @includes
        = map { lc $_ } split( ',', $app->param('includeComponents') || '' );
    my @excludes
        = map { lc $_ } split( ',', $app->param('excludeComponents') || '' );

    my $endpoint_data = $app->endpoints( $app->current_api_version );
    my @results       = map {
        my $e = $_;
        my %endpoint = map { $_ => $e->{$_} }
            qw(id route version resources format verb);
        my $c    = $e->{component};
        my $c_id = $c->id;

        if (   ( @includes && !grep { $_ eq lc $c_id } @includes )
            || ( @excludes && grep { $_ eq lc $c_id } @excludes ) )
        {
            ();
        }
        else {
            $endpoint{component} = {
                id   => $c_id,
                name => $c->name,
            };

            \%endpoint;
        }
    } @{ $endpoint_data->{list} };

    +{  totalResults => scalar @results,
        items        => \@results,
    };
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::Util - Movable Type class for utility endpoint.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
