package Markdown::Perl::BlockParser;

use strict;
use warnings;
use utf8;
use feature ':5.24';

use feature 'refaliasing';
no warnings 'experimental::refaliasing';

use Carp;
use English;
use Hash::Util 'lock_keys_plus';
use List::MoreUtils 'first_index';
use List::Util 'pairs', 'min';
use Markdown::Perl::HTML 'html_escape', 'decode_entities', 'remove_disallowed_tags';
use Markdown::Perl::Util ':all';
use YAML::Tiny;

our $VERSION = '0.02';

=pod

=encoding utf8

=cut

sub new {
  # $md must be a reference
  my ($class, $pmarkdown, $md) = @_;

  my $this = bless {
    pmarkdown => $pmarkdown,
    blocks => [],
    blocks_stack => [],
    paragraph => [],
    last_line_is_blank => 0,
    last_line_was_blank => 0,
    skip_next_block_matching => 0,
    is_lazy_continuation => 0,
    md => undef,
    last_pos => 0,
    line_ending => '',
    continuation_re => qr//,
    linkrefs => {},
    matched_prefix_size => 0,
  }, $class;
  lock_keys_plus(%{$this}, qw(forced_line));

  \$this->{md} = $md;  # aliasing to avoid copying the input, does this work? is it useful?

  return $this;
}

# This autoload method allows to call option accessors from the parent object
# transparently.
my $pkg = __PACKAGE__;

sub AUTOLOAD {  ## no critic (ProhibitAutoloading, RequireArgUnpacking)
  our $AUTOLOAD;  # Automatically populated when the method is called.
  $AUTOLOAD =~ s/${pkg}:://;
  return if $AUTOLOAD eq 'DESTROY';
  confess "Undefined method ${AUTOLOAD}" unless $AUTOLOAD =~ m/^get_/;
  my $this = shift @_;
  return $this->{pmarkdown}->$AUTOLOAD(@_);
}

my $eol_re = qr/ \r\n | \n | \r /x;

