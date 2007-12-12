# $Id: Builder.pm 4532 2004-05-11 05:15:40Z ezra $

package XML::XPath::Builder;

use strict;

# to get array index constants
use XML::XPath::Node;
use XML::XPath::Node::Element;
use XML::XPath::Node::Attribute;
use XML::XPath::Node::Namespace;
use XML::XPath::Node::Text;
use XML::XPath::Node::PI;
use XML::XPath::Node::Comment;

use vars qw/$xmlns_ns $xml_ns/;

$xmlns_ns = "http://www.w3.org/2000/xmlns/";
$xml_ns = "http://www.w3.org/XML/1998/namespace";

sub new {
    my $class = shift;
    my $self = ($#_ == 0) ? { %{ (shift) } } : { @_ };

    bless $self, $class;
}

sub start_document {
    my $self = shift;

    $self->{IdNames} = {};
    $self->{InScopeNamespaceStack} = [ { 
            '_Default' => undef,
            'xmlns' => $xmlns_ns,
            'xml' => $xml_ns,
        } ];
    
    $self->{NodeStack} = [ ];
    
    my $document = XML::XPath::Node::Element->new();
    my $newns = XML::XPath::Node::Namespace->new('xml', $xml_ns);
    $document->appendNamespace($newns);
    $self->{current} = $self->{DOC_Node} = $document;
}

sub end_document {
    my $self = shift;
    
    return $self->{DOC_Node};
}

sub characters {
    my $self = shift;
    my $sarg = shift;
    my $text = $sarg->{Data};
    
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

sub start_element {
    my $self = shift;
    my $sarg = shift;
    my $tag  = $sarg->{'Name'};
    my $attr = $sarg->{'Attributes'};

    push @{ $self->{InScopeNamespaceStack} },
         { %{ $self->{InScopeNamespaceStack}[-1] } };
    $self->_scan_namespaces(@_);
    
    my ($prefix, $namespace) = $self->_namespace($tag);
    
    my $node = XML::XPath::Node::Element->new($tag, $prefix);
    
    foreach my $name (keys %$attr) {
	my $value = $attr->{$name};

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

sub end_element {
    my $self = shift;
    $self->{current} = $self->{current}->getParentNode;
}

sub processing_instruction {
    my $self = shift;
    my $pi = shift;
    my $node = XML::XPath::Node::PI->new($pi->{Target}, $pi->{Data});
    $self->{current}->appendChild($node, 1);
}

sub comment {
    my $self = shift;
    my $comment = shift;
    my $node = XML::XPath::Node::Comment->new($comment->{Data});
    $self->{current}->appendChild($node, 1);
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

1;

__END__

=head1 NAME

XML::XPath::Builder - SAX handler for building an XPath tree

=head1 SYNOPSIS

 use AnySAXParser;
 use XML::XPath::Builder;

 $builder = XML::XPath::Builder->new();
 $parser = AnySAXParser->new( Handler => $builder );

 $root_node = $parser->parse( Source => [SOURCE] );

=head1 DESCRIPTION

C<XML::XPath::Builder> is a SAX handler for building an XML::XPath
tree.

C<XML::XPath::Builder> is used by creating a new instance of
C<XML::XPath::Builder> and providing it as the Handler for a SAX
parser.  Calling `C<parse()>' on the SAX parser will return the
root node of the tree built from that parse.

=head1 AUTHOR

Ken MacLeod, <ken@bitsko.slc.ut.us>

=head1 SEE ALSO

perl(1), XML::XPath(3)

PerlSAX.pod in libxml-perl

Extensible Markup Language (XML) <http://www.w3c.org/XML>

=cut
