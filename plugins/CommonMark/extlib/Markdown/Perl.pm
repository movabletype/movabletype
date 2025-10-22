package Markdown::Perl;

use strict;
use warnings;
use utf8;
use feature ':5.24';

use Carp;
use English;
use Exporter 'import';
use Hash::Util 'lock_keys';
use List::Util 'none';
use List::MoreUtils 'pairwise';
use Markdown::Perl::BlockParser;
use Markdown::Perl::Inlines;
use Markdown::Perl::HTML 'html_escape', 'decode_entities', 'parse_attributes';
use Readonly;
use Scalar::Util 'blessed';

use parent 'Markdown::Perl::Options';

our $VERSION = '1.11';

our @EXPORT_OK = qw(convert set_options set_mode set_hooks);
our %EXPORT_TAGS = (all => \@EXPORT_OK);

sub new {
  my ($class, @options) = @_;

  my $this = $class->SUPER::new(
    mode => undef,
    options => {},
    local_options => {},
    hooks => {});
  $this->SUPER::set_options(options => @options);
  lock_keys(%{$this});

  return $this;
}

sub set_options {
  my ($this, @options) = &_get_this_and_args;  ## no critic (ProhibitAmpersandSigils)
  $this->SUPER::set_options(options => @options);
  return;
}

sub set_mode {
  my ($this, $mode) = &_get_this_and_args;  ## no critic (ProhibitAmpersandSigils)
  $this->SUPER::set_mode(options => $mode);
  return;
}

Readonly::Array my @VALID_HOOKS => qw(resolve_link_ref yaml_metadata);

sub set_hooks {
  my ($this, %hooks) = &_get_this_and_args;  ## no critic (ProhibitAmpersandSigils)
  while (my ($k, $v) = each %hooks) {
    if (none { $_ eq $k } @VALID_HOOKS) {
      croak "Invalid hook name: ${k}";
    } elsif (!defined $v) {
      delete $this->{hooks}{$k};
    } elsif (ref $v ne 'CODE') {
      carp 'Hook target must be a CODE reference';
    } else {
      $this->{hooks}{$k} = $v;
    }
  }
  return;
}

# Returns @_, unless the first argument is not blessed as a Markdown::Perl
# object, in which case it returns a default object.
my $default_this = Markdown::Perl->new();

sub _get_this_and_args {  ## no critic (RequireArgUnpacking)
  return unless @_;
  # We could use `$this isa Markdown::Perl` that does not require to test
  # blessedness first. However this requires 5.31.6 which is not in Debian
  # stable as of writing this.
  if (!blessed($_[0]) || !$_[0]->isa(__PACKAGE__)) {
    unshift @_, $default_this;
  }
  return @_ if defined wantarray;
  return;
}

# Takes a string and converts it to HTML. Can be called as a free function or as
# class method. In the latter case, provided options override those set in the
# class constructor.
# Both the input and output are unicode strings.
sub convert {  ## no critic (RequireArgUnpacking)
  &_get_this_and_args;  ## no critic (ProhibitAmpersandSigils)
  my $this = shift @_;
  my $md = \(shift @_);  # Taking a reference to avoid copying the input. is it useful?
  $this->SUPER::set_options(local_options => @_);

  # TODO: introduce an HtmlRenderer object that carries the $linkrefs states
  # around (instead of having to pass it in all the calls).
  my ($blocks, $linkrefs) = $this->_parse($md);
  my $out = $this->_emit_html(0, 'root', $linkrefs, @{$blocks});
  $this->{local_options} = {};
  return $out;
}

# This is an internal call for now because the structure of the parse tree is
# not defined.
# Note that while convert() takes care not to copy the md argument, this is not
# the case of this method, however, it can receive a scalar ref instead of a
# scalar, to avoid the copy.
# TODO: create a BlockTree class and document it, then make this be public.
sub _parse {
  my ($this, $md_or_ref) = &_get_this_and_args;  ## no critic (ProhibitAmpersandSigils)
  my $md = ref($md_or_ref) ? $md_or_ref : \$md_or_ref;

  my $parser = Markdown::Perl::BlockParser->new($this, $md);
  my ($linkrefs, $blocks) = $parser->process();
  return ($blocks, $linkrefs) if wantarray;
  return $blocks;
}

sub _render_inlines {
  my ($this, $linkrefs, @lines) = @_;
  return Markdown::Perl::Inlines::render($this, $linkrefs, @lines);
}

