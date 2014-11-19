#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

BEGIN {
    use Test::More;
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

use lib qw(lib extlib t/lib);

eval(
    $ENV{SKIP_REINITIALIZE_DATABASE}
    ? "use MT::Test qw(:app);"
    : "use MT::Test qw(:app :db :data);"
);

use Data::Dumper;
use boolean ();

use MT::App::DataAPI;
my $app    = MT::App::DataAPI->new;
my $author = MT->model('author')->load(1);

my $mock_author  = Test::MockModule->new('MT::Author');
my $is_superuser = 1;
$mock_author->mock( 'is_superuser', sub {$is_superuser} );
my $mock_app_api = Test::MockModule->new('MT::App::DataAPI');
$mock_app_api->mock( 'authenticate', $author );
my $version;
$mock_app_api->mock( 'current_api_version',
    sub { $version = $_[1] if $_[1]; $version } );

my @suite = (

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
        setup  => sub { $app->config->TempDir('/') },
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
        complete =>
            sub { $app->config->TempDir( $app->config->default('TempDir') ) },
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

    # backup_site - normal tests.
    {    # Blog.
        path     => '/v2/sites/1/backup',
        method   => 'GET',
        complete => sub {
            my ( $data, $body ) = @_;

            ($body) = ( $body =~ m/(\{.+\})/ );
            my $got = $app->current_format->{unserialize}->($body);

            is( $got->{status}, 'success', 'status is success.' );
            is( scalar @{ $got->{backupFiles} },
                3, 'Returned 3 backup files.' );

            print Dumper($got) . "\n";
        },
    },
    {    # Website.
        path     => '/v2/sites/2/backup',
        method   => 'GET',
        complete => sub {
            my ( $data, $body ) = @_;

            ($body) = ( $body =~ m/(\{.+\})/ );
            my $got = $app->current_format->{unserialize}->($body);

            is( $got->{status}, 'success', 'status is success.' );
            is( scalar @{ $got->{backupFiles} },
                3, 'Returned 3 backup files.' );

            print Dumper($got) . "\n";
        },
    },

    # System.
    {    # Website.
        path     => '/v2/sites/0/backup',
        method   => 'GET',
        complete => sub {
            my ( $data, $body ) = @_;

            ($body) = ( $body =~ m/(\{.+\})/ );
            my $got = $app->current_format->{unserialize}->($body);

            is( $got->{status}, 'success', 'status is success.' );
            is( scalar @{ $got->{backupFiles} },
                4, 'Returned 4 backup files.' );

            print Dumper($got) . "\n";
        },
    },

    # restore_site - irregular tests.
    {    # No file.
        path   => '/v2/restore',
        method => 'POST',
        code   => 400,
        result => sub {
            return +{
                error => {
                    code    => 400,
                    message => 'A parameter "file" is required.',
                },
            };
        },
    },
    {    # Old schema version.
        path   => '/v2/restore',
        method => 'POST',
        upload => [
            'file',
            File::Spec->catfile(
                $ENV{MT_HOME},                       "t",
                '278-api-endpoint-backup-restore.d', 'backup.xml'
            ),
        ],
        code     => 500,
        complete => sub {
            my ( $data, $body ) = @_;

            ($body) = ( $body =~ m/(\{.+\})/ );
            my $got = $app->current_format->{unserialize}->($body);

            my $error_message
                = qr/An error occurred during the restore process: The uploaded backup manifest file was created with Movable Type, but the schema version/;
            like( $got->{error}{message},
                $error_message, 'Error message is OK.' );
        },
    },

    # restore_site - normal tests.
    {   path   => '/v2/restore',
        method => 'POST',
        upload => [
            'file',
            File::Spec->catfile(
                $ENV{MT_HOME},                       "t",
                '278-api-endpoint-backup-restore.d', 'backup.xml'
            ),
        ],
        setup => sub {
            my $file = File::Spec->catfile( $ENV{MT_HOME}, "t",
                '278-api-endpoint-backup-restore.d', 'backup.xml' );
            my $schema_version = $MT::SCHEMA_VERSION;
            system "perl -i -pe \"s{6\\.0008}{$schema_version}g\" $file";
        },
        complete => sub {
            my ( $data, $body ) = @_;

            ($body) = ( $body =~ m/(\{.+\})/ );
            my $got = $app->current_format->{unserialize}->($body);

            my $expected = +{ status => 'success', };

            is_deeply( $got, $expected );
        },
    },

);

my %callbacks = ();
my $mock_mt   = Test::MockModule->new('MT');
$mock_mt->mock(
    'run_callbacks',
    sub {
        my ( $app, $meth, @param ) = @_;
        $callbacks{$meth} ||= [];
        push @{ $callbacks{$meth} }, \@param;
        $mock_mt->original('run_callbacks')->(@_);
    }
);

my $format = MT::DataAPI::Format->find_format('json');

for my $data (@suite) {
    $data->{setup}->($data) if $data->{setup};

    my $path = $data->{path};
    $path
        =~ s/:(?:(\w+)_id)|:(\w+)/ref $data->{$1} ? $data->{$1}->id : $data->{$2}/ge;

    my $params
        = ref $data->{params} eq 'CODE'
        ? $data->{params}->($data)
        : $data->{params};

    my $note = $path;
    if ( lc $data->{method} eq 'get' && $data->{params} ) {
        $note .= '?'
            . join( '&',
            map { $_ . '=' . $data->{params}{$_} }
                keys %{ $data->{params} } );
    }
    $note .= ' ' . $data->{method};
    $note .= ' ' . $data->{note} if $data->{note};
    note($note);

    %callbacks = ();
    _run_app(
        'MT::App::DataAPI',
        {   __path_info      => $path,
            __request_method => $data->{method},
            ( $data->{upload} ? ( __test_upload => $data->{upload} ) : () ),
            (   $params
                ? map {
                    $_ => ref $params->{$_}
                        ? MT::Util::to_json( $params->{$_} )
                        : $params->{$_};
                    }
                    keys %{$params}
                : ()
            ),
        }
    );
    my $out = delete $app->{__test_output};
    my ( $headers, $body ) = split /^\s*$/m, $out, 2;
    my %headers = map {
        my ( $k, $v ) = split /\s*:\s*/, $_, 2;
        $v =~ s/(\r\n|\r|\n)\z//;
        lc $k => $v
        }
        split /\n/, $headers;
    my $expected_status = $data->{code} || 200;
    is( $headers{status}, $expected_status, 'Status ' . $expected_status );
    if ( $data->{next_phase_url} ) {
        like(
            $headers{'x-mt-next-phase-url'},
            $data->{next_phase_url},
            'X-MT-Next-Phase-URL'
        );
    }

    foreach my $cb ( @{ $data->{callbacks} } ) {
        my $params_list = $callbacks{ $cb->{name} } || [];
        if ( my $params = $cb->{params} ) {
            for ( my $i = 0; $i < scalar(@$params); $i++ ) {
                is_deeply( $params_list->[$i], $cb->{params}[$i] );
            }
        }

        if ( my $c = $cb->{count} ) {
            is( @$params_list, $c,
                $cb->{name} . ' was called ' . $c . ' time(s)' );
        }
    }

    if ( my $expected_result = $data->{result} ) {
        $expected_result = $expected_result->( $data, $body )
            if ref $expected_result eq 'CODE';
        if ( UNIVERSAL::isa( $expected_result, 'MT::Object' ) ) {
            MT->instance->user($author);
            $expected_result = $format->{unserialize}->(
                $format->{serialize}->(
                    MT::DataAPI::Resource->from_object($expected_result)
                )
            );
        }

        my $result = $format->{unserialize}->($body);
        is_deeply( $result, $expected_result, 'result' );
    }

    if ( my $complete = $data->{complete} ) {
        $complete->( $data, $body );
    }
}

done_testing();

sub check_error_message {
    my ( $body, $error ) = @_;
    my $result = $app->current_format->{unserialize}->($body);
    is( $result->{error}{message}, $error, 'Error message: ' . $error );
}
