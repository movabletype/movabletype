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
        SMTPOptions       => {Debug => $ENV{TEST_VERBOSE} ? 1 : 0},
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

my $mail_class = MT::Util::Mail::find_module('MT::Mail');

subtest 'simple' => sub {
    eval {
        $mail_class->send({
                To => ['test@localhost.localdomain', 'test2@localhost.localdomain'],
            },
            'mail body'
        );
    };
    ok(!$@, "No error") or note($@);
    ok(!$mail_class->errstr, 'No error') or note($mail_class->errstr);
    my $last_sent = $server->last_sent_mail;
    like($last_sent, qr{mail body}, 'right body');
    like($last_sent, qr{Content-Transfer-Encoding: 8bit\r\n}, 'right newline chars');
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
    ok(!$@, "No error") or note($@);
    ok(!$mail_class->errstr, 'No error') or note($mail_class->errstr);
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
    ok(!$@, "No error") or note($@);
    ok(!$mail_class->errstr, 'No error') or note($mail_class->errstr);
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
    ok(!$@, "No error") or note($@);
    ok(!$mail_class->errstr, 'No error') or note($mail_class->errstr);
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
    ok(!$@, "No error") or note($@);
    ok(!$mail_class->errstr, 'No error') or note($mail_class->errstr);
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
    ok(!$@, "No error") or note($@);
    ok(!$mail_class->errstr, 'No error') or note($mail_class->errstr);
};

subtest 'cc and bcc' => sub {
    eval {
        $mail_class->send({
                To  => ['t1@host.domain', 't2@host.domain'],
                Cc  => ['t3@host.domain'],
                Bcc => ['t4@host.domain', 't5@host.domain'],
            },
            'mail body'
        );
    };
    ok(!$@, "No error") or note($@);
    ok(!$mail_class->errstr, 'No error') or note($mail_class->errstr);
    my $last_sent = $server->last_sent_mail;
    like($last_sent, qr{t3}, 'cc is appeard');
    unlike($last_sent, qr{t4}, 'bcc is not appeard');
    unlike($last_sent, qr{t5}, 'bcc is not appeard');
    my @recipients = $server->last_sent_recipients;
    is(@recipients, 5, 'right number of recipients');
};

$server->stop;

done_testing();