# TODO: move this to a separate package and split the method in smaller chunks.
sub _emit_html {  ## no critic (ProhibitExcessComplexity)
  my ($this, $tight_block, $parent_type, $linkrefs, @blocks) = @_;
  my $out = '';
  my $block_index = 0;
  for my $bl (@blocks) {
    $block_index++;
    if ($bl->{type} eq 'break') {
      $out .= "<hr />\n";
    } elsif ($bl->{type} eq 'heading') {
      my $l = $bl->{level};
      my $c = $bl->{content};
      $c = $this->_render_inlines($linkrefs, ref $c eq 'ARRAY' ? @{$c} : $c);
      $c =~ s/^[ \t]+|[ \t]+$//g;  # Only the setext headings spec asks for this, but this can’t hurt atx heading where this can’t change anything.
      $out .= "<h${l}>$c</h${l}>\n";
    } elsif ($bl->{type} eq 'code') {
      my $c = $bl->{content};
      html_escape($c, $this->get_html_escaped_code_characters);
      my $i = '';
      if ($this->get_code_blocks_info eq 'language' && $bl->{info}) {
        my $l = $bl->{info} =~ s/\s.*//r;  # The spec does not really cover this behavior so we’re using Perl notion of whitespace here.
        decode_entities($l);
        html_escape($l, $this->get_html_escaped_characters);
        $i = " class=\"language-${l}\"";
      }
      $out .= "<pre><code${i}>$c</code></pre>\n";
    } elsif ($bl->{type} eq 'html') {
      $out .= $bl->{content};
    } elsif ($bl->{type} eq 'paragraph') {
      my $html = '';
      if ((
             $this->get_allow_task_list_markers eq 'list'
          && $parent_type eq 'list'
          && $block_index == 1)
        || $this->get_allow_task_list_markers eq 'always'
      ) {
        if ($bl->{content}[0] =~ m/ ^ \s* \[ (?<marker> [ xX] ) \] (?<space> \s | $ ) /x) {
          $html =
               '<input '
              .($LAST_PAREN_MATCH{marker} eq ' ' ? '' : 'checked="" ')
              .'disabled="" type="checkbox">'
              .($LAST_PAREN_MATCH{space} eq ' ' ? ' ' : "\n");
          substr $bl->{content}[0], 0, $LAST_MATCH_END[0], '';
        }
      }
      $html .= $this->_render_inlines($linkrefs, @{$bl->{content}});
      if ($tight_block) {
        $out .= $html;
      } elsif ($this->get_render_naked_paragraphs) {
        $out .= "${html}\n";
      } else {
        $out .= "<p>${html}</p>\n";
      }
    } elsif ($bl->{type} eq 'quotes') {
      my $c = $this->_emit_html(0, 'quotes', $linkrefs, @{$bl->{content}});
      $out .= "<blockquote>\n${c}</blockquote>\n";
    } elsif ($bl->{type} eq 'list') {
      my $type = $bl->{style};  # 'ol' or 'ul'
      my $start = '';
      my $num = $bl->{start_num};
      my $loose = $bl->{loose};
      $start = " start=\"${num}\"" if $type eq 'ol' && $num != 1;
      $out .= "<${type}${start}>\n<li>"
          .join("</li>\n<li>",
        map { $this->_emit_html(!$loose, 'list', $linkrefs, @{$_->{content}}) } @{$bl->{items}})
          ."</li>\n</${type}>\n";
    } elsif ($bl->{type} eq 'table') {
      $out .= '<table><thead><tr>';
      my @align = map { $_ ? " align=\"${_}\"" : '' } @{$bl->{content}{align}};
      my @h = map { $this->_render_inlines($linkrefs, $_) } @{$bl->{content}{headers}};
      $out .= join('', pairwise { "<th${a}>${b}</th>" } @align, @h);
      $out .= '</tr></thead>';
      if (@{$bl->{content}{table}}) {
        $out .= '<tbody>';
        my $ms = $this->get_table_blocks_have_cells_for_missing_data;
        for my $l (@{$bl->{content}{table}}) {
          $out .= '<tr>';
          my @d = map { defined ? $this->_render_inlines($linkrefs, $_) : $ms ? '' : undef } @{$l};
          $out .= join('', pairwise { defined $b ? "<td${a}>${b}</td>" : '' } @align, @d);
          $out .= '</tr>';
        }
        $out .= '</tbody>';
      }
      $out .= '</table>';
    } elsif ($bl->{type} eq 'directive') {
      my $c = $this->_emit_html(0, 'directive', $linkrefs, @{$bl->{content}});
      my %attr = parse_attributes($bl->{attributes}) if defined $bl->{attributes};  ## no critic (ProhibitConditionalDeclaration)
      my @attr = ('div');
      push @attr, 'id="'.$attr{id}.'"' if exists $attr{id};
      unshift @{$attr{class}}, lc($bl->{name}) if defined $bl->{name};
      push @attr, 'class="'.join(' ', @{$attr{class}}).'"' if exists $attr{class};
      push @attr, map { sprintf 'data-%s="%s"', @{$_} } @{$attr{keys}} if exists $attr{keys};
      my $tag = join(' ', @attr);
      # TODO: the inline content is ignored for now
      # TODO we should add a hook to process the directive in custom cases.
      $out .= "<${tag}>\n${c}</div>\n";
      if (defined $bl->{inline} && $this->get_warn_for_unused_input()) {
        carp 'Unused inline content in a directive block: '.$bl->{inline};
      }
      if (defined $attr{junk} && $this->get_warn_for_unused_input()) {
        carp 'Unused attribute content in a directive block: '.$attr{junk};
      }
    } else {
      confess 'Unexpected block type when rendering HTML output: '.$bl->{type};
    }
  }
  # Note: a final new line should always be appended to $out. This is not
  # guaranteed when the last element is HTML and the input file did not contain
  # a final new line, unless the option force_final_new_line is set.
  return $out;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Markdown::Perl – Very configurable Markdown processor written in pure Perl,
supporting the CommonMark spec and many extensions.

=head1 SYNOPSIS

This is the library underlying the L<pmarkdown> tool. It can be used in an
object-oriented style:

  use Markdown::Perl;
  my $converter = Markdown::Perl->new([mode => $mode], %options);
  my $html = $converter->convert($markdown);

Or the library can be used functionally:

  use Markdown::Perl 'convert';
  Markdown::Perl::set_options([mode => $mode], %options);
  my $html = convert($markdown);

=head1 DESCRIPTION

=head2 new

  my $pmarkdown = Markdown::Perl->new([mode => $mode], %options);

Creates a C<Markdown::Perl> object that can be used to convert Markdown data
into HTML. Note that you don’t have to create an instance of this class to use
this module. The methods of this class can also be used like package functions
and they will operate on an implicit default instance of the class.

See the L<pmarkdown/MODES> page for the documentation of existing modes.

See the L<Markdown::Perl::Options> documentation for all the existing options.

For the reference on the default syntax supported by the library, see the GitHub
repository of the project:
L<https://github.com/mkende/pmarkdown/blob/main/Syntax.md>

=head2 set_options

  $pmarkdown->set_options(%options);
  Markdown::Perl::set_options(%option);

Sets the options of the current object or, for the functional version, the
options used by functional calls to convert(). The options set through the
functional version do B<not> apply to any objects created through a call to
new().

See the L<Markdown::Perl::Options> documentation for all the existing options.

=head2 set_mode

  $pmarkdown->set_mode($mode);
  Markdown::Perl::set_mode($mode);

Specifies a I<mode> for the current object or, for the functional version, the
mode used by functional calls to convert(). A mode is a set of configuration
options working together, typically to replicate the semantics of another
existing Markdown processor. See the L<pmarkdown/MODES> documentation for a list
of available modes.

When a mode is applied, it sets specific values for some options but any value
for these options set through the set_options() will take precedence, even if
set_options() is called before set_mode(). The mode set through the functional
version does B<not> apply to any objects created through a call to new().

=head2 convert

  my $html = $pmarkdown->convert($md);
  my $html = Markdown::Perl::convert($md);

Converts the given $md string into HTML. The input string must be a decoded
Unicode string (or an ASCII string) and the output is similarly a decoded
Unicode string.

=head2 set_hooks

  $pmarkdown->set_hooks(hook_name => sub { ... }, ...);
  Markdown::Perl::set_hooks(hook_name => sub { ... }, ...);

Registers hooks to be called during the processing of a Markdown document. Each
hook must point to a code reference. You can remove a hook by passing C<undef>
as the value associated with a hook.

There is currently a single hook:

=over 4

=item *

C<resolve_link_ref>: this hook will receive a single string an argument,
containing the label of a link reference in case where there was no matching
link definition in the document and it must returns either C<undef> or a
hash-reference containing a C<target> key, pointing to the link destination and
optionally a C<title> key containing the title of the key. The hash-ref can also
contain a C<content> key, in which case its value should be a span of HTML which
will replace whatever would have been used for the link content.

=item *

C<yaml_metadata>: this hook will trigger if there is B<valid> YAML metadata at
the beginning of the file. This also requires that the
L<parse_file_metadata option|Markdown::Perl::Options/parse_file_metadata> is set
to C<yaml> (which is the default in our default mode). The hook will receive a
hashref or an arrayref with the content of the YAML document.

To allow conditional parsing based on some metadata, if the hook dies, the
exception will interrupt the processing and be propagated as-is to the initial
caller.

=back

=head1 AUTHOR

Mathias Kende <mathias@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2024 Mathias Kende

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

=head1 SEE ALSO

=over

=item L<pmarkdown>

=item L<Text::Markdown> another pure Perl implementation, implementing the
original Markdown syntax from L<http://daringfireball.net/projects/markdown>.

=item L<CommonMark> a wrapper around the official CommonMark C library.

=back

=cut
