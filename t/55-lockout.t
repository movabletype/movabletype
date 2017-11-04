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

my $fixed_time = CORE::time;
sub fixed_time() {
    return $fixed_time;
};
BEGIN {
    no warnings 'redefine';

    undef(*CORE::GLOBAL::time);

    *CORE::GLOBAL::time = \&fixed_time;
    use MT::FailedLogin;

    use MT::Test;
}

MT::Test->init_app;

$test_env->prepare_fixture('db');

use MT::Lockout;


my $app = MT::Test::init_cms;
my $author_class = $app->model('author');
my $failedlogin_class = $app->model('failedlogin');

my $now = time;

my $evil_ip_address    = '192.0.2.1';
my $good_ip_address    = '192.0.2.2';
my @white_ip_addresses = qw( 192.0.2.3 192.0.3.1 );

my $ip_limit      = $app->config->IPLockoutLimit(10);
my $user_limit    = $app->config->UserLockoutLimit(6);
my $ip_interval   = $app->config->IPLockoutInterval(1800); # 30min
my $user_interval = $app->config->UserLockoutInterval(1800); # 30min
$app->config->LockoutIPWhitelist('192.0.2.3,192.0.3');
my $max_interval  =
    $ip_interval > $user_interval ? $ip_interval : $user_interval;


my $unknown_name   = 'Unknown';
my $valid_password = 'Password';
$author_class->remove({
    name => ['Evil', 'Good', $unknown_name],
});
my $evil_user = $author_class->new;
$evil_user->set_values(
    {
        name             => 'Evil',
        nickname         => 'Evil',
        email            => 'evil@example.com',
        url              => 'http://example.com/',
        api_password     => $valid_password,
        auth_type        => 'MT',
        status => MT::Author::ACTIVE,
    }
);
$evil_user->set_password($valid_password);
$evil_user->type( MT::Author::AUTHOR() );
$evil_user->save()
  or die "Couldn't save author: " . $evil_user->errstr;

my $good_user = $author_class->new;
$good_user->set_values(
    {
        name             => 'Good',
        nickname         => 'Good',
        email            => 'good@example.com',
        url              => 'http://example.com/',
        api_password     => $valid_password,
        auth_type        => 'MT',
        status => MT::Author::ACTIVE,
    }
);
$good_user->set_password($valid_password);
$good_user->type( MT::Author::AUTHOR() );
$good_user->save()
  or die "Couldn't save author: " . $good_user->errstr;


sub clear_lockout_statuses {
    $failedlogin_class->remove;
    MT::Lockout->unlock($evil_user);
    $evil_user->save();
    $fixed_time = $now;
}



clear_lockout_statuses();
note('MT::Lockout::is_locked_out_ip');
ok(
    ! MT::Lockout->is_locked_out_ip($app, $evil_ip_address),
    '$evil_ip_address has not locked out. (FailedLogin: 0)'
);
ok(
    ! MT::Lockout->is_locked_out_ip($app, $good_ip_address),
    '$good_ip_address has not locked out. (FailedLogin: 0)'
);

for (my $i = 0; $i < $ip_limit-1; $i++) {
    $fixed_time = $now-60*($i+2);
    MT::Lockout->_insert_failedlogin($app, $evil_ip_address, '');
}
ok(
    ! MT::Lockout->is_locked_out_ip($app, $evil_ip_address),
    '$evil_ip_address has not locked out. (FailedLogin: IPLockoutLimit - 1)'
);

$fixed_time = $now;
MT::Lockout->_insert_failedlogin($app, $evil_ip_address, '');
ok(
    MT::Lockout->is_locked_out_ip($app, $evil_ip_address),
    '$evil_ip_address has locked out. (FailedLogin: IPLockoutLimit)'
);
ok(
    ! MT::Lockout->is_locked_out_ip($app, $good_ip_address),
    '$good_ip_address has not locked out. (FailedLogin: IPLockoutLimit)'
);

$fixed_time = $now+$ip_interval;
ok(
    MT::Lockout->is_locked_out_ip($app, $evil_ip_address),
    '$evil_ip_address has locked out. (not yet recovered)'
);

$fixed_time = $now+$ip_interval+1;
ok(
    ! MT::Lockout->is_locked_out_ip($app, $evil_ip_address),
    '$evil_ip_address has not locked out. (recovered)'
);



