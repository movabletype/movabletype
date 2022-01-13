# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Mail::Email::MIME;

use strict;
use warnings;

use MT;
use base qw( MT::Mail::MIME );
use Email::MIME;

my $crlf = "\x0d\x0a";

sub render {
    my ($class, %args) = @_;
    my ($hdrs, $body) = map { $args{$_} } (qw(header body));
    my $conf = MT->config;
    my $mail_enc = lc($conf->MailEncoding || 'utf-8');
    $hdrs->{'Content-Type'}              ||= qq(text/plain; charset="$mail_enc");
    $hdrs->{'Content-Transfer-Encoding'} ||= $conf->MailTransferEncoding || (($mail_enc !~ m/utf-?8/) ? '7bit' : '8bit');
    require MT::I18N::default;
    $body = MT::I18N::default->encode_text_encode($body, undef, $mail_enc);

    my $msg = eval {
        Email::MIME->create(
            header_str => [%$hdrs],
            body_str   => $body,
            attributes => {
                charset  => $mail_enc,
                encoding => $hdrs->{'Content-Transfer-Encoding'},
            },
        );
    };
    return $class->error(MT->translate('Failed to encode mail' . ($@ ? ':' . $@ : ''))) if $@ || !$msg;

    my $encoded = $msg->as_string;
    $encoded =~ s{\x0d(?!\x0a)|(?<!\x0d)\x0a}{$crlf}g;

    return $encoded;
}

1;
