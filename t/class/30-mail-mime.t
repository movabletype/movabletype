use strict;
use warnings;
use utf8;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    plan skip_all => 'not for Win32' if $^O eq 'MSWin32';
}

our $test_env;
BEGIN {
    $test_env          = MT::Test::Env->new;
    $ENV{MT_CONFIG}    = $test_env->config_file;
    $ENV{MT_TEST_MAIL} = 1;
}

use MT::Test;
use MT;
use MT::Util::Mail;
use MIME::Base64;
use MIME::EncWords;
use Encode;

my $mt = MT->new() or die MT->errstr;
$mt->config('MailTransfer', 'debug');

isa_ok($mt, 'MT');

subtest 'fix_xfer_enc' => sub {
    my $mail_module = MT::Util::Mail::find_module('Email::MIME');
    my $test        = sub {
        my ($conf, $arg, $charset, $expected) = @_;
        $mt->config->set('MailTransferEncoding', $conf);
        my $msg = qq!conf:"$conf", arg:"$arg", charset:"$charset"!;
        is($mail_module->fix_xfer_enc($arg, $charset), $expected, $msg);
    };
    $test->('',                 '',                 'utf-8',       '8bit');
    $test->('',                 '',                 'iso-2022-jp', '7bit');
    $test->('',                 'base64',           'utf-8',       'base64');
    $test->('',                 'base64',           'iso-2022-jp', 'base64');
    $test->('',                 '8bit',             'utf-8',       '8bit');
    $test->('',                 '8bit',             'iso-2022-jp', '8bit');
    $test->('',                 '7bit',             'utf-8',       '8bit');
    $test->('',                 '7bit',             'UTF-8',       '8bit');
    $test->('',                 '7bit',             'iso-2022-jp', '7bit');
    $test->('',                 'quoted-printable', 'utf-8',       'quoted-printable');
    $test->('',                 'quoted-printable', 'iso-2022-jp', 'quoted-printable');
    $test->('',                 'unknown',          'utf-8',       '8bit');
    $test->('',                 'unknown',          'iso-2022-jp', '7bit');
    $test->('base64',           '',                 'utf-8',       'base64');
    $test->('base64',           '',                 'iso-2022-jp', '7bit');
    $test->('8bit',             '',                 'utf-8',       '8bit');
    $test->('8bit',             '',                 'iso-2022-jp', '7bit');
    $test->('7bit',             '',                 'utf-8',       '8bit');
    $test->('7bit',             '',                 'UTF-8',       '8bit');
    $test->('7bit',             '',                 'iso-2022-jp', '7bit');
    $test->('quoted-printable', '',                 'utf-8',       'quoted-printable');
    $test->('quoted-printable', '',                 'iso-2022-jp', '7bit');
    $test->('unknown',          '',                 'utf-8',       '8bit');
    $test->('unknown',          '',                 'iso-2022-jp', '7bit');
    $test->('7bit',             'base64',           'iso-2022-jp', 'base64');
    $test->('7bit',             'base64',           'utf-8',       'base64');
    $test->('8bit',             'base64',           'iso-2022-jp', 'base64');
    $test->('8bit',             'base64',           'utf-8',       'base64');
    $test->('base64',           '7bit',             'iso-2022-jp', '7bit');
    $test->('base64',           '7bit',             'utf-8',       'base64');
    $test->('base64',           '8bit',             'iso-2022-jp', '8bit');
    $test->('base64',           '8bit',             'utf-8',       '8bit');
};

