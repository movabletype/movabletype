package OAuth::Lite2::Agent::PSGIMock;

use strict;
use warnings;

use Params::Validate qw(CODEREF);
use HTTP::Response;
use HTTP::Message::PSGI;
use Try::Tiny qw/try catch/;

=head1 NAME

OAuth::Lite2::Agent::PSGIMock - Agent class for test which use PSGI App

=head2 SYNOPSIS

    use Test::More;

    my $endpoint = OAuth::Lite2::Server::Endpoint::Token->new(
        data_handler => 'YourApp::DataHandler',
    );

    my $agent = OAuth::Lite2::Agent::PSGIMock->new( app => $endpoint );

    my $client = OAuth::Lite2::Client::UsernameAndPassword->new(
        client_id     => q{foo},
        client_secret => q{bar},
        agent         => $agent,
    );

    my $res = $client->get_access_token(
        username => q{buz},
        password => q{huga},
        scope    => q{email},
    );

    is($res->access_token, ...);
    is($res->refresh_token, ...);


=head1 DESCRIPTION

This class is useful for test to check if your PSGI based
server application acts as expected.

=head1 METHODS

=head2 new (%args)

parameters

=over 4

=item app (PSGI application)

=back

=cut

sub new {
    my $class = shift;

    my %args = Params::Validate::validate(@_, {
        app => 1,
    });

    my $self = bless {
        app => $args{app},
    }, $class;

    return $self;
}

=head2 request ($req)

handle request with PSIG application you set at constructor

=cut

sub request {
    my ($self, $req) = @_;
    my $res = try {
        HTTP::Response->from_psgi($self->{app}->($req->to_psgi));
    } catch {
        HTTP::Response->from_psgi([500, [ "Content-Type" => "text/plain" ], [ $_ ] ]);
    };
    return $res;
}

1;

=head1 SEE ALSO

L<OAuth::Lite2::Client::Agent>,
L<OAuth::Lite2::Client::Agent::Strict>
L<OAuth::Lite2::Client::Agent::Dump>

=head1 AUTHOR

Lyo Kato, C<lyo.kato _at_ gmail.com>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
