package Net::OAuth::SignatureMethod::RSA_SHA1;
use warnings;
use strict;
use MIME::Base64;

sub sign {
    my $self = shift;
    my $request = shift;
	my $key = shift || $request->signature_key;
    die '$request->signature_key must be an RSA key object (e.g. Crypt::OpenSSL::RSA) that can sign($text)'
        unless UNIVERSAL::can($key, 'sign');
    return encode_base64($key->sign($request->signature_base_string), "");
}

sub verify {
    my $self = shift;
    my $request = shift;
    my $key = shift || $request->signature_key;
    die 'You must pass an RSA key object (e.g. Crypt::OpenSSL::RSA) that can verify($text,$sig)'
        unless UNIVERSAL::can($key, 'verify');
    return $key->verify($request->signature_base_string, decode_base64($request->signature));
}

=head1 NAME

Net::OAuth::SignatureMethod::RSA_SHA1 - RSA_SHA1 Signature Method for OAuth protocol

=head1 SEE ALSO

L<Net::OAuth>, L<http://oauth.net>

=head1 AUTHOR

Originally by Keith Grennan <kgrennan@cpan.org>

Currently maintained by Robert Rothenberg <rrwo@cpan.org>

=head1 COPYRIGHT & LICENSE

Copyright 2007-2012, 2024-2025 Keith Grennan

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
