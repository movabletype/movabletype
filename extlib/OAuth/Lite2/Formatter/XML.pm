package OAuth::Lite2::Formatter::XML;

use strict;
use warnings;

use parent 'OAuth::Lite2::Formatter';
use Try::Tiny;
use XML::LibXML;
use Carp ();

sub name { "xml" }
sub type { "application/xml" }

sub format {
    my ($self, $hash) = @_;
    my $xml = '<?xml version="1.0" encoding="UTF-8"?>';
    $xml .= '<OAuth>';
    for my $key ( keys %$hash ) {
        $xml .= sprintf(q{<%s>%s</%s>},
            $key,
            $hash->{$key},
            $key);
    }
    $xml .= '</OAuth>';
    return $xml;
}

sub parse {
    my ($self, $xml) = @_;
    my $parser = XML::LibXML->new;
    my $doc = $parser->parse_string($xml);
    my $root = $doc->documentElement();
    Carp::croak "<OAuth/> Element not found: " . $xml
        unless $root->nodeName eq 'OAuth';
    my $hash = {};
    my @children = $root->childNodes();
    for my $child ( @children ) {
        next unless $child->nodeType == 1;
        my $key = $child->nodeName();
        next unless $key;
        my $value = $child->textContent() || '';
        $hash->{$key} = $value;
    }
    return $hash;
}

=head1 NAME

OAuth::Lite2::Formatter::XML - OAuth 2.0 XML formatters store

=head1 SYNOPSIS

    my $formatter = OAuth::Lite2::Formatter::XML->new;
    my $obj = $formatter->parse( $string );
    $string = $formatter->format( $obj );

=head1 DESCRIPTION

DEPRECATED.
OAuth 2.0 XML formatter.

=head1 METHODS

=head2 name

Accessor for name of this format, "xml".

=head2 type

Accessor for content-type of this format, "application/xml".

=head2 format( $object )

    my $xml_string = $formatter->format( $obj );

=head2 parse( $xml_string )

    my $obj = $formatter->parse( $xml_string );

=head1 SEE ALSO

L<OAuth::Lite2::Formatter>
L<OAuth::Lite2::Formatters>
L<OAuth::Lite2::Formatter::JSON>
L<OAuth::Lite2::Formatter::FormURLEncoded>

=head1 AUTHOR

Lyo Kato, E<lt>lyo.kato@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
