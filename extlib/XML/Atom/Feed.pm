# $Id$

package XML::Atom::Feed;
use strict;
use base qw( XML::Atom::Thing );

use XML::Atom;
use XML::Atom::Entry;
BEGIN {
    if (LIBXML) {
        *entries = \&entries_libxml;
        *add_entry = \&add_entry_libxml;
    } else {
        *entries = \&entries_xpath;
        *add_entry = \&add_entry_xpath;
    }
}

sub init {
    my $atom = shift;
    my %param = @_ == 1 ? (Stream => $_[0]) : @_;
    if (UNIVERSAL::isa($param{Stream}, 'URI')) {
        my @feeds = __PACKAGE__->find_feeds($param{Stream});
        return $atom->error("Can't find Atom file") unless @feeds;
        my $ua = LWP::UserAgent->new;
        my $req = HTTP::Request->new(GET => $feeds[0]);
        my $res = $ua->request($req);
        if ($res->is_success) {
            $param{Stream} = \$res->content;
        }
    }
    $atom->SUPER::init(%param);
}

sub find_feeds {
    my $class = shift;
    my($uri) = @_;
    my $ua = LWP::UserAgent->new;
    my $req = HTTP::Request->new(GET => $uri);
    my $res = $ua->request($req);
    return unless $res->is_success;
    my @feeds;
    if ($res->content_type eq 'text/html' || $res->content_type eq 'application/xhtml+xml') {
        my $base_uri = $uri;
        my $find_links = sub {
            my($tag, $attr) = @_;
            if ($tag eq 'link') {
                return unless $attr->{rel};
                my %rel = map { $_ => 1 } split /\s+/, lc($attr->{rel});
                (my $type = lc $attr->{type}) =~ s/^\s*//;
                $type =~ s/\s*$//;
                push @feeds, URI->new_abs($attr->{href}, $base_uri)->as_string
                   if $rel{alternate} &&
                      $type eq 'application/atom+xml';
            } elsif ($tag eq 'base') {
                $base_uri = $attr->{href};
            }
        };
        require HTML::Parser;
        my $p = HTML::Parser->new(api_version => 3,
                                  start_h => [ $find_links, "tagname, attr" ]);
        $p->parse($res->content);
    } else {
        @feeds = ($uri);
    }
    @feeds;
}

sub element_name { 'feed' }
*language = \&lang; # legacy


sub version {
    my $feed = shift;
    my $elem = $feed->elem;
    if (@_) {
        $elem->setAttribute('version', $_[0]);
    }
    $elem->getAttribute('version') || $feed->SUPER::version(@_);
}

sub entries_libxml {
    my $feed = shift;
    my @res = $feed->elem->getElementsByTagNameNS($feed->ns, 'entry') or return;
    my @entries;
    for my $res (@res) {
        my $entry = XML::Atom::Entry->new(Elem => $res->cloneNode(1));
        push @entries, $entry;
    }
    @entries;
}

sub entries_xpath {
    my $feed = shift;
    my $set = $feed->elem->find("descendant-or-self::*[local-name()='entry' and namespace-uri()='" . $feed->ns . "']");
    my @entries;
    for my $elem ($set->get_nodelist) {
        ## Delete the link to the parent (feed) element, and append
        ## the default Atom namespace.
        $elem->del_parent_link;
        my $ns = XML::XPath::Node::Namespace->new('#default' => $feed->ns);
        $elem->appendNamespace($ns);
        my $entry = XML::Atom::Entry->new(Elem => $elem);
        push @entries, $entry;
    }
    @entries;
}

sub add_entry_libxml {
    my $feed = shift;
    my($entry, $opt) = @_;
    $opt ||= {};
    # When doing an insert, we try to insert before the first <entry> so
    # that we don't screw up any preamble.  If there are no existing
    # <entry>'s, then fall back to appending, which should be
    # semantically identical.
    my ($first_entry) =
        $feed->elem->getChildrenByTagNameNS($entry->ns, 'entry');
    if ($opt->{mode} && $opt->{mode} eq 'insert' && $first_entry) {
        $feed->elem->insertBefore($entry->elem, $first_entry);
    } else {
        $feed->elem->appendChild($entry->elem);
    }
}

sub add_entry_xpath {
    my $feed = shift;
    my($entry, $opt) = @_;
    $opt ||= {};
    my $set = $feed->elem->find("*[local-name()='entry' and namespace-uri()='" . $entry->ns . "']");
    my $first_entry = $set ? ($set->get_nodelist)[0] : undef;
    if ($opt->{mode} && $opt->{mode} eq 'insert' && $first_entry) {
        $feed->elem->insertBefore($entry->elem, $first_entry);
    } else {
        $feed->elem->appendChild($entry->elem);
    }
}

__PACKAGE__->mk_elem_accessors(qw( generator ));
__PACKAGE__->mk_xml_attr_accessors(qw( lang base ));

__PACKAGE__->_rename_elements('modified' => 'updated');
__PACKAGE__->_rename_elements('tagline' => 'subtitle');

1;
__END__

=head1 NAME

XML::Atom::Feed - Atom feed

