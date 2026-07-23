package Net::OAuth::SignatureMethod::PLAINTEXT;
use warnings;
use strict;

sub sign {
    my $self = shift;
    my $request = shift;
    return $request->signature_key;
}

sub verify {
    my $self = shift;
    my $request = shift;
    return $request->signature eq $self->sign($request);
}

=head1 NAME

Net::OAuth::SignatureMethod::PLAINTEXT - PLAINTEXT Signature Method for OAuth protocol

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
