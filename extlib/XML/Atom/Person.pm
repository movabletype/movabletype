# $Id$

package XML::Atom::Person;
use strict;
use base qw( XML::Atom::Base );

use XML::Atom;
use XML::Atom::Feed;
use XML::Atom::Entry;

__PACKAGE__->mk_elem_accessors(qw( email name uri url homepage ));

for my $class (qw( XML::Atom::Feed XML::Atom::Entry )) {
    $class->mk_object_accessor( author => __PACKAGE__ );
    $class->mk_object_accessor( contributor => __PACKAGE__ );
}

sub element_name { 'author' }

1;
__END__

=head1 NAME

XML::Atom::Person - Author or contributor object

=head1 SYNOPSIS

    my $person = XML::Atom::Person->new;
    $person->email('foo@example.com');
    $person->name('Foo Bar');
    $entry->author($person);

=head1 DESCRIPTION

I<XML::Atom::Person> represents an author or contributor element in an
Atom feed or entry.

=head1 USAGE

=head2 XML::Atom::Person->new

=head2 $person->email([ $email ])

=head2 $person->name([ $name ])

=head2 $person->uri([ $uri ])

=cut
