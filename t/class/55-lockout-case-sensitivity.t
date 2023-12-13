use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        IPLockoutLimit      => 10,
        UserLockoutLimit    => 6,
        IPLockoutInterval   => 1800,
        UserLockoutInterval => 1800,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Test::MockTime qw(set_fixed_time);
use MT;
use MT::Lockout;
use MT::Test::Permission;

$test_env->prepare_fixture('db');

my $app = MT->instance;

my $evil_user = MT::Test::Permission->make_author(
    name     => 'Evil',
    nickname => 'Evil',
    email    => 'evil@example.org',
);
$evil_user->save;

sub clear_lockout_statuses {
    MT->model('failedlogin')->remove;
    MT::Lockout->unlock($evil_user);
    $evil_user->save();
}

my $ip_address  = '127.0.0.1';
my $ip_address2 = '127.0.0.2';
my $limit       = MT->config->UserLockoutLimit;
my $interval    = MT->config->UserLockoutInterval;

clear_lockout_statuses();
note('MT::Lockout::is_locked_out_user');
ok(
    !MT::Lockout->is_locked_out_user($app, $evil_user->name),
    '$evil_user has not locked out yet. (FailedLogin: 0)'
);

my $now = time;
{
    for (my $i = 0; $i < $limit - 1; $i++) {
        set_fixed_time($now - 60 * ($i + 2));
        MT::Lockout->_insert_failedlogin($app, $ip_address, $evil_user->name);
    }
    ok(
        !MT::Lockout->is_locked_out_user($app, $evil_user->name),
        '$evil_user has not locked out. (FailedLogin: AuthorLockoutLimit - 1)'
    );

    set_fixed_time($now);

    MT::Lockout->_insert_failedlogin($app, $ip_address, $evil_user->name);
    ok(
        MT::Lockout->is_locked_out_user($app, $evil_user->name),
        '$evil_user (' . ($evil_user->name) . ') has locked out. (FailedLogin: AuthorLockoutLimit)'
    );
    ok(
        !MT::Lockout->is_locked_out_user($app, lc $evil_user->name),
        '$lc_evil_user (' . (lc $evil_user->name) . ') has not locked out. (wrong cased)'
    );
    ok(
        !MT::Lockout->is_locked_out_user($app, uc $evil_user->name),
        '$uc_evil_user (' . (uc $evil_user->name) . ') has not locked out. (wrong cased)'
    );

    set_fixed_time($now + $interval);

    ok(
        MT::Lockout->is_locked_out_user($app, $evil_user->name),
        '$evil_user has locked out. (not yet recoveried)'
    );
    ok(
        !MT::Lockout->is_locked_out_user($app, lc $evil_user->name),
        '$lc_evil_user (' . (lc $evil_user->name) . ') has not locked out. (wrong cased)'
    );
    ok(
        !MT::Lockout->is_locked_out_user($app, uc $evil_user->name),
        '$uc_evil_user (' . (uc $evil_user->name) . ') has not locked out. (wrong cased)'
    );

    set_fixed_time($now + $interval + 10);

    ok(
        !MT::Lockout->is_locked_out_user($app, $evil_user->name),
        '$evil_user has not locked out. (recovered automaticaly)'
    );

    clear_lockout_statuses();

    note('MT::Lockout::process_login_result');
    foreach my $res (MT::Auth::UNKNOWN(), MT::Auth::INVALID_PASSWORD()) {
        clear_lockout_statuses();
        MT::Lockout->process_login_result($app, $ip_address, uc $evil_user->name, $res);
        my $obj = $app->model('failedlogin')->load;
        ok($obj && !$obj->author_id, 'Failedlogin has been inserted but author id is null: ' . $res);

        clear_lockout_statuses();
        MT::Lockout->process_login_result($app, $ip_address, lc $evil_user->name, $res);
        $obj = $app->model('failedlogin')->load;
        ok($obj && !$obj->author_id, 'Failedlogin has been inserted but author id is null: ' . $res);

        clear_lockout_statuses();
        MT::Lockout->process_login_result($app, $ip_address, $evil_user->name, $res);
        $obj = $app->model('failedlogin')->load;
        ok($obj, 'Failedlogin has been inserted in login result: ' . $res);
        is($obj->author_id, $evil_user->id, 'Same author_id in login result: ' . $res);
    }

    foreach my $res (
        MT::Auth::INACTIVE(),  MT::Auth::PENDING(),
        MT::Auth::DELETED(),   MT::Auth::REDIRECT_NEEDED(),
        MT::Auth::NEW_LOGIN(), MT::Auth::NEW_USER())
    {
        clear_lockout_statuses();
        set_fixed_time($now - 60);
        MT::Lockout->_insert_failedlogin($app, $ip_address, $evil_user->name);

        MT::Lockout->process_login_result($app, $ip_address2, uc $evil_user->name, $res);
        ok($app->model('failedlogin')->count, 'Failedlogin was not cleared in login result: ' . $res);

        MT::Lockout->process_login_result($app, $ip_address2, lc $evil_user->name, $res);
        ok($app->model('failedlogin')->count, 'Failedlogin was not cleared in login result: ' . $res);

        MT::Lockout->process_login_result($app, $ip_address2, $evil_user->name, $res);
        is($app->model('failedlogin')->count, 0, 'Failedlogin was cleared in login result: ' . $res);
    }
}

done_testing;
