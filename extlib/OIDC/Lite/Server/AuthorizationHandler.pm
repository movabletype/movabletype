package OIDC::Lite::Server::AuthorizationHandler;
use strict;
use warnings;

use Params::Validate;
use OAuth::Lite2::Server::Error;

my @DEFINED_DISPLAY_PARAMS = qw(
    page
    popup
    touch
    wap
);

my @DEFINED_PROMPT_PARAMS = qw(
    none
    login
    consent
    select_account
);

sub new {
    my $class = shift;
    my %args = Params::Validate::validate(@_, {
        data_handler => 1,
        response_types => 1,
    });

    my $self = bless {
        data_handler   => $args{data_handler},
        response_types   => $args{response_types},
    }, $class;
    return $self;
}

sub handle_request {
    my ($self) = @_;
    my $dh = $self->{data_handler};
    my $req = $self->{data_handler}->request;

    # response_type
    my $allowed_response_type = $self->{response_types};
    my $response_type = $req->param("response_type")
        or OAuth::Lite2::Server::Error::InvalidRequest->throw(
            description => "'response_type' not found"
        );

    my @response_type_for_sort = split(/\s/, $response_type);
    @response_type_for_sort = sort @response_type_for_sort;
    $response_type = join(' ', @response_type_for_sort);

    my %allowed_response_type_hash;
    $allowed_response_type_hash{$_}++ foreach @$allowed_response_type;
    OAuth::Lite2::Server::Error::InvalidRequest->throw(
        description => "'response_type' not allowed"
    ) unless (exists $allowed_response_type_hash{$response_type});
 
    # client_id
    my $client_id = $req->param("client_id")
        or OAuth::Lite2::Server::Error::InvalidClient->throw(
            description => "'client_id' not found"
        );

    OAuth::Lite2::Server::Error::InvalidClient->throw
        unless ($dh->validate_client_by_id($client_id));

    OAuth::Lite2::Server::Error::InvalidRequest->throw(
        description => "'response_type' not allowed for this 'client_id'"
    ) unless ($dh->validate_client_for_authorization($client_id, $response_type));

    # redirect_uri
    my $redirect_uri = $req->param("redirect_uri")
        or OAuth::Lite2::Server::Error::InvalidRequest->throw(
            description => "'redirect_uri' not found"
        );
    
    OAuth::Lite2::Server::Error::InvalidRequest->throw(
        description => "'redirect_uri' is invalid"
    ) unless ($dh->validate_redirect_uri($client_id, $redirect_uri));

    # sever_state
    # validate server_state for CSRF Protection
    my $server_state = $req->param("server_state");
    if ( $server_state ) {
        OAuth::Lite2::Server::Error::InvalidServerState->throw(
            description => "'server_state' is invalid"
        ) unless $dh->validate_server_state($server_state, $client_id);
    }

    # scope
    my $scope = $req->param("scope");
    OAuth::Lite2::Server::Error::InvalidScope->throw
        unless ($dh->validate_scope($client_id, $scope));

    # scope and server_state
    OAuth::Lite2::Server::Error::InvalidRequest->throw(
        description => "This scope requires 'server_state'"
    ) unless ($server_state || !$dh->require_server_state($scope));

    ## optional parameters
    # nonce
    my $nonce = $req->param("nonce");
    if ( $response_type ne "token" && $response_type ne "code" && $response_type ne "code token") {
        OAuth::Lite2::Server::Error::InvalidRequest->throw(
            description => "nonce_required"
        ) unless $nonce;
    }

    # display
    my $display = $req->param("display");
    if ( $display ) {
        my %defined_display_hash;
        $defined_display_hash{$_}++ foreach @DEFINED_DISPLAY_PARAMS;
        OAuth::Lite2::Server::Error::InvalidRequest->throw(
            description => "'display' is invalid"
        ) unless ( exists $defined_display_hash{$display} && $dh->validate_display($display));
    }

    # prompt
    my $prompt = $req->param("prompt");
    if ( $prompt ) {
        my %defined_prompt_hash;
        $defined_prompt_hash{$_}++ foreach @DEFINED_PROMPT_PARAMS;
        OAuth::Lite2::Server::Error::InvalidRequest->throw(
            description => "'prompt' is invalid"
        ) unless ( exists $defined_prompt_hash{$prompt} && $dh->validate_prompt($prompt));
    }

    # max_age
    OAuth::Lite2::Server::Error::InvalidRequest->throw(
        description => "'max_age' is invalid"
    ) unless ($dh->validate_max_age($req->parameters()));

    # ui_locales
    my $ui_locales = $req->param("ui_locales");
    OAuth::Lite2::Server::Error::InvalidRequest->throw(
        description => "'ui_locales' is invalid"
    ) unless ($dh->validate_ui_locales($ui_locales));

    # claims_locales
    my $claims_locales = $req->param("claims_locales");
    OAuth::Lite2::Server::Error::InvalidRequest->throw(
        description => "'claims_locales' is invalid"
    ) unless ($dh->validate_claims_locales($claims_locales));

    # id_token_hint
    my $id_token_hint = $req->param("id_token_hint");
    OAuth::Lite2::Server::Error::InvalidRequest->throw(
        description => "'id_token_hint' is invalid"
    ) unless ($dh->validate_id_token_hint($req->parameters));

    # login_hint
    my $login_hint = $req->param("login_hint");
    OAuth::Lite2::Server::Error::InvalidRequest->throw(
        description => "'login_hint' is invalid"
    ) unless ($dh->validate_login_hint($req->parameters));

    # acr_values
    my $acr_values = $req->param("acr_values");
    OAuth::Lite2::Server::Error::InvalidRequest->throw(
        description => "'acr_values' is invalid"
    ) unless ($dh->validate_acr_values($req->parameters()));

    # request
    OAuth::Lite2::Server::Error::InvalidRequest->throw(
        description => "'request' is invalid"
    ) unless ($dh->validate_request($req->parameters()));

    # request_uri
    OAuth::Lite2::Server::Error::InvalidRequest->throw(
        description => "'request_uri' is invalid"
    ) unless ($dh->validate_request_uri($req->parameters()));

}

