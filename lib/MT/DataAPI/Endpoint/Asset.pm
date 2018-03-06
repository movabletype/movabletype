# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::Asset;

use warnings;
use strict;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;
use MT::CMS::Asset;

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
        if ( my $v = $app->param($k) ) {
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

MT::DataAPI::Endpoint::Asset - Movable Type class for endpoint definitions about the MT::Asset.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
