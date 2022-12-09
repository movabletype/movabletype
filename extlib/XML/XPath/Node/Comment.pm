package XML::XPath::Node::Comment;

use strict;
use warnings;
use parent qw/XML::XPath::Node/;

our $VERSION = '1.48';

package XML::XPath::Node::CommentImpl;

use XML::XPath::Node ':node_keys';
use parent qw/-norequire XML::XPath::NodeImpl XML::XPath::Node::Comment/;

sub new {
    my $class = shift;
    my ($comment) = @_;

        my $pos = XML::XPath::Node->nextPos;

        my @vals;
        @vals[node_global_pos, node_comment] =
                ($pos, $comment);
    my $self = \@vals;

    bless $self, $class;
}

sub getNodeType { COMMENT_NODE }

sub isCommentNode { 1; }

sub getNodeValue {
    return shift->[node_comment];
}

sub getData {
    shift->getNodeValue;
}

sub setNodeValue {
    shift->[node_comment] = shift;
}

sub _to_sax {
    my $self = shift;
    my ($doch, $dtdh, $enth) = @_;

    $doch->comment( { Data => $self->getValue } );
}

sub comment_escape {
    my $data = shift;
    $data =~ s/--/&#45;&#45;/g;
    return $data;
}

sub string_value {
    my $self = shift;
    return $self->[node_comment];
}

sub toString {
    my $self = shift;
    return '<!--' . comment_escape($self->[node_comment]) . '-->';
}

1;
__END__

=head1 NAME

Comment - an XML comment: <!--comment-->

=head1 API

=head2 new ( data )

Create a new comment node.

=head2 getValue / getData

Returns the value in the comment

=head2 toString

Returns the comment with -- encoded as a numeric entity (if it
exists in the comment text).

=cut
