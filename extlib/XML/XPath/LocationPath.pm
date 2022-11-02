package XML::XPath::LocationPath;

$VERSION = '1.44';

use Scalar::Util qw(blessed);
use XML::XPath::Root;
use strict; use warnings;

sub new {
    my $class = shift;
    my $self = [];
    bless $self, $class;
}

sub as_string {
    my $self = shift;
    my $string;
    for (my $i = 0; $i < @$self; $i++) {
        $string .= $self->[$i]->as_string if defined $self->[$i]->as_string;
        $string .= "/" if $self->[$i+1];
    }
    return $string;
}

sub as_xml {
    my $self = shift;
    my $string = "<LocationPath>\n";

    for (my $i = 0; $i < @$self; $i++) {
        $string .= $self->[$i]->as_xml;
    }

    $string .= "</LocationPath>\n";
    return $string;
}

sub set_root {
    my $self = shift;
    unshift @$self, XML::XPath::Root->new();
}

sub evaluate {
    my $self = shift;
    # context _MUST_ be a single node
    my $context = shift;
    die "No context" unless $context;

    # I _think_ this is how it should work :)

    my $nodeset = XML::XPath::NodeSet->new();
    $nodeset->push($context);
    foreach my $step (@$self) {
        next unless (defined $step && blessed($step));
        # For each step
        # evaluate the step with the nodeset
        my $pos = 1;
        $nodeset = $step->evaluate($nodeset);
    }

    return $nodeset->remove_duplicates;
}

1;