=head1 SYNOPSIS

    use XML::Atom::Feed;
    use XML::Atom::Entry;
    my $feed = XML::Atom::Feed->new;
    $feed->title('My Weblog');
    $feed->id('tag:example.com,2006:feed-id');
    my $entry = XML::Atom::Entry->new;
    $entry->title('First Post');
    $entry->id('tag:example.com,2006:entry-id');
    $entry->content('Post Body');
    $feed->add_entry($entry);
    $feed->add_entry($entry, { mode => 'insert' });

    my @entries = $feed->entries;
    my $xml = $feed->as_xml;

    ## Get a list of the <link rel="..." /> tags in the feed.
    my $links = $feed->link;

    ## Find all of the Atom feeds on a given page, using auto-discovery.
    my @uris = XML::Atom::Feed->find_feeds('http://www.example.com/');

    ## Use auto-discovery to load the first Atom feed on a given page.
    my $feed = XML::Atom::Feed->new(URI->new('http://www.example.com/'));

=head1 USAGE

=head2 XML::Atom::Feed->new([ $stream ])

Creates a new feed object, and if I<$stream> is supplied, fills it with the
data specified by I<$stream>.

Automatically handles autodiscovery if I<$stream> is a URI (see below).

Returns the new I<XML::Atom::Feed> object. On failure, returns C<undef>.

I<$stream> can be any one of the following:

=over 4

=item * Reference to a scalar

This is treated as the XML body of the feed.

=item * Scalar

This is treated as the name of a file containing the feed XML.

=item * Filehandle

This is treated as an open filehandle from which the feed XML can be read.

=item * URI object

This is treated as a URI, and the feed XML will be retrieved from the URI.

If the content type returned from fetching the content at URI is
I<text/html>, this method will automatically try to perform auto-discovery
by looking for a I<E<lt>linkE<gt>> tag describing the feed URL. If such
a URL is found, the feed XML will be automatically retrieved.

If the URI is already of a feed, no auto-discovery is necessary, and the
feed XML will be retrieved and parsed as normal.

=back

=head2 XML::Atom::Feed->find_feeds($uri)

Given a URI I<$uri>, use auto-discovery to find all of the Atom feeds linked
from that page (using I<E<lt>linkE<gt>> tags).

Returns a list of feed URIs. 

=head2 $feed->link

If called in scalar context, returns an I<XML::Atom::Link> object
corresponding to the first I<E<lt>linkE<gt>> tag found in the feed.

If called in list context, returns a list of I<XML::Atom::Link> objects
corresponding to all of the I<E<lt>linkE<gt>> tags found in the feed.

=head2 $feed->add_link($link)

Adds the link I<$link>, which must be an I<XML::Atom::Link> object, to
the feed as a new I<E<lt>linkE<gt>> tag. For example:

    my $link = XML::Atom::Link->new;
    $link->type('text/html');
    $link->rel('alternate');
    $link->href('http://www.example.com/');
    $feed->add_link($link);

=head2 $feed->add_entry($entry)

Adds the entry I<$entry>, which must be an I<XML::Atom::Entry> object,
to the feed. If you want to add an entry before existent entries, you can pass optional hash reference containing C<mode> value set to C<insert>.

  $feed->add_entry($entry, { mode => 'insert' });

=head2 $feed->entries

Returns list of XML::Atom::Entry objects contained in the feed.

=head2 $feed->language

Returns the language of the feed, from I<xml:lang>.

=head2 $feed->author([ $author ])

Returns an I<XML::Atom::Person> object representing the author of the entry,
or C<undef> if there is no author information present.

If I<$author> is supplied, it should be an I<XML::Atom::Person> object
representing the author. For example:

    my $author = XML::Atom::Person->new;
    $author->name('Foo Bar');
    $author->email('foo@bar.com');
    $feed->author($author);

=head2 $feed->id([ $id ])

Returns an id for the feed. If I<$id> is supplied, set the id. When
generating the new feed, it is your responsibility to generate unique
ID for the feed and set to XML::Atom::Feed object. You can use I<http>
permalink, I<tag> URI scheme or I<urn:uuid> for handy.

=head1 UNICODE FLAGS

By default, XML::Atom takes off all the Unicode flag fro mthe feed content. For example,

  my $title = $feed->title;

the variable C<$title> contains UTF-8 bytes without Unicode flag set,
even if the feed title contains some multibyte chracters.

If you don't like this behaviour and wants to andle everything as
Unicode characters (rather than UTF-8 bytes), set
C<$XML::Atom::ForceUnicode> flag to 1.

  $XML::Atom::ForceUnicode = 1;

then all the data returned from XML::Atom::Feed object and
XML::Atom::Entry object etc., will have Unicode flag set.

The only exception will be C<< $entry->content->body >>, if content
type is not text/* (e.g. image/gif). In that case, the content body is
still binary data, without Unicode flag set.

=head1 CREATING ATOM 1.0 FEEDS

By default, XML::Atom::Feed and other classes (Entry, Link and
Content) will create entities using Atom 0.3 namespaces. In order to
create 1.0 feed and entry elements, you can set I<Version> as a
parameter, like:

  $feed = XML::Atom::Feed->new(Version => 1.0);
  $entry = XML::Atom::Entry->new(Version => 1.0);

Setting those Version to every element would be sometimes painful. In
that case, you can override the default version number by setting
C<$XML::Atom::DefaultVersion> global variable to "1.0".

  use XML::Atom;

  $XML::Atom::DefaultVersion = "1.0";

  my $feed = XML::Atom::Feed->new;
  $feed->title("blah");

  my $entry = XML::Atom::Entry->new;
  $feed->add_entry($entry);

  $feed->version; # 1.0

=head1 AUTHOR & COPYRIGHT

Please see the I<XML::Atom> manpage for author, copyright, and license
information.

=cut
