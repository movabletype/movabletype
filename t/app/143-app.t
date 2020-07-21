#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;

$test_env->prepare_fixture('db');

subtest 'Check transencoding in validate_request_params().' => sub {
    my $flag = 0;

    my $module = Test::MockModule->new('MT::I18N::default');
    $module->mock( 'encode_text_encode',
        sub { $flag++; $module->original('encode_text_encode')->(@_) },
    );

    local $ENV{CONTENT_TYPE} = 'text/plain; charset=UTF-8';
    my $app = MT->app;
    $app->init_request;
    $app->param( 'dummy', 'ダミーパラメータ' );
    $app->validate_request_params;

    is( $flag, 0,
        'MT::I18N::default::encode_text_encode() is not executed when charset is UTF-8.'
    );
};

subtest 'If Content-Type has multi paramters' => sub {
    local $ENV{CONTENT_TYPE}
        = 'multipart/form-data; charset=utf-8; boundary=0xKhTmLbOuNdArY-CAF30B04-D79D-4CD9-9B7D-57302B6F9649';
    my $app = MT->app;
    $app->init_request;
    $app->param( 'dummy', 'ダミーパラメータ' );
    eval { $app->validate_request_params };

    is( scalar(@_), 0, 'No error occurs in validate_request_params().' );
};

subtest 'do_reboot' => sub {
    my $app = MT->app;
    $app->reboot;
    ok( $app->do_reboot,  'ran do_reboot' );
    ok( !$app->do_reboot, 'do not run do_reboot twice' );
};

subtest 'check_release_updated' => sub {
    my $name = MT::App::CURRENT_RELEASE_COOKIE_NAME();
    my $current_release = $MT::RELEASE_VERSION_ID;

    subtest 'initial' => sub {
        my $app = _run_app('MT::App::CMS');

        is $app->{cgi_headers}{'-clear_site_data'}, '"cache"';
        is $app->{cgi_headers}{'-cookie'}[0]->name, $name;
        is $app->{cgi_headers}{'-cookie'}[0]->value, $current_release;
    };

    subtest 'match to current release' => sub {
        local $ENV{COOKIE} = "$name=$current_release";
        my $app = _run_app('MT::App::CMS');

        ok !$app->{cgi_headers}{'-clear_site_data'};
        ok !$app->{cgi_headers}{'-cookie'};
    };

    subtest 'does not match to current release' => sub {
        local $ENV{COOKIE} = "$name=$current_release-rc1";
        my $app = _run_app('MT::App::CMS');

        is $app->{cgi_headers}{'-clear_site_data'}, '"cache"';
        is $app->{cgi_headers}{'-cookie'}[0]->name, $name;
        is $app->{cgi_headers}{'-cookie'}[0]->value, $current_release;
    };

    subtest 'do not send in mt-search.cgi' => sub {
        my $app = _run_app('MT::App::Search');

        ok !$app->{cgi_headers}{'-clear_site_data'};
        ok !$app->{cgi_headers}{'-cookie'};
    };
};

done_testing;
