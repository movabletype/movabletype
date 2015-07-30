package OAuth::Lite2::Model::ServerState;

use strict;
use warnings;

use base 'Class::Accessor::Fast';

__PACKAGE__->mk_accessors(qw(
    client_id
    server_state
    expires_in
    created_on
));

use Params::Validate;

sub new {
    my $class = shift;
    my @args = @_ == 1 ? %{$_[0]} : @_;
    my %params = Params::Validate::validate_with(
        params => \@args, 
        spec => {
            client_id    => 1,
            server_state => 1,
            expires_in   => 1,
            created_on   => { optional => 1 },
        },
        allow_extra => 1,
    );
    my $self = bless \%params, $class;
    return $self;
}

=head1 NAME

OAuth::Lite2::Model::ServerState - model class that represents Server State

=head1 ACCESSORS

=head2 client_id

Client Identifier

=head2 server_state

Server State string.

=head2 expires_in

Seconds to expires from 'created_on'

=head2 created_on

UNIX time when Server State created.

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
