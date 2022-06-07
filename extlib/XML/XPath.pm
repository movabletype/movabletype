package XML::XPath;

=head1 NAME

XML::XPath - Parse and evaluate XPath statements.

=head1 VERSION

Version 1.44

=cut

use strict; use warnings;
use vars qw($VERSION $AUTOLOAD $revision);

$VERSION = '1.44';
$XML::XPath::Namespaces = 1;
$XML::XPath::ParseParamEnt = 1;
$XML::XPath::Debug = 0;

use Data::Dumper;
use XML::XPath::XMLParser;
use XML::XPath::Parser;
use IO::File;

# Parameters for new()
my @options = qw(
        filename
        parser
        xml
        ioref
        context
        );

=head1 DESCRIPTION

This module aims to comply exactly to the XPath specification at http://www.w3.org/TR/xpath
and yet allow extensions to be added in the form of functions.Modules such as XSLT
and XPointer may need to do this as they support functionality beyond XPath.

=head1 SYNOPSIS

    use XML::XPath;
    use XML::XPath::XMLParser;

    my $xp = XML::XPath->new(filename => 'test.xhtml');

    my $nodeset = $xp->find('/html/body/p'); # find all paragraphs

    foreach my $node ($nodeset->get_nodelist) {
        print "FOUND\n\n",
            XML::XPath::XMLParser::as_string($node),
            "\n\n";
    }

=head1 DETAILS

There is an awful lot to  all  of  this, so bear with it - if you stick it out it
should be worth it. Please get a good understanding of XPath by reading  the spec
before asking me questions. All of the classes and parts  herein are named to  be
synonymous  with  the  names in  the  specification, so consult that if you don't
understand why I'm doing something in the code.

=head1 METHODS

The API of XML::XPath itself is extremely simple to allow you to get going almost
immediately. The deeper API's are more complex, but you  shouldn't  have to touch
most of that.

=head2 new()

This  constructor follows  the often seen named parameter method call. Parameters
you can use are: filename, parser, xml, ioref and context. The filename parameter
specifies  an  XML  file to parse. The xml parameter specifies a string to parse,
and the ioref parameter specifies  an ioref to  parse. The context  option allows
you to specify a context node. The context node has to be in the format of a node
as specified in L<XML::XPath::XMLParser>. The 4  parameters  filename, xml, ioref
and context are mutually exclusive - you should only  specify one (if you specify
anything other than context, the context node is the root of your document).  The
parser  option  allows  you to pass in an already prepared XML::Parser object, to
save you having to create more than one in your application (if, for example, you
are doing more than just XPath).

    my $xp = XML::XPath->new( context => $node );

It is very much recommended that you use only 1 XPath object  throughout the life
of  your  application. This is because the object (and it's sub-objects) maintain
certain  bits  of state information that will be useful (such as XPath variables)
to later  calls  to find().  It's also a good idea because you'll use less memory
this way.

=cut

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;

    my(%args);
    # Try to figure out what the user passed
    if ($#_ == 0) { # passed a scalar
        my $string = $_[0];
        if ($string =~ m{<.*?>}s) { # it's an XML string
            $args{'xml'} = $string;
        } elsif (ref($string)) {    # read XML from file handle
            $args{'ioref'} = $string;
        } elsif ($string eq '-') {  # read XML from stdin
            $args{'ioref'} = IO::File->new($string);
        } else {                    # read XML from a file
            $args{'filename'} = $string;
        }
    } else {        # passed a hash or hash reference
        # just pass the parameters on to the XPath constructor
        %args = ((ref($_[0]) eq "HASH") ? %{$_[0]} : @_);
    }

    if ($args{filename} && (!-e $args{filename} || !-r $args{filename})) {
        die "Cannot open file '$args{filename}'";
    }

    my %hash = map(( "_$_" => $args{$_} ), @options);
    $hash{path_parser} = XML::XPath::Parser->new();
    return bless \%hash, $class;
}

=head2 find($path, [$context])

The find function takes an XPath expression (a string) and returns either an XML::XPath::NodeSet
object  containing the nodes it found (or empty if no nodes matched the path), or
one of L<XML::XPath::Literal> (a string), L<XML::XPath::Number> or L<XML::XPath::Boolean>.
It should always return something - and you can use ->isa()  to find out  what it
returned. If you need to check how many nodes it found you should check $nodeset->size.
See L<XML::XPath::NodeSet>. An optional second parameter of a context node allows
you to use this method repeatedly, for example XSLT needs to do this.

=cut

