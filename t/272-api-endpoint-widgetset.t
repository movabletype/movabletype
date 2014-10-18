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

use MT::DataAPI::Endpoint::WidgetSet::v2;

use MT::App::DataAPI;
my $app    = MT::App::DataAPI->new;
my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

my $mock_author = Test::MockModule->new('MT::Author');
$mock_author->mock( 'is_superuser', sub {0} );
my $mock_app_api = Test::MockModule->new('MT::App::DataAPI');
$mock_app_api->mock( 'authenticate', $author );
my $version;
$mock_app_api->mock( 'current_api_version',
    sub { $version = $_[1] if $_[1]; $version } );

my @suite = (

    # list_widgetsets - irregular tests
    {    # Non-existent site.
        path   => '/v2/sites/5/widgetsets',
        method => 'GET',
        code   => 404,
    },

    # list_widgetsets - normal tests
    {   path   => '/v2/sites/1/widgetsets',
        method => 'GET',
    },

    # get_widgetset - irregular tests
    {    # Non-existent widgetset.
        path   => '/v2/sites/1/widgetsets/500',
        method => 'GET',
        code   => 404,
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/widgetsets/136',
        method => 'GET',
        code   => 404,
    },
    {    # Other site.
        path   => '/v2/sites/2/widgetsets/136',
        method => 'GET',
        code   => 404,
    },
    {    # Other site (system).
        path   => '/v2/sites/0/widgetsets/136',
        method => 'GET',
        code   => 404,
    },
    {    # Not widgetset (index template).
        path   => '/v2/sites/2/widgetsets/133',
        method => 'GET',
        code   => 404,
    },

    # get_widgetset - normal tests
    {   path   => '/v2/sites/1/widgetsets/136',
        method => 'GET',
        result => sub {
            my $ws = $app->model('template')->load(
                {   id      => 136,
                    blog_id => 1,
                    type    => 'widgetset',
                }
            );
            return MT::DataAPI::Endpoint::WidgetSet::v2::_from_object($ws);
        },
    },

    # create_widgetset - irregular tests
    {    # No resource.
        path     => '/v2/sites/1/widgetsets',
        method   => 'POST',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                'A resource "widgetset" is required.' );
        },
    },
    {    # No name.
        path     => '/v2/sites/1/widgetsets',
        method   => 'POST',
        params   => { widgetset => {}, },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"name\" is required.\n" );
        },
    },

    # create_widgetset - normal tests
    {   path   => '/v2/sites/1/widgetsets',
        method => 'POST',
        params => {
            widgetset => {
                name    => 'create-widgetset',
                widgets => [ { id => 132 }, { id => 131 }, ],
            },
        },
        result => sub {
            my $ws = $app->model('template')->load(
                {   blog_id => 1,
                    name    => 'create-widgetset',
                    type    => 'widgetset',
                }
            );
            return MT::DataAPI::Endpoint::WidgetSet::v2::_from_object($ws);
        },
    },

    # update_widgetset - irregular tests
    {    # No resource.
        path     => '/v2/sites/1/widgetsets/136',
        method   => 'PUT',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                'A resource "widgetset" is required.' );
        },
    },

    # update_widgetset - normal tests
    {   path   => '/v2/sites/1/widgetsets/136',
        method => 'PUT',
        params => {
            widgetset => {
                name    => 'update-widgetset',
                widgets => [ { id => 105 }, { id => 107 }, ],
            },
        },
        result => sub {
            my $ws = $app->model('template')->load(
                {   id      => 136,
                    blog_id => 1,
                    name    => 'update-widgetset',
                    type    => 'widgetset',
                }
            );
            return MT::DataAPI::Endpoint::WidgetSet::v2::_from_object($ws);
        },
    },

    # delete_widgetset - irregular tests
    {    # Non-eixstent widgetset.
        path   => '/v2/sites/1/widgetsets/500',
        method => 'DELETE',
        code   => 404,
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/widgetsets/136',
        method => 'DELETE',
        code   => 404,
    },
    {    # Other site.
        path   => '/v2/sites/2/widgetsets/136',
        method => 'DELETE',
        code   => 404,
    },
    {    # Other site (system).
        path   => '/v2/sites/0/widgetsets/136',
        method => 'DELETE',
        code   => 404,
    },
    {    # Not widgetset (index template).
        path   => '/v2/sites/2/widgetsets/133',
        method => 'DELETE',
        code   => 404,
    },

    # delete_widgetset - normal tests
    {   path   => '/v2/sites/1/widgetsets/136',
        method => 'DELETE',
        setup  => sub {
            die if !$app->model('template')->load(136);
        },
        complete => sub {
            my $ws = $app->model('template')->load(
                {   id      => 136,
                    blog_id => 1,
                    type    => 'widgetset',
                }
            );
            is( $ws, undef, 'Deleted widgetset.' );
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
