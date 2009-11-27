# $Id$

package XML::Atom::Base;
use strict;
use base qw( XML::Atom::ErrorHandler Class::Data::Inheritable );

use Encode;
use XML::Atom;
use XML::Atom::Util qw( set_ns first nodelist childlist create_element );

__PACKAGE__->mk_classdata('__attributes', []);

sub new {
    my $class = shift;
    my $obj = bless {}, $class;
    $obj->init(@_) or return $class->error($obj->errstr);
    $obj;
}

sub init {
    my $obj = shift;
    my %param = @_;
    if (!exists $param{Namespace} and my $ns = $obj->element_ns) {
        $param{Namespace} = $ns;
    }
    $obj->set_ns(\%param);
    my $elem;
    unless ($elem = $param{Elem}) {
        if (LIBXML) {
            my $doc = XML::LibXML::Document->createDocument('1.0', 'utf-8');
            my $ns = $obj->ns;
            my ($ns_uri, $ns_prefix);
            if ( ref $ns and $ns->isa('XML::Atom::Namespace') ) {
                $ns_uri     = $ns->{uri};
                $ns_prefix  = $ns->{prefix};
            } else {
                $ns_uri = $ns;
            }
            if ( $ns_uri and $ns_prefix ) {
                $elem = $doc->createElement($obj->element_name);
                $elem->setNamespace( $ns_uri, $ns_prefix, 1 );
            } else {
                $elem = $doc->createElementNS($obj->ns, $obj->element_name);
            }
            $doc->setDocumentElement($elem);
        } else {
            $elem = XML::XPath::Node::Element->new($obj->element_name);
            my $ns = XML::XPath::Node::Namespace->new('#default' => $obj->ns);
            $elem->appendNamespace($ns);
        }
    }
    $obj->{elem} = $elem;
    $obj;
}

sub element_name { }
sub element_ns { }

sub ns   { $_[0]->{ns} }
sub elem { $_[0]->{elem} }

sub version {
    my $atom = shift;
    XML::Atom::Util::ns_to_version($atom->ns);
}

sub content_type {
    my $atom = shift;
    if ($atom->version >= 1.0) {
        return "application/atom+xml";
    } else {
        return "application/x.atom+xml";
    }
}

sub get {
    my $obj = shift;
    my($ns, $name) = @_;
    my @list = $obj->getlist($ns, $name);
    return $list[0];
}

sub getlist {
    my $obj = shift;
    my($ns, $name) = @_;
    my $ns_uri = ref($ns) eq 'XML::Atom::Namespace' ? $ns->{uri} : $ns;
    my @node = nodelist($obj->elem, $ns_uri, $name);
    return map {
        my $val = LIBXML ? $_->textContent : $_->string_value;
        if ($] >= 5.008) {
            require Encode;
            Encode::_utf8_off($val) unless $XML::Atom::ForceUnicode;
        }
        $val;
     } @node;
}

sub add {
    my $obj = shift;
    my($ns, $name, $val, $attr) = @_;
    return $obj->set($ns, $name, $val, $attr, 1);
}

sub set {
    my $obj = shift;
    my($ns, $name, $val, $attr, $add) = @_;
    my $ns_uri = ref $ns eq 'XML::Atom::Namespace' ? $ns->{uri} : $ns;
    my @elem = childlist($obj->elem, $ns_uri, $name);
    if (!$add && @elem) {
        $obj->elem->removeChild($_) for @elem;
    }
    my $elem = create_element($ns, $name);
    if (UNIVERSAL::isa($val, 'XML::Atom::Base')) {
        if (LIBXML) {
            for my $child ($val->elem->childNodes) {
                $elem->appendChild($child->cloneNode(1));
            }
            for my $attr ($val->elem->attributes) {
                next unless ref($attr) eq 'XML::LibXML::Attr';
                $elem->setAttribute($attr->getName, $attr->getValue);
            }
        } else {
            for my $child ($val->elem->getChildNodes) {
                $elem->appendChild($child);
            }
            for my $attr ($val->elem->getAttributes) {
                $elem->appendAttribute($attr);
            }
        }
    } else {
        if (LIBXML) {
            $elem->appendChild(XML::LibXML::Text->new($val));
        } else {
            $elem->appendChild(XML::XPath::Node::Text->new($val));
        }
    }
    $obj->elem->appendChild($elem);
    if ($attr) {
        while (my($k, $v) = each %$attr) {
            $elem->setAttribute($k, $v);
        }
    }
    return $val;
}

sub get_attr {
    my $obj = shift;
    my($attr) = @_;
    my $val = $obj->elem->getAttribute($attr);
    if ($] >= 5.008) {
        require Encode;
        Encode::_utf8_off($val) unless $XML::Atom::ForceUnicode;
    }
    $val;
}

sub set_attr {
    my $obj = shift;
    if (@_ == 2) {
        my($attr, $val) = @_;
        $obj->elem->setAttribute($attr => $val);
    } elsif (@_ == 3) {
        my($ns, $attr, $val) = @_;
        my $attribute = "$ns->{prefix}:$attr";
        if (LIBXML) {
            $obj->elem->setAttributeNS($ns->{uri}, $attribute, $val);
        } else {
            my $ns = XML::XPath::Node::Namespace->new(
                    $ns->{prefix} => $ns->{uri}
                );
            $obj->elem->appendNamespace($ns);
            $obj->elem->setAttribute($attribute => $val);
        }
    }
}

