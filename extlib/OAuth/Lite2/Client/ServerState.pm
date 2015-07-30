package OAuth::Lite2::Client::ServerState;

use strict;
use warnings;

use base 'Class::Accessor::Fast';

__PACKAGE__->mk_accessors(qw(
    server_state
    expires_in
));

=head1 NAME

OAuth::Lite2::Client::ServerState - Class represents server-state response

=head1 SYNOPSIS

    my $t = $client->get_server_state( ... );
    $t->server_state;
    $t->expires_in;

=head1 DESCRIPTION

Class represents server-state response

=head1 ACCESSORS

=head2 server_state

server_state string

=head2 expires_in

Seconds to expires

=head1 AUTHOR

Ryo Ito, E<lt>ritou.06@gmail.comE<gt>

Lyo Kato, E<lt>lyo.kato@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
