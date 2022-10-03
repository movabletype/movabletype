# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v3::Asset;

use strict;
use warnings;

use MT::DataAPI::Endpoint::v1::Asset;
use MT::DataAPI::Endpoint::v2::Asset;

sub upload_openapi_spec {
    my $spec = MT::DataAPI::Endpoint::v2::Asset::upload_openapi_spec();
    $spec->{requestBody}{content}{'multipart/form-data'}{schema}{properties}{autoRenameNonAscii} = {
        type => 'integer',
        description => 'If this value is "1", the filename is renamed non-ascii filename automatically',
        enum => [0, 1],
    };
    return $spec;
}

sub upload_deprecated_openapi_spec {
    my $spec = MT::DataAPI::Endpoint::v1::Asset::upload_v2_openapi_spec();
    $spec->{description} = <<'DESCRIPTION';
This endpoint is marked as deprecated in v2.0.

Upload single file to specific site.

#### Permissions

- upload
DESCRIPTION
    return $spec;
}

sub upload {
    my ( $app, $endpoint ) = @_;

    my $site_id = $app->param('site_id');
    if ( !( defined($site_id) && $site_id =~ m/^\d+$/ ) ) {
        return $app->error(
            $app->translate( 'A parameter "[_1]" is required.', 'site_id' ),
            400 );
    }

    $app->param( 'blog_id', $site_id );
    $app->delete_param('site_id');

    my $site = MT->model('blog')->load($site_id);
    $app->blog($site);

    my $user = $app->user;
    $app->permissions( $user->permissions($site_id) )
        if $user && !$user->is_anonymous;

    if ($site) {
        if ( defined $site->allow_to_change_at_upload
            && !$site->allow_to_change_at_upload )
        {
            # Ignore path parameter, using default upload destination instead.
            my $path;
            if ( $site->upload_destination ) {
                my $dest = $site->upload_destination;
                my $extra_path = $site->extra_path || '';
                $dest = MT::Util::build_upload_destination($dest);
                $path = File::Spec->catdir( $dest, $extra_path );
                $app->param( 'site_path',
                    ( $site->upload_destination =~ m/^%s/i ) ? 1 : 0 );
            }
            else {
                $path = '';
            }
            $app->param( 'path', $path );
        }
    }

    my $autoRenameNonAscii = $app->param('autoRenameNonAscii');
    if ( defined $autoRenameNonAscii ) {
        $app->param( 'auto_rename_non_ascii', $autoRenameNonAscii );
    }

    MT::DataAPI::Endpoint::v1::Asset::upload( $app, $endpoint );
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v3::Asset - Movable Type class for endpoint definitions about the MT::Asset.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
