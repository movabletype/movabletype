package XML::XPath::Node::Namespace;

use strict;
use warnings;
use parent qw/XML::XPath::Node/;

our $VERSION = '1.48';

package XML::XPath::Node::NamespaceImpl;

use XML::XPath::Node ':node_keys';
use parent qw/-norequire XML::XPath::NodeImpl XML::XPath::Node::Namespace/;

sub new {
	my $class = shift;
	my ($prefix, $expanded) = @_;

        my $pos = XML::XPath::Node->nextPos;

        my @vals;
        @vals[node_global_pos, node_prefix, node_expanded] =
                ($pos, $prefix, $expanded);
	my $self = \@vals;

	bless $self, $class;
}

sub getNodeType { NAMESPACE_NODE }

sub isNamespaceNode { 1; }

sub getPrefix {
	my $self = shift;
	$self->[node_prefix];
}

sub getExpanded {
	my $self = shift;
	$self->[node_expanded];
}

sub getValue {
	my $self = shift;
	$self->[node_expanded];
}

sub getData {
	my $self = shift;
	$self->[node_expanded];
}

sub string_value {
	my $self = shift;
	$self->[node_expanded];
}

sub toString {
	my $self = shift;
	my $string = '';
	return '' unless defined $self->[node_expanded];
	if ($self->[node_prefix] eq '#default') {
		$string .= ' xmlns="';
	}
	else {
		$string .= ' xmlns:' . $self->[node_prefix] . '="';
	}
	$string .= XML::XPath::Node::XMLescape($self->[node_expanded], '"&<');
	$string .= '"';
}

1;
__END__

=head1 NAME

Namespace - an XML namespace node

=head1 API

=head2 new ( prefix, expanded )

Create a new namespace node, expanded is the expanded namespace URI.

=head2 getPrefix

Returns the prefix

=head2 getExpanded

Returns the expanded URI

=head2 toString

Returns a string that you can add to the list
of attributes of an element: xmlns:prefix="expanded"

=cut
