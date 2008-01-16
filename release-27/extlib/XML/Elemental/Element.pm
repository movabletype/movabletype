package XML::Elemental::Element;
use strict;
use base qw( XML::Elemental::Node );

__PACKAGE__->mk_accessors(qw( name parent contents attributes ));

sub new {
    my $self = shift->SUPER::new(@_);
    $self->{attributes} ||= {};
    $self->{contents}   ||= [];
    $self;
}

sub text_content {
    return '' unless defined $_[0]->{contents};
    join('',
         map { $_->can('text_content') ? $_->text_content : $_->data }
           @{$_[0]->contents});
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

=item $element->parent([$object])

Returns a reference to the parent object. If a parameter is
passed the parent is set.

=item $element->contents([\@children])

Returns an ordered array reference of direct sibling
objects. Returns a reference to an empty array if the
element does not have any siblings. If a parameter is passed
all the direct siblings are (re)set.

=item $element->attributes([\%attributes])

Returns a hash reference of key-value pairs representing the
tag's attributes. It returns a reference to an empty hash if
the element does not have any attributes. If a parameter is
passed all attributes are (re)set. Like the element name,
keys must be in Clarkian notation.

=item $element->text_content

A method that returns the character data of all siblings.

=item $element->root

A method that returns a reference to the Elemental Document
object.

=head1 AUTHOR & COPYRIGHT

Please see the XML::Elemental manpage for author, copyright,
and license information.

=cut

=end
