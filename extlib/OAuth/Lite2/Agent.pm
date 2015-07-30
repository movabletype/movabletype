package OAuth::Lite2::Agent;

use strict;
use warnings;

use LWP::UserAgent;

=head1 NAME

OAuth::Lite2::Agent - Base class of preset-agents.

=head1 SYNOPSIS

    my $agent = OAuth::Lite2::Client::Agent->new;
    my $res = $agent->request( $req );

=head1 DESCRIPTION

Base class of preset-agents.

=head1 METHODS

=head2 new (%args)

Constructor you can set 'agent' that has same 'request' interface method as LWP::UserAgent.
If you omit that, a simple LWP::UserAgent object is set by default.

    my $agent = $class->new( agent => YourCustomAgent->new );

=cut

sub new {
    my $class = shift;
    my $self = bless { @_ }, $class;
    unless ($self->{agent}) {
        $self->{agent} = LWP::UserAgent->new;
        $self->{agent}->agent(
            join "/",
                __PACKAGE__,
                $OAuth::Lite2::Client::VERSION
        );
    }
    return $self;
}

=head2 request ($req)

Returns L<HTTP::Response> object.

=cut

sub request {
    my ($self, $req) = @_;
    return $self->{agent}->request($req);
}

1;

=head1 SEE ALSO

L<OAuth::Lite2::Client::Agent::Dump>,
L<OAuth::Lite2::Client::Agent::Strict>

=head1 AUTHOR

Lyo Kato, C<lyo.kato _at_ gmail.com>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
