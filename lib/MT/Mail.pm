# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Mail;

use strict;
use warnings;

use MT;
use base qw( MT::ErrorHandler );
use Encode;
use Sys::Hostname;
our $MAX_LINE_OCTET = 998;

my %SMTPModules = (
    Core     => [ 'Net::SMTPS',      'MIME::Base64' ],
    Auth     => ['Authen::SASL'],
    SSLorTLS => [ 'IO::Socket::SSL', 'Net::SSLeay' ],
);

my %Sent;

sub sent { \%Sent }

sub send {
    my $class = shift;
    my ( $hdrs_arg, $body ) = @_;

    local $hdrs_arg->{id} = $hdrs_arg->{id};
    my $id = delete $hdrs_arg->{id};

    my %hdrs = map { $_ => $hdrs_arg->{$_} } keys %$hdrs_arg;
    foreach my $h ( keys %hdrs ) {
        if ( ref( $hdrs{$h} ) eq 'ARRAY' ) {
            map {y/\n\r/  /} @{ $hdrs{$h} };
        }
        else {
            $hdrs{$h} =~ y/\n\r/  / unless ( ref( $hdrs{$h} ) );
        }
    }
    %Sent = (subject => $hdrs{Subject});

    my $mgr  = MT->config;
    my $xfer = $mgr->MailTransfer;

    my $mail_enc = uc( $mgr->MailEncoding || $mgr->PublishCharset );
    $mail_enc = lc $mail_enc;

    require MT::I18N::default;
    $body = MT::I18N::default->encode_text_encode( $body, undef, $mail_enc );

    eval "require MIME::EncWords;";
    unless ($@) {
        foreach my $header ( keys %hdrs ) {
            my $val = $hdrs{$header};

            if ( ref $val eq 'ARRAY' ) {
                foreach (@$val) {
                    if ( ( $mail_enc ne 'iso-8859-1' ) || (m/[^[:print:]]/) )
                    {
                        if ( $header =~ m/^(From|To|Reply-To|B?cc)/i ) {
                            if (m/^(.+?)\s*(<[^@>]+@[^>]+>)\s*$/) {
                                $_ = MIME::EncWords::encode_mimeword(
                                    MT::I18N::default->encode_text_encode(
                                        $1, undef, $mail_enc
                                    ),
                                    'b',
                                    $mail_enc
                                    )
                                    . ' '
                                    . $2;
                            }
                        }
                        elsif ( $header
                            !~ m/^(Content-Type|Content-Transfer-Encoding|MIME-Version)/i
                            )
                        {
                            $_ = MIME::EncWords::encode_mimeword(
                                MT::I18N::default->encode_text_encode(
                                    $_, undef, $mail_enc
                                ),
                                'b',
                                $mail_enc
                            );
                        }
                    }
                }
            }
            else {
                if (   ( $mail_enc ne 'iso-8859-1' )
                    || ( $val =~ /[^[:print:]]/ ) )
                {
                    if ( $header =~ m/^(From|To|Reply|B?cc)/i ) {
                        if ( $val =~ m/^(.+?)\s*(<[^@>]+@[^>]+>)\s*$/ ) {
                            $hdrs{$header} = MIME::EncWords::encode_mimeword(
                                MT::I18N::default->encode_text_encode(
                                    $1, undef, $mail_enc
                                ),
                                'b',
                                $mail_enc
                                )
                                . ' '
                                . $2;
                        }
                    }
                    elsif ( $header
                        !~ m/^(Content-Type|Content-Transfer-Encoding|MIME-Version)/i
                        )
                    {
                        $hdrs{$header} = MIME::EncWords::encode_mimeword(
                            MT::I18N::default->encode_text_encode(
                                $val, undef, $mail_enc
                            ),
                            'b',
                            $mail_enc
                        );
                    }
                }
            }
        }
    }
    else {
        $hdrs{Subject}
            = MT::I18N::default->encode_text_encode( $hdrs{Subject}, undef,
            $mail_enc );
        $hdrs{From}
            = MT::I18N::default->encode_text_encode( $hdrs{From}, undef,
            $mail_enc );
    }
    $hdrs{'Content-Type'} ||= qq(text/plain; charset=") . $mail_enc . q(");
    $hdrs{'Content-Transfer-Encoding'}
        = ( ($mail_enc) !~ m/utf-?8/ ) ? '7bit' : '8bit';
    $hdrs{'MIME-Version'} ||= "1.0";

    $hdrs{From} = $mgr->EmailAddressMain unless exists $hdrs{From};
    if ( !$hdrs{From} ) {
        return $class->error(
            MT->translate("System Email Address is not configured.") );
    }

    if ( $body =~ /^.{@{[$MAX_LINE_OCTET+1]},}/m
        && eval { require MIME::Base64 } )
    {
        $body = MIME::Base64::encode_base64($body);
        $hdrs{'Content-Transfer-Encoding'} = 'base64';
    }

    return 1
        unless MT->run_callbacks(
        'mail_filter',
        args     => $hdrs_arg,
        headers  => \%hdrs,
        body     => \$body,
        transfer => \$xfer,
        ( $id ? ( id => $id ) : () )
        );

    if ( $xfer eq 'sendmail' ) {
        return $class->_send_mt_sendmail( \%hdrs, $body, $mgr );
    }
    elsif ( $xfer eq 'smtp' ) {
        return $class->_send_mt_smtp( \%hdrs, $body, $mgr );
    }
    elsif ( $xfer eq 'debug' ) {
        return $class->_send_mt_debug( \%hdrs, $body, $mgr );
    }
    else {
        return $class->error(
            MT->translate( "Unknown MailTransfer method '[_1]'", $xfer ) );
    }
}

