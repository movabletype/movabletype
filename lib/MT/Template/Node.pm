# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Template::Node;

use strict;
use warnings;
use Exporter 'import';

sub EL_NODE_NAME ()     {0}
sub EL_NODE_ATTR ()     {1}
sub EL_NODE_CHILDREN () {2}
sub EL_NODE_VALUE ()    {3}
sub EL_NODE_ATTRLIST () {4}
sub EL_NODE_PARENT ()   {5}
sub EL_NODE_TEMPLATE () {6}

sub NODE_TEXT ()     {1}
sub NODE_BLOCK ()    {2}
sub NODE_FUNCTION () {3}

our @EXPORT_OK = qw(
    EL_NODE_NAME EL_NODE_ATTR EL_NODE_CHILDREN EL_NODE_VALUE
    EL_NODE_ATTRLIST EL_NODE_PARENT EL_NODE_TEMPLATE
);
our %EXPORT_TAGS = (constants => \@EXPORT_OK);

use MT::Util qw( weaken );
use MT::Util::Encode;

sub mk_wref_accessor {
    my ( $class, $field, $index ) = @_;
    return sub {
        return $_[0]->[$index] unless @_ > 1;
        my $self = shift;
        weaken( $self->[$index] = ( @_ == 1 ? $_[0] : [@_] ) );
    };
}
*parentNode = __PACKAGE__->mk_wref_accessor( 'parentNode', EL_NODE_PARENT );
*template   = __PACKAGE__->mk_wref_accessor( 'template',   EL_NODE_TEMPLATE );

sub new {
    my $pkg = shift;
    my ($param) = ref $_[0] ? $_[0] : {@_};
    my $self = $param->{tag} eq 'TEXT'
        ? [
        'TEXT',
        undef,
        undef,
        delete $param->{nodeValue},
        undef,
        delete $param->{parentNode},
        delete $param->{template},
        ]
        : [
        delete $param->{tag},
        delete $param->{attributes},
        delete $param->{childNodes} || [],
        delete $param->{nodeValue},
        delete $param->{attribute_list},
        delete $param->{parentNode},
        delete $param->{template},
        ];
    bless $self, $pkg;
    weaken( $self->[EL_NODE_PARENT] )   if defined $self->[EL_NODE_PARENT];
    weaken( $self->[EL_NODE_TEMPLATE] ) if defined $self->[EL_NODE_TEMPLATE];
    $self;
}

sub nodeValue {
    my $node = shift;
    $node->[EL_NODE_VALUE] = shift if @_;
    $node->[EL_NODE_VALUE];
}

sub childNodes {
    my $node = shift;
    return $node->[EL_NODE_CHILDREN] = shift if @_;
    return $node->[EL_NODE_CHILDREN] ||= [];
}

sub attributes {
    my $node = shift;
    return {} if $node->[0] eq 'TEXT';
    return $node->[EL_NODE_ATTR] = shift if @_;
    return $node->[EL_NODE_ATTR] ||= {};
}

sub attribute_list {
    my $node = shift;
    return $node->[EL_NODE_ATTRLIST] = shift if @_;
    return $node->[EL_NODE_ATTRLIST] ||= [];
}

sub tag {
    return $_[1] ? $_[0]->[EL_NODE_NAME] = $_[1] : $_[0]->[EL_NODE_NAME];
}

sub setAttribute {
    my $node = shift;
    my ( $attr, $val ) = @_;
    if ( $attr eq 'id' ) {

        # assign into ids
        my $tmpl   = $node->template;
        my $ids    = $tmpl->token_ids;
        my $old_id = $node->getAttribute("id");
        if ( $old_id && $ids ) {
            delete $ids->{$old_id};
        }
    }
    elsif ( $attr eq 'class' ) {

        # assign into classes
        my $tmpl      = $node->template;
        my $classes   = $tmpl->token_classes;
        my $old_class = $node->getAttribute("class");
        if ( $old_class && $classes->{$old_class} ) {
            @{ $classes->{$old_class} }
                = grep { $_ != $node } @{ $classes->{$old_class} };
        }
        push @{ $classes->{$val} ||= [] }, $node;
    }
    ( $node->[EL_NODE_ATTR] ||= {} )->{$attr} = $val;
}

sub getAttribute {
    my $node = shift;
    my ($attr) = @_;
    $node->[EL_NODE_ATTR]->{$attr};
}

sub firstChild {
    my $node     = shift;
    my $children = $node->[EL_NODE_CHILDREN];
    @$children ? $children->[0] : undef;
}