sub find {
    my ($self, $path, $context) = @_;

    die "No path to find" unless $path;

    if (!defined $context) {
        $context = $self->get_context;
    }

    if (!defined $context) {
        # Still no context? Need to parse.
        my $parser = XML::XPath::XMLParser->new(
                filename => $self->get_filename,
                xml      => $self->get_xml,
                ioref    => $self->get_ioref,
                parser   => $self->get_parser,
        );
        $context = $parser->parse;
        $self->set_context($context);
        print "CONTEXT:\n", Dumper([$context], ['context']) if $XML::XPath::Debug;
    }

    my $parsed_path = $self->{path_parser}->parse($path);
    print "\n\nPATH: ", $parsed_path->as_string, "\n\n" if $XML::XPath::Debug;

    #warn "evaluating path\n";
    return $parsed_path->evaluate($context);
}

=head2 findnodes($path, [$context])

Returns a list of nodes found by $path, optionally in context $context. In scalar
context returns an XML::XPath::NodeSet object.

=cut

sub findnodes {
    my ($self, $path, $context) = @_;

    my $results = $self->find($path, $context);

    if ($results->isa('XML::XPath::NodeSet')) {
        return wantarray ? $results->get_nodelist : $results;
    }

    # warn("findnodes returned a ", ref($results), " object\n") if $XML::XPath::Debug;
    return wantarray ? () : XML::XPath::NodeSet->new();
}

=head2 matches($node, $path, [$context])

Returns true if the node matches the path (optionally in context $context).

=cut

sub matches {
    my $self = shift;
    my ($node, $path, $context) = @_;

    my @nodes = $self->findnodes($path, $context);

    if (grep { "$node" eq "$_" } @nodes) {
        return 1;
    }
    return;
}

=head2 findnodes_as_string($path, [$context])

Returns the nodes found reproduced as XML.The result isn't guaranteed to be valid
XML though.

=cut

sub findnodes_as_string {
    my ($self, $path, $context) = @_;

    my $results = $self->find($path, $context);

    if ($results->isa('XML::XPath::NodeSet')) {
        return join('', map { $_->toString } $results->get_nodelist);
    }
    elsif ($results->isa('XML::XPath::Node')) {
        return $results->toString;
    }
    else {
        return XML::XPath::Node::XMLescape($results->value);
    }
}

=head2 findvalue($path, [$context])

Returns either a C<XML::XPath::Literal>, a C<XML::XPath::Boolean> or a C<XML::XPath::Number>
object.If the path returns a NodeSet,$nodeset->to_literal is called automatically
for you (and thus a C<XML::XPath::Literal> is returned).Note that for each of the
objects stringification is overloaded, so you can just print the  value found, or
manipulate it in the ways you would a normal perl value (e.g. using regular expressions).

=cut

sub findvalue {
    my ($self, $path, $context) = @_;

    my $results = $self->find($path, $context);
    if ($results->isa('XML::XPath::NodeSet')) {
        return $results->to_literal;
    }

    return $results;
}

=head2 exists($path, [$context])

Returns true if the given path exists.

=cut

sub exists {
    my ($self, $path, $context) = @_;

    $path = '/' if (!defined $path);
    my @nodeset = $self->findnodes($path, $context);
    return 1 if (scalar( @nodeset ));
    return 0;
}

sub getNodeAsXML {
    my ($self, $node_path) = @_;

    $node_path = '/' if (!defined $node_path);
    if (ref($node_path)) {
        return $node_path->as_string();
    } else {
        return $self->findnodes_as_string($node_path);
    }
}

=head2 getNodeText($path)

Returns the L<XML::XPath::Literal> for a particular XML node. Returns a string if
exists or '' (empty string) if the node doesn't exist.

=cut

sub getNodeText {
    my ($self, $node_path) = @_;

    if (ref($node_path)) {
        return $node_path->string_value();
    } else {
        return $self->findvalue($node_path);
    }
}

=head2 setNodeText($path, $text)

Sets the text string for a particular XML node.  The node can be an element or an
attribute. If the node to be set is an attribute, and the attribute node does not
exist, it will be created automatically.

=cut

