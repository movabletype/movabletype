package XML::Elemental;
use strict;
use warnings;

use vars qw($VERSION);
$VERSION = '2.1';

use XML::SAX;

sub parser {
    my $handler;
    if ($_[1] && ref($_[1]) ne 'HASH') {
        $handler = $_[1];
    } else {
        require XML::Elemental::SAXHandler;
        $handler = XML::Elemental::SAXHandler->new($_[1]);
    }
    XML::SAX::ParserFactory->parser(Handler => $handler);
}

1;

__END__

=begin

=head1 NAME

XML::Elemental - simplistic and perlish handling of XML
data.

=head1 SYNOPSIS

 use XML::Elemental; 
 my $p = XML::Elemental->parser; 
 my $xml = '<foo>There is a <helloworld/> in my soup.</foo>';
 my $tree = $p->parse_string($xml);

=head1 DESCRIPTION

XML::Elemental is a SAX-based package for easily parsing XML
documents into a more native and mostly object-oriented perl
form.

The development of this package grew out of the desire for
something more object-oriented then L<XML::Simple> and was
more simplistic and perlish then the various standard XML
API modules such as L<XML::DOM>. Easier installation of
modules was also a contributing factor.

Original this package began as a style plugin to
L<XML::Parser>. That proved to be too limiting that it was
expanded. With the release of version 2.0 the package was
refactored to take advantage of any parser supporting SAX
that includes the pure perl option that ships with
L<XML::SAX>.

=head1 METHODS

=over

=item MT::Elemental->parser([\%options])

Instantiates and returns a SAX2 parser using
L<XML::Elemental::SAXHandler> as its handler and thereby
inherits all the methods found in L<XML::SAX::Base>.

The parser method can optionally take a hash reference containing 
SAX options. The hash reference can also include document, element 
and character class names to use during processing. The following
keys and their defaults are used:

    KEY         DEFAULT
    Document    XML::Elemental::Document
    Element     XML::Elemental::Element
    Characters  XML::Elemental::Characters

Any class that supports the same method signatures as the
XML::Elemental default classes can be used.

=head1 DEPENDENCIES

L<XML::SAX>, L<Scalar::Util>

=head1 SEE ALSO

L<XML::Simple>, L<XML::DOM>, L<XML::Handler::Trees>

=head1 LICENSE

The software is released under the Artistic License. The
terms of the Artistic License are described at
L<http://www.perl.com/language/misc/Artistic.html>.

=head1 AUTHOR & COPYRIGHT

Except where otherwise noted, XML::Elemental is Copyright
2004-2008, Timothy Appnel, tima@cpan.org. All rights
reserved.

=cut

=end
