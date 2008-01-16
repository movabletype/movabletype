package Text::WikiFormat;

use strict;

use Carp;
use URI;
use URI::Escape;

use vars qw( $VERSION %tags $indent );
$VERSION = 0.71;

$indent = qr/^(?:\t+|\s{4,})/;
%tags = (
	indent		=> qr/^(?:\t+|\s{4,})/,
	newline		=> '<br />',
	link		=> \&make_html_link,
	strong		=> sub { "<strong>$_[0]</strong>" },
	emphasized	=> sub { "<em>$_[0]</em>" },
	strong_tag  => qr/'''(.+?)'''/,
	emphasized_tag => qr/''(.+?)''/,

	code		=> [ '<pre><code>', "</code></pre>\n", '', "\n" ],
	line		=> [ '', "\n", '<hr />',  "\n" ],
	paragraph	=> [ '<p>', "</p>\n", '', "<br />\n", 1 ],
	unordered	=> [ "<ul>\n", "</ul>\n", '<li>', "</li>\n" ],
	ordered		=> [ "<ol>\n", "</ol>\n", 
		sub { qq|<li value="$_[2]">|, $_[0], "</li>\n" } ],
	header      => [ '', "\n", sub {
		my $level = length $_[2];
		return "<h$level>", format_line($_[3], @_[-2, -1]), "</h$level>\n" }
	],

	blocks		=> {
		ordered		=> qr/^([\dA-Za-z]+)\.\s*/,
		unordered	=> qr/^\*\s*/,
		code		=> qr/  /,
		header      => qr/^(=+) (.+) \1/,
		paragraph   => qr/^/,
		line        => qr/^-{4,}/,
	},

	indented    => { map { $_ => 1 } qw( ordered unordered code )},
	nests       => { map { $_ => 1 } qw( ordered unordered ) },

	blockorder               =>
		[qw( header line ordered unordered code paragraph )],
	extended_link_delimiters => [qw( [ ] )],
);

sub process_args
{
	my $self = shift;
	my $name = @_ == 1 ? shift : 'wikiformat';
	return ( as => $name, @_ );
}

sub default_opts
{
	my ($class, $args) = @_;

	my %defopts = ( implicit_links => 1, map { $_ => delete $args->{ $_ } }
		qw( prefix extended implicit_links) );

	return %defopts;
}

sub merge_hash
{
	my ($from, $to) = @_;
	while (my ($key, $value) = each %$from)
	{
		if (UNIVERSAL::isa( $value, 'HASH' ))
		{
			$to->{$key} = {} unless defined $to->{$key};
			merge_hash( $value, $to->{$key} );
		}
		else
		{
			$to->{$key} = $value;
		}
	}
}

sub import
{
	my $class = shift;
	return unless @_;

	my %args    = $class->process_args( @_ );
	my %defopts = $class->default_opts( \%args );

	my $caller = caller();
	my $name   = delete $args{as};

	no strict 'refs';
	*{ $caller . "::$name" } = sub {
		my ($text, $tags, $opts) = @_;

		$tags ||= {};
		$opts ||= {};

		my %tags = %args;
		merge_hash( $tags, \%tags );
		my %opts = %defopts;
		merge_hash( $opts, \%opts );

		Text::WikiFormat::format( $text, \%tags, \%opts);
	}
}

sub format
{
	my ($text, $newtags, $opts) = @_;
	$opts    ||= { prefix => '', extended => 0, implicit_links => 1 };
	my %tags   = %tags;

	merge_hash( $newtags, \%tags )
		if defined $newtags and UNIVERSAL::isa( $newtags, 'HASH' );
	check_blocks( \%tags )
		if exists $newtags->{blockorder} or exists $newtags->{blocks};

	my @blocks =  find_blocks( $text,     \%tags, $opts );
	@blocks    = merge_blocks( \@blocks,  \%tags, $opts );
	@blocks    =  nest_blocks( \@blocks,  \%tags, $opts );
	return     process_blocks( \@blocks,  \%tags, $opts );
}

