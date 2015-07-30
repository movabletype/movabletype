package OAuth::Lite2::Server::DataHandler;

use strict;
use warnings;

use Params::Validate;
use OAuth::Lite2::Server::Error;

sub new {
    my ($class, %args) = @_;
    my $self = bless { request => undef, %args }, $class;
    $self->init;
    $self;
}

sub request {
    my $self = shift;
    return $self->{request};
}

sub init {
    my $self = shift;
    # template method
}

sub validate_client {
    my ($self, $client_id, $client_secret, $grant_type) = @_;
    die "abstract method";
}

sub get_user_id {
    my ($self, $username, $password) = @_;
    die "abstract method";
}

sub create_or_update_auth_info {
    my ($self, %args) = @_;
    Params::Validate::validate(@_, {
        client_id   => 1,
        user_id     => 1,
        scope       => { optional => 1 },
    });
    die "abstract method";
}

sub create_or_update_access_token {
    my ($self, %args) = @_;
    Params::Validate::validate(@_, {
        auth_info   => 1,
        # secret_type => 1,
    });
    die "abstract method";
}

sub get_auth_info_by_code {
    my ($self, $code) = @_;
    die "abstract method";
}

sub get_auth_info_by_refresh_token {
    my ($self, $refresh_token) = @_;
    die "abstract method";
}

sub get_client_user_id {
    my ($self, $client_id) = @_;
    die "abstract method";
}

sub validate_client_by_id {
    my ($self, $client_id) = @_;
    1;
}

sub validate_user_by_id {
    my ($self, $user_id) = @_;
    1;
}

sub get_access_token {
    my ($self, $token) = @_;
    die "abstract method";
}

sub get_auth_info_by_id {
    my ($self, $id) = @_;
    die "abstract method";
}

sub get_group_id_by_client_id {
    my ($self, $client_id) = @_;
    die "abstract method";
}

sub validate_grouping_scope {
    my ($self, $client_id, $scope) = @_;
    die "abstract method";
}

sub create_server_state {
    my ($self, %args) = @_;
    die "abstract method";
}

sub get_user_id_by_external_assertion{
    my ($self, %args) = @_;
    die "abstract method";
}

=head1 NAME

OAuth::Lite2::Server::DataHandler - Base class that specifies interface for data handler for your service.

=head1 DESCRIPTION

This connects OAuth::Lite2 library to your service.

This specifies an interface to handle data stored in your application. You must
inherit this and implement the subroutines according to the interface contract.

=head1 SYNOPSIS

    package YourDataHandler;
    
    use strict;
    use warnings;

    use parent 'OAuth::Lite2::Server::DataHandler';

=head1 METHODS

=head2 init

This method can be implemented to initialize your subclass.

=head1 INTERFACES

=head2 request

Returns <Plack::Request> object.

=head2 validate_client( $client_id, $client_secret, $grant_type )

This method is used by Token Endpoint. This method will be called all the time,
regardless of the grant_type setting.

This is the place to check if the client_id and client credentials are valid,
as well as checking if the client is allowed to use this grant_type.

If all the checks are successful, return 1. Otherwise return 0.

=head2 get_user_id( $username, $password )

This method is used by Token Endpoint, when requested grant_type is 'password'.

The username and password are provided. You should check if the credentials are
valid or not.

If the checks are successful, return the user's identifier. The user's
identifier is managed by your service.

=head2 create_or_update_auth_info( %params )

Create and save new authorization info.
Should return L<OAuth::Lite2::Model::AuthInfo> object.

=head2 create_or_update_access_token( %params )

Create and save new access token.
Should return L<OAuth::Lite2::Model::AccessToken> object.

=head2 get_auth_info_by_code( $code )

This method is used when the client obtains an access_token using an
authorization-code that was issued by server with user's authorization.

The Web Server Profile requires this interface.

Should return L<OAuth::Lite2::Model::AuthInfo> object.

=head2 get_auth_info_by_refresh_token( $refresh_token )

This method is used when the access_token is refreshed.

Should return L<OAuth::Lite2::Model::AuthInfo> object.

=head2 get_access_token( $token )

This interface is used on a protected resource endpoint.
See L<Plack::Middleware::Auth::OAuth2::ProtectedResource>.

Returns an access token which allows access to the protected attributes.
Should return L<OAuth::Lite2::Model::AccessToken> object.

=head2 get_auth_info_by_id( $auth_id )

This method is used on a protected resource endpoint.
See L<Plack::Middleware::Auth::OAuth2::ProtectedResource>.

This method is called after the get_access_token method. Returns
authorization-info that is related to the $auth_id and access-token.

Should return L<OAuth::Lite2::Model::AuthInfo> object.

=head2 validate_client_by_id( $client_id )

This hook is called on protected resource endpoint.
See L<Plack::Middleware::Auth::OAuth2::ProtectedResource>.

After checking if the token is valid, you can check if the client related the
token is valid in this method.

If the validation of the client_id is successful, return 1. Otherwise return 0.

=head2 validate_user_by_id( $user_id )

This hook is called on protected resource endpoint.
See L<Plack::Middleware::Auth::OAuth2::ProtectedResource>.

After checking if token is valid, you can check if the user related the token
is valid in this method.

If the validation of the user is successful, return 1. Otherwise return 0.

=head2 get_group_id_by_client_id ( $client_id )

If client_id has group_id, return it.

=head2 validate_grouping_scope ( $client_id, $scope )

If scope value is allowed, return 1.

=head2 create_server_state ( $client_id )

Create and save L<OAuth::Lite2::Model::ServerState> object.

=head2 get_user_id_by_external_assertion ( %params )

This method is used by Token Endpoint, when requested grant_type is 'federation-bearer'.

The external service assertion is provided. You should check if the related external service account is valid or not.
If the checks are successful, return the user's identifier. The user's identifier is managed by your service.

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
