# $Id: XMLParser.pm 4532 2004-05-11 05:15:40Z ezra $

package XML::XPath::XMLParser;

use strict;

use XML::Parser;
#use XML::XPath;
use XML::XPath::Node;
use XML::XPath::Node::Element;
use XML::XPath::Node::Text;
use XML::XPath::Node::Comment;
use XML::XPath::Node::PI;
use XML::XPath::Node::Attribute;
use XML::XPath::Node::Namespace;

my @options = qw(
        filename
        xml
        parser
        ioref
        );

my ($_current, $_namespaces_on);
my %IdNames;

use vars qw/$xmlns_ns $xml_ns/;

$xmlns_ns = "http://www.w3.org/2000/xmlns/";
$xml_ns = "http://www.w3.org/XML/1998/namespace";

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my %args = @_;
    my %hash = map(( "_$_" => $args{$_} ), @options);
    bless \%hash, $class;
}

sub parse {
    my $self = shift;
    
    $self->{IdNames} = {};
    $self->{InScopeNamespaceStack} = [ { 
            '_Default' => undef,
            'xmlns' => $xmlns_ns,
            'xml' => $xml_ns,
        } ];
    
    $self->{NodeStack} = [ ];
    
    $self->set_xml($_[0]) if $_[0];
    
    my $parser = $self->get_parser || XML::Parser->new(
            ErrorContext => 2,
            ParseParamEnt => 1,
            );
    
    $parser->setHandlers(
            Init => sub { $self->parse_init(@_) },
            Char => sub { $self->parse_char(@_) },
            Start => sub { $self->parse_start(@_) },
            End => sub { $self->parse_end(@_) },
            Final => sub { $self->parse_final(@_) },
            Proc => sub { $self->parse_pi(@_) },
            Comment => sub { $self->parse_comment(@_) },
            Attlist => sub { $self->parse_attlist(@_) },
            );
    
    my $toparse;
    if ($toparse = $self->get_filename) {
        return $parser->parsefile($toparse);
    }
    else {
        return $parser->parse($self->get_xml || $self->get_ioref);
    }
}

sub parsefile {
    my $self = shift;
    my ($filename) = @_;
    $self->set_filename($filename);
    $self->parse;
}

sub parse_init {
    my $self = shift;
    my $e = shift;
    my $document = XML::XPath::Node::Element->new();
    my $newns = XML::XPath::Node::Namespace->new('xml', $xml_ns);
    $document->appendNamespace($newns);
    $self->{current} = $self->{DOC_Node} = $document;
}

sub parse_final {
    my $self = shift;
    return $self->{DOC_Node};
}

sub parse_char {
    my $self = shift;
    my $e = shift;
    my $text = shift;
    
    my $parent = $self->{current};
    
    my $last = $parent->getLastChild;
    if ($last && $last->isTextNode) {
        # append to previous text node
        $last->appendText($text);
        return;
    }
    
    my $node = XML::XPath::Node::Text->new($text);
    $parent->appendChild($node, 1);
}

sub parse_start {
    my $self = shift;
    my $e = shift;
    my $tag = shift;
    
    push @{ $self->{InScopeNamespaceStack} },
         { %{ $self->{InScopeNamespaceStack}[-1] } };
    $self->_scan_namespaces(@_);
    
    my ($prefix, $namespace) = $self->_namespace($tag);
    
    my $node = XML::XPath::Node::Element->new($tag, $prefix);
    
    my @attributes;
    for (my $ii = 0; $ii < $#_; $ii += 2) {
	my ($name, $value) = ($_[$ii], $_[$ii+1]);
        if ($name =~ /^xmlns(:(.*))?$/) {
            # namespace node
            my $prefix = $2 || '#default';
#            warn "Creating NS node: $prefix = $value\n";
            my $newns = XML::XPath::Node::Namespace->new($prefix, $value);
            $node->appendNamespace($newns);
        }
        else {
	    my ($prefix, $namespace) = $self->_namespace($name);
            undef $namespace unless $prefix;

            my $newattr = XML::XPath::Node::Attribute->new($name, $value, $prefix);
            $node->appendAttribute($newattr, 1);
            if (exists($self->{IdNames}{$tag}) && ($self->{IdNames}{$tag} eq $name)) {
    #            warn "appending Id Element: $val for ", $node->getName, "\n";
                $self->{DOC_Node}->appendIdElement($value, $node);
            }
        }
    }
        
    $self->{current}->appendChild($node, 1);
    $self->{current} = $node;
}

sub parse_end {
    my $self = shift;
    my $e = shift;
    $self->{current} = $self->{current}->getParentNode;
}

sub parse_pi {
    my $self = shift;
    my $e = shift;
    my ($target, $data) = @_;
    my $node = XML::XPath::Node::PI->new($target, $data);
    $self->{current}->appendChild($node, 1);
}

sub parse_comment {
    my $self = shift;
    my $e = shift;
    my ($data) = @_;
    my $node = XML::XPath::Node::Comment->new($data);
    $self->{current}->appendChild($node, 1);
}

sub parse_attlist {
    my $self = shift;
    my $e = shift;
    my ($elname, $attname, $type, $default, $fixed) = @_;
    if ($type eq 'ID') {
        $self->{IdNames}{$elname} = $attname;
    }
}

