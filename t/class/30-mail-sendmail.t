use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use Test::SharedFork;
use MT::Test::Env;
use MT::Test::SendmailMock;

our $test_env;
BEGIN {
    plan skip_all => 'not for Win32' if $^O eq 'MSWin32';
    $test_env          = MT::Test::Env->new(MT::Test::SendmailMock->sendmail_config);
    $ENV{MT_CONFIG}    = $test_env->config_file;
    $ENV{MT_TEST_MAIL} = 1;
}

no Carp::Always;
use MT::Test;
use MT;
use MT::Util::Mail;
use IO::String;
use MIME::Head;
use MT::Util ();

MT->instance;

my $sendmail = MT::Test::SendmailMock->new(test_env => $test_env);

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
    validate_headers();
    my $last_sent = $sendmail->last_sent_mail();
    like($last_sent, qr{mail body}, 'right body');
    like($last_sent, qr{Content-Transfer-Encoding: 8bit\n}, 'right newline chars');
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
    validate_headers();
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
    validate_headers();
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
    validate_headers();
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
    validate_headers();
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
    validate_headers();
};

subtest 'only uncanonical reply-to' => sub {
    eval {
        $mail_class->send({
                From       => 'test@localhost.localdomain',
                To         => 'test@localhost.localdomain',
                'Reply-to' => 'test@localhost.localdomain',
            },
            'mail body'
        );
    };
    ok(!$@, "No error") or note($@);
    ok(!$mail_class->errstr, 'No error') or note($mail_class->errstr);
    validate_headers();
};

subtest 'only uncanonical to' => sub {
    eval {
        $mail_class->send({
                From       => 'test@localhost.localdomain',
                TO         => 'test@localhost.localdomain',
                'Reply-To' => 'test@localhost.localdomain',
            },
            'mail body'
        );
    };
    ok(!$@, "No error") or note($@);
    ok(!$mail_class->errstr, 'No error') or note($mail_class->errstr);
    validate_headers();
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
    my $last_sent = $sendmail->last_sent_mail;
    like($last_sent, qr{t3}, 'cc is appeard');
    like($last_sent, qr{t4}, 'bcc is appeard');
    like($last_sent, qr{t5}, 'bcc is appeard');
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
        if ($count and $tag =~ /^(?:From|Sender|Reply-To|To|Cc|Bcc)$/) {
            my $value = $header->unfold($tag)->get($tag);
            $value =~ s/(?:\015|\012)+\z//gs;
            note "[$tag] $value";
            my @addresses = split /,\s*/, $value;
            my @invalid = grep {!defined $_ or $_ eq '' or !_is_valid_email($_)} @addresses;
            ok !@invalid, "no invalid $tag" or note explain \@invalid;
        }
    }
}

sub _is_valid_email {
    my $address = shift;
    $address =~ s/^<|>$//gs;
    MT::Util::is_valid_email($address);
}
