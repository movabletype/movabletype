package Markdown::Perl::Options;

use strict;
use warnings;
use utf8;
use feature ':5.24';

use Carp;
use English;
use Exporter 'import';
use List::Util 'any', 'all', 'pairs';

our $VERSION = '0.02';

our @EXPORT_OK = qw(validate_options);
our %EXPORT_TAGS = (all => \@EXPORT_OK);

=pod

=encoding utf8

=head1 NAME

Configuration options for pmarkdown and Markdown::Perl

=head1 SYNOPSIS

This document describes the existing configuration options for the
L<Markdown::Perl> library and the L<pmarkdown> program. Please refer to their
documentation to know how to set and use these options.

=head1 MODES

In addition to setting individual options, you can set bundle of options
together using I<modes>. See the L<pmarkdown/MODES> documentation for a list
of available modes. And see the documentation for L<Markdown::Perl> or
L<pmarkdown> to learn how to set a mode.

Note that all options are applied I<on top> of the selected mode. Even if the
options are passed before the mode, the mode will not override the options.

Note also that only the modes are tested as coherent selves. Setting individual
options on top of a given mode might result in inconsistent behavior.

=head1 OPTIONS

=cut

sub new {
  my ($class, %options) = @_;

  my $this = bless \%options, $class;
  $this->{memoized} = {};  # TODO: use this.
  return $this;
}

my %options_modes;
my %validation;

# Undocumented for now, used in tests.
our @valid_modes = (qw(default cmark github markdown));
my %valid_modes = map { $_ => 1 } @valid_modes;

my $err_str;

sub set_options {
  my ($this, $dest, @options) = @_;
  # We don’t put the options into a hash, to preserve the order in which they
  # are passed.
  for my $p (pairs @options) {
    my ($k, $v) = @{$p};
    if ($k eq 'mode') {
      $this->Markdown::Perl::Options::set_mode($dest, $v);
    } else {
      carp "Unknown option ignored: ${k}" unless exists $validation{$k};
      my $validated_value = $validation{$k}($v);
      croak "Invalid value for option '${k}': ${err_str}" unless defined $validated_value;
      $this->{$dest}{$k} = $validated_value;
    }
  }
  return;
}

# returns nothing but dies if the options are not valid. Useful to call before
# set_options to get error messages without stack-traces in context where this
# is not needed (while set_options will use carp/croak).
sub validate_options {
  my (%options) = @_;
  while (my ($k, $v) = each %options) {
    if ($k eq 'mode') {
      die "Unknown mode '${v}'\n" unless exists $options_modes{$v};
    } else {
      die "Unknown option: ${k}\n" unless exists $validation{$k};
      my $validated = $validation{$k}($v);
      die "Invalid value for option '${k}': ${err_str}\n" unless defined $validated;
    }
  }
  return;
}

sub set_mode {
  my ($this, $dest, $mode) = @_;
  carp "Setting mode '${mode}' overriding already set mode '$this->{$dest}{mode}'"
      if defined $this->{$dest}{mode};
  croak "Unknown mode '${mode}'" unless exists $valid_modes{$mode};
  $this->{$dest}{mode} = $mode;
  return;
}

# This method is called below to "create" each option. In particular, it
# populate an accessor method in this package to reach the option value.
sub _make_option {
  my ($opt, $default, $validation, %mode) = @_;
  while (my ($k, $v) = each %mode) {
    confess "Unknown mode '${k}' when creating option '${opt}'" unless exists $valid_modes{$k};
    $options_modes{$k}{$opt} = $v;
  }
  $validation{$opt} = $validation;

  {
    no strict 'refs';
    *{"get_${opt}"} = sub {
      my ($this) = @_;
      return $this->{local_options}{$opt} if exists $this->{local_options}{$opt};
      return $this->{options}{$opt} if exists $this->{options}{$opt};
      if (defined $this->{local_options}{mode}) {
        # We still enter here if the mode is 'default', to not enter the global
        # mode (a local mode entirely shadows a global mode).
        return $options_modes{$this->{local_options}{mode}}{$opt}
            if exists $options_modes{$this->{local_options}{mode}}{$opt};
      } elsif (defined $this->{options}{mode}) {
        return $options_modes{$this->{options}{mode}}{$opt}
            if exists $options_modes{$this->{options}{mode}}{$opt};
      }
      return $default;
    };
  }

  return;
}

