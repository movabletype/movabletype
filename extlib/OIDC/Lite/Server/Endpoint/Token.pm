package OIDC::Lite::Server::Endpoint::Token;
use strict;
use warnings;
use parent 'OAuth::Lite2::Server::Endpoint::Token';
use overload
    q(&{})   => sub { shift->psgi_app },
    fallback => 1;

use OIDC::Lite::Server::GrantHandlers;
use OAuth::Lite2::Server::Error;

sub support_grant_type {
    my ($self, $type) = @_;
    my $handler = OIDC::Lite::Server::GrantHandlers->get_handler($type)
        or OAuth::Lite2::Server::Error::UnsupportedGrantType->throw;
    $self->{grant_handlers}{$type} = $handler;
}

=head1 NAME

OIDC::Lite::Server::Endpoint::Token - token endpoint PSGI application

=head1 SYNOPSIS

token_endpoint.psgi

    use strict;
    use warnings;
    use Plack::Builder;
    use OIDC::Lite::Server::Endpoint::Token;
    use MyDataHandlerClass;

    builder {
        my $app = OIDC::Lite::Server::Endpoint::Token->new(
            data_handler => 'MyDataHandlerClass',
        );
        $app->support_grant_types(qw(authorization_code refresh_token));
        $app;
    };

=head1 DESCRIPTION

The object of this class behaves as PSGI application (subroutine reference).
This is for OpenID Connect token-endpoint.

At first you have to make your custom class inheriting L<OIDC::Lite::Server::DataHandler>,
and setup PSGI file with it.

=head1 METHODS

=head2 new( %params )

=over 4

=item data_handler

name of your custom class that inherits L<OIDC::Lite::Server::DataHandler>
and implements interface.

=item error_uri

Optional. URI that represents error description page.
This would be included in error responses.

=back

=head2 support_grant_type( $type )

You can set 'authorization_code', 'password', 'client_credentials' or 'refresh_token'

=head2 support_grant_types( @types )

You can set 'authorization_code', 'password', 'client_credentials' or 'refresh_token'

=head1 TEST

You can test with L<OAuth::Lite2::Agent::PSGIMock> and some of client classes.

    my $app = OIDC::Lite::Server::Endpoint::Token->new(
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

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Ryo Ito

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
