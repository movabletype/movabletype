package MT::Test::AnyEventSMTPServer;

use strict;
use warnings;
use Test::More;
use Test::TCP;
use Test::More;
use MIME::Head;

BEGIN {
    plan skip_all => 'not for Win32' if $^O eq 'MSWin32';
    eval { require AnyEvent::SMTP::Server; 1 }
        or plan skip_all => "requires AnyEvent::SMTP::Server";
}

sub smtp_config {
    my ($class, %env) = @_;
    return (
        MailTransfer      => 'smtp',
        SMTPServer        => 'localhost',
        SMTPAuth          => 0,
        SMTPSSLVerifyNone => 1,
        SMTPOptions       => {Debug => $ENV{TEST_VERBOSE} ? 1 : 0},
        %env,
    );
}

sub new {
    my ( $class, %args ) = @_;

    my $server = Test::TCP->new(
        code => sub {
            my $port = shift;
            my $smtp = AnyEvent::SMTP::Server->new(
                port  => $port,
                debug => 0, # $ENV{TEST_VERBOSE} ? 1 : 0,
                mail_validate => delete $args{mail_validate},
                rcpt_validate => delete $args{rcpt_validate},
                data_validate => delete $args{data_validate} || \&_data_validate,
            );
            $smtp->reg_cb(%args);
            $smtp->start;
            AnyEvent->condvar->recv;
        }
    );
    bless { server => $server }, $class;
}

sub port {
    my $self = shift;
    $self->{server}->port;
}

sub _data_validate {
    my ($stash, $data) = @_;
    my $io = IO::String->new($data);
    my $header = MIME::Head->new;
    $header->read($io);
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
    fail "found perl references" if $data =~ /(?:SCALAR|ARRAY|HASH|CODE)\(/s;
    note $data;
}

sub stop {
    my $self = shift;
    delete $self->{server};
}

1;