clear_lockout_statuses();
note('MT::Lockout::is_locked_out_user');
ok(
    ! MT::Lockout->is_locked_out_user($app, $evil_user->name),
    '$evil_user has not locked out. (FailedLogin: 0)'
);
ok(
    ! MT::Lockout->is_locked_out_user($app, $good_user->name),
    '$good_user has not locked out. (FailedLogin: 0)'
);

for (my $i = 0; $i < $user_limit-1; $i++) {
    $fixed_time = $now-60*($i+2);
    MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
}
ok(
    ! MT::Lockout->is_locked_out_user($app, $evil_user->name),
    '$evil_user has not locked out. (FailedLogin: AuthorLockoutLimit - 1)'
);

$fixed_time = $now;
MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
ok(
    MT::Lockout->is_locked_out_user($app, $evil_user->name),
    '$evil_user has locked out. (FailedLogin: AuthorLockoutLimit)'
);
ok(
    ! MT::Lockout->is_locked_out_user($app, $good_user->name),
    '$good_user has not locked out. (FailedLogin: IPLockoutLimit)'
);

$fixed_time = $now+$user_interval;
ok(
    MT::Lockout->is_locked_out_user($app, $evil_user->name),
    '$evil_user has locked out. (not yet recoveried)'
);

$fixed_time = $now+$user_interval+1;
ok(
    ! MT::Lockout->is_locked_out_user($app, $evil_user->name),
    '$evil_user has not locked out. (recoveried automaticaly)'
);



clear_lockout_statuses();
note('MT::Lockout::lock / MT::Lockout::unlock');
MT::Lockout->_insert_failedlogin($app, $evil_ip_address, '');
MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);

MT::Lockout->lock($evil_user);
$evil_user->save();
ok(
    MT::Lockout->is_locked_out_user($app, $evil_user->name),
    '$evil_user has been locked out.'
);

MT::Lockout->unlock($evil_user);
$evil_user->save();
ok(
    ! MT::Lockout->is_locked_out_user($app, $evil_user->name),
    '$evil_user has been unlocked.'
);
is( $app->model('failedlogin')->count( { author_id => $evil_user->id } ),
    0, 'Failedlogin for $evil_user was cleared' );
is( $app->model('failedlogin')->count,
    1, 'Failedlogin for $evil_ip_address was not cleared' );



clear_lockout_statuses();
note('MT::Lockout::is_locked_out');
foreach my $case (
    {
        ip   => 0,
        user => 0,
        res  => 0,
    },
    {
        ip   => 1,
        user => 0,
        res  => 1,
    },
    {
        ip   => 0,
        user => 1,
        res  => 1,
    },
    {
        ip   => 1,
        user => 1,
        res  => 1,
    }
) {
    no warnings 'redefine';
    local *MT::Lockout::is_locked_out_ip   = sub { $case->{ip} };
    local *MT::Lockout::is_locked_out_user = sub { $case->{user} };
    is(
        MT::Lockout->is_locked_out() ? 1 : 0, $case->{res},
        sprintf(
            'is_locked_out: %d, is_locked_out_ip: %d, is_locked_out_user: %d',
            $case->{res}, $case->{ip}, $case->{user}
        )
    );
}



note('MT::Lockout::process_login_result');
foreach my $res ( MT::Auth::UNKNOWN(), MT::Auth::INVALID_PASSWORD() ) {
    clear_lockout_statuses();
    MT::Lockout->process_login_result( $app, $evil_ip_address,
        $evil_user->name, $res );
    my $obj = $app->model('failedlogin')->load;
    ok( $obj, 'Failedlogin has been inserted in login result: ' . $res );
    is( $obj->remote_ip, $evil_ip_address,
        'Same address in login result: ' . $res );
    is( $obj->author_id, $evil_user->id,
        'Same author_is in login result: ' . $res );
}

foreach my $res (
    MT::Auth::INACTIVE(),  MT::Auth::PENDING(),
    MT::Auth::DELETED(),   MT::Auth::REDIRECT_NEEDED(),
    MT::Auth::NEW_LOGIN(), MT::Auth::NEW_USER()
    )
{
    clear_lockout_statuses();
    $fixed_time = $now - 60;
    MT::Lockout->_insert_failedlogin( $app, $evil_ip_address, $evil_user->name );

    MT::Lockout->process_login_result( $app, $evil_ip_address,
        $evil_user->name, $res );
    is( $app->model('failedlogin')->count,
        0, 'Failedlogin was cleared in login result: ' . $res );
}

