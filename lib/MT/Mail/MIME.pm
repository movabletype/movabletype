# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Mail::MIME;

use strict;
use warnings;

use MT;
use base qw( MT::ErrorHandler );
use Encode;
use Sys::Hostname;
use MT::Util qw(is_valid_email);

sub send {
    my $class = shift;
    my ($hdrs_arg, $body) = @_;

    my %hdrs = map { $_ => $hdrs_arg->{$_} } keys %$hdrs_arg;
    for my $h (keys %hdrs) {
        if (ref($hdrs{$h}) eq 'ARRAY') {
            map { y/\n\r/  / } @{ $hdrs{$h} };
        } elsif (!ref($hdrs{$h})) {
            $hdrs{$h} =~ y/\n\r/  /;
        }
    }

    my $mgr = MT->config;

    $hdrs{From} ||= $mgr->EmailAddressMain or return $class->error(MT->translate("System Email Address is not configured."));

    $hdrs{To} = $mgr->DebugEmailAddress if (is_valid_email($mgr->DebugEmailAddress || ''));

    $class->_dedupe_headers(\%hdrs);

    # Sender MUST occur with multi-address from
    $hdrs{Sender} = $hdrs{From}[0] if (ref $hdrs{From} eq 'ARRAY' && scalar(@{ $hdrs{From} }) > 1);

    my $xfer = $mgr->MailTransfer;
    return $class->_send_mt_sendmail(\%hdrs, $body, $mgr) if $xfer eq 'sendmail';
    return $class->_send_mt_smtp(\%hdrs, $body, $mgr)     if $xfer eq 'smtp';
    return $class->_send_mt_debug(\%hdrs, $body, $mgr)    if $xfer eq 'debug';
    return $class->error(MT->translate("Unknown MailTransfer method '[_1]'", $xfer));
}

sub _lc {
    my $field    = shift;
    my $lc_field = lc $field;
    $lc_field =~ s/\-/_/g;
    $lc_field;
}

sub _dedupe_headers {
    my ($class, $hdrs) = @_;

    # dedupe for SendGrid (cf. CLOUD-73)
    my @unique_headers = qw(From Sender Reply-To To Cc Bcc X-SMTPAPI);
    my %canonical_map  = map { _lc($_) => $_ } @unique_headers;
    for my $k (sort { $a cmp $b } keys %$hdrs) {
        my $lc_k    = _lc($k);
        my $canon_k = $canonical_map{$lc_k};
        if ($canon_k && $canon_k ne $k) {
            if ($canon_k =~ /^(?:From|To|Cc|Bcc|Reply-To)$/) {
                my $addr = delete $hdrs->{$k};
                my @addrs =
                      ref $hdrs->{$canon_k} eq 'ARRAY'                     ? @{ $hdrs->{$canon_k} }
                    : defined $hdrs->{$canon_k} && $hdrs->{$canon_k} ne '' ? ($hdrs->{$canon_k})
                    :                                                        ();
                push @addrs, ref $addr eq 'ARRAY' ? @$addr : $addr;
                my %seen;
                $hdrs->{$canon_k} = [grep { !$seen{$_}++ } @addrs];
            } else {
                $hdrs->{$canon_k} = delete $hdrs->{$k};
            }
        }
    }
}

sub _send_mt_debug {
    my $class = shift;
    my ($hdrs, $body, $mgr) = @_;
    my $msg = $class->render(header => $hdrs, body => $body);
    print STDERR $msg;
    1;
}

