use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use MT::Test::SendmailMock;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        MT::Test::SendmailMock->sendmail_config(),
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test::App;
use MT::Test::Fixture;

$test_env->prepare_fixture('db');

my $server = MT::Test::SendmailMock->new(test_env => $test_env);

my $objs = MT::Test::Fixture->prepare({
    author => [{
            name         => 'admin',
            email        => 'admin@example.jp',
            password     => 'passw0rd',
            is_superuser => 1,
        }, {
            name     => 'test_user',
            email    => 'test@example.jp',
            password => 'passw0rd',
        }
    ],
});

subtest "admin changes their own password" => sub {
    $test_env->remove_logfile;
    my $admin = $objs->{author}{admin};
    my $app   = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'author',
        blog_id => 0,
        id      => $admin->id,
    });
    $app->post_form_ok({
        old_pass    => 'passw0rd',
        pass        => 'new_passw0rd',
        pass_verify => 'new_passw0rd',
    });
    ok !$app->generic_error, "no error";
    my $log = $test_env->slurp_logfile;
    like $log => qr/User 'admin' \(ID: \d+\) changed their login password/, "logged correctly";
};

subtest "user changes their own password" => sub {
    $test_env->remove_logfile;
    my $user = $objs->{author}{test_user};
    my $app  = MT::Test::App->new;
    $app->login($user);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'author',
        blog_id => 0,
        id      => $user->id,
    });
    $app->post_form_ok({
        old_pass    => 'passw0rd',
        pass        => 'new_passw0rd',
        pass_verify => 'new_passw0rd',
    });
    ok !$app->generic_error, "no error";
    my $log = $test_env->slurp_logfile;
    like $log => qr/User 'test_user' \(ID: \d+\) changed their login password/, "logged correctly";
};

subtest "admin changes test_user's password" => sub {
    $test_env->remove_logfile;
    my $admin = $objs->{author}{admin};
    my $user  = $objs->{author}{test_user};
    my $app   = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'author',
        blog_id => 0,
        id      => $user->id,
    });
    $app->post_form_ok({
        pass        => 'new_passw0rd',
        pass_verify => 'new_passw0rd',
    });
    ok !$app->generic_error, "no error";
    my $log = $test_env->slurp_logfile;
    like $log => qr/User 'admin' \(ID: \d+\) changed the login password for user 'test_user' \(ID: \d+\)/, "logged correctly";

    my $mail_sent = $server->last_sent_mail;
    like $mail_sent => qr/The login password for 'test_user' was changed by a system administrator \(admin\)./, 'sent email';
};

done_testing;

