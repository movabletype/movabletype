#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

BEGIN {
    eval { use Test::MockTime::HiRes qw(set_fixed_time); 1 } or plan skip_all => "requires Test::MockTime::HiRes";
    use MT::Test;
}

$test_env->prepare_fixture('db');

use MT::Lockout;

my $app               = MT::Test::init_cms;
my $author_class      = $app->model('author');
my $failedlogin_class = $app->model('failedlogin');

my $now = time;

my $evil_ip_address    = '192.0.2.1';
my $good_ip_address    = '192.0.2.2';
my @white_ip_addresses = qw( 192.0.2.3 192.0.3.1 );

my $ip_limit      = $app->config->IPLockoutLimit(10);
my $user_limit    = $app->config->UserLockoutLimit(6);
my $ip_interval   = $app->config->IPLockoutInterval(1800);      # 30min
my $user_interval = $app->config->UserLockoutInterval(1800);    # 30min
$app->config->LockoutIPWhitelist('192.0.2.3,192.0.3');
my $max_interval = $ip_interval > $user_interval ? $ip_interval : $user_interval;

my $unknown_name   = 'Unknown';
my $valid_password = 'Password';
$author_class->remove({
    name => ['Evil', 'Good', $unknown_name],
});
my $evil_user = $author_class->new;
$evil_user->set_values({
    name         => 'Evil',
    nickname     => 'Evil',
    email        => 'evil@example.com',
    url          => 'http://example.com/',
    api_password => $valid_password,
    auth_type    => 'MT',
    status       => MT::Author::ACTIVE,
});
$evil_user->set_password($valid_password);
$evil_user->type(MT::Author::AUTHOR());
$evil_user->save()
    or die "Couldn't save author: " . $evil_user->errstr;

my $good_user = $author_class->new;
$good_user->set_values({
    name         => 'Good',
    nickname     => 'Good',
    email        => 'good@example.com',
    url          => 'http://example.com/',
    api_password => $valid_password,
    auth_type    => 'MT',
    status       => MT::Author::ACTIVE,
});
$good_user->set_password($valid_password);
$good_user->type(MT::Author::AUTHOR());
$good_user->save()
    or die "Couldn't save author: " . $good_user->errstr;

sub clear_lockout_statuses {
    $failedlogin_class->remove;
    MT::Lockout->unlock($evil_user);
    $evil_user->save();
    set_fixed_time($now);
}

subtest 'MT::Lockout::is_locked_out_ip' => sub {
    clear_lockout_statuses();
    ok(
        !MT::Lockout->is_locked_out_ip($app, $evil_ip_address),
        '$evil_ip_address has not locked out. (FailedLogin: 0)'
    );
    ok(
        !MT::Lockout->is_locked_out_ip($app, $good_ip_address),
        '$good_ip_address has not locked out. (FailedLogin: 0)'
    );

    for (my $i = 0; $i < $ip_limit - 1; $i++) {
        set_fixed_time($now - 60 * ($i + 2));
        MT::Lockout->_insert_failedlogin($app, $evil_ip_address, '');
    }
    ok(
        !MT::Lockout->is_locked_out_ip($app, $evil_ip_address),
        '$evil_ip_address has not locked out. (FailedLogin: IPLockoutLimit - 1)'
    );

    set_fixed_time($now);
    MT::Lockout->_insert_failedlogin($app, $evil_ip_address, '');
    ok(
        MT::Lockout->is_locked_out_ip($app, $evil_ip_address),
        '$evil_ip_address has locked out. (FailedLogin: IPLockoutLimit)'
    );
    ok(
        !MT::Lockout->is_locked_out_ip($app, $good_ip_address),
        '$good_ip_address has not locked out. (FailedLogin: IPLockoutLimit)'
    );

    set_fixed_time($now + $ip_interval);
    ok(
        MT::Lockout->is_locked_out_ip($app, $evil_ip_address),
        '$evil_ip_address has locked out. (not yet recovered)'
    );

    set_fixed_time($now + $ip_interval + 1);
    ok(
        !MT::Lockout->is_locked_out_ip($app, $evil_ip_address),
        '$evil_ip_address has not locked out. (recovered)'
    );
};

