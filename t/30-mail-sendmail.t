use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";    # t/lib
use Test::More;
use Test::SharedFork;
use MT::Test::Env;
BEGIN {
    plan skip_all => 'not for Win32' if $^O eq 'MSWin32';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        MailTransfer => 'sendmail',
        SendMailPath => 'TEST_ROOT/bin/sendmail.pl',
    );
    $ENV{MT_CONFIG}    = $test_env->config_file;
    $ENV{MT_TEST_MAIL} = 1;

    my $sendmail = $test_env->save_file('bin/sendmail.pl', <<"SENDMAIL");
#!$^X
use strict;
use warnings;
use Getopt::Long;
GetOptions(\\my \%opts => "from|f", "oi", "t");

my \$mail = do { local \$/; <STDIN> };

print STDERR "MAIL: \$mail\\n" if \$ENV{TEST_VERBOSE};
open my \$fh, '>', "$ENV{MT_TEST_ROOT}/mail";
print \$fh \$mail, "\\n";
SENDMAIL
    chmod 0755, $sendmail;
}

no Carp::Always;
use MT::Test;
use MT;
use MT::Mail;
use IO::String;
use MIME::Head;

MT->instance;

subtest 'simple' => sub {
    eval {
        MT::Mail->send({
                To => ['test@localhost.localdomain', 'test2@localhost.localdomain'],
            },
            'mail body'
        );
    };
    ok !$@ && !MT::Mail->errstr, "No error" or note $@;
    validate_headers();
};

subtest 'different cases' => sub {
    eval {
        MT::Mail->send({
                to => ['test@localhost.localdomain'],
                To => ['test2@localhost.localdomain'],
            },
            'mail body'
        );
    };
    ok !$@ && !MT::Mail->errstr, "No error" or note $@;
    validate_headers();
};

subtest 'different froms and reply-toes' => sub {
    eval {
        MT::Mail->send({
                From       => ['test@localhost.localdomain'],
                from       => ['test@localhost.localdomain'],
                To         => ['test@localhost.localdomain'],
                'Reply-to' => ['test@localhost.localdomain'],
                'Reply-To' => ['test2@localhost.localdomain'],
            },
            'mail body'
        );
    };
    ok !$@ && !MT::Mail->errstr, "No error" or note $@;
    validate_headers();
};

subtest 'different froms and reply-toes in scalar' => sub {
    eval {
        MT::Mail->send({
                From       => 'test@localhost.localdomain',
                from       => 'test@localhost.localdomain',
                To         => 'test@localhost.localdomain',
                'Reply-to' => 'test@localhost.localdomain',
                'Reply-To' => 'test2@localhost.localdomain',
            },
            'mail body'
        );
    };
    ok !$@ && !MT::Mail->errstr, "No error" or note $@;
    validate_headers();
};

subtest 'different froms and reply-toes with <>' => sub {
    eval {
        MT::Mail->send({
                From       => 'test@localhost.localdomain',
                from       => 'test@localhost.localdomain',
                To         => 'test@localhost.localdomain',
                'Reply-to' => '<test@localhost.localdomain>',
                'Reply-To' => '<test2@localhost.localdomain>',
            },
            'mail body'
        );
    };
    ok !$@ && !MT::Mail->errstr, "No error" or note $@;
    validate_headers();
};

subtest 'different froms and reply-toes with the same address' => sub {
    eval {
        MT::Mail->send({
                From       => 'test@localhost.localdomain',
                from       => 'test@localhost.localdomain',
                To         => 'test@localhost.localdomain',
                'Reply-to' => 'test@localhost.localdomain',
                'Reply-To' => 'test@localhost.localdomain',
            },
            'mail body'
        );
    };
    ok !$@ && !MT::Mail->errstr, "No error" or note $@;
    validate_headers();
};

done_testing();

sub validate_headers {
    my $file = $test_env->path('mail');
    my $header = MIME::Head->from_file($file);
    # SendGrid (or RFC) strictly requests the following tags must not be duplicated
    my @tags = qw(From Sender Reply-To To Cc Bcc X-SMTPAPI);
    # According to the RFC, a unique Date field must exist but MT::Mail does not follow the rule yet
    # push @tags, qw(Date);
    # According to the RFC, there are a few tags that must not be duplicated
    push @tags, qw(Subject Message-ID);
    for my $tag (@tags) {
        my $count = $header->count($tag) || 0;
        if ($tag =~ /\A(?:From|Date)\z/) {
            ok $count == 1, "has $count $tag";
        } else {
            ok $count <= 1, "has $count $tag";
        }
    }
    unlink $file;
}