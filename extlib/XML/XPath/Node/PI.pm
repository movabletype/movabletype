# $Id: PI.pm 4532 2004-05-11 05:15:40Z ezra $

package XML::XPath::Node::PI;

use strict;
use vars qw/@ISA/;

@ISA = ('XML::XPath::Node');

package XML::XPath::Node::PIImpl;

use vars qw/@ISA/;
@ISA = ('XML::XPath::NodeImpl', 'XML::XPath::Node::PI');
use XML::XPath::Node ':node_keys';

sub new {
	my $class = shift;
	my ($target, $data) = @_;
	
        my $pos = XML::XPath::Node->nextPos;
        
        my @vals;
        @vals[node_global_pos, node_target, node_data] = 
                ($pos, $target, $data);
	my $self = \@vals;
	bless $self, $class;
}

sub getNodeType { PROCESSING_INSTRUCTION_NODE }

sub isPINode { 1; }
sub isProcessingInstructionNode { 1; }

sub getTarget {
	my $self = shift;
	$self->[node_target];
}

sub getData {
	my $self = shift;
	$self->[node_data];
}

sub _to_sax {
	my $self = shift;
	my ($doch, $dtdh, $enth) = @_;
	# PI's not supported in PerlSAX 1
}

sub string_value {
	my $self = shift;
	return $self->[node_data];
}

sub toString {
	my $self = shift;
	return "<?" . $self->[node_target] . " " . XML::XPath::Node::XMLescape($self->[node_data], ">") . "?>";
}

1;
__END__

=head1 NAME

PI - an XML processing instruction node

=head1 API

=head2 new ( target, data )

Create a new PI node.

=head2 getTarget

Returns the target

=head2 getData

Returns the data

=cut
