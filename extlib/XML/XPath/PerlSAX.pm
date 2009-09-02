# $Id: PerlSAX.pm 4532 2004-05-11 05:15:40Z ezra $

package XML::XPath::PerlSAX;
use XML::XPath::XMLParser;
use strict;

sub new {
	my $class = shift;
	my %args = @_;
	bless \%args, $class;
}

sub parse {
	my $self = shift;

	die "XML::XPath::PerlSAX: parser instance ($self) already parsing\n"
		if (defined $self->{ParseOptions});

	# If there's one arg and it's an array ref, assume it's a node we're parsing
	my $args;
	if (@_ == 1 && ref($_[0]) =~ /^(text|comment|element|namespace|attribute|pi)$/) {
#		warn "Parsing node\n";
		my $node = shift;
#		warn "PARSING: $node ", XML::XPath::XMLParser::as_string($node), "\n\n";
		$args = { Source => { Node => $node } };
	}
	else {
		$args = (@_ == 1) ? shift : { @_ };
	}

	my $parse_options = { %$self, %$args };
	$self->{ParseOptions} = $parse_options;

	# ensure that we have at least one source
	if (!defined $parse_options->{Source} ||
		!defined $parse_options->{Source}{Node}) {
		die "XML::XPath::PerlSAX: no source defined for parse\n";
	}

	# assign default Handler to any undefined handlers
	if (defined $parse_options->{Handler}) {
		$parse_options->{DocumentHandler} = $parse_options->{Handler}
			if (!defined $parse_options->{DocumentHandler});
	}

	# ensure that we have a DocumentHandler
	if (!defined $parse_options->{DocumentHandler}) {
		die "XML::XPath::PerlSAX: no Handler or DocumentHandler defined for parse\n";
	}

	# cache DocumentHandler in self for callbacks
	$self->{DocumentHandler} = $parse_options->{DocumentHandler};

	if ((ref($parse_options->{Source}{Node}) eq 'element') &&
			!($parse_options->{Source}{Node}->[node_parent])) {
		# Got root node
		$self->{DocumentHandler}->start_document( { } );
		$self->parse_node($parse_options->{Source}{Node});
		return $self->{DocumentHandler}->end_document( { } );
	}
	else {
		$self->parse_node($parse_options->{Source}{Node});
	}

	# clean up parser instance
	delete $self->{ParseOptions};
	delete $self->{DocumentHandler};

}

sub parse_node {
	my $self = shift;
	my $node = shift;
#	warn "parse_node $node\n";
	if (ref($node) eq 'element' && $node->[node_parent]) {
		# bundle up attributes
		my @attribs;
		foreach my $attr (@{$node->[node_attribs]}) {
			if ($attr->[node_prefix]) {
				push @attribs, $attr->[node_prefix] . ":" . $attr->[node_key];
			}
			else {
				push @attribs, $attr->[node_key];
			}
			push @attribs, $attr->[node_value];
		}
		
		$self->{DocumentHandler}->start_element(
				{ Name => $node->[node_name],
				  Attributes => \@attribs,
				}
			);
		foreach my $kid (@{$node->[node_children]}) {
			$self->parse_node($kid);
		}
		$self->{DocumentHandler}->end_element(
				{
					Name => $node->[node_name],
				}
			);
	}
	elsif (ref($node) eq 'text') {
		$self->{DocumentHandler}->characters($node->[node_text]);
	}
	elsif (ref($node) eq 'comment') {
		$self->{DocumentHandler}->comment($node->[node_comment]);
	}
	elsif (ref($node) eq 'pi') {
		$self->{DocumentHandler}->processing_instruction(
				{
					Target => $node->[node_target],
					Data => $node->[node_data]
				}
			);
	}
	elsif (ref($node) eq 'element') { # root node
		# just do kids
		foreach my $kid (@{$node->[node_children]}) {
			$self->parse_node($kid);
		}
	}
	else {
		die "Unknown node type: '", ref($node), "' ", scalar(@$node), "\n";
	}
}

1;

__END__

=head1 NAME

XML::XPath::PerlSAX - A PerlSAX event generator for my wierd node structure

=head1 SYNOPSIS

	use XML::XPath;
	use XML::XPath::PerlSAX;
	use XML::DOM::PerlSAX;
	
	my $xp = XML::XPath->new(filename => 'test.xhtml');
	my $paras = $xp->find('/html/body/p');
	
	my $handler = XML::DOM::PerlSAX->new();
	my $generator = XML::XPath::PerlSAX->new( Handler => $handler );
	
	foreach my $node ($paras->get_nodelist) {
		my $domtree = $generator->parse($node);
		# do something with $domtree
	}

=head1 DESCRIPTION

This module generates PerlSAX events to pass to a PerlSAX handler such
as XML::DOM::PerlSAX. It operates specifically on my wierd tree format.

Unfortunately SAX doesn't seem to cope with namespaces, so these are
lost completely. I believe SAX2 is doing namespaces.

=head1 Other

The XML::DOM::PerlSAX handler I tried was completely broken (didn't even
compile before I patched it a bit), so I don't know how correct this
is or how far it will work.

This software may only be distributed as part of the XML::XPath package.
