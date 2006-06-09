# $Id: Author.pm 4532 2004-05-11 05:15:40Z ezra $

package XML::Atom::Author;
use strict;

use base qw( XML::Atom::Thing );

sub element_name { 'author' }

1;
__END__

=head1 NAME

XML::Atom::Author - Author or contributor object

=head1 SYNOPSIS

    my $author = XML::Atom::Author->new;
    $author->email('foo@example.com');
    $author->name('Foo Bar');
    $entry->author($author);

=head1 DESCRIPTION

I<XML::Atom::Author> represents an author or contributor element in an
Atom feed or entry.

=cut