sub get_object {
    my $obj = shift;
    my($ns, $name, $class) = @_;
    my $ns_uri = ref($ns) eq 'XML::Atom::Namespace' ? $ns->{uri} : $ns;
    my @elem = childlist($obj->elem, $ns_uri, $name) or return;
    my @obj = map { $class->new( Elem => $_, Namespace => $ns ) } @elem;
    return wantarray ? @obj : $obj[0];
}

sub mk_elem_accessors {
    my $class = shift;
    my (@list) = @_;
    my $override_ns;

    if ( ref $list[-1] ) {
        my $ns_list = pop @list;
        if ( ref $ns_list eq 'ARRAY' ) {
            $ns_list = $ns_list->[0];
        }
        if ( ref($ns_list) =~ /Namespace/ ) {
            $override_ns = $ns_list;
        } else {
            if ( ref $ns_list eq 'HASH' ) {
                $override_ns = XML::Atom::Namespace->new(%$ns_list);
            }
            elsif ( not ref $ns_list and $ns_list ) {
                $override_ns = $ns_list;
            }
        } 
    }

    no strict 'refs';
    for my $elem ( @list ) {
        (my $meth = $elem) =~ tr/\-/_/;
        *{"${class}::$meth"} = sub {
            my $obj = shift;
            if (@_) {
                return $obj->set( $override_ns || $obj->ns, $elem, $_[0]);
            } else {
                return $obj->get( $override_ns || $obj->ns, $elem);
            }
        };
    }
}

sub mk_attr_accessors {
    my $class = shift;
    my(@list) = @_;
    no strict 'refs';
    for my $attr (@list) {
        (my $meth = $attr) =~ tr/\-/_/;
        *{"${class}::$meth"} = sub {
            my $obj = shift;
            if (@_) {
                return $obj->set_attr($attr => $_[0]);
            } else {
                return $obj->get_attr($attr);
            }
        };
        $class->_add_attribute($attr);
    }
}

sub _add_attribute {
    my($class, $attr) = @_;
    push @{$class->__attributes}, $attr;
}

sub attributes {
    my $class = shift;
    @{ $class->__attributes };
}

sub mk_xml_attr_accessors {
    my($class, @list) = @_;
    no strict 'refs';
    for my $attr (@list) {
        (my $meth = $attr) =~ tr/\-/_/;
        *{"${class}::$meth"} = sub {
            my $obj = shift;
            if (LIBXML) {
                my $elem = $obj->elem;
                if (@_) {
                    $elem->setAttributeNS('http://www.w3.org/XML/1998/namespace',
                                          $attr, $_[0]);
                }
                return $elem->getAttribute("xml:$attr");
            } else {
                if (@_) {
                    $obj->elem->setAttribute("xml:$attr", $_[0]);
                }
                return $obj->elem->getAttribute("xml:$attr");
            }
        };
    }
}

sub mk_object_accessor {
    my $class = shift;
    my($name, $ext_class) = @_;
    no strict 'refs';
    (my $meth = $name) =~ tr/\-/_/;
    *{"${class}::$meth"} = sub {
        my $obj = shift;
        my $ns_uri = $ext_class->element_ns || $obj->ns;
        if (@_) {
            return $obj->set($ns_uri, $name, $_[0]);
        } else {
            return $obj->get_object($ns_uri, $name, $ext_class);
        }
    };
}


sub mk_object_list_accessor {
    my $class = shift;
    my($name, $ext_class, $moniker) = @_;

    no strict 'refs';

    *{"$class\::$name"} = sub {
        my $obj = shift;

        my $ns_uri = $ext_class->element_ns || $obj->ns;
        if (@_) {
            # setter: clear existent elements first
            my @elem = childlist($obj->elem, $ns_uri, $name);
            for my $el (@elem) {
                $obj->elem->removeChild($el);
            }

            # add the new elements for each
            my $adder = "add_$name";
            for my $add_elem (@_) {
                $obj->$adder($add_elem);
            }
        } else {
            # getter: just call get_object which is a context aware
            return $obj->get_object($ns_uri, $name, $ext_class);
        }
    };

    # moniker returns always list: array ref in a scalar context
    if ($moniker) {
        *{"$class\::$moniker"} = sub {
            my $obj = shift;
            if (@_) {
                return $obj->$name(@_);
            } else {
                my @obj = $obj->$name;
                return wantarray ? @obj : \@obj;
            }
        };
    }

    # add_$name
    *{"$class\::add_$name"} = sub {
        my $obj = shift;
        my($stuff) = @_;

        my $ns_uri = $ext_class->element_ns || $obj->ns;
        my $elem = (ref $stuff && UNIVERSAL::isa($stuff, $ext_class)) ?
            $stuff->elem : create_element($ns_uri, $name);
        $obj->elem->appendChild($elem);

        if (ref($stuff) eq 'HASH') {
            for my $k ( $ext_class->attributes ) {
                defined $stuff->{$k} or next;
                $elem->setAttribute($k, $stuff->{$k});
            }
        }
    };
}

sub as_xml {
    my $obj = shift;
    if (LIBXML) {
        my $doc = XML::LibXML::Document->new('1.0', 'utf-8');
        $doc->setDocumentElement($obj->elem->cloneNode(1));
        return $doc->toString(1);
    } else {
        return '<?xml version="1.0" encoding="utf-8"?>' . "\n" .
            $obj->elem->toString;
    }
}

sub as_xml_utf8 {
    my $obj = shift;
    my $xml = $obj->as_xml;
    if (utf8::is_utf8($xml)) {
        return Encode::encode_utf8($xml);
    }
    return $xml;
}

1;
