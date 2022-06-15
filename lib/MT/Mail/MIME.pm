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

my %Sent;

sub sent { \%Sent }

sub send {
    my $class = shift;
    my ($hdrs_arg, $body) = @_;

    my %hdrs = map { $_ => $hdrs_arg->{$_} } keys %$hdrs_arg;
    for my $h (keys %hdrs) {
        unless (defined $hdrs{$h}) {
            $hdrs{$h} = '';
            next;
        }
        if (ref($hdrs{$h}) eq 'ARRAY') {
            map { y/\n\r/  / } @{ $hdrs{$h} };
        } elsif (!ref($hdrs{$h})) {
            $hdrs{$h} =~ y/\n\r/  /;
        }
    }

    %Sent = defined($hdrs{Subject}) ? (subject => $hdrs{Subject}) : ();

    my $conf = MT->config;

    $hdrs{From} ||= $conf->EmailAddressMain or return $class->error(MT->translate("System Email Address is not configured."));

    $hdrs{To} = $conf->DebugEmailAddress if (is_valid_email($conf->DebugEmailAddress || ''));

    $class->_dedupe_headers(\%hdrs);

    # Sender MUST occur with multi-address from
    $hdrs{Sender} = $hdrs{From}[0] if (ref $hdrs{From} eq 'ARRAY' && scalar(@{ $hdrs{From} }) > 1);

    my $xfer = $conf->MailTransfer;
    return $class->_send_mt_sendmail(\%hdrs, $body) if $xfer eq 'sendmail';
    return $class->_send_mt_smtp(\%hdrs, $body)     if $xfer eq 'smtp';
    return $class->_send_mt_debug(\%hdrs, $body)    if $xfer eq 'debug';
    return $class->error(MT->translate("Unknown MailTransfer method '[_1]'", $xfer));
}

sub fix_xfer_enc {
    my ($class, $enc, $charset, $body) = @_;

    my $non_ascii = $body =~ /[^\x00-\x7F]/;

    $enc ||= MT->config->MailTransferEncoding;
    $enc = $enc ? lc($enc) : '';

    if ($enc && $enc !~ /^(?:base64|quoted\-printable|7bit|8bit|binary)$/) {
        $enc = '';
        require MT::Log;
        MT->log({
            message => MT->translate('MailTransferEncoding was auto detected because an invalid value was given.'),
            level   => MT::Log::WARNING(),
        });
    }

    $enc = 'base64' if $charset =~ /utf-?8/i && (!$enc || $enc eq '7bit') && $non_ascii;
    $enc ||= '7bit';

    if ($enc =~ /^(?:8bit|7bit)$/) {
        for my $line (split(/\r\n|\r|\n/, Encode::encode($charset, $body))) {
            use bytes;
            return $non_ascii ? 'base64' : 'quoted-printable' if length($line) > 998;
        }
    }

    return $enc;
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
    my ($hdrs, $body) = @_;
    my $msg = $class->render(header => $hdrs, body => $body);
    print STDERR $msg;
    1;
}

