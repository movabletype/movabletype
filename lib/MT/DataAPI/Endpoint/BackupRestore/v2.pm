# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::BackupRestore::v2;

use strict;
use warnings;

use MT::Util;
use MT::CMS::Tools;

sub backup {
    my ( $app, $endpoint ) = @_;

    return
           unless _check_tmp_dir($app)
        && _check_backup_what($app)
        && _check_backup_archive_format($app)
        && _check_limit_size($app);

    no warnings 'redefine';
    local *MT::App::validate_magic = sub {1};
    local $app->{is_admin} = 1;

    my $param;
    my $_backup_finisher = \&MT::CMS::Tools::_backup_finisher;
    local *MT::CMS::Tools::_backup_finisher
        = sub { $param = $_[2]; $_backup_finisher->(@_) };

    MT::CMS::Tools::backup($app);

    # Error.
    if ( !$param->{backup_success} ) {
        return +{
            error => {
                code    => 500,
                message => $app->translate(
                    'An error occurred during the backup process: [_1]',
                    $param->{error}
                ),
            },
        };
    }

    # Success.
    return +{
        status      => 'success',
        backupFiles => ( $param->{files_loop} )
        ? [ map { $_->{url} } @{ $param->{files_loop} } ]
        : [ $app->uri(
                mode => 'backup_download',
                args => {
                    magic_token => $param->{magic_token},
                    filename => MT::Util::encode_html( $param->{filename} ),
                    $param->{blog_id} ? ( blog_id => $param->{blog_id} ) : (),
                },
            )
        ],
    };
}

sub _check_tmp_dir {
    my ($app) = @_;

    my $tmp = $app->config('TempDir');
    unless ( ( -d $tmp ) && ( -w $tmp ) ) {
        return $app->error(
            $app->translate(
                'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.'
            ),
            409
        );
    }

    return 1;
}

sub _check_backup_what {
    my ($app) = @_;

    if ( my $blog_id = $app->param('blog_id') ) {

        # Set default value to "backup_what" parameter.
        my $backup_what = join ',',
            MT::CMS::Tools::_allowed_blog_ids_for_backup( $app, $blog_id );
        $app->param( 'backup_what', $backup_what );
    }
    else {

        # Check backup_what.
        if ( !defined $app->param('backup_what') ) {
            return $app->error(
                $app->translate('A parameter "backup_what" is required.'),
                400 );
        }

        my $backup_what = $app->param('backup_what');
        my @blog_ids    = split ',', $backup_what;
        my @blogs       = $app->model('blog')->load( { id => \@blog_ids } );
        if ( scalar @blog_ids != scalar @blogs ) {
            return $app->error(
                $app->translate(
                    '"backup_what" is invalid: [_1]', $backup_what
                ),
                400
            );
        }
    }

    return 1;
}

sub _check_backup_archive_format {
    my ($app) = @_;

    my $backup_archive_format = $app->param('backup_archive_format');
    if ( !defined $backup_archive_format ) {

        # Set default value to "backup_archive_format" parameter.
        $app->param( 'backup_archive_format', 0 );
    }
    else {

        # Check bakcup_archive_format.
        require MT::Util::Archive;
        my @formats = MT::Util::Archive->available_formats();

        unless ( grep { $backup_archive_format eq $_->{key} } @formats ) {
            return $app->error(
                $app->translate(
                    '"backup_archive_format" is invalid: [_1]',
                    $backup_archive_format
                ),
                400
            );
        }
    }

    return 1;
}

sub _check_limit_size {
    my ($app) = @_;
    my $limit_size = $app->param('limit_size');

    if ( $limit_size && $limit_size !~ m/^\d+$/ ) {
        return $app->error(
            $app->translate( '"limit_size" is invalid: [_1]', $limit_size ),
            400 );
    }

    return 1;
}

sub restore {
    my ( $app, $endpoint ) = @_;

    if ( !defined $app->param('file') ) {
        return $app->error(
            $app->translate('A parameter "file" is required.'), 400 );
    }

    local $app->{no_print_body};

    no warnings 'redefine';
    local *MT::App::validate_magic = sub {1};

    my ( $file, $param );
    my $build_page = \&MT::build_page;
    local *MT::build_page
        = sub { $file = $_[1]; $param = $_[2]; $build_page->(@_) };

    MT::CMS::Tools::restore($app);

    # TODO: Implement adjust_sitepath process.

    if ( $param->{restore_success} ) {
        return +{
            status => 'success',
            !$param->{restore_upload}
            ? ( message => $app->translate(
                    "Make sure that you remove the files that you restored from the 'import' folder, so that if/when you run the restore process again, those files will not be re-restored."
                )
                )
            : (),
        };
    }
    else {
        return $app->error(
            $app->translate(
                'An error occurred during the restore process: [_1] Please check activity log for more details.',
                $param->{error}
            ),
            500
        );
    }

}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::BackupRestore::v2 - Movable Type class for endpoint definitions about the MT::BackupRestore.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
