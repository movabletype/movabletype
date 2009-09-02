package XML::Elemental::Node;
use strict;

sub new { bless {}, $_[0]; }

sub root {
    my $e = shift;
    while ($e->{parent}) { $e = $e->{parent} }
    return $e;
}

sub ancestors {
    my $e = shift;
    my @a;
    while ($e->{parent}) {
        $e = $e->{parent};
        push @a, $e;
    }
    return @a;
}

sub in_element {
    my ($e, $a) = @_;
    while ($e->{parent}) {
        $e = $e->{parent};
        return 1 if $e == $a;
    }
    return 0;
}

sub DESTROY {
    my $self = shift;
    if ($self->{contents}) {
        for (@{$self->{contents}}) {
            $_->DESTROY if $_ && $_->isa('XML::Elemental::Node');
        }
    }
    %$self = ();    # safety first.
}

1;

__END__

=begin

=head1 NAME

XML::Elemental::Node - base class for all other XML::Elemental objects.

=head1 AUTHOR & COPYRIGHT

Please see the XML::Elemental manpage for author, copyright, and
license information.

=cut

=end