sub allow {
    my ($self) = @_;
    my $dh = $self->{data_handler};
    my $req = $self->{data_handler}->request;

    my @response_type_for_sort = split(/\s/, $req->param("response_type"));
    @response_type_for_sort = sort @response_type_for_sort;
    my $response_type = join(' ', @response_type_for_sort);
    my $client_id = $req->param("client_id");
    my $user_id = $dh->get_user_id_for_authorization();
    my $scope = $req->param("scope");

    # create id_token
    my $id_token = $dh->create_id_token();

    # create authInfo
    my $auth_info = $dh->create_or_update_auth_info(
                        client_id       => $client_id,
                        user_id         => $user_id,
                        scope           => $scope,
                        id_token        => $id_token->get_token_string(),
    );

    # create Access Token
    my $access_token;
    if (
        $response_type eq 'token' ||
        $response_type eq 'code token' ||
        $response_type eq 'id_token token' ||
        $response_type eq 'code id_token token')
    {
        $access_token = $dh->create_or_update_access_token(
                        auth_info => $auth_info,
        );
    }
  
    my $params = {};
    # state
    $params->{state} = $req->param("state") if($req->param("state"));
 
    # access token
    if($access_token){
        $id_token->access_token_hash($access_token->token);
        $params->{access_token} = $access_token->token; 
        $params->{token_type} = q{Bearer}; 
        $params->{expires_in} = $access_token->expires_in if($access_token->expires_in);
    }

    # authorization code
    if (
        $response_type eq 'code' ||
        $response_type eq 'code token' ||
        $response_type eq 'code id_token' ||
        $response_type eq 'code id_token token')
    {
        $params->{code} = $auth_info->code;
        $id_token->code_hash($auth_info->code);
    }

    # id_token
    $params->{id_token} = $id_token->get_token_string()
        if (
            $response_type eq 'id_token' ||
            $response_type eq 'code id_token' ||
            $response_type eq 'id_token token' ||
            $response_type eq 'code id_token token'
        );

    # build response
    my $res = {
        redirect_uri => $req->param("redirect_uri"),
    };

    # set data to query or fragment
    if($response_type eq 'code'){
        $res->{query} = $params;
    }else{
        $res->{fragment} = $params;
    }
    return $res;
}

sub deny {
    my ($self) = @_;
    my $dh = $self->{data_handler};
    my $req = $self->{data_handler}->request;

    my @response_type_for_sort = split(/\s/, $req->param("response_type"));
    @response_type_for_sort = sort @response_type_for_sort;
    my $response_type = join(' ', @response_type_for_sort);

    my $params = {
        error => q{access_denied},
    };
    
    $params->{state} = $req->param("state")
        if($req->param("state"));

    my $res = {
        redirect_uri => $req->param("redirect_uri"),
    };

    # build response
    if($response_type eq 'code'){
        $res->{query} = $params;
    }else{
        $res->{fragment} = $params;
    }
    return $res;
}

=head1 NAME

OIDC::Lite::Server::AuthorizationHandler - handler for OpenID Connect Authorization request

=head1 SYNOPSIS

    # At Authorization Endpoint
    my $handler = OIDC::Lite::Server::AuthorizationHandler->new;
    $handler->handle_request();

    # after user agreement
    my $res;
    if($allowed){
        $res = $handler->allow();        
    }else{
        $res = $handler->deny();
    }
    ...

=head1 DESCRIPTION

handler for OpenID Connect authorization request.

=head1 METHODS

=head2 handle_request( $req )

Processes authorization request.
If there is error, L<OAuth::Lite2::Server::Error> object is thrown.

=head2 allow( $req )

Returns authorization response params.

=head2 deny( $req )

Returns authorization error response params.

=head1 AUTHOR

Ryo Ito, E<lt>ritou.06@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Ryo Ito

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