foreach my $case (
    {
        remote_ip => $good_ip_address,
        user  => $good_user,
    },
    {
        remote_ip => $evil_ip_address,
        user  => $good_user,
    },
    {
        remote_ip => $evil_ip_address,
        user  => $evil_user,
    },
    {
        remote_ip => $good_ip_address,
        user  => $evil_user,
    },
) {
    $fixed_time = $now-10;
    MT::Lockout->_insert_failedlogin($app, $good_ip_address, $good_user->name);
    MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $good_user->name);
    MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
    MT::Lockout->_insert_failedlogin($app, $good_ip_address, $evil_user->name);

    MT::Lockout->process_login_result(
        $app, $case->{remote_ip}, $case->{user}->name, MT::Auth::NEW_LOGIN(),
    );
    is(
        $app->model('failedlogin')->count, 1,
        sprintf(
            'Remains only one entry. remote_ip: %s, username: %s',
            $case->{remote_ip}, $case->{user}->name
        )
    );

    my @objs = $app->model('failedlogin')->load;

    my $obj = $app->model('failedlogin')->load;
    isnt(
        $obj->remote_ip, $case->{remote_ip},
        sprintf(
            'Different address. remote_ip: %s, username: %s',
            $case->{remote_ip}, $case->{user}->name
        )
    );
    isnt(
        $obj->author_id, $case->{user}->id,
        sprintf(
            'Different user. remote_ip: %s, username: %s',
            $case->{remote_ip}, $case->{user}->name
        )
    );
}



note('MT::Lockout::process_login_result (with LockoutIPWhitelist)');
foreach my $ip (@white_ip_addresses) {
    clear_lockout_statuses();
    MT::Lockout->process_login_result( $app, $ip, '',
        MT::Auth::INVALID_PASSWORD() );
    is( $app->model('failedlogin')->count,
        0, 'Failedlogin is not inserted for : ' . $ip );
}



note('MT::Lockout::_notify_to');
$app->config->LockoutNotifyTo(undef);
is_deeply(
    [MT::Lockout->_notify_to($app)],
    [$app->config->EmailAddressMain],
    'notify_to: EmailAddressMain is returned by default'
);
$app->config->LockoutNotifyTo($evil_user->id . ';' . $good_user->id);
is_deeply(
    [MT::Lockout->_notify_to($app)],
    [$evil_user->email, $good_user->email],
    'notify_to: specified users emails are returned'
);



clear_lockout_statuses();
note('MT::Lockout::cleanup');
$fixed_time = $now-60;
MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
$fixed_time = $now-$max_interval-60;
MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
is($app->model('failedlogin')->count, 2, 'Failedlogin has 2 entries.');

$fixed_time = $now;
$app->model('failedlogin')->cleanup($app);
is($app->model('failedlogin')->count, 1, 'Failedlogin has 1 entries. (cleaned)');



clear_lockout_statuses();
note('MT::Lockout::locked_out_ip_recovery_time');
for (my $i = 0; $i < $ip_limit; $i++) {
    $fixed_time = $now-60;
    MT::Lockout->_insert_failedlogin($app, $evil_ip_address, '');
}
is( MT::Lockout->locked_out_ip_recovery_time( $app, $evil_ip_address ),
    $now - 60 + $ip_interval,
    'Will recovered after IPLockoutInterval seconds.'
);



clear_lockout_statuses();
note('MT::Lockout::recover_token / MT::Lockout::validate_recover_token');
MT::Lockout->lock($evil_user);
$evil_user->save();
{
    my $token = MT::Lockout->recover_token( $app, $evil_user );
    ok( $token, 'Get recover token' );

    ok( MT::Lockout->validate_recover_token( $app, $evil_user, $token ),
        'Valid token' );
    ok( ! MT::Lockout->validate_recover_token( $app, $evil_user, 'invalid' ),
        'Invalid token' );
}



clear_lockout_statuses();
note('MT::Lockout::recover_lockout_uri');
MT::Lockout->lock($evil_user);
$evil_user->save();
{
    require MT::Util;
    my $encoded_token = MT::Util::encode_url(
        MT::Lockout->recover_token( $app, $evil_user ) );
    like(
        MT::Lockout->recover_lockout_uri( $app, $evil_user ),
        qr/token=$encoded_token/,
        'Included token param'
    );
}



