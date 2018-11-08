package XML::XPath::Literal;

$VERSION = '1.42';

use XML::XPath::Boolean;
use XML::XPath::Number;
use strict; use warnings;

use overload
		'""' => \&value,
                'fallback' => 1,
		'cmp' => \&cmp;

sub new {
	my $class = shift;
	my ($string) = @_;

#	$string =~ s/&quot;/"/g;
#	$string =~ s/&apos;/'/g;

	bless \$string, $class;
}

sub as_string {
	my $self = shift;
	my $string = $$self;
	$string =~ s/'/&apos;/g;
	return "'$string'";
}

sub as_xml {
    my $self = shift;
    my $string = $$self;
    return "<Literal>$string</Literal>\n";
}

sub value {
	my $self = shift;
	$$self;
}

sub cmp {
	my $self = shift;
	my ($cmp, $swap) = @_;
	if ($swap) {
		return $cmp cmp $$self;
	}
	return $$self cmp $cmp;
}

sub evaluate {
	my $self = shift;
	$self;
}

sub to_boolean {
	my $self = shift;
	return (length($$self) > 0) ? XML::XPath::Boolean->True : XML::XPath::Boolean->False;
}

sub to_number { return XML::XPath::Number->new($_[0]->value); }
sub to_literal { return $_[0]; }

sub string_value { return $_[0]->value; }

1;
__END__

=head1 NAME

XML::XPath::Literal - Simple string values.

=head1 DESCRIPTION

In XPath terms a Literal is what we know as a string.

=head1 API

=head2 new($string)

Create a new Literal object with the value in $string. Note that &quot; and
&apos; will be converted to " and ' respectively. That is not part of the XPath
specification, but I consider it useful. Note though that you have to go
to extraordinary lengths in an XML template file (be it XSLT or whatever) to
make use of this:

	<xsl:value-of select="&quot;I'm feeling &amp;quot;sad&amp;quot;&quot;"/>

Which produces a Literal of:

	I'm feeling "sad"

=head2 value()

Also overloaded as stringification, simply returns the literal string value.

=head2 cmp($literal)

Returns the equivalent of perl's cmp operator against the given $literal.

=cut
