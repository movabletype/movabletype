package OAuth::Lite2::Server::GrantHandler::GroupingRefreshToken;
use strict;
use warnings;
use parent 'OAuth::Lite2::Server::GrantHandler';

use Carp ();
use OAuth::Lite2::Server::Error;
use OAuth::Lite2::ParamMethod::AuthHeader;

sub handle_request {
    my ($self, $dh) = @_;

    my $req = $dh->request;

    my $parser = OAuth::Lite2::ParamMethod::AuthHeader->new;
    my $header_credentials = $parser->basic_credentials($req);
    my $client_id = ($header_credentials->{client_id}) ? $header_credentials->{client_id} : $req->param("client_id");

    # validate grouping refresh_token
    my $refresh_token = $req->param("refresh_token")
        or OAuth::Lite2::Server::Error::InvalidRequest->throw(
            description => "'refresh_token' not found"
        );

    my $grouping_auth_info = $dh->get_auth_info_by_refresh_token($refresh_token)
        or OAuth::Lite2::Server::Error::InvalidGrant->throw(
            description => "'refresh_token' is invalid"
        );
    Carp::croak "OAuth::Lite2::Server::DataHandler::get_auth_info_by_refresh_token doesn't return OAuth::Lite2::Model::AuthInfo"
        unless ($grouping_auth_info
            && $grouping_auth_info->isa("OAuth::Lite2::Model::AuthInfo"));

    my $group_id = $dh->get_group_id_by_client_id( $grouping_auth_info->client_id )
        or OAuth::Lite2::Server::Error::InvalidGrant->throw(
            description => "'refresh_token' does not have group id"
        );

    # validate target client
    my $target_group_id = $dh->get_group_id_by_client_id( $client_id )
        or OAuth::Lite2::Server::Error::InvalidClient->throw(
            description => "'client_id' does not have group id"
        );

    OAuth::Lite2::Server::Error::InvalidRequest->throw(
        description => "group id does not match"
    )   unless  ( $group_id eq $target_group_id );

    my $scope = $req->param("scope");
    OAuth::Lite2::Server::Error::InvalidScope->throw
        unless $dh->validate_grouping_scope( $client_id, $scope );

    # create response 
    my $auth_info =    $dh->create_or_update_auth_info(
                                    client_id       => $client_id,
                                    user_id         => $grouping_auth_info->user_id,
                                    scope           => $scope,
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

OAuth::Lite2::Server::GrantHandler::GroupingRefreshToken - handler for 'grouping-refresh-token' grant_type request

=head1 SYNOPSIS

    my $handler = OAuth::Lite2::Server::GrantHandler::GroupingRefreshToken->new;
    my $res = $handler->handle_request( $data_handler );

=head1 DESCRIPTION

handler for 'grouping-refresh-token' grant_type request.

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
