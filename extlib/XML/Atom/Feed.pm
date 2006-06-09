# $Id: Feed.pm 21854 2006-01-20 23:07:31Z bchoate $

package XML::Atom::Feed;
use strict;

use XML::Atom;
use base qw( XML::Atom::Thing );
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

sub language {
    my $feed = shift;
    if (LIBXML) {
        my $elem = $feed->{doc}->getDocumentElement;
        if (@_) {
            $elem->setAttributeNS('http://www.w3.org/XML/1998/namespace',
                'lang', $_[0]);
        }
        return $elem->getAttribute('lang');
    } else {
        if (@_) {
            $feed->{doc}->setAttribute('xml:lang', $_[0]);
        }
        return $feed->{doc}->getAttribute('xml:lang');
    }
}

sub version {
    my $feed = shift;
    my $elem = LIBXML ? $feed->{doc}->getDocumentElement : $feed->{doc};
    if (@_) {
        $elem->setAttribute('version', $_[0]);
    }
    $elem->getAttribute('version') || $feed->SUPER::version(@_);
}

sub entries_libxml {
    my $feed = shift;
    my @res = $feed->{doc}->getElementsByTagNameNS($feed->ns, 'entry') or return;
    my @entries;
    for my $res (@res) {
        my $entry = XML::Atom::Entry->new(Elem => $res->cloneNode(1));
        push @entries, $entry;
    }
    @entries;
}

sub entries_xpath {
    my $feed = shift;
    my $set = $feed->{doc}->find("descendant-or-self::*[local-name()='entry' and namespace-uri()='" . $feed->ns . "']");
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
        $feed->{doc}->getDocumentElement->getChildrenByTagNameNS($entry->ns, 'entry');
    if ($opt->{mode} && $opt->{mode} eq 'insert' && $first_entry) {
        $feed->{doc}->getDocumentElement->insertBefore(
            $entry->{doc}->getDocumentElement,
            $first_entry,
        );
    } else {
        $feed->{doc}->getDocumentElement->appendChild(
            $entry->{doc}->getDocumentElement,
        );
    }
}

sub add_entry_xpath {
    my $feed = shift;
    my($entry, $opt) = @_;
    $opt ||= {};
    my $set = $feed->{doc}->find("*[local-name()='entry' and namespace-uri()='" . $entry->ns . "']");
    my $first_entry = $set ? ($set->get_nodelist)[0] : undef;
    if ($opt->{mode} && $opt->{mode} eq 'insert' && $first_entry) {
        $feed->{doc}->insertBefore($entry->{doc}, $first_entry);
    } else {
        $feed->{doc}->appendChild($entry->{doc});
    }
}

1;
__END__

=head1 NAME

XML::Atom::Feed - Atom feed

=head1 SYNOPSIS

    use XML::Atom::Feed;
    use XML::Atom::Entry;
    my $feed = XML::Atom::Feed->new;
    $feed->title('My Weblog');
    my $entry = XML::Atom::Entry->new;
    $entry->title('First Post');
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

=head1 AUTHOR & COPYRIGHT

Please see the I<XML::Atom> manpage for author, copyright, and license
information.

=cut
