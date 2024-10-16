package MT::Test::MailPitServer;

use strict;
use warnings;
use Test::More ();
use Test::TCP;
use LWP::UserAgent;
use JSON;

my @ServerCandidates = qw(
    /usr/local/bin/mailpit
    /usr/bin/mailpit
);

sub port { shift->{port} }

sub run {
    my ($class, %args) = @_;

    my $mailpit = _find_mailpit()
        or Test::More::plan skip_all => "mailpit not found";

    my $root    = $ENV{MT_TEST_ROOT};
    my $logfile = "$root/.mailpit.log";
    my $cert    = _make_cert($root);

    my $auth_file;
    if ($args{auth}) {
        $auth_file = "$root/.auth";
        open my $fh, '>', $auth_file or die $!;
        for my $user (sort keys %{$args{auth} || {}}) {
            print $fh "$user:$args{auth}{$user}\n";
        }
    }

    Test::More::note "launching MailPit server";
    my $guard = Test::TCP->new(
        code => sub {
            my $port = shift;
            my $ui_port   = $port + 1;
            my $pop3_port = $port + 2;
            exec $mailpit,
                ($ENV{TEST_VERBOSE} ? "-v" : ()),
                "--smtp=0.0.0.0:$port",
                "--listen=0.0.0.0:$ui_port",
                "--pop3=0.0.0.0:$pop3_port",
                "--smtp-tls-cert=$cert",
                "--smtp-tls-key=$cert",
                "--log-file=$logfile",
                "--smtp-disable-rdns",
                ($auth_file ? "--smtp-auth-file=$auth_file" : "--smtp-auth-accept-any"),
                ($args{requires_tls} ? "--smtp-tls-required" : ()),
            ;
            die "Can't execute $mailpit: $!";
        },
    );

    bless {
        guard     => $guard,
        port      => $guard->port,
        ui_port   => $guard->port + 1,
        pop3_port => $guard->port + 2,
        logfile   => $logfile,
    }, $class;
}

sub _find_mailpit {
    for my $candidate (@ServerCandidates) {
        return $candidate if -e $candidate && -x _;
    }
}

sub _make_cert {
    my $root = shift;
    my $dir  = "$root/.priv";
    mkdir $dir unless -d $dir;
    my $file = "$dir/mailpit.pem";
    system(
        qw( openssl req -x509 -nodes -newkey rsa:2048 -days 3650 -subj /C=JP/CN=mt ),
        "-keyout", $file, "-out", $file
    ) and die $?;
    $file;
}

sub slurp_logfile {
    my $self    = shift;
    my $logfile = $self->{logfile} or return;
    open my $fh, '<', $logfile or die "$logfile: $!";
    local $/;
    <$fh>;
}

sub last_sent_mail {
    my $self = shift;
    my $mail = $self->list_messages->[0];
    my $id   = $mail->{ID};
    $self->get_raw_message($id)->decoded_content; 
}

sub last_sent_recipients {
    my $self = shift;
    my $mail = $self->list_messages->[0];
    my @recipients;
    for my $type (qw(To Cc Bcc)) {
        push @recipients, map {$_->{Address}} @{ $mail->{$type} || [] };
    }
    @recipients;
}

sub list_messages {
    my $self = shift;
    my $ui_port = $self->{ui_port};
    my $ua = LWP::UserAgent->new;
    my $res = $ua->get("http://localhost:$ui_port/api/v1/messages");
    unless ($res->is_success) {
        diag $res->status_line;
        return;
    }
    decode_json($res->decoded_content)->{messages};
}

sub delete_messages {
    my $self = shift;
    my $ui_port = $self->{ui_port};
    my $ua = LWP::UserAgent->new;
    $ua->delete("http://localhost:$ui_port/api/v1/messages");
}

sub get_raw_message {
    my ($self, $id) = @_;
    my $ui_port = $self->{ui_port};
    my $ua = LWP::UserAgent->new;
    $ua->get("http://localhost:$ui_port/api/v1/message/$id/raw");
}

sub stop {
    my $self = shift;
    delete $self->{guard};
}

sub test_connection {
    my $self = shift;
    my $ct = 5;
    while($ct--) {
        if (Net::EmptyPort::check_port($self->{ui_port})) {
            my $res = $self->list_messages;
            return 1 if ref $res;
        }
        sleep 1;
    }
    return;
}

1;