sub _boolean {
  return sub {
    return 0 if $_[0] eq 'false' || $_[0] eq '' || $_[0] eq '0';
    return 1 if $_[0] eq 'true' || $_[0] eq '1';
    $err_str = 'must be a boolean value (0 or 1)';
    return;
  };
}

sub _enum {
  my @valid = @_;
  return sub {
    return $_[0] if any { $_ eq $_[0] } @valid;
    $err_str = "must be one of '".join("', '", @valid)."'";
    return;
  };
}

sub _regex {
  return sub {
    my $re = eval { qr/$_[0]/ };
    return $re if defined $re;
    $err_str = 'cannot be parsed as a Perl regex ($@)';
    return;
  };
}

sub _word_list {
  return sub {
    my @a = ref $_[0] eq 'ARRAY' ? @{$_[0]} : split(/,/, $_[0]);
    # TODO: validate the values of a.
    return \@a;
  };
}

=pod

=head2 Options controlling which top-level blocks are used

=head3 B<parse_file_metadata> I<(enum, default: yaml)>

This option controls whether the parser accepts optional metadata at the
beginning of the file. The module currently does nothing with the metadata
itself but you can configure a hook to receive the YAML content.

The possible values are:

=over 4

=item B<none>

No file metadata is accepted, any structure in the document must be in Markdown.

=item B<yaml> I<(default)>

The parser accepts a YAML table as the very beginning of the document. This
table must start with a line containing just C<---> and ends with another line
containing C<---> or C<...>. The content between these two markers must be valid
a valid, non-empty YAML sequence and it cannot contain any empty line.

=back

=cut

_make_option(
  parse_file_metadata => 'yaml',
  _enum(qw(none yaml)),
  cmark => 'none',
  github => 'none',
  markdown => 'none',);

=head3 B<use_fenced_code_blocks> I<(boolean, default: true)>

This option controls whether fenced code blocks are recognised in the document
structure.

=cut

_make_option(use_fenced_code_blocks => 1, _boolean, (markdown => 0));

=pod

=head3 B<use_table_blocks> I<(boolean, default: true)>

This options controls whether table blocks can be used.

=cut

_make_option(use_table_blocks => 1, _boolean, (cmark => 0, markdown => 0));

=pod

=head3 B<use_setext_headings> I<(boolean, default: false)>

This options controls whether table blocks can be used.

=cut

_make_option(use_setext_headings => 0, _boolean, (cmark => 1, markdown => 1, github => 1));

=pod

=head3 B<use_directive_blocks> I<(boolean, default: true)>

This options controls whether directive blocks can be used.

=cut

_make_option(use_directive_blocks => 1, _boolean, (cmark => 0, markdown => 0, github => 0));

=pod

=head2 Options controlling the parsing of top-level blocks

=head3 B<fenced_code_blocks_must_be_closed> I<(boolean, default: true)>

By default, a fenced code block with no closing fence will run until the end of
the document. With this setting, the opening fence will be treated as normal
text, rather than the start of a code block, if there is no matching closing
fence.

=cut

_make_option(fenced_code_blocks_must_be_closed => 1, _boolean, (cmark => 0, github => 0));

=pod

=head3 B<multi_lines_setext_headings> I<(enum, default: multi_line)>

The default behavior of setext headings in the CommonMark spec is that they can
have multiple lines of text preceding them (forming the heading itself).

This option allows to change this behavior. And is illustrated with this example
of Markdown:

    Foo
    bar
    ---
    baz

The possible values are:

=over 4

=item B<single_line>

Only the last line of text is kept as part of the heading. The preceding lines
are a paragraph of themselves. The result on the example would be:
paragraph C<Foo>, heading C<bar>, paragraph C<baz>

=item B<break>

If the heading underline can be interpreted as a thematic break, then it is
interpreted as such (normally the heading interpretation takes precedence). The
result on the example would be: paragraph C<Foo bar>, thematic break,
paragraph C<baz>.

If the heading underline cannot be interpreted as a thematic break, then the
heading will use the default B<multi_line> behavior.

=item B<multi_line> I<(default)>

This is the default CommonMark behavior where all the preceding lines are part
of the heading. The result on the example would be:
heading C<Foo bar>, paragraph C<baz>

=item B<ignore>

