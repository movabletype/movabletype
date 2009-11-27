# $Id$

package XML::Atom::Content;
use strict;
use base qw( XML::Atom::Base );

__PACKAGE__->mk_attr_accessors(qw( type mode ));
__PACKAGE__->mk_xml_attr_accessors(qw( lang base ));

use Encode;
use XML::Atom;
use MIME::Base64 qw( encode_base64 decode_base64 );

sub element_name { 'content' }

sub init {
    my $content = shift;
    my %param = @_ == 1 ? (Body => $_[0]) : @_;
    $content->SUPER::init(%param);
    if ($param{Body}) {
        $content->body($param{Body});
    }
    if ($param{Type}) {
        $content->type($param{Type});
    }
    return $content;
}

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
            Encode::_utf8_off($data);
            if (LIBXML) {
               $elem->appendChild(XML::LibXML::Text->new(encode_base64($data, '')));
            } else {
               $elem->appendChild(XML::XPath::Node::Text->new(encode_base64($data, '')));
            }

            if ($content->version == 0.3) {
                $content->mode('base64');
            }
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
                if ($content->version == 0.3) {
                    $content->mode('xml');
                } else {
                    $content->type('xhtml');
                }
            } else {
                if (LIBXML) {
                    $elem->appendChild(XML::LibXML::Text->new($data));
                } else {
                    $elem->appendChild(XML::XPath::Node::Text->new($data));
                }

                if ($content->version == 0.3) {
                    $content->mode('escaped');
                } else {
                    $content->type($data =~ /^\s*</ ? 'html' : 'text');
                }
            }
        }
    } else {
        unless (exists $content->{__body}) {
            my $mode;

            if ($content->version == 0.3) {
                $mode = $content->mode || 'xml';
            } else {
                $mode =
                    $content->type eq 'xhtml'         ? 'xml'
                  : $content->type =~ m![/\+]xml$!    ? 'xml'
                  : $content->type eq 'html'          ? 'escaped'
                  : $content->type eq 'text'          ? 'escaped'
                  : $content->type =~ m!^text/!       ? 'escaped'
                  :                                     'base64';
            }

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
                        $content->{__body} .= $n->toString(LIBXML ? 1 : 0);
                    }
                } else {
                    $content->{__body} = LIBXML ? $elem->textContent : $elem->string_value;
                }
                if ($] >= 5.008) {
                    Encode::_utf8_off($content->{__body}) unless $XML::Atom::ForceUnicode;
                }
            } elsif ($mode eq 'base64') {
                my $raw = decode_base64(LIBXML ? $elem->textContent : $elem->string_value);
                if ($content->type && $content->type =~ m!^text/!) {
                    $content->{__body} = eval { Encode::decode("utf-8", $raw) } || $raw;
                    Encode::_utf8_off($content->{__body}) unless $XML::Atom::ForceUnicode;
                } else {
                    $content->{__body} = $raw;
                }
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

    local $@;
    # try decoding this $data with UTF-8
    my $decoded =
        ( Encode::is_utf8($data)
          ? $data
          : eval { Encode::decode("utf-8", $data, Encode::FB_CROAK) } );

    return ! $@ && $decoded =~ /^\p{IsPrint}*$/;
}

1;
