package Net::OAuth::SignatureMethod::HMAC_SHA1;
use warnings;
use strict;
use Digest::HMAC_SHA1;
use MIME::Base64;

sub sign {
    my $self = shift;
    my $request = shift;
    my $hmac = Digest::HMAC_SHA1->new($request->signature_key);
    $hmac->add($request->signature_base_string);
    return encode_base64($hmac->digest, '');
}

sub verify {
    my $self = shift;
    my $request = shift;
    return $request->signature eq $self->sign($request);
}

=head1 NAME

Net::OAuth::SignatureMethod::HMAC_SHA1 - HMAC_SHA1 Signature Method for OAuth protocol

=head1 SEE ALSO

L<Net::OAuth>, L<http://oauth.net>

=head1 AUTHOR

Keith Grennan, C<< <kgrennan at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2007 Keith Grennan, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;