sub check_blocks
{
	my $tags   = shift;
	my %blocks = %{ $tags->{blocks} };
	delete @blocks{ @{ $tags->{blockorder} } };
	Carp::carp(
		"No order specified for blocks '" . join(', ', keys %blocks ) . "'\n")
		if keys %blocks;
}

sub find_blocks
{
	my ($text, $tags, $opts) = @_;

	my @blocks;
	for my $line ( split(/\n/, $text) )
	{
		my $block = start_block( $line, $tags, $opts );
		push @blocks, $block if $block;
	}

	return @blocks;
}

sub start_block
{
	my ($text, $tags, $opts) = @_;
	return { type => 'end', level => 0 } unless $text;

	for my $block (@{ $tags->{blockorder} })
	{
		my ($line, $level) = ( $text, 0 );
		if ($tags->{indented}{$block})
		{
			($level, $line) = get_indentation( $tags, $line );
			next unless $level;
		}

		next unless $line =~ /$tags->{blocks}{$block}/;
		$level = 0 if $block eq 'code';
		
		$line =~ s/$tags->{blocks}{$block}//;
		return {
			args => [ grep { defined } $1, $2, $3, $4, $5, $6, $7, $8, $9 ],
			type => $block,
			text => $block eq 'code' ? $line : format_line($line, $tags, $opts),
			level=> $level || 0,
		};
	}
}

sub merge_blocks
{
	my ($blocks, $tags, $opts) = @_;

	my @merged;
	for my $block (@$blocks)
	{
		if (@merged and $block->{type} eq $merged[-1]{type}
			and $block->{level} == $merged[-1]{level})
		{
			push @{ $merged[-1]{text} }, $block->{text};
			push @{ $merged[-1]{args} }, $block->{args};
			next;
		}

		push @merged, {
			text  => [ $block->{text} ],
			type  => $block->{type},
			level => $block->{level},
			args  => [ $block->{args} ],
		};
	}

	return @merged;
}

sub nest_blocks
{
	my ($blocks, $tags, $opts) = @_;
	my @merged;

	for my $block (@$blocks)
	{
		if (@merged and $tags->{nests}{ $block->{type} }
			and $tags->{nests}{ $merged[-1]{type} }
			and $block->{level} > $merged[-1]{level})
		{
			push @{ $merged[-1]{text} }, $block;
			next;
		}
		push @merged, $block;
	}

	return @merged;
}

sub process_blocks
{
	my ($blocks, $tags, $opts) = @_;

	my @open;
	for my $block (@$blocks)
	{
		push @open, process_block( $block, $tags, $opts )
			unless $block->{type} eq 'end';
	}

	return join('', @open);
}

sub process_block
{
	my ($block, $tags, $opts) = @_;

	my ($start, $end, $start_line, $end_line, $between)
		= @{ $tags->{ $block->{type} } };

	my @text;

	for my $line (@{ $block->{text} })
	{
		if (UNIVERSAL::isa( $line, 'HASH' ))
		{
			my $prev_end = pop @text || ();
			push @text, process_block( $line, $tags, $opts ), $prev_end;
			next;
		}

		if (UNIVERSAL::isa( $start_line, 'CODE' ))
		{
			(my $start_line, $line, $end_line) = 
				$start_line->( $line, $block->{level}, 
				@{ shift @{ $block->{args} } }, $tags, $opts);
			push @text, $start_line, $line, $end_line;
		}
		else
		{
			push @text, $start_line, $line, $end_line;
		}
	}

	pop @text if $between;
	return join('', $start, @text, $end);
}

sub get_block
{
	my ($line, $tags, $opts) = @_;

	return 'header', $line if $line =~ /$tags->{blocks}{header}/;

	if ((my $level, $line) = get_indentation( $tags, $line ))
	{
		return 'list', $line, $level;
	}

	return 'paragraph', $line;
}

