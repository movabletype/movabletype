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
    my ($class, $hdrs, $body, $hide_bcc) = @_;

    my $mail_enc = ($hdrs->{'Content-Type'} =~ /charset="(.+)"/)[0];
    $class->encwords($hdrs, $mail_enc);

    # MIME::Lite doesn't allow array ref for unique headers
    my @unique_headers = qw(From Sender Reply-To To Cc Bcc X-SMTPAPI);
    for my $k (@unique_headers) {
        $hdrs->{$k} = join(', ', @{ $hdrs->{$k} }) if ref $hdrs->{$k};
    }

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

    my @recipients = map { split(/, /, $_) } grep { $_ } map { $hdrs->{$_} } (qw( To Bcc Cc ));

    return ($encoded, @recipients);
}

1;
