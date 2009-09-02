package XML::Elemental::Util;
use strict;

use Exporter;
@XML::Elemental::Util::ISA = qw( Exporter );
use vars qw( @EXPORT_OK );
@EXPORT_OK = qw( process_name );

sub process_name {
    $_[0] =~ m/^{(.*)}(.+)$/;
    my $ns = defined $1 ? $1 : '';
    $2, $ns;
}

#--- more to come?

1;

__END__

=begin

=head1 NAME

XML::Elemental::Util - utility methods for working with
L<XML::Elemental>.

=head1 METHODS

All utility methods are exportable.

=over

=item process_name($name)

Takes one required string presumed to be in Clarkian
notation and parses it into its local name and namespace URI
parts. If the element name does not have a namespace
provided a null string is returned. An element must always
have a local part, however if undefined is returned the name
was not a in the proper notation.

=back

=head1 AUTHOR & COPYRIGHT

Please see the XML::Elemental manpage for author, copyright,
and license information.

=cut

=end