subtest 'MT::Lockout::is_locked_out_user' => sub {
    clear_lockout_statuses();
    ok(
        !MT::Lockout->is_locked_out_user($app, $evil_user->name),
        '$evil_user has not locked out. (FailedLogin: 0)'
    );
    ok(
        !MT::Lockout->is_locked_out_user($app, $good_user->name),
        '$good_user has not locked out. (FailedLogin: 0)'
    );

    for (my $i = 0; $i < $user_limit - 1; $i++) {
        set_fixed_time($now - 60 * ($i + 2));
        MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
    }
    ok(
        !MT::Lockout->is_locked_out_user($app, $evil_user->name),
        '$evil_user has not locked out. (FailedLogin: AuthorLockoutLimit - 1)'
    );

    set_fixed_time($now);
    MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
    ok(
        MT::Lockout->is_locked_out_user($app, $evil_user->name),
        '$evil_user has locked out. (FailedLogin: AuthorLockoutLimit)'
    );
    ok(
        !MT::Lockout->is_locked_out_user($app, $good_user->name),
        '$good_user has not locked out. (FailedLogin: IPLockoutLimit)'
    );

    set_fixed_time($now + $user_interval);
    ok(
        MT::Lockout->is_locked_out_user($app, $evil_user->name),
        '$evil_user has locked out. (not yet recoveried)'
    );

    set_fixed_time($now + $user_interval + 1);
    ok(
        !MT::Lockout->is_locked_out_user($app, $evil_user->name),
        '$evil_user has not locked out. (recoveried automaticaly)'
    );
};

subtest 'MT::Lockout::lock / MT::Lockout::unlock' => sub {
    clear_lockout_statuses();
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
        !MT::Lockout->is_locked_out_user($app, $evil_user->name),
        '$evil_user has been unlocked.'
    );
    is(
        $app->model('failedlogin')->count({ author_id => $evil_user->id }),
        0, 'Failedlogin for $evil_user was cleared'
    );
    is(
        $app->model('failedlogin')->count,
        1, 'Failedlogin for $evil_ip_address was not cleared'
    );
};

subtest 'MT::Lockout::is_locked_out' => sub {
    clear_lockout_statuses();
    foreach my $case ({
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
        })
    {
        no warnings 'redefine';
        local *MT::Lockout::is_locked_out_ip   = sub { $case->{ip} };
        local *MT::Lockout::is_locked_out_user = sub { $case->{user} };
        is(
            MT::Lockout->is_locked_out() ? 1 : 0, $case->{res},
            sprintf(
                'is_locked_out: %d, is_locked_out_ip: %d, is_locked_out_user: %d',
                $case->{res}, $case->{ip}, $case->{user}));
    }
};

subtest 'MT::Lockout::process_login_result' => sub {
    foreach my $res (MT::Auth::UNKNOWN(), MT::Auth::INVALID_PASSWORD()) {
        clear_lockout_statuses();
        MT::Lockout->process_login_result(
            $app,             $evil_ip_address,
            $evil_user->name, $res
        );
        my $obj = $app->model('failedlogin')->load;
        ok($obj, 'Failedlogin has been inserted in login result: ' . $res);
        is(
            $obj->remote_ip, $evil_ip_address,
            'Same address in login result: ' . $res
        );
        is(
            $obj->author_id, $evil_user->id,
            'Same author_is in login result: ' . $res
        );
    }

    foreach my $res (
        MT::Auth::INACTIVE(),  MT::Auth::PENDING(),
        MT::Auth::DELETED(),   MT::Auth::REDIRECT_NEEDED(),
        MT::Auth::NEW_LOGIN(), MT::Auth::NEW_USER())
    {
        clear_lockout_statuses();
        set_fixed_time($now - 60);
        MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);

        MT::Lockout->process_login_result(
            $app,             $evil_ip_address,
            $evil_user->name, $res
        );
        is(
            $app->model('failedlogin')->count,
            0, 'Failedlogin was cleared in login result: ' . $res
        );
    }

    foreach my $case ({
            remote_ip => $good_ip_address,
            user      => $good_user,
        },
        {
            remote_ip => $evil_ip_address,
            user      => $good_user,
        },
        {
            remote_ip => $evil_ip_address,
            user      => $evil_user,
        },
        {
            remote_ip => $good_ip_address,
            user      => $evil_user,
        },
        )
    {
        set_fixed_time($now - 10);
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
            ));

        my @objs = $app->model('failedlogin')->load;

        my $obj = $app->model('failedlogin')->load;
        isnt(
            $obj->remote_ip, $case->{remote_ip},
            sprintf(
                'Different address. remote_ip: %s, username: %s',
                $case->{remote_ip}, $case->{user}->name
            ));
        isnt(
            $obj->author_id, $case->{user}->id,
            sprintf(
                'Different user. remote_ip: %s, username: %s',
                $case->{remote_ip}, $case->{user}->name
            ));
    }
};

