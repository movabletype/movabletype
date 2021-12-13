package XML::SAX::Writer::XML;
$XML::SAX::Writer::XML::VERSION = '0.57';
use strict;
use warnings;
use XML::NamespaceSupport   qw();
@XML::SAX::Writer::XML::ISA = qw(XML::SAX::Writer);

# ABSTRACT: XML::SAX::Writer's SAX Handler

###
# Robin Berjon <robin@knowscape.com>
###


#-------------------------------------------------------------------#
# start_document
#-------------------------------------------------------------------#
sub start_document {
    my $self = shift;

    $self->setConverter;
    $self->setEscaperRegex;
    $self->setAttributeEscaperRegex;
    $self->setCommentEscaperRegex;

    $self->{NSDecl} = [];
    $self->{NSHelper} = XML::NamespaceSupport->new({ xmlns => 1, fatal_errors => 0 });
    $self->{NSHelper}->pushContext;

    $self->setConsumer;
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# end_document
#-------------------------------------------------------------------#
sub end_document {
    my $self = shift;
    # we may need to do a little more here
    $self->{NSHelper}->popContext;
    return $self->{Consumer}->finalize
        if $self->{Consumer}->can( 'finalize' );
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# start_element
#-------------------------------------------------------------------#
sub start_element {
    my $self = shift;
    my $data = shift;
    $self->_output_element;
    my $attr = $data->{Attributes};

    # fix the namespaces and prefixes of what we're receiving, in case
    # something is wrong
    if ($data->{NamespaceURI}) {
        my $uri = $self->{NSHelper}->getURI($data->{Prefix}) || '';
        if ($uri ne $data->{NamespaceURI}) { # ns has precedence
            $data->{Prefix} = $self->{NSHelper}->getPrefix($data->{NamespaceURI}); # random, but correct
            $data->{Name} = $data->{Prefix} ? "$data->{Prefix}:$data->{LocalName}" : "$data->{LocalName}";
        }
    }
    elsif ($data->{Prefix}) { # we can't have a prefix and no NS
        $data->{Name}   = $data->{LocalName};
        $data->{Prefix} = '';
    }

    # create a hash containing the attributes so that we can ensure there is
    # no duplication. Also, we check that ns are properly declared, that the
    # Name is good, etc...
    my %attr_hash;
    for my $at (values %$attr) {
        next unless length $at->{Name}; # people have trouble with autovivification
        if ($at->{NamespaceURI}) {
            my $uri = $self->{NSHelper}->getURI($at->{Prefix});
            warn "Well formed error: prefix '$at->{Prefix}' is not bound to any URI" unless defined $uri;
            if (defined $uri and $uri ne $at->{NamespaceURI}) { # ns has precedence
                $at->{Prefix} = $self->{NSHelper}->getPrefix($at->{NamespaceURI}); # random, but correct
                $at->{Name} = $at->{Prefix} ? "$at->{Prefix}:$at->{LocalName}" : "$at->{LocalName}";
            }
        }
        elsif ($at->{Prefix}) { # we can't have a prefix and no NS
            $at->{Name}   = $at->{LocalName};
            $at->{Prefix} = '';
        }
        $attr_hash{$at->{Name}} = $at->{Value};
    }

    for my $nd (@{$self->{NSDecl}}) {
        if ($nd->{Prefix}) {
            $attr_hash{'xmlns:' . $nd->{Prefix}} = $nd->{NamespaceURI};
        }
        else {
            $attr_hash{'xmlns'} = $nd->{NamespaceURI};
        }
    }
    $self->{NSDecl} = [];

    # build a string from what we have, and buffer it
    my $el = '<' . $data->{Name};
    for my $k (keys %attr_hash) {
        $el .= ' ' . $k . qq[=$self->{QuoteCharacter}] . $self->escapeAttribute($attr_hash{$k}) . qq[$self->{QuoteCharacter}];
    }

    $self->{BufferElement} = $el;
    $self->{NSHelper}->pushContext;
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# end_element
#-------------------------------------------------------------------#
sub end_element {
    my $self = shift;
    my $data = shift;

    my $el;
    if ($self->{BufferElement}) {
        $el = $self->{BufferElement} . ' />';
    }
    else {
        $el = '</' . $data->{Name} . '>';
    }
    $el = $self->safeConvert($el);
    $self->{Consumer}->output($el);
    $self->{NSHelper}->popContext;
    $self->{BufferElement} = '';
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# characters
#-------------------------------------------------------------------#
sub characters {
    my $self = shift;
    my $data = shift;
    $self->_output_element;

    my $char = $data->{Data};
    if ($self->{InCDATA}) {
        # we must scan for ]]> in the CDATA and escape it if it
        # is present by close--opening
        # we need to have buffer text in front of this...
        $char = join ']]>]]&lt;<![CDATA[', split ']]>', $char;
    }
    else {
        $char = $self->escape($char);
    }
    $char = $self->safeConvert($char);
    $self->{Consumer}->output($char);
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# start_prefix_mapping
#-------------------------------------------------------------------#
sub start_prefix_mapping {
    my $self = shift;
    my $data = shift;

    push @{$self->{NSDecl}}, $data;
    $self->{NSHelper}->declarePrefix($data->{Prefix}, $data->{NamespaceURI});
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# end_prefix_mapping
#-------------------------------------------------------------------#
sub end_prefix_mapping {}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# processing_instruction
#-------------------------------------------------------------------#
sub processing_instruction {
    my $self = shift;
    my $data = shift;
    $self->_output_element;
    $self->_output_dtd;

    my $pi = "<?$data->{Target} $data->{Data}?>";
    $pi = $self->safeConvert($pi);
    $self->{Consumer}->output($pi);
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# ignorable_whitespace
#-------------------------------------------------------------------#
sub ignorable_whitespace {
    my $self = shift;
    my $data = shift;
    $self->_output_element;

    my $char = $data->{Data};
    $char = $self->escape($char);
    $char = $self->safeConvert($char);
    $self->{Consumer}->output($char);
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# skipped_entity
#-------------------------------------------------------------------#
sub skipped_entity {
    my $self = shift;
    my $data = shift;
    $self->_output_element;
    $self->_output_dtd;

    my $ent;
    if ($data->{Name} =~ m/^%/) {
        $ent = $data->{Name} . ';';

    } elsif ($data->{Name} eq '[dtd]') {
	# ignoring

    } else {
        $ent = '&' . $data->{Name} . ';';
    }

    $ent = $self->safeConvert($ent);
    $self->{Consumer}->output($ent);

}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# notation_decl
#-------------------------------------------------------------------#
sub notation_decl {
    my $self = shift;
    my $data = shift;
    $self->_output_dtd;

    # I think that param entities are normalized before this
    my $not = "    <!NOTATION " . $data->{Name};
    if ($data->{PublicId} and $data->{SystemId}) {
        $not .= ' PUBLIC \'' . $self->escape($data->{PublicId}) . '\' \'' . $self->escape($data->{SystemId}) . '\'';
    }
    elsif ($data->{PublicId}) {
        $not .= ' PUBLIC \'' . $self->escape($data->{PublicId}) . '\'';
    }
    else {
        $not .= ' SYSTEM \'' . $self->escape($data->{SystemId}) . '\'';
    }
    $not .= " >\n";

    $not = $self->safeConvert($not);
    $self->{Consumer}->output($not);
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# unparsed_entity_decl
#-------------------------------------------------------------------#
sub unparsed_entity_decl {
    my $self = shift;
    my $data = shift;
    $self->_output_dtd;

    # I think that param entities are normalized before this
    my $ent = "    <!ENTITY " . $data->{Name};
    if ($data->{PublicId}) {
        $ent .= ' PUBLIC \'' . $self->escape($data->{PublicId}) . '\' \'' . $self->escape($data->{SystemId}) . '\'';
    }
    else {
        $ent .= ' SYSTEM \'' . $self->escape($data->{SystemId}) . '\'';
    }
    $ent .= " NDATA $data->{Notation} >\n";

    $ent = $self->safeConvert($ent);
    $self->{Consumer}->output($ent);
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# element_decl
#-------------------------------------------------------------------#
sub element_decl {
    my $self = shift;
    my $data = shift;
    $self->_output_dtd;

    # I think that param entities are normalized before this
    my $eld = "    <!ELEMENT " . $data->{Name} . ' ' . $data->{Model} . " >\n";

    $eld = $self->safeConvert($eld);
    $self->{Consumer}->output($eld);
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# attribute_decl
#-------------------------------------------------------------------#
sub attribute_decl {
    my $self = shift;
    my $data = shift;
    $self->_output_dtd;

    # to be backward compatible with Perl SAX 2.0
    $data->{Mode} = $data->{ValueDefault} 
      if not(exists $data->{Mode}) and exists $data->{ValueDefault};

    # I think that param entities are normalized before this
    my $atd = "      <!ATTLIST " . $data->{eName} . ' ' . $data->{aName} . ' ';
    $atd   .= $data->{Type} . ' ' . $data->{Mode} . ' ';
    $atd   .= $data->{Value} . ' ' if $data->{Value};
    $atd   .= " >\n";

    $atd = $self->safeConvert($atd);
    $self->{Consumer}->output($atd);
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# internal_entity_decl
#-------------------------------------------------------------------#
sub internal_entity_decl {
    my $self = shift;
    my $data = shift;
    $self->_output_dtd;

    # I think that param entities are normalized before this
    my $ent = "    <!ENTITY " . $data->{Name} . ' \'' . $self->escape($data->{Value}) . "' >\n";
    $ent = $self->safeConvert($ent);
    $self->{Consumer}->output($ent);
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# external_entity_decl
#-------------------------------------------------------------------#
sub external_entity_decl {
    my $self = shift;
    my $data = shift;
    $self->_output_dtd;

    # I think that param entities are normalized before this
    my $ent = "    <!ENTITY " . $data->{Name};
    if ($data->{PublicId}) {
        $ent .= ' PUBLIC \'' . $self->escape($data->{PublicId}) . '\' \'' . $self->escape($data->{SystemId}) . '\'';
    }
    else {
        $ent .= ' SYSTEM \'' . $self->escape($data->{SystemId}) . '\'';
    }
    $ent .= " >\n";

    $ent = $self->safeConvert($ent);
    $self->{Consumer}->output($ent);
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# comment
#-------------------------------------------------------------------#
sub comment {
    my $self = shift;
    my $data = shift;
    $self->_output_element;
    $self->_output_dtd;

    my $cmt = '<!--' . $self->escapeComment($data->{Data}) . '-->';
    $cmt = $self->safeConvert($cmt);
    $self->{Consumer}->output($cmt);
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# start_dtd
#-------------------------------------------------------------------#
sub start_dtd {
    my $self = shift;
    my $data = shift;

    my $dtd = '<!DOCTYPE ' . $data->{Name};
    if ($data->{PublicId}) {
        $dtd .= ' PUBLIC \'' . $self->escape($data->{PublicId}) . '\' \'' . $self->escape($data->{SystemId}) . '\'';
    }
    elsif ($data->{SystemId}) {
        $dtd .= ' SYSTEM \'' . $self->escape($data->{SystemId}) . '\'';
    }

    $self->{BufferDTD} = $dtd;
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# end_dtd
#-------------------------------------------------------------------#
sub end_dtd {
    my $self = shift;
    my $data = shift;

    my $dtd;
    if ($self->{BufferDTD}) {
        $dtd = $self->{BufferDTD} . ' >';
    }
    else {
        $dtd = ' ]>';
    }
    $dtd = $self->safeConvert($dtd);
    $self->{Consumer}->output($dtd);
    $self->{BufferDTD} = '';
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# start_cdata
#-------------------------------------------------------------------#
sub start_cdata {
    my $self = shift;
    $self->_output_element;

    $self->{InCDATA} = 1;
    my $cds = $self->{Encoder}->convert('<![CDATA[');
    $self->{Consumer}->output($cds);
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# end_cdata
#-------------------------------------------------------------------#
sub end_cdata {
    my $self = shift;

    $self->{InCDATA} = 0;
    my $cds = $self->{Encoder}->convert(']]>');
    $self->{Consumer}->output($cds);
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# start_entity
#-------------------------------------------------------------------#
sub start_entity {
    my $self = shift;
    my $data = shift;
    $self->_output_element;
    $self->_output_dtd;

    my $ent;
    if ($data->{Name} eq '[dtd]') {
        # we ignore the fact that we're dealing with an external
        # DTD entity here, and probably shouldn't write the DTD
        # events unless explicitly told to
        # this will probably change
    }
    elsif ($data->{Name} =~ m/^%/) {
        $ent = $data->{Name} . ';';
    }
    else {
        $ent = '&' . $data->{Name} . ';';
    }

    $ent = $self->safeConvert($ent);
    $self->{Consumer}->output($ent);
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# end_entity
#-------------------------------------------------------------------#
sub end_entity {
    # depending on what is done above, we might need to do sth here
}
#-------------------------------------------------------------------#


### SAX1 stuff ######################################################

#-------------------------------------------------------------------#
# xml_decl
#-------------------------------------------------------------------#
sub xml_decl {
    my $self = shift;
    my $data = shift;

    # version info is compulsory, contrary to what some seem to think
    # also, there's order in the pseudo-attr
    my $xd = '';
    if ($data->{Version}) {
        $xd .= "<?xml version=\"$data->{Version}\"";
        if ($data->{Encoding}) {
            $xd .= " encoding=\"$data->{Encoding}\"";
        }
        if ($data->{Standalone}) {
            $xd .= " standalone=\"$data->{Standalone}\"";
        }
        $xd .= "?>\n";
    }

    #$xd = $self->{Encoder}->convert($xd); # this may blow up
    $self->{Consumer}->output($xd);
}
#-------------------------------------------------------------------#


#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#
#`,`, Helpers `,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,#
#```````````````````````````````````````````````````````````````````#

#-------------------------------------------------------------------#
# _output_element
#-------------------------------------------------------------------#
sub _output_element {
    my $self = shift;

    if ($self->{BufferElement}) {
        my $el = $self->{BufferElement} . '>';
	$el = $self->safeConvert($el);
        $self->{Consumer}->output($el);
        $self->{BufferElement} = '';
    }
}
#-------------------------------------------------------------------#

#-------------------------------------------------------------------#
# _output_dtd
#-------------------------------------------------------------------#
sub _output_dtd {
    my $self = shift;

    if ($self->{BufferDTD}) {
        my $dtd = $self->{BufferDTD} . " [\n";
	$dtd = $self->safeConvert($dtd);
        $self->{Consumer}->output($dtd);
        $self->{BufferDTD} = '';
    }
}
#-------------------------------------------------------------------#

1;
#,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#
#`,`, Documentation `,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,`,#
#```````````````````````````````````````````````````````````````````#

__END__

=pod

=encoding UTF-8

=head1 NAME

XML::SAX::Writer::XML - XML::SAX::Writer's SAX Handler

=head1 VERSION

version 0.57

=head1 SYNOPSIS

  ...

=head1 DESCRIPTION

...

=head1 SEE ALSO

XML::SAX::*

=head1 AUTHORS

=over 4

=item *

Robin Berjon <robin@knowscape.com>

=item *

Chris Prather <chris@prather.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Robin Berjon.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
