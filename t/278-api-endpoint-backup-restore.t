#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Data::Dumper;
use File::Spec;
use File::Temp qw( tempdir );
use MT::Test::DataAPI;

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

if ( $^O eq 'MSWin32' ) {
    $app->config->TempDir( File::Spec->tmpdir );
}

$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent = 0;

my $suite = suite();
test_data_api( $suite, { author_id => 1, is_superuser => 1 } );

done_testing;

sub suite {
    return +[

        # backup_site - irregular tests.
        {    # Non-existent site.
            path   => '/v2/sites/10/backup',
            method => 'GET',
            code   => 404,
            result => sub {
                return +{
                    error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Invalid TmpDir.
            path   => '/v2/sites/1/backup',
            method => 'GET',
            setup  => sub { $app->config->TempDir('NON_EXISTENT_DIR') },
            code   => 409,
            result => sub {
                return +{
                    error => {
                        code => 409,
                        message =>
                            'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.',
                    },
                };
            },
            complete => sub {
                if ( $^O eq 'MSWin32' ) {
                    $app->config->TempDir('C:\Windows\Temp');
                }
                else {
                    $app->config->TempDir( $app->config->default('TempDir') );
                }
            },
        },
        {    # Invalid backup_what.
            path   => '/v2/sites/0/backup',
            method => 'GET',
            params => { backup_what => '10', },
            code   => 400,
            result => sub {
                return +{
                    error => {
                        code    => 400,
                        message => 'Invalid backup_what: 10',
                    },
                };
            },
        },
        {    # Invalid backup_arhive_format.
            path   => '/v2/sites/1/backup',
            method => 'GET',
            params => { backup_archive_format => 'invalid', },
            code   => 400,
            result => sub {
                return +{
                    error => {
                        code    => 400,
                        message => 'Invalid backup_archive_format: invalid',
                    },
                };
            },
        },
        {    # Invalid limit_size.
            path   => '/v2/sites/1/backup',
            method => 'GET',
            params => { limit_size => 'invalid', },
            code   => 400,
            result => sub {
                return +{
                    error => {
                        code    => 400,
                        message => 'Invalid limit_size: invalid',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/1/backup',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions (site).
            path         => '/v2/sites/1/backup',
            method       => 'GET',
            is_superuser => 0,
            restrictions => { 1 => [qw/ backup_blog /], },
            code         => 403,
            error => 'Do not have permission to back up the requested site.',
        },
        {    # No permissions (system).
            path         => '/v2/sites/0/backup',
            method       => 'GET',
            is_superuser => 0,
            restrictions => { 0 => [qw/ backup_blog /], },
            code         => 403,
            error => 'Do not have permission to back up the requested site.',
        },

        # backup_site - normal tests.
        {    # Blog.
            path   => '/v2/sites/1/backup',
            method => 'GET',
            setup  => sub {
                MT->config->TempDir( tempdir( CLEANUP => 1 ) );
            },
            complete => sub {
                my ( $data, $body ) = @_;

                ($body) = ( $body =~ m/(\{.+\})/ );
                my $got = $app->current_format->{unserialize}->($body);

                is( $got->{status}, 'success', 'status is success.' );
                is( scalar @{ $got->{backupFiles} },
                    3, 'Returned 3 backup files.' );

                print Dumper($got) . "\n";

                for my $url ( @{ $got->{backupFiles} } ) {
                    my ($filename) = $url =~ m/name=([^&]+)/;
                    my $filepath = File::Spec->catfile( MT->config->TempDir,
                        $filename );
                    ok( -e $filepath, "$filepath exists" );
                }
            },
        },
        {    # Website.
            path   => '/v2/sites/2/backup',
            method => 'GET',
            setup  => sub {
                MT->config->TempDir( tempdir( CLEANUP => 1 ) );
            },
            complete => sub {
                my ( $data, $body ) = @_;

                ($body) = ( $body =~ m/(\{.+\})/ );
                my $got = $app->current_format->{unserialize}->($body);

                is( $got->{status}, 'success', 'status is success.' );
                is( scalar @{ $got->{backupFiles} },
                    3, 'Returned 3 backup files.' );

                print Dumper($got) . "\n";

                for my $url ( @{ $got->{backupFiles} } ) {
                    my ($filename) = $url =~ m/name=([^&]+)/;
                    my $filepath = File::Spec->catfile( MT->config->TempDir,
                        $filename );
                    ok( -e $filepath, "$filepath exists" );
                }
            },
        },
        {    # System.
            path   => '/v2/sites/0/backup',
            method => 'GET',
            setup  => sub {
                MT->config->TempDir( tempdir( CLEANUP => 1 ) );
            },
            complete => sub {
                my ( $data, $body ) = @_;

                ($body) = ( $body =~ m/(\{.+\})/ );
                my $got = $app->current_format->{unserialize}->($body);

                is( $got->{status}, 'success', 'status is success.' );
                is( scalar @{ $got->{backupFiles} },
                    4, 'Returned 4 backup files.' );

                print Dumper($got) . "\n";

                for my $url ( @{ $got->{backupFiles} } ) {
                    my ($filename) = $url =~ m/name=([^&]+)/;
                    my $filepath = File::Spec->catfile( MT->config->TempDir,
                        $filename );
                    ok( -e $filepath, "$filepath exists" );
                }
            },
        },
        {    # zip.
            path   => '/v2/sites/1/backup',
            method => 'GET',
            params => { backup_archive_format => 'zip', },
            setup  => sub {
                MT->config->TempDir( tempdir( CLEANUP => 1 ) );
            },
            complete => sub {
                my ( $data, $out, $headers ) = @_;
                like( $headers->{'content-type'},
                    qr/^application\/zip;/,
                    'content-type field has "application/zip;"' );
                like(
                    $headers->{'content-disposition'},
                    qr/^attachment; filename="/,
                    'content-disposition field has "attachment; filename="'
                );
            },
        },
        {    # tar.gz.
            path   => '/v2/sites/2/backup',
            method => 'GET',
            params => { backup_archive_format => 'tgz', },
            setup  => sub {
                MT->config->TempDir( tempdir( CLEANUP => 1 ) );
            },
            complete => sub {
                my ( $data, $out, $headers ) = @_;
                like( $headers->{'content-type'},
                    qr/^application\/x\-tar\-gz;/,
                    'content-type field has "application/x-tar-gz;"' );
                like(
                    $headers->{'content-disposition'},
                    qr/^attachment; filename="/,
                    'content-disposition field has "attachment; filename="'
                );
            },
        },
        {    # Do not have backup_download permission.
            path         => '/v2/sites/0/backup',
            method       => 'GET',
            params       => { backup_archive_format => 'zip' },
            restrictions => { 0 => [qw/ backup_download /], },
            setup        => sub {
                MT->config->TempDir( tempdir( CLEANUP => 1 ) );
            },
            complete => sub {
                my ( $data, $out, $headers ) = @_;
                ok( !exists $headers->{'content-disposition'},
                    'There is not content-disposition'
                );
            },
        },

#        # restore_site - irregular tests.
#        {    # No file.
#            path   => '/v2/restore',
#            method => 'POST',
#            code   => 400,
#            result => sub {
#                return +{
#                    error => {
#                        code    => 400,
#                        message => 'A parameter "file" is required.',
#                    },
#                };
#            },
#        },
#        {    # Old schema version.
#            path   => '/v2/restore',
#            method => 'POST',
#            upload => [
#                'file',
#                File::Spec->catfile(
#                    $ENV{MT_HOME},                       "t",
#                    '278-api-endpoint-backup-restore.d', 'backup.xml'
#                ),
#            ],
#            code     => 500,
#            complete => sub {
#                my ( $data, $body ) = @_;
#
#                ($body) = ( $body =~ m/(\{.+\})/ );
#                my $got = $app->current_format->{unserialize}->($body);
#
#                my $error_message
#                    = qr/An error occurred during the restore process: The uploaded backup manifest file was created with Movable Type, but the schema version/;
#                like( $got->{error}{message},
#                    $error_message, 'Error message is OK.' );
#
#            },
#        },
#        {    # Not logged in.
#            path      => '/v2/restore',
#            method    => 'POST',
#            author_id => 0,
#            code      => 401,
#            error     => 'Unauthorized',
#        },
#        {    # No permissions.
#            path   => '/v2/restore',
#            method => 'POST',
#            upload => [
#                'file',
#                File::Spec->catfile(
#                    $ENV{MT_HOME},                       "t",
#                    '278-api-endpoint-backup-restore.d', 'backup.xml'
#                ),
#            ],
#            setup => sub {
#                my $file = File::Spec->catfile( $ENV{MT_HOME}, "t",
#                    '278-api-endpoint-backup-restore.d', 'backup.xml' );
#                my $schema_version = $MT::SCHEMA_VERSION;
#                system "perl -i -pe \"s{6\\.0008}{$schema_version}g\" $file";
#            },
#            is_superuser => 0,
#            restrictions => { 0 => [qw/ restore_blog /], },
#            code         => 403,
#            error =>
#                'Do not have permission to restore the requested site data.',
#        },
#
#        # restore_site - normal tests.
#        {   path   => '/v2/restore',
#            method => 'POST',
#            upload => [
#                'file',
#                File::Spec->catfile(
#                    $ENV{MT_HOME},                       "t",
#                    '278-api-endpoint-backup-restore.d', 'backup.xml'
#                ),
#            ],
#            complete => sub {
#                my ( $data, $body ) = @_;
#
#                ($body) = ( $body =~ m/(\{.+\})/ );
#                my $got = $app->current_format->{unserialize}->($body);
#
#                my $expected = +{ status => 'success', };
#
#                is_deeply( $got, $expected );
#            },
#        },

    ];
}

