use strict;
use warnings;

use Test::More;

use lib qw( lib extlib t/lib );
use MT::Test qw( :app :db );
use MT::Test::Permission;

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
    ok( $out,                       "Request: login" );
    ok( $out !~ m!not authorized!i, "not authorized(mode=dashboard) by admin" );
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
    ok( $out,                       "Request: login" );
    ok( $out !~ m!not authorized!i, "not authorized(mode=dashboard) by user(can_sign_in_cms=1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'GET',
            __mode           => 'cfg_prefs',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: login" );
    ok( $out !~ m!not authorized!i, "not authorized(mode=cfg_prefs) by user(can_sign_in_cms=1)" );

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
    ok( $out,                       "Request: login" );
    ok( $out =~ m!not authorized!i, "not authorized(mode=dashboard) by user(can_sign_in_cms=0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'GET',
            __mode           => 'cfg_prefs',
            __blog_id        => 1,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                       "Request: login" );
    ok( $out =~ m!not authorized!i, "not authorized(mode=cfg_prefs) by user(can_sign_in_cms=0)" );

};

done_testing();
