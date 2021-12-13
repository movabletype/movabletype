
###
# XML::Filter::BufferText - Filter to put all characters() in one event
# Robin Berjon <robin@knowscape.com>
# 04/07/2003 - v1.01
# 26/11/2001 - v0.01
###

package XML::Filter::BufferText;
use strict;
use base qw(XML::SAX::Base);
use vars qw($VERSION $AUTOLOAD);
$VERSION = '1.01';

#-------------------------------------------------------------------#
# now who said SAX was complex...
#-------------------------------------------------------------------#
sub characters { $_[0]->{_CharBuffer} .= $_[1]->{Data};}

sub AUTOLOAD {
    my $self = shift;
    my $data = shift;
    my $call = $AUTOLOAD;
    $call =~ s/^.*:://;
    return if $call eq 'DESTROY';

    if (defined $self->{_CharBuffer} and length $self->{_CharBuffer}) {
        $self->SUPER::characters( { Data => $self->{_CharBuffer} } );
        $self->{_CharBuffer} = '';
    }
    $call = 'SUPER::' . $call;
    $self->$call($data);
}
#-------------------------------------------------------------------#

### AUTOLOAD and inheritance don't work all that well, this is a
### workaround for that problem.
sub start_document;     sub end_document;           sub start_element;
sub end_element;        sub processing_instruction; sub comment;
sub skipped_entity;     sub ignorable_whitespace;   sub end_entity;
sub start_entity;       sub entity_reference;
sub start_cdata;        sub end_cdata;

1;
#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#
#`,`, Documentation `,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,#
#```````````````````````````````````````````````````````````````````#

=pod

=head1 NAME

XML::Filter::BufferText - Filter to put all characters() in one event

=head1 SYNOPSIS

  my $h = SomeHandler->new;
  my $f = XML::Filter::BufferText->new( Handler => $h );
  my $p = SomeParser->new( Handler => $f );
  $p->parse;

=head1 DESCRIPTION

This is a very simple filter. One common cause of grief (and programmer
error) is that XML parsers aren't required to provide character events in one
chunk. They can, but are not forced to, and most don't. This filter does the
trivial but oft-repeated task of putting all characters into a single event.

Note that this won't help you cases such as:

  <foo> blah <!-- comment --> phubar </foo>

In the above case, given the interleaving comment, there will be two
C<character()> events. This may be worked around in the future if there is
demand for it.

An interesting way to use this filter, instead of telling users to use it,
is to return it from your handler's constructor, already configured and all.
That'll make the buffering totally transparent to them (C<XML::SAX::Writer>
does that).

=head1 AUTHOR

Robin Berjon, robin@knowscape.com

=head1 COPYRIGHT

Copyright (c) 2001-2002 Robin Berjon. All rights reserved. This program is
free software; you can redistribute it and/or modify it under the same
terms as Perl itself.

=head1 SEE ALSO

XML::SAX::*, XML::Generator::*, XML::Handler::*, XML::Filter::*

=cut

