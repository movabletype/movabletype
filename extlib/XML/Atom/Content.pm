# $Id: Content.pm 29346 2006-05-19 23:59:07Z bchoate $

package XML::Atom::Content;
use strict;
use base qw( XML::Atom::ErrorHandler );

use XML::Atom;
use XML::Atom::Util qw( set_ns remove_default_ns hack_unicode_entity );
use MIME::Base64 qw( encode_base64 decode_base64 );

sub new {
    my $class = shift;
    my $content = bless {}, $class;
    $content->init(@_) or return $class->error($content->errstr);
    $content;
}

sub init {
    my $content = shift;
    my %param = @_ == 1 ? (Body => $_[0]) : @_;
    $content->set_ns(\%param);
    my $elem;
    unless ($elem = $param{Elem}) {
        if (LIBXML) {
            my $doc = XML::LibXML::Document->createDocument('1.0', 'utf-8');
            $elem = $doc->createElementNS($content->ns, 'content');
            $doc->setDocumentElement($elem);
        } else {
            $elem = XML::XPath::Node::Element->new('content');
        }
    }
    $content->{elem} = $elem;
    if ($param{Body}) {
        $content->body($param{Body});
    }
    if ($param{Type}) {
        $content->type($param{Type});
    }
    $content;
}

sub ns   { $_[0]->{ns} }
sub elem { $_[0]->{elem} }

sub type {
    my $content = shift;
    if (@_) {
        $content->elem->setAttribute('type', shift);
    }
    $content->elem->getAttribute('type');
}

sub mode {
    my $content = shift;
    $content->elem->getAttribute('mode');
}

sub lang { $_[0]->elem->getAttribute('lang') }
sub base { $_[0]->elem->getAttribute('base') }

sub body {
    my $content = shift;
    my $elem = $content->elem;
    if (@_) {
        my $data = shift;
        if (LIBXML) {
            $elem->removeChildNodes;
        } else {
            $elem->removeChild($_) for $elem->getChildNodes;
        }
        if (!_is_printable($data)) {
            if ($] >= 5.008) {
                require Encode;
                Encode::_utf8_off($data);
            }
            if (LIBXML) {
               $elem->appendChild(XML::LibXML::Text->new(encode_base64($data, '')));
            } else {
               $elem->appendChild(XML::XPath::Node::Text->new(encode_base64($data, '')));
            }
            $elem->setAttribute('mode', 'base64');
        } else {
            my $copy = '<div xmlns="http://www.w3.org/1999/xhtml">' .
                       $data .
                       '</div>';
            my $node;
            eval {
                if (LIBXML) {
                    my $parser = XML::LibXML->new;
                    my $tree = $parser->parse_string($copy);
                    $node = $tree->getDocumentElement;
                } else {
                    my $xp = XML::XPath->new(xml => $copy);
                    $node = (($xp->find('/')->get_nodelist)[0]->getChildNodes)[0]
                        if $xp;
                }
            };
            if (!$@ && $node) {
                $elem->appendChild($node);
                $elem->setAttribute('mode', 'xml');
            } else {
                if (LIBXML) {
                    $elem->appendChild(XML::LibXML::Text->new($data));
                } else {
                    $elem->appendChild(XML::XPath::Node::Text->new($data));
                }
                $elem->setAttribute('mode', 'escaped');
            }
        }
    } else {
        unless (exists $content->{__body}) {
            my $mode = $elem->getAttribute('mode') || 'xml';
            if ($mode eq 'xml') {
                my @children = grep ref($_) =~ /Element/,
                    LIBXML ? $elem->childNodes : $elem->getChildNodes;
                if (@children) {
                    if (@children == 1 && $children[0]->getLocalName eq 'div') {
                        @children =
                            LIBXML ? $children[0]->childNodes :
                                     $children[0]->getChildNodes
                    }
                    $content->{__body} = '';
                    for my $n (@children) {
                        remove_default_ns($n) if LIBXML;
                        $content->{__body} .= $n->toString(LIBXML ? 1 : 0);
                    }
                } else {
                    $content->{__body} = LIBXML ? $elem->textContent : $elem->string_value;
                }
                if ($] >= 5.008) {
                    $content->{__body} = hack_unicode_entity($content->{__body});
                }
            } elsif ($mode eq 'base64') {
                my $raw = decode_base64(LIBXML ? $elem->textContent : $elem->string_value);
                if ($content->type && $content->type =~ m!^text/!) {
                    $content->{__body} = eval { require Encode; Encode::decode("utf-8", $raw) } || $raw;
                } else {
                    $content->{__body} = $raw;
                }
#                $content->{__body} = Encode::decode("utf-8", $raw);
            } elsif ($mode eq 'escaped') {
                $content->{__body} = LIBXML ? $elem->textContent : $elem->string_value;
            } else {
                $content->{__body} = undef;
            }
        }
    }
    $content->{__body};
}

sub _is_printable {
    my $data = shift;

    # try decoding this $data with UTF-8
    my $decoded;
    eval {
        require Encode;
        $decoded = Encode::is_utf8($data) ? $data : Encode::decode("utf-8", $data, Encode::FB_CROAK());
    };
    $decoded = $data if $@;

    return $decoded =~ /^[[:print:]]*$/ if $] < 5.008;
    return $decoded =~ /^\p{IsPrint}*$/;
}

sub as_xml {
    my $content = shift;
    if (LIBXML) {
        my $doc = XML::LibXML::Document->new('1.0', 'utf-8');
        $doc->setDocumentElement($content->elem);
        return $doc->toString(1);
    } else {
        return $content->elem->toString;
    }
}

1;
