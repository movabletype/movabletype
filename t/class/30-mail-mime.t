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
            my @cases = ({
                    name             => '8bit short',
                    input            => 'a' x 100, # some number smaller than both 990 and 998
                    TransferEncoding => '8bit',
                    expected         => sub { $_[0] },
                },
                {
                    name             => '8bit short',
                    input            => 'a' x 1000, # some number bigger than both 990 and 998
                    TransferEncoding => '8bit',
                    expected         => sub { $_[0] },
                },
                {
                    name             => 'Base64 short',
                    input            => 'a' x 100, # some number smaller than both 990 and 998
                    TransferEncoding => 'base64',
                    expected         => sub { MIME::Base64::encode_base64($_[0]) },
                },
                {
                    name             => 'Base64 long',
                    input            => 'a' x 1000, # some number bigger than both 990 and 998
                    TransferEncoding => 'base64',
                    expected         => sub { MIME::Base64::encode_base64($_[0]) },
                },
            );
            for my $data (@cases) {
                $mt->config('MailTransferEncoding', $data->{TransferEncoding});
                subtest $data->{name} => sub {
                    my ($headers, $body) = send_mail({ %{$data->{header} || {}} }, $data->{input});
                    my $expected = $data->{expected}->($data->{input});
                    $body     =~ s{\x0d\x0a|\x0d|\x0a}{}g;
                    $expected =~ s{\x0d\x0a|\x0d|\x0a}{}g;
                    is($body, $expected, 'right body');
                    is($headers->{'Content-Transfer-Encoding'}, $data->{TransferEncoding}, 'right transter encoding');
                };
            }
        };

        subtest 'header word encoding' => sub {
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
