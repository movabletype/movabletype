package OAuth::Lite2::Client::Token;

use strict;
use warnings;

use base 'Class::Accessor::Fast';

__PACKAGE__->mk_accessors(qw(
    access_token
    expires_in
    refresh_token
    access_token_secret
    scope
));

=head1 NAME

OAuth::Lite2::Client::Token - Class represents access-token response

=head1 SYNOPSIS

    my $t = $client->get_access_token( ... );
    $t->access_token;
    $t->expires_in;
    $t->refresh_token;
    $t->scope;

=head1 DESCRIPTION

Class represents access-token response

=head1 ACCESSORS

=head2 access_token

The access token issued by the authorization serve

=head2 expires_in

The lifetime in seconds of the access token

=head2 refresh_token

The refresh token, which can be used to obtain new access tokens using the same authorization grant

=head2 scope

The scope of the access token

=head2 access_token_secret

DEPRECATED.

=head1 AUTHOR

Lyo Kato, E<lt>lyo.kato@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
