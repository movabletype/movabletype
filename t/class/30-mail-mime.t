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

my $mt = MT->new() or die MT->errstr;
$mt->config('MailTransfer', 'debug');

isa_ok($mt, 'MT');

sub base64_encode_suite {
    my $mail_class     = shift;
    my $max_line_octet = $mail_class->MAX_LINE_OCTET;
    return ({
            name        => '8bit',
            input       => 'a' x $max_line_octet,
            header_args => { 'Content-Transfer-Encoding' => '8bit' },
            expected    => 'a' x $max_line_octet,
            headers     => { 'Content-Transfer-Encoding' => qr/\A\dbit\z/, },
        },
        {
            name        => 'Base64 encoded',
            input       => 'a' x ($max_line_octet + 1),
            header_args => { 'Content-Transfer-Encoding' => 'base64' },
            expected    => MIME::Base64::encode_base64('a' x ($max_line_octet + 1)),
            headers     => { 'Content-Transfer-Encoding' => qr/\Abase64\z/, },
        });
}

for my $c ('MT::Mail::MIME::Lite', 'MT::Mail::MIME::EmailMIME') {
    my $mail_class = MT::Util::Mail::find_module($c);

    subtest 'render' => sub {
        my $hdrs = {
            'Content-Type'              => q(text/plain; charset="utf-8"),
            'Content-Transfer-Encoding' => '8bit',
            'MIME-Version'              => "1.0",
            To                          => 'to@a.com',
            Cc                          => 'cc@a.com',
            Bcc                         => 'bcc@a.com',
        };
        subtest 'without hide_bcc' => sub {
            my $hdr_copy = {%$hdrs};
            my ($ret, @recipients) = $mail_class->render(header => $hdr_copy, body => 'body');
            print($ret);
            like($ret, qr/To:/, 'key exists');
            like($ret, qr/Cc:/, 'key exists');
            like($ret, qr/Bcc:/, 'key exists');
            is(scalar @recipients, 3, 'right number of recipients')
        };
        subtest 'with hide_bcc' => sub {
            my $hdr_copy = {%$hdrs};
            my ($ret, @recipients) = $mail_class->render(header => $hdr_copy, body => 'body', hide_bcc => 1);
            like($ret, qr/To:/, 'key exists');
            like($ret, qr/Cc:/, 'key exists');
            unlike($ret, qr/Bcc:/, 'key exists');
            is(scalar @recipients, 3, 'right number of recipients')
        };
    };

    subtest $mail_class => sub {

        subtest 'encode' => sub {
            for my $data (base64_encode_suite($mail_class)) {
                my ($headers, $body) = send_mail({ %{ $data->{header_args} } }, $data->{input});
                my $expected = $data->{expected};
                $body     =~ s{\x0d\x0a|\x0d|\x0a}{}g;
                $expected =~ s{\x0d\x0a|\x0d|\x0a}{}g;
                is($body, $expected, $data->{name} . ' : body');
                foreach my $key (sort keys %{ $data->{headers} }) {
                    like(
                        $headers->{$key},
                        $data->{headers}{$key},
                        $data->{name} . ' : header : ' . $key
                    );
                }
            }
        };

        subtest '_dedupe_headers' => sub {
            my $hdr = {
                From => 'test1@localhost.localdomain',
                from => 'test2@localhost.localdomain',
                FROM => ['test3@localhost.localdomain'],
                To   => 'test@localhost.localdomain',
            };
            $mail_class->_dedupe_headers($hdr);
            is(keys(%$hdr), 2, 'right number of keys');
            $hdr->{From} = [split(/, /, $hdr->{From})] if !ref($hdr->{From});
            is(scalar(@{ $hdr->{From} }), 3, 'right number of elements');
        };
    };

    subtest 'header encoding' => sub {
        subtest 'utf-8' => sub {
            $mt->config('MailEncoding',         'utf-8');
            $mt->config('MailTransferEncoding', 'base64');
            my $jp1   = 'あ';
            my $jp2   = 'い';
            my $mime1 = '=?UTF-8?B?44GC?=';    # あ
            my $mime2 = '=?UTF-8?B?44GE?=';    # い
            subtest 'single' => sub {
                my $hdrs = { To => "$jp1<t1\@a.com>" };
                my ($headers, $body) = send_mail($hdrs, 'body text');
                like($headers->{To}, qr/\Q$mime1\E/, 'right to header');
            };
            subtest 'multiple' => sub {
                my $hdrs = { To => ["$jp1<t1\@a.com>", "$jp2<t2\@a.com>"] };
                my ($headers, $body) = send_mail($hdrs, 'body text');
                my @addrs = split(', ', $headers->{To});
                like($addrs[0], qr{\Q$mime1\E}, 'right To header');
                like($addrs[1], qr{\Q$mime2\E}, 'right To header');
            };
        };
        subtest 'iso-8859-1' => sub {
            $mt->config('MailEncoding',         'iso-8859-1');
            $mt->config('MailTransferEncoding', 'base64');
            subtest 'single' => sub {
                my $hdrs = { To => "a/a<t1\@a.com>" };
                my ($headers, $body) = send_mail($hdrs, 'body text');
                like($headers->{To}, qr{a/a}, 'right to header');
            };
            subtest 'multiple' => sub {
                my $hdrs = { To => ["a/a<t1\@a.com>", "a/b<t2\@a.com>"] };
                my ($headers, $body) = send_mail($hdrs, 'body text');
                my @addrs = split(', ', $headers->{To});
                like($addrs[0], qr{a/a}, 'right To header');
                like($addrs[1], qr{a/b}, 'right To header');
            };
        };
    };
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
        if (exists $headers{$key}) {
            $headers{$key} = [
                (ref $headers{$key}) ? @{ $headers{$key} } : $headers{$key},
                $value,
            ];
        } else {
            $headers{$key} = $value;
        }
    }
    $mail_body = join '', <$read>;

    close $read;
    *STDERR = $save_stderr;

    \%headers, $mail_body;
}

done_testing();