subtest 'MT::Lockout::process_login_result (with LockoutIPWhitelist)' => sub {
    foreach my $ip (@white_ip_addresses) {
        clear_lockout_statuses();
        MT::Lockout->process_login_result(
            $app, $ip, '',
            MT::Auth::INVALID_PASSWORD());
        is(
            $app->model('failedlogin')->count,
            0, 'Failedlogin is not inserted for : ' . $ip
        );
    }
};

subtest 'MT::Lockout::_notify_to' => sub {
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
};

subtest 'MT::Lockout::cleanup' => sub {
    clear_lockout_statuses();
    set_fixed_time($now - 60);
    MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
    set_fixed_time($now - $max_interval - 60);
    MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
    is($app->model('failedlogin')->count, 2, 'Failedlogin has 2 entries.');

    set_fixed_time($now);
    $app->model('failedlogin')->cleanup($app);
    is($app->model('failedlogin')->count, 1, 'Failedlogin has 1 entries. (cleaned)');
};

subtest 'MT::Lockout::locked_out_ip_recovery_time' => sub {
    clear_lockout_statuses();
    for (my $i = 0; $i < $ip_limit; $i++) {
        set_fixed_time($now - 60);
        MT::Lockout->_insert_failedlogin($app, $evil_ip_address, '');
    }
    is(
        MT::Lockout->locked_out_ip_recovery_time($app, $evil_ip_address),
        $now - 60 + $ip_interval,
        'Will recovered after IPLockoutInterval seconds.'
    );
};

subtest 'MT::Lockout::recover_token / MT::Lockout::validate_recover_token' => sub {
    clear_lockout_statuses();
    MT::Lockout->lock($evil_user);
    $evil_user->save();
    {
        my $token = MT::Lockout->recover_token($app, $evil_user);
        ok($token, 'Get recover token');

        ok(
            MT::Lockout->validate_recover_token($app, $evil_user, $token),
            'Valid token'
        );
        ok(
            !MT::Lockout->validate_recover_token($app, $evil_user, 'invalid'),
            'Invalid token'
        );
    }
};

subtest 'MT::Lockout::recover_lockout_uri' => sub {
    clear_lockout_statuses();
    MT::Lockout->lock($evil_user);
    $evil_user->save();
    {
        require MT::Util;
        my $encoded_token = MT::Util::encode_url(MT::Lockout->recover_token($app, $evil_user));
        like(
            MT::Lockout->recover_lockout_uri($app, $evil_user),
            qr/token=$encoded_token/,
            'Included token param'
        );
    }
};

subtest 'UserLockoutLimit is 0' => sub {
    clear_lockout_statuses();
    {
        local $app->config->{__var}{ lc('UserLockoutLimit') } = 0;

        note('When UserLockoutLimit is 0');
        ok(
            !MT::Lockout->is_locked_out_user($app, $evil_user->name),
            '$evil_user has not locked out.'
        );
        for (my $i = 0; $i < 10; $i++) {
            set_fixed_time($now - 60 * ($i + 2));
            MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
        }

        $evil_user = $author_class->load($evil_user->id);
        ok(
            !$evil_user->locked_out,
            '$evil_user is never locked out.'
        );
    }
};

