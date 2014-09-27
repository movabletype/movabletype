# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Callback::Website;

use strict;
use warnings;

use File::Spec;
use MT::CMS::Common;

# Implemented filtering processes in MT::CMS::Common::save().
sub save_filter {
    my ( $eh, $app, $obj, $original ) = @_;

    # Check empty fields.
    my @not_empty_fields = (
        { field => 'name',      parameter => 'name' },
        { field => 'site_url',  parameter => 'url' },
        { field => 'site_path', parameter => 'sitePath' },
        { field => 'theme_id',  parameter => 'themeId' },
    );
    for (@not_empty_fields) {
        my $field = $_->{field};
        if ( !( defined $obj->$field ) || $obj->$field eq '' ) {
            return $app->errtrans( 'A parameter "[_1]" is required.',
                $_->{parameter} );
        }
    }

    # Check positive interger fields.
    my @positive_inteter_columns
        = qw( max_revisions_entry max_revisions_template );
    for my $col (@positive_interger_columns) {
        if ( !( $obj->$col && $obj->$col =~ m/^\d+$/ ) ) {
            return $eh->error(
                $app->translate(
                    "The number of revisions to store must be a positive integer."
                )
            );
        }
    }

    # Check whether blog has a preferred archive type or not.
    if ( _blog_has_archive_type($obj) && !$obj->archive_type_preferred ) {
        return $eh->error(
            $app->translate("Please choose a preferred archive type.") );
    }

    # Check whether theme_id is valid or not.
    require MT::Theme;
    if ( !MT::Theme->load( $obj->theme_id ) ) {
        return $app->errtrans( 'Invalid theme_id: [_1]', $obj->theme_id );
    }

    # Check whether site_path is within BaseSitePath or not.
    my $site_path = $obj->column('site_path');
    if ( $site_path and $app->config->BaseSitePath ) {
        my $l_path = $app->config->BaseSitePath;
        unless (
            MT::CMS::Common::is_within_base_sitepath( $app, $site_path ) )
        {
            return $app->errtrans(
                "The website root directory must be within [_1]", $l_path );
        }
    }

    # Check whether site_path is absolute or not.
    if ( $site_path
        and not File::Spec->file_name_is_absolute($site_path) )
    {
        return $app->errtrans(
            "The website root directory must be absolute: [_1]", $site_path );
    }

    return 1;
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::Website - Movable Type class for Data API's callbacks about the MT::Website.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
