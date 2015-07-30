package JSON::WebToken::Exception;

use strict;
use warnings;
use overload (
    q|""| => \&to_string,
);

use Carp qw/croak/;

sub throw {
    my ($class, %args) = @_;
    my $self = bless \%args, $class;
    croak $self;
}

sub code { $_[0]->{code} }
sub message { $_[0]->{message} }

sub to_string {
    $_[0]->message;
}

1;
__END__