The heading is ignored, and form just one large paragraph. The result on the
example would be: paragraph C<Foo bar --- baz>.

Note that this actually has an impact on the interpretation of the thematic
breaks too.

=back

=cut

_make_option(
  multi_lines_setext_headings => 'multi_line',
  _enum(qw(single_line break multi_line ignore)));

=pod

=head3 B<lists_can_interrupt_paragraph> I<(enum, default: strict)>

Specify whether and how a list can interrupt a paragraph.

=over 4

=item B<never>

A list can never interrupt a paragraph.

=item B<within_list>

A list can interrupt a paragraph only when we are already inside another list.

=item B<strict> I<(default)>

A list can interrupt a paragraph but only with some non ambiguous list markers.

=item B<always>

A list can always interrupt a paragraph.

=back

=cut

_make_option(
  lists_can_interrupt_paragraph => 'strict',
  _enum(qw(never within_list strict always)), (
    markdown => 'within_list',
  ));

=pod

=head3 B<allow_task_list_markers> I<(enum, default: list)>

Specify whether task list markers (rendered as check boxes) are recognised in
the input. The possible values are as follow:

=over 4

=item B<never>

Task list marker are never recognised

=item B<list> I<(default)>

Task list markers are recognised only as the first element at the beginning of
a list item.

=item B<always>

Task list markers are recognised at the beginning of any paragraphs, inside any
type of block.

=back

=cut

_make_option(
  allow_task_list_markers => 'list',
  _enum(qw(never list always)), (
    markdown => 'never',
    cmark => 'never',
  ));

=pod

=head3 B<table_blocks_can_interrupt_paragraph> I<(boolean, default: false)>

Allow a table top level block to interrupt a paragraph.

=cut

_make_option(
  table_blocks_can_interrupt_paragraph => 0,
  _boolean, (
    github => 1,
  ));

=pod

=head3 B<table_blocks_pipes_requirements> I<(enum, default: strict)>

Defines how strict is the parsing of table top level blocks when the leading or
trailing pipes of a given line are missing.

=over 4

=item B<strict> I<(default)>

Leading and trailing pipes are always required for all the lines of the table.

=item B<loose>

Leading and trailing pipes can be omitted when the table is not interrupting a
paragraph, if it has at least two columns, and if the delimiter row uses
delimiters with more than one character.

=item B<lenient>

Leading and trailing pipes can be omitted when the table has at least two
columns, and if the delimiter row uses delimiters with more than one character.

=item B<lax>

Leading and trailing pipes can always be omitted, except on the header line of
a table, if it has a single column.

=back

=cut

_make_option(
  table_blocks_pipes_requirements => 'strict',
  _enum(qw(strict loose lenient lax)), (
    github => 'loose',
  ));

=pod

=head3 B<yaml_file_metadata_allows_empty_lines> I<(boolean, default: false)>

YAML document at the beginning of a Markdown file can contain empty lines. Note
that with this some reasonable Markdown documents can be interpreted as YAML so
you should set this value to true only if you expect to use YAML metadata with
your files.

=cut

_make_option(yaml_file_metadata_allows_empty_lines => 0, _boolean);

=pod

=head3 B<yaml_parser> I<(enum, default: YAML::Tiny)>

Defines the YAML parser being used for the YAML metadata. Only the default
L<YAML::Tiny> is installed by default with this program so if you use any other
value you should make sure that the corresponding module is installed.

Supported values: L<YAML::Tiny>, L<YAML::PP>, and L<YAML::PP::LibYAML>.

=cut

_make_option(
  yaml_parser => 'YAML::Tiny',
  _enum(qw(YAML::Tiny YAML::PP YAML::PP::LibYAML)));

=pod

=head2 Options controlling the rendering of top-level blocks

=head3 B<code_blocks_info> I<(enum, default: language)>

