use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use Test::SharedFork;
use MT::Test::Env;
BEGIN {
    plan skip_all => 'not for Win32' if $^O eq 'MSWin32';
    eval { require AnyEvent::SMTP::Server; 1 }
        or plan skip_all => 'requires AnyEvent::SMTP::Server';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        MailTransfer      => 'smtp',
        SMTPServer        => 'localhost',
        SMTPAuth          => 0,
        SMTPSSLVerifyNone => 1,
        SMTPOptions       => { Debug => $ENV{TEST_VERBOSE} ? 1 : 0 },
    );
    $ENV{MT_CONFIG}    = $test_env->config_file;
    $ENV{MT_TEST_MAIL} = 1;
}

no Carp::Always;
use MT::Test;
use MT;
use MT::Util::Mail;
use IO::String;

MT->instance;

require MT::Test::AnyEventSMTPServer;
my $server = MT::Test::AnyEventSMTPServer->new;

MT->config(SMTPPort => $server->port);

for my $c ('MT::Mail::MIME::Lite', 'MT::Mail::MIME::EmailMIME') {
    my $mail_class = MT::Util::Mail::find_module($c);

    subtest 'simple' => sub {
        eval {
            MT::Util::Mail->send({
                    To => ['test@localhost.localdomain', 'test2@localhost.localdomain'],
                },
                'mail body'
            );
        };
        ok !$@ && !MT::Util::Mail->errstr, "No error" or note $@;
        my $last_sent = $server->last_sent_mail;
        like($last_sent, qr{mail body},                           'right body');
        like($last_sent, qr{Content-Transfer-Encoding: 8bit\r\n}, 'right newline chars');
    };

    subtest 'different cases' => sub {
        eval {
            MT::Util::Mail->send({
                    to => ['test@localhost.localdomain'],
                    To => ['test2@localhost.localdomain'],
                },
                'mail body'
            );
        };
        ok !$@ && !MT::Util::Mail->errstr, "No error" or note $@;
    };

    subtest 'different froms and reply-toes' => sub {
        eval {
            MT::Util::Mail->send({
                    From       => ['test@localhost.localdomain'],
                    from       => ['test@localhost.localdomain'],
                    To         => ['test@localhost.localdomain'],
                    'Reply-to' => ['test@localhost.localdomain'],
                    'Reply-To' => ['test2@localhost.localdomain'],
                },
                'mail body'
            );
        };
        ok !$@ && !MT::Util::Mail->errstr, "No error" or note $@;
    };

    subtest 'different froms and reply-toes in scalar' => sub {
        eval {
            MT::Util::Mail->send({
                    From       => 'test@localhost.localdomain',
                    from       => 'test@localhost.localdomain',
                    To         => 'test@localhost.localdomain',
                    'Reply-to' => 'test@localhost.localdomain',
                    'Reply-To' => 'test2@localhost.localdomain',
                },
                'mail body'
            );
        };
        ok !$@ && !MT::Util::Mail->errstr, "No error" or note $@;
    };

    subtest 'different froms and reply-toes with <>' => sub {
        eval {
            MT::Util::Mail->send({
                    From       => 'test@localhost.localdomain',
                    from       => 'test@localhost.localdomain',
                    To         => 'test@localhost.localdomain',
                    'Reply-to' => '<test@localhost.localdomain>',
                    'Reply-To' => '<test2@localhost.localdomain>',
                },
                'mail body'
            );
        };
        ok !$@ && !MT::Util::Mail->errstr, "No error" or note $@;
    };

    subtest 'different froms and reply-toes with the same address' => sub {
        eval {
            MT::Util::Mail->send({
                    From       => 'test@localhost.localdomain',
                    from       => 'test@localhost.localdomain',
                    To         => 'test@localhost.localdomain',
                    'Reply-to' => 'test@localhost.localdomain',
                    'Reply-To' => 'test@localhost.localdomain',
                },
                'mail body'
            );
        };
        ok !$@ && !MT::Util::Mail->errstr, "No error" or note $@;
    };

    subtest 'SMTPAuth fails because of lack of user info' => sub {
        my $mt = MT->new();
        $mt->config('SMTPAuth', 'starttls');
        eval {
            MT::Util::Mail->send({
                    From       => 'test@localhost.localdomain',
                    To         => 'test@localhost.localdomain',
                },
                'mail body'
            );
        };
        is(MT::Util::Mail->errstr, qq{Username and password is required for SMTP authentication.\n}, 'right error');
        $mt->config->set('SMTPAuth', 0);
        $MT::ErrorHandler::ERROR = undef;
    };

    subtest 'SMTPAuth fails' => sub {
        my $mt = MT->new();
        $mt->config('SMTPAuth', 'starttls');
        $mt->config('SMTPUser', 'user');
        $mt->config('SMTPPassword', 'password');
        eval {
            MT::Util::Mail->send({
                    From       => 'test@localhost.localdomain',
                    To         => 'test@localhost.localdomain',
                },
                'mail body'
            );
        };
        is(MT::Util::Mail->errstr, qq{Authentication failure: Command unknown: 'AUTH'\n}, 'right error');
        $mt->config->set('SMTPAuth', 0);
        $mt->config->set('SMTPUser', undef);
        $mt->config->set('SMTPPassword', undef);
        $MT::ErrorHandler::ERROR = undef;
    };
}

$server->stop;

done_testing();
