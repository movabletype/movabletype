use strict;
use warnings;
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
    my $mail_class = MT::Util::Mail->load_class($c);
    subtest $mail_class => sub {

        subtest 'encode' => sub {
            for my $data (base64_encode_suite($mail_class)) {
                my ($headers, $body) = send_mail({ %{ $data->{header_args} } }, $data->{input}, $mail_class);
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
}

sub send_mail {
    my ($hdrs_arg, $body, $mail_class) = @_;
    my (%headers, $mail_body);

    my $save_stderr = \*STDERR;
    pipe my $read, my $write;
    *STDERR = $write;
    $mail_class->send($hdrs_arg, $body);
    close $write;

    while (my $line = <$read>) {
        last if $line =~ /\A(\x0d\x0a|\x0d|\x0a)\z/;
        $line =~ s{\x0d\x0a|\x0d|\x0a}{}g;
        my ($key, $value) = split /: /, $line, 2;
        $headers{$key} = $value;
    }
    $mail_body = join '', <$read>;

    close $read;
    *STDERR = $save_stderr;

    \%headers, $mail_body;
}

done_testing();
