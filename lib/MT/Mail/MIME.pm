# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Mail::MIME;

use strict;
use warnings;

use MT;
use base qw( MT::Mail );
use Encode;
use Sys::Hostname;
use MT::Util qw(is_valid_email);

our $MAX_LINE_OCTET = 990;

sub MAX_LINE_OCTET { $MAX_LINE_OCTET }

my $crlf = "\x0d\x0a";
my $lf   = "\x0a";

my %SMTPModules = (
    Core     => ['Net::SMTPS', 'MIME::Base64'],
    Auth     => ['Authen::SASL'],
    SSLorTLS => ['IO::Socket::SSL', 'Net::SSLeay'],
);

sub send {
    my $class = shift;
    my ($hdrs_arg, $body) = @_;

    my %hdrs = map { $_ => $hdrs_arg->{$_} } keys %$hdrs_arg;

    my $id       = delete $hdrs{id};
    my $mgr      = MT->config;
    my $xfer     = $mgr->MailTransfer;
    my $mail_enc = lc($mgr->MailEncoding || $mgr->PublishCharset);

    require MT::I18N::default;
    $body = MT::I18N::default->encode_text_encode($body, undef, $mail_enc);
    $body =~ s{\x0d(?!\x0a)|(?<!\x0d)\x0a}{$crlf}g;

    $class->prepare_header(\%hdrs, $mgr, $mail_enc);

    $hdrs{'Content-Transfer-Encoding'} = 'base64' if ($body =~ /^.{@{[$MAX_LINE_OCTET+1]},}/m);

    return 1
        unless MT->run_callbacks(
        'mail_filter',
        args     => $hdrs_arg,
        headers  => \%hdrs,
        body     => \$body,
        transfer => \$xfer,
        ($id ? (id => $id) : ()));

    $hdrs{To} = $mgr->DebugEmailAddress if (is_valid_email($mgr->DebugEmailAddress || ''));

    if ($xfer eq 'sendmail') {
        return $class->_send_mt_sendmail(\%hdrs, $body, $mgr);
    } elsif ($xfer eq 'smtp') {
        return $class->_send_mt_smtp(\%hdrs, $body, $mgr);
    } elsif ($xfer eq 'debug') {
        return $class->_send_mt_debug(\%hdrs, $body, $mgr);
    } else {
        return $class->error(MT->translate("Unknown MailTransfer method '[_1]'", $xfer));
    }
}

sub _send_mt_debug {
    my $class = shift;
    my ($hdrs, $body, $mgr) = @_;
    my ($msg) = $class->_render($hdrs, $body);
    print STDERR $msg;
    1;
}

