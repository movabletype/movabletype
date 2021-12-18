use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    plan skip_all => 'not for Win32' if $^O eq 'MSWin32';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
    $ENV{MT_TEST_MAIL} = 1;
}

use MT::Test;
use MT;
use MT::Mail;
use MIME::Base64;

my $mt = MT->new() or die MT->errstr;
$mt->config('MailTransfer', 'debug');

my $max_line_octet = $MT::Mail::MAX_LINE_OCTET;

isa_ok($mt, 'MT');

my @base64_encode_suite = (
    {   name     => 'Not base64 encoded',
        input    => 'a' x $max_line_octet,
        expected => 'a' x $max_line_octet,
        headers  => { 'Content-Transfer-Encoding' => qr/\A\dbit\z/, },
    },
    {   name  => 'Base64 encoded',
        input => 'a' x ( $max_line_octet + 1 ),
        expected =>
            MIME::Base64::encode_base64( 'a' x ( $max_line_octet + 1 ) ),
        headers => { 'Content-Transfer-Encoding' => qr/\Abase64\z/, },
    }
);

subtest 'encode' => sub {
    for my $data (@base64_encode_suite) {
        my ($headers, $body) = send_mail({}, $data->{input});
        is( $body, $data->{expected}, $data->{name} . ' : body' );
        foreach my $key ( sort keys %{ $data->{headers} } ) {
            like(
                $headers->{$key},
                $data->{headers}{$key},
                $data->{name} . ' : header : ' . $key
            );
        }
    }
};

subtest 'encoded words' => sub {
    subtest 'utf-8' => sub {
        $mt->config('MailEncoding', 'utf-8');
        subtest 'single' => sub {
            my ($headers, $body) = send_mail({ To => 'a/b c<t@a.com>' }, 'body text');
            is($headers->{To}, '=?UTF-8?B?YS9iIGM=?= <t@a.com>', 'right to header');
        };
        subtest 'array' => sub {
            my ($headers, $body) = send_mail({ To => ['a/b c<t@a.com>', 'a/b c2<t@a.com>'] }, 'body text');
            is($headers->{To}->[0], '=?UTF-8?B?YS9iIGM=?= <t@a.com>', 'right To header');
            is($headers->{To}->[1], '=?UTF-8?B?YS9iIGMy?= <t@a.com>', 'right To header');
        };
    };
    subtest 'iso-8859-1' => sub {
        $mt->config('MailEncoding', 'iso-8859-1');
        subtest 'single' => sub {
            my ($headers, $body) = send_mail({ To => 'a/b c<t@a.com>' }, 'body text');
            is($headers->{To}, 'a/b c<t@a.com>', 'right to header');
        };
        subtest 'array' => sub {
            my ($headers, $body) = send_mail({ To => ['a/b c<t@a.com>', 'a/b c2<t@a.com>'] }, 'body text');
            is($headers->{To}->[0], 'a/b c<t@a.com>', 'right To header');
            is($headers->{To}->[1], 'a/b c2<t@a.com>', 'right To header');
        };
    };
};

sub send_mail {
    my ( $hdrs_arg, $body ) = @_;
    my ( %headers, $mail_body );

    my $save_stderr = \*STDERR;
    pipe my $read, my $write;
    *STDERR = $write;
    MT::Mail->send( $hdrs_arg, $body );
    close $write;

    while ( ( my $line = <$read> ) ne "\n" ) {
        chomp $line;
        my ( $key, $value ) = split /: /, $line, 2;
        if (exists $headers{$key}) {
            $headers{$key} = [
                (ref $headers{$key}) ? @{$headers{$key}} : $headers{$key},
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
