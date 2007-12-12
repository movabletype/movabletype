package HTML::Entities::Numbered;

use strict;
use HTML::Entities::Numbered::Table;
use base qw(Exporter);
use vars qw($VERSION @EXPORT %DECIMALS %ENTITIES);
@EXPORT = qw(
    name2decimal name2hex name2decimal_xml name2hex_xml decimal2name hex2name
);

$VERSION = '0.04';

BEGIN { %ENTITIES = reverse %DECIMALS }

sub name2decimal {
    my $content = shift;
    $content =~ s/(&[a-z0-9]+;)/_convert2num($1, '&#%d;')/ieg;
    return $content;
}

sub name2hex {
    my $content = shift;
    $content =~ s/(&[a-z0-9]+;)/_convert2num($1, '&#x%X;')/ieg;
    return $content;
}

sub name2decimal_xml {
    my $content = shift;
    $content =~ s{(&(?:(lt|gt|amp|quot|apos)|[a-z0-9]+);)}
	{ $2 ? $1 : _convert2num($1, '&#%d;') }ieg;
    return $content;
}

sub name2hex_xml {
    my $content = shift;
    $content =~ s{(&(?:(lt|gt|amp|quot|apos)|[a-z0-9]+);)}
	{ $2 ? $1 : _convert2num($1, '&#x%X;') }ieg;
    return $content;
}

sub decimal2name {
    my $content = shift;
    $content =~ s/(&#\d+;)/_convert2name($1)/ieg;
    return $content;
}

sub hex2name {
    my $content = shift;
    $content =~ s/(&#x[a-f0-9]+;)/_convert2name($1)/ieg;
    return $content;
}

sub _convert2num {
    my($reference, $format) = @_;
    my($name) = $reference =~ /^&([a-z0-9]+);$/i;
    return exists $DECIMALS{$name} ?
	sprintf($format, $DECIMALS{$name}) : $reference;
}

sub _convert2name {
    my $reference = shift;
    my($is_hex, $decimal) = $reference =~ /^&#(x?)([a-f0-9]+);$/i;
    $decimal = sprintf('%d', ($is_hex ? hex($decimal) : $decimal));
    return exists $ENTITIES{$decimal} ?
	sprintf('&%s;', $ENTITIES{$decimal}) : $reference;
}

1;
__END__

=head1 NAME

HTML::Entities::Numbered - Conversion of numbered HTML entities

=head1 SYNOPSIS

 use HTML::Entities::Numbered;
 
 $html    = 'Hi Honey<b>&hearts;</b>';
 
 # convert named HTML entities to numbered (decimal)
 $decimal = name2decimal($html);    # Hi Honey<b>&#9829;</b>
 
 # to numbered (hexadecimal)
 $hex     = name2hex($html);        # Hi Honey<b>&#x2665;</b>
 
 $content = 'Copyright &#169; Larry Wall';
 
 # convert numbered HTML entities (decimal) to named
 $name1   = decimal2name($content); # Copyright &copy; Larry Wall
 
 $content = 'Copyright &#xA9; Larry Wall';
 # convert numbered HTML entitites (hexadecimal) to named
 $name2   = hex2name($content);     # Copyright &copy; Larry Wall
 
 $xml     = '&quot;Give me &yen;10,000&quot; &gt; cherie&spades;';
 
 # convert named HTML entities to numbered
 # except valid XML entities (decimal)
 $decimal = name2decimal_xml($xml); # &quot;Give me &#165;10,000&quot;
                                    # &gt; cherie&#9824;
 
 # to numbered except valid XML entities (hexdecimal)
 $hex     = name2hex_xml($xml);     # &quot;Give me &#xA5;10,000&quot;
                                    # &gt; cherie&#x2660;

=head1 DESCRIPTION

HTML::Entities::Numbered is a content conversion filter for named HTML
entities (symbols, mathmetical symbols, Greek letters, Latin letters,
etc.).
When an argument of C<name2decimal()> or C<name2hex()> contains some
B<nameable> HTML entities, they will be replaced to numbered HTML
entities. And when an argument of C<name2decimal_xml()> or
C<name2hex_xml()> contains some B<nameable> numbered HTML entities,
they will be replaced to numbered HTML entities B<except valid XML
entities> (the excepted "valid XML entities" are the following five
entities: C<&lt;>, C<&gt;>, C<&amp;>, C<&quot;>, C<&apos;>).
By the same token, when an argument of C<decimal2name()> or
C<hex2name()> contains some B<nameable> numbered HTML entities, they
will be replaced to named HTML entities.

(the exception "valid XML entities" means the following five entities:
C<&lt;>, C<&gt;>, C<&amp;>, C<&quot;>, C<&apos;>)

On version 0.03, the entities hash table is imported from
L<HTML::Entities> (with obsolete class
C<HTML::Entities::Numbered::Extra> for older releases of Perl).
At the moment, 0.04 (or later) is included
L<HTML::Entities::Numbered::Table> to import HTML entities table, and
thereby we do not need to have L<HTML::Entities> (included in
L<HTML::Parser> distribution).

This may be also useful for making valid XML (corrects the undefined
entity references, and enhanced by addition of functions conform to
the XML).

=head1 FUNCTIONS

Following all functions are exported by default.

=over 4

=item * name2decimal

Some included named HTML entities in argument of C<name2decimal()>
will be replaced to decimal numbered HTML entities.

=item * name2hex

Some included named HTML entities in argument of C<name2hex()>
will be replaced to hexadecimal numbered HTML entities.

=item * decimal2name

Some include decimal numbered HTML entities in argument of
C<decimal2name()> will be replaced to named HTML entities
(If they're nameable).

=item * hex2name

Some include hexadecimal numbered HTML entities in argument of
C<hex2name()> will be replaced to named HTML entities
(If they're nameable).

=item * name2decimal_xml

Some included named HTML entities in argument of C<name2decimal_xml()>
will be replaced to decimal numbered HTML entities B<except valid XML
entities>.

=item * name2hex_xml

Some included named HTML entities in argument of C<name2hex_xml()>
will be replaced to hexadecimal numbered HTML entities B<except valid
XML entities>.

=back

If you'd prefer not to import them functions into the caller's
namespace, you can call them as below:

 use HTML::Entities::Numbered ();
 
 $decimal = HTML::Entities::Numbered::name2decimal($str);
 $hex     = HTML::Entities::Numbered::name2hex($str);
 $named1  = HTML::Entities::Numbered::decimal2name($str);
 $named2  = HTML::Entities::Numbered::hex2name($str);
 $decimal = HTML::Entities::Numbered::name2decimal_xml($str);
 $hex     = HTML::Entities::Numbered::name2hex_xml($str);

=head1 AUTHOR

Koichi Taniguchi E<lt>taniguchi@livedoor.jpE<gt>

Develop triggered by IKEBE Tomohiro E<lt>ikebe@cpan.orgE<gt>

Many thanks to Tatsuhiko Miyagawa E<lt>miyagawa@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright (c) 2004 Koichi Taniguchi. Japan. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<HTML::Entities>,
L<http://www.w3.org/TR/REC-html40/sgml/entities.html>

=cut