use MT::Util qw(is_valid_email);

sub _send_mt_debug {
    my $class = shift;
    my ( $hdrs, $body, $mgr ) = @_;
    $hdrs->{To} = $mgr->DebugEmailAddress
        if ( is_valid_email( $mgr->DebugEmailAddress || '' ) );
    for my $key ( keys %$hdrs ) {
        my @arr
            = ref( $hdrs->{$key} ) eq 'ARRAY'
            ? @{ $hdrs->{$key} }
            : ( $hdrs->{$key} );
        print STDERR map "$key: $_\n", @arr;
    }
    print STDERR "\n";
    print STDERR $body;
    1;
}

sub _send_mt_smtp {
    my $class = shift;
    my ( $hdrs, $body, $mgr ) = @_;
    $hdrs->{To} = $mgr->DebugEmailAddress
        if ( is_valid_email( $mgr->DebugEmailAddress || '' ) );

    # SMTP Configuration
    my $host      = $mgr->SMTPServer;
    my $user      = $mgr->SMTPUser;
    my $pass      = $mgr->SMTPPassword;
    my $localhost = hostname() || 'localhost';
    my $port
        = $mgr->SMTPPort          ? $mgr->SMTPPort
        : $mgr->SMTPAuth eq 'ssl' ? 465
        :                           25;
    my ( $auth, $tls, $ssl );
    if ( $mgr->SMTPAuth ) {

        if ( 'starttls' eq $mgr->SMTPAuth ) {
            $tls  = 1;
            $auth = 1;
        }
        elsif ( 'ssl' eq $mgr->SMTPAuth ) {
            $ssl  = 1;
            $auth = 1;
        }
        else {
            $auth = 1;
        }
    }
    my $do_ssl = ( $ssl || $tls ) ? $mgr->SMTPAuth : '';
    my $ssl_verify_mode
        = $do_ssl
        ? ( ( $mgr->SSLVerifyNone || $mgr->SMTPSSLVerifyNone ) ? 0 : 1 )
        : undef;

    return $class->error(
        MT->translate(
            "Username and password is required for SMTP authentication."
        )
        )
        if $auth
        and ( !$user or !$pass );

    # Check required modules;
    my @modules = ();
    push @modules, @{ $SMTPModules{Core} };
    push @modules, @{ $SMTPModules{Auth} } if $auth;
    push @modules, @{ $SMTPModules{SSLorTLS} } if $ssl || $tls;

    $class->can_use( \@modules ) or return;

  # bugid: 111227
  # Do not use IO::Socket::INET6 on Windows environment for avoiding an error.
    if ( $^O eq 'MSWin32' && $Net::SMTPS::ISA[0] eq 'IO::Socket::INET6' ) {
        shift @Net::SMTPS::ISA;
        require IO::Socket::INET;
        unshift @Net::SMTPS::ISA, 'IO::Socket::INET';
    }

    my %args = (
        Port    => $port,
        Timeout => $mgr->SMTPTimeout,
        Hello   => $localhost,
        doSSL   => $do_ssl,
        (   $do_ssl
            ? (
                SSL_verify_mode => $ssl_verify_mode,
                SSL_version => MT->config->SSLVersion
                        || MT->config->SMTPSSLVersion
                        || 'SSLv23:!SSLv3:!SSLv2' ,
                ( eval { require Mozilla::CA; 1 } )
                ? (
                    SSL_ca_file         => Mozilla::CA::SSL_ca_file(),
                    )
                : (),
                SSL_verifycn_name   => $host,
                SSL_verifycn_scheme => 'smtp'
                )
            : ()
        ),
        ( $MT::DebugMode ? ( Debug => 1 ) : () ),
    );

    # Overwrite the arguments of Net::SMTPS.
    my $smtp_opts = $mgr->SMTPOptions;
    if ( ref($smtp_opts) eq 'HASH' && %$smtp_opts ) {
        %args = ( %args, %$smtp_opts );
    }

    # Make a smtp object
    my $smtp = Net::SMTPS->new( $host, %args )
        or return $class->error(
        MT->translate(
            'Error connecting to SMTP server [_1]:[_2]',
            $host, $port
        )
        );

    if ($auth) {
        my $mech = MT->config->SMTPAuthSASLMechanism || do {

            # Disable DIGEST-MD5.
            my $m
                = $smtp->supports( 'AUTH', 500, ["Command unknown: 'AUTH'"] )
                || '';
            $m =~ s/DIGEST-MD5//;
            $m =~ /^\s+$/ ? undef : $m;
        };

        if ( !eval { $smtp->auth( $user, $pass, $mech ) } ) {
            return $class->error(
                MT->translate(
                    "Authentication failure: [_1]",
                    $@ ? $@ : scalar $smtp->message
                )
            );
        }
    }

    # Set sender header if smtp user id is valid email
    $hdrs->{Sender} = $user if MT::Util::is_valid_email($user);

    $class->_dedupe_headers($hdrs);

    # Sending mail (XXX: better to use sender as ->mail only takes a scalar?)
    $smtp->mail( ref $hdrs->{From} eq 'ARRAY' ? $hdrs->{From}[0] : $hdrs->{From} );

    my ($hdr, @recipients) = $class->_render_headers($hdrs, 'hide_bcc');

    $smtp->recipient($_) for @recipients;

    my $_check_smtp_err;
    {
        $_check_smtp_err = sub {

     # Net::SMTP::TLS is does'nt work "$smtp->status()" and "$smtp->message()"
            return unless $smtp->can('status');

            # status 4xx or 5xx is not send message.
            die scalar $smtp->message() if $smtp->status() =~ /^[45]$/;
        };
    }

    eval {
        $smtp->data();
        $smtp->datasend($hdr);
        $_check_smtp_err->();
        $smtp->datasend("\n");
        $smtp->datasend($body);
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
    my $field = shift;
    my $lc_field = lc $field;
    $lc_field =~ s/\-/_/g;
    $lc_field;
}

sub _dedupe_headers {
    my ($class, $hdrs) = @_;

    # dedupe for SendGrid (cf. CLOUD-73)
    my @unique_headers = qw(From Sender Reply-To To Cc Bcc X-SMTPAPI);
    my %canonical_map  = map {_lc($_) => $_} @unique_headers;
    for my $k (sort {$a cmp $b} keys %$hdrs) {
        my $lc_k    = _lc($k);
        my $canon_k = $canonical_map{$lc_k};
        if ($canon_k && $canon_k ne $k) {
            if ($canon_k =~ /^(?:From|To|Cc|Bcc|Reply-To)$/) {
                my $addr = delete $hdrs->{$k};
                my @addrs = ref $hdrs->{$canon_k} eq 'ARRAY' ? @{$hdrs->{$canon_k}} :
                    defined $hdrs->{$canon_k} && $hdrs->{$canon_k} ne '' ? ($hdrs->{$canon_k}) : ();
                push @addrs, ref $addr eq 'ARRAY' ? @$addr : $addr;
                my %seen;
                $hdrs->{$canon_k} = [grep {!$seen{$_}++} @addrs];
            } else {
                $hdrs->{$canon_k} = delete $hdrs->{$k};
            }
        }
    }
}

sub _render_headers {
    my ($class, $hdrs, $hide_bcc) = @_;

    # Setup headers
    my $hdr;
    foreach my $k ( keys %$hdrs ) {
        next if ( $k =~ /^(To|Bcc|Cc)$/ );
        my $value = $hdrs->{$k};
        if (ref $value eq 'ARRAY') {   # From, Reply-To
            $hdr .= "$k: " . join( ",\r\n ", @$value ) . "\r\n";
        } else {
            $hdr .= "$k: " . $value . "\r\n";
        }
    }

    my @recipients;
    foreach my $h (qw( To Bcc Cc )) {
        if ( defined $hdrs->{$h} ) {
            my $addr = $hdrs->{$h};
            $addr = [$addr] unless 'ARRAY' eq ref $addr;
            push @recipients, @$addr;
            $hdr .= "$h: " . join( ",\r\n ", @$addr ) . "\r\n" unless $hide_bcc && $h eq 'Bcc';
        }
    }
    $Sent{recipients} = [@recipients];
    return wantarray ? ($hdr, @recipients) : $hdr;
}

my @Sendmail
    = qw( /usr/lib/sendmail /usr/sbin/sendmail /usr/ucblib/sendmail );

sub _send_mt_sendmail {
    my $class = shift;
    my ( $hdrs, $body, $mgr ) = @_;
    $hdrs->{To} = $mgr->DebugEmailAddress
        if ( is_valid_email( $mgr->DebugEmailAddress || '' ) );
    my $sm_loc;
    for my $loc ( $mgr->SendMailPath, @Sendmail ) {
        next unless $loc;
        $sm_loc = $loc, last if -x $loc && !-d $loc;
    }
    return $class->error(
        MT->translate(
                  "You do not have a valid path to sendmail on your machine. "
                . "Perhaps you should try using SMTP?"
        )
    ) unless $sm_loc;
    local $SIG{PIPE} = {};
    my $pid = open my $MAIL, '|-';
    local $SIG{ALRM} = sub { CORE::exit() };
    return unless defined $pid;
    if ( !$pid ) {
        exec $sm_loc, "-oi", "-t", "-f", $hdrs->{From}
            or return $class->error(
            MT->translate( "Exec of sendmail failed: [_1]", "$!" ) );
    }

    $class->_dedupe_headers($hdrs);

    my $hdr = $class->_render_headers($hdrs);
    $hdr  =~ s{\r\n}{\n}g;

    print $MAIL $hdr;
    print $MAIL "\n";
    print $MAIL $body;
    close $MAIL;
    1;
}

sub can_use {
    my $class = shift;
    my ($mods) = @_;
    return unless $mods;

    my @err;
    for my $module ( @{$mods} ) {
        eval "use $module;";
        push @err, $module
            if $@;
    }

    if (@err) {
        $class->error(
            MT->translate(
                "Following required module(s) were not found: ([_1])",
                ( join ', ', @err )
            )
        );
        return;
    }

    return 1;
}

sub can_use_smtp {
    my $class = shift;
    my @mods;
    push @mods, @{ $SMTPModules{Core} };

    return $class->can_use( \@mods );
}

sub can_use_smtpauth {
    my $class = shift;

    # return if we cannot use smtp modules
    return unless $class->can_use_smtp;

    my @mods;
    push @mods, @{ $SMTPModules{Auth} };
    return $class->can_use( \@mods );
}

sub can_use_smtpauth_ssl {
    my $class = shift;

    # return if we cannot use smtp modules
    return unless $class->can_use_smtp;

    # return if we cannot use smtpauth modules
    return unless $class->can_use_smtpauth;

    my @mods;
    push @mods, @{ $SMTPModules{SSLorTLS} };
    return $class->can_use( \@mods );
}

*can_use_smtpauth_tls = \&can_use_smtpauth_ssl;

1;
__END__

=head1 NAME

MT::Mail - Movable Type mail sender

=head1 SYNOPSIS

    use MT::Mail;
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
