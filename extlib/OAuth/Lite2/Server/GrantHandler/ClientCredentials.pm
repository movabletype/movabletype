package OAuth::Lite2::Server::GrantHandler::ClientCredentials;

use strict;
use warnings;

use parent 'OAuth::Lite2::Server::GrantHandler';
use OAuth::Lite2::Server::Error;
use OAuth::Lite2::ParamMethod::AuthHeader;
use Carp ();

sub handle_request {
    my ($self, $dh) = @_;

    my $req = $dh->request;

    my $parser = OAuth::Lite2::ParamMethod::AuthHeader->new;
    my $header_credentials = $parser->basic_credentials($req);
    my $client_id = ($header_credentials->{client_id}) ? $header_credentials->{client_id} : $req->param("client_id");
    my $client_secret = ($header_credentials->{client_secret}) ? $header_credentials->{client_secret} : $req->param("client_secret");

    my $user_id = $dh->get_client_user_id($client_id, $client_secret);
    OAuth::Lite2::Server::Error::InvalidClient->throw unless defined $user_id;

    my $scope = $req->param("scope");

    my $auth_info = $dh->create_or_update_auth_info(
        client_id => $client_id,
        user_id   => $user_id,
        scope     => $scope,
    );
    Carp::croak "OAuth::Lite2::Server::DataHandler::create_or_update_auth_info doesn't return OAuth::Lite2::Model::AuthInfo"
        unless ($auth_info
            && $auth_info->isa("OAuth::Lite2::Model::AuthInfo"));

    my $access_token = $dh->create_or_update_access_token(
        auth_info => $auth_info,
    );
    Carp::croak "OAuth::Lite2::Server::DataHandler::create_or_update_access_token doesn't return OAuth::Lite2::Model::AccessToken"
        unless ($access_token
            && $access_token->isa("OAuth::Lite2::Model::AccessToken"));

    my $res = {
        token_type => 'Bearer',
        access_token => $access_token->token,
    };
    $res->{expires_in} = $access_token->expires_in
        if $access_token->expires_in;
    $res->{refresh_token} = $auth_info->refresh_token
        if $auth_info->refresh_token;
    $res->{scope} = $auth_info->scope
        if $auth_info->scope;

    return $res;
}

=head1 NAME

OAuth::Lite2::Server::GrantHandler::ClientCredentials - handler for 'client_credentials' grant_type request

=head1 SYNOPSIS

    my $handler = OAuth::Lite2::Server::GrantHandler::ClientCredentials->new;
    my $res = $handler->handle_request( $data_handler );

=head1 DESCRIPTION

handler for 'client_credentials' grant_type request.

=head1 METHODS

=head2 handle_request( $req )

See L<OAuth::Lite2::Server::GrantHandler> document.

=head1 AUTHOR

Lyo Kato, E<lt>lyo.kato@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
