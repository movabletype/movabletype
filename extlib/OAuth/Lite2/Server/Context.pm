package OAuth::Lite2::Server::Context;

use strict;
use warnings;

use base 'Class::Accessor::Fast';

__PACKAGE__->mk_accessors(qw(request data_handler));

=head1 NAME

OAuth::Lite2::Server::Context - request context object.

=head1 SYNOPSIS

    my $context = OAuth::Lite2::Server::Context->new({
        request      => $req,
        data_handler => YourDataHandler->new,
    });

=head1 DESCRIPTION

request context object.

=head1 METHODS

=head2 request

accessor for current L<Plack::Request> object.

=head2 data_handler

accessor for L<OAuth::Lite2::Server::DataHandler> object.

=head1 SEE ALSO

L<OAuth::Lite2::Server::DataHandler>

=head1 AUTHOR

Lyo Kato, E<lt>lyo.kato@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
