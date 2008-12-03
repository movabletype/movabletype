package XML::Elemental::Characters;
use strict;
use base qw( XML::Elemental::Node );

sub data {
    $_[0]->{data} = $_[1] if @_ > 1;
    return $_[0]->{data};
}

sub parent {
    $_[0]->{parent} = $_[1] if @_ > 1;
    return $_[0]->{parent};
}

1;

__END__

=begin

=head1 NAME

XML::Elemental::Characters - a generic characters object.

=head1 DESCRIPTION

XML::Elemental::Characters is a subclass of L<XML::Elemental::Node>
that is used by the Elemental parser to represent character
data.

=head1 METHODS

=item XML::Elemental::Characters->new

Parameterless constructor. Returns an instance of the object.

=item $chars->parent([$object])

Returns a the parent element object. If a object parameter
is passed the parent is set. The object is assumed to be or
have an interface like L<XML::Elemental::Element>.

=item $chars->data([$string])

A method that returns the character data as a string. If a
parameter is passed the value is set.

=item $chars->root

Inherited from L<XML::Elemental::Node>, returns the top most
object ancestor. Typically this will be a
L<XML::Element::Document> object.

=item $chars->ancestors

Inherited from L<XML::Elemental::Node>, returns an ordered
array of elements starting with the closest ancestor and
ending with the root.

=item $chars->in_element($element)

Inherited from L<XML::Elemental::Node>, this method will
test if the required L<XML::Elemental::Element> parameter is
an ancestor of the current object and return a boolean
value.

=head1 AUTHOR & COPYRIGHT

Please see the XML::Elemental manpage for author, copyright, and
license information.

=cut

=end