for my $mod_name ('MIME::Lite', 'Email::MIME') {
    my $mail_module = MT::Util::Mail::find_module($mod_name);

    subtest $mod_name => sub {
        plan skip_all => MT::Util::Mail->errstr unless $mail_module;

        subtest '_dedupe_headers' => sub {
            my $hdr = {
                From => 'test1@localhost.localdomain',
                from => 'test2@localhost.localdomain',
                FROM => ['test3@localhost.localdomain'],
                To   => 'test@localhost.localdomain',
            };
            $mail_module->_dedupe_headers($hdr);
            is(keys(%$hdr), 2, 'right number of keys');
            $hdr->{From} = [split(/, /, $hdr->{From})] if !ref($hdr->{From});
            is(scalar(@{ $hdr->{From} }), 3, 'right number of elements');
        };

        subtest 'transfer encoding' => sub {
            my $body_short = 'a' x 100;     # some number bigger than both 990 and 998
            my $body_long  = 'a' x 1000;    # some number bigger than both 990 and 998
            my @cases      = ({
                    name            => 'reduce over spec encoding for iso-2022-jp',
                    input           => $body_short,
                    mailEnc         => 'iso-2022-jp',
                    xferEnc         => '8bit',
                    expected_header => { 'Content-Transfer-Encoding' => '7bit' },
                },
                {
                    name            => 'prefer auto detected xfer encoding 7bit with length is long',
                    input           => $body_long,
                    xferEnc         => '8bit',
                    expected_header => { 'Content-Transfer-Encoding' => '8bit' },
                },
                {
                    name            => 'reduce over spec encoding for iso-2022-jp',
                    input           => $body_long,
                    mailEnc         => 'iso-2022-jp',
                    xferEnc         => 'base64',
                    expected_header => { 'Content-Transfer-Encoding' => '7bit' },
                },
                {
                    name            => 'auto detect xfer encoding for short body',
                    input           => $body_short,
                    xferEnc         => undef,
                    expected_header => { 'Content-Transfer-Encoding' => '8bit' },
                },
                {
                    name            => 'auto detect xfer encoding for long body',
                    input           => $body_long,
                    xferEnc         => undef,
                    expected_header => { 'Content-Transfer-Encoding' => '8bit' },
                },
                {
                    name            => 'auto detect xfer encoding for iso-2022-jp',
                    input           => $body_short,
                    mailEnc         => 'iso-2022-jp',
                    xferEnc         => undef,
                    expected_header => { 'Content-Transfer-Encoding' => '7bit' },
                },
                {
                    name            => 'auto correct wrong xfer encoding',
                    input           => $body_short,
                    xferEnc         => '7bit',
                    expected_header => { 'Content-Transfer-Encoding' => '8bit' },
                },
                {
                    name            => 'auto correct unknown xfer encoding',
                    input           => $body_short,
                    xferEnc         => 'unknown',
                    expected_header => { 'Content-Transfer-Encoding' => '8bit' },
                },
                {
                    name            => 'to header utf8 single',
                    input           => $body_short,
                    xferEnc         => 'base64',
                    header          => { To => "あ<t1\@a.com>" },
                    expected_header => {
                        To                          => expected_regex('あ'),
                        'Content-Transfer-Encoding' => 'base64',
                    },
                },
                {
                    name            => 'to header utf8 multi',
                    input           => $body_short,
                    xferEnc         => 'base64',
                    header          => { To => ["あ<t1\@a.com>", "い<t2\@a.com>"] },
                    expected_header => {
                        To                          => expected_regex('あ', 'い'),
                        'Content-Transfer-Encoding' => 'base64',
                    },
                },
                {
                    name            => 'to header iso-8859-1 single',
                    input           => $body_short,
                    mailEnc         => 'iso-8859-1',
                    xferEnc         => 'base64', # over spec
                    header          => { To => "a/a<t1\@a.com>" },
                    expected_header => {
                        To                          => qr{a/a},
                        'Content-Transfer-Encoding' => '7bit',
                    },
                },
                {
                    name            => 'to header iso-8859-1 multi',
                    input           => $body_short,
                    mailEnc         => 'iso-8859-1',
                    xferEnc         => 'base64', # over spec
                    header          => { To => ["a/a<t1\@a.com>", "a/b<t2\@a.com>"] },
                    expected_header => {
                        To                          => qr{a/a|a/b},
                        'Content-Transfer-Encoding' => '7bit',
                    },
                },
            );
            send_mail_suite($_) for @cases;
        };

        subtest 'various test for body encoding' => sub {
            for my $char ('あ') {
                for my $length (1, 1000) {
                    for my $lb ('', "\n", "\r\n", "\n\n", "\r\n\r\n", "\r\r\n") {
                        my @cases = ({
                                name     => 'utf8',
                            },
                            {
                                name     => 'iso-2022-jp',
                                mailEnc  => 'iso-2022-jp',
                            },
                        );
                        for my $case (@cases) {
                            $case->{input} = ($char x $length) . $lb;
                            my $lb_c = join(',', map { sprintf('0x%0X', ord($_)) } split('', $lb));
                            $case->{name} .= ' - ' . join(' - ', $length, $lb_c ? $lb_c : ());
                            send_mail_suite($case);
                        }
                    }
                }
            }
        };
    };
}

sub send_mail_suite {
    my ($data) = @_;
    $mt->config->set('MailTransferEncoding', $data->{xferEnc});
    $mt->config->set('MailEncoding',         $data->{mailEnc});
    subtest $data->{name} => sub {
        my ($headers, $body) = send_mail({ %{ $data->{header} || {} } }, $data->{input});
        my $expected = do {
            my $encoded = Encode::encode($data->{mailEnc} || 'utf8', $data->{input});
            my $cb = {
                'base64'           => sub { MIME::Base64::encode_base64($_[0]) },
                'quoted-printable' => sub { encode_qp($_[0]) },
            }->{$headers->{'Content-Transfer-Encoding'}->[0]};
            $cb ? $cb->($encoded) : $encoded;
        };
        $body     =~ s{\x0d\x0a|\x0d|\x0a}{}g;
        $expected =~ s{\x0d\x0a|\x0d|\x0a}{}g;
        is($body, $expected, 'right body');
        for my $field (keys %{ $data->{expected_header} || {} }) {
            my $exp = $data->{expected_header}->{$field};
            $exp = ref($exp) eq 'ARRAY' ? $exp : [$exp];
            for (my $i = 0; $i < scalar(@$exp); $i++) {
                if (ref($exp->[$i]) eq 'Regexp') {
                    like($headers->{$field}->[$i], $exp->[$i], 'right header pattern for ' . $field);
                } else {
                    is($headers->{$field}->[$i], $exp->[$i], 'right header value for ' . $field);
                }
            }
        }
    };
}

sub expected_regex {
    my (@words) = @_;
    my @regex   = map { quotemeta(MIME::EncWords::encode_mimeword(Encode::encode('utf8', $_), 'b', 'utf-8')) } @words;
    my $join    = join('|', @regex);
    return qr{$join};
}

sub send_mail {
    my ($hdrs_arg, $body) = @_;
    my (%headers, $mail_body);

    my $save_stderr = \*STDERR;
    pipe my $read, my $write;
    *STDERR = $write;
    MT::Util::Mail->send($hdrs_arg, $body);
    close $write;

    while (my $line = <$read>) {
        last if $line =~ /\A(\x0d\x0a|\x0d|\x0a)\z/;
        $line =~ s{\x0d\x0a|\x0d|\x0a}{}g;
        my ($key, $value) = split /: /, $line, 2;
        push @{ $headers{$key} }, $value;
    }
    $mail_body = join '', <$read>;

    close $read;
    *STDERR = $save_stderr;

    \%headers, $mail_body;
}

done_testing();