sub lastChild {
    my $node     = shift;
    my $children = $node->[EL_NODE_CHILDREN];
    @$children ? $children->[ scalar @$children - 1 ] : undef;
}

sub nextSibling {
    my $node     = shift;
    my $siblings = $node->[EL_NODE_PARENT][EL_NODE_CHILDREN];
    my $max      = ( scalar @$siblings ) - 1;
    return undef unless $max;
    my $last = $siblings->[0];
    foreach my $n ( $siblings->[ 1 .. $max ] ) {
        return $n if $node == $last;
        $last = $n;
    }
    return $siblings->[$max] if $node == $last;
    return undef;
}

sub previousSibling {
    my $node     = shift;
    my $siblings = $node->[EL_NODE_PARENT][EL_NODE_CHILDREN];
    my $last;
    foreach my $n (@$siblings) {
        return $last if $node == $n;
        $last = $n;
    }
    return undef;
}

sub ownerDocument {    #template
    my $node = shift;
    return $node->[EL_NODE_TEMPLATE];
}

sub hasChildNodes {
    my $node     = shift;
    my $children = $node->[EL_NODE_CHILDREN];
    $children && (@$children) ? 1 : 0;
}

sub nodeType {
    my $node = shift;
    if ( $node->[EL_NODE_NAME] eq 'TEXT' ) {
        return NODE_TEXT();
    }
    elsif ( defined $node->childNodes ) {
        return NODE_BLOCK();
    }
    else {
        return NODE_FUNCTION();
    }
}

sub nodeName {
    my $node = shift;
    my $tag  = $node->[EL_NODE_NAME];
    if ( $tag eq 'TEXT' ) {
        return undef;
    }

    # normalize:
    #    MTEntry => mt:entry
    #    MTAPP:WIDGET => mtapp:widget
    $tag = lc $tag;
    if ( ( $tag !~ m/:/ ) && ( $tag =~ m/^mt/ ) ) {
        $tag =~ s/^mt/mt:/;
    }
    return $tag;
}

sub innerHTML {
    my $node = shift;
    if (@_) {
        my ($text) = @_;
        $node->[EL_NODE_VALUE] = $text;
        my $builder = MT->builder;
        require MT::Template::Context;
        my $ctx = MT::Template::Context->new;
        $node->[EL_NODE_CHILDREN] = $builder->compile( $ctx, $text ) || [];
        my $tmpl = $node->[EL_NODE_TEMPLATE];

        if ($tmpl) {
            $tmpl->reset_markers;
            $tmpl->{reflow_flag} = 1;
        }
    }
    return $node->[EL_NODE_VALUE];
}

# TBD: what about new nodes that are added with id elements?
sub appendChild {
    my $node       = shift;
    my ($new_node) = @_;
    my $nodes      = $node->[EL_NODE_CHILDREN];
    push @$nodes, $new_node;
    my $tmpl = $node->[EL_NODE_TEMPLATE];
    if ($tmpl) {
        $tmpl->{reflow_flag} = 1;
    }
}

sub removeChild {
    my $node = shift;
}

## Decode all items
sub upgrade {
    my $node = shift;
    my $i;
    for my $v (@$node) {
        _upgrade( \$v ) if defined($v);
        $i++;
        ## Don't decode parents.
        last if $i >= 5;
    }
}

sub _upgrade {
    my $ref = ref $_[0];
    if ( !$ref ) {
        MT::Util::Encode::_utf8_on( $_[0] )
            if !MT::Util::Encode::is_utf8( $_[0] );
    }
    elsif ( $ref eq 'HASH' ) {
        for my $v ( values %{ $_[0] } ) {
            _upgrade( \$v ) if defined($v);
        }
    }
    elsif ( $ref eq 'ARRAY' ) {
        for my $v ( @{ $_[0] } ) {
            _upgrade( \$v ) if defined($v);
        }
    }
    elsif ( $ref eq 'SCALAR' ) {
        MT::Util::Encode::_utf8_on( ${ $_[0] } )
            if !MT::Util::Encode::is_utf8( ${ $_[0] } );
    }
    elsif ( $ref eq 'MT::Template::Node' ) {
        $_[0]->upgrade;
    }
    elsif ( $ref eq 'MT::Template::Tokens' ) {
        for my $n ( @{ $_[0] } ) {
            $n->upgrade;
        }
    }
    elsif ( $ref eq 'REF' ) {
        _upgrade( ${ $_[0] } );
    }
}

*inner_html    = \&innerHTML;
*append_child  = \&appendChild;
*insert_before = \&insertBefore;
*remove_child  = \&removeChild;

1;
__END__
