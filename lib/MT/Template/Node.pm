# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Template::Node;

use strict;
use base qw( Class::Accessor::Fast );

sub NODE_TEXT ()     { 1 }
sub NODE_BLOCK ()    { 2 }
sub NODE_FUNCTION () { 3 }

use MT::Util qw( weaken );

__PACKAGE__->mk_accessors(qw( tag attributes childNodes nodeValue attribute_list ));

sub mk_wref_accessor {
    my ($class, $field) = @_;
    return sub {
        return $_[0]->{$field} unless @_ > 1;
        my $self = shift;
        weaken($self->{$field} = (@_ == 1 ? $_[0] : [@_]));
    };
}
__PACKAGE__->_mk_accessors('mk_wref_accessor', qw( parentNode template ));

sub new {
    my $pkg = shift;
    my ($self) = ref $_[0] ? @_ : {@_};
    bless $self, $pkg;
    weaken($self->{parentNode})if defined $self->{parentNode};
    weaken($self->{template}) if defined $self->{template};
    $self;
}

sub setAttribute {
    my $node = shift;
    my ($attr, $val) = @_;
    if ($attr eq 'id') {
        # assign into ids
        my $tmpl = $node->template;
        my $ids = $tmpl->token_ids;
        my $old_id = $node->getAttribute("id");
        if ($old_id && $ids) {
            delete $ids->{$old_id};
        }
    }
    elsif ($attr eq 'class') {
        # assign into classes
        my $tmpl = $node->template;
        my $classes = $tmpl->token_classes;
        my $old_class = $node->getAttribute("class");
        if ($old_class && $classes->{$old_class}) {
            @{$classes->{$old_class}} = grep { $_ != $node }
                @{$classes->{$old_class}};
        }
        push @{$classes->{$val} ||= []}, $node;
    }
    ($node->{attributes} ||= {})->{$attr} = $val;
}

sub getAttribute {
    my $node = shift;
    my ($attr) = @_;
    ($node->attributes || {})->{$attr};
}

sub firstChild {
    my $node = shift;
    my $children = $node->childNodes or return undef;
    @$children ? $children->[0] : undef;
}

sub lastChild {
    my $node = shift;
    my $children = $node->childNodes or return undef;
    @$children ? $children->[scalar @$children - 1] : undef;
}

sub nextSibling {
    my $node = shift;
    my $siblings = $node->parentNode->childNodes;
    my $max = (scalar @$siblings) - 1;
    return undef unless $max;
    my $last = $siblings->[0];
    foreach my $n ($siblings->[1..$max]) {
        return $n if $node == $last;
        $last = $n;
    }
    return $siblings->[$max] if $node == $last;
    return undef;
}

sub previousSibling {
    my $node = shift;
    my $siblings = $node->parentNode->childNodes;
    my $last;
    foreach my $n (@$siblings) {
        return $last if $node == $n;
        $last = $n;
    }
    return undef;
}

sub ownerDocument { #template
    my $node = shift;
    return $node->template;
}

sub hasChildNodes {
    my $node = shift;
    my $children = $node->childNodes;
    $children && (@$children) ? 1 : 0;
}

sub nodeType {
    my $node = shift;
    if ($node->tag eq 'TEXT') {
        return NODE_TEXT();
    } elsif (defined $node->childNodes) {
        return NODE_BLOCK();
    } else {
        return NODE_FUNCTION();
    }
}

sub nodeName {
    my $node = shift;
    my $tag = $node->tag;
    if ($tag eq 'TEXT') {
        return undef;
    }
    # normalize:
    #    MTEntry => mt:entry
    #    MTAPP:WIDGET => mtapp:widget
    $tag = lc $tag;
    if (($tag !~ m/:/) && ($tag =~ m/^mt/)) {
        $tag =~ s/^mt/mt:/;
    }
    return $tag;
}

sub innerHTML {
    my $node = shift;
    if (@_) {
        my ($text) = @_;
        $node->nodeValue($text);
        require MT::Builder;
        my $builder = new MT::Builder;
        require MT::Template::Context;
        my $ctx = MT::Template::Context->new;
        $node->childNodes($builder->compile($ctx, $text));
        my $tmpl = $node->ownerDocument;
        if ($tmpl) {
            $tmpl->reset_markers;
            $tmpl->{reflow_flag} = 1;
        }
    }
    return $node->nodeValue;
}

# TBD: what about new nodes that are added with id elements?
sub appendChild {
    my $node = shift;
    my ($new_node) = @_;
    my $nodes = $node->childNodes;
    push @$nodes, $new_node;
    my $tmpl = $node->ownerDocument;
    if ($tmpl) {
        $tmpl->{reflow_flag} = 1;
    }
}

sub removeChild {
    my $node = shift;
}

*inner_html = \&innerHTML;
*append_child = \&appendChild;
*insert_before = \&insertBefore;
*remove_child = \&removeChild;

1;
__END__
