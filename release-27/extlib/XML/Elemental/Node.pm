package XML::Elemental::Node;
use strict;
use base qw( Class::Accessor::Fast );

sub new { bless $_[1] || {}, $_[0]; }

sub root {
    my $e = shift;
    while ($e->{parent}) { $e = $e->{parent} }
    $e;
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
