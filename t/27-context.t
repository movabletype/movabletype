#!/usr/bin/perl
# $Id$
use strict;
use warnings;

use lib 't/lib';
use lib 'lib';
use lib 'extlib';

use Test::More tests => 55;
use File::Temp qw( tempfile );

use MT;
use MT::Author;
use MT::Blog;
use MT::Comment;
use MT::Entry;
use MT::Template;
use MT::Template::Context;
use MT::Util qw( first_n_words html_text_transform );

use vars qw( $DB_DIR $T_CFG $BASE );

use MT::Test qw(:db :data);

my $mt = MT->new( Config => $T_CFG ) or die MT->errstr;
isa_ok($mt, 'MT');

sub build {
#    my($ctx, $markup) = @_;
#    my $b = MT::Builder->new;
#    my $tokens = $b->compile($ctx, $markup) or die $b->errstr;
#    $b->build($ctx, $tokens);

    my($ctx, $markup) = @_;
    my $b = $ctx->stash('builder');
    my $tokens = $b->compile($ctx, $markup);
    print('# -- error compiling: ' . $b->errstr), return undef
        unless defined $tokens;
    my $res = $b->build($ctx, $tokens);
    print '# -- error building: ' . ($b->errstr ? $b->errstr : '') . "\n"
        unless defined $res;
    return $res;
}

## Need to test:
##     create a couple of entries
##     MTEntries:
##         test all arguments (days, lastn, category)
##         test DateHeader section
##         test conditionals for extended entries and allow comments
##         test that we can do stash->('entries', \@entries) to set entrylist
##         test sort_order_posts works
##         test that only status=LIVE posts get published
##         test Category tag
##         test all MTEntry* tags
##     MTComments;
##         test sort_order_comments works
##         test all MTComment* tags
##     MTArchiveList:
##         test all archive types
##         test MTEntries inside
##         test MTArchiveTitle correctness for all archive types
##         test all MTArchive* tags
##     test each of the tags, both for failure (out of context) and success

my $blog = MT::Blog->load(1);
isa_ok($blog, 'MT::Blog');

my $author = MT::Author->load({ name => 'Chuck D' });
isa_ok($author, 'MT::Author');

ok($author && $author->is_valid_password('bass'), 'valid');
ok($author && !$author->is_valid_password('wrong'), 'invalid');

my $ctx = MT::Template::Context->new;
isa_ok($ctx, 'MT::Template::Context');
$ctx->stash('blog', $blog);
$ctx->stash('blog_id', $blog->id);
$ctx->stash('builder', MT::Builder->new);
isa_ok($ctx, 'MT::Template::Context');


## Test MTBlog* tags
is(build($ctx, '<$MTBlogName$>'), $blog->name, 'MTBlogName');
is(build($ctx, '<$MTBlogURL$>'), $blog->site_url, 'MTBlogURL');
is(build($ctx, '<$MTBlogDescription$>'), $blog->description, 'MTBlogDescription');
is(build($ctx, '<a href="<$MTBlogURL$>"><$MTBlogName$></a>'),
   qq(<a href="@{[ $blog->site_url ]}">@{[ $blog->name ]}</a>), 'href');

my $entry = MT::Entry->load(1);
$entry->text_more("Something\nelse");
my @cmts = MT::Comment->load({entry_id => $entry->id});
for (@cmts) { $_->remove() }
 $ctx->stash('entry', $entry);
my $ts = local $ctx->{current_timestamp} = $entry->created_on;
my @ts = unpack 'A4A2A2A2A2A2', $ts;
$ts = sprintf "%04d.%02d.%02d %02d:%02d:%02d", @ts;

is(build($ctx, '<$MTEntryTitle$>'), $entry->title, 'MTEntryTitle');
is(build($ctx, '<$MTEntryAuthor$>'), $entry->author->name, 'MTEntryAuthor');
is(build($ctx, '<$MTEntryMore$>'), html_text_transform($entry->text_more), 'MTEntryMore');
is(build($ctx, '<$MTEntryCommentCount$>'), 0, 'MTEntryCommentCount');
is(build($ctx, '<$MTEntryDate format="%Y.%m.%d %H:%M:%S"$>'), $ts, 'MTEntryDate format');

is(build($ctx, '<$MTEntryBody words="2"$>'), first_n_words($entry->text, 2), 'MTEntryBody words 2');

## Test convert_breaks variations with <$MTEntryBody$>.
is(build($ctx, '<$MTEntryBody$>'), html_text_transform($entry->text), 'MTEntryBody');
is(build($ctx, '<$MTEntryBody convert_breaks="0"$>'), $entry->text, 'convert_breaks 0');
is(build($ctx, '<$MTEntryBody convert_breaks="1"$>'), html_text_transform($entry->text), 'convert_breaks 1');
$entry->convert_breaks(0);
is(build($ctx, '<$MTEntryBody$>'), $entry->text, 'MTEntryBody');
is(build($ctx, '<$MTEntryBody convert_breaks="0"$>'), $entry->text, 'convert_breaks 0');
is(build($ctx, '<$MTEntryBody convert_breaks="1"$>'), html_text_transform($entry->text), 'convert_breaks 1');
$entry->column_values->{convert_breaks} = undef;
is(build($ctx, '<$MTEntryBody$>'), html_text_transform($entry->text), 'MTEntryBody');
is(build($ctx, '<$MTEntryBody convert_breaks="0"$>'), $entry->text, 'convert_breaks 0');
is(build($ctx, '<$MTEntryBody convert_breaks="1"$>'), html_text_transform($entry->text), 'convert_breaks 1');
$blog->convert_paras(0);
is(build($ctx, '<$MTEntryBody$>'), $entry->text, 'MTEntryBody');
is(build($ctx, '<$MTEntryBody convert_breaks="0"$>'), $entry->text, 'convert_breaks 0');
is(build($ctx, '<$MTEntryBody convert_breaks="1"$>'), html_text_transform($entry->text), 'convert_breaks 1');
$entry->convert_breaks(1);
$blog->convert_paras(1);

