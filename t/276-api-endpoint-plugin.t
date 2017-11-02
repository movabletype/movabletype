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

use MT::Test::DataAPI;

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

# preparation.
{
    my $author = $app->model('author')->load(1);

    my $website_entry = $app->model('entry')->new;
    $website_entry->set_values(
        {   blog_id   => 2,
            author_id => 1,
            status    => 1,
        }
    );
    $website_entry->save or die $website_entry->errstr;

    my $website = $app->model('website')->load(2) or die;
    my $role = $app->model('role')->load( { name => 'Site Administrator' } )
        or die;

    require MT::Association;
    MT::Association->link( $author, $website, $role );
}

# test.
my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # list_plugins - irregular tests.
        {    # Not logged in.
            path      => '/v2/plugins',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/plugins',
            method       => 'GET',
            restrictions => { 0 => [qw/ manage_plugins /], },
            code         => 403,
            error =>
                'Do not have permission to retrieve the list of plugins.',
        },

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

                return +{
                    totalResults => scalar @$list,
                    items        => $list,
                };
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
        {    # Not logged in.
            path      => '/v2/plugins/Awesome',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/plugins/Awesome',
            method       => 'GET',
            restrictions => { 0 => [qw/ manage_plugins /], },
            code         => 403,
            error =>
                'Do not have permission to retrieve the requested plugin.',
        },

        # get_plugin - normal tests.
        {    # By signature.
            path   => '/v2/plugins/Awesome',
            method => 'GET',
            result => sub {

                my %param;
                MT::CMS::Plugin::build_plugin_table(
                    $app,
                    param => \%param,
                    scope => 'system'
                );

                my $plugin_id = 'Awesome';

                my @plugin_loop = grep {
                           $_->{plugin_folder}
                        || $_->{plugin_sig} eq $plugin_id
                } @{ $param{plugin_loop} };

                my ($plugin) = @{
                    MT::DataAPI::Endpoint::v2::Plugin::_to_object(
                        \@plugin_loop
                    )
                };
                return $plugin;
            },
        },
        {    # By id.
            path   => '/v2/plugins/64ec5077d1e64b9c18495913e02ba95915a280a4',
            method => 'GET',
            result => sub {

                my %param;
                MT::CMS::Plugin::build_plugin_table(
                    $app,
                    param => \%param,
                    scope => 'system'
                );

                my $plugin_id = 'MultiBlog/multiblog.pl';

                my @plugin_loop
                    = grep { $_->{plugin_sig} eq $plugin_id }
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
        {    # Not logged in.
            path      => '/v2/plugins/Awesome/enable',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/plugins/Awesome/enable',
            method       => 'POST',
            restrictions => { 0 => [qw/ toggle_plugin_switch /], },
            code         => 403,
            error        => 'Do not have permission to enable a plugin.',
        },

        # enable_plugin - normal tests.
        {    # By signature.
            path   => '/v2/plugins/Awesome/enable',
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
        {    # By id.
            path =>
                '/v2/plugins/64ec5077d1e64b9c18495913e02ba95915a280a4/enable',
            method => 'POST',
            result => sub {
                return +{ status => 'success', };
            },
            complete => sub {
                my $plugin_switch = $app->config->PluginSwitch;
                ok( exists $plugin_switch->{'MultiBlog/multiblog.pl'},
                    'MultiBlog/multiblog.pl exists in PluginSwitch.'
                );
                is( $plugin_switch->{'MultiBlog/multiblog.pl'},
                    1, 'PluginSwitch of MultiBlog/multiblog.pl is 1.' );
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
        {    # Not logged in.
            path      => '/v2/plugins/Awesome/disable',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/plugins/Awesome/disable',
            method       => 'POST',
            restrictions => { 0 => [qw/ toggle_plugin_switch /], },
            code         => 403,
            error        => 'Do not have permission to disable a plugin.',
        },

        # disable_plugin - normal tests.
        {    # By signature.
            path   => '/v2/plugins/Awesome/disable',
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

                $plugin_switch->{Awesome} = 1;
                $app->config->PluginSwitch( $plugin_switch, 1 );
                $app->config->save_config;
            },
        },
        {    # By id.
            path =>
                '/v2/plugins/64ec5077d1e64b9c18495913e02ba95915a280a4/disable',
            method => 'POST',
            result => sub {
                return +{ status => 'success', };
            },
            complete => sub {
                my $plugin_switch = $app->config->PluginSwitch;
                ok( exists $plugin_switch->{'MultiBlog/multiblog.pl'},
                    'MultiBlog/multiblog.pl exists in PluginSwitch.'
                );
                is( $plugin_switch->{'MultiBlog/multiblog.pl'},
                    0, 'PluginSwitch of MultiBlog/multiblog.pl is 0.' );

                $plugin_switch->{'MultiBlog/multiblog.pl'} = 1;
                $app->config->PluginSwitch( $plugin_switch, 1 );
                $app->config->save_config;
            },
        },

        # enable_all_plugins - irregular tests.
        {    # Not logged in.
            path      => '/v2/plugins/enable',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/plugins/enable',
            method       => 'POST',
            restrictions => { 0 => [qw/ toggle_plugin_switch /], },
            code         => 403,
            error        => 'Do not have permission to enable all plugins.',
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

        # diable_all_plugins - irregular tests.
        {    # Not logged in.
            path      => '/v2/plugins/disable',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/plugins/disable',
            method       => 'POST',
            restrictions => { 0 => [qw/ toggle_plugin_switch /], },
            code         => 403,
            error        => 'Do not have permission to disable all plugins.',
        },

        # disable_all_plugins - normal tests.
        {   path   => '/v2/plugins/disable',
            method => 'POST',
            result => sub {
                return +{ status => 'success', };
            },
            complete => sub {
                is( $app->config->UsePlugins, 0, 'UsePlugins is 0.' );

                $app->config->UsePlugins( 1, 1 );
                $app->config->save_config;
            },
        },
    ];
}

