use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
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
        SMTPOptions       => {},
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
    $ENV{MT_TEST_MAIL} = 1;
}

no Carp::Always;
use MT::Test;
use MT;
use MT::Mail;
use IO::String;

MT->instance;

require MT::Test::AnyEventSMTPServer;
my $server = MT::Test::AnyEventSMTPServer->new;

MT->config(SMTPPort => $server->port);

subtest 'simple' => sub {
    eval {
        MT::Mail->send({
            To => ['test@localhost.localdomain', 'test2@localhost.localdomain'],
        }, 'mail body');
    };
    ok !$@ && !MT::Mail->errstr, "No error";
};

subtest 'different cases' => sub {
    eval {
        MT::Mail->send({
            to => ['test@localhost.localdomain'],
            To => ['test2@localhost.localdomain'],
        }, 'mail body');
    };
    ok !$@ && !MT::Mail->errstr, "No error";
};

$server->stop;

done_testing();
