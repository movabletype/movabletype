# $Id$

package XML::Atom;
use strict;

use 5.008_001;
our $VERSION = '0.35';

BEGIN {
    @XML::Atom::EXPORT = qw( LIBXML );
    if (eval { require XML::LibXML }) {
        *{XML::Atom::LIBXML} = sub() {1};
    } else {
        require XML::XPath;
        *{XML::Atom::LIBXML} = sub() {0};
    }
    local $^W = 0;
    *XML::XPath::Function::namespace_uri = sub {
        my $self = shift;
        my($node, @params) = @_;
        my $ns = $node->getNamespace($node->getPrefix);
        if (!$ns) {
            $ns = ($node->getNamespaces)[0];
        }
        XML::XPath::Literal->new($ns ? $ns->getExpanded : '');
    };

    $XML::Atom::ForceUnicode = 0;
    $XML::Atom::DefaultVersion = 0.3;
}

use base qw( XML::Atom::ErrorHandler Exporter );

package XML::Atom::Namespace;
use strict;

sub new {
    my $class = shift;
    my($prefix, $uri) = @_;
    bless { prefix => $prefix, uri => $uri }, $class;
}

sub DESTROY { }

use vars qw( $AUTOLOAD );
sub AUTOLOAD {
    (my $var = $AUTOLOAD) =~ s!.+::!!;
    no strict 'refs';
    ($_[0], $var);
}

1;
__END__

=head1 NAME

XML::Atom - Atom feed and API implementation

=head1 SYNOPSIS

    use XML::Atom;

=head1 DESCRIPTION

Atom is a syndication, API, and archiving format for weblogs and other
data. I<XML::Atom> implements the feed format as well as a client for the
API.

=head1 LICENSE

I<XML::Atom> is free software; you may redistribute it and/or modify it
under the same terms as Perl itself.

=head1 AUTHOR

Benjamin Trott, Tatsuhiko Miyagawa

=head1 COPYRIGHT

All rights reserved.

=cut
