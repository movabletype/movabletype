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
use MT::Test::Image;
use MT;
use MT::Util::Mail;
use MIME::Base64;
use MIME::QuotedPrint;
use MIME::EncWords;
use Encode;
use File::Basename;

my $mt = MT->new() or die MT->errstr;
$mt->config('MailTransfer', 'debug');

isa_ok($mt, 'MT');

subtest 'fix_xfer_enc' => sub {
    my $mail_module = MT::Util::Mail::find_module('Email::MIME');
    my $test        = sub {
        my ($enc, $charset, $body, $expected) = @_;
        $mt->config->set('MailTransferEncoding', $enc);
        is($mail_module->fix_xfer_enc($enc, $charset, $body), $expected, qq!enc:"$enc", charset:"$charset"!);
    };

    my $jp = 'あ';

    $test->('',                 'utf-8',       'a', '7bit');
    $test->('',                 'utf-8',       $jp, 'base64');
    $test->('',                 'iso-2022-jp', 'a', '7bit');
    $test->('',                 'iso-2022-jp', $jp, '7bit');
    $test->('base64',           'utf-8',       'a', 'base64');
    $test->('base64',           'iso-2022-jp', 'a', 'base64');
    $test->('8bit',             'utf-8',       'a', '8bit');
    $test->('8bit',             'iso-2022-jp', 'a', '8bit');
    $test->('7bit',             'utf-8',       'a', '7bit');
    $test->('7bit',             'UTF-8',       'a', '7bit');
    $test->('7bit',             'utf-8',       $jp, 'base64');
    $test->('7bit',             'UTF-8',       $jp, 'base64');
    $test->('7bit',             'iso-2022-jp', 'a', '7bit');
    $test->('quoted-printable', 'utf-8',       'a', 'quoted-printable');
    $test->('quoted-printable', 'iso-2022-jp', 'a', 'quoted-printable');
    $test->('unknown',          'utf-8',       'a', '7bit');
    $test->('unknown',          'iso-2022-jp', 'a', '7bit');

    # 998 octets detection tests
    $test->('',       'utf-8',       'a' x 999,              'quoted-printable');
    $test->('',       'iso-2022-jp', 'a' x 999,              'quoted-printable');
    $test->('',       'utf-8',       $jp . 'a' x 999,        'base64');
    $test->('',       'iso-2022-jp', $jp . 'a' x 999,        'base64');
    $test->('',       'utf-8',       "\n" . 'a' x 999,       'quoted-printable');
    $test->('',       'iso-2022-jp', "\n" . 'a' x 999,       'quoted-printable');
    $test->('',       'utf-8',       "\n" . $jp . 'a' x 999, 'base64');
    $test->('',       'iso-2022-jp', "\n" . $jp . 'a' x 999, 'base64');
    $test->('',       'utf-8',       $jp x 333,              'base64');             # 333 x 3byte = 999
    $test->('',       'iso-2022-jp', $jp x 333,              '7bit');               # 333 x 2byte = 666
    $test->('',       'iso-2022-jp', $jp x 500,              'base64');             # 500 x 2byte = 1000
    $test->('',       'utf-8',       "\n" . $jp x 333,       'base64');             # 333 x 3byte = 999
    $test->('',       'iso-2022-jp', "\n" . $jp x 333,       '7bit');               # 333 x 2byte = 666
    $test->('',       'iso-2022-jp', "\n" . $jp x 500,       'base64');             # 500 x 2byte = 1000
    $test->('base64', 'iso-2022-jp', $jp x 333,              'base64');             # 333 x 2byte = 666
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
            my $body_short = 'a' x 100;     # some number smaller than both 998
            my $body_long  = 'a' x 1000;    # some number bigger than both 998
            my @cases      = ({
                    input           => $body_short,
                    mailEnc         => 'iso-2022-jp',
                    expected_header => { 'Content-Transfer-Encoding' => '7bit' },
                },
                {
                    input           => $body_long,
                    expected_header => { 'Content-Transfer-Encoding' => 'quoted-printable' },
                },
                {
                    input           => $body_long,
                    mailEnc         => 'iso-2022-jp',
                    xferEnc         => 'base64',
                    expected_header => { 'Content-Transfer-Encoding' => 'base64' },
                },
                {
                    input           => $body_long . 'あ',
                    header          => { Subject => "い" },
                    expected_header => { 'Content-Transfer-Encoding' => 'base64', Subject => expected_regex('い') },
                },
                {
                    input           => $body_short,
                    expected_header => { 'Content-Transfer-Encoding' => '7bit' },
                },
                {
                    input           => $body_long,
                    expected_header => { 'Content-Transfer-Encoding' => 'quoted-printable' },
                },
                {
                    input           => $body_short,
                    mailEnc         => 'iso-2022-jp',
                    expected_header => { 'Content-Transfer-Encoding' => '7bit' },
                },
                {
                    input           => $body_short,
                    header          => { To => "あ<t1\@a.com>" },
                    expected_header => { To => expected_regex('あ') },
                },
                {
                    input           => $body_short,
                    header          => { To => ["あ<t1\@a.com>", "い<t2\@a.com>"] },
                    expected_header => { To => expected_regex('あ', 'い') },
                },
                {
                    input           => $body_short,
                    mailEnc         => 'iso-8859-1',
                    header          => { To => "a/a<t1\@a.com>" },
                    expected_header => { To => qr{a/a} },
                },
                {
                    input           => $body_short,
                    mailEnc         => 'iso-8859-1',
                    header          => { To => ["a/a<t1\@a.com>", "a/b<t2\@a.com>"] },
                    expected_header => { To => qr{a/a|a/b} },
                },
            );
            send_mail_suite($_) for @cases;
        };

        subtest 'various test for body encoding' => sub {
            for my $char ('あ') {
                for my $length (1, 1000) {
                    for my $lb ('', "\n", "\r\n", "\n\n", "\r\n\r\n", "\r\r\n") {
                        my @cases = ({
                                name => 'utf8',
                            },
                            {
                                name    => 'iso-2022-jp',
                                mailEnc => 'iso-2022-jp',
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

        for my $setting (['ISO-2022-JP', '8bit'], ['UTF-8', 'quoted-printable']) {
            my ($mailenc, $xfer_enc) = @$setting;
            $mt->config->set('MailEncoding',         $mailenc);
            $mt->config->set('MailTransferEncoding', $xfer_enc);
            my $charsetl = lc($mailenc);
            my $desc     = sprintf('MailEncoding=%s, MailTransferEncoding=%s', $mailenc, $xfer_enc);

            subtest 'attach files with ' . $desc => sub {
                my (undef, $file1) = MT::Test::Image->tempfile(DIR => $test_env->root, SUFFIX => '.gif');
                my (undef, $file2) = MT::Test::Image->tempfile(DIR => $test_env->root, SUFFIX => '.png');

                subtest 'prepare_parts' => sub {
                    my $parts = MT::Mail::MIME->prepare_parts([
                            { name => 'foo.unknown', 'path' => $file1 },
                        ],
                        $mailenc
                    );
                    is($parts->[0]->[1], 'application/octet-stream', 'right type');
                };

                subtest 'simple' => sub {
                    my $ret = render_and_parse(
                        header => { To => 'to@example.com' },
                        body   => ['日本語', { path => $file1 }, { path => $file2 }],
                    );
                    my $exp_name1 = expected_regex(File::Basename::basename($file1));
                    my $exp_name2 = expected_regex(File::Basename::basename($file2));

                    is($ret->[0]->{header}->{To}, 'to@example.com', 'right header');
                    like($ret->[0]->{header}->{'Content-Type'},        qr{multipart/mixed}, 'right header');
                    like($ret->[1]->{header}->{'Content-Disposition'}, qr{inline},          'right header');
                    unlike($ret->[1]->{header}->{'Content-Disposition'}, qr{filename=}, 'right header');
                    like($ret->[1]->{header}->{'Content-Transfer-Encoding'}, qr{base64},                'right header');
                    like($ret->[1]->{header}->{'Content-Type'},              qr{text/plain},            'right header');
                    like($ret->[1]->{header}->{'Content-Type'},              qr{charset="?$charsetl"?}, 'right header');
                    unlike($ret->[1]->{header}->{'Content-Type'}, qr{name=}, 'right header');
                    like($ret->[1]->{body},                                  qr{日本語},                     'right body');
                    like($ret->[2]->{header}->{'Content-Disposition'},       qr{attachment},              'right header');
                    like($ret->[2]->{header}->{'Content-Disposition'},       qr{filename="?$exp_name1"?}, 'right header');
                    like($ret->[2]->{header}->{'Content-Type'},              qr{image/gif},               'right header');
                    like($ret->[2]->{header}->{'Content-Transfer-Encoding'}, qr{base64},                  'right header');
                    like($ret->[2]->{body},                                  qr{R0lGODlhk},               'right body');
                    like($ret->[3]->{header}->{'Content-Disposition'},       qr{attachment},              'right header');
                    like($ret->[3]->{header}->{'Content-Disposition'},       qr{filename="?$exp_name2"?}, 'right header');
                    like($ret->[3]->{header}->{'Content-Type'},              qr{image/png},               'right header');
                    like($ret->[3]->{header}->{'Content-Transfer-Encoding'}, qr{base64},                  'right header');
                    like($ret->[3]->{body},                                  qr{iVBORw0KG},               'right body');
                    is(scalar @$ret, 4, 'right number of mime parts');
                };

                subtest 'name and type specified' => sub {
                    my $ret = render_and_parse(
                        header => { To => 'to@example.com' },
                        body   => ['日本語', { path => $file1, name => 'my_file.gif', type => 'image/mygif' }],
                    );
                    my $exp_name = expected_regex('my_file.gif');
                    is($ret->[0]->{header}->{To}, 'to@example.com', 'right header');
                    like($ret->[0]->{header}->{'Content-Type'},        qr{multipart/mixed}, 'right header');
                    like($ret->[1]->{header}->{'Content-Disposition'}, qr{inline},          'right header');
                    unlike($ret->[1]->{header}->{'Content-Disposition'}, qr{filename=}, 'right header');
                    like($ret->[1]->{header}->{'Content-Transfer-Encoding'}, qr{base64},                 'right header');
                    like($ret->[1]->{body},                                  qr{日本語},                    'right body');
                    like($ret->[2]->{header}->{'Content-Disposition'},       qr{attachment},             'right header');
                    like($ret->[2]->{header}->{'Content-Disposition'},       qr{filename="?$exp_name"?}, 'right header');
                    like($ret->[2]->{header}->{'Content-Type'},              qr{image/mygif},            'right header');
                    like($ret->[2]->{header}->{'Content-Transfer-Encoding'}, qr{base64},                 'right header');
                    like($ret->[2]->{body},                                  qr{R0lGODlhk},              'right body');
                    is(scalar @$ret, 3, 'right number of mime parts');
                };

                subtest 'body given' => sub {
                    my $ret = render_and_parse(
                        header => { To => 'to@example.com' },
                        body   => ['日本語', { body => "ライン1\nライン2", name => 'my_file.log', type => 'text/plain' }],
                    );
                    my $exp_name = expected_regex('my_file.log');

                    is($ret->[0]->{header}->{To}, 'to@example.com', 'right header');
                    like($ret->[0]->{header}->{'Content-Type'},        qr{multipart/mixed}, 'right header');
                    like($ret->[1]->{header}->{'Content-Disposition'}, qr{inline},          'right header');
                    unlike($ret->[1]->{header}->{'Content-Disposition'}, qr{filename=}, 'right header');
                    like($ret->[1]->{header}->{'Content-Transfer-Encoding'}, qr{base64},                 'right header');
                    like($ret->[1]->{body},                                  qr{日本語},                    'right body');
                    like($ret->[2]->{header}->{'Content-Disposition'},       qr{attachment},             'right header');
                    like($ret->[2]->{header}->{'Content-Disposition'},       qr{filename="?$exp_name"?}, 'right header');
                    like($ret->[2]->{header}->{'Content-Type'},              qr{text/plain},             'right header');
                    like($ret->[2]->{header}->{'Content-Transfer-Encoding'}, qr{base64},                 'right header');
                    like($ret->[2]->{body},                                  qr{\Aライン1\nライン2\z},         'right body');
                    is(scalar @$ret, 3, 'right number of mime parts');
                };

                subtest 'multiple part in scalar' => sub {
                    my $ret = render_and_parse(
                        header => { To => 'to@example.com' },
                        body   => ['パート1', 'パート2'],
                    );

                    is($ret->[0]->{header}->{To}, 'to@example.com', 'right header');
                    like($ret->[0]->{header}->{'Content-Type'},        qr{multipart/mixed}, 'right header');
                    like($ret->[1]->{header}->{'Content-Disposition'}, qr{inline},          'right header');
                    unlike($ret->[1]->{header}->{'Content-Disposition'}, qr{filename=}, 'right header');
                    like($ret->[1]->{header}->{'Content-Transfer-Encoding'}, qr{base64},                'right header');
                    like($ret->[1]->{header}->{'Content-Type'},              qr{text/plain},            'right header');
                    like($ret->[1]->{header}->{'Content-Type'},              qr{charset="?$charsetl"?}, 'right header');
                    unlike($ret->[2]->{header}->{'Content-Type'}, qr{name=}, 'right header');
                    like($ret->[1]->{body},                            qr{パート1},       'right body');
                    like($ret->[2]->{header}->{'Content-Disposition'}, qr{attachment}, 'right header');
                    unlike($ret->[2]->{header}->{'Content-Disposition'}, qr{filename=}, 'right header');
                    like($ret->[2]->{header}->{'Content-Transfer-Encoding'}, qr{base64},                'right header');
                    like($ret->[2]->{header}->{'Content-Type'},              qr{text/plain},            'right header');
                    like($ret->[2]->{header}->{'Content-Type'},              qr{charset="?$charsetl"?}, 'right header');
                    unlike($ret->[2]->{header}->{'Content-Type'}, qr{name=}, 'right header');
                    like($ret->[2]->{body}, qr{パート2}, 'right body');
                    is(scalar @$ret, 3, 'right number of mime parts');
                };

                subtest 'part body without name' => sub {
                    my $ret = render_and_parse(
                        header => { To => 'to@example.com' },
                        body   => [{ body => "パート", type => 'text/plain' }],
                    );

                    like($ret->[1]->{header}->{'Content-Disposition'}, qr{attachment}, 'right header');
                    unlike($ret->[1]->{header}->{'Content-Disposition'}, qr{filename=}, 'right header');
                    like($ret->[1]->{header}->{'Content-Type'}, qr{text/plain}, 'right header');
                    unlike($ret->[1]->{header}->{'Content-Type'}, qr{name=}, 'right header');
                    like($ret->[1]->{header}->{'Content-Transfer-Encoding'}, qr{base64}, 'right header');
                    like($ret->[1]->{body},                                  qr{パート},    'right body');
                    is(scalar @$ret, 2, 'right number of mime parts');
                };

                subtest 'falsy string body' => sub {
                    my $ret = render_and_parse(
                        header => { To => 'to@example.com' },
                        body   => [{ body => "0" }],
                    );

                    like($ret->[1]->{header}->{'Content-Disposition'}, qr{attachment}, 'right header');
                    unlike($ret->[1]->{header}->{'Content-Disposition'}, qr{filename=}, 'right header');
                    like($ret->[1]->{header}->{'Content-Type'}, qr{text/plain}, 'right header');
                    unlike($ret->[1]->{header}->{'Content-Type'}, qr{name=}, 'right header');
                    like($ret->[1]->{header}->{'Content-Transfer-Encoding'}, qr{base64}, 'right header');
                    like($ret->[1]->{body},                                  qr{0},      'right body');
                    is(scalar @$ret, 2, 'right number of mime parts');
                };

                subtest 'overwrite charset' => sub {
                    my $ret = render_and_parse(
                        header => { To => 'to@example.com' },
                        body   => [{ body => "あ", charset => 'iso-2022-jp' }],
                    );

                    like($ret->[1]->{header}->{'Content-Type'}, qr{text/plain},              'right header');
                    like($ret->[1]->{header}->{'Content-Type'}, qr{charset="?iso-2022-jp"?}, 'right header');
                    like($ret->[1]->{body},                     qr{あ},                       'right body');
                    is(scalar @$ret, 2, 'right number of mime parts');
                };

                subtest 'non-ascii filename' => sub {
                    my $ret = render_and_parse(
                        header => { To => 'to@example.com' },
                        body   => [{ body => "aaa", name => 'アクセス.log' }],
                    );

                    like($ret->[1]->{header}->{'Content-Type'},        qr{text/plain},             'right header');
                    like($ret->[1]->{header}->{'Content-Disposition'}, expected_regex('アクセス.log'), 'right header');
                    is(scalar @$ret, 2, 'right number of mime parts');
                };
            };
        }
    };
}

sub render_and_parse {
    my $module  = $MT::Util::Mail::Module;
    my $encoded = $module->render(@_);
    note $encoded;
    my $boundary = ($encoded =~ qr{multipart/mixed;\s*boundary="?([^"\x0d\x0a]+)"?})[0];
    my @parts    = split(/[\x0d\x0a]+--$boundary-*[\x0d\x0a]+/m, $encoded);
    my $ret;
    for my $part (@parts) {
        my ($header, $body) = split(/\x0d\x0a\x0d\x0a/, $part, 2);
        my %header_kv;
        $header =~ s{\x0d\x0a\s}{}g;
        for my $hl (split(/\x0d\x0a/, $header)) {
            $hl =~ s{\x0d|\x0a}{}g;
            my ($key, $value) = split(/: /, $hl);
            $header_kv{$key} = $value;
        }
        if ($header_kv{'Content-Type'} =~ qr{text/}) {
            my $cb = {
                'base64'           => sub { MIME::Base64::decode_base64($_[0]) },
                'quoted-printable' => sub { decode_qp($_[0]) },
            }->{ $header_kv{'Content-Transfer-Encoding'} };
            $body = $cb->($body) if $cb;
            my $charset = ($header_kv{'Content-Type'} =~ qr{charset="?([^";]+)"?})[0];
            $body = Encode::decode($charset, $body);
        }
        push @$ret, { header => \%header_kv, body => $body };
    }
    return $ret;
}

sub send_mail_suite {
    my ($data) = @_;
    $mt->config->set('MailTransferEncoding', $data->{xferEnc});
    $mt->config->set('MailEncoding',         $data->{mailEnc});
    subtest $data->{name} => sub {
        my ($headers, $body) = send_mail({ %{ $data->{header} || {} } }, $data->{input});
        my $expected = do {
            my $encoded = Encode::encode($data->{mailEnc} || 'utf8', $data->{input});
            my $cb      = {
                'base64'           => sub { MIME::Base64::encode_base64($_[0]) },
                'quoted-printable' => sub { encode_qp($_[0]) },
            }->{ $headers->{'Content-Transfer-Encoding'}->[0] };
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
    my $charset = $mt->config('MailEncoding');
    my @regex   = map { quotemeta(MIME::EncWords::encode_mimeword(Encode::encode($charset, $_), 'b', $charset)) } @words;
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
