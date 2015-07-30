package OAuth::Lite2::Client::Error;

use strict;
use warnings;

use overload
    q{""}    => sub { shift->message },
    fallback => 1;

sub default_message { "error" }

sub new {
    my ($class, %args) = @_;
    bless {
        message => $args{message} || $class->default_message,
    }, $class;
}

sub throw {
    my ($class, %args) = @_;
    die $class->new(%args);
}

sub message {
    my $self = shift;
    return $self->{message};
}

package OAuth::Lite2::Client::Error::InvalidResponse;
our @ISA = qw(OAuth::Lite2::Client::Error);
sub default_message { "invalid response" }

package OAuth::Lite2::Client::Error::InsecureRequest;
our @ISA = qw(OAuth::Lite2::Client::Error);
sub default_message { "insecure request" }

package OAuth::Lite2::Client::Error::InsecureResponse;
our @ISA = qw(OAuth::Lite2::Client::Error);
sub default_message { "insecure response" }

package OAuth::Lite2::Client::Error;

=head1 NAME

OAuth::Lite2::Client::Error - OAuth 2.0 client error

=head1 SYNOPSIS

    OAuth::Lite2::Client::Error::InvalidResponse->throw(
        message => q{invalid format},
    );

=head1 DESCRIPTION

OAuth 2.0 client error

=head1 ERRORS

=over 4

=item OAuth::Lite2::Client::Error::InvalidResponse

=item OAuth::Lite2::Client::Error::InsecureRequest

=item OAuth::Lite2::Client::Error::InsecureResponse

=back

=head1 AUTHOR

Lyo Kato, E<lt>lyo.kato@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
