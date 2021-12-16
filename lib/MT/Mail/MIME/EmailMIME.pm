# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Mail::MIME::EmailMIME;

use strict;
use warnings;

use MT;
use base qw( MT::Mail::MIME );
use Email::MIME;

sub MAX_LINE_OCTET { 998 }

my $crlf = "\x0d\x0a";

sub render {
    my ($class, $hdrs, $body, $hide_bcc) = @_;

    my $msg;

    eval {
        $msg = Email::MIME->create(
            header_str => [%$hdrs],
            body_str   => $body,
            attributes => {
                charset  => ($hdrs->{'Content-Type'} =~ /charset="(.+)"/)[0],
                encoding => $hdrs->{'Content-Transfer-Encoding'}
            },
        );
    };
    return $class->error(MT->translate('Failed to encode mail' . ($@ ? ':' . $@ : ''))) if $@ || !$msg;

    my $encoded = $msg->as_string;
    $encoded =~ s{\x0d(?!\x0a)|(?<!\x0d)\x0a}{$crlf}g;

    my @recipients = map { split(/, /, $_) } grep { $_ } map { $hdrs->{$_} } (qw( To Bcc Cc ));

    return ($encoded, @recipients);
}

1;