sub next_line {
  my ($this) = @_;
  # When we are forcing a line, we don’t recompute the line_ending, but it
  # should already be correct because the forced one is a substring of the last
  # line.
  return delete $this->{forced_line} if exists $this->{forced_line};
  return if pos($this->{md}) == length($this->{md});
  $this->{last_pos} = pos($this->{md});
  $this->{md} =~ m/\G([^\n\r]*)(${eol_re})?/g or confess 'Should not happen';
  my ($t, $e) = ($1, $2);
  if ($1 =~ /^[ \t]+$/) {
    $this->{line_ending} = $t.($e // '') if $this->get_preserve_white_lines;
    return '';
  } else {
    $this->{line_ending} = $e // ($this->get_force_final_new_line ? "\n" : '');
    return $t;
  }
}

sub line_ending {
  my ($this) = @_;
  return $this->{line_ending};
}

# last_pos should be passed whenever set_pos can be followed by a "return;" in
# one of the _do_..._block method (so, if the method fails), to reset the parser
# to its previous state, when the pos was manipulated.
# TODO: add a better abstraction to save and restore parser state.
sub set_pos {
  my ($this, $pos, $last_pos) = @_;
  pos($this->{md}) = $pos;
  $this->{last_pos} = $last_pos if defined $last_pos;
  return;
}

sub get_pos {
  my ($this) = @_;
  return pos($this->{md});
}

sub redo_line {
  my ($this) = @_;
  confess 'Cannot push back more than one line' unless exists $this->{last_pos};
  $this->set_pos(delete $this->{last_pos});
  return;
}

# Takes a string and converts it to HTML. Can be called as a free function or as
# class method. In the latter case, provided options override those set in the
# class constructor.
# Both the input and output are unicode strings.
sub process {
  my ($this) = @_;
  pos($this->{md}) = 0;

  # https://spec.commonmark.org/0.30/#characters-and-lines
  # TODO: The spec asks for this, however we can’t apply it, because md is a
  # reference to the value passed by the user and we don’t want to modify it (it
  # may even be a read-only value). I’m too lazy to find another place to
  # implement this behavior.
  # $this->{md} =~ s/\000/\xfffd/g;

  # https://spec.commonmark.org/0.30/#tabs
  # TODO: nothing to do at this stage.

  # https://spec.commonmark.org/0.30/#backslash-escapes
  # https://spec.commonmark.org/0.30/#entity-and-numeric-character-references
  # Done at a later stage, as escaped characters don’t have their Markdown
  # meaning, we need a way to represent that.

  $this->_parse_yaml_metadata() if $this->get_parse_file_metadata eq 'yaml';

  while (defined (my $l = $this->next_line())) {
    # This field might be set to true at the beginning of the processing, while
    # we’re looking at the conditions of the currently open containers.
    $this->{is_lazy_continuation} = 0;
    $this->_parse_blocks($l);
  }
  $this->_finalize_paragraph();
  while (@{$this->{blocks_stack}}) {
    $this->_restore_parent_block();
  }
  return delete $this->{linkrefs}, delete $this->{blocks};
}

# The $force_loose_test parameter is used when we are actually starting a new
# block. In that case, or if we are actually after a paragraph, then we possibly
# convert the enclosing list to a loose list.
# TODO: the logic to decide if a list is loose is extremely complex and split in
# many different place. It would be great to rewrite it in a simpler way.
sub _finalize_paragraph {
  my ($this, $force_loose_test) = @_;
  if (@{$this->{paragraph}} || $force_loose_test) {
    if ($this->{last_line_was_blank}) {
      if (@{$this->{blocks_stack}}
        && $this->{blocks_stack}[-1]{block}{type} eq 'list_item') {
        $this->{blocks_stack}[-1]{block}{loose} = 1;
      }
    }
  }
  return unless @{$this->{paragraph}};
  push @{$this->{blocks}}, {type => 'paragraph', content => $this->{paragraph}};
  $this->{paragraph} = [];
  return;
}

# Whether the list_item match the most recent list (should we add to the same
# list or create a new one).
sub _list_match {
  my ($this, $item) = @_;
  return 0 unless @{$this->{blocks}};
  my $list = $this->{blocks}[-1];
  return
         $list->{type} eq 'list'
      && $list->{style} eq $item->{style}
      && $list->{marker} eq $item->{marker};
}

sub _add_block {
  my ($this, $block) = @_;
  if ($block->{type} eq 'list_item') {
    $this->_finalize_paragraph(0);
    # https://spec.commonmark.org/0.30/#lists
    if ($this->_list_match($block)) {
      push @{$this->{blocks}[-1]{items}}, $block;
      $this->{blocks}[-1]{loose} ||= $block->{loose};
    } else {
      my $list = {
        type => 'list',
        style => $block->{style},
        marker => $block->{marker},
        start_num => $block->{num},
        items => [$block],
        loose => $block->{loose}
      };
      push @{$this->{blocks}}, $list;
    }
  } else {
    $this->_finalize_paragraph(1);
    push @{$this->{blocks}}, $block;
  }
  return;
}

# Anything passed to $prefix_re must necessary accept an empty string unless the
# block cannot accept lazy continuations. This is a best effort simulation of
# the block condition, to be used for some complex multi-line constructs that
# are parsed through a single regex.
sub _enter_child_block {
  my ($this, $new_block, $cond, $prefix_re, $forced_next_line) = @_;
  $this->_finalize_paragraph(1);
  if (defined $forced_next_line) {
    $this->{forced_line} = $forced_next_line;
  }
  push @{$this->{blocks_stack}}, {
        cond => $cond,
        block => $new_block,
        parent_blocks => $this->{blocks},
        continuation_re => $this->{continuation_re}
      };
  $this->{continuation_re} = qr/$this->{continuation_re} $prefix_re/x;
  $this->{blocks} = [];
  return;
}

sub _restore_parent_block {
  my ($this) = @_;
  # TODO: rename the variables here with something better.
  my $last_block = pop @{$this->{blocks_stack}};
  my $block = delete $last_block->{block};
  # TODO: maybe rename content to blocks here.
  $block->{content} = $this->{blocks};
  $this->{blocks} = delete $last_block->{parent_blocks};
  $this->{continuation_re} = delete $last_block->{continuation_re};
  $this->_add_block($block);
  return;
}

# Returns true if $l would be parsed as the continuation of a paragraph in the
# context of $this (which is not modified).
sub _test_lazy_continuation {
  my ($this, $l) = @_;
  return unless @{$this->{paragraph}};
  my $tester = new(ref($this), $this->{pmarkdown}, \'');
  pos($tester->{md}) = 0;
  # What is a paragraph depends on whether we already have a paragraph or not.
  $tester->{paragraph} = [@{$this->{paragraph}} ? ('foo') : ()];
  # We use this field both in the tester and in the actual object when we
  # matched a lazy continuation.
  $tester->{is_lazy_continuation} = 1;
  # We’re ignoring the eol of the original line as it should not affect parsing.
  $tester->_parse_blocks($l);
  # BUG: there is a bug here which is that a construct like a fenced code block
  # or a link ref definition, whose validity depends on more than one line,
  # might be misclassified. The probability of that is low.
  if (@{$tester->{paragraph}}) {
    $this->{is_lazy_continuation} = 1;
    return 1;
  }
  return 0;
}

sub _count_matching_blocks {
  my ($this, $lr) = @_;  # $lr is a scalar *reference* to the current line text.
  $this->{matched_prefix_size} = 0;
  for my $i (0 .. $#{$this->{blocks_stack}}) {
    local *::_ = $lr;
    my $r = $this->{blocks_stack}[$i]{cond}();
    $this->{matched_prefix_size} += $r if defined $r && $r > 0;  # $r < 0 means match but no prefix.
    return $i unless $r;
  }
  return @{$this->{blocks_stack}};
}

sub _all_blocks_match {
  my ($this, $lr) = @_;
  return @{$this->{blocks_stack}} == $this->_count_matching_blocks($lr);
}

my $thematic_break_re = qr/^\ {0,3} (?: (?:-[ \t]*){3,} | (_[ \t]*){3,} | (\*[ \t]*){3,} ) $/x;
my $block_quotes_re = qr/^ {0,3}>/;
my $indented_code_re = qr/^(?: {0,3}\t| {4})/;
my $list_item_marker_re = qr/ [-+*] | (?<digits>\d{1,9}) (?<symbol>[.)])/x;
my $list_item_re =
    qr/^ (?<indent>\ {0,3}) (?<marker>${list_item_marker_re}) (?<text>(?:[ \t].*)?) $/x;
