package OAuth::Lite2::Agent::Dump;

use strict;
use warnings;

use parent 'OAuth::Lite2::Agent';
use Data::Dump qw(dump);

=head1 NAME

OAuth::Lite2::Agent::Dump - Preset User Agent class for debug

=head1 SYNOPSIS

    my $client = OAuth::Lite2::Client::WebApp->new(
        ..., # other params
        agent => OAuth::Lite2::Client::Agent::Dump->new,
    );

=head1 DESCRIPTION

This is useful for debug.

=head1 METHODS

=head2 request ($req)

Append to the behavior of parent class, this method dumps the request and response object.

=cut

sub request {
    my ($self, $req) = @_;
    warn dump($req);
    my $res = $self->SUPER::request($req);
    warn dump($res);
    return $res;
}

1;

=head1 SEE ALSO

L<OAuth::Lite2::Client::Agent>,
L<OAuth::Lite2::Client::Agent::Strict>

=head1 AUTHOR

Lyo Kato, C<lyo.kato _at_ gmail.com>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
