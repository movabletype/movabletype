# $Id: Element.pm 4532 2004-05-11 05:15:40Z ezra $

package XML::XPath::Node::Element;

use strict;
use vars qw/@ISA/;

@ISA = ('XML::XPath::Node');

package XML::XPath::Node::ElementImpl;

use vars qw/@ISA/;
@ISA = ('XML::XPath::NodeImpl', 'XML::XPath::Node::Element');
use XML::XPath::Node ':node_keys';

sub new {
    my $class = shift;
    my ($tag, $prefix) = @_;
        
    my $pos = XML::XPath::Node->nextPos;

    my @vals;
    @vals[node_global_pos, node_prefix, node_children, node_name, node_attribs] =
            ($pos, $prefix, [], $tag, []);
        
    my $self = \@vals;
    bless $self, $class;
}

sub getNodeType { ELEMENT_NODE }

sub isElementNode { 1; }

sub appendChild {
    my $self = shift;
    my $newnode = shift;
    if (shift) { # called from internal to XML::XPath
#    warn "AppendChild $newnode to $self\n";
        push @{$self->[node_children]}, $newnode;
        $newnode->setParentNode($self);
        $newnode->set_pos($#{$self->[node_children]});
    }
    else {
        if (@{$self->[node_children]}) {
            $self->insertAfter($newnode, $self->[node_children][-1]);
        }
        else {
            my $pos_number = $self->get_global_pos() + 1;
            
            if (my $brother = $self->getNextSibling()) { # optimisation
                if ($pos_number == $brother->get_global_pos()) {
                    $self->renumber('following::node()', +5);
                }
            }
            else {
                eval {
                    if ($pos_number == 
                            $self->findnodes(
                                'following::node()'
                                )->get_node(1)->get_global_pos()) {
                        $self->renumber('following::node()', +5);
                    }
                };
            }
            
            push @{$self->[node_children]}, $newnode;
            $newnode->setParentNode($self);
            $newnode->set_pos($#{$self->[node_children]});
            $newnode->set_global_pos($pos_number);
        }
    }
}

sub removeChild {
    my $self = shift;
    my $delnode = shift;
    
    my $pos = $delnode->get_pos;
    
#    warn "removeChild: $pos\n";
    
#    warn "children: ", scalar @{$self->[node_children]}, "\n";
    
#    my $node = $self->[node_children][$pos];
#    warn "child at $pos is: $node\n";
    
    splice @{$self->[node_children]}, $pos, 1;
    
#    warn "children now: ", scalar @{$self->[node_children]}, "\n";
    
    for (my $i = $pos; $i < @{$self->[node_children]}; $i++) {
#        warn "Changing pos of child: $i\n";
        $self->[node_children][$i]->set_pos($i);
    }
    
    $delnode->del_parent_link;
    
}

sub appendIdElement {
    my $self = shift;
    my ($val, $element) = @_;
#    warn "Adding '$val' to ID hash\n";
    $self->[node_ids]{$val} = $element;
}

sub DESTROY {
    my $self = shift;
#    warn "DESTROY ELEMENT: ", $self->[node_name], "\n";
#    warn "DESTROY ROOT\n" unless $self->[node_name];
    
    foreach my $kid ($self->getChildNodes) {
        $kid && $kid->del_parent_link;
    }
    foreach my $attr ($self->getAttributeNodes) {
        $attr && $attr->del_parent_link;
    }
    foreach my $ns ($self->getNamespaceNodes) {
        $ns && $ns->del_parent_link;
    }
#     $self->[node_children] = undef;
#     $self->[node_attribs] = undef;
#     $self->[node_namespaces] = undef;
}

sub getName {
    my $self = shift;
    $self->[node_name];
}

sub getTagName {
    shift->getName(@_);
}

sub getLocalName {
    my $self = shift;
    my $local = $self->[node_name];
    $local =~ s/.*://;
    return $local;
}

sub getChildNodes {
    my $self = shift;
    return wantarray ? @{$self->[node_children]} : $self->[node_children];
}

sub getChildNode {
    my $self = shift;
    my ($pos) = @_;
    if ($pos < 1 || $pos > @{$self->[node_children]}) {
        return;
    }
    return $self->[node_children][$pos - 1];
}

sub getFirstChild {
    my $self = shift;
    return unless @{$self->[node_children]};
    return $self->[node_children][0];
}

sub getLastChild {
    my $self = shift;
    return unless @{$self->[node_children]};
    return $self->[node_children][-1];
}

sub getAttributeNode {
    my $self = shift;
    my ($name) = @_;
    my $attribs = $self->[node_attribs];
    foreach my $attr (@$attribs) {
        return $attr if $attr->getName eq $name;
    }
}

sub getAttribute {
    my $self = shift;
    my $attr = $self->getAttributeNode(@_);
    if ($attr) {
        return $attr->getValue;
    }
}

sub getAttributes {
    my $self = shift;
    if ($self->[node_attribs]) {
        return wantarray ? @{$self->[node_attribs]} : $self->[node_attribs];
    }
    return wantarray ? () : [];
}

sub appendAttribute {
    my $self = shift;
    my $attribute = shift;
    
    if (shift) { # internal call
        push @{$self->[node_attribs]}, $attribute;
        $attribute->setParentNode($self);
        $attribute->set_pos($#{$self->[node_attribs]});
    }
    else {
        my $node_num;
        if (@{$self->[node_attribs]}) {
            $node_num = $self->[node_attribs][-1]->get_global_pos() + 1;
        }
        else {
            $node_num = $self->get_global_pos() + 1;
        }
        
        eval {
            if (@{$self->[node_children]}) {
                if ($node_num == $self->[node_children][-1]->get_global_pos()) {
                    $self->renumber('descendant::node() | following::node()', +5);
                }
            }
            elsif ($node_num == 
                    $self->findnodes('following::node()')->get_node(1)->get_global_pos()) {
                $self->renumber('following::node()', +5);
            }
        };
        
        push @{$self->[node_attribs]}, $attribute;
        $attribute->setParentNode($self);
        $attribute->set_pos($#{$self->[node_attribs]});
        $attribute->set_global_pos($node_num);
        
    }
}

sub removeAttribute {
    my $self = shift;
    my $attrib = shift;
    
    if (!ref($attrib)) {
        $attrib = $self->getAttributeNode($attrib);
    }
    
    my $pos = $attrib->get_pos;
    
    splice @{$self->[node_attribs]}, $pos, 1;
    
    for (my $i = $pos; $i < @{$self->[node_attribs]}; $i++) {
        $self->[node_attribs][$i]->set_pos($i);
    }
    
    $attrib->del_parent_link;
}

sub setAttribute {
    my $self = shift;
    my ($name, $value) = @_;
    
    if (my $attrib = $self->getAttributeNode($name)) {
        $attrib->setNodeValue($value);
        return $attrib;
    }
    
    my ($nsprefix) = ($name =~ /^($XML::XPath::Parser::NCName):($XML::XPath::Parser::NCName)$/o);
    
    if ($nsprefix && !$self->getNamespace($nsprefix)) {
        die "No namespace matches prefix: $nsprefix";
    }
    
    my $newnode = XML::XPath::Node::Attribute->new($name, $value, $nsprefix);
    $self->appendAttribute($newnode);
}

sub setAttributeNode {
    my $self = shift;
    my ($node) = @_;
    
    if (my $attrib = $self->getAttributeNode($node->getName)) {
        $attrib->setNodeValue($node->getValue);
        return $attrib;
    }
    
    my ($nsprefix) = ($node->getName() =~ /^($XML::XPath::Parser::NCName):($XML::XPath::Parser::NCName)$/o);
    
    if ($nsprefix && !$self->getNamespace($nsprefix)) {
        die "No namespace matches prefix: $nsprefix";
    }
    
    $self->appendAttribute($node);
}

sub getNamespace {
    my $self = shift;
    my ($prefix) = @_;
    $prefix ||= $self->getPrefix || '#default';
    my $namespaces = $self->[node_namespaces] || [];
    foreach my $ns (@$namespaces) {
        return $ns if $ns->getPrefix eq $prefix;
    }
    my $parent = $self->getParentNode;
    
    return $parent->getNamespace($prefix) if $parent;
}

sub getNamespaces {
    my $self = shift;
    if ($self->[node_namespaces]) {
        return wantarray ? @{$self->[node_namespaces]} : $self->[node_namespaces];
    }
    return wantarray ? () : [];
}

sub getNamespaceNodes { goto &getNamespaces }

sub appendNamespace {
    my $self = shift;
    my ($ns) = @_;
    push @{$self->[node_namespaces]}, $ns;
    $ns->setParentNode($self);
    $ns->set_pos($#{$self->[node_namespaces]});
}

sub getPrefix {
    my $self = shift;
    $self->[node_prefix];
}

sub getExpandedName {
    my $self = shift;
    warn "Expanded name not implemented for ", ref($self), "\n";
    return;
}

sub _to_sax {
    my $self = shift;
    my ($doch, $dtdh, $enth) = @_;
    
    my $tag = $self->getName;
    my @attr;
    
    for my $attr ($self->getAttributes) {
        push @attr, $attr->getName, $attr->getValue;
    }
    
    my $ns = $self->getNamespace($self->[node_prefix]);
    if ($ns) {
        $doch->start_element( 
                { 
                Name => $tag,
                Attributes => { @attr },
                NamespaceURI => $ns->getExpanded,
                Prefix => $ns->getPrefix,
                LocalName => $self->getLocalName,
                }
            );
    }
    else {
        $doch->start_element(
                {
                Name => $tag,
                Attributes => { @attr },
                }
            );
    }
    
    for my $kid ($self->getChildNodes) {
        $kid->_to_sax($doch, $dtdh, $enth);
    }
    
    if ($ns) {
        $doch->end_element( 
                {
                Name => $tag,
                NamespaceURI => $ns->getExpanded,
                Prefix => $ns->getPrefix,
                LocalName => $self->getLocalName
                }
            );
    }
    else {
        $doch->end_element( { Name => $tag } );
    }
}

sub string_value {
    my $self = shift;
    my $string = '';
    foreach my $kid (@{$self->[node_children]}) {
        if ($kid->getNodeType == ELEMENT_NODE
                || $kid->getNodeType == TEXT_NODE) {
            $string .= $kid->string_value;
        }
    }
    return $string;
}

sub toString {
    my $self = shift;
    my $norecurse = shift;
    my $string = '';
    if (! $self->[node_name] ) {
            # root node
            return join('', map { $_->toString($norecurse) } @{$self->[node_children]});
    }
    $string .= "<" . $self->[node_name];
    
        $string .= join('', map { $_->toString } @{$self->[node_namespaces]});
    
        $string .= join('', map { $_->toString } @{$self->[node_attribs]});
    
    if (@{$self->[node_children]}) {
        $string .= ">";

        if (!$norecurse) {
                        $string .= join('', map { $_->toString($norecurse) } @{$self->[node_children]});
        }
        
        $string .= "</" . $self->[node_name] . ">";
    }
    else {
        $string .= " />";
    }
    
    return $string;
}

1;
__END__

=head1 NAME

Element - an <element>

=head1 API

=head2 new ( name, prefix )

Create a new Element node with name "name" and prefix "prefix". The name
be "prefix:local" if prefix is defined. I know that sounds wierd, but it
works ;-)

=head2 getName

Returns the name (including "prefix:" if defined) of this element.

=head2 getLocalName

Returns just the local part of the name (the bit after "prefix:").

=head2 getChildNodes

Returns the children of this element. In list context returns a list. In
scalar context returns an array ref.

=head2 getChildNode ( pos )

Returns the child at position pos.

=head2 appendChild ( childnode )

Appends the child node to the list of current child nodes.

=head2 getAttribute ( name )

Returns the attribute node with key name.

=head2 getAttributes / getAttributeNodes

Returns the attribute nodes. In list context returns a list. In scalar
context returns an array ref.

=head2 appendAttribute ( attrib_node)

Appends the attribute node to the list of attributes (XML::XPath stores
attributes in order).

=head2 getNamespace ( prefix )

Returns the namespace node by the given prefix

=head2 getNamespaces / getNamespaceNodes

Returns the namespace nodes. In list context returns a list. In scalar
context returns an array ref.

=head2 appendNamespace ( ns_node )

Appends the namespace node to the list of namespaces.

=head2 getPrefix

Returns the prefix of this element

=head2 getExpandedName

Returns the expanded name of this element (not yet implemented right).

=head2 string_value

For elements, the string_value is the concatenation of all string_values
of all text-descendants of the element node in document order.

=head2 toString ( [ norecurse ] )

Output (and all children) the node to a string. Doesn't process children
if the norecurse option is a true value.

=cut