subtest 'When the failedlogin count reached the limit at different timing.' => sub {
    clear_lockout_statuses();
    {
        my $user_limit = 2;
        my $ip_limit   = 4;
        local $app->config->{__var}{ lc('UserLockoutLimit') } = $user_limit;
        local $app->config->{__var}{ lc('IPLockoutLimit') }   = $ip_limit;

        for (my $i = 0; $i < $user_limit; $i++) {
            MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
        }
        for (my $i = $user_limit; $i < $ip_limit; $i++) {
            MT::Lockout->_insert_failedlogin($app, $evil_ip_address, '');
        }
        $evil_user = $author_class->load($evil_user->id);
        MT::Lockout->unlock($evil_user);
        ok(
            MT::Lockout->is_locked_out_ip($app, $evil_ip_address),
            '$evil_ip_address is locked out yet. (not recovered by unlocking user)'
        );
    }
};

subtest 'When the failedlogin count reached the limit at same timing. And unlock' => sub {
    clear_lockout_statuses();
    {
        my $user_limit = 2;
        my $ip_limit   = 4;
        local $app->config->{__var}{ lc('UserLockoutLimit') } = $user_limit;
        local $app->config->{__var}{ lc('IPLockoutLimit') }   = $ip_limit;

        for (my $i = 0; $i < $ip_limit - $user_limit; $i++) {
            MT::Lockout->_insert_failedlogin($app, $evil_ip_address, '');
        }
        for (my $i = $ip_limit - $user_limit; $i < $ip_limit; $i++) {
            MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
        }
        $evil_user = $author_class->load($evil_user->id);
        MT::Lockout->unlock($evil_user);
        ok(
            MT::Lockout->is_locked_out_ip($app, $evil_ip_address),
            '$evil_ip_address is locked out yet. (not recovered by unlocking user)'
        );
    }
};

