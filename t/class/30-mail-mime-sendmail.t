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
use MT::Util::Mail;
use IO::String;
use MIME::Head;
use MT::Util ();

MT->instance;

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
        validate_headers();
        my $last_sent = last_sent_mail();
        like($last_sent, qr{mail body},                         'right body');
        like($last_sent, qr{Content-Transfer-Encoding: 8bit\n}, 'right newline chars');
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
        validate_headers();
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
        validate_headers();
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
        validate_headers();
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
        validate_headers();
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
        validate_headers();
    };

    subtest 'only uncanonical reply-to' => sub {
        eval {
            MT::Util::Mail->send({
                    From       => 'test@localhost.localdomain',
                    To         => 'test@localhost.localdomain',
                    'Reply-to' => 'test@localhost.localdomain',
                },
                'mail body'
            );
        };
        ok !$@ && !MT::Util::Mail->errstr, "No error" or note $@;
        validate_headers();
    };

    subtest 'only uncanonical to' => sub {
        eval {
            MT::Util::Mail->send({
                    From       => 'test@localhost.localdomain',
                    TO         => 'test@localhost.localdomain',
                    'Reply-To' => 'test@localhost.localdomain',
                },
                'mail body'
            );
        };
        ok !$@ && !MT::Util::Mail->errstr, "No error" or note $@;
        validate_headers();
    };
}

done_testing();

sub validate_headers {
    my $file   = $test_env->path('mail');
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
            my @invalid   = grep { !defined $_ or $_ eq '' or !_is_valid_email($_) } @addresses;
            ok !@invalid, "no invalid $tag" or note explain \@invalid;
        }
    }
}

sub last_sent_mail {
    return do { open my $fh, '<', _last_mail_file() or return; local $/; <$fh> }
}

sub _last_mail_file { "$ENV{MT_TEST_ROOT}/mail" }

sub _is_valid_email {
    my $address = shift;
    $address =~ s/^<|>$//gs;
    MT::Util::is_valid_email($address);
}
