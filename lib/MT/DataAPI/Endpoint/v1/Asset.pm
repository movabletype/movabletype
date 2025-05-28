# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::v1::Asset;

use warnings;
use strict;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;
use MT::CMS::Asset;

sub upload_openapi_spec {
    +{
        tags        => ['Assets'],
        summary     => 'Upload a file',
        description => <<'DESCRIPTION',
Upload a file.

Authorization is required.
DESCRIPTION
        requestBody => {
            required => JSON::true,
            content  => {
                'multipart/form-data' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            path => {
                                type        => 'string',
                                description => 'The upload destination. You can specify the path to the under the site path.',
                            },
                            file => {
                                type        => 'string',
                                format      => 'binary',
                                description => 'The actual file data',
                            },
                            autoRenameIfExists => {
                                type        => 'integer',
                                description => 'If this value is "1" and the file with the same filename exists, the uploaded file is automatically renamed to the random generated name. Default is "0".',
                                enum => [0, 1],
                            },
                            normalizeOrientation => {
                                type        => 'integer',
                                description => 'If this value is "1" and the uploaded file has a orientation information in Exif, this file\'s orientation is automatically normalized. Default is "1".',
                                enum => [0, 1],
                            },
                        },
                    },
                },
            },
        },
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/asset',
                        },
                    },
                },
            },
            404 => {
                description => 'Not Found',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
            409 => {
                description => 'Conflict',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                error => {
                                    type       => 'object',
                                    properties => {
                                        code    => { type => 'integer' },
                                        message => { type => 'string' },
                                        data    => {
                                            type       => 'object',
                                            properties => {
                                                fileName => { type => 'string' },
                                                path     => { type => 'string' },
                                                temp     => { type => 'string' },
                                            },
                                        },
                                    },
                                },
                            },
                        },
                    },
                },
            },
        },
    };
}

sub upload_v2_openapi_spec {
    my $spec = __PACKAGE__->upload_openapi_spec;
    $spec->{description} = <<'DESCRIPTION';
This endpoint is marked as deprecated in v2.0.

#### Permissions

- upload
DESCRIPTION
    $spec->{deprecated} = JSON::true;
    return $spec;
}

sub upload {
    my ( $app, $endpoint ) = @_;

    return $app->error(403) unless $app->can_do('upload');

    $app->param( 'site_path', 1 )
        if !defined $app->param('site_path');

    # Rename parameters.
    my %keys = (
        overwrite            => 'overwrite_yes',
        fileName             => 'fname',
        temp                 => 'temp',
        path                 => 'extra_path',
        autoRenameIfExists   => 'auto_rename_if_exists',
        normalizeOrientation => 'normalize_orientation',
    );
    for my $k ( keys %keys ) {
        my $v = $app->param($k);
        if (defined $v && $v ne '') {
            $app->param( $keys{$k}, $v );
        }
    }

    my $error_handler = sub {
        my ( $app, %param ) = @_;
        $app->error( $param{error} );
    };
    my $exists_handler = sub {
        my ( $app, %param ) = @_;
        my %keys = (
            fname      => 'fileName',
            extra_path => 'path',
            temp       => 'temp',
        );
        $app->error( "A file named '" . $param{fname} . "' already exists.",
            409, { map { $keys{$_} => $param{$_}, } keys %keys } );
    };

    my ( $asset, $bytes ) = MT::CMS::Asset::_upload_file_compat(
        $app,
        error_handler  => $error_handler,
        exists_handler => sub {
            my ( $app, %param ) = @_;

            # version 1
            if ( $app->current_api_version == 1 ) {
                return $exists_handler->( $app, %param );
            }

            # version 2
            # overwrite asset once when overwrite_once is 1.
            if ( $app->param('overwrite_once') ) {
                for my $k ( keys %param ) {
                    $app->param( $k, $param{$k} );
                }
                $app->param( 'overwrite_yes', 1 );

                my ($asset) = MT::CMS::Asset::_upload_file_compat(
                    $app,
                    error_handler  => $error_handler,
                    exists_handler => $exists_handler,
                );
                return $asset;
            }

            return $exists_handler->( $app, %param );
        },
    );

    return $asset;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v1::Asset - Movable Type class for endpoint definitions about the MT::Asset.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