sub get_indentation
{
	my ($tags, $text) = @_;

	return 0, $text unless $text =~ s/($tags->{indent})//;
	return length( $1 ) + 1, $text;
}

sub end_all_lists
{
	my ($lists, $tags) = @_;
	my $parsed = '';

	while (@$lists and $lists->[0]{level} == 0)
	{
		my $list = shift @$lists;
		$parsed .= end_list( $list, $tags->{ $list->{list} } );
	}

	while ( my $list = pop @$lists )
	{
		$parsed .= end_list( $list, $tags->{ $list->{list} } );
	}

	return $parsed;
}

sub find_list
{
	my ( $line, $list_types, $tags, $opts ) = @_;

	for my $list (@$list_types) {
		my $regex = $tags->{lists}{$list};

		next unless $line =~ s/^$regex//;
		
		my @captures = map { defined $_ ? $_ : () }
			$1, $2, $3, $4, $5, $6, $7, $8, $9;

		$line = format_line($line, $tags, $opts) unless $list eq 'code';

		return unless my $action = $tags->{$list};
		my @formatted;

		if (@$action == 3)
		{
			my $subref = $action->[2];
			if (defined $subref and defined &$subref)
			{
				@formatted = $subref->($line, @captures);
			}
			else
			{
				warn "Bad actions for list type '$list'\n";
			}
		}
		else
		{
			@formatted = ( $action->[2], $line, $action->[3] );
		}
		return $list, @formatted;
	}
}

sub end_list
{
	my ($list, $tags) = @_;
	return join('', grep { defined } @{ $list->{lines} }, $tags->[1]);
}