clear_lockout_statuses();
{
    local $app->config->{__var}{lc('UserLockoutLimit')} = 0;

    note('When UserLockoutLimit is 0');
    ok(
        ! MT::Lockout->is_locked_out_user($app, $evil_user->name),
        '$evil_user has not locked out.'
    );
    for (my $i = 0; $i < 10; $i++) {
        $fixed_time = $now-60*($i+2);
        MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
    }

    $evil_user = $author_class->load($evil_user->id);
    ok(
        ! $evil_user->locked_out,
        '$evil_user is never locked out.'
    );
}



note('When the failedlogin count reached the limit at different timing.');
clear_lockout_statuses();
{
    my $user_limit = 2;
    my $ip_limit   = 4;
    local $app->config->{__var}{lc('UserLockoutLimit')} = $user_limit;
    local $app->config->{__var}{lc('IPLockoutLimit')}   = $ip_limit;

    for (my $i = 0; $i < $user_limit; $i++) {
        MT::Lockout
            ->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
    }
    for (my $i = $user_limit; $i < $ip_limit; $i++) {
        MT::Lockout
            ->_insert_failedlogin($app, $evil_ip_address, '');
    }
    $evil_user = $author_class->load($evil_user->id);
    MT::Lockout->unlock($evil_user);
    ok(
        MT::Lockout->is_locked_out_ip($app, $evil_ip_address),
        '$evil_ip_address is locked out yet. (not recovered by unlocking user)'
    );
}


note('When the failedlogin count reached the limit at same timing. And unlock');
clear_lockout_statuses();
{
    my $user_limit = 2;
    my $ip_limit   = 4;
    local $app->config->{__var}{lc('UserLockoutLimit')} = $user_limit;
    local $app->config->{__var}{lc('IPLockoutLimit')}   = $ip_limit;

    for (my $i = 0; $i < $ip_limit-$user_limit; $i++) {
        MT::Lockout
            ->_insert_failedlogin($app, $evil_ip_address, '');
    }
    for (my $i = $ip_limit-$user_limit; $i < $ip_limit; $i++) {
        MT::Lockout
            ->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
    }
    $evil_user = $author_class->load($evil_user->id);
    MT::Lockout->unlock($evil_user);
    ok(
        MT::Lockout->is_locked_out_ip($app, $evil_ip_address),
        '$evil_ip_address is locked out yet. (not recovered by unlocking user)'
    );
}


note('When the failedlogin count reached the limit at same timing. And remove');
clear_lockout_statuses();
{
    my $user_limit = 2;
    my $ip_limit   = 4;
    local $app->config->{__var}{lc('UserLockoutLimit')} = $user_limit;
    local $app->config->{__var}{lc('IPLockoutLimit')}   = $ip_limit;

    for (my $i = 0; $i < $ip_limit-$user_limit; $i++) {
        MT::Lockout
            ->_insert_failedlogin($app, $evil_ip_address, '');
    }
    for (my $i = $ip_limit-$user_limit; $i < $ip_limit; $i++) {
        MT::Lockout
            ->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
    }
    $evil_user = $author_class->load($evil_user->id);
    $evil_user->remove;
    ok(
        MT::Lockout->is_locked_out_ip($app, $evil_ip_address),
        '$evil_ip_address is locked out yet. (not recovered by removing user)'
    );

    $evil_user->save;
    $evil_user = $author_class->load($evil_user->id);
}


clear_lockout_statuses();
note('task');
$fixed_time = $now-$max_interval-60;
MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
is($app->model('failedlogin')->count, 1, 'Failedlogin has 1 entries.');
$fixed_time = $now;

my $task = $app->registry('tasks', 'CleanExpiredFailedLogin');
ok($task, 'CleanExpiredFailedLogin is registered.');
is($task->{frequency}, $app->config->FailedLoginExpirationFrequency, "task's frequency: is FailedLoginExpirationFrequency");
$task->{code}->();
is($app->model('failedlogin')->count, 0, 'Failedlogin has 0 entries. (cleaned)');



note('Callbasks');