sub _send_mt_smtp {
    my $class = shift;
    my ($hdrs, $body) = @_;
    my $conf = MT->config;

    # SMTP Configuration
    my $host = $conf->SMTPServer;
    my $user = $conf->SMTPUser;
    my $pass = $conf->SMTPPassword;
    my $port = $conf->SMTPPort || ($conf->SMTPAuth eq 'ssl' ? 465 : 25);
    my %args = (
        Port    => $port,
        Timeout => $conf->SMTPTimeout,
        Hello   => hostname() || 'localhost',
        ($MT::DebugMode ? (Debug => 1) : ()),
        doSSL => '',    # must be defined to avoid uuv
    );

    # If SMTP user ID is valid email address, it's more suitable for Sender header.
    $hdrs->{Sender} = $user if $user && $hdrs->{From} ne $user && is_valid_email($user);

    if ($conf->SMTPAuth) {
        return $class->error(MT->translate("Username and password is required for SMTP authentication.")) if !$user or !$pass;
        return unless $class->_can_use('Authen::SASL', 'MIME::Base64');
        if ($conf->SMTPAuth =~ /^(?:starttls|ssl)$/) {
            return unless $class->_can_use('IO::Socket::SSL', 'Net::SSLeay');
            %args = (
                %args,
                doSSL               => $conf->SMTPAuth,
                SSL_verify_mode     => ($conf->SSLVerifyNone || $conf->SMTPSSLVerifyNone) ? 0 : 1,
                SSL_version         => $conf->SSLVersion || $conf->SMTPSSLVersion || 'SSLv23:!SSLv3:!SSLv2',
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
    my $smtp_opts = $conf->SMTPOptions;
    if (ref($smtp_opts) eq 'HASH' && %$smtp_opts) {
        %args = (%args, %$smtp_opts);
    }

    # Make a smtp object
    my $smtp = Net::SMTPS->new($host, %args)
        or return $class->error(MT->translate('Error connecting to SMTP server [_1]:[_2]', $host, $port));

    if ($conf->SMTPAuth) {
        my $mech = $conf->SMTPAuthSASLMechanism || do {

            # Disable DIGEST-MD5.
            my $m = $smtp->supports('AUTH', 500, ["Command unknown: 'AUTH'"]) || '';
            $m =~ s/DIGEST-MD5//;
            $m =~ /^\s+$/ ? undef : $m;
        };

        if (!eval { $smtp->auth($user, $pass, $mech) }) {
            return $class->error(MT->translate("Authentication failure: [_1]", $@ ? $@ : scalar $smtp->message));
        }
    }

    $smtp->mail(ref $hdrs->{From} eq 'ARRAY' ? $hdrs->{From}[0] : $hdrs->{From})
        or return $class->smtp_error($smtp);

    $Sent{recipients} = _recipients($hdrs);
    for (@{$Sent{recipients}}) {
        $smtp->recipient($_) or return $class->smtp_error($smtp);
    }

    delete $hdrs->{Bcc};

    my $msg = $class->render(header => $hdrs, body => $body);
    $smtp->data()         or return $class->smtp_error($smtp);
    $smtp->datasend($msg) or return $class->smtp_error($smtp);
    $smtp->dataend()      or return $class->smtp_error($smtp);
    $smtp->quit           or return $class->smtp_error($smtp);

    1;
}

my $SMTPErrorMessage;

sub smtp_error {
    my ($class, $smtp) = @_;
    $SMTPErrorMessage ||= MT->translate('An error occured during sending mail');
    $class->error(join(':', $SMTPErrorMessage, $smtp->message || ()));
}

my @Sendmail = qw( /usr/lib/sendmail /usr/sbin/sendmail /usr/ucblib/sendmail );

sub _send_mt_sendmail {
    my $class = shift;
    my ($hdrs, $body) = @_;
    my $conf = MT->config;

    my $sm_loc;
    for my $loc ($conf->SendMailPath, @Sendmail) {
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

    $Sent{recipients} = _recipients($hdrs);

    my $msg = $class->render(header => $hdrs, body => $body);
    $msg =~ s{\r\n}{\n}g;
    print $MAIL $msg;
    close $MAIL;
    1;
}

sub _recipients {
    my $hdrs = shift;
    my @ret;
    for my $h (qw( To Bcc Cc )) {
        next unless defined $hdrs->{$h};
        my $addr = $hdrs->{$h};
        push @ret, $_ for (ref $addr eq 'ARRAY' ? @$addr : $addr);
    }
    return \@ret;
}

sub _can_use {
    my ($class, @mods) = @_;

    my @err;
    for my $mod (@mods) {
        eval "use $mod;";
        push @err, $mod if $@;
    }

    if (@err) {
        $class->error(MT->translate("Following required module(s) were not found: ([_1])", (join ', ', @err)));
        return;
    }

    return 1;
}

my $Types;

sub prepare_parts {
    my ($class, $parts, $charset) = @_;
    my @ret;

    require MT::I18N::default;

    for my $part (@$parts) {
        if (ref $part) {
            my ($type, $name, $path, $body, $pcharset) = @{$part}{qw(type name path body charset)};
            $pcharset ||= $charset;
            if (defined $body) {
                $type ||= 'text/plain';
                $body = MT::I18N::default->encode_text_encode($body, undef, $pcharset);
                $name = _encword($name, $pcharset) if $name;
                push @ret, ['attachment', $type, $body, $name, $pcharset];
            } elsif ($path) {
                if (!$Types) {
                    require File::Basename;
                    require MIME::Types;
                    $Types = MIME::Types->new;
                }
                $name ||= File::Basename::basename($path);
                unless ($type) {
                    my $found = $Types->mimeTypeOf($name);
                    $type = $found ? $found->type() : 'application/octet-stream';
                }
                $body = _slurp($path);
                $name = _encword($name, $pcharset);
                push @ret, ['attachment', $type, $body, $name, undef];
            } else {
                require Carp;
                Carp::croak 'Multipart property requires either body or path.';
            }
        } else {
            push @ret, [
                (@ret ? 'attachment' : 'inline'),
                'text/plain',
                MT::I18N::default->encode_text_encode($part, undef, $charset),
                undef,
                $charset,
            ];
        }
    }

    return \@ret;
}

sub _encword {
    my ($word, $charset) = @_;
    if (defined $word && $word =~ /(?:\P{ASCII}|=\?)/s) {
        require MIME::EncWords;
        $word = MIME::EncWords::encode_mimeword(
            MT::I18N::default->encode_text_encode($word, undef, $charset), 'b', $charset);
    }
    return $word;
}

sub _slurp {
    my $path = shift;
    open my $fh, '<', $path or die "$path: $!";
    binmode $fh;
    local $/;
    <$fh>;
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
I<$body>. Optionally, you can attach files if your I<MailModule> supports it.

The keys and values in I<\%headers> are passed directly into the mail
program or server, so you can use any valid mail header names as keys. If
you need to supply a list of header values, specify the hash value as a
reference to a list of the header values. For example:

    %headers = ( Bcc => [ 'foo@bar.com', 'baz@quux.com' ] );

If you wish the lines in I<$body> to be wrapped, you should do this yourself;
it will not be done by I<send>.

You can send multipart mail by giving array ref for $body instead of a scalar.

    $body = [ { path => 'path/to/your.png' }, {...}, ... ];

Each file can also contain types and names in case you don't like the auto
detection.

    push @$body, {
        path => 'path/to/your.png', 
        type => 'image/png', 
        name => 'yourname.png',
    };

You can also set the file body by string.

    push @$body, { body => 'file content' };

Or, you can attach text/plain part by scalar directly to $body.

    push @$body, 'file content';

If the first part of $body is a scalar, it will be treated as inline instead of
attachment.

    $body = ['hello', $file1, $file2, ... ];

On success, I<send> returns true; on failure, it returns C<undef>, and the
error message is in C<MT::Mail::MIME-E<gt>errstr>.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
