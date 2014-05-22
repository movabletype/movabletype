# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
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

__END__

=head1 NAME

MT::DataAPI::Endpoint::Asset - Movable Type class for endpoint definitions about the MT::Asset.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
