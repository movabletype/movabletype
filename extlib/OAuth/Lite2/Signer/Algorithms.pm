package OAuth::Lite2::Signer::Algorithms;

use strict;
use warnings;

#use OAuth::Lite2::Signer::Algorithm::HMAC_SHA1;
use OAuth::Lite2::Signer::Algorithm::HMAC_SHA256;

my %ALGORITHMS;

sub add_algorithm {
    my ($class, $signer) = @_;
    $ALGORITHMS{$signer->name} = $signer;
}

#__PACKAGE__->add_algorithm( OAuth::Lite2::Signer::Algorithm::HMAC_SHA1->new );
__PACKAGE__->add_algorithm( OAuth::Lite2::Signer::Algorithm::HMAC_SHA256->new );

sub get_algorithm {
    my ($class, $name) = @_;
    return $ALGORITHMS{$name};
}

=head1 NAME

OAuth::Lite2::Signer::Algorithms - signature algorithms

=head1 SYNOPSIS

    my $algorithm = OAuth::Lite2::Signer::Algorithms->get_algorithm('hmac-sha256');
    my $signature = $algorithm->hash($key, $text);

=head1 DESCRIPTION

DEPRECATED. algorithm object store for OAuth 2.0 signature.

=head1 METHODS

=head2 add_algorithm( $signer )

Add signer algorithm object. the class should be L<OAuth::Lite2::Signer::Algorithm> or its child.
L<OAuth::Lite2::Signer::Algorithm::HMAC_SHA256> is automatically added by default.

=head2 get_algorithm( $algorithm_name )

Get algorithm object by its name.

    my $algorithm = OAuth::Lite2::Signer::Algorithms->get_algorithm('hmac-sha256');

=head1 SEE ALSO

L<OAuth::Lite2::Signer::Algorithm>
L<OAuth::Lite2::Signer::Algorithm::HMAC_SHA1>
L<OAuth::Lite2::Signer::Algorithm::HMAC_SHA256>

=head1 AUTHOR

Lyo Kato, E<lt>lyo.kato@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut


1;