my $supported_html_tags = join('|',
  qw(address article aside base basefont blockquote body caption center col colgroup dd details dialog dir div dl dt fieldset figcaption figure footer form frame frameset h1 h2 h3 h4 h5 h6 head header hr html iframe legend li link main menu menuitem nav noframes ol optgroup option p param search section summary table tbody td tfoot th thead title tr track ul)
);

my $directive_name_re = qr/(?<name> [-\w]+ )?/x;
my $directive_content_re = qr/(?: \s* \[ (?<content> [^\]]+ ) \] )?/x;
my $directive_attribute_re = qr/(?: \s* \{ (?<attributes> .* ) \} )?/x;
my $directive_data_re = qr/${directive_name_re} ${directive_content_re} ${directive_attribute_re}/x;
my $directive_block_re = qr/^\ {0,3} (?<marker> :{3,} ) \s* ${directive_data_re} \s* :* \s* $/x;

# TODO: Share these regex with the Inlines.pm file that has a copy of them.
my $html_tag_name_re = qr/[a-zA-Z][-a-zA-Z0-9]*/;
my $html_attribute_name_re = qr/[a-zA-Z_:][-a-zA-Z0-9_.:]*/;
# We include new lines in these regex as the spec mentions them, but we can’t
# match them for now as the regex will see lines one at a time.
my $html_space_re = qr/\n[ \t]*|[ \t][ \t]*\n?[ \t]*/;  # Spaces, tabs, and up to one line ending.
my $opt_html_space_re = qr/[ \t]*\n?[ \t]*/;  # Optional spaces.
my $html_attribute_value_re = qr/ [^ \t\n"'=<>`]+ | '[^']*' | "[^"]*" /x;
my $html_attribute_re =
    qr/ ${html_space_re} ${html_attribute_name_re} (?: ${opt_html_space_re} = ${opt_html_space_re} ${html_attribute_value_re} )? /x;
my $html_open_tag_re =
    qr/ < ${html_tag_name_re} ${html_attribute_re}* ${opt_html_space_re} \/? > /x;
my $html_close_tag_re = qr/ <\/ ${html_tag_name_re} ${opt_html_space_re} > /x;

# Parse at least one line of text to build a new block; and possibly several
# lines, depending on the block type.
# https://spec.commonmark.org/0.30/#blocks-and-inlines
our $l;  # global variable, localized during the call to _parse_blocks.

sub _parse_blocks {  ## no critic (RequireArgUnpacking)
  my $this = shift @_;
  # TODO do the localization in process to avoid the copy (but this will need
  # change in the continuation tester).
  local $l = shift @_;  ## no critic (ProhibitLocalVars)

  if (!$this->{skip_next_block_matching}) {
    my $matched_block = $this->_count_matching_blocks(\$l);
    if (@{$this->{blocks_stack}} > $matched_block) {
      $this->_finalize_paragraph();
      while (@{$this->{blocks_stack}} > $matched_block) {
        $this->_restore_parent_block();
      }
    }
  } else {
    $this->{skip_next_block_matching} = 0;
  }

  # There are two different cases. The first one, handled here, is when we have
  # multiple blocks inside a list item separated by a blank line. The second
  # case (when the list items themselves are separated by a blank line) is
  # handled when parsing the list item itself (based on the last_line_was_blank
  # setting).
  if ($this->{last_line_is_blank}) {
    if (@{$this->{blocks_stack}}
      && $this->{blocks_stack}[-1]{block}{type} eq 'list_item') {
      # $this->{blocks_stack}[-1]{block}{loose} = 1;
    }
  }
  $this->{last_line_was_blank} = $this->{last_line_is_blank};
  $this->{last_line_is_blank} = 0;

  _do_atx_heading($this)
      || ($this->get_use_setext_headings && _do_setext_heading($this))
      # Thematic breaks are described first in the spec, but the setext headings has
      # precedence in case of conflict, so we test for the break after the heading.
      || _do_thematic_break($this)
      || _do_indented_code_block($this)
      || ($this->get_use_fenced_code_blocks && _do_fenced_code_block($this))
      || _do_html_block($this)
      || _do_block_quotes($this)
      || _do_list_item($this)
      || _do_directive_block($this)
      || _do_link_reference_definition($this)
      || ($this->get_use_table_blocks && _do_table_block($this))
      || _do_paragraph($this)
      || croak "Current line could not be parsed as anything: $l";
  return;
}

sub _load_yaml_module {
  my ($module_name) = @_;
  if (!eval "require $module_name; 1") {  ## no critic (BuiltinFunctions::ProhibitStringyEval)
    croak "Cannot load module $module_name: ${EVAL_ERROR}";
  }
  return;
}

sub _call_yaml_parser {
  my ($this, $yaml) = @_;
  my $parser = $this->get_yaml_parser;
  my $metadata;
  if ($parser eq 'YAML::Tiny') {
    return eval { YAML::Tiny->read_string($yaml)->[0] };
  } elsif ($parser eq 'YAML::PP' || $parser eq 'YAML::PP::LibYAML') {
    _load_yaml_module($parser);
    return eval { ($parser->new()->load_string($yaml))[0] };
  }
  croak "Unsupported YAML parser: $parser";
}

sub _parse_yaml_metadata {
  my ($this) = @_;

  # At this point, pos(md) is guaranteed to be 0.
  my $line_re = $this->get_yaml_file_metadata_allows_empty_lines ? qr/.*\n/ : qr/.+\n/;
  if ($this->{md} =~ m/ ^ ---\n (?<YAML> (?: $line_re )+? ) (?: --- | \.\.\. ) \n /gxc) {  ## no critic (ProhibitUnusedCapture)
    my $metadata = $this->_call_yaml_parser($+{YAML});
    if ($EVAL_ERROR) {
      pos($this->{md}) = 0;
      carp 'YAML Metadata (Markdown frontmatter) is invalid' if $this->get_warn_for_unused_input();
      return;
    }
    if (exists($this->{pmarkdown}{hooks}{yaml_metadata})) {
      $this->{pmarkdown}{hooks}{yaml_metadata}->($metadata);
    }
  }
  return;
}

# https://spec.commonmark.org/0.30/#atx-headings
sub _do_atx_heading {
  my ($this) = @_;
  if ($l =~ /^ \ {0,3} (\#{1,6}) (?:[ \t]+(.+?))?? (?:[ \t]+\#+)? [ \t]* $/x) {
    # Note: heading breaks can interrupt a paragraph or a list
    # TODO: the content of the header needs to be interpreted for inline content.
    $this->_add_block({
      type => 'heading',
      level => length($1),
      content => $2 // '',
      debug => 'atx'
    });
    return 1;
  }
  return;
}

# https://spec.commonmark.org/0.30/#setext-headings
sub _do_setext_heading {
  my ($this) = @_;
  return unless $l =~ /^ {0,3}(-+|=+)[ \t]*$/;
  if ( !@{$this->{paragraph}}
    || indent_size($this->{paragraph}[0]) >= 4
    || $this->{is_lazy_continuation}) {
    return;
  }
  # TODO: this should not interrupt a list if the heading is just one -
  my $c = substr $1, 0, 1;
  my $p = $this->{paragraph};
  my $m = $this->get_multi_lines_setext_headings;
  if ($m eq 'single_line' && @{$p} > 1) {
    my $last_line = pop @{$p};
    $this->_finalize_paragraph();
    $p = [$last_line];
  } elsif ($m eq 'break' && $l =~ m/${thematic_break_re}/) {
    $this->_finalize_paragraph();
    $this->_add_block({type => 'break', debug => 'setext_as_break'});
    return 1;
  } elsif ($m eq 'ignore') {
    # TODO: maybe we should just do nothing and return 0 here.
    push @{$this->{paragraph}}, $l;
    return 1;
  }
  $this->{paragraph} = [];
  $this->_add_block({
    type => 'heading',
    level => ($c eq '=' ? 1 : 2),
    content => $p,
    debug => 'setext'
  });
  return 1;
}

# https://spec.commonmark.org/0.30/#thematic-breaks
sub _do_thematic_break {
  my ($this) = @_;
  if ($l !~ /${thematic_break_re}/) {
    return;
  }
  $this->_add_block({type => 'break', debug => 'native_break'});
  return 1;
}

# https://spec.commonmark.org/0.30/#indented-code-blocks
sub _do_indented_code_block {
  my ($this) = @_;
  # Indented code blocks cannot interrupt a paragraph.
  if (@{$this->{paragraph}} || $l !~ m/${indented_code_re}/) {
    return;
  }
  my $convert_tabs = $this->get_code_blocks_convert_tabs_to_spaces;
  tabs_to_space($l, $this->{matched_prefix_size}) if $convert_tabs;
  my @code_lines = scalar(remove_prefix_spaces(4, $l.$this->line_ending()));
  my $count = 1;  # The number of lines we have read
  my $valid_count = 1;  # The number of lines we know are in the code block.
  my $valid_pos = $this->get_pos();
  while (defined (my $nl = $this->next_line())) {
    if ($this->_all_blocks_match(\$nl)) {
      $count++;
      if ($nl =~ m/${indented_code_re}/) {
        $valid_pos = $this->get_pos();
        $valid_count = $count;
        tabs_to_space($nl, $this->{matched_prefix_size}) if $convert_tabs;
        push @code_lines, scalar(remove_prefix_spaces(4, $nl.$this->line_ending()));
      } elsif ($nl eq '') {
        push @code_lines, scalar(remove_prefix_spaces(4, $nl.$this->line_ending(), !$convert_tabs));
      } else {
        last;
      }
    } else {
      last;
    }
  }
  splice @code_lines, $valid_count;
  $this->set_pos($valid_pos);
  my $code = join('', @code_lines);
  $this->_add_block({type => 'code', content => $code, debug => 'indented'});
  return 1;
}

# https://spec.commonmark.org/0.30/#fenced-code-blocks
sub _do_fenced_code_block {
  my ($this) = @_;
  return unless $l =~ /^ (?<indent>\ {0,3}) (?<fence>`{3,}|~{3,}) [ \t]* (?<info>.*?) [ \t]* $/x;  ## no critic (ProhibitComplexRegexes)
  my $f = substr $+{fence}, 0, 1;
  if ($f eq '`' && index($+{info}, '`') != -1) {
    return;
  }
  my $fl = length($+{fence});
  my $info = $+{info};
  my $indent = length($+{indent});
  # This is one of the few case where we need to process character escaping
  # outside of the full inlines rendering process.
  # TODO: Consider if it would be cleaner to do it inside the render_html method.
  $info =~ s/\\(\p{PosixPunct})/$1/g;
  # The spec does not describe what we should do with fenced code blocks inside
  # other containers if we don’t match them.
  my @code_lines;  # The first line is not part of the block.
  my $end_fence_seen = 0;
  my $start_pos = $this->get_pos();
  while (defined (my $nl = $this->next_line())) {
    if ($this->_all_blocks_match(\$nl)) {
      if ($nl =~ m/^ {0,3}${f}{$fl,}[ \t]*$/) {
        $end_fence_seen = 1;
        last;
      } else {
        # We’re adding one line to the fenced code block
        push @code_lines, scalar(remove_prefix_spaces($indent, $nl.$this->line_ending()));
      }
    } else {
      # We’re out of our enclosing block and we haven’t seen the end of the
      # fence. If we accept enclosed fence, then that last line must be tried
      # again (and, otherwise, we will start again from start_pos).
      $this->redo_line() if !$this->get_fenced_code_blocks_must_be_closed;
      last;
    }
  }

  if (!$end_fence_seen && $this->get_fenced_code_blocks_must_be_closed) {
    $this->set_pos($start_pos);
    return;
  }
  my $code = join('', @code_lines);
  $this->_add_block({
    type => 'code',
    content => $code,
    info => $info,
    debug => 'fenced'
  });
  return 1;
}

# https://spec.commonmark.org/0.31.2/#html-blocks
sub _do_html_block {
  my ($this) = @_;
  # HTML blocks can interrupt a paragraph.
  # TODO: add an option so that they don’t interrupt a paragraph (make it be
  # the default?).
  # TODO: PERF: test that $l =~ m/^ {0,3}</ to short circuit all these regex.
  my $html_end_condition;
  if ($l =~ m/ ^\ {0,3} < (?:pre|script|style|textarea) (?:\ |\t|>|$) /x) {
    $html_end_condition = qr/ <\/ (?:pre|script|style|textarea) > /x;
  } elsif ($l =~ m/^ {0,3}<!--/) {
    $html_end_condition = qr/-->/;
  } elsif ($l =~ m/^ {0,3}<\?/) {
    $html_end_condition = qr/\?>/;
  } elsif ($l =~ m/^ {0,3}<![a-zA-Z]/) {
    $html_end_condition = qr/=>/;
  } elsif ($l =~ m/^ {0,3}<!\[CDATA\[/) {
    $html_end_condition = qr/]]>/;
  } elsif ($l =~ m/^\ {0,3} < \/? (?:${supported_html_tags}) (?:\ |\t|\/?>|$) /x) {
    $html_end_condition = qr/^$/;  ## no critic (ProhibitFixedStringMatches)
  } elsif (!@{$this->{paragraph}}
    && $l =~ m/^\ {0,3} (?: ${html_open_tag_re} | ${html_close_tag_re} ) [ \t]* $ /x) {
    # TODO: the spec seem to say that the tag can take more than one line, but
    # this is not tested, so we don’t implement this for now.
    $html_end_condition = qr/^$/;  ## no critic (ProhibitFixedStringMatches)
  }
  # TODO: Implement rule 7 about any possible tag.
  if (!$html_end_condition) {
    return;
  }
  # TODO: see if some code could be shared with the code blocks
  my @html_lines = $l.$this->line_ending();
  # TODO: add an option to not parse a tag if it’s closing condition is never
  # seen.
  if ($l !~ m/${html_end_condition}/) {
    # The end condition can occur on the opening line.
    while (defined (my $nl = $this->next_line())) {
      if ($this->_all_blocks_match(\$nl)) {
        if ($nl !~ m/${html_end_condition}/) {
          push @html_lines, $nl.$this->line_ending();
        } elsif ($nl eq '') {
          # This can only happen for rules 6 and 7 where the end condition
          # line is not part of the HTML block.
          $this->redo_line();
          last;
        } else {
          push @html_lines, $nl.$this->line_ending();
          last;
        }
      } else {
        $this->redo_line();
        last;
      }
    }
  }
  my $html = join('', @html_lines);
  remove_disallowed_tags($html, $this->get_disallowed_html_tags);
  $this->_add_block({type => 'html', content => $html});
  return 1;
}

# https://spec.commonmark.org/0.30/#block-quotes
sub _do_block_quotes {
  my ($this) = @_;
  return unless $l =~ /${block_quotes_re}/;
  # TODO: handle laziness (block quotes where the > prefix is missing)
  my $cond = sub {
    if (s/(${block_quotes_re})/' ' x length($1)/e) {
      # We remove the '>' character that we replaced by a space, and the
      # optional space after it. We’re using this approach to correctly handle
      # the case of a line like '>\t\tfoo' where we need to retain the 6
      # spaces of indentation, to produce a code block starting with two
      # spaces.
      my $m;
      ($_, $m) = remove_prefix_spaces(length($1) + 1, $_);
      # Returns the matched horizontal size.
      return $m;
    }
    return $this->_test_lazy_continuation($_);
  };
  {
    local *::_ = \$l;
    $this->{matched_prefix_size} += $cond->();
  }
  $this->{skip_next_block_matching} = 1;
  $this->_enter_child_block({type => 'quotes'}, $cond, qr/ {0,3}(?:> ?)?/, $l);
  return 1;
}

# https://spec.commonmark.org/0.30/#list-items
sub _do_list_item {
  my ($this) = @_;
  return unless $l =~ m/${list_item_re}/;
  # There is a note in the spec on thematic breaks that are not list items,
  # it’s not exactly clear what is intended, and there are no examples.
  my ($indent_outside, $marker, $text, $digits, $symbol) = @+{qw(indent marker text digits symbol)};
  my $indent_marker = length($indent_outside) + length($marker);
  my $type = $marker =~ m/[-+*]/ ? 'ul' : 'ol';
  # The $indent_marker is passed in case the text starts with tabs, to properly
  # compute the tab stops. This is better than nothing but won’t work inside
  # other container blocks. In all cases, using tabs instead of space should not
  # be encouraged.
  my $text_indent = indent_size($text, $indent_marker + $this->{matched_prefix_size});
  # When interrupting a paragraph, the rules are stricter.
  my $mode = $this->get_lists_can_interrupt_paragraph;
  if (@{$this->{paragraph}}) {
    return if $mode eq 'never';
    if ($mode eq 'within_list'
      && !(@{$this->{blocks_stack}} && $this->{blocks_stack}[-1]{block}{type} eq 'list_item')) {
      return;
    }
    if ($mode eq 'strict' && ($text eq '' || ($type eq 'ol' && $digits != 1))) {
      return;
    }
  }
  return if $text ne '' && $text_indent == 0;
  # in the current implementation, $text_indent is enough to know if $text
  # is matching $indented_code_re, but let’s not depend on that.
  my $first_line_blank = $text =~ m/^[ \t]*$/;
  my $discard_text_indent = $first_line_blank || indented(4 + 1, $text);  # 4 + 1 is an indented code block, plus the required space after marker.
  my $indent_inside = $discard_text_indent ? 1 : $text_indent;
  my $indent = $indent_inside + $indent_marker;
  my $cond = sub {
    if ($first_line_blank && m/^[ \t]*$/) {
      # A list item can start with at most one blank line
      return 0;
    } else {
      $first_line_blank = 0;
    }
    if (indent_size($_) >= $indent) {
      $_ = remove_prefix_spaces($indent, $_);
      # Returns the matched horizontal size.
      return $indent;
    }
    # TODO: we probably don’t need to test the list_item_re case here, just
    # the lazy continuation and the emptiness is enough.
    return (!m/${list_item_re}/ && $this->_test_lazy_continuation($_))
        || $_ eq '';
  };
  my $forced_next_line = undef;
  if (!$first_line_blank) {
    # We are doing a weird compensation for the fact that we are not
    # processing the condition and to correctly handle the case where the
    # list marker was followed by tabs.
    $forced_next_line = remove_prefix_spaces($indent, (' ' x $indent_marker).$text);
    $this->{matched_prefix_size} = $indent;
    $this->{skip_next_block_matching} = 1;
  }
  # Note that we are handling the creation of the lists themselves in the
  # _add_block method. See https://spec.commonmark.org/0.30/#lists for
  # reference.
  # TODO: handle tight and loose lists.
  my $item = {
    type => 'list_item',
    style => $type,
    marker => $symbol // $marker,
    num => int($digits // 1),
  };
  $item->{loose} =
      $this->_list_match($item) && $this->{last_line_was_blank};
  $this->_enter_child_block($item, $cond, qr/ {0,${indent}}/, $forced_next_line);
  return 1;
}

# https://talk.commonmark.org/t/generic-directives-plugins-syntax/444
# See also https://github.com/mkende/pmarkdown/issues/5
sub _do_directive_block {
  my ($this) = @_;
  return unless $this->get_use_directive_blocks();
  # marker, name, content, attributes
  return unless $l =~ /${directive_block_re}/;  # TODO: add an option to allow this block type.
  my $lm = length($+{marker});
  my $cond = sub {
    if (m/^\ {0,3} :{$lm,} \s* $/x) {
      $_ = '';
      return 0;
    }
    return -1;
  };
  # At rendering time, a hook should be able to intercept the name and
  # attributes of the directive to do fancy things with it.
  $this->_enter_child_block({
      type => 'directive',
      name => $+{name},
      inline => $+{content},
      attributes => $+{attributes}
    },
    $cond,
    qr/ {0,3}/);  # Unclear if we need the continuation prefix here.
  return 1;
}

# https://spec.commonmark.org/0.31.2/#link-reference-definitions
sub _do_link_reference_definition {
  my ($this) = @_;
  # Link reference definitions cannot interrupt paragraphs
  #
  # This construct needs to be parsed across multiple lines, so we are directly
  # using the {md} string rather than our parsed $l line
  # TODO: another maybe much simpler approach would be to parse the block as a
  # normal paragraph but immediately try to parse the content as a link
  # reference definition (and otherwise to keep it as a normal paragraph).
  # That would allow to use the higher lever InlineTree parsing constructs.
  return if @{$this->{paragraph}} || $l !~ m/^ {0,3}\[/;
  my $last_pos = $this->{last_pos};
  my $init_pos = $this->get_pos();
  $this->redo_line();
  my $start_pos = $this->get_pos();

  # We consume the continuation prefix of enclosing blocks. Note that in the big
  # regex we allow any number of space after the continuation because it’s what
  # cmark does.
  my $cont = $this->{continuation_re};
  confess 'Unexpected regex match failure' unless $this->{md} =~ m/\G${cont}/g;

  # TODO:
  # - Support for escaped or balanced parenthesis in naked destination
  # - break this up in smaller pieces and test them independently.
  # - The need to disable ProhibitUnusedCapture seems to be buggy...
  # - most of the regex parses only \n and not other eol sequence. The regex
  #   should either be fixed or the entry be normalized.
  ## no critic (ProhibitComplexRegexes, ProhibitUnusedCapture)
  if (
    $this->{md} =~ m/\G
      \ {0,3} \[
      (?>(?<LABEL>                                            # The link label (in square brackets), matched as an atomic group
        (?:
          [^\\\[\]]{0,100} (?:(?:\\\\)* \\ .)?                # The label cannot contain unescaped ]
          # With 5.38 this could be (?(*{ ...}) (*FAIL))  which will be more efficient.
          (*COMMIT) (?(?{ pos() > $start_pos + 1004 }) (*FAIL) )  # As our block can be repeated, we prune the search when we are far enough.
        )+ 
      )) \]:
      [ \t]* (?:\n ${cont})? [ \t]*                           # optional spaces and tabs with up to one line ending
      (?>(?<TARGET>                                           # the destination can be either:
        < (?: [^\n>]* (?<! \\) (?:\\\\)* )+ >                 # - enclosed in <> and containing no unescaped >
        | [^< [:cntrl:]] [^ [:cntrl:]]*                       # - not enclosed but cannot contains spaces, new lines, etc. and only balanced or escaped parenthesis
      ))
      (?:
        # Note that this is an atomic pattern so that we don’t backtrack in it
        # (so the pattern must not erroneously accept one of its branch).
        (?> [ \t]* (?:\n ${cont}) [ \t]* | [ \t]+ )           # The spec says that spaces must be present here, but it seems that a new line is fine too.
        (?<TITLE>                                             # The title can be between ", ' or (). The matching characters can’t appear unescaped in the title
          "  (:?[^\n"]* (?: (?<! \n) \n (?! \n) | (?<! \\) (?:\\\\)* \\ " )? )* "
        |  '  (:?[^\n']* (?: (?<! \n) \n (?! \n) | (?<! \\) (?:\\\\)* \\ ' )? )* '
        |  \( (:?[^\n"()]* (?: (?<! \n) \n (?! \n) | (?<! \\) (?:\\\\)* \\ [()] )? )* \)
        )
      )?
      [ \t]*(:?\r\n|\n|\r|$)                                  # The spec says that no characters can occur after the title, but it seems that whitespace is tolerated.
      /gx
    ## use critic
  ) {
    my ($ref, $target, $title) = @LAST_PAREN_MATCH{qw(LABEL TARGET TITLE)};
    $ref = normalize_label($ref);
    if ($ref ne '') {
      $this->_finalize_paragraph(1);
      # TODO: option to keep the last appearance instead of the first one.
      if (exists $this->{linkrefs}{$ref}) {
        # We keep the first appearance of a label.
        # TODO: mention the link label.
        carp 'Only the first appearance of a link reference definition is kept'
            if $this->get_warn_for_unused_input();
        return 1;
      }
      if (defined $title) {
        $title =~ s/^.(.*).$/$1/s;
        _unescape_char($title);
      }
      $target =~ s/^<(.*)>$/$1/;
      _unescape_char($target);
      $this->{linkrefs}{$ref} = {
        target => $target,
        (defined $title ? ('title' => $title) : ())
      };
      return 1;
    }
    #pass-through intended;
  }
  $this->set_pos($init_pos, $last_pos);
  return;
}

# https://github.github.com/gfm/#tables-extension-
sub _do_table_block {
  my ($this) = @_;

  # TODO: add an option to prevent interrupting a paragraph with a table (and
  # make it be true for pmarkdown, but not for github where tables can interrupt
  # a paragraph).
  # TODO: github supports omitting the first | even on the first line when we
  # are not interrupting a paragraph and when subsequent the delimiter line has
  # more than one dash per cell.
  my $i = !!@{$this->{paragraph}};
  return if $i && !$this->get_table_blocks_can_interrupt_paragraph;
  my $m = $this->get_table_blocks_pipes_requirements;
  # The tests here are quite lenient and there are many ways in which parsing
  # the table can fail even if these tests pass.
  if ($m eq 'strict' || ($m eq 'loose' && $i)) {
    return unless $l =~ m/^ {0,3}\|/;
  } else {
    return unless $l =~ m/ (?<! \\) (?:\\\\)* \| /x;
  }
  my $last_pos = $this->{last_pos};
  my $init_pos = $this->get_pos();
  $this->redo_line();
  my $table = $this->_parse_table_structure();
  if (!$table) {
    $this->set_pos($init_pos, $last_pos);
    return;
  }

  $this->_add_block({type => 'table', content => $table});

  return 1;
}

sub _parse_table_structure {  ## no critic (ProhibitExcessComplexity)
  my ($this) = @_;

  my $m = $this->get_table_blocks_pipes_requirements;
  my $i = !!@{$this->{paragraph}};

  # A regexp that matches no back-slashes or an even number of them, so that the
  # next character cannot be escaped.
  my $e = qr/(?<! \\) (?:\\\\)*/x;

  # We consume the continuation prefix of enclosing blocks. Note that,
  # as opposed to what happens for links, subsequent lines can have at most
  # 3 more spaces than the initial one with the GitHub implementation (but not
  # some other GFM implementations).
  my $cont = $this->{continuation_re};
  confess 'Unexpected regex match failure' unless $this->{md} =~ m/\G${cont}/g;
  # We want to allow successive 0 length matches. For more details on this
  # behavior, see:
  # https://perldoc.perl.org/perlre#Repeated-Patterns-Matching-a-Zero-length-Substring
  pos($this->{md}) = pos($this->{md});

  # Now we consume the initial | marking the beginning of the table that we know
  # is here because of the initial match against $l in _do_table_block.
  confess 'Unexpected missing table markers' unless $this->{md} =~ m/\G (\ {0,3}) (\|)?/gcx;

  my $n = length($1) + 3;  # Maximum amount of space allowed on subsequent line
  my $has_pipe = defined $2;

  # We parse the header row
  my @headers = $this->{md} =~ m/\G [ \t]* (.*? [ \t]* $e) \| /gcx;
  return unless @headers;
  # We parse the last header if it is not followed by a pipe, and the newline.
  # The only failure case here is if we have reached the end of the file.
  return unless $this->{md} =~ m/\G [ \t]* (.+)? [ \t]* ${eol_re} /gcx;
  if (defined $1) {
    push @headers, $1;
    $has_pipe = 0;
  }

  return if ($m eq 'strict' || ($m eq 'loose' && $i) || @headers == 1) && !$has_pipe;

  # We consume the continuation marker at the beginning of the delimiter row.
  return unless $this->{md} =~ m/\G ${cont} \ {0,$n} (\|)? /gx;

  $has_pipe &&= defined $1;

  my @separators = $this->{md} =~ m/\G [ \t]* ( :? -+ :? ) [ \t]* \| /gcx;
  return unless $this->{md} =~ m/\G [ \t]* (:? -+ :?)? [ \t]* (:? ${eol_re} | $ ) /gcx;
  if (defined $1) {
    push @separators, $1;
    $has_pipe = 0;
  }
  return unless @separators == @headers;
  my @align =
      map { s/^(:)?-+(:)?$/ $1 ? ($2 ? 'center' : 'left') : ($2 ? 'right' : '') /er } @separators;

  return if ($m eq 'strict' || ($m eq 'loose' && $i) || @headers == 1) && !$has_pipe;
  return if $m ne 'lax' && @headers == 1 && !$has_pipe;
  return if $m ne 'lax' && !$has_pipe && min(map { length } @separators) < 2;

  # And now we try to read as many lines as possible
  my @table;
  while (1) {
    last if pos($this->{md}) == length($this->{md});
    last unless $this->{md} =~ m/\G ${cont} \ {0,$n} (\|)? /gcx;
    # TODO: use a simulator to decide whether we are entering a new block-level
    # structure, rather than using this half baked regex.
    $has_pipe &&= defined $1;
    last if !defined $1 && $this->{md} =~ m/\G (?: [ ] | > | ${list_item_marker_re} )/x;
    my @cells = $this->{md} =~ m/\G [ \t]* (.*? [ \t]* $e) \| /gcx;
    pos($this->{md}) = pos($this->{md});
    confess 'Unexpected match failure'
        unless $this->{md} =~ m/\G [ \t]* (.+)? [ \t]* (?: ${eol_re} | $ ) /gcx;
    if (defined $1) {
      push @cells, $1;
      $has_pipe = 0;
    }
    # There is a small bug when we exit here which is that we have consumed a
    # blank line. The only case where it would matter would be to decide whether
    # a list is loose or not, which is a pretty "edge" case with tables.
    # Otherwise, we will start a new paragraph in all cases.
    last unless @cells;
    if (@cells != @headers) {
      $#cells = @headers - 1;
      # TODO: mention the line number in the file (if possible to track
      # correctly).
      carp 'Excess cells in table row are ignored'
          if @cells > @headers && $this->get_warn_for_unused_input();
    }
    # Pipes need to be escaped inside table, and we need to unescape them here
    # in case one would appear in a code block for example (where the escaping
    # would appear literally otherwise). Given that pipes don’t have other
    # meaning by default, there is not a big risk to do that (and this is
    # mandated) by the GitHub Spec anyway.
    push @table, [map { defined ? s/($e)\\\|/${1}|/gr : undef } @cells];
  }

  return {headers => \@headers, align => \@align, table => \@table};
}

# https://spec.commonmark.org/0.30/#paragraphs
sub _do_paragraph {
  my ($this) = @_;
  # We need to test for blank lines here (not just emptiness) because after we
  # have removed the markers of container blocks our line can become empty. The
  # fact that we need to do this, seems to imply that we don’t really need to
  # check for emptiness when initially building $l.
  # TODO: check if the blank-line detection in next_line() is needed or not.
  if ($l !~ m/^[ \t]*$/) {
    push @{$this->{paragraph}}, $l;
    return 1;
  }

  # https://spec.commonmark.org/0.30/#blank-lines
  # if ($l eq '')
  $this->_finalize_paragraph();
  # Needed to detect loose lists. But ignore blank lines when they are inside
  # block quotes
  $this->{last_line_is_blank} =
      !@{$this->{blocks_stack}} || $this->{blocks_stack}[-1]{block}{type} ne 'quotes';
  return 1;
}

sub _unescape_char {
  # TODO: configure the set of escapable character. Note that this regex is
  # shared with Inlines.pm process_char_escaping.
  $_[0] =~ s/\\(\p{PosixPunct})/$1/g;
  return;
}

1;
