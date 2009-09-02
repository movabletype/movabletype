package XML::Elemental::Element;
use strict;
use base qw( XML::Elemental::Node );

sub new {
    my $self = bless {}, $_[0];
    $self->{attribute} = {};
    $self->{contents}  = [];
    return $self;
}

sub text_content {
    return '' unless defined $_[0]->{contents};
    return
      join('',
           map { $_->can('text_content') ? $_->text_content : $_->data }
             @{$_[0]->contents});
}

sub name {
    $_[0]->{name} = $_[1] if @_ > 1;
    return $_[0]->{name};
}

sub parent {
    $_[0]->{parent} = $_[1] if @_ > 1;
    return $_[0]->{parent};
}

sub contents {
    $_[0]->{contents} ||= [];
    $_[0]->{contents} = $_[1] if @_ > 1;
    return $_[0]->{contents};
}

sub attributes {
    $_[0]->{attributes} ||= {};
    $_[0]->{attributes} = $_[1] if @_ > 1;
    return $_[0]->{attributes};
}

1;

__END__

=begin

=head1 NAME

XML::Elemental::Element - a generic element (tag) object.

=head1 DESCRIPTION

XML::Elemental::Element is a subclass of
L<XML::Elemental::Node> that is used by the Elemental parser
to represent a tag.

=head1 METHODS

=item XML::Elemental::Element->new

Parameterless constructor. Returns an instance of the
object.

=item $element->name([$name])

Returns the tag name as a string in Clarkian notation --
{namespace}tag. See C<process_name> in
L<MT::Elemental::Util> for a routine that can split this
namespace-qualified name into its individual parts. If you
are setting the element name it B<must> be in this same
notation.

=item $element->parent([$element])

Returns a the parent element object. If a object parameter
is passed the parent is set. The object is assumed to be or
have an interface like L<XML::Elemental::Element>.

=item $element->contents([\@children])

Returns an ordered array reference of direct sibling
objects. Returns a reference to an empty array if the
element does not have any siblings. If a parameter is passed
all the direct siblings are (re)set.

=item $element->attributes([\%attributes])

Returns a HASH reference of key-value pairs representing the
tag's attributes. It returns a reference to an empty hash if
the element does not have any attributes. If a parameter is
passed all attributes are (re)set. Like the element name,
keys must be in Clarkian notation.

=item $element->text_content

A method that returns the character data of all siblings as
a string.

=item $element->root

Inherited from L<XML::Elemental::Node>, returns the top most
object ancestor. Typically this will be a
L<XML::Element::Document> object.

=item $element->ancestors

Inherited from L<XML::Elemental::Node>, returns an ordered
array of elements starting with the closest ancestor and
ending with the root.

=item $element->in_element($element)

Inherited from L<XML::Elemental::Node>, this method will
test if the required L<XML::Elemental::Element> parameter is
an ancestor of the current object and return a boolean
value.

=head1 AUTHOR & COPYRIGHT

Please see the XML::Elemental manpage for author, copyright,
and license information.

=cut

=end
