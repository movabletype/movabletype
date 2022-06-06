# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Mail::MIME::Lite;

use strict;
use warnings;

use MT;
use base qw( MT::Mail::MIME );
use MIME::Lite;

my $crlf = "\x0d\x0a";

sub render {
    my ($class, %args) = @_;
    my ($header, $body) = @args{qw(header body)};
    my $conf = MT->config;
    my $mail_enc = lc($conf->MailEncoding || 'utf-8');

    $class->encwords($header, $mail_enc);

    # MIME::Lite doesn't allow array ref for unique headers
    my @unique_headers = qw(From Sender Reply-To To Cc Bcc X-SMTPAPI);
    for my $k (@unique_headers) {
        $header->{$k} = join(', ', @{ $header->{$k} }) if ref $header->{$k};
    }

    my $msg;

    eval {
        if (ref($body) eq 'ARRAY') {
            my @parts;
            for my $props (@{$class->prepare_parts($body, $mail_enc)}) {
                my ($disposition, $type, $pbody, $name, $charset) = @$props;
                my $part = MIME::Lite->new(
                    Type        => $type,
                    Data        => $pbody,
                    Encoding    => 'base64',
                    Filename    => $name,
                    Disposition => $disposition,
                ) or die "Error adding an attachment: $!\n";
                $part->attr('content-type.charset' => $charset);
                push @parts, $part;
            }
            $msg = MIME::Lite->new(Type => 'multipart/mixed');
            $msg->attr($_, $header->{$_}) for keys(%$header);
            $msg->attr('Content-Type' => 'multipart/mixed');
            $msg->attach($_) for @parts;
        } else {
            $header->{'Content-Type'} ||= qq(text/plain; charset="$mail_enc");
            $header->{'Content-Transfer-Encoding'} =
                $class->fix_xfer_enc($header->{'Content-Transfer-Encoding'}, $mail_enc, $body);
            require MT::I18N::default;
            $body = MT::I18N::default->encode_text_encode($body, undef, $mail_enc);
            $msg  = MIME::Lite->new(Data => $body);
            $msg->attr($_, $header->{$_}) for keys(%$header);
        }
    };
    return $class->error(MT->translate('Failed to encode mail' . ($@ ? ':' . $@ : ''))) if $@ || !$msg;

    my $encoded = $msg->as_string;
    $encoded =~ s{\x0d(?!\x0a)|(?<!\x0d)\x0a}{$crlf}g;

    return $encoded;
}

sub encwords {
    my ($class, $hdrs, $mail_enc) = @_;

    eval "require MIME::EncWords;";
    unless ($@) {
        foreach my $header (keys %$hdrs) {
            my $val = $hdrs->{$header};

            if (ref $val eq 'ARRAY') {
                foreach (@$val) {
                    if (($mail_enc ne 'iso-8859-1') || (m/[^[:print:]]/)) {
                        if ($header =~ m/^(From|To|Reply-To|B?cc)/i) {
                            if (m/^(.+?)\s*(<[^@>]+@[^>]+>)\s*$/) {
                                $_ = MIME::EncWords::encode_mimeword(
                                    MT::I18N::default->encode_text_encode($1, undef, $mail_enc),
                                    'b',
                                    $mail_enc
                                    )
                                    . ' '
                                    . $2;
                            }
                        } elsif ($header !~ m/^(Content-Type|MIME-Version)/i) {
                            $_ = MIME::EncWords::encode_mimeword(
                                MT::I18N::default->encode_text_encode($_, undef, $mail_enc),
                                'b',
                                $mail_enc
                            );
                        }
                    }
                }
            } else {
                if (($mail_enc ne 'iso-8859-1') || ($val =~ /[^[:print:]]/)) {
                    if ($header =~ m/^(From|To|Reply|B?cc)/i) {
                        if ($val =~ m/^(.+?)\s*(<[^@>]+@[^>]+>)\s*$/) {
                            $hdrs->{$header} = MIME::EncWords::encode_mimeword(
                                MT::I18N::default->encode_text_encode($1, undef, $mail_enc),
                                'b',
                                $mail_enc
                                )
                                . ' '
                                . $2;
                        }
                    } elsif ($header !~ m/^(Content-Type|MIME-Version)/i) {
                        $hdrs->{$header} = MIME::EncWords::encode_mimeword(
                            MT::I18N::default->encode_text_encode($val, undef, $mail_enc),
                            'b',
                            $mail_enc
                        );
                    }
                }
            }
        }
    } else {
        $hdrs->{Subject} = MT::I18N::default->encode_text_encode($hdrs->{Subject}, undef, $mail_enc);
        $hdrs->{From}    = MT::I18N::default->encode_text_encode($hdrs->{From},    undef, $mail_enc);
    }
}

1;
