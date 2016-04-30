use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
};

use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use MT;
use MT::Mail;
use Test::More;
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
for my $data (@base64_encode_suite) {
    my ( $headers, $body ) = send_mail( {}, $data->{input} );
    is( $body, $data->{expected}, $data->{name} . ' : body' );
    foreach my $key ( keys %{ $data->{headers} } ) {
        like(
            $headers->{$key},
            $data->{headers}{$key},
            $data->{name} . ' : header : ' . $key
        );
    }
}

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
        $headers{$key} = $value;
    }
    $mail_body = join '', <$read>;

    close $read;
    *STDERR = $save_stderr;

    \%headers, $mail_body;
}

done_testing();