sub setNodeText {
    my ($self, $node_path, $new_text) = @_;

    my $nodeset = $self->findnodes($node_path);
    return undef if (!defined $nodeset);

    my @nodes = $nodeset->get_nodelist;
    if ($#nodes < 0) {
        if ($node_path =~ m{/(?:@|attribute::)([^/]+)$}) {
            # attribute not found, so try to create it

            # Based upon the 'perlvar' documentation located at:
            # http://perldoc.perl.org/perlvar.html
            #
            # The @LAST_MATCH_START section indicates that there's a more efficient
            # version of $` that can be used.
            #
            # Specifically, after a match against some variable $var:
            #    * $` is the same as substr($var, 0, $-[0])
            my $parent_path = substr($node_path, 0, $-[0]);
            my $attr = $1;
            $nodeset = $self->findnodes($parent_path);
            return undef if (!defined $nodeset);
            foreach my $node ($nodeset->get_nodelist) {
                my $newnode = XML::XPath::Node::Attribute->new($attr, $new_text);
                return undef if (!defined $newnode);
                $node->appendAttribute($newnode);
            }
        } else {
            return undef;
        }
    }

    foreach my $node (@nodes) {
        if ($node->getNodeType == XML::XPath::Node::ATTRIBUTE_NODE) {
            $node->setNodeValue($new_text);
        } else {
            foreach my $delnode ($node->getChildNodes()) {
                $node->removeChild($delnode);
            }
            my $newnode = XML::XPath::Node::Text->new($new_text);
            return undef if (!defined $newnode);
            $node->appendChild($newnode);
        }
    }

    return 1;
}

=head2 createNode($path)

Creates the node matching the C<$path> given. If part of the path given or all of
the path do not exist, the necessary nodes will be created automatically.

=cut

sub createNode {
    my ($self, $node_path) = @_;

    my $path_steps = $self->{path_parser}->parse($node_path);
    my @path_steps = ();
    my (undef, @path_steps_lhs) = @{$path_steps->get_lhs()};
    foreach my $step (@path_steps_lhs) { # precompute paths as string
        my $string = $step->as_string();
        push(@path_steps, $string) if (defined $string && $string ne "");
    }

    my $prev_node = undef;
    my $nodeset = undef;
    my $nodes = undef;
    my $p = undef;
    my $test_path = "";

    # Start with the deepest node, working up the path (right to left),
    # trying to find a node that exists.
    for ($p = $#path_steps_lhs; $p >= 0; $p--) {
        my $path = $path_steps_lhs[$p];
        $test_path = "(/" . join("/", @path_steps[0..$p]) . ")";

        $nodeset = $self->findnodes($test_path);
        return undef if (!defined $nodeset); # error looking for node
        $nodes = $nodeset->size;
        return undef if ($nodes > 1); # too many paths - path not specific enough
        if ($nodes == 1) { # found a node -- need to create nodes below it
            $prev_node = $nodeset->get_node(1);
            last;
        }
    }
    if (!defined $prev_node) {
        my @root_nodes = $self->findnodes('/')->get_nodelist();
        $prev_node = $root_nodes[0];
    }

    # We found a node that exists, or we'll start at the root.
    # Create all lower nodes working left to right along the path.
    for ($p++ ; $p <= $#path_steps_lhs; $p++) {
        my $path = $path_steps_lhs[$p];
        my $newnode = undef;

        my $axis = $path->{axis};
        my $name = $path->{literal};

        do {
            if ($axis =~ /^child$/i) {
                if ($name =~ /(\S+):(\S+)/) {
                    $newnode = XML::XPath::Node::Element->new($name, $1);
                } else {
                    $newnode = XML::XPath::Node::Element->new($name);
                }
                return undef if (!defined $newnode); # could not create new node
                $prev_node->appendChild($newnode);
            } elsif ($axis =~ /^attribute$/i) {
                if ($name =~ /(\S+):(\S+)/) {
                    $newnode = XML::XPath::Node::Attribute->new($name, "", $1);
                } else {
                    $newnode = XML::XPath::Node::Attribute->new($name, "");
                }
                return undef if (!defined $newnode); # could not create new node
                $prev_node->appendAttribute($newnode);
            }

            $test_path = "(/" . join("/", @path_steps[0..$p]) . ")";
            $nodeset = $self->findnodes($test_path);
            $nodes = $nodeset->size;
            die "failed to find node '$test_path'" if (!defined $nodeset); # error looking for node
        } while ($nodes < 1);

        $prev_node = $nodeset->get_node(1);
    }

    return $prev_node;
}

sub get_filename {
    my $self = shift;
    $self->{_filename};
}

sub set_filename {
    my $self = shift;
    $self->{_filename} = shift;
}

sub get_parser {
    my $self = shift;
    $self->{_parser};
}

sub set_parser {
    my $self = shift;
    $self->{_parser} = shift;
}

sub get_xml {
    my $self = shift;
    $self->{_xml};
}

sub set_xml {
    my $self = shift;
    $self->{_xml} = shift;
}

