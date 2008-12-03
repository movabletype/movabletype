package XML::Elemental::Document;
use strict;
use base qw( XML::Elemental::Node );

use Scalar::Util qw(weaken);

sub root_element { $_[0]->{contents} }

sub contents {
    if (@_ > 1) {
        $_[0]->{contents} = ref $_[1] eq 'ARRAY' ? $_[1]->[0] : $_[1];
        weaken($_[0]->{contents}->{parent} = $_[0]);
    }
    return $_[0]->{contents} ? [$_[0]->{contents}] : [];
}

sub attributes { }    # deprecated. documents never have attributes.

sub DESTROY {
    $_[0]->{contents}->DESTROY if $_[0]->{contents};
}                     # starts circular reference teardown

1;

__END__

=begin

=head1 NAME

XML::Elemental::Document - a generic document object.

=head1 DESCRIPTION

XML::Elemental::Document is a subclass of L<XML::Elemental::Node>
that can be used with the Elemental parser to represent the document
(root) node.

=head1 METHODS

=item XML::Elemental::Document->new

Parameterless constructor. Returns an instance of the object.

=item $doc->contents([\@children])

Returns an ordered array reference of direct sibling
objects. In the case of the document object it will return 0
to 1 elements. Returns a reference to an empty array if the
element does not have any siblings. If a parameter is passed
all the direct siblings are (re)set.

=item $doc->root_element;

Returns the root element of the document. This a connivence method that
is the equivalent of:

  $doc->contents->[0];

=item $doc->root

Inherited from L<XML::Elemental::Node>, returns a reference to itself.

=item $doc->ancestors

Inherited from L<XML::Elemental::Node>, returns undef. The
document object never has ancestors.

=item $doc->in($element)

Inherited from L<XML::Elemental::Node>, returns undef. The
document object is always the root of the tree.

=head1 AUTHOR & COPYRIGHT

Please see the XML::Elemental manpage for author, copyright, and
license information.

=cut

=end