note('pre_lockout / post_lockout');
my (
    @pre_lockout_args, @pre_lockout_user_args, @pre_lockout_ip_args,
    @post_lockout_args, @post_lockout_user_args, @post_lockout_ip_args,
);
sub pre_lockout       { push @pre_lockout_args,       [@_] }
sub pre_lockout_user  { push @pre_lockout_user_args,  [@_] }
sub pre_lockout_ip    { push @pre_lockout_ip_args,    [@_] }
sub post_lockout      { push @post_lockout_args,      [@_] }
sub post_lockout_user { push @post_lockout_user_args, [@_] }
sub post_lockout_ip   { push @post_lockout_ip_args,   [@_] }

$app->add_callback( 'pre_lockout',       1, undef, \&pre_lockout );
$app->add_callback( 'pre_lockout.user',  1, undef, \&pre_lockout_user );
$app->add_callback( 'pre_lockout.ip',    1, undef, \&pre_lockout_ip );
$app->add_callback( 'post_lockout',      1, undef, \&post_lockout );
$app->add_callback( 'post_lockout.user', 1, undef, \&post_lockout_user );
$app->add_callback( 'post_lockout.ip',   1, undef, \&post_lockout_ip );


clear_lockout_statuses();
note('for ip lockout');
for (my $i = 0; $i < $ip_limit; $i++) {
    $fixed_time = $now-60*($i+2);
    MT::Lockout->process_login_result( $app, $evil_ip_address, $unknown_name,
        MT::Auth::INVALID_PASSWORD() );
}

is(scalar @pre_lockout_args, 1, 'pre_lockout ran once');
is($pre_lockout_args[0][2], $unknown_name, 'pre_lockout was passed username');
is($pre_lockout_args[0][3], $evil_ip_address, 'pre_lockout was passed ip');

is(scalar @post_lockout_args, 1, 'post_lockout ran once.');
is($post_lockout_args[0][2], $unknown_name, 'post_lockout was passed username');
is($post_lockout_args[0][3], $evil_ip_address, 'post_lockout was passed ip');

is(scalar @pre_lockout_ip_args, 1, 'pre_lockout.ip ran once');
is($pre_lockout_args[0][2], $unknown_name, 'pre_lockout.ip was passed username');
is($pre_lockout_args[0][3], $evil_ip_address, 'pre_lockout.ip was passed ip');

is(scalar @post_lockout_ip_args, 1, 'post_lockout.ip ran once');
is($post_lockout_args[0][2], $unknown_name, 'post_lockout.ip was passed username');
is($post_lockout_args[0][3], $evil_ip_address, 'post_lockout.ip was passed ip');

is(scalar @pre_lockout_user_args, 0, 'pre_lockout.user did not run');
is(scalar @post_lockout_user_args, 0, 'post_lockout.user did not run');


(
    @pre_lockout_args, @pre_lockout_user_args, @pre_lockout_ip_args,
    @post_lockout_args, @post_lockout_user_args, @post_lockout_ip_args,
) = ();
clear_lockout_statuses();
note('for user lockout');
for ( my $i = 0; $i < $user_limit; $i++ ) {
    $fixed_time = $now - 60 * ( $i + 2 );
    MT::Lockout->process_login_result( $app, $evil_ip_address,
        $evil_user->name, MT::Auth::INVALID_PASSWORD() );
}

is(scalar @pre_lockout_args, 1, 'pre_lockout ran once');
is($pre_lockout_args[0][2], $evil_user->name, 'pre_lockout was passed username');
is($pre_lockout_args[0][3], $evil_ip_address, 'pre_lockout was passed ip');

is(scalar @post_lockout_args, 1, 'post_lockout ran once.');
is($post_lockout_args[0][2], $evil_user->name, 'post_lockout was passed username');
is($post_lockout_args[0][3], $evil_ip_address, 'post_lockout was passed ip');

is(scalar @pre_lockout_user_args, 1, 'pre_lockout.user ran once');
is($pre_lockout_args[0][2], $evil_user->name, 'pre_lockout.user was passed username');
is($pre_lockout_args[0][3], $evil_ip_address, 'pre_lockout.user was passed ip');

is(scalar @post_lockout_user_args, 1, 'post_lockout.user ran once');
is($post_lockout_args[0][2], $evil_user->name, 'post_lockout.user was passed username');
is($post_lockout_args[0][3], $evil_ip_address, 'post_lockout.user was passed ip');

is(scalar @pre_lockout_ip_args, 0, 'pre_lockout.ip did not run');
is(scalar @post_lockout_ip_args, 0, 'post_lockout.ip did not run');


done_testing();
