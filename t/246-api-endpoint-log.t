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

    # create_log - irregular tests
    {    # No resource.
        path     => '/v2/sites/1/logs',
        method   => 'POST',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, "A resource \"log\" is required." );
        },
    },

    {    # No message.
        path     => '/v2/sites/1/logs',
        method   => 'POST',
        params   => { log => {} },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A paramter \"message\" is required.\n" );
        },
    },

    # create_log - normal tests
    {   path      => '/v2/sites/1/logs',
        method    => 'POST',
        params    => { log => { message => 'create-log-site-1', }, },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_save_permission_filter.log',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_save_filter.log',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_pre_save.log',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_save.log',
                count => 1,
            },
        ],
        result => sub {
            MT->model('log')
                ->load( { blog_id => 1, message => 'create-log-site-1' } );
        },
    },
    {   path   => '/v2/sites/1/logs',
        method => 'POST',
        params => {
            log => {
                message  => 'create-log-site-1-with-params',
                metadata => 'metadata',
                by       => { id => 1 },
                level    => 'DEBUG',
                category => 'entry',
            },
        },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_save_permission_filter.log',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_save_filter.log',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_pre_save.log',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_save.log',
                count => 1,
            },
        ],
        result => sub {
            MT->model('log')->load(
                {   class   => '*',
                    blog_id => 1,
                    message => 'create-log-site-1-with-params'
                }
            );
        },
    },

    # list_logs - irregular tests
    {    # Non-existent site.
        path   => '/v2/sites/5/logs',
        method => 'GET',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Site not found',
                },
            };
        },
    },

    # list_logs - normal tests
    {   path      => '/v2/sites/1/logs',
        method    => 'GET',
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.log',
                count => 2,
            },
        ],
        complete => sub {
            my ( $data, $body ) = @_;

            my $got_logs = $app->current_format->{unserialize}->($body);
            my @expected_logs
                = MT->model('log')->load( { class => '*', blog_id => 1 },
                { sort => 'created_on', direction => 'descend' } );

            my @got_log_ids      = map { $_->{id} } @{ $got_logs->{items} };
            my @expected_log_ids = map { $_->id } @expected_logs;

            is_deeply( \@got_log_ids, \@expected_log_ids,
                'IDs of items are "' . "@got_log_ids" . '"' );
        },
    },
    {    # Search message.
        path      => '/v2/sites/1/logs',
        method    => 'GET',
        params    => { search => 'with-param', },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.log',
                count => 2,
            },
        ],
        result => sub {
            $app->user($author);

            my @logs = $app->model('log')->load(
                {   blog_id => 1,
                    message => { like => '%with-param%' },
                }
            );

            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 1,
                items        => MT::DataAPI::Resource->from_object( \@logs ),
            };
        },
    },
    {    # Search ip.
        path   => '/v2/sites/1/logs',
        method => 'GET',
        params => { search => '192.168', },
        setup  => sub {
            my $log = $app->model('log')->load( { blog_id => 1 } );
            $log->ip('192.168.56.1');
            $log->save or die $log->errstr;
        },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.log',
                count => 2,
            },
        ],
        result => sub {
            $app->user($author);

            my @logs = $app->model('log')->load(
                {   blog_id => 1,
                    ip      => { like => '%192.168%' },
                }
            );

            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 1,
                items        => MT::DataAPI::Resource->from_object( \@logs ),
            };
        },
    },
    {    # Filter by level (info).
        path      => '/v2/sites/1/logs',
        method    => 'GET',
        params    => { level => 'info', },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.log',
                count => 2,
            },
        ],
        result => sub {
            $app->user($author);

            my @logs = $app->model('log')->load(
                {   blog_id => 1,
                    level   => MT::Log::INFO(),
                }
            );

            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 1,
                items        => MT::DataAPI::Resource->from_object( \@logs ),
            };
        },
    },
    {    # Filter by level (error).
        path      => '/v2/sites/1/logs',
        method    => 'GET',
        params    => { level => 'error', },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.log',
                count => 1,
            },
        ],
        result => sub {
            $app->user($author);

            my @logs = $app->model('log')->load(
                {   blog_id => 1,
                    level   => MT::Log::ERROR(),
                }
            );

            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 0,
                items        => MT::DataAPI::Resource->from_object( \@logs ),
            };
        },
    },

    # export_log - normal tests
    {   path   => '/v2/sites/1/logs/export',
        method => 'GET',
    },

    # update_log - irregular tests
    {    # Non-existent site.
        path   => '/v2/sites/10/logs/1',
        method => 'PUT',
        params => { log => { message => 'update-log-site-1', }, },
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Site not found',
                },
            };
        },
    },
    {    # Non-existent log.
        path   => '/v2/sites/1/logs/10',
        method => 'PUT',
        params => { log => { message => 'update-log-site-1', }, },
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Log not found',
                },
            };
        },
    },
    {    # Other site.
        path   => '/v2/sites/2/logs/1',
        method => 'PUT',
        params => { log => { message => 'update-log-site-1', }, },
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Log not found',
                },
            };
        },
    },
    {    # Other site (system).
        path   => '/v2/sites/0/logs/1',
        method => 'PUT',
        params => { log => { message => 'update-log-site-1', }, },
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Log not found',
                },
            };
        },
    },

    # update_log - normal tests
    {   path   => '/v2/sites/1/logs/1',
        method => 'PUT',
        setup  => sub {
            MT->model('log')->load(1)
                and !MT->model('log')
                ->load( { class => '*', message => 'update-log-site-1' } );
        },
        params    => { log => { message => 'update-log-site-1', }, },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_save_permission_filter.log',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_save_filter.log',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_pre_save.log',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_save.log',
                count => 1,
            },
        ],
        result => sub {
            MT->model('log')
                ->load( { message => 'update-log-site-1', blog_id => 1, } );
        },
    },

    # delete_log - irregular tests
    {    # Non-existent site.
        path   => '/v2/sites/10/logs/1',
        method => 'DELETE',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Site not found',
                },
            };
        },
    },
    {    # Non-existent log.
        path   => '/v2/sites/1/logs/10',
        method => 'DELETE',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Log not found',
                },
            };
        },
    },
    {    # Other site.
        path   => '/v2/sites/2/logs/1',
        method => 'DELETE',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Log not found',
                },
            };
        },
    },
    {    # Other site (system).
        path   => '/v2/sites/0/logs/1',
        method => 'DELETE',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Log not found',
                },
            };
        },
    },

    # delete_log - normal tests
    {   path      => '/v2/sites/1/logs/1',
        method    => 'DELETE',
        setup     => sub { MT->model('log')->load(1) or die },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_delete_permission_filter.log',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_delete.log',
                count => 1,
            },
        ],
        complete => sub {
            is( MT->model('log')->load(1),
                undef, 'A log (ID:1) was deleted.' );
        },
    },

    # reset_logs - irregular tests
    {    # Non-existent site.
        path   => '/v2/sites/10/logs',
        method => 'DELETE',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Site not found',
                },
            };
        },
    },

    # reset_logs - normal tests
    {   path     => '/v2/sites/0/logs',
        method   => 'DELETE',
        setup    => sub { MT->model('log')->load( { class => '*' } ) or die },
        complete => sub {
            my @logs = MT->model('log')->load( { class => '*' } );
            is( scalar @logs, 1, 'There is one log.' );
            is( $logs[0]->category, 'reset_log',
                'All logs except reset_log were deleted.' );
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
