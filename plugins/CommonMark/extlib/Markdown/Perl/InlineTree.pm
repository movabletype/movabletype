# A tree data structure to represent the content of an inline text of a block
# element.

package Markdown::Perl::InlineTree;

use strict;
use warnings;
use utf8;
use feature ':5.24';

use Carp;
use English;
use Exporter 'import';
use Hash::Util ();
use Scalar::Util 'blessed';

our $VERSION = 0.01;

our @EXPORT_OK =
    qw(new_text new_code new_link new_html new_style new_literal is_node is_tree UNESCAPE_LITERAL);
our %EXPORT_TAGS = (all => \@EXPORT_OK);

=pod

=encoding utf8

=head1 NAME

Markdown::Perl::InlineTree

=head1 SYNOPSIS

A tree structure meant to represent the inline elements of a Markdown paragraph.

This package is internal to the implementation of L<Markdown::Perl> and its
documentation should be useful only if you are trying to modify the library.

Otherwise please refer to the L<Markdown::Perl> and L<pmarkdown> documentation.

=head1 DESCRIPTION

=head2 new

  my $tree = Markdown::Perl::InlineTree->new();

The constructor currently does not support any options.

=cut

sub new {
  my ($class) = @_;

  return bless {children => []}, $class;
}

package Markdown::Perl::InlineNode {  ## no critic (ProhibitMultiplePackages)
  use Carp;
  use Markdown::Perl::HTML 'decode_entities', 'html_escape', 'http_escape';

  sub hashpush (\%%) {
    my ($hash, %args) = @_;
    while (my ($k, $v) = each %args) {
      $hash->{$k} = $v;
    }
    return;
  }

  sub new {
    my ($class, $type, $content, %options) = @_;

    my $this = {type => $type, escaped => 0};
    $this->{debug} = delete $options{debug} if exists $options{debug};
    my $content_ref = ref $content;
    if (Scalar::Util::blessed($content)
      && $content->isa('Markdown::Perl::InlineTree')) {
      hashpush %{$this}, subtree => $content;
    } elsif (!ref($content)) {
      hashpush %{$this}, content => $content;
    } else {
      confess "Unexpected content for inline ${type} node: ".ref($content);
    }
    # There is one more node type, not created here, that looks like a text
    # node but that is a 'delimiter' node. These nodes are created manually
    # inside the Inlines module.
    if ($type eq 'text' || $type eq 'code' || $type eq 'literal' || $type eq 'html') {
      confess "Unexpected content for inline ${type} node: ${content_ref}" if $content_ref;
      confess "Unexpected parameters for inline ${type} node: ".join(', ', %options)
          if %options;
    } elsif ($type eq 'link') {
      confess 'Missing required option "type" for inline link node' unless exists $options{type};
      hashpush %{$this}, linktype => delete $options{type};
      confess 'Missing required option "target" for inline link node'
          unless exists $options{target};
      hashpush %{$this}, target => delete $options{target};
      hashpush %{$this}, title => delete $options{title} if exists $options{title};
      hashpush %{$this}, content => delete $options{content} if exists $options{content};
      confess 'Unexpected parameters for inline link node: '.join(', ', %options) if keys %options;
    } elsif ($type eq 'style') {
      confess 'Unexpected parameters for inline style node: '.join(', ', %options)
          if keys %options > 1 || !exists $options{tag};
      confess 'The content of a style node must be an InlineTree' unless $content_ref;
      hashpush %{$this}, tag => $options{tag};
    } else {
      confess "Unexpected type for an InlineNode: ${type}";
    }
    bless $this, $class;

    Hash::Util::lock_keys %{$this};
    return $this;
  }

  sub clone {
    my ($this) = @_;

    return bless {%{$this}}, ref($this);
  }

  sub has_subtree {
    my ($this) = @_;

    return exists $this->{subtree};
  }

  sub escape_content {
    my ($this, $char_class_to_escape, $char_class_to_escape_in_code) = @_;

    confess 'Node should not already be escaped when calling to_text' if $this->{escaped};
    $this->{escaped} = 1;

    if ($this->{type} eq 'text') {
      decode_entities($this->{content});
      html_escape($this->{content}, $char_class_to_escape);
    } elsif ($this->{type} eq 'literal') {
      html_escape($this->{content}, $char_class_to_escape);
    } elsif ($this->{type} eq 'code') {
      # New lines are treated like spaces in code.
      $this->{content} =~ s/\n/ /g;
      # If the content is not just whitespace and it has one space at the
      # beginning and one at the end, then we remove them.
      $this->{content} =~ s/^ (.*[^ ].*) $/$1/g;
      html_escape($this->{content}, $char_class_to_escape_in_code);
    } elsif ($this->{type} eq 'link') {
      if ($this->{linktype} eq 'autolink') {
        # For autolinks we don’t decode entities as these are treated like html
        # construct.
        html_escape($this->{content}, $char_class_to_escape);
        http_escape($this->{target});
        html_escape($this->{target}, $char_class_to_escape);
      } elsif ($this->{linktype} eq 'link' || $this->{linktype} eq 'img') {
        # This is a real MD link definition (or image). The target and title
        # have been generated through the to_source_text() method, so they need
        # to be decoded and html_escaped
        if (exists $this->{title}) {
          decode_entities($this->{title});
          html_escape($this->{title}, $char_class_to_escape);
        }
        decode_entities($this->{target});
        http_escape($this->{target});
        html_escape($this->{target}, $char_class_to_escape);
      } else {
        confess 'Unexpected link type in render_node_html: '.$this->{linktype};
      }
    } elsif ($this->{type} eq 'html' || $this->{type} eq 'style') {
      # Nothing here on purpose
    } else {
      confess 'Unexpected node type in render_node_html: '.$this->{type};
    }
    return;
  }
}  # package Markdown::Perl::InlineNode

