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

    # list_plugins - normal tests.
    {   path   => '/v2/plugins',
        method => 'GET',
        result => sub {

            my %param;
            require MT::CMS::Plugin;
            MT::CMS::Plugin::build_plugin_table(
                $app,
                param => \%param,
                scope => 'system'
            );

            require MT::DataAPI::Endpoint::v2::Plugin;
            my $list = MT::DataAPI::Endpoint::v2::Plugin::_to_object(
                $param{plugin_loop} );
            return $list;
        },
    },

    # get_plugin - irregular tests.
    {    # Non-existent plugin.
        path   => '/v2/plugins/not_exsits',
        method => 'GET',
        code   => 404,
        result => sub {
            return +{
                error => {
                    code    => 404,
                    message => 'Plugin not found',
                },
            };
        },
    },

    # get_plugin - normal tests.
    {   path   => '/v2/plugins/Awesome',
        method => 'GET',
        result => sub {

            my %param;
            MT::CMS::Plugin::build_plugin_table(
                $app,
                param => \%param,
                scope => 'system'
            );

            my $plugin_id = 'Awesome';

            my @plugin_loop
                = grep { $_->{plugin_folder} || $_->{plugin_sig} eq $plugin_id }
                @{ $param{plugin_loop} };

            my ($plugin) = @{
                MT::DataAPI::Endpoint::v2::Plugin::_to_object(
                    \@plugin_loop
                )
            };
            return $plugin;
        },
    },

    # enable_plugin - irregular tests.
    {    # Non-existent plugin.
        path   => '/v2/plugins/not_exists/enable',
        method => 'POST',
        code   => 404,
        result => sub {
            return +{
                error => {
                    code    => 404,
                    message => 'Plugin not found',
                },
            };
        },
    },

    # enable_plugin - normal tests.
    {   path   => '/v2/plugins/Awesome/enable',
        method => 'POST',
        result => sub {
            return +{ status => 'success', };
        },
        complete => sub {
            my $plugin_switch = $app->config->PluginSwitch;
            ok( exists $plugin_switch->{Awesome},
                'Awesome exists in PluginSwitch.'
            );
            is( $plugin_switch->{Awesome},
                1, 'PluginSwitch of Awesome is 1.' );
        },
    },

    # disable_plugin - irregular tests.
    {    # Non-existent plugin.
        path   => '/v2/plugins/not_existes/disable',
        method => 'POST',
        code   => 404,
        result => sub {
            return +{
                error => {
                    code    => 404,
                    message => 'Plugin not found',
                },
            };
        },
    },

    # disable_plugin - normal tests.
    {   path   => '/v2/plugins/Awesome/disable',
        method => 'POST',
        result => sub {
            return +{ status => 'success', };
        },
        complete => sub {
            my $plugin_switch = $app->config->PluginSwitch;
            ok( exists $plugin_switch->{Awesome},
                'Awesome exists in PluginSwitch.'
            );
            is( $plugin_switch->{Awesome},
                0, 'PluginSwitch of Awesome is 0.' );
        },
    },

    # enable_all_plugins - normal tests.
    {   path   => '/v2/plugins/enable',
        method => 'POST',
        result => sub {
            return +{ status => 'success', };
        },
        complete => sub {
            is( $app->config->UsePlugins, 1, 'UsePlugins is 1.' );
        },
    },

    # disable_all_plugins - normal tests.
    {   path   => '/v2/plugins/disable',
        method => 'POST',
        result => sub {
            return +{ status => 'success', };
        },
        complete => sub {
            is( $app->config->UsePlugins, 0, 'UsePlugins is 0.' );
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
