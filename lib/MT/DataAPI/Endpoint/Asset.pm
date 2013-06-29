# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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

    $app->param( 'site_path', 1 );

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

    my ( $asset, $bytes ) = MT::CMS::Asset::_upload_file(
        $app,
        error_handler => sub {
            my ( $app, %param ) = @_;
            $app->error( $param{error} );
        },
        exists_handler => sub {
            my ( $app, %param ) = @_;
            my %keys = (
                fname      => 'fileName',
                extra_path => 'path',
                temp       => 'temp',
            );
            $app->error(
                "A file named '" . $param{fname} . "' already exists.",
                409, { map { $keys{$_} => $param{$_}, } keys %keys } );
        },
    );
    $asset;
}

1;