sub _scan_namespaces {
    my ($self, %attributes) = @_;

    while (my ($attr_name, $value) = each %attributes) {
	if ($attr_name eq 'xmlns') {
	    $self->{InScopeNamespaceStack}[-1]{'_Default'} = $value;
	} elsif ($attr_name =~ /^xmlns:(.*)$/) {
	    my $prefix = $1;
	    $self->{InScopeNamespaceStack}[-1]{$prefix} = $value;
	}
    }
}

sub _namespace {
    my ($self, $name) = @_;

    my ($prefix, $localname) = split(/:/, $name);
    if (!defined($localname)) {
	if ($prefix eq 'xmlns') {
	    return '', undef;
	} else {
	    return '', $self->{InScopeNamespaceStack}[-1]{'_Default'};
	}
    } else {
	return $prefix, $self->{InScopeNamespaceStack}[-1]{$prefix};
    }
}

sub as_string {
    my $node = shift;
    $node->toString;
}

sub get_parser { shift->{_parser}; }
sub get_filename { shift->{_filename}; }
sub get_xml { shift->{_xml}; }
sub get_ioref { shift->{_ioref}; }

sub set_parser { $_[0]->{_parser} = $_[1]; }
sub set_filename { $_[0]->{_filename} = $_[1]; }
sub set_xml { $_[0]->{_xml} = $_[1]; }
sub set_ioref { $_[0]->{_ioref} = $_[1]; }

1;

__END__

=head1 NAME

XML::XPath::XMLParser - The default XML parsing class that produces a node tree

=head1 SYNOPSIS

    my $parser = XML::XPath::XMLParser->new(
                filename => $self->get_filename,
                xml => $self->get_xml,
                ioref => $self->get_ioref,
                parser => $self->get_parser,
            );
    my $root_node = $parser->parse;

=head1 DESCRIPTION

This module generates a node tree for use as the context node for XPath processing.
It aims to be a quick parser, nothing fancy, and yet has to store more information
than most parsers. To achieve this I've used array refs everywhere - no hashes.
I don't have any performance figures for the speedups achieved, so I make no
appologies for anyone not used to using arrays instead of hashes. I think they
make good sense here where we know the attributes of each type of node.

=head1 Node Structure

All nodes have the same first 2 entries in the array: node_parent
and node_pos. The type of the node is determined using the ref() function.
The node_parent always contains an entry for the parent of the current
node - except for the root node which has undef in there. And node_pos is the
position of this node in the array that it is in (think: 
$node == $node->[node_parent]->[node_children]->[$node->[node_pos]] )

Nodes are structured as follows:

=head2 Root Node

The root node is just an element node with no parent.

    [
      undef, # node_parent - check for undef to identify root node
      undef, # node_pos
      undef, # node_prefix
      [ ... ], # node_children (see below)
    ]

=head2 Element Node

    [
      $parent, # node_parent
      <position in current array>, # node_pos
      'xxx', # node_prefix - namespace prefix on this element
      [ ... ], # node_children
      'yyy', # node_name - element tag name
      [ ... ], # node_attribs - attributes on this element
      [ ... ], # node_namespaces - namespaces currently in scope
    ]

=head2 Attribute Node

    [
      $parent, # node_parent - the element node
      <position in current array>, # node_pos
      'xxx', # node_prefix - namespace prefix on this element
      'href', # node_key - attribute name
      'ftp://ftp.com/', # node_value - value in the node
    ]

=head2 Namespace Nodes

Each element has an associated set of namespace nodes that are currently
in scope. Each namespace node stores a prefix and the expanded name (retrieved
from the xmlns:prefix="..." attribute).

    [
      $parent,
      <pos>,
      'a', # node_prefix - the namespace as it was written as a prefix
      'http://my.namespace.com', # node_expanded - the expanded name.
    ]

=head2 Text Nodes

    [
      $parent,
      <pos>,
      'This is some text' # node_text - the text in the node
    ]

=head2 Comment Nodes

    [
      $parent,
      <pos>,
      'This is a comment' # node_comment
    ]

=head2 Processing Instruction Nodes

    [
      $parent,
      <pos>,
      'target', # node_target
      'data', # node_data
    ]

=head1 Usage

If you feel the need to use this module outside of XML::XPath (for example
you might use this module directly so that you can cache parsed trees), you
can follow the following API:

=head2 new

The new method takes either no parameters, or any of the following parameters:

        filename
        xml
        parser
        ioref

This uses the familiar hash syntax, so an example might be:

    use XML::XPath::XMLParser;
    
    my $parser = XML::XPath::XMLParser->new(filename => 'example.xml');

The parameters represent a filename, a string containing XML, an XML::Parser
instance and an open filehandle ref respectively. You can also set or get all
of these properties using the get_ and set_ functions that have the same
name as the property: e.g. get_filename, set_ioref, etc.

=head2 parse

The parse method generally takes no parameters, however you are free to
pass either an open filehandle reference or an XML string if you so require.
The return value is a tree that XML::XPath can use. The parse method will
die if there is an error in your XML, so be sure to use perl's exception
handling mechanism (eval{};) if you want to avoid this.

=head2 parsefile

The parsefile method is identical to parse() except it expects a single
parameter that is a string naming a file to open and parse. Again it
returns a tree and also dies if there are XML errors.

=head1 NOTICES

This file is distributed as part of the XML::XPath module, and is copyright
2000 Fastnet Software Ltd. Please see the documentation for the module as a
whole for licencing information.
