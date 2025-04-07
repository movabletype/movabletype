use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use Test::SharedFork;
use MT::Test::Env;
BEGIN {
    plan skip_all => 'not for Win32' if $^O eq 'MSWin32';
}

our $test_env;
BEGIN {
    require Authen::SASL;
    if ($ENV{MT_TEST_AUTHEN_SASL_XS}) {
        unless (eval { require Authen::SASL::XS; 1 }) {
            plan skip_all => 'requires Authen::SASL::XS';
        }
        Authen::SASL->import('XS');
    } else {
        Authen::SASL->import('Perl');
    }

    my %smtp_env;
    for my $key (qw(SMTPAuth SMTPS SMTPUser SMTPPassword SMTPAuthSASLMechanism)) {
        my $env_key = 'MT_TEST_' . uc($key);
        next unless exists $ENV{$env_key};
        $smtp_env{$key} = $ENV{$env_key};
    }
    $smtp_env{SMTPAuth} //= 0;

    $test_env = MT::Test::Env->new(
        MailTransfer      => 'smtp',
        SMTPServer        => 'localhost',
        SMTPSSLVerifyNone => 1,
        SMTPOptions       => { Debug => $ENV{TEST_VERBOSE} ? 1 : 0 },
        %smtp_env,
    );
    $ENV{MT_CONFIG}    = $test_env->config_file;
    $ENV{MT_TEST_MAIL} = 1;
}

use MT::Test;
use MT;
use IO::String;

MT->instance;

require MT::Util::Mail;
require MT::Test::MailPitServer;

my %mailpit_opts;
if ($ENV{MT_TEST_SMTPS} or $ENV{MT_TEST_SMTPAUTH}) {
    $mailpit_opts{requires_ssl} = 1;
}
if ($ENV{MT_TEST_SMTPUSER} and $ENV{MT_TEST_SMTPPASSWORD}) {
    $mailpit_opts{auth} = { $ENV{MT_TEST_SMTPUSER} => $ENV{MT_TEST_SMTPPASSWORD} };
}

my $server = MT::Test::MailPitServer->run(%mailpit_opts);
$server->test_connection or plan skip_all => 'Mailpit seems not working';

MT->config(SMTPPort => $server->port);

my @mail_modules = split / /, $ENV{MT_TEST_MAIL_MODULES} || 'MT::Mail';

for my $mod_name (@mail_modules) {
    my $mail_module = MT::Util::Mail::find_module($mod_name);

    subtest $mod_name => sub {
        plan skip_all => MT::Util::Mail->errstr unless $mail_module;

        subtest 'simple' => sub {
            eval {
                MT::Util::Mail->send({
                        To => ['test@localhost.localdomain', 'test2@localhost.localdomain'],
                    },
                    'mail body'
                );
            };
            ok(!$@, "No error") or note($@);
            ok(!MT::Util::Mail->errstr, 'No error') or note(MT::Util::Mail->errstr);
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
            ok(!$@, "No error") or note($@);
            ok(!MT::Util::Mail->errstr, 'No error') or note(MT::Util::Mail->errstr);
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
            ok(!$@, "No error") or note($@);
            ok(!MT::Util::Mail->errstr, 'No error') or note(MT::Util::Mail->errstr);
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
            ok(!$@, "No error") or note($@);
            ok(!MT::Util::Mail->errstr, 'No error') or note(MT::Util::Mail->errstr);
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
            ok(!$@, "No error") or note($@);
            ok(!MT::Util::Mail->errstr, 'No error') or note(MT::Util::Mail->errstr);
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
            ok(!$@, "No error") or note($@);
            ok(!MT::Util::Mail->errstr, 'No error') or note(MT::Util::Mail->errstr);
        };

        subtest 'SMTPAuth fails because of lack of user info' => sub {
            my $mt = MT->new();
            plan skip_all => 'For SMTPAuth only' unless $mt->config->SMTPAuth;
            my $orig_user = $mt->config('SMTPUser');
            my $orig_pass = $mt->config('SMTPPassword');
            $mt->config('SMTPUser', undef);
            $mt->config('SMTPPassword', undef);
            eval {
                MT::Util::Mail->send({
                        From       => 'test@localhost.localdomain',
                        To         => 'test@localhost.localdomain',
                    },
                    'mail body'
                );
            };
            is(MT::Util::Mail->errstr, qq{Username and password is required for SMTP authentication.\n}, 'right error');
            $mt->config->set('SMTPUser', $orig_user);
            $mt->config->set('SMTPPassword', $orig_pass);
            $MT::ErrorHandler::ERROR = undef;
        };

        subtest 'SMTPAuth fails' => sub {
            my $mt = MT->new();
            plan skip_all => 'For SMTPAuth only' unless $mt->config->SMTPAuth;
            my $orig_user = $mt->config('SMTPUser');
            my $orig_pass = $mt->config('SMTPPassword');
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
            like(MT::Util::Mail->errstr, qr{All the supported SMTP authentication mechanisms failed}, 'right error');
            $mt->config->set('SMTPUser', $orig_user);
            $mt->config->set('SMTPPassword', $orig_pass);
            $MT::ErrorHandler::ERROR = undef;
        };

        subtest 'cc and bcc' => sub {
            eval {
                MT::Util::Mail->send({
                        To  => ['t1@host.domain', 't2@host.domain'],
                        Cc  => ['t3@host.domain'],
                        Bcc => ['t4@host.domain', 't5@host.domain'],
                    },
                    'mail body'
                );
            };
            ok(!$@, "No error") or note($@);
            ok(!MT::Util::Mail->errstr, 'No error') or note(MT::Util::Mail->errstr);
            my $last_sent = $server->last_sent_mail;
            like($last_sent, qr{t3}, 'cc exists');
            like($last_sent, qr{t4}, 'bcc exists');
            like($last_sent, qr{t5}, 'bcc exists');
            my @recipients = $server->last_sent_recipients;
            is(@recipients, 5, 'right number of recipients');
        };
    }
}

done_testing();
