package OIDC::Lite::Server::GrantHandlers;
use strict;
use warnings;

use OIDC::Lite::Server::GrantHandler::AuthorizationCode;
use OAuth::Lite2::Server::GrantHandler::Password;
use OAuth::Lite2::Server::GrantHandler::RefreshToken;
use OAuth::Lite2::Server::GrantHandler::ClientCredentials;
use OAuth::Lite2::Server::GrantHandler::GroupingRefreshToken;
use OAuth::Lite2::Server::GrantHandler::ServerState;

my %HANDLERS;

sub add_handler {
    my ($class, $type, $handler) = @_;
    $HANDLERS{$type} = $handler;
}

__PACKAGE__->add_handler( 'authorization_code' =>
    OIDC::Lite::Server::GrantHandler::AuthorizationCode->new );
__PACKAGE__->add_handler( 'password' =>
    OAuth::Lite2::Server::GrantHandler::Password->new );
__PACKAGE__->add_handler( 'refresh_token' =>
    OAuth::Lite2::Server::GrantHandler::RefreshToken->new );
__PACKAGE__->add_handler( 'client_credentials' =>
    OAuth::Lite2::Server::GrantHandler::ClientCredentials->new );
# Grant types which is not defined in RFC
__PACKAGE__->add_handler( 'grouping_refresh_token' =>
    OAuth::Lite2::Server::GrantHandler::GroupingRefreshToken->new );
__PACKAGE__->add_handler( 'server_state' =>
    OAuth::Lite2::Server::GrantHandler::ServerState->new );
__PACKAGE__->add_handler( 'external_service' =>
    OAuth::Lite2::Server::GrantHandler::ExternalService->new );

#__PACKAGE__->add_handler( 'assertion' => );
#__PACKAGE__->add_handler( 'none' => );

sub get_handler {
    my ($class, $type) = @_;
    return $HANDLERS{$type};
}

=head1 NAME

OIDC::Lite::Server::GrantHandlers - store of handlers for each grant_type.

=head1 SYNOPSIS

    my $handler = OIDC::Lite::Server::GrantHandlers->get_handler( $grant_type );
    $handler->handle_request( $ctx );

=head1 DESCRIPTION

store of handlers for each grant_type.

=head1 METHODS

=head2 add_handler( $grant_type, $handler )

add GrantHandler instance

=head2 get_handler( $grant_type )

get GrantHandler instance

=head1 SEE ALSO

L<OIDC::Lite::Server::GrantHandler>
L<OIDC::Lite::Server::GrantHandler::AuthorizationCode>
L<OAuth::Lite2::Server::GrantHandler::ClientCredentials>
L<OAuth::Lite2::Server::GrantHandler::Password>
L<OAuth::Lite2::Server::GrantHandler::RefreshToken>
L<OAuth::Lite2::Server::GrantHandler::GroupingRefreshToken>
L<OAuth::Lite2::Server::GrantHandler::ServerState>

=head1 AUTHOR

Ryo Ito, E<lt>ritou.06@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Ryo Ito

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;

