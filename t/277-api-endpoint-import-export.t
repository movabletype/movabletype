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

use boolean ();

use MT::Entry;

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

    # export_entries - irregular tests.
    {    # Non-existent site.
        path   => '/v2/sites/10/entries/export',
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
    {    # System.
        path   => '/v2/sites/0/entries/export',
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

    # export_entries - normal tests.
    {    # Blog.
        path   => '/v2/sites/1/entries/export',
        method => 'GET',
    },
    {    # Whbsite.
        path   => '/v2/sites/2/entries/export',
        method => 'GET',
    },

    # import_entries - irregular tests.
    {    # Non-existent site.
        path   => '/v2/sites/10/entries/import',
        method => 'POST',
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
    {    # System.
        path   => '/v2/sites/0/entries/import',
        method => 'POST',
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
    {    # No file.
        path   => '/v2/sites/1/entries/import',
        method => 'POST',
        code   => 500,
        result => sub {
            return +{
                error => {
                    code => 500,
                    message =>
                        'An error occurred during the import process: . Please check your import file.',
                },
            };
        },
    },
    {    # import_as_me=0 and no password.
        path   => '/v2/sites/1/entries/import',
        method => 'POST',
        params => { import_as_me => 0 },
        upload => [
            'file',
            File::Spec->catfile(
                $ENV{MT_HOME},                      "t",
                '277-api-endpoint-import-export.d', 'first_entry.txt'
            ),
        ],
        code   => 400,
        result => sub {
            return +{
                error => {
                    code => 400,
                    message =>
                        'You need to provide a parameter "password" if you are going to create new users for each user listed in your blog.',
                },
            };
        },
        complete => sub {
            my $entry = $app->model('entry')
                ->load( { blog_id => 1, title => 'First Entry' } );
            is( $entry, undef, 'An entry has not been imported.' );
        },
    },
    {    # import_as_me=0 and invalid password.
        path   => '/v2/sites/1/entries/import',
        method => 'POST',
        params => {
            import_as_me => 0,
            password     => 123,
        },
        upload => [
            'file',
            File::Spec->catfile(
                $ENV{MT_HOME},                      "t",
                '277-api-endpoint-import-export.d', 'first_entry.txt'
            ),
        ],
        code   => 400,
        result => sub {
            return +{
                error => {
                    code    => 400,
                    message => 'Password should be longer than 8 characters',
                },
            };
        },
        complete => sub {
            my $entry = $app->model('entry')
                ->load( { blog_id => 1, title => 'First Entry' } );
            is( $entry, undef, 'An entry has not been imported.' );
        },
    },
    {    # Invalid import_type.
        path   => '/v2/sites/1/entries/import',
        method => 'POST',
        params => { import_type => 'invalid', },
        upload => [
            'file',
            File::Spec->catfile(
                $ENV{MT_HOME},                      "t",
                '277-api-endpoint-import-export.d', 'first_entry.txt'
            ),
        ],
        code   => 400,
        result => sub {
            return +{
                error => {
                    code    => 400,
                    message => 'Invalid import_type: invalid',
                },
            };
        },
        complete => sub {
            my $entry = $app->model('entry')
                ->load( { blog_id => 1, title => 'First Entry' } );
            is( $entry, undef, 'An entry has not been imported.' );
        },
    },
    {    # Invalid endoing.
        path   => '/v2/sites/1/entries/import',
        method => 'POST',
        params => { encoding => 'invalid', },
        upload => [
            'file',
            File::Spec->catfile(
                $ENV{MT_HOME},                      "t",
                '277-api-endpoint-import-export.d', 'first_entry.txt'
            ),
        ],
        code   => 400,
        result => sub {
            return +{
                error => {
                    code    => 400,
                    message => 'Invalid encoding: invalid',
                },
            };
        },
        complete => sub {
            my $entry = $app->model('entry')
                ->load( { blog_id => 1, title => 'First Entry' } );
            is( $entry, undef, 'An entry has not been imported.' );
        },
    },
    {    # Invalid convert_breaks.
        path   => '/v2/sites/1/entries/import',
        method => 'POST',
        params => { convert_breaks => 'invalid', },
        upload => [
            'file',
            File::Spec->catfile(
                $ENV{MT_HOME},                      "t",
                '277-api-endpoint-import-export.d', 'first_entry.txt'
            ),
        ],
        code   => 400,
        result => sub {
            return +{
                error => {
                    code    => 400,
                    message => 'Invalid convert_breaks: invalid',
                },
            };
        },
        complete => sub {
            my $entry = $app->model('entry')
                ->load( { blog_id => 1, title => 'First Entry' } );
            is( $entry, undef, 'An entry has not been imported.' );
        },
    },
    {    # Invalid default_cat_id.
        path   => '/v2/sites/1/entries/import',
        method => 'POST',
        params => { default_cat_id => 100, },
        upload => [
            'file',
            File::Spec->catfile(
                $ENV{MT_HOME},                      "t",
                '277-api-endpoint-import-export.d', 'first_entry.txt'
            ),
        ],
        code   => 400,
        result => sub {
            return +{
                error => {
                    code    => 400,
                    message => 'Invalid default_cat_id: 100',
                },
            };
        },
        complete => sub {
            my $entry = $app->model('entry')
                ->load( { blog_id => 1, title => 'First Entry' } );
            is( $entry, undef, 'An entry has not been imported.' );
        },
    },

    # import_entries - normal tests.
    {    # Blog.
        path   => '/v2/sites/1/entries/import',
        method => 'POST',
        upload => [
            'file',
            File::Spec->catfile(
                $ENV{MT_HOME},                      "t",
                '277-api-endpoint-import-export.d', 'first_entry.txt'
            ),
        ],
        result => sub {
            return +{ status => 'success', };
        },
        complete => sub {
            my $entry = $app->model('entry')
                ->load( { blog_id => 1, title => 'First Entry' } );
            ok( $entry, 'A entry has been imported.' );
        },
    },
    {    # Website.
        path   => '/v2/sites/2/entries/import',
        method => 'POST',
        upload => [
            'file',
            File::Spec->catfile(
                $ENV{MT_HOME},                      "t",
                '277-api-endpoint-import-export.d', 'second_entry.txt'
            ),
        ],
        result => sub {
            return +{ status => 'success', };
        },
        complete => sub {
            my $entry = $app->model('entry')
                ->load( { blog_id => 2, title => 'Second Entry' } );
            ok( $entry, 'A entry has been imported.' );
        },
    },
    {    # import_as_me=0.
        path   => '/v2/sites/1/entries/import',
        method => 'POST',
        params => {
            import_as_me => 0,
            password     => 'password',
        },
        upload => [
            'file',
            File::Spec->catfile(
                $ENV{MT_HOME},                      "t",
                '277-api-endpoint-import-export.d', 'third_entry.txt'
            ),
        ],
        result => sub {
            return +{ status => 'success', };
        },
        complete => sub {
            my $entry = $app->model('entry')
                ->load( { blog_id => 1, title => 'Third Entry' } );
            ok( $entry, 'A entry has been imported.' );
        },
    },
    {    # import_type=import_mt_format.
        path   => '/v2/sites/1/entries/import',
        method => 'POST',
        params => { import_type => 'import_mt_format', },
        upload => [
            'file',
            File::Spec->catfile(
                $ENV{MT_HOME},                      "t",
                '277-api-endpoint-import-export.d', 'fourth_entry.txt'
            ),
        ],
        result => sub {
            return +{ status => 'success', };
        },
        complete => sub {
            my $entry = $app->model('entry')
                ->load( { blog_id => 1, title => 'Fourth Entry' } );
            ok( $entry, 'A entry has been imported.' );
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