=pod

=head2 new_text, new_code, new_link, new_literal

  my $text_node = new_text('text content');
  my $code_node = new_code('code content');
  my $link_node = new_link('text content', type=> 'type', target => 'the target'[, title => 'the title']);
  my $link_node = new_link($subtree_content, type=> 'type', target => 'the target'[, title => 'the title'][, content => 'override content']);
  my $html_node = new_html('<raw html content>');
  my $style_node = new_literal($subtree_content, 'html_tag');
  my $literal_node = new_literal('literal content');

These methods return a text node that can be inserted in an C<InlineTree>.

=cut

sub new_text { return Markdown::Perl::InlineNode->new(text => @_) }
sub new_code { return Markdown::Perl::InlineNode->new(code => @_) }
sub new_link { return Markdown::Perl::InlineNode->new(link => @_) }
sub new_html { return Markdown::Perl::InlineNode->new(html => @_) }
sub new_style { return Markdown::Perl::InlineNode->new(style => @_) }
sub new_literal { return Markdown::Perl::InlineNode->new(literal => @_) }

=pod

=head2 is_node, is_tree

These two methods returns whether a given object is a node that can be inserted
in an C<InlineTree> and whether it’s an C<InlineTree> object.

=cut

sub is_node {
  my ($obj) = @_;
  return blessed($obj) && $obj->isa('Markdown::Perl::InlineNode');
}

sub is_tree {
  my ($obj) = @_;
  return blessed($obj) && $obj->isa('Markdown::Perl::InlineTree');
}

=pod

=head2 push

  $tree->push(@nodes_or_trees);

Push a list of nodes at the end of the top-level nodes of the current tree.

If passed C<InlineTree> objects, then the nodes of these trees are pushed (not
the tree itself).

=cut

sub push {  ## no critic (ProhibitBuiltinHomonyms)
  my ($this, @nodes_or_trees) = @_;

  for my $node_or_tree (@nodes_or_trees) {
    if (is_node($node_or_tree)) {
      push @{$this->{children}}, $node_or_tree;
    } elsif (is_tree($node_or_tree)) {
      push @{$this->{children}}, @{$node_or_tree->{children}};
    } else {
      confess 'Invalid argument type for InlineTree::push: '.ref($node_or_tree);
    }
  }

  return;
}

=pod

=head2 replace

  $tree->replace($index, @nodes);

Remove the existing node at the given index and replace it by the given list of
nodes (or, if passed C<InlineTree> objects, their own nodes).

=cut

sub replace {
  my ($this, $child_index, @new_nodes) = @_;
  splice @{$this->{children}}, $child_index, 1,
      map { is_node($_) ? $_ : @{$_->{children}} } @new_nodes;
  return;
}

=pod

=head2 insert

  $tree->insert($index, @new_nodes);

Inserts the given nodes  (or, if passed C<InlineTree> objects, their own nodes)
at the given index. After the operation, the first inserted node will have that
index.

=cut

sub insert {
  my ($this, $index, @new_nodes) = @_;
  splice @{$this->{children}}, $index, 0, map { is_node($_) ? $_ : @{$_->{children}} } @new_nodes;
  return;
}

