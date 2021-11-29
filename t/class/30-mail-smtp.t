use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Module::Load '';
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
        SMTPOptions       => {Debug => $ENV{TEST_VERBOSE} ? 1 : 0},
    );
    $ENV{MT_CONFIG}    = $test_env->config_file;
    $ENV{MT_TEST_MAIL} = 1;
}

no Carp::Always;
use MT::Test;
use MT;
use IO::String;

MT->instance;

require MT::Test::AnyEventSMTPServer;
my $server = MT::Test::AnyEventSMTPServer->new;

MT->config(SMTPPort => $server->port);

for my $mail_class ('MT::Mail', 'MT::Mail::MIME') {
    Module::Load::load($mail_class);

    subtest 'simple' => sub {
        eval {
            $mail_class->send({
                    To => ['test@localhost.localdomain', 'test2@localhost.localdomain'],
                },
                'mail body'
            );
        };
        ok !$@ && !$mail_class->errstr, "No error" or note $@;
        my $last_sent = $server->last_sent_mail;
        like($last_sent, qr{mail body}, 'right body');
        unlike($last_sent, qr{\x0d(?!\x0a)|(?<!\x0d)\x0a}, 'no illegal newline chars');
    };

    subtest 'illegal newline chars' => sub {
        eval {
            $mail_class->send({
                    To => ['test@localhost.localdomain', 'test2@localhost.localdomain'],
                },
                "line1\x0d\x0aline2\x0dline3\x0aline4",
            );
        };
        ok !$@ && !$mail_class->errstr, "No error" or note $@;
        my $last_sent = $server->last_sent_mail;
        like($last_sent, qr{line1\x0d\x0aline2\x0d\x0aline3\x0d\x0aline4}, 'right body');
        unlike($last_sent, qr{\x0d(?!\x0a)|(?<!\x0d)\x0a}, 'no illegal newline chars');
    };

    subtest 'different cases' => sub {
        eval {
            $mail_class->send({
                    to => ['test@localhost.localdomain'],
                    To => ['test2@localhost.localdomain'],
                },
                'mail body'
            );
        };
        ok !$@ && !$mail_class->errstr, "No error" or note $@;
    };

    subtest 'different froms and reply-toes' => sub {
        eval {
            $mail_class->send({
                    From       => ['test@localhost.localdomain'],
                    from       => ['test@localhost.localdomain'],
                    To         => ['test@localhost.localdomain'],
                    'Reply-to' => ['test@localhost.localdomain'],
                    'Reply-To' => ['test2@localhost.localdomain'],
                },
                'mail body'
            );
        };
        ok !$@ && !$mail_class->errstr, "No error" or note $@;
    };

    subtest 'different froms and reply-toes in scalar' => sub {
        eval {
            $mail_class->send({
                    From       => 'test@localhost.localdomain',
                    from       => 'test@localhost.localdomain',
                    To         => 'test@localhost.localdomain',
                    'Reply-to' => 'test@localhost.localdomain',
                    'Reply-To' => 'test2@localhost.localdomain',
                },
                'mail body'
            );
        };
        ok !$@ && !$mail_class->errstr, "No error" or note $@;
    };

    subtest 'different froms and reply-toes with <>' => sub {
        eval {
            $mail_class->send({
                    From       => 'test@localhost.localdomain',
                    from       => 'test@localhost.localdomain',
                    To         => 'test@localhost.localdomain',
                    'Reply-to' => '<test@localhost.localdomain>',
                    'Reply-To' => '<test2@localhost.localdomain>',
                },
                'mail body'
            );
        };
        ok !$@ && !$mail_class->errstr, "No error" or note $@;
    };

    subtest 'different froms and reply-toes with the same address' => sub {
        eval {
            $mail_class->send({
                    From       => 'test@localhost.localdomain',
                    from       => 'test@localhost.localdomain',
                    To         => 'test@localhost.localdomain',
                    'Reply-to' => 'test@localhost.localdomain',
                    'Reply-To' => 'test@localhost.localdomain',
                },
                'mail body'
            );
        };
        ok !$@ && !$mail_class->errstr, "No error" or note $@;
    };
}

$server->stop;

done_testing();
