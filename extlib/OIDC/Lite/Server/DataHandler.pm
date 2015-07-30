package OIDC::Lite::Server::DataHandler;
use strict;
use warnings;
use parent 'OAuth::Lite2::Server::DataHandler';

sub validate_client_for_authorization {
    my ($self, $client_id, $response_type) = @_;
    die "abstract method";
}

sub validate_redirect_uri {
    my ($self, $client_id, $redirect_uri) = @_;
    die "abstract method";
}

sub validate_scope {
    my ($self, $client_id, $scope) = @_;
    die "abstract method";
}

sub validate_display {
    my ($self, $display) = @_;
    die "abstract method";
}

sub validate_prompt {
    my ($self, $prompt) = @_;
    die "abstract method";
}

sub validate_max_age {
    my ($self, $param) = @_;
    die "abstract method";
}

sub validate_ui_locales {
    my ($self, $ui_locales) = @_;
    die "abstract method";
}

sub validate_claims_locales {
    my ($self, $claims_locales) = @_;
    die "abstract method";
}

sub validate_id_token_hint {
    my ($self, $param) = @_;
    die "abstract method";
}

sub validate_login_hint {
    my ($self, $param) = @_;
    die "abstract method";
}

sub validate_acr_values {
    my ($self, $param) = @_;
    die "abstract method";
}

sub validate_request {
    my ($self, $param) = @_;
    die "abstract method";
}

sub validate_request_uri {
    my ($self, $param) = @_;
    die "abstract method";
}

sub get_user_id_for_authorization {
    my ($self) = @_;
    die "abstract method";
}

sub create_id_token {
    my ($self) = @_;
    die "abstract method";
    # need another param?
}

sub create_or_update_auth_info {
    my ($self, %args) = @_;
    die "abstract method";
}

# Because it is a method added later and optional, this must not die
sub validate_server_state {
    my ($self, $server_state, $client_id) = @_;
    return 0;
}

sub require_server_state {
    my ($self, $scope) = @_;
    return 0;
}

=head1 NAME

OIDC::Lite::Server::DataHandler - Base class that specifies interface for data handler for your service.

=head1 DESCRIPTION

This specifies interface to handle data stored on your application.
You have to inherit this, and implements subroutines according to the interface contract.
This is proxy or adapter that connects OIDC::Lite library to your service.

=head1 SYNOPSIS

    package YourDataHandler;
    
    use strict;
    use warnings;

    use parent 'OIDC::Lite::Server::DataHandler';

    sub validate_scope {
        my ($self, $client_id, $scope) = @_;
        # your logic
        return 1;
    }

=head1 METHODS

=head2 init

If your subclass need some initiation, implement in this method.

=head1 INTERFACES

=head2 request

Returns <Plack::Request> object.

=head2 validate_client_for_authorization( $client_id, $response_type )

Validation of client and allowed response_type.
If it's OK, return 1. Return 0 if not.

=head2 validate_redirect_uri( $client_id, $redirect_uri )

Validation of redirect_uri param.
If it's OK, return 1. Return 0 if not.

=head2 validate_scope( $client_id, $scope )

Validation of scope param.
If it's OK, return 1. Return 0 if not.

=head2 validate_display( $display )

Validation of display param.
If it's OK, return 1. Return 0 if not.

=head2 validate_prompt( $prompt )

Validation of prompt param.
If it's OK, return 1. Return 0 if not.

=head2 validate_max_age( $aram )

Validation of max_age param.
If it's OK, return 1. Return 0 if not.

=head2 validate_ui_locales_( $ui_locales )

Validation of ui_locales param.
If it's OK, return 1. Return 0 if not.

=head2 validate_claims_locales_( $claims_locales )

Validation of claims_locales param.
If it's OK, return 1. Return 0 if not.

=head2 validate_id_token_hint( $param )

Validation of id_token_hint param.
If it's OK, return 1. Return 0 if not.

=head2 validate_login_hint( $param )

Validation of login_hint param.
If it's OK, return 1. Return 0 if not.

=head2 validate_acr_values( $param )

Validation of acr_values param.
If it's OK, return 1. Return 0 if not.

=head2 validate_request( $param )

Validation of request param.
If it's OK, return 1. Return 0 if not.

=head2 validate_request_uri( $param )

Validation of request_uri param.
If it's OK, return 1. Return 0 if not.

=head2 get_user_id_for_authorization()

Return current user_id string.

=head2 create_id_token()

Return OIDC::Lite::Model::IDToken object.

=head2 create_or_update_auth_info(%args) 

Return OIDC::Lite::Model::AuthInfo object.

=head2 validate_server_state($server_state, $client_id)

Return whether server_state is valid or not

=head2 require_server_state($scope)

Return whether scope requires server_state

=head1 AUTHOR

Ryo Ito, E<lt>ritou.06@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Ryo Ito

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
