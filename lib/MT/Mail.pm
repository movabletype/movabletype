# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Mail;

use strict;

use MT;
use base qw( MT::ErrorHandler );
use MT::I18N qw(encode_text);

sub send {
    my $class = shift;
    my($hdrs_arg, $body) = @_;
    my $id = delete $hdrs_arg->{id} if exists $hdrs_arg->{id};

    my %hdrs = map { $_ => $hdrs_arg->{$_} } keys %$hdrs_arg;
    foreach my $h (keys %hdrs) {
        if (ref($hdrs{$h}) eq 'ARRAY') {
            map { y/\n\r/  / } @{$hdrs{$h}};
        } else {
            $hdrs{$h} =~ y/\n\r/  / unless (ref($hdrs{$h}));
        }
    }
    
    my $mgr = MT->config;
    my $xfer = $mgr->MailTransfer;

    my $enc = $mgr->PublishCharset;
    my $mail_enc = uc ($mgr->MailEncoding || $enc);


    $body = encode_text($body, $enc, lc $mail_enc);

    eval "require MIME::EncWords;";
    unless ($@) {
        foreach my $header (keys %hdrs) {
            my $val = $hdrs{$header};

            if (ref $val eq 'ARRAY') {
                foreach (@$val) {
                    if ((lc($mail_enc) ne 'iso-8859-1') || (m/[^[:print:]]/)) {
                        if ($header =~ m/^(From|To|Reply|B?cc)/i) {
                            if (m/^(.+?)\s*(<[^@>]+@[^>]+>)\s*$/) {
                                $_ = MIME::EncWords::encode_mimeword(
                                    encode_text($1, $enc, lc $mail_enc), 'b', lc $mail_enc) . ' ' . $2;
                            }
                        } elsif ($header !~ m/^(Content-Type|Content-Transfer-Encoding|MIME-Version)/i) {
                            $_ = MIME::EncWords::encode_mimeword(
                                    encode_text($_, $enc, lc $mail_enc), 'b', lc $mail_enc);
                        }
                    }
                }
            } else {
                if ((lc($mail_enc) ne 'iso-8859-1') || ($val =~ /[^[:print:]]/)) {
                    if ($header =~ m/^(From|To|Reply|B?cc)/i) {
                        if ($val =~ m/^(.+?)\s*(<[^@>]+@[^>]+>)\s*$/) {
                            $hdrs{$header} = MIME::EncWords::encode_mimeword(
                                    encode_text($1, $enc, lc $mail_enc), 'b', lc $mail_enc) . ' ' . $2;
                        }
                    } elsif ($header !~ m/^(Content-Type|Content-Transfer-Encoding|MIME-Version)/i) {
                        $hdrs{$header} = MIME::EncWords::encode_mimeword(
                            encode_text($val, $enc, lc $mail_enc), 'b', lc $mail_enc);
                    }
                }
            }
        }
    } else {
        $hdrs{Subject} = encode_text($hdrs{Subject}, $enc, lc $mail_enc);
        $hdrs{From} = encode_text($hdrs{From}, $enc, lc $mail_enc);
    }
    $hdrs{'Content-Type'} ||= qq(text/plain; charset=") . lc $mail_enc . q(");
    $hdrs{'Content-Transfer-Encoding'} = ((lc $mail_enc) !~ m/utf-?8/) ? '7bit' : '8bit';
    $hdrs{'MIME-Version'} ||= "1.0";

    return 1 unless
        MT->run_callbacks('mail_filter', args => $hdrs_arg, headers => \%hdrs,
            body => \$body, transfer => \$xfer, id => $id );

    if ($xfer eq 'sendmail') {
        return $class->_send_mt_sendmail(\%hdrs, $body, $mgr);
    } elsif ($xfer eq 'smtp') {
        return $class->_send_mt_smtp(\%hdrs, $body, $mgr);
    } elsif ($xfer eq 'debug') {
        return $class->_send_mt_debug(\%hdrs, $body, $mgr);
    } else {
        return $class->error(MT->translate(
            "Unknown MailTransfer method '[_1]'", $xfer ));
    }
}

use MT::Util qw(is_valid_email);

sub _send_mt_debug {
    my $class = shift;
    my($hdrs, $body, $mgr) = @_;
    $hdrs->{To} = $mgr->DebugEmailAddress 
        if (is_valid_email($mgr->DebugEmailAddress||''));
    for my $key (keys %$hdrs) {
        my @arr = ref($hdrs->{$key}) eq 'ARRAY' ?
            @{ $hdrs->{$key} } : ($hdrs->{$key});
        print STDERR map "$key: $_\n", @arr;
    }
    print STDERR "\n";
    print STDERR $body;
    1;
}

sub _send_mt_smtp {
    my $class = shift;
    my($hdrs, $body, $mgr) = @_;
    eval { require Mail::Sendmail; };
    return $class->error(MT->translate(
        "Sending mail via SMTP requires that your server " .
        "have Mail::Sendmail installed: [_1]", $@ )) if $@;
    my %hdrs = %$hdrs;
    $hdrs{Message} = $body;
    $hdrs{Smtp} = $mgr->SMTPServer;
    for my $h (qw( Cc Bcc )) {
        if ($hdrs{$h}) {
            $hdrs{$h} = join ', ', @{ $hdrs{$h} };
        }
    }
    my $ret = Mail::Sendmail::sendmail(%hdrs);
    $ret or return $class->error(MT->translate(
        "Error sending mail: [_1]", $Mail::Sendmail::error ));
    1;
}

my @Sendmail = qw( /usr/lib/sendmail /usr/sbin/sendmail /usr/ucblib/sendmail );
sub _send_mt_sendmail {
    my $class = shift;
    my($hdrs, $body, $mgr) = @_;
    $hdrs->{To} = $mgr->DebugEmailAddress 
        if (is_valid_email($mgr->DebugEmailAddress||''));
    my $sm_loc;
    for my $loc ($mgr->SendMailPath, @Sendmail) {
        next unless $loc;
        $sm_loc = $loc, last if -x $loc && !-d $loc;
    }
    return $class->error(MT->translate(
        "You do not have a valid path to sendmail on your machine. " .
        "Perhaps you should try using SMTP?" ))
        unless $sm_loc;
    local $SIG{PIPE} = { };
    my $pid = open MAIL, '|-';
    local $SIG{ALRM} = sub { CORE::exit() };
    return unless defined $pid;
    if (!$pid) {
        exec $sm_loc, "-oi", "-t" or
            return $class->error(MT->translate(
                "Exec of sendmail failed: [_1]", "$!" ));
    }
    for my $key (keys %$hdrs) {
        my @arr = ref($hdrs->{$key}) eq 'ARRAY' ?
            @{ $hdrs->{$key} } : ($hdrs->{$key});
        print MAIL map "$key: $_\n", @arr;
    }
    print MAIL "\n";
    print MAIL $body;
    close MAIL;
    1;
}

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