sub _send_mt_smtp {
    my $class = shift;
    my ($hdrs, $body, $mgr) = @_;

    # SMTP Configuration
    my $host = $mgr->SMTPServer;
    my $user = $mgr->SMTPUser;
    my $pass = $mgr->SMTPPassword;
    my $port = $mgr->SMTPPort || ($mgr->SMTPAuth eq 'ssl' ? 465 : 25);
    my %args = (
        Port    => $port,
        Timeout => $mgr->SMTPTimeout,
        Hello   => hostname() || 'localhost',
        ($MT::DebugMode ? (Debug => 1) : ()),
        doSSL => '',    # must be defined to avoid uuv
    );

    # If SMTP user ID is valid email address, it's more suitable for Sender header.
    $hdrs->{Sender} = $user if $user && $hdrs->{From} ne $user && is_valid_email($user);

    if ($mgr->SMTPAuth) {
        return $class->error(MT->translate("Username and password is required for SMTP authentication.")) if !$user or !$pass;
        require MT::Util::Mail;
        return unless MT::Util::Mail->can_use('Authen::SASL', 'MIME::Base64');
        if ($mgr->SMTPAuth =~ /^(?:starttls|ssl)$/) {
            return unless MT::Util::Mail->can_use('IO::Socket::SSL', 'Net::SSLeay');
            %args = (
                %args,
                doSSL               => $mgr->SMTPAuth,
                SSL_verify_mode     => ($mgr->SSLVerifyNone || $mgr->SMTPSSLVerifyNone) ? 0 : 1,
                SSL_version         => MT->config->SSLVersion || MT->config->SMTPSSLVersion || 'SSLv23:!SSLv3:!SSLv2',
                SSL_verifycn_name   => $host,
                SSL_verifycn_scheme => 'smtp',
            );
            $args{SSL_ca_file} = Mozilla::CA::SSL_ca_file() if (eval { require Mozilla::CA; 1 });
        }
    }
    require Net::SMTPS;

    # bugid: 111227
    # Do not use IO::Socket::INET6 on Windows environment for avoiding an error.
    if ($^O eq 'MSWin32' && $Net::SMTPS::ISA[0] eq 'IO::Socket::INET6') {
        shift @Net::SMTPS::ISA;
        require IO::Socket::INET;
        unshift @Net::SMTPS::ISA, 'IO::Socket::INET';
    }

    # Overwrite the arguments of Net::SMTPS.
    my $smtp_opts = $mgr->SMTPOptions;
    if (ref($smtp_opts) eq 'HASH' && %$smtp_opts) {
        %args = (%args, %$smtp_opts);
    }

    # Make a smtp object
    my $smtp = Net::SMTPS->new($host, %args)
        or return $class->error(MT->translate('Error connecting to SMTP server [_1]:[_2]', $host, $port));

    if ($mgr->SMTPAuth) {
        my $mech = MT->config->SMTPAuthSASLMechanism || do {

            # Disable DIGEST-MD5.
            my $m = $smtp->supports('AUTH', 500, ["Command unknown: 'AUTH'"]) || '';
            $m =~ s/DIGEST-MD5//;
            $m =~ /^\s+$/ ? undef : $m;
        };

        if (!eval { $smtp->auth($user, $pass, $mech) }) {
            return $class->error(MT->translate("Authentication failure: [_1]", $@ ? $@ : scalar $smtp->message));
        }
    }

    $smtp->mail($user) or return $class->smtp_error($smtp);

    for my $h (qw( To Bcc Cc )) {
        next unless defined $hdrs->{$h};
        my $addr = $hdrs->{$h};
        for (ref $addr eq 'ARRAY' ? @$addr : $addr) {
            $smtp->recipient($_) or return $class->smtp_error($smtp);
        }
    }

    delete $hdrs->{Bcc};

    my $msg = $class->render(header => $hdrs, body => $body);
    $smtp->data()         or return $class->smtp_error($smtp);
    $smtp->datasend($msg) or return $class->smtp_error($smtp);
    $smtp->dataend()      or return $class->smtp_error($smtp);
    $smtp->quit           or return $class->smtp_error($smtp);

    1;
}

my $err = MT->translate('An error occured during sending mail');

sub smtp_error {
    my ($class, $smtp) = @_;
    $class->error(join(':', $err, $smtp->message || ()));
}

my @Sendmail = qw( /usr/lib/sendmail /usr/sbin/sendmail /usr/ucblib/sendmail );

sub _send_mt_sendmail {
    my $class = shift;
    my ($hdrs, $body, $mgr) = @_;

    my $sm_loc;
    for my $loc ($mgr->SendMailPath, @Sendmail) {
        next unless $loc;
        $sm_loc = $loc, last if -x $loc && !-d $loc;
    }
    return $class->error(MT->translate("You do not have a valid path to sendmail on your machine. " . "Perhaps you should try using SMTP?")) unless $sm_loc;
    local $SIG{PIPE} = {};
    my $pid = open my $MAIL, '|-';
    local $SIG{ALRM} = sub { CORE::exit() };
    return unless defined $pid;
    if (!$pid) {
        exec $sm_loc, "-oi", "-t", "-f", $hdrs->{From}
            or return $class->error(MT->translate("Exec of sendmail failed: [_1]", "$!"));
    }

    my $msg = $class->render(header => $hdrs, body => $body);
    $msg =~ s{\r\n}{\n}g;
    print $MAIL $msg;
    close $MAIL;
    1;
}

1;
__END__

=head1 NAME

MT::Mail::MIME - Movable Type mail sender base class

=head1 SYNOPSIS

    # use a subclass
    use MT::Mail::MIME::EmailMIME;
    my %head = ( To => 'foo@bar.com', Subject => 'My Subject' );
    my $body = 'This is the body of the message.';
    MT::Mail::MIME::EmailMIME->send(\%head, $body)
        or die MT::Mail::MIME::EmailMIME->errstr;

=head1 DESCRIPTION

I<MT::Mail::MIME> is the Movable Type mail-sending interface. It can send mail
through I<sendmail> (in several different default locations), through SMTP,
or through a debugging interface that writes data to STDERR. You can set the
method of sending mail through the F<mt.cfg> file by changing the value for
the I<MailTransfer> setting to one of the following values: C<sendmail>,
C<smtp>, or C<debug>.

If you are using C<sendmail>, I<MT::Mail::MIME::send> looks for your I<sendmail>
program in any of the following locations: F</usr/lib/sendmail>,
F</usr/sbin/sendmail>, and F</usr/ucblib/sendmail>. If your I<sendmail> is at
a different location, you can set it using the I<SendMailPath> directive.

If you are using C<smtp>, I<MT::Mail::MIME::send> will by default use C<localhost>
as the SMTP server. You can change this by setting the I<SMTPServer>
directive.

=head1 USAGE

=head2 MT::Mail::MIME->send(\%headers, $body)

Sends a mail message with the headers I<\%headers> and the message body
I<$body>.

The keys and values in I<\%headers> are passed directly in to the mail
program or server, so you can use any valid mail header names as keys. If
you need to supply a list of header values, specify the hash value as a
reference to a list of the header values. For example:

    %headers = ( Bcc => [ 'foo@bar.com', 'baz@quux.com' ] );

If you wish the lines in I<$body> to be wrapped, you should do this yourself;
it will not be done by I<send>.

On success, I<send> returns true; on failure, it returns C<undef>, and the
error message is in C<MT::Mail::MIME-E<gt>errstr>.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
