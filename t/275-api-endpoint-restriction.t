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

my $website_entry = $app->model('entry')->new;
$website_entry->set_values(
    {   blog_id   => 2,
        author_id => 1,
        status    => 1,
    }
);
$website_entry->save or die $website_entry->errstr;

my $website = $app->model('website')->load(2) or die;
my $role = $app->model('role')->load( { name => 'Website Administrator' } )
    or die;

require MT::Association;
MT::Association->link( $author, $website, $role );

my @suite = (

    # No restriction.
    {
        # superuser.
        # blog.
        path     => '/v2/sites/1/entries',
        method   => 'GET',
        setup    => sub { $is_superuser = 1 },
        complete => sub {
            my ( $data, $body ) = @_;
            my $got = $app->current_format->{unserialize}->($body);
            is( $got->{totalResults}, 8, 'No restriction, superuser, blog.' );
        },
    },
    {
        # superuser.
        # website.
        path     => '/v2/sites/2/entries',
        method   => 'GET',
        setup    => sub { $is_superuser = 1 },
        complete => sub {
            my ( $data, $body ) = @_;
            my $got = $app->current_format->{unserialize}->($body);
            is( $got->{totalResults}, 1,
                'No restriction, superuser, website.' );
        },
    },
    {
        # superuser.
        # system.
        path     => '/v2/sites/0/entries',
        method   => 'GET',
        setup    => sub { $is_superuser = 1 },
        complete => sub {
            my ( $data, $body ) = @_;
            my $got = $app->current_format->{unserialize}->($body);
            is( $got->{totalResults}, 9,
                'No restriction, superuser, system.' );
        },
    },
    {
        # non-superuser.
        # blog.
        path     => '/v2/sites/1/entries',
        method   => 'GET',
        setup    => sub { $is_superuser = 0 },
        complete => sub {
            my ( $data, $body ) = @_;
            my $got = $app->current_format->{unserialize}->($body);
            is( $got->{totalResults}, 8,
                'No restriction, non-superuser, blog.' );
        },
    },
    {
        # non-superuser.
        # website.
        path     => '/v2/sites/2/entries',
        method   => 'GET',
        setup    => sub { $is_superuser = 0 },
        complete => sub {
            my ( $data, $body ) = @_;
            my $got = $app->current_format->{unserialize}->($body);
            is( $got->{totalResults}, 1,
                'No restriction, non-superuser, website.' );
        },
    },

#    {
#        # non-superuser.
#        # system.
#        path     => '/v2/sites/0/entries',
#        method   => 'GET',
#        setup    => sub { $is_superuser = 0 },
#        complete => sub {
#            my ( $data, $body ) = @_;
#            my $got = $app->current_format->{unserialize}->($body);
#            is( $got->{totalResults}, 9, 'No restriction, non-superuser, system.' );
#        },
#    },

    # Restriction.
    {
        # superuser.
        # blog.
        path   => '/v2/sites/1/entries',
        method => 'GET',
        setup  => sub {
            $app->config->DataAPIDisableSite(1);
            $app->config->save_config;
            $is_superuser = 1;
        },
        complete => sub {
            my ( $data, $body ) = @_;
            my $got = $app->current_format->{unserialize}->($body);
            is( $got->{totalResults}, 8, 'Restriction, superuser, blog.' );
        },
    },
    {
        # superuser.
        # website.
        path   => '/v2/sites/2/entries',
        method => 'GET',
        setup  => sub {
            $is_superuser = 1;
        },
        complete => sub {
            my ( $data, $body ) = @_;
            my $got = $app->current_format->{unserialize}->($body);
            is( $got->{totalResults}, 1, 'Restriction, superuser, website.' );
        },
    },
    {
        # superuser.
        # system.
        path   => '/v2/sites/0/entries',
        method => 'GET',
        setup  => sub {
            $is_superuser = 1;
        },
        complete => sub {
            my ( $data, $body ) = @_;
            my $got = $app->current_format->{unserialize}->($body);
            is( $got->{totalResults}, 9, 'Restriction, superuser, system.' );
        },
    },
    {
        # non-superuser.
        # blog.
        path   => '/v2/sites/1/entries',
        method => 'GET',
        setup  => sub { $is_superuser = 0 },
        code   => 403,
    },
    {
        # non-superuser.
        # website.
        path     => '/v2/sites/2/entries',
        method   => 'GET',
        setup    => sub { $is_superuser = 0 },
        complete => sub {
            my ( $data, $body ) = @_;
            my $got = $app->current_format->{unserialize}->($body);
            is( $got->{totalResults}, 1,
                'Restriction, non-superuser, website.' );
        },
    },
    {
        # non-superuser.
        # system.
        path     => '/v2/sites/0/entries',
        method   => 'GET',
        setup    => sub { $is_superuser = 0 },
        complete => sub {
            my ( $data, $body ) = @_;
            my $got = $app->current_format->{unserialize}->($body);
            is( $got->{totalResults}, 1,
                'Restriction, non-superuser, system.' );
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
