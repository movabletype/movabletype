# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::OpenAPI;

use warnings;
use strict;

sub openapi_spec {
    +{
        tags    => ['Common API'],
        summary => 'Retrieve OpenAPI schema'
    };
}

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
        if (my $nouns = $endpoints->{$id}{openapi_options}{filtered_list_ds_nouns}) {
            my $current_parameters = $response->{components}{parameters} || {};
            my $additional_parameters = _build_filtered_list_parameters($app, $nouns, $endpoints->{$id}{default_params});
            $response->{components}{parameters} = { %$current_parameters, %$additional_parameters };
        }
        my $route = $endpoints->{$id}{route};
        my @path_parameters;
        while ($route =~ s!/:([^/]+)!/{$1}!) {
            my $id_name = $1;
            my $id_type = 'integer';
            if ($id_name eq 'user_id' || $id_name eq 'theme_id' || $id_name eq 'plugin_id') {
                $id_type = 'string';
            }
            push @path_parameters, +{
                name     => $id_name,
                in       => 'path',
                required => JSON::true,
                schema   => {
                    type => $id_type,
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
        if ($endpoints->{$id}{openapi_options}{can_use_access_token}) {
            push @{$response->{paths}{$route}{$verb}{parameters}}, +{
                'in'        => 'header',
                name        => 'X-MT-Authorization',
                description => 'Input `MTAuth accessToken={accessToken}`',
                schema      => { type => 'string' },
            };
        }
        if ($endpoints->{$id}{openapi_options}{can_use_session_id}) {
            push @{$response->{paths}{$route}{$verb}{parameters}}, +{
                'in'        => 'header',
                name        => 'X-MT-Authorization',
                description => 'Input `MTAuth sessionId={sessionId}`',
                schema      => { type => 'string' },
            };
        }
        my $openapi = $endpoints->{$id}{openapi_handler} ? $app->handler_to_coderef($endpoints->{$id}{openapi_handler})->() : {};
        for my $key (qw/summary description tags requestBody parameters deprecated/) {
            if ($openapi->{$key}) {
                if (ref($openapi->{$key}) eq 'ARRAY') {
                    push @{ $response->{paths}{$route}{$verb}{$key} }, @{ $openapi->{$key} };
                } else {
                    $response->{paths}{$route}{$verb}{$key} = $openapi->{$key};
                }
            }
        }
        if ($app->current_api_version >= 3) {
            if (my $nouns = $endpoints->{$id}{openapi_options}{filtered_list_ds_nouns}) {
                my ($singular, $plural) = split(',', $nouns);
                push @{$response->{paths}{$route}{$verb}{parameters}}, (
                    { '$ref' => "#/components/parameters/${singular}_dateField" },
                    { '$ref' => "#/components/parameters/${singular}_dateFrom" },
                    { '$ref' => "#/components/parameters/${singular}_dateTo" },
                );
            }
        }
        my @notes;
        if ($verb eq 'put' || $verb eq 'delete') {
            push @notes, sprintf('This method accepts %s and POST with __method=%s.', uc $verb, uc $verb);
        }
        if (@notes) {
            my $description;
            for my $note (@notes) {
                $description .= "- $note\n";
            }
            $response->{paths}{$route}{$verb}{description} .= "\n#### Notes\n$description";
        }
        if ($openapi->{responses}) {
            for my $code (keys(%{ $openapi->{responses} })) {
                $response->{paths}{$route}{$verb}{responses}{$code} = $openapi->{responses}{$code};
            }
            if ($verb eq 'put' || $verb eq 'delete') {
                $response->{paths}{$route}{$verb}{responses}{405} = {
                    description => sprintf('Request method is not %s or POST with __method=%s', uc $verb, uc $verb),
                    content     => {
                        'application/json' => {
                            schema => {
                                '$ref' => '#/components/schemas/ErrorContent',
                            },
                        },
                    },
                };
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

sub _build_filtered_list_parameters {
    my ($app, $nouns, $default_params) = @_;
    my ($singular, $plural)         = split(/,/, $nouns);
    my $parameter_template = {
        "${singular}_search" => {
            in          => 'query',
            name        => 'search',
            schema      => { type => 'string' },
            description => 'Search query.',
        },
        "${singular}_searchFields" => {
            in          => 'query',
            name        => 'searchFields',
            schema      => { type => 'string' },
            description => 'The comma separated field name list to search.',
        },
        "${singular}_limit" => {
            in          => 'query',
            name        => 'limit',
            schema      => { type => 'integer' },
            description => "Maximum number of $plural to retrieve.",
        },
        "${singular}_offset" => {
            in          => 'query',
            name        => 'offset',
            schema      => { type => 'integer' },
            description => '0-indexed offset.',
        },
        "${singular}_sortBy" => {
            in     => 'query',
            name   => 'sortBy',
            schema => {
                type => 'string',
            },
        },
        "${singular}_sortOrder" => {
            in     => 'query',
            name   => 'sortOrder',
            schema => {
                type => 'string',
                enum => [
                    'descend',
                    'ascend',
                ],
            },
            description => <<"DESCRIPTION",
#### descend

Return $plural in descending order.

#### ascend

Return $plural in ascending order.

DESCRIPTION
        },
        "${singular}_fields" => {
            in          => 'query',
            name        => 'fields',
            schema      => { type => 'string' },
            description => "The field list to retrieve as part of the $singular resource. That list should be separated by comma. If this parameter is not specified, All fields will be returned.",

        },
        "${singular}_includeIds" => {
            in          => 'query',
            name        => 'includeIds',
            schema      => { type => 'string' },
            description => "The comma separated ID list of $plural to include to result.",
        },
        "${singular}_excludeIds" => {
            in          => 'query',
            name        => 'excludeIds',
            schema      => { type => 'string' },
            description => "The comma separated ID list of $plural to exclude from result.",
        },
    };
    if ($app->current_api_version >= 3) {
        $parameter_template->{"${singular}_dateField"} = {
            in     => 'query',
            name   => 'dateField',
            schema => {
                type    => 'string',
                default => 'created_on',
            },
            description => 'Specifies the field name to be used as a date field for filtering. (new in v3)',
        };
        $parameter_template->{"${singular}_dateFrom"} = {
            in          => 'query',
            name        => 'dateFrom',
            schema      => { type => 'string' },
            description => 'The start date to filtering. Specify in "YYYY-MM-DD" format. (new in v3)',
        };
        $parameter_template->{"${singular}_dateTo"} = {
            in          => 'query',
            name        => 'dateTo',
            schema      => { type => 'string' },
            description => 'The end date to filtering. Specify in "YYYY-MM-DD" format. (new in v3)',
        };
    }
    if ($singular eq 'entry' || $singular eq 'page') {
        $parameter_template->{"${singular}_maxComments"} = {
            in          => 'query',
            name        => 'maxComments',
            schema      => { type => 'integer' },
            description => "This is an optional parameter. Maximum number of comments to retrieve as part of the $plural resource. If this parameter is not supplied, no comments will be returned.",
        };
        $parameter_template->{"${singular}_maxTrackbacks"} = {
            in          => 'query',
            name        => 'maxTrackbacks',
            schema      => { type => 'integer' },
            description => "This is an optional parameter. Maximum number of received trackbacks to retrieve as part of the $plural resource. If this parameter is not supplied, no trackbacks will be returned.",
        };
        $parameter_template->{"${singular}_status"} = {
            in     => 'query',
            name   => 'status',
            schema => {
                type => 'string',
                enum => [
                    'Draft',
                    'Publish',
                    'Review',
                    'Future',
                    'Spam',
                ],
            },
            description => <<"DESCRIPTION",
Filter by container ${singular}'s status.

#### Draft

entry_status is 1.

#### Publish

entry_status is 2.

#### Review

entry_status is 3.

#### Future

entry_status is 4.

#### Spam

entry_status is 5.
DESCRIPTION
        };
        $parameter_template->{"${singular}_sortBy"} = {
            in     => 'query',
            name   => 'sortBy',
            schema => {
                type => 'string',
                enum => [
                    'authored_on',
                    'title',
                    'created_on',
                    'modified_on',
                ],
            },
            description => <<'DESCRIPTION',
The field name for sort. You can specify one of following values
- authored_on
- title
- created_on
- modified_on
DESCRIPTION
        };
        if ($app->current_api_version >= 5) {
            $parameter_template->{"${singular}_no_text_filter"} = {
                in     => 'query',
                name   => 'noTextFilter',
                schema => {
                    type => 'integer',
                    enum => [0, 1],
                },
            description => <<'DESCRIPTION',
If you want to fetch the raw text, set to '1'. New in v2
DESCRIPTION
            };
        } else {
            $parameter_template->{"${singular}_no_text_filter"} = {
                in     => 'query',
                name   => 'no_text_filter',
                schema => {
                    type => 'integer',
                    enum => [0, 1],
                },
            description => <<'DESCRIPTION',
If you want to fetch the raw text, set to '1'. New in v2
DESCRIPTION
            };
        }
    } elsif ($singular eq 'site' || $singular eq 'blog') {
        $parameter_template->{"${singular}_sortBy"} = {
            in     => 'query',
            name   => 'sortBy',
            schema => {
                type => 'string',
                enum => [
                    'name',
                ],
                default => 'name',
            },
            description => <<'DESCRIPTION',
Only 'name' is available
DESCRIPTION
        };
    } elsif ($singular eq 'role') {
        $parameter_template->{"${singular}_sortBy"} = {
            in     => 'query',
            name   => 'sortBy',
            schema => {
                type => 'string',
                enum => [
                    'name',
                    'created_by',
                    'modified_by',
                    'created_on',
                    'modified_on',
                ],
            },
            description => <<'DESCRIPTION',
The field name for sort. You can specify one of following values

- created_by
- modified_by
- created_on
- modified_on
DESCRIPTION
        };
    } elsif ($singular eq 'permission') {
        $parameter_template->{"${singular}_sortBy"} = {
            in     => 'query',
            name   => 'sortBy',
            schema => {
                type => 'string',
                enum => [
                    'id',
                    'blog_id',
                    'author_id',
                    'created_by',
                    'created_on',
                ],
                default => 'blog_id',
            },
            description => <<'DESCRIPTION',
The field name for sort. You can specify one of following values

- id
- blog_id
- author_id
- created_by
- created_on
DESCRIPTION
        };
        $parameter_template->{"${singular}_blogIds"} = {
            in          => 'query',
            name        => 'blogIds',
            schema      => { type => 'string' },
            description => 'The comma-separated blog id list that to be included in the result.',
        };
    }
    my $param;
    for my $key (keys %$parameter_template) {
        $param->{$key} = $parameter_template->{$key};

        (my $source_key = $key) =~ s/${singular}_(.*)/$1/;
        my $default_value = $default_params->{$source_key};
        if (defined $default_value && $default_value ne '') {
            $param->{$key}{schema}{default} = $default_value;
            $param->{$key}{description} .= "\n\n**Default**: " . $default_value;
        }
    }
    return $param;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::OpenAPI - OpenAPI document for Movable Type Data API.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