=pod

=head2 extract

  $tree->extract($start_child, $start_offset, $end_child, $end_offset);

Extract the content of the given tree, starting at the child with the given
index (which must be a B<text> node) and at the given offset in the child’s
text, and ending at the given node and offset (which must also be a B<text>
node).

That content is removed from the input tree and returned as a new C<InlineTree>
object. Returns a pair with the new tree and the index of the first child after
the removed content in the input tree. Usually it will be C<$start_child + 1>,
but it can be C<$start_child> if C<$start_offset> was 0.

In scalar context, returns only the extracted tree.

=cut

sub extract {
  my ($this, $child_start, $text_start, $child_end, $text_end) = @_;

  # In this method, we should not read $sn and $en when they are not split (that
  # is if text_start or text_end are 0), so that the method works at the
  # boundary of non-text nodes.

  my $sn = $this->{children}[$child_start];
  confess 'Start node in an extract operation is not of type text: '.$sn->{type}
      unless $sn->{type} eq 'text' || $text_start == 0;

  ## I don’t think that this block is useful (I should add tests for this case
  ## to check if this is needed).
  ## The code after this block will be invalid if we extract an empty span, but
  ## I don’t think that this can happen in practice.
  # if ($child_start == $child_end && $text_start == $text_end) {
  #   my $offset = 0;
  #   if ($text_start != 0) {
  #     if ($text_start != length($sn->{content})) {
  #       my $nn = new_text(substr $sn->{content}, $text_start, length($sn->{content}), '');
  #       $this->insert($child_start + 1, $nn);
  #     }
  #     $offset = 1;
  #   }
  #   return (Markdown::Perl::InlineTree->new(), $child_start + $offset) if wantarray;
  #   return Markdown::Perl::InlineTree->new();
  # }

  my $en = $this->{children}[$child_end];
  confess 'End node in an extract operation is not of type text: '.$en->{type}
      unless $text_end == 0 || $en->{type} eq 'text';
  confess 'Start offset is less than 0 in an extract operation' if $text_start < 0;
  confess 'End offset is past the end of the text in an extract operation'
      if $text_end != 0 && $text_end > length($en->{content});

  my $empty_last = 0;
  if ($text_end == 0) {
    $empty_last = 1;
    $child_end--;
  }

  # Clone will not recurse into sub-trees. But the start and end nodes can’t
  # have sub-trees, and the middle ones don’t matter because they are not shared
  # with the initial tree.
  my @nodes =
      map { $_->clone() } @{$this->{children}}[$child_start .. $child_end];
  ## no critic (ProhibitLvalueSubstr)
  substr($nodes[-1]{content}, $text_end) = '' unless $empty_last;  ## We have already removed the empty last node.
  substr($nodes[0]{content}, 0, $text_start) = '';  # We must do this after text_end in case they are the same node.
  shift @nodes if length($nodes[0]{content}) == 0;
  pop @nodes if !$empty_last && @nodes && length($nodes[-1]{content}) == 0;
  my $new_tree = Markdown::Perl::InlineTree->new();
  $new_tree->push(@nodes);

  if ($child_start != $child_end) {
    if ($text_start == 0) {
      $child_start--;
    } else {
      substr($sn->{content}, $text_start) = '';
    }
    if ($empty_last || $text_end == length($en->{content})) {
      $child_end++;
    } else {
      substr($en->{content}, 0, $text_end) = '';
    }
    splice @{$this->{children}}, $child_start + 1, $child_end - $child_start - 1;
  } else {
    my @new_nodes;
    if ($text_start > 0) {
      CORE::push @new_nodes, new_text(substr $sn->{content}, 0, $text_start);
    }
    if (!$empty_last && $text_end < length($sn->{content})) {
      CORE::push @new_nodes, new_text(substr $sn->{content}, $text_end);
    }
    $this->replace($child_start, @new_nodes);
    $child_start-- if $text_start == 0;
  }
  ## use critic (ProhibitLvalueSubstr)

  return ($new_tree, $child_start + 1) if wantarray;
  return $new_tree;
}

=pod

=head2 map_shallow

  $tree->map_shallow($sub);

Apply the given sub to each direct child of the tree. The sub can return a node
or a tree and that returned content is concatenated to form a new tree.

Only the top-level nodes of the tree are visited.

In void context, update the tree in-place. Otherwise, the new tree is returned.

In all cases, C<$sub> must return new nodes or trees, it can’t modify the input
object. The argument to C<$sub> are passed in the usual way in C<@_>, not in
C<$_>.

