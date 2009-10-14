# $Id$

package XML::Atom::Entry;
use strict;

use XML::Atom;
use base qw( XML::Atom::Thing );
use MIME::Base64 qw( encode_base64 decode_base64 );
use XML::Atom::Person;
use XML::Atom::Content;
use XML::Atom::Util qw( first );

sub element_name { 'entry' }

sub content {
    my $entry = shift;
    if (my @arg = @_) {
        if (ref($arg[0]) ne 'XML::Atom::Content') {
            $arg[0] = XML::Atom::Content->new(Body => $arg[0], Version => $entry->version);
        }
        $entry->set($entry->ns, 'content', @arg);
    } else {
        return $entry->get_object($entry->ns, 'content', 'XML::Atom::Content');
    }
}

__PACKAGE__->mk_elem_accessors(qw( summary ));
__PACKAGE__->mk_xml_attr_accessors(qw( lang base ));

__PACKAGE__->_rename_elements('issued' => 'published');
__PACKAGE__->_rename_elements('modified' => 'updated');

# OMG 0.3 elements ... to be backward compatible
__PACKAGE__->mk_elem_accessors(qw( created ));

__PACKAGE__->mk_object_accessor( source => 'XML::Atom::Feed' );

1;
__END__

=head1 NAME

XML::Atom::Entry - Atom entry

=head1 SYNOPSIS

    use XML::Atom::Entry;
    my $entry = XML::Atom::Entry->new;
    $entry->title('My Post');
    $entry->content('The content of my post.');
    my $xml = $entry->as_xml;
    my $dc = XML::Atom::Namespace->new(dc => 'http://purl.org/dc/elements/1.1/');
    $entry->set($dc, 'subject', 'Food & Drink');

=head1 USAGE

=head2 XML::Atom::Entry->new([ $stream ])

Creates a new entry object, and if I<$stream> is supplied, fills it with the
data specified by I<$stream>.

Automatically handles autodiscovery if I<$stream> is a URI (see below).

Returns the new I<XML::Atom::Entry> object. On failure, returns C<undef>.

I<$stream> can be any one of the following:

=over 4

=item * Reference to a scalar

This is treated as the XML body of the entry.

=item * Scalar

This is treated as the name of a file containing the entry XML.

=item * Filehandle

This is treated as an open filehandle from which the entry XML can be read.

=back

=head2 $entry->content([ $content ])

Returns the content of the entry. If I<$content> is given, sets the content
of the entry. Automatically handles all necessary escaping.

=head2 $entry->author([ $author ])

Returns an I<XML::Atom::Person> object representing the author of the entry,
or C<undef> if there is no author information present.

If I<$author> is supplied, it should be an I<XML::Atom::Person> object
representing the author. For example:

    my $author = XML::Atom::Person->new;
    $author->name('Foo Bar');
    $author->email('foo@bar.com');
    $entry->author($author);

=head2 $entry->link

If called in scalar context, returns an I<XML::Atom::Link> object
corresponding to the first I<E<lt>linkE<gt>> tag found in the entry.

If called in list context, returns a list of I<XML::Atom::Link> objects
corresponding to all of the I<E<lt>linkE<gt>> tags found in the entry.

=head2 $entry->add_link($link)

Adds the link I<$link>, which must be an I<XML::Atom::Link> object, to
the entry as a new I<E<lt>linkE<gt>> tag. For example:

    my $link = XML::Atom::Link->new;
    $link->type('text/html');
    $link->rel('alternate');
    $link->href('http://www.example.com/2003/12/post.html');
    $entry->add_link($link);

=head2 $entry->get($ns, $element)

Given an I<XML::Atom::Namespace> element I<$ns> and an element name
I<$element>, retrieves the value for the element in that namespace.

This is useful for retrieving the value of elements not in the main Atom
namespace, like categories. For example:

    my $dc = XML::Atom::Namespace->new(dc => 'http://purl.org/dc/elements/1.1/');
    my $subj = $entry->get($dc, 'subject');

=head2 $entry->getlist($ns, $element)

Just like I<$entry-E<gt>get>, but if there are multiple instances of the
element I<$element> in the namespace I<$ns>, returns all of them. I<get>
will return only the first.

=head1 AUTHOR & COPYRIGHT

Please see the I<XML::Atom> manpage for author, copyright, and license
information.

=cut
