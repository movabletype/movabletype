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
    my ($header, $body) = @args{qw(header body)};
    my $conf = MT->config;
    my $mail_enc = lc($conf->MailEncoding || 'utf-8');
 
    my $msg;

    eval {
        if (ref($body) eq 'ARRAY') {
            my @parts;
            for my $props (@{$class->prepare_parts($body, $mail_enc)}) {
                my ($disposition, $type, $pbody, $name, $charset) = @$props;
                push @parts, Email::MIME->create(
                    attributes => {
                        content_type => $type,
                        disposition  => $disposition,
                        encoding     => 'base64',
                        filename     => $name,
                        charset      => $charset,
                    },
                    body => $pbody,
                );
            }

            $header->{'Content-Type'} = 'multipart/mixed';
            $msg = Email::MIME->create(
                header_str => [%$header],
                parts      => \@parts,
            );
        } else {
            $header->{'Content-Type'} ||= qq(text/plain; charset="$mail_enc");
            $header->{'Content-Transfer-Encoding'} =
                $class->fix_xfer_enc($header->{'Content-Transfer-Encoding'}, $mail_enc, $body);
            $msg = Email::MIME->create(
                header_str => [%$header],
                body_str   => $body,
                attributes => {
                    charset  => $mail_enc,
                    encoding => $header->{'Content-Transfer-Encoding'},
                },
            );
        }
    };
    return $class->error(MT->translate('Failed to encode mail' . ($@ ? ':' . $@ : ''))) if $@ || !$msg;

    my $encoded = $msg->as_string;
    $encoded =~ s{\x0d(?!\x0a)|(?<!\x0d)\x0a}{$crlf}g;

    return $encoded;
}

1;