=cut

sub map_shallow {
  my ($this, $sub) = @_;

  my $new_tree = Markdown::Perl::InlineTree->new();

  for (@{$this->{children}}) {
    $new_tree->push($sub->());
  }

  return $new_tree if defined wantarray;
  %{$this} = %{$new_tree};
  return;
}

=pod

=head2 map

  $tree->map($sub);

Same as C<map_shallow>, but the tree is visited recursively. The subtree of
individual nodes are visited and their content replaced before the node itself
are visited.

=cut

sub map {  ## no critic (ProhibitBuiltinHomonyms)
  my ($this, $sub, $start, $stop) = @_;
  # $start and $stop are not documented for this function, they are used by
  # clone().

  my $new_tree = Markdown::Perl::InlineTree->new();

  for (@{$this->{children}}[$start // 0 .. $stop // $#{$this->{children}}]) {
    if ($_->has_subtree()) {
      if (defined wantarray) {
        my $new_node = $_->clone();
        $new_node->{subtree}->map($sub);
        local *_ = \$new_node;
        $new_tree->push($sub->());
      } else {
        # Is there a risk that this modifies $_ before the call to $sub?
        $_->{subtree}->map($sub);
        $new_tree->push($sub->());
      }
    } else {
      if (defined wantarray) {
        my $new_node = $_->clone();
        local *_ = \$new_node;
        $new_tree->push($sub->());
      } else {
        $new_tree->push($sub->());
      }
    }
  }

  return $new_tree if defined wantarray;
  %{$this} = %{$new_tree};
  return;
}

=pod

=head2 apply

  $tree->apply($sub);

Apply the given C<$sub> to all nodes of the tree. The sub receives the current
node in C<$_> and can modify it. The return value of the sub is ignored.

=cut

sub apply {
  my ($this, $sub) = @_;

  for (@{$this->{children}}) {
    $sub->();
    $_->{subtree}->apply($sub) if $_->has_subtree();
  }

  return;
}

=pod

=head2 clone

  my $new_tree = $tree->clone([$child_start, $child_end]);

Clone (deep copy) the entire tree or a portion of it.

=cut

sub clone {
  my ($this, $start, $stop) = @_;
  return $this->map(sub { $_ }, $start, $stop);
}

=head2 fold

  $tree->fold($sub, $init);

Iterates over the top-level nodes of the tree, calling C<$sub> for each of them.
It receives two arguments, the current node and the result of the previous call.
The first call receives C<$init> as its second argument.

Returns the result of the last call of C<$sub>.

=cut

# TODO: maybe have a "cat" methods that expects each node to return a string and
# concatenate them, so that we can concatenate them all together at once, which
#  might be more efficient.
sub fold {
  my ($this, $sub, $init) = @_;

  my $out = $init;

  for (@{$this->{children}}) {
    $out = $sub->($_, $out);
  }

  return $out;
}

=pod

=head2 find_in_text

  $tree->find_in_text($regex, $start_child, $start_offset, [$end_child, $end_offset]);

Find the first match of the given regex in the tree, starting at the given
offset in the node. This only considers top-level nodes of the tree and skip
over non B<text> node (including the first one).

If C<$end_child> and C<$end_offset> are given, then does not look for anything
starting at or after that bound.

Does not match the regex across multiple nodes.

Returns C<$child_number, $match_start_offset, $match_end_offset> (or just a
I<true> value in scalar context) or C<undef>.

=cut

sub find_in_text {
  my ($this, $re, $child_start, $text_start, $child_bound, $text_bound) = @_;
  # qr/^\b$/ is a regex that can’t match anything.
  return $this->find_balanced_in_text(qr/^\b$/, $re, $child_start, $text_start, $child_bound,
    $text_bound);
}

=pod

=head2 find_balanced_in_text

  $tree->find_balanced_in_text(
    $open_re, $close_re, $start_child, $start_offset, $child_bound, $text_bound);

Same as C<find_in_text> except that this method searches for both C<$open_re> and
C<$close_re> and, each time C<$open_re> is found, it needs to find C<$close_re>
one more time before we it returns. The method assumes that C<$open_re> has
already been seen once before the given C<$start_child> and C<$start_offset>.

=cut

sub find_balanced_in_text {
  my ($this, $open_re, $close_re, $child_start, $text_start, $child_bound, $text_bound) = @_;

  my $open = 1;

  for my $i ($child_start .. ($child_bound // $#{$this->{children}})) {
    next unless $this->{children}[$i]{type} eq 'text';
    if ($i == $child_start && $text_start != 0) {
      pos($this->{children}[$i]{content}) = $text_start;
    } else {
      pos($this->{children}[$i]{content}) = 0;
    }

    # When the code in this regex is executed, we are sure that the engine
    # won’t backtrack (as we are at the end of the regex).
    while (
      $this->{children}[$i]{content} =~ m/ ${open_re}(?{$open++}) | ${close_re}(?{$open--}) /gx)
    {
      return if $i == ($child_bound // -1) && $LAST_MATCH_START[0] >= $text_bound;
      if ($open == 0) {
        return ($i, $LAST_MATCH_START[0], $LAST_MATCH_END[0]) if wantarray;
        return 1;
      }
    }
  }

  return;
}

=pod

=head2 find_in_text_with_balanced_content

  $tree->find_in_text_with_balanced_content(
    $open_re, $close_re, $end_re, $start_child, $start_offset,
    $child_bound, $text_bound);

Similar to C<find_balanced_in_text> except that this method ends when C<$end_re>
is seen, after the C<$open_re> and C<$close_re> regex have been seen a balanced
number of time. If the closing one is seen more than the opening one, the search
succeeds too. The method does B<not> assumes that C<$open_re> has already been
seen before the given C<$start_child> and C<$start_offset> (as opposed to
C<find_balanced_in_text>).

=cut

sub find_in_text_with_balanced_content {
  my ($this, $open_re, $close_re, $end_re, $child_start, $text_start, $child_bound, $text_bound) =
      @_;

  my $open = 0;

  for my $i ($child_start .. ($child_bound // $#{$this->{children}})) {
    next unless $this->{children}[$i]{type} eq 'text';
    if ($i == $child_start && $text_start != 0) {
      pos($this->{children}[$i]{content}) = $text_start;
    } else {
      pos($this->{children}[$i]{content}) = 0;
    }

    # When the code in this regex is executed, we are sure that the engine
    # won’t backtrack (as we are at the end of the regex).

    my $done = 0;
    while ($this->{children}[$i]{content} =~
      m/ ${end_re}(?{$done = 1}) | ${open_re}(?{$open++}) | ${close_re}(?{$open--}) /gx) {
      return if $i == ($child_bound // -1) && $LAST_MATCH_START[0] >= $text_bound;
      return ($i, $LAST_MATCH_START[0], $LAST_MATCH_END[0]) if ($open == 0 && $done) || $open < 0;
      $done = 0;
    }
  }

  return;
}

=pod

=head2 render_html

  $tree->render_html();

Returns the HTML representation of that C<InlineTree>.

=cut

sub render_html {
  my ($tree) = @_;
  return $tree->fold(\&render_node_html, '');
}

sub render_node_html {
  my ($n, $acc) = @_;

  confess 'Node should  already be escaped when calling render_html' unless $n->{escaped};

  if ($n->{type} eq 'text' || $n->{type} eq 'literal' || $n->{type} eq 'html') {
    return $acc.$n->{content};
  } elsif ($n->{type} eq 'code') {
    return $acc.'<code>'.$n->{content}.'</code>';
  } elsif ($n->{type} eq 'link') {
    my $title = '';
    if (exists $n->{title}) {
      $title = " title=\"$n->{title}\"";
    }
    if ($n->{linktype} eq 'link' || $n->{linktype} eq 'autolink') {
      # $n->{content} can only be set in the case of autolink or through the
      # resolve_link_ref hook (in which case it takes precedence over whatever
      # was in the link definition).
      my $content = exists $n->{content} ? $n->{content} : $n->{subtree}->render_html();
      return $acc."<a href=\"$n->{target}\"${title}>${content}</a>";
    } elsif ($n->{linktype} eq 'img') {
      my $content = $n->{subtree}->to_text();
      return $acc."<img src=\"$n->{target}\" alt=\"${content}\"${title} />";
    } else {
      confess 'Unexpected link type in render_node_html: '.$n->{linktype};
    }
  } elsif ($n->{type} eq 'style') {
    my $content = $n->{subtree}->render_html();
    if ($n->{tag} =~ m/^\.(.*)$/) {
      my $class = $1;
      return $acc."<span class=\"${class}\">${content}</span>";
    } else {
      my $tag = $n->{tag};
      return $acc."<${tag}>${content}</${tag}>";
    }
  } else {
    confess 'Unexpected node type in render_node_html: '.$n->{type};
  }
}

=pod

=head2 to_text

  $tree->to_text();

Returns the text content of this C<InlineTree> discarding all HTML formatting.
This is used mainly to produce the C<alt> text of image nodes (which can contain
any Markdown construct in the source).

=cut

sub to_text {
  my ($tree) = @_;
  return $tree->fold(\&node_to_text, '');
}

sub node_to_text {
  my ($n, $acc) = @_;
  confess 'Node should  already be escaped when calling to_text' unless $n->{escaped};
  if ($n->{type} eq 'text') {
    return $acc.$n->{content};
  } elsif ($n->{type} eq 'style') {
    return $acc.$n->{subtree}->to_text();
  } elsif ($n->{type} eq 'literal' || $n->{type} eq 'html') {
    # This is not the exact same behavior as cmark because we will escape
    # literals here, while cmark would not escape them. The cmark behavior is
    # probably faulty here (and is not tested by the test suite).
    return $acc.$n->{content};
  } elsif ($n->{type} eq 'link') {
    if ($n->{linktype} ne 'autolink') {
      return $acc.$n->{subtree}->to_text();
    } else {
      return $acc.$n->{content};
    }
  } elsif ($n->{type} eq 'code') {
    return $acc.'<code>'.$n->{content}.'</code>';
  } else {
    confess 'Unsupported node type for to_text: '.$n->{type};
  }
}

=pod

=head2 to_source_text

  $tree->to_source_text($unescape_literal);

Returns the original Markdown source corresponding to this C<InlineTree>. This
is used to produce the reference label, target and title of link elements and so
can support only node types that have a higher priority than links (nodes that
may have been built already when this is called).

The source is returned as-is, the HTML entities are neither decoded nor escaped.

If C<$unescape_literal> is true, then literal values that were escaped in the
source are unescaped (e.g. C<\;>  will appear again as C<\;>). Otherwise they
will just appear as their literal value (e.g. C<;>).

As a readability facility, the C<UNESCAPE_LITERAL> symbol can be used to pass
this option (with a value of C<1>).

=cut

# It’s a feature that this does not interpolate.
use constant UNESCAPE_LITERAL => 1;  ## no critic (ProhibitConstantPragma)

sub to_source_text {
  my ($tree, $unescape_literal) = @_;
  return $tree->fold(node_to_source_text($unescape_literal), '');
}

sub node_to_source_text {
  my ($unescape_literal) = @_;
  # TODO: ideally all this should be replaced by the fact that the nodes should
  # store the span of text that they represent, to be able to extract the actual
  # source text.
  # This probably requires that the inlines processing should be rewritten to do
  # the link at the same time as the auto-links and inline HTML so that this
  # operates on text.
  return sub {
    my ($n, $acc) = @_;
    confess 'Node should not already be escaped when calling to_source_text' if $n->{escaped};
    if ($n->{type} eq 'text') {
      return $acc.$n->{content};
    } elsif ($n->{type} eq 'literal' && $unescape_literal) {
      return $acc.'\\'.$n->{content};
    } elsif ($n->{type} eq 'literal' || $n->{type} eq 'html') {
      return $acc.$n->{content};
    } elsif ($n->{type} eq 'code') {
      # TODO: This also need to be the source string with the right delimiters.
      return $acc.'<code>'.$n->{content}.'</code>';
    } elsif ($n->{type} eq 'link') {
      if ($n->{linktype} eq 'autolink') {
        return $acc.'<'.$n->{content}.'>';
      } else {
        # 'img' can appear inside other links and links can appear inside images
        # and, as-such, we may try to treat them as link reference label, so we
        # need this case.
        # Because their structure is complex, we return a dummy value.
        # BUG: we can’t have a link reference using a label that looks like an
        # image.
        return $acc.'dummy_text_hopefully_this_does_not_collide_with_anything';
      }
    } else {
      confess 'Unsupported node type for to_source_text: '.$n->{type};
    }
  };
}

=head2 span_to_source_text

  $tree->span_to_source_text($child_start, $text_start, $child_end, $text_end[, $unescape_literal]);

Same as C<to_source_text()> but only renders the specified span of the
C<InlineTree>.

=cut

sub span_to_source_text {
  my ($tree, $child_start, $text_start, $child_end, $text_end, $unescape_literal) = @_;
  my $copy = $tree->clone($child_start, $child_end);
  my $extract = $copy->extract(0, $text_start, $child_end - $child_start, $text_end);
  return $extract->to_source_text($unescape_literal);
}

1;