sub get_ioref {
    my $self = shift;
    $self->{_ioref};
}

sub set_ioref {
    my $self = shift;
    $self->{_ioref} = shift;
}

sub get_context {
    my $self = shift;
    $self->{_context};
}

sub set_context {
    my $self = shift;
    $self->{_context} = shift;
}

sub cleanup {
    my $self = shift;
    if ($XML::XPath::SafeMode) {
        my $context = $self->get_context;
        return unless $context;
        $context->dispose;
        $self->{path_parser}->cleanup if $self->{path_parser};
    }
}

=head2 set_namespace($prefix, $uri)

Sets the namespace prefix mapping to the uri.

Normally in C<XML::XPath> the prefixes in XPath node test take their context from
the current node. This means that foo:bar will always match an element  <foo:bar>
regardless  of  the  namespace that the prefix foo is mapped to (which might even
change  within  the document, resulting  in unexpected results). In order to make
prefixes in XPath node tests actually map  to a real URI, you need to enable that
via a call to the set_namespace method of your C<XML::XPath> object.

=cut

sub set_namespace {
    my $self = shift;
    my ($prefix, $expanded) = @_;
    $self->{path_parser}->set_namespace($prefix, $expanded);
}

=head2 clear_namespaces()

Clears all previously set namespace mappings.

=cut

sub clear_namespaces {
    my $self = shift;
    $self->{path_parser}->clear_namespaces();
}

=head2 $XML::XPath::Namespaces

Set this to 0  if you I<don't> want namespace processing to occur. This will make
everything a little (tiny) bit faster, but you'll suffer for it, probably.

=head1 Node Object Model

See L<XML::XPath::Node>, L<XML::XPath::Node::Element>,
L<XML::XPath::Node::Text>, L<XML::XPath::Node::Comment>,
L<XML::XPath::Node::Attribute>, L<XML::XPath::Node::Namespace>,
and L<XML::XPath::Node::PI>.

=head1 On Garbage Collection

XPath nodes  work in a special way that allows circular references, and yet still
lets Perl's reference counting garbage collector to clean up the nodes after use.
This should  be  totally  transparent to the user, with one caveat: B<If you free
your tree before letting go of a sub-tree,consider that playing with fire and you
may get burned>. What does this mean to the average user?  Not much. Provided you
don't free (or let go out of scope) either the tree you passed to XML::XPath->new,
or if you didn't  pass a tree, and passed a filename or IO-ref, then provided you
don't  let the XML::XPath object go out of scope before you let results of find()
and its  friends  go out of scope, then you'll be fine. Even if you B<do> let the
tree go out of scope before results, you'll probably still be fine. The only case
where  you  may  get  stung is when the last part of your path/query is either an
ancestor or parent axis. In that case the worst that will happen is you'll end up
with  a  circular  reference that won't get cleared until interpreter destruction
time.You can get around that by explicitly calling $node->DESTROY on each of your
result nodes, if you really need to do that.

Mail me direct if that's not clear. Note that it's not doom and gloom. It's by no
means perfect,but the worst that will happen is a long running process could leak
memory. Most  long  running  processes  will  therefore  be able to explicitly be
careful not to free the tree (or XML::XPath object) before freeing results.AxKit,
an application  that  uses XML::XPath,  does  this  and I didn't have to make any
changes to the code - it's already sensible programming.

If you I<really> don't want all this to happen, then set the variable $XML::XPath::SafeMode,
and call $xp->cleanup() on the XML::XPath object when you're finished, or $tree->dispose()
if you have a tree instead.

=head1 Example

Please see the test files in t/ for examples on how to use XPath.

=head1 AUTHOR

Original author Matt Sergeant, C<< <matt at sergeant.org> >>

Currently maintained by Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 SEE ALSO

L<XML::XPath::Literal>, L<XML::XPath::Boolean>, L<XML::XPath::Number>,
L<XML::XPath::XMLParser>, L<XML::XPath::NodeSet>, L<XML::XPath::PerlSAX>,
L<XML::XPath::Builder>.

=head1 LICENSE AND COPYRIGHT

This module is  copyright  2000 AxKit.com Ltd. This is free software, and as such
comes with NO WARRANTY. No dates are used in this module. You may distribute this
module under the terms  of either the Gnu GPL,  or the Artistic License (the same
terms as Perl itself).

For support, please subscribe to the L<Perl-XML|http://listserv.activestate.com/mailman/listinfo/perl-xml>
mailing list at the URL

=cut

1; # End of XML::XPath