sub format_line
{
	my ($text, $tags, $opts) = @_;
	$opts ||= {};

	$text =~ s!$tags->{strong_tag}!$tags->{strong}->($1, $opts)!eg;
	$text =~ s!$tags->{emphasized_tag}!$tags->{emphasized}->($1, $opts)!eg;

	$text = find_extended_links( $text, $tags, $opts ) if $opts->{extended};

	$text =~ s|(?<!["/>=])\b([A-Za-z]+(?:[A-Z]\w+)+)|
			  $tags->{link}->($1, $opts)|egx
			if !defined $opts->{implicit_links} or $opts->{implicit_links};

	return $text;
}

sub find_extended_links
{
	my ($text, $tags, $opts) = @_;

	my ($start, $end) = @{ $tags->{extended_link_delimiters} };

	my $position = 0;
	while (1)
	{
		my $open       = index $text, $start, $position;
		last if $open  == -1;
		my $close      = index $text, $end, $open;
		last if $close == -1;

		my $text_start = $open + length $start;
		my $extended   = substr $text, $text_start, $close - $text_start;

		$extended  = $tags->{link}->( $extended, $opts );
		substr $text, $open, $close - $open + length $end, $extended;
		$position += length $extended;
	};

	return $text;
}

sub make_html_link
{
	my ($link, $opts) = @_;
	$opts ||= {};
	($link, my $title) = find_link_title( $link, $opts );

	$link = escape_link( $link, $opts );

	my $prefix = defined $opts->{prefix} ? $opts->{prefix} : '';
	return qq|<a href="$prefix$link">$title</a>|;
}

sub escape_link
{
	my ($link, $opts) = @_;
	return uri_escape( $link ) unless $opts->{absolute_links};
		
	my $u = URI->new( $link );
	return $link if $u->scheme();

	return uri_escape( $link );
}

sub find_link_title
{
	my ($link, $opts)    = @_;
	my $title;
	($link, $title)      = split(/\|/, $link, 2) if $opts->{extended};
	$title             ||= $link;

	return $link, $title;
}

'shamelessly adapted from the Jellybean project';

__END__

=head1 NAME

Text::WikiFormat - module for translating Wiki formatted text into other formats

=head1 SYNOPSIS

	use Text::WikiFormat;
	my $html = Text::WikiFormat::format($raw);

=head1 DESCRIPTION

The original Wiki web site was intended to have a very simple interface to
edit and to add pages.  Its formatting rules are simple and easy to use.  They
are also easily translated into other, more complicated markup languages with
this module.  It creates HTML by default, but can be extended to produce valid
POD, DocBook, XML, or any other format imaginable.

The most important function is C<format()>.  It is not exported by default.

=head2 format()

C<format()> takes one required argument, the text to convert, and returns the
converted text.  It allows two optional arguments.  The first is a reference to
a hash of tags.  Anything passed in here will override the default tag
behavior.  These tags are described later.  The second argument is a hash
reference of options.  There are currently limited to:

=over 4

=item * prefix

The prefix of any links.  In HTML mode, this is the path to the Wiki.  The
actual linked item itself will be appended to the prefix.  This is used to
create full URIs:

	{ prefix => 'http://example.com/wiki.pl?page=' }

=item * extended

A boolean flag, false by default, to use extended linking semantics.  This is
stolen from the Everything Engine (L<http://everydevel.com/>), where links are
marked by square brackets.  An optional title may occur after the link target,
preceded by an open pipe.  That is to say, these are valid extended
links:

	[a valid link]
	[link|title]

Where the linking semantics of the destination format allow it, the title will
be displayed instead of the URI.  In HTML terms, the title is the content of an
A element (not the content of its HREF attribute).

You can use delimiters other than single square brackets for marking extended
links, by passing a value for C<extended_link_delimiters> in the C<%tags> hash
when calling C<format> (see below for details).

=item * implicit_links

A boolean flag, true by default, to cause links to be created wherever a
StudlyCapsString is seen.  Note that if you disable this flag, you'll most
likely be wanting to enable the C<extended> one also, or there will be no way
of creating links in your documents.  To disable it, use the pair:

	{ implicit_links => 0 }

=item * absolute_links

A boolean flag, false by default, which treats any links that are absolute URIs
(such as http://www.cpan.org/) to be treated specially. Any prefix will not
apply and the URIs aren't quoted. Must be used in conjunction with the
C<extended> option for the link to be detected.

=head2 Wiki Format

Wiki formatting is very simple.  An item wrapped in three single quotes is
marked as B<strong>.  An item wrapped in two single quotes is marked as
I<emphasized>.  Any word with multiple CapitalLetters (e. g., StudlyCaps) will
be turned into a link.  Four or more hyphen characters at the start of a line
create a horizontal line.  Newlines are translated into the appropriate tag.
Headers are marked with matching equals signs around the header text -- the
more signs, the lesser the header.

Lists are indented by one tab or four spaces, by default.  Indentation may be
disabled.  Lists can be unordered, where each item has its own bullet point.
These are marked by a leading asterisk and space.  They can also be ordered,
where any combination of one or more alphanumeric characters can be followed by
a period and an optional space.  Any indented text without either marking is
considered to be code, and is handled literally.  Lists can be nested.

The following is valid Wiki formatting, with an extended link as marked.

	= my interesting text =

	ANormalLink
	[let the Sun shine|AnExtendedLink]

	== my interesting lists ==

	    * unordered one
	    * unordered two

	    1. ordered one
	    2. ordered two
			a. nested one
			b. nested two

	    code one
	    code two

	The first line of a normal paragraph.
	The second line of a normal paragraph.  Whee.

=head1 EXPORT

If you'd like to make your life more convenient, you can optionally import a
subroutine that already has default tags and options set up.  This is
especially handy if you will be using a prefix:

	use Text::WikiFormat prefix => 'http://www.example.com/';
	wikiformat( 'some text' );

tags are interpreted as, well, tags, except for four special keys:

=over 4

=item * C<prefix>, interpreted as a link prefix

=item * C<extended>, interpreted as the extended link flag

=item * C<implicit_links>, interpreted as the flag to control implicit links

=item * C<as>, interpreted as an alias for the imported function

=back

Use the C<as> flag to control the name by which the imported function is
called.  For example,

	use Text::WikiFormat as => 'formatTextInWikiStyle';
	formatTextInWikiStyle( 'some text' );

You might choose a better name, though.

The calling semantics are effectively the same as those of the format()
function.  Any additional tags or options to the imported function will
override the defaults.  In this example:

	use Text::WikiFormat as => 'wf', extended => 0;
	wf( 'some text', {}, { extended => 1 });

extended links will be enabled, though the default is to disable them.

This feature was suggested by Tony Bowden E<lt>tony@kasei.comE<gt>, but all
implementation blame rests solely with me.  Kate L Pugh
(E<lt>kake@earth.liE<gt>) pointed out that it didn't work, with tests, so it's
fixed now.

=head1 GORY DETAILS

=head2 Tags

There are two types of Wiki markup: line items and blocks.  Blocks include
lists, which are made up of lines and can also contain other lists.

=head3 Line items

There are two classes of line items: simple tags, and tags that contain data.
The simple tags are C<newline> and C<line>.  A newline is inserted whenever a
newline character (C<\n>) is encountered.  A line is inserted whenever four or
more dash characters (C<---->) occur at the start of a line.  No whitespace is
allowed.  These default to the E<lt>brE<gt> and E<lt>hrE<gt> HTML tags,
respectively.  To override either, simply pass tags such as:

	my $html = format($text, { newline => "\n" });

The three line items are more complex, and require subroutine references. This
category includes the C<strong> and C<emphasized> tags as well as C<link>s.
The first argument passed to the subref will be the data found in between the
marks.  The second argument is the $opts hash reference.  The default action
for a strong tag can be reimplemented with this syntax:

	my $html = format($text, { strong => sub { "<b>$_[0]</b>" } });

As of version 0.70, you can change the regular expressions used to find strong
and emphasized tags:

	%tags = (
		strong_tag     => qr/\*(.+?)\*/,
		emphasized_tag => qr|(?<!<)/(.+?)/|,
	);

	$wikitext = 'this is *strong*, /emphasized/, and */emphasized strong/*';
	$htmltext = Text::WikiFormat::format( $wikitext, \%tags, {} );

Be aware that using forward slashes to mark anything leads to the hairy regular
expression -- use something else.  B<This interface is experimental> and may
change if I find something better.  It's nice to be able to override those
tags, though.

Finally, there are C<extended_link_delimiters>, which allow you to use
delimiters other than single square brackets for marking extended links.  Pass
the tags as:

	my $html = format( $text, { extended_link_delimiters => [ '[[', ']]' ] });

This will allow you to use double square brackets as UseMod supports:

	[[an extended link]]
	[[a titled extended link|title]]

=head3 Blocks

Five block types are recognized by default:  C<paragraph>, C<header>, C<code>,
C<unordered>, and C<ordered>.  Each of these is I<usually> marked by
indentation, either one or more tabs or four or more whitespace characters.
(This does not include newlines, however.)  Any line that does not fall in any
of these three categories is automatically put in a C<paragraph> list.

Lists (code, unordered, and ordered blocks) are usually marked by indentation.
This is not required, however, it's used to mark nesting.  Be careful.  To mark
a block as requiring indentation, use the C<indented> tag, which contains a
reference to a hash:

	my $html = format($text, { 
		indented    => { map { $_ => 1 } qw( ordered unordered code )}
	});

Block entries in the tag hashes must contain array references.  The first two
items are the tags used at the start and end of the block.  As you'd expect,
the last items contain the tags used at the start and end of each line.  Where
there needs to be more processing of individual lines, use a subref as the
third item.  This is how ordered lines are numbered in HTML lists:

	my $html = format($text, { ordered => [ '<ol>', "</ol>\n",
		sub { qq|<li value="$_[2]">$_[0]</li>\n| } ] });

The first argument to these subrefs is the text of the line itself, after it
has been processed.  (The indentation and tokens used to mark this as a list
item are removed, and the rest of the line is checked for other line
formattings.)  The second argument is the indentation level.  The subsequent
arguments are captured variables in the regular expression used to find this
list type.  The regexp for ordered lists is:

	qr/^([\dA-Za-z]+)\.\s*/;

Indentation is processed first, if applicable, and the indentation level (the
length of the indentation removed) is stored.  The line must contain one or
more alphanumeric character followed by a single period and optional whitespace
to be identified as an ordered list item.  The contents of this last group, the
value of the list item, is saved, and will be passed to the subref as the third
argument.

Lists are automatically started and ended as necessary.

Because of the indentation issue, blocks must be processed in a specific order.
The C<blockorder> tag governs this order.  It contains a reference to an array
of the names of the appropriate blocks to process.  If you add a block type, be
sure to add an entry for it in C<blockorder>:

	my $html = format($text, {
		escaped       => [ '', '', '', '' ],
		blocks        => {
			invisible => qr!^--(.*?)--$!,
		},
		blockorder    =>
			[qw( header line ordered unordered code paragraph invisible )],
	});

=head3 Finding blocks

Text::WikiFormat uses regular expressions to find blocks.  These are kept in
the %tags hash, under the C<blocks> key.  To change the regular expression to
find code block items, use:

	my $html     =  format($wikitext, {
		blocks   => { 
			code => qr/^:\s+/,
		},
		indented => {
			code => 1,
		},
	);

This will require indentation and a colon to mark code lines.  A potential
shortcut is to use the C<indent> tag to match or to change the indentation
marker.  

B<Note>: if you want to mark a block type as non-indented, you B<cannot> use an
empty regex such as C<qr//>.  Use a mostly-empty, always-true regex such as
C<qr/^/> instead.

=head3 Finding Blocks in the Correct Order

As intrepid bug reporter Tom Hukins pointed out in CPAN RT bug #671, the order
in which Text::WikiFormat searches for blocks varies by platform and version of
Perl.  Because some block-finding regular expressions are more specific than
others, what's intended to be one type of block may be caught by a different
list type.

If you're adding new block types, be aware of this.  The C<blockorder> entry in
C<%tags> exists to force Text::WikiFormat to apply its regexes from most
specific to least specific.  It contains an array reference.  By default, it
looks for ordered lists first, unordered lists second, and code references at
the end.

=back

=head1 AUTHOR

chromatic, C<chromatic@wgz.org>, with much input from the Jellybean team
(including Jonathan Paulett).  Kate L Pugh has also provided several patches,
many failing tests, and is usually the driving force behind new features and
releases.  If you think this module is worth buying me a beer, she deserves at
least half of it.  

Tony Bowden, Tom Hukins, and Andy H. all suggested useful features that are now
implemented.  

Sam Vilain found a silly bug.

Blame me for the implementation.

=head1 BUGS

The link checker in C<format_line()> may fail to detect existing links that do
not follow HTML, XML, or SGML style.  They may die with some SGML styles too.
I<Sic transit gloria mundi>.

=head1 TODO

=over 4

=item * Find a nicer way to mark list as having unformatted lines

=item * Optimize C<format_line()> to work on a list of lines

=item * Handle nested C<strong> and C<emphasized> markings better

=back

=head1 OTHER MODULES

Brian "Ingy" Ingerson's CGI::Kwiki has a fairly nice parser.

John McNamara's Pod::Simple::Wiki looks like a good project.

Matt Sergeant keeps threatening to write a nice SAX-throwing Wiki formatter.

=head1 COPYRIGHT

Copyright (c) 2002 - 2003, chromatic.  All rights reserved.  This module is
distributed under the same terms as Perl itself.
