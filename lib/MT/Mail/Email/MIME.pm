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
    my ($header, $body, $files) = @args{qw(header body files)};
    my $conf = MT->config;
    my $mail_enc = lc($conf->MailEncoding || 'utf-8');
    $header->{'Content-Type'}              ||= qq(text/plain; charset="$mail_enc");
    $header->{'Content-Transfer-Encoding'} = $class->fix_xfer_enc($header->{'Content-Transfer-Encoding'}, $mail_enc, $body);

    my $msg;

    eval {
        if ($files && @$files) {
            my @parts;
            push @parts, Email::MIME->create(
                body_str   => $body,
                attributes => {
                    content_type => 'text/plain',
                    disposition  => 'inline',
                    charset      => $mail_enc,
                    encoding     => $header->{'Content-Transfer-Encoding'},
                },
            );

            for my $file (@$files) {
                my ($name, $type, $body) = $class->prepare_attach_args($file);
                push @parts, Email::MIME->create(
                    attributes => {
                        content_type => $type,
                        disposition  => 'attachment',
                        encoding     => 'base64',
                        filename     => $name,
                    },
                    body => $body,
                );
            }

            $header->{'Content-Type'} = 'multipart/mixed';
            $msg = Email::MIME->create(
                header_str => [%$header],
                parts      => \@parts,
            );
        } else {
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
