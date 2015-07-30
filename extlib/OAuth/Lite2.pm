package OAuth::Lite2;

use strict;
use warnings;

our $VERSION = '0.10';

1;
__END__

=head1 NAME

OAuth::Lite2 - OAuth 2.0 Library

=head2 DESCRIPTION

OAuth 2.0 Library

The maintainer of this CPAN module was transferred to ritou by lyokato.
Main repository is L<https://github.com/ritou/p5-oauth-lite2>.

=head2 SEE ALSO

=head3 Client

=over 4

=item L<OAuth::Lite2::Client::WebServer>

=item L<OAuth::Lite2::Client::UsernameAndPassword>

=back

=head3 Server

=over 4

=item L<OAuth::Lite2::Server::Endpoint::Token>

=item L<Plack::Middleware::Auth::OAuth2::ProtectedResource>

=back

=head2 AUTHOR

Ryo Ito, E<lt>ritou.06@gmail.comE<gt>
Lyo Kato, E<lt>lyo.kato@gmail.comE<gt>

=head2 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
