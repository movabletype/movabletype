package OAuth::Lite2::Server::Endpoint::Token;
use strict;
use warnings;
use overload
    q(&{})   => sub { shift->psgi_app },
    fallback => 1;

use Try::Tiny qw/try catch/;
use Plack::Request;
use Params::Validate;
use OAuth::Lite2::Formatters;
use OAuth::Lite2::Server::Error;
use OAuth::Lite2::Server::GrantHandlers;
use OAuth::Lite2::ParamMethod::AuthHeader;

sub new {
    my $class = shift;
    my %args = Params::Validate::validate(@_, {
        data_handler => 1,
        error_uri    => { optional => 1 },
    });
    my $self = bless {
        data_handler   => $args{data_handler},
        error_uri      => $args{error_uri},
        grant_handlers => {},
    }, $class;
    return $self;
}

sub support_grant_type {
    my ($self, $type) = @_;
    my $handler = OAuth::Lite2::Server::GrantHandlers->get_handler($type)
        or OAuth::Lite2::Server::Error::UnsupportedGrantType->throw;
    $self->{grant_handlers}{$type} = $handler;
}

sub support_grant_types {
    my $self = shift;
    $self->support_grant_type($_) for @_;
}

sub data_handler {
    my ($self, $handler) = @_;
    $self->{data_handler} = $handler if $handler;
    $self->{data_handler};
}

sub psgi_app {
    my $self = shift;
    return $self->{psgi_app}
        ||= $self->compile_psgi_app;
}

sub compile_psgi_app {
    my $self = shift;

    my $app = sub {
        my $env = shift;
        my $req = Plack::Request->new($env);
        my $res; try {
            $res = $self->handle_request($req);
        } catch {
            # Internal Server Error
            warn $_;
            $res = $req->new_response(500);
        };
        return $res->finalize;
    };

    return $app;
}

sub handle_request {
    my ($self, $request) = @_;

    # from draft-v8, format is specified to JSON only.
    my $format = "json";
    # my $format = $request->param("format") || "json";
    my $formatter = OAuth::Lite2::Formatters->get_formatter_by_name($format)
        || OAuth::Lite2::Formatters->get_formatter_by_name("json");

    my $res = try {

        my $type = $request->param("grant_type")
            or OAuth::Lite2::Server::Error::InvalidRequest->throw(
                description => q{'grant_type' not found},
            );

        my $handler = $self->{grant_handlers}{$type}
            or OAuth::Lite2::Server::Error::UnsupportedGrantType->throw;

        my $data_handler = $self->{data_handler}->new(request => $request);

        # If Authorization Header is set, it is decoded and overwrite form encoded parameters.
        my $parser = OAuth::Lite2::ParamMethod::AuthHeader->new;
        my $header_credentials = $parser->basic_credentials($request);

        my $client_id = ($header_credentials->{client_id}) ? $header_credentials->{client_id} : $request->param("client_id");
        OAuth::Lite2::Server::Error::InvalidRequest->throw(
            description => q{'client_id' not found},
        )unless($client_id);

        my $client_secret = ($header_credentials->{client_secret}) ? $header_credentials->{client_secret} : $request->param("client_secret");

        # The grant type which are defined in spec require client authentication, 
        # but additional grant type may not.
        if ( $handler->is_required_client_authentication ) {
            OAuth::Lite2::Server::Error::InvalidRequest->throw(
                description => q{'client_secret' not found},
            )unless($client_secret);
        }

        $data_handler->validate_client($client_id, $client_secret, $type)
            or OAuth::Lite2::Server::Error::InvalidClient->throw;

        $handler->{client_id} = $client_id;
        $handler->{client_secret} = $client_secret;
        my $result = $handler->handle_request($data_handler);

        return $request->new_response(200,
            [ "Content-Type"  => $formatter->type,
              "Cache-Control" => "no-store"  ],
            [ $formatter->format($result) ]);

    } catch {

        if ($_->isa("OAuth::Lite2::Server::Error")) {

            my $error_params = { error => $_->type };
            $error_params->{error_description} = $_->description
                if $_->description;
            $error_params->{error_uri} = $self->{error_uri}
                if $self->{error_uri};

            return $request->new_response($_->code,
                [ "Content-Type"  => $formatter->type,
                  "Cache-Control" => "no-store"  ],
                [ $formatter->format($error_params) ]);

        } else {

            die $_;

        }

    };
}

=head1 NAME

OAuth::Lite2::Server::Endpoint::Token - token endpoint PSGI application

=head1 SYNOPSIS

token_endpoint.psgi

    use strict;
    use warnings;
    use Plack::Builder;
    use OAuth::Lite2::Server::Endpoint::Token;
    use MyDataHandlerClass;

    builder {
        my $app = OAuth::Lite2::Server::Endpoint::Token->new(
            data_handler => 'MyDataHandlerClass',
        );
        $app->support_grant_types(qw(authorization_code refresh_token));
        $app;
    };

=head1 DESCRIPTION

The instance of this class behaves as a PSGI application (subroutine reference).
This is for the OAuth 2.0 token-endpoint.

The first thing you need to do is make your custom class, which inherits L<OAuth::Lite2::Server::DataHandler>, and then setup the PSGI file referencing it.

=head1 METHODS

=head2 new( %params )

=over 4

=item data_handler

The name of your custom class that inherits the L<OAuth::Lite2::Server::DataHandler> package.

=item error_uri

Optional. This URI indicates the page that should be presented on an error. This will be included in error responses.

=back

=head2 support_grant_type( $type )

Indicates support for a specific grant type. This does not remove previously supported grant types. The available values are:

=over 4

=item authorization_code

=item password

=item client_credentials

=item refresh_token

=back

=head2 support_grant_types( @types )

Allows specification of multiple grant types at once. This is equivalent to calling support_grant_type once for each type in the list. The available values are:

=over 4

=item authorization_code

=item password

=item client_credentials

=item refresh_token

=back

=head2 data_handler

This returns the class that inherits the L<OAuth::Lite2::Server::DataHandler> package. This is defined by the data_handler parameter of the constructor.

=head2 psgi_app

This returns a PSGI application.

=head2 compile_psgi_app

This will compile the PSGI application.

=head2 handle_request( $req )

This will parse the access token request and call the data handler's method.

=head1 TEST

You can test with L<OAuth::Lite2::Agent::PSGIMock> and some of the client classes.

    my $app = OAuth::Lite2::Server::Endpoint::Token->new(
        data_handler => 'MyDataHandlerClass',
    );
    $app->support_grant_types(qw(authorization_code refresh_token));
    my $mock_agent = OAuth::Lite2::Agent::PSGIMock->new(app => $app);
    my $client = OAuth::Lite2::Client::UsernameAndPassword->new(
        id     => q{my_client_id},
        secret => q{my_client_secret},
        agent  => $mock_agent,
    );
    my $token = $client->get_access_token(
        username => q{foo},
        password => q{bar},
    );
    ok($token);
    is($token->access_token, q{access_token_value});

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