## Test convert_breaks variations with <$MTEntryMore$>.
is(build($ctx, '<$MTEntryMore$>'), html_text_transform($entry->text_more), 'MTEntryMore');
is(build($ctx, '<$MTEntryMore convert_breaks="0"$>'), $entry->text_more, 'convert_breaks 0');
is(build($ctx, '<$MTEntryMore convert_breaks="1"$>'), html_text_transform($entry->text_more), 'convert_breaks 1');
$entry->convert_breaks(0);
is(build($ctx, '<$MTEntryMore$>'), $entry->text_more, 'MTEntryMore');
is(build($ctx, '<$MTEntryMore convert_breaks="0"$>'), $entry->text_more, 'convert_breaks 0');
is(build($ctx, '<$MTEntryMore convert_breaks="1"$>'), html_text_transform($entry->text_more), 'convert_breaks 1');
$entry->column_values->{convert_breaks} = undef;
is(build($ctx, '<$MTEntryMore$>'), html_text_transform($entry->text_more), 'MTEntryMore');
is(build($ctx, '<$MTEntryMore convert_breaks="0"$>'), $entry->text_more, 'convert_breaks 0');
is(build($ctx, '<$MTEntryMore convert_breaks="1"$>'), html_text_transform($entry->text_more), 'convert_breaks 1');
$blog->convert_paras(0);
is(build($ctx, '<$MTEntryMore$>'), $entry->text_more, 'MTEntryMore');
is(build($ctx, '<$MTEntryMore convert_breaks="0"$>'), $entry->text_more, 'convert_breaks 0');
is(build($ctx, '<$MTEntryMore convert_breaks="1"$>'), html_text_transform($entry->text_more), 'convert_breaks 1');
$entry->convert_breaks(1);
$blog->convert_paras(1);

## This should run remove_html first (stripping "<html">), then
## run encode_xml. Previous to 2.61 encode_xml was run first, wrapping
## the excerpt in CDATA, which was then screwed up by remove_html.
$entry->excerpt('Contains <html>');
is(build($ctx, '<$MTEntryExcerpt remove_html="1" encode_xml="1"$>'), 'Contains ', 'remove_html 1 encode_xml 1');
$entry->excerpt('Fight the powers that be');

## Test with set excerpt.
is(build($ctx, '<$MTEntryExcerpt$>'), $entry->excerpt, 'MTEntryExcerpt');
is(build($ctx, '<$MTEntryExcerpt convert_breaks="1"$>'), html_text_transform($entry->excerpt), 'convert_breaks 1');
is(build($ctx, '<$MTEntryExcerpt no_generate="1"$>'), $entry->excerpt, 'no_generate 1');

## Test with auto-generating excerpt.
$entry->excerpt('');
is(build($ctx, '<$MTEntryExcerpt$>'), first_n_words($entry->text, 40) . '...', 'MTEntryExcerpt');
is(build($ctx, '<$MTEntryExcerpt convert_breaks="1"$>'), first_n_words($entry->text, 40) . '...', 'convert_breaks 1');
is(build($ctx, '<$MTEntryExcerpt no_generate="1"$>'), '', 'no_generate 1');

## Make sure text formatting is applied before excerpt is generated,
## unless convert_breaks="0" is explicitly set.
## Change to use Markdown
$entry->convert_breaks('markdown');
$entry->text(q(This text is **strong**));
is(build($ctx, '<$MTEntryExcerpt$>'), q(This text is strong...), 'MTEntryExcerpt');
is(build($ctx, '<$MTEntryExcerpt convert_breaks="1"$>'), q(This text is strong...), 'convert_breaks 1');
is(build($ctx, '<$MTEntryExcerpt convert_breaks="0"$>'), q(This text is **strong**...), 'convert_breaks 0');

$entry->convert_breaks('__default__');
$entry->text('Elvis was a hero to most but he never meant shit to me');

is(build($ctx, '<$MTEntryBody encode_xml="1"$>'), "<![CDATA[<p>Elvis was a hero to most but he never meant shit to me</p>]]>", 'MTEntryBody');

my $comment = MT::Comment->new;
isa_ok($comment, 'MT::Comment');
$comment->entry_id($entry->id);
$comment->blog_id($entry->blog_id);
$comment->author('JL');
$comment->text('This is not a comment');
$comment->visible(1);
$comment->save or die $comment->errstr;

# Clear caching of things like the comment count of an entry
$entry = MT::Entry->load($entry->id);
$ctx->stash('entry', $entry);

is(build($ctx, '<MTComments><$MTCommentBody encode_xml="1"$></MTComments>'),
   "<![CDATA[<p>This is not a comment</p>]]>", 'This is not a comment');
is(build($ctx, '<$MTEntryCommentCount$>'), 1, 'MTEntryCommentCount');