Fenced code blocks can have info strings on their opening lines (any text after
the C<```> or C<~~~> fence). This option controls what is done with that text.

The possible values are:

=over 4

=item B<ignored>

The info text is ignored.

=item B<language> I<(default)>

=back

=cut

_make_option(code_blocks_info => 'language', _enum(qw(ignored language)));

=pod

=head3 B<code_blocks_convert_tabs_to_spaces> I<(boolean, default: false)>

By default, tabs are preserved inside code blocks. With this option, all tabs (at
the beginning of the lines or inside) are turned into spaces, aligned with the
tab stops (currently always a multiple of 4).

=cut

_make_option(code_blocks_convert_tabs_to_spaces => 0, _boolean, (markdown => 1));

=pod

=head3 B<table_blocks_have_cells_for_missing_data> I<(boolean, default: false)>

Whether a table will have a cell in HTML for a missing cell in the markdown
input.

=cut

_make_option(
  table_blocks_have_cells_for_missing_data => 0,
  _boolean, (
    github => 1,
  ));

=pod

=head3 B<render_naked_paragraphs> I<(boolean, default: false)>

When this is set to true, the C<E<lt>pE<gt>> tag is always skipped around a
paragraph. This is mostly meant to render short amount of text as pure Markdown
inline content, without a surrounding block structure.

=cut

_make_option(render_naked_paragraphs => 0, _boolean);

=pod

=head2 Options controlling which inline elements are used

=head3 B<use_extended_autolinks> I<(boolean, default: true)>

Allow some links to be recognised when they appear in plain text. These links
must start by C<http://>, C<https://>, or C<www.>.

=cut

_make_option(
  use_extended_autolinks => 1,
  _boolean, (
    markdown => 0,
    cmark => 0
  ));

=pod

=head2 Options controlling the parsing of inline elements

=head3 B<autolinks_regex> I<(regex string)>

The regex that an autolink must match. This is for CommonMark autolinks, that
are recognized only if they appear between brackets C<\<I<link>\>>.

The default value is meant to match the
L<spec|https://spec.commonmark.org/0.30/#autolinks>. Basically it requires a
scheme (e.g. C<https:>) followed by mostly anything else except that spaces and
the bracket symbols (C<\<> and C<\>>) must be escaped.

=cut

_make_option(autolinks_regex => '(?i)[a-z][-+.a-z0-9]{1,31}:[^ <>[:cntrl:]]*', _regex);

=pod

=head3 B<autolinks_email_regex> I<(regex string)>

The regex that an autolink must match to be recognised as an email address. This
allows to omit the C<mailto:> scheme that would be needed to be recognised as
an autolink otherwise.

The default value is exactly the regex specified by the
L<spec|https://spec.commonmark.org/0.30/#autolinks>.

=cut

_make_option(
  autolinks_email_regex =>
      q{[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*},
  _regex);

=pod

=head3 B<inline_delimiters> I<(map)>

This option provides a map from delimiter symbols to the matching HTML tags.
This option should be passed as a comma-separated list of C<delimiter=tag_name>
values. For example, the original Markdown syntax map could be specified as
C<*=em,**=strong,_=em,__=strong>. The delimiters can only be made of a single
unicode character or of twice the same unicode character. The values should be
either HTML tag names (for example C<em>, C<strong>, etc.) or they can be
arbitrary HTML class names, prefixed by a single dot (C<.>). In the latter case
the delimiters will be used to insert a C<E<lt>spanE<gt>> element, with the
given class.

When using the programmatic interface, this map can be passed directly as a
hash-reference, with the same content as described above.

=cut

sub _delimiters_map {
  return sub {
    my %m = ref $_[0] eq 'HASH' ? %{$_[0]} : map { split(/=/, $_, 2) } split(/,/, $_[0]);
    # TODO: validate the keys and values of m.
    if (!all { m/^(.)\1?$/ } keys %m) {
      $err_str = sprintf 'keys must be a single character, optionally repeated once';
      return;
    }
    if (!all { m/^\.?[a-z][-_a-z0-9]*$/i } values %m) {
      $err_str = sprintf 'values must be a valid HTML tag or class names';
      return;
    }
    return \%m if %m;
    return {"\N{NULL}" => 'p'}  # this can’t trigger but the code fails with an empty map otherwise.
  };
}

_make_option(
  inline_delimiters => {
    '*' => 'em',
    '**' => 'strong',
    '_' => 'em',
    '__' => 'strong',
    '~' => 's',
    '~~' => 'del',
  },
  _delimiters_map,
  markdown => {
    '*' => 'em',
    '**' => 'strong',
    '_' => 'em',
    '__' => 'strong',
  },
  cmark => {
    '*' => 'em',
    '**' => 'strong',
    '_' => 'em',
    '__' => 'strong',
  },
  github => {
    '*' => 'em',
    '**' => 'strong',
    '_' => 'em',
    '__' => 'strong',
    '~' => 'del',
    '~~' => 'del',
  });

=pod

=head3 B<inline_delimiters_max_run_length> I<(map)>

TODO: document

=cut

sub _delimiters_max_run_length_map {
  return sub {
    my %m = ref $_[0] eq 'HASH' ? %{$_[0]} : map { split(/=/, $_, 2) } split(/,/, $_[0]);
    # TODO: validate the keys and values of m.
    return \%m;
  };
}

_make_option(
  inline_delimiters_max_run_length => {},
  _delimiters_max_run_length_map,
  github => {
    '~' => 2,
  });

=pod

=head3 B<allow_spaces_in_links> I<(enum, default: none)>

This option controls whether spaces are allowed between the link text and the
link destination (between the closing bracket of the text and the opening
parenthesis or bracket of the destination).

=over 4

=item B<none> I<(default)>

No space is allowed between the link text and the link target.

=item B<reference>

This allows at most one space between the two sets of brackets in a
reference link.

=back

=cut

_make_option(
  allow_spaces_in_links => 'none',
  _enum(qw(none reference)),
  (markdown => 'reference'));

=pod

=head3 B<two_spaces_hard_line_breaks> I<(boolean, default: false)>

Controls if a hard line break can be generated by ending a line with two spaces.

=cut

_make_option(
  two_spaces_hard_line_breaks => 0,
  _boolean,
  (markdown => 1, cmark => 1, github => 1));

=pod

=head2 Options controlling the rendering of inline elements

=head3 B<html_escaped_characters> I<(character_class)>

This option specifies the list of characters that will be escaped in the HTML
output. This should be a string containing the characters to escapes. Only the
following characters are supported and can be passed in the string: C<">, C<'>,
C<&>, C<E<lt>>, and C<E<gt>>.

=cut

sub _escaped_characters {
  return sub {
    return $_[0] if $_[0] =~ m/^["'&<>]*$/;
    $err_str = "must only contains the following characters: \", ', &, <, and >";
    return;
  };
}

_make_option(html_escaped_characters => '"&<>', _escaped_characters, markdown => '&<');

=pod

=head3 B<html_escaped_code_characters> I<(character_class)>

This option is similar to the C<html_escaped_characters> but is used in the
context of C<E<lt>codeE<gt>> blocks.

=cut

_make_option(html_escaped_code_characters => '"&<>', _escaped_characters, markdown => '&<>');

=pod

=head3 B<force_final_new_line> I<(boolean, default: false)>

This option forces the processing of the input markdown to behave as if a final
new line was always present. Note that, even without this option, a final new
line will almost always be present in the output (and will always be present
with it).

=cut

_make_option(force_final_new_line => 0, _boolean, (markdown => 1));

=pod

=head3 B<preserve_white_lines> I<(boolean, default: true)>

By default, pmarkdown will try to preserve lines that contains only whitespace
when possible. If this option is set to false, such lines are treated as if they
contained just the new line character.

=cut

_make_option(preserve_white_lines => 1, _boolean, (markdown => 0));

=pod

=head3 B<disallowed_html_tags> I<(world list)>

This option specifies a comma separated list (or, in Perl, an array reference)
of name of HTML tags that will be disallowed in the output. If these tags appear
they will be deactivated in the output.

=cut

_make_option(
  disallowed_html_tags => [],
  _word_list,
  github => [qw(title textarea style xmp iframe noembed noframes script plaintext)]);

=pod

=head3 B<default_extended_autolinks_scheme> I<(enum, default: https)>

Specify which scheme is added to the beginning of extended autolinks when none
was present initially.

=cut

_make_option(
  default_extended_autolinks_scheme => 'https',
  _enum(qw(http https)),
  github => 'http');

=pod

=head2 Other options

=head3 B<warn_for_unused_input> I<(boolean, default: true)>

In general, all user input is present in the output (possibly as uninterpreted
text if it was not understood). But some valid Markdown construct results in
parts of the input being ignored. By default C<pmarkdown> will emit a warning
when such a construct is found. This option can disable these warnings.

=cut

_make_option(
  warn_for_unused_input => 1,
  _boolean);

=pod

=head1 SEE ALSO

L<Markdown::Perl>, L<pmarkdown>

=cut

1;
