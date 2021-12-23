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

sub MAX_LINE_OCTET { 990 }

my $crlf = "\x0d\x0a";

sub render {
    my ($class, %args) = @_;
    my ($hdrs, $body, $hide_bcc) = map { $args{$_} } (qw(header body hide_bcc));

    my $mail_enc = ($hdrs->{'Content-Type'} =~ /charset="(.+)"/)[0];
    $class->encwords($hdrs, $mail_enc);

    # MIME::Lite doesn't allow array ref for unique headers
    my @unique_headers = qw(From Sender Reply-To To Cc Bcc X-SMTPAPI);
    for my $k (@unique_headers) {
        $hdrs->{$k} = join(', ', @{ $hdrs->{$k} }) if ref $hdrs->{$k};
    }

    my @recipients = map { split(/, /, $_) } grep { $_ } map { $hdrs->{$_} } (qw( To Bcc Cc ));

    delete $hdrs->{Bcc} if $hide_bcc;

    my $msg;

    eval {
        # MIME::Lite suggests direct settting mime-* or content-* fields is dengerous
        my %special_fields;
        map { $special_fields{$_} = delete $hdrs->{$_} if $_ =~ /^(mime\-|content\-)/i } keys(%$hdrs);
        $msg = MIME::Lite->new(%$hdrs, Data => $body);
        $msg->attr($_, $special_fields{$_}) for keys(%special_fields);
    };
    return $class->error(MT->translate('Failed to encode mail' . ($@ ? ':' . $@ : ''))) if $@ || !$msg;

    my $encoded = $msg->as_string;
    $encoded =~ s{\x0d(?!\x0a)|(?<!\x0d)\x0a}{$crlf}g;

    return ($encoded, @recipients);
}

sub encwords {
    my ($class, $hdrs, $mail_enc) = @_;

    return unless ($hdrs->{'Content-Transfer-Encoding'} eq 'base64');

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
                        } elsif ($header !~ m/^(Content-Type|Content-Transfer-Encoding|MIME-Version)/i) {
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
                    } elsif ($header !~ m/^(Content-Type|Content-Transfer-Encoding|MIME-Version)/i) {
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
