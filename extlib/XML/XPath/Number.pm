# $Id: Number.pm 4532 2004-05-11 05:15:40Z ezra $

package XML::XPath::Number;
use XML::XPath::Boolean;
use XML::XPath::Literal;
use strict;

use overload
        '""' => \&value,
        '0+' => \&value,
        '<=>' => \&cmp;

sub new {
    my $class = shift;
    my $number = shift;
    if ($number !~ /^\s*[+-]?(\d+(\.\d*)?|\.\d+)\s*$/) {
        $number = undef;
    }
    else {
        $number =~ s/^\s*(.*)\s*$/$1/;
    }
    bless \$number, $class;
}

sub as_string {
    my $self = shift;
    defined $$self ? $$self : 'NaN';
}

sub as_xml {
    my $self = shift;
    return "<Number>" . (defined($$self) ? $$self : 'NaN') . "</Number>\n";
}

sub value {
    my $self = shift;
    $$self;
}

sub cmp {
    my $self = shift;
    my ($other, $swap) = @_;
    if ($swap) {
        return $other <=> $$self;
    }
    return $$self <=> $other;
}

sub evaluate {
    my $self = shift;
    $self;
}

sub to_boolean {
    my $self = shift;
    return $$self ? XML::XPath::Boolean->True : XML::XPath::Boolean->False;
}

sub to_literal { XML::XPath::Literal->new($_[0]->as_string); }
sub to_number { $_[0]; }

sub string_value { return $_[0]->value }

1;
__END__

=head1 NAME

XML::XPath::Number - Simple numeric values.

=head1 DESCRIPTION

This class holds simple numeric values. It doesn't support -0, +/- Infinity,
or NaN, as the XPath spec says it should, but I'm not hurting anyone I don't think.

=head1 API

=head2 new($num)

Creates a new XML::XPath::Number object, with the value in $num. Does some
rudimentary numeric checking on $num to ensure it actually is a number.

=head2 value()

Also as overloaded stringification. Returns the numeric value held.

=cut
