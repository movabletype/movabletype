package OAuth::Lite2::Server::GrantHandler::ServerState;

use strict;
use warnings;

use parent 'OAuth::Lite2::Server::GrantHandler';
use OAuth::Lite2::Server::Error;
use OAuth::Lite2::ParamMethod::AuthHeader;
use Carp ();

sub is_required_client_authentication {
    return 0;
}

sub handle_request {
    my ($self, $dh) = @_;

    my $req = $dh->request;

    my $parser = OAuth::Lite2::ParamMethod::AuthHeader->new;
    my $header_credentials = $parser->basic_credentials($req);
    my $client_id = ($header_credentials->{client_id}) ? $header_credentials->{client_id} : $req->param("client_id");

    # create server_state
    my $server_state = $dh->create_server_state(
        client_id => $client_id,
    );
    Carp::croak "OAuth::Lite2::Server::DataHandler::create_server_state doesn't return OAuth::Lite2::Model::ServerState"
        unless ($server_state
            && $server_state->isa("OAuth::Lite2::Model::ServerState"));

    my $res = {
        server_state    => $server_state->server_state,
        expires_in      => $server_state->expires_in
    };
    return $res;
}

=head1 NAME

OAuth::Lite2::Server::GrantHandler::ServerState - handler for 'server_state' grant_type request

=head1 SYNOPSIS

    my $handler = OAuth::Lite2::Server::GrantHandler::ServerState->new;
    my $res = $handler->handle_request( $data_handler );

=head1 DESCRIPTION

handler for 'server_state' grant_type request.

=head1 METHODS

=head2 handle_request( $req )

See L<OAuth::Lite2::Server::GrantHandler> document.

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
