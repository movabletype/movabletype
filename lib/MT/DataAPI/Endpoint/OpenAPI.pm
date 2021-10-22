# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::OpenAPI;

use warnings;
use strict;

sub build_schema {
    my ($app, $endpoint) = @_;
    my $endpoints        = $app->endpoints($app->current_api_version)->{hash};
    my $resource_schemas = $app->schemas($app->current_api_version);
    my $response         = {
        openapi => '3.0.0',
        info    => {
            title   => 'Movable Type Data API',
            version => $app->release_version_id,
        },
        externalDocs => {
            description => 'Find out more about Movable Type Data API',
            url         => 'https://www.movabletype.jp/developers/data-api/',
        },
        servers => [{ url => $app->base . $app->uri . '/v' . $app->current_api_version, }],
        tags    => [
            { name => 'Authentication' },
            { name => 'Common API' },
            { name => 'Endpoints' },
        ],
        components => {
            securitySchemes => {
                mtauth => {
                    type        => 'apiKey',
                    in          => 'header',
                    name        => 'X-MT-Authorization',
                    description => 'MTAuth accessToken={accessToken}',
                },
            },
            schemas => {
                ErrorContent => {
                    type       => 'object',
                    properties => {
                        error => {
                            type       => 'object',
                            properties => {
                                code    => { type => 'number' },
                                message => { type => 'string' },
                            },
                        },
                    },
                },
                %$resource_schemas,
            },
        },
    };
    for my $id (sort keys %$endpoints) {
        my $route = $endpoints->{$id}{route};
        my @path_parameters;
        while ($route =~ s!/:([^/]+)!/{$1}!) {
            push @path_parameters, +{
                name     => $1,
                in       => 'path',
                required => 'true',
                schema   => {
                    type => 'integer',
                },
            };
        }
        my $verb = lc($endpoints->{$id}{verb} || 'GET');
        $response->{paths}{$route}{$verb} = {
            responses => {
                200 => {
                    'description' => 'OK',
                    'content'     => {
                        'application/json' => {
                            'schema' => {
                                'type' => 'object',
                            },
                        },
                    },
                },
                400 => {
                    description => 'Bad request',
                    content     => {
                        'application/json' => {
                            schema => {
                                '$ref' => '#/components/schemas/ErrorContent',
                            },
                        },
                    },
                },
                401 => {
                    description => 'Invalid login',
                    content     => {
                        'application/json' => {
                            schema => {
                                '$ref' => '#/components/schemas/ErrorContent',
                            },
                        },
                    },
                },
            },
        };
        if ($endpoints->{$id}{requires_login}) {
            $response->{paths}{$route}{$verb}{security} = [{ mtauth => [] }];
        }
        if (@path_parameters) {
            $response->{paths}{$route}{$verb}{parameters} = \@path_parameters;
        }
        my $openapi = $endpoints->{$id}{openapi};
        for my $key (qw/summary description tags requestBody parameters/) {
            if ($openapi->{$key}) {
                if (ref($openapi->{$key}) eq 'ARRAY') {
                    push @{ $response->{paths}{$route}{$verb}{$key} }, @{ $openapi->{$key} };
                } else {
                    $response->{paths}{$route}{$verb}{$key} = $openapi->{$key};
                }
            }
        }
        if ($openapi->{responses}) {
            for my $code (keys(%{ $openapi->{responses} })) {
                $response->{paths}{$route}{$verb}{responses}{$code} = $openapi->{responses}{$code};
            }
        }
        for my $code (keys %{ $endpoints->{$id}{error_codes} }) {
            $response->{paths}{$route}{$verb}{responses}{$code} = {
                description => $endpoints->{$id}{error_codes}{$code},
            };
        }
    }
    return $response;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::OpenAPI - OpenAPI document for Movable Type Data API.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
