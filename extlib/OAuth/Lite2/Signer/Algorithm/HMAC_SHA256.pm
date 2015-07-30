package OAuth::Lite2::Signer::Algorithm::HMAC_SHA256;

use strict;
use warnings;

use parent 'OAuth::Lite2::Signer::Algorithm';
use Digest::SHA;

sub name { "hmac-sha256" }

sub hash {
    my ($self, $key, $text) = @_;
    Digest::SHA::hmac_sha256($text, $key);
}

=head1 NAME

OAuth::Lite2::Signer::Algorithm::HMAC_SHA256 - hmac-sha256 signature algorithm class

=head1 SYNOPSIS

    my $algorithm = OAuth::Lite2::Signer::Algorithm::HMAC_SHA256->new;
    my $signature = $algorithm->hash($key, $text);

=head1 DESCRIPTION

DEPRECATED. 'hmac-sha256' signature algorithm class.

=head1 METHODS

=head2 new( )

Constructor.

=head2 name

Returns a name of the algorithm, 'hmac-sha256'.

=head2 hash( $key, $text )

Generate signature.

    my $signature = $algorithm->hash($key, $text);

=head1 SEE ALSO

L<OAuth::Lite2::Signer::Algorithm>
L<OAuth::Lite2::Signer::Algorithms>
L<OAuth::Lite2::Signer::Algorithm::HMAC_SHA1>

=head1 AUTHOR

Lyo Kato, E<lt>lyo.kato@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
