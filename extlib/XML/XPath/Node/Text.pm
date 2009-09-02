# $Id: Text.pm 4532 2004-05-11 05:15:40Z ezra $

package XML::XPath::Node::Text;

use strict;
use vars qw/@ISA/;

@ISA = ('XML::XPath::Node');

package XML::XPath::Node::TextImpl;

use vars qw/@ISA/;
@ISA = ('XML::XPath::NodeImpl', 'XML::XPath::Node::Text');
use XML::XPath::Node ':node_keys';

sub new {
    my $class = shift;
    my ($text) = @_;
    
        my $pos = XML::XPath::Node->nextPos;
        
        my @vals;
        @vals[node_global_pos, node_text] = ($pos, $text);
    my $self = \@vals;
        
    bless $self, $class;
}

sub getNodeType { TEXT_NODE }

sub isTextNode { 1; }

sub appendText {
    my $self = shift;
    my ($text) = @_;
    $self->[node_text] .= $text;
}

sub getNodeValue {
    my $self = shift;
    $self->[node_text];
}

sub getData {
    my $self = shift;
    $self->[node_text];
}

sub setNodeValue {
    my $self = shift;
    $self->[node_text] = shift;
}

sub _to_sax {
    my $self = shift;
    my ($doch, $dtdh, $enth) = @_;
    
    $doch->characters( { Data => $self->getValue } );
}

sub string_value {
    my $self = shift;
    $self->[node_text];
}

sub toString {
    my $self = shift;
    XML::XPath::Node::XMLescape($self->[node_text], "<&");
}

1;
__END__

=head1 NAME

Text - an XML text node

=head1 API

=head2 new ( text )

Create a new text node.

=head2 getValue / getData

Returns the text

=head2 string_value

Returns the text

=head2 appendText ( text )

Adds the given text string to this node.

=cut