sub _send_mt_smtp {
    my $class = shift;
    my ($hdrs, $body, $mgr) = @_;

    # SMTP Configuration
    my $host      = $mgr->SMTPServer;
    my $user      = $mgr->SMTPUser;
    my $pass      = $mgr->SMTPPassword;
    my $localhost = hostname() || 'localhost';
    my $port =
          $mgr->SMTPPort          ? $mgr->SMTPPort
        : $mgr->SMTPAuth eq 'ssl' ? 465
        :                           25;
    my ($auth, $tls, $ssl);
    if ($mgr->SMTPAuth) {

        if ('starttls' eq $mgr->SMTPAuth) {
            $tls  = 1;
            $auth = 1;
        } elsif ('ssl' eq $mgr->SMTPAuth) {
            $ssl  = 1;
            $auth = 1;
        } else {
            $auth = 1;
        }
    }
    my $do_ssl          = ($ssl || $tls) ? $mgr->SMTPAuth                                             : '';
    my $ssl_verify_mode = $do_ssl        ? (($mgr->SSLVerifyNone || $mgr->SMTPSSLVerifyNone) ? 0 : 1) : undef;

    return $class->error(MT->translate("Username and password is required for SMTP authentication."))
        if $auth and (!$user or !$pass);

    # Check required modules;
    my @modules = ();
    push @modules, @{ $SMTPModules{Core} };
    push @modules, @{ $SMTPModules{Auth} }     if $auth;
    push @modules, @{ $SMTPModules{SSLorTLS} } if $ssl || $tls;

    $class->can_use(\@modules) or return;

    # bugid: 111227
    # Do not use IO::Socket::INET6 on Windows environment for avoiding an error.
    if ($^O eq 'MSWin32' && $Net::SMTPS::ISA[0] eq 'IO::Socket::INET6') {
        shift @Net::SMTPS::ISA;
        require IO::Socket::INET;
        unshift @Net::SMTPS::ISA, 'IO::Socket::INET';
    }

    my %args = (
        Port    => $port,
        Timeout => $mgr->SMTPTimeout,
        Hello   => $localhost,
        doSSL   => $do_ssl,
        (
            $do_ssl
            ? (
                SSL_verify_mode => $ssl_verify_mode,
                SSL_version     => MT->config->SSLVersion || MT->config->SMTPSSLVersion || 'SSLv23:!SSLv3:!SSLv2',
                (eval { require Mozilla::CA; 1 })
                ? (SSL_ca_file => Mozilla::CA::SSL_ca_file())
                : (),
                SSL_verifycn_name   => $host,
                SSL_verifycn_scheme => 'smtp'
                )
            : ()
        ),
        ($MT::DebugMode ? (Debug => 1) : ()),
    );

    # Overwrite the arguments of Net::SMTPS.
    my $smtp_opts = $mgr->SMTPOptions;
    if (ref($smtp_opts) eq 'HASH' && %$smtp_opts) {
        %args = (%args, %$smtp_opts);
    }

    # Make a smtp object
    my $smtp = Net::SMTPS->new($host, %args)
        or return $class->error(MT->translate('Error connecting to SMTP server [_1]:[_2]', $host, $port));

    if ($auth) {
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

    # Set sender header if smtp user id is valid email
    $hdrs->{Sender} = $user if MT::Util::is_valid_email($user);

    $class->_dedupe_headers($hdrs);

    # Sending mail (XXX: better to use sender as ->mail only takes a scalar?)
    $smtp->mail(ref $hdrs->{From} eq 'ARRAY' ? $hdrs->{From}[0] : $hdrs->{From});

    my ($msg, @recipients) = $class->_render($hdrs, $body, 'hide_bcc');

    $smtp->recipient($_) for @recipients;

    my $_check_smtp_err = sub {

        # Net::SMTP::TLS is does'nt work "$smtp->status()" and "$smtp->message()"
        return unless $smtp->can('status');

        # status 4xx or 5xx is not send message.
        die scalar $smtp->message() if $smtp->status() =~ /^[45]$/;
    };

    eval {
        $smtp->data();
        $smtp->datasend($msg);
        $_check_smtp_err->();
        $smtp->dataend();
        $smtp->quit;
    };
    if ($@) {
        return $class->error($@);
    }
    1;
}

sub _lc {
    my $field    = shift;
    my $lc_field = lc $field;
    $lc_field =~ s/\-/_/g;
    $lc_field;
}

sub _dedupe_headers {
    my ($class, $hdrs) = @_;

    $class->SUPER::_dedupe_headers($hdrs);

    # MIME::Lite doesn't allow array ref for unique headers
    my @unique_headers = qw(From Sender Reply-To To Cc Bcc X-SMTPAPI);
    for my $k (@unique_headers) {
        $hdrs->{$k} = join(', ', @{$hdrs->{$k}}) if ref $hdrs->{$k};
    }
}

sub _render {
    my ($class, $hdrs, $body, $hide_bcc) = @_;

    require MIME::Lite;
    my $msg;
    eval {
        # MIME::Lite suggests direct settting mime-* or content-* fields is dengerous
        my %special_fields;
        map { $special_fields{$_} = delete $hdrs->{$_} if $_ =~ /^(mime\-|content\-)/i } keys(%$hdrs);
        $msg = MIME::Lite->new(%$hdrs, Data => $body);
        $msg->attr($_, $special_fields{$_}) for keys(%special_fields);
    };
    return $class->error(MT->translate('Failed to encode mail'. ($@ ? ':'. $@ : ''))) if $@ || !$msg;

    my $encoded = $msg->as_string;
    $encoded =~ s{\x0d(?!\x0a)|(?<!\x0d)\x0a}{$crlf}g;

    my @recipients = map { split(/, /, $_) } map { $hdrs->{$_} } (qw( To Bcc Cc ));

    return ($encoded, @recipients);
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

    $class->_dedupe_headers($hdrs);

    my ($msg) = $class->_render($hdrs, $body);
    $msg  =~ s{$crlf}{$lf}g;
    print $MAIL $msg;
    close $MAIL;
    1;
}

1;
__END__

=head1 NAME

MT::Mail::MIME - Movable Type mail sender

=head1 SYNOPSIS

    use MT::Mail::MIME;
    my %head = ( To => 'foo@bar.com', Subject => 'My Subject' );
    my $body = 'This is the body of the message.';
    MT::Mail->send(\%head, $body)
        or die MT::Mail->errstr;

=head1 DESCRIPTION

I<MT::Mail> is the Movable Type mail-sending interface. It can send mail
through I<sendmail> (in several different default locations), through SMTP,
or through a debugging interface that writes data to STDERR. You can set the
method of sending mail through the F<mt.cfg> file by changing the value for
the I<MailTransfer> setting to one of the following values: C<sendmail>,
C<smtp>, or C<debug>.

If you are using C<sendmail>, I<MT::Mail::send> looks for your I<sendmail>
program in any of the following locations: F</usr/lib/sendmail>,
F</usr/sbin/sendmail>, and F</usr/ucblib/sendmail>. If your I<sendmail> is at
a different location, you can set it using the I<SendMailPath> directive.

If you are using C<smtp>, I<MT::Mail::send> will by default use C<localhost>
as the SMTP server. You can change this by setting the I<SMTPServer>
directive.

=head1 USAGE

=head2 MT::Mail->send(\%headers, $body)

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
error message is in C<MT::Mail-E<gt>errstr>.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
