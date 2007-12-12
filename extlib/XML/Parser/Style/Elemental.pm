# Copyright (c) 2004-2005 Timothy Appnel
# http://www.timaoutloud.org/
# This code is released under the Artistic License.
#
# XML::Parser::Style::Elemental - A flexible and extensible object
# tree style for XML::Parser. DEPRECATED.
#

package XML::Parser::Style::Elemental;
use strict;
use warnings;

use vars qw($VERSION);
$VERSION = '0.72';

sub Init {
    my $xp = shift;
    $xp->{Elemental} ||= {};
    my $e = $xp->{Elemental};
    if ($xp->{Pkg} eq 'main' || !defined $xp->{Pkg}) {
        $e->{Document}   ||= 'XML::Elemental::Document';
        $e->{Element}    ||= 'XML::Elemental::Element';
        $e->{Characters} ||= 'XML::Elemental::Characters';
    }
    map { eval "use $e->{$_}" } qw( Document Element Characters);
    $xp->{__doc} = $e->{Document}->new;
    push(@{$xp->{__stack}}, $xp->{__doc});
}

sub Start {
    my $xp   = shift;
    my $tag  = shift;
    my $node = $xp->{Elemental}->{Element}->new();
    $node->name(ns_qualify($xp, $tag));
    $node->parent($xp->{__stack}->[-1]);
    if (@_) {
        $node->attributes({});
        while (@_) {
            my ($key, $value) = (shift @_, shift @_);
            $node->attributes->{ns_qualify($xp, $key, $tag)} = $value;
        }
    }
    $node->parent->contents([]) unless $node->parent->contents;
    push(@{$node->parent->contents}, $node);
    push(@{$xp->{__stack}}, $node);
}

sub Char {
    my ($xp, $data) = @_;
    my $parent = $xp->{__stack}->[-1];
    $parent->contents([]) unless $parent->contents;
    my $contents = $parent->contents();
    my $class    = $xp->{Elemental}->{Characters};
    unless ($contents && ref($contents->[-1]) eq $class) {
        return if ($xp->{Elemental}->{No_Whitespace} && $data !~ /\S/);
        my $node = $class->new();
        $node->parent($parent);
        $node->data($data);
        push(@{$contents}, $node);
    } else {
        my $d = $contents->[-1]->data() || '';
        return if ($xp->{Elemental}->{No_Whitespace} && $d !~ /\S/);
        $contents->[-1]->data("$d$data");
    }
}

sub End { pop(@{$_[0]->{__stack}}) }

sub Final {
    delete $_[0]->{__stack};
    $_[0]->{__doc};
}

sub ns_qualify {
    return $_[1] unless $_[0]->{Namespaces};
    my $ns = $_[0]->namespace($_[1]) || $_[0]->namespace($_[2]);
    return $_[1] unless $ns;
    $ns =~ m!(/|#)$! ? "$ns$_[1]" : "$ns/$_[1]";
}

1;

__END__

=begin

=head1 NAME

XML::Parser::Style::Elemental - A flexible and extensible object
tree style for XML::Parser. DEPRECATED.

=head1 SYNOPSIS

 #!/usr/bin/perl -w
 use XML::Parser;
 use Data::Dumper;
 my $p   = XML::Parser->new( Style => 'Elemental' );
 my $doc = <<DOC;
 <foo>
     <bar key="value">The world is foo enough.</bar>
 </foo>
 DOC
 my ($e) = $p->parse($doc);
 print Data::Dumper->Dump( [$e] );
 my $test_node = $e->contents->[0];
 print "root: " . $test_node->root . " is " . $e . "\n";
 print "text content of " . $test_node->name . "\n";
 print $test_node->text_content;

=head1 DESCRIPTION

This module is similar to the L<XML::Parser> Objects style (See
L<XML::Parser::Style::Objects>, but a bit more advanced and
flexible. While the Objects style creates simple hash objects for
each node, Elemental uses a set of generic classes with accessors
that can be subclassed. This parser style is also namespace aware
and work with custom objects that provide additional functionality
whether they be subclasses of the L<XML::Elemental> objects or
written from scratch with the same core method signatures. (See
L<REGISTERING CUSTOM CLASSES>)

Originally this parser style used a dynamic class factory to create
objects with accessor methods if other classes were not specified.
This behaviour has been deprecated in favor of using the simple
static classes found in the XML::Elemental package.

=head1 OPTIONS

Elemental specific options are set in the L<XML::Parser>
constructor through a hash element with a key of 'Elemental', The
value of Elemental is expected to be a hash reference with one of
more of the option keys detailed in the following sections.

=head2 REGISTERING CUSTOM CLASSES

If you require something more functional then the generic set of
classes provided you can register your own with Elemental. Like the
Elemental class types, the option keys are C<Document>, C<Element>
and C<Characters>.

 my $p = XML::Parser->new(
                           Style     => 'Elemental',
                           Namespace => 1,
                           Elemental => {
                                          Document   => 'Foo::Doc',
                                          Element    => 'Foo::El',
                                          Characters => 'Foo::Chars'
                           }
 );
 
XML::Elemental provides a collection of very simple generic objects
that can be subclassed to add more functionality while continuing
to use the Elemental parser style. Developers are free to create
their own modules from scratch. All that is required is that they
support the same core method signatures of the XML:Elemental
classes. (See L<XML::Elemental::Document>,
L<XML::Elemental::Element> and L<XML::Elemental::Characters> and
their abstract base class L<XML::Elemental::Node>.)

=head2 NO_WHITESPACE

When set to true, C<No_Whitespace> causes Elemental to pass over
character strings of all whitespace instead of creating a new
Character object. This options is helpful in stripping out
extraneous non-markup characters that are commonly introduced when
formatting XML to be human readable.

This method is a bit crude a simplistic. Eventually this module
will support the C<xml:space> attribute and related functionality
to processing whitespace.

=head1 SEE ALSO

L<XML::Parser::Style::Objects>, L<XML::Elemental>

=head1 TO DO

=item * Implement xml:space support and related functionality.

=head1 AUTHOR & COPYRIGHT

Please see the XML::Elemental manpage for author, copyright, and
license information.

=cut

=end
