use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);
my $user = MT::Test::Permission->make_author;
$user->save or die $user->errstr;

my ( $app, $out );

subtest 'user = administrator' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'GET',
            __mode           => 'dashboard',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: dashboard" );
    ok( $out !~ m!not Invalid login.!i, "Invalid login(mode=dashboard) by admin" );
};

subtest 'user = not administrator' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'GET',
            __mode           => 'dashboard',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: dashboard" );
    ok( $out !~ m!Invalid login.!i, "Invalid login(mode=dashboard) by user(can_sign_in_cms=1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'GET',
            __mode           => 'cfg_prefs',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: cfg_prefs" );
    ok( $out !~ m!Invalid login.!i, "Invalid login(mode=cfg_prefs) by user(can_sign_in_cms=1)" );

    $user->can_sign_in_cms(0);
    $user->save or die $user->errstr;

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'GET',
            __mode           => 'dashboard',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: dashboard" );
    ok( $out =~ m!Invalid login.!i, "Invalid login(mode=dashboard) by user(can_sign_in_cms=0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'GET',
            __mode           => 'cfg_prefs',
            __blog_id        => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: cfg_prefs" );
    ok( $out =~ m!Invalid login.!i, "Invalid login(mode=cfg_prefs) by user(can_sign_in_cms=0)" );

};

done_testing();
