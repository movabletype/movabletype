package OAuth::Lite2::Signer::Algorithm;

use strict;
use warnings;

sub new { bless {}, $_[0] }

sub name {
    die "abstract method";
}

sub hash {
    my ($self, $key, $text) = @_;
    die "abstract method";
}

=head1 NAME

OAuth::Lite2::Signer::Algorithm - signature algorithm base class.

=head1 SYNOPSIS

Imlement child class inheriting this.

    package OAuth::Lite2::Signer::Algorithm::Foo;
    use parent 'OAuth::Lite2::Signer::Algorithm';
    sub hash {
        # override
    }
    1;

And use with 'hash' method interface.

    my $algorithm = OAuth::Lite2::Signer::Algorithm::Foo->new;
    my $signature = $algorithm->hash($key, $text);


=head1 DESCRIPTION

DEPRECATED. signature algorithm base class.

=head1 METHODS

=head2 new( )

Constructor.

=head2 name

Returns a name of the algorithm.

=head2 hash( $key, $text )

Generate signature.

    my $signature = $algorithm->hash($key, $text);

=head1 SEE ALSO

L<OAuth::Lite2::Signer::Algorithms>
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