subtest 'When the failedlogin count reached the limit at same timing. And remove' => sub {
    clear_lockout_statuses();
    {
        my $user_limit = 2;
        my $ip_limit   = 4;
        local $app->config->{__var}{ lc('UserLockoutLimit') } = $user_limit;
        local $app->config->{__var}{ lc('IPLockoutLimit') }   = $ip_limit;

        for (my $i = 0; $i < $ip_limit - $user_limit; $i++) {
            MT::Lockout->_insert_failedlogin($app, $evil_ip_address, '');
        }
        for (my $i = $ip_limit - $user_limit; $i < $ip_limit; $i++) {
            MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
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
};

subtest 'task' => sub {
    clear_lockout_statuses();
    set_fixed_time($now - $max_interval - 60);
    MT::Lockout->_insert_failedlogin($app, $evil_ip_address, $evil_user->name);
    is($app->model('failedlogin')->count, 1, 'Failedlogin has 1 entries.');
    set_fixed_time($now);

    my $task = $app->registry('tasks', 'CleanExpiredFailedLogin');
    ok($task, 'CleanExpiredFailedLogin is registered.');
    is($task->{frequency}, $app->config->FailedLoginExpirationFrequency, "task's frequency: is FailedLoginExpirationFrequency");
    $task->{code}->();
    is($app->model('failedlogin')->count, 0, 'Failedlogin has 0 entries. (cleaned)');
};

subtest 'Callbasks' => sub {

    subtest 'pre_lockout / post_lockout' => sub {
        my (
            @pre_lockout_args,  @pre_lockout_user_args,  @pre_lockout_ip_args,
            @post_lockout_args, @post_lockout_user_args, @post_lockout_ip_args,
        );
        my $pre_lockout       = sub { push @pre_lockout_args,       [@_] };
        my $pre_lockout_user  = sub { push @pre_lockout_user_args,  [@_] };
        my $pre_lockout_ip    = sub { push @pre_lockout_ip_args,    [@_] };
        my $post_lockout      = sub { push @post_lockout_args,      [@_] };
        my $post_lockout_user = sub { push @post_lockout_user_args, [@_] };
        my $post_lockout_ip   = sub { push @post_lockout_ip_args,   [@_] };

        $app->add_callback('pre_lockout',       1, undef, $pre_lockout);
        $app->add_callback('pre_lockout.user',  1, undef, $pre_lockout_user);
        $app->add_callback('pre_lockout.ip',    1, undef, $pre_lockout_ip);
        $app->add_callback('post_lockout',      1, undef, $post_lockout);
        $app->add_callback('post_lockout.user', 1, undef, $post_lockout_user);
        $app->add_callback('post_lockout.ip',   1, undef, $post_lockout_ip);

        subtest 'for ip lockout' => sub {
            clear_lockout_statuses();
            for (my $i = 0; $i < $ip_limit; $i++) {
                set_fixed_time($now - 60 * ($i + 2));
                MT::Lockout->process_login_result(
                    $app, $evil_ip_address, $unknown_name,
                    MT::Auth::INVALID_PASSWORD());
            }

            is(scalar @pre_lockout_args, 1,                'pre_lockout ran once');
            is($pre_lockout_args[0][2],  $unknown_name,    'pre_lockout was passed username');
            is($pre_lockout_args[0][3],  $evil_ip_address, 'pre_lockout was passed ip');

            is(scalar @post_lockout_args, 1,                'post_lockout ran once.');
            is($post_lockout_args[0][2],  $unknown_name,    'post_lockout was passed username');
            is($post_lockout_args[0][3],  $evil_ip_address, 'post_lockout was passed ip');

            is(scalar @pre_lockout_ip_args, 1,                'pre_lockout.ip ran once');
            is($pre_lockout_args[0][2],     $unknown_name,    'pre_lockout.ip was passed username');
            is($pre_lockout_args[0][3],     $evil_ip_address, 'pre_lockout.ip was passed ip');

            is(scalar @post_lockout_ip_args, 1,                'post_lockout.ip ran once');
            is($post_lockout_args[0][2],     $unknown_name,    'post_lockout.ip was passed username');
            is($post_lockout_args[0][3],     $evil_ip_address, 'post_lockout.ip was passed ip');

            is(scalar @pre_lockout_user_args,  0, 'pre_lockout.user did not run');
            is(scalar @post_lockout_user_args, 0, 'post_lockout.user did not run');
        };

        subtest 'for user lockout' => sub {
            (
                @pre_lockout_args,  @pre_lockout_user_args,  @pre_lockout_ip_args,
                @post_lockout_args, @post_lockout_user_args, @post_lockout_ip_args,
            ) = ();
            clear_lockout_statuses();
            for (my $i = 0; $i < $user_limit; $i++) {
                set_fixed_time($now - 60 * ($i + 2));
                MT::Lockout->process_login_result(
                    $app,             $evil_ip_address,
                    $evil_user->name, MT::Auth::INVALID_PASSWORD());
            }

            is(scalar @pre_lockout_args, 1,                'pre_lockout ran once');
            is($pre_lockout_args[0][2],  $evil_user->name, 'pre_lockout was passed username');
            is($pre_lockout_args[0][3],  $evil_ip_address, 'pre_lockout was passed ip');

            is(scalar @post_lockout_args, 1,                'post_lockout ran once.');
            is($post_lockout_args[0][2],  $evil_user->name, 'post_lockout was passed username');
            is($post_lockout_args[0][3],  $evil_ip_address, 'post_lockout was passed ip');

            is(scalar @pre_lockout_user_args, 1,                'pre_lockout.user ran once');
            is($pre_lockout_args[0][2],       $evil_user->name, 'pre_lockout.user was passed username');
            is($pre_lockout_args[0][3],       $evil_ip_address, 'pre_lockout.user was passed ip');

            is(scalar @post_lockout_user_args, 1,                'post_lockout.user ran once');
            is($post_lockout_args[0][2],       $evil_user->name, 'post_lockout.user was passed username');
            is($post_lockout_args[0][3],       $evil_ip_address, 'post_lockout.user was passed ip');

            is(scalar @pre_lockout_ip_args,  0, 'pre_lockout.ip did not run');
            is(scalar @post_lockout_ip_args, 0, 'post_lockout.ip did not run');
        };
    };
};

done_testing();
