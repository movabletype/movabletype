# $Id$

package XML::Atom;
use strict;

use 5.008_001;
our $VERSION = '0.43';

BEGIN {
    @XML::Atom::EXPORT = qw( LIBXML DATETIME);
    if (eval { require XML::LibXML }) {
        *{XML::Atom::LIBXML} = sub() {1};
    } else {
        require XML::XPath;
        *{XML::Atom::LIBXML} = sub() {0};
    }
    if (eval { require DateTime::Format::Atom }) {
        *{XML::Atom::DATETIME} = sub() {1};
    } else {
        *{XML::Atom::DATETIME} = sub() {0};
    }

    $XML::Atom::ForceUnicode = 0;
    $XML::Atom::DefaultVersion = 0.3;
}

sub libxml_parser {
    ## uses old XML::LibXML < 1.70 interface for compat reasons
    return XML::LibXML->new(
        #no_network      => 1, # v1.63+
        expand_xinclude => 0,
        expand_entities => 1,
        load_ext_dtd    => 0,
        ext_ent_handler => sub { warn "External entities disabled."; '' },
    );
}

sub expat_parser {
    return XML::Parser->new(
        Handlers => {
            ExternEnt => sub { warn "External Entities disabled."; '' },
            ExternEntFin => sub {},
        },
    );
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
