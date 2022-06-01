#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;

MT::Test->init_app;

$test_env->prepare_fixture('db_data');

my $mt    = MT->instance;
my $cfg   = $mt->config;
my $admin = $mt->model('author')->load(1);
my $blog  = $mt->model('blog')->load(1);

subtest 'Save DataAPI plugin settings in system' => sub {
    # force disable DataAPIDisableSite
    $cfg->DataAPIDisableSite('0', 1);
    $cfg->save_config;

    is($cfg->DataAPIDisableSite, '0');
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user             => $admin,
            __request_method        => 'POST',
            __mode                  => 'save_plugin_config',
            plugin_sig              => 'DataAPI',
            enable_data_api         => 1,
            return_args             => '__mode=cfg_plugins&blog_id=0',
            __test_follow_redirects => 1,
        }
    );
    is($cfg->DataAPIDisableSite, '');

    my $out = delete $app->{__test_output};
    my $id = MT::Util::perl_sha1_digest_hex('DataAPI');
    unlike($out, qr/resetPlugin\(getByID\('plugin-${id}-form'\)\)/, 'Hide Reset to Defaults button');
};

subtest 'Save DataAPI plugin settings in website' => sub {
    # force disable allow_data_api
    $blog->allow_data_api(0);
    $blog->save;

    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user             => $admin,
            __request_method        => 'POST',
            __mode                  => 'save_plugin_config',
            blog_id                 => $blog->id,
            plugin_sig              => 'DataAPI',
            enable_data_api         => 1,
            return_args             => '__mode=cfg_plugins&_type=blog&blog_id=' . $blog->id . '&id=' . $blog->id,
            __test_follow_redirects => 1,
        }
    );

    $blog  = $mt->model('blog')->load(1);
    ok($blog->allow_data_api);

    my $out = delete $app->{__test_output};
    my $id = MT::Util::perl_sha1_digest_hex('DataAPI');
    unlike($out, qr/resetPlugin\(getByID\('plugin-${id}-form'\)\)/, 'Hide Reset to Defaults button');
};

subtest 'Save cfg_web_services DataAPI settings in system' => sub {
    # force disable DataAPIDisableSite
    $cfg->DataAPIDisableSite('0', 1);
    $cfg->save_config;

    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save_cfg_system_web_services',
            id               => 0,
            enable_data_api  => 1,
        }
    );

    is($cfg->DataAPIDisableSite, '');
};

subtest 'Save cfg_web_services DataAPI settings in website' => sub {
    # force disable allow_data_api
    $blog->allow_data_api(0);
    $blog->save;

    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            id               => $blog->id,
            _type            => 'website',
            cfg_screen       => 'cfg_web_services',
            blog_id          => $blog->id,
            enable_data_api  => 1,
        }
    );

    $blog  = $mt->model('blog')->load(1);
    ok($blog->allow_data_api);
};

done_testing();