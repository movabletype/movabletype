# $Id$

BEGIN { unshift @INC, 't/' }

use Test;
use MT::Blog;
use MT::Author;
use MT::Template;
use MT::Entry;
use MT::Comment;
use MT::Template::Context;
use MT::Util qw( first_n_words html_text_transform );
use MT;
use File::Temp qw( tempfile );
use strict;

BEGIN { plan tests => 52 };

use vars qw( $DB_DIR $T_CFG $BASE );
require 'test-common.pl';
system("rm -r t/db/*"); # needed because some earlier test craps up the db
require 'blog-common.pl';

my $mt = MT->new( Config => $T_CFG ) or die MT->errstr;
MT->add_text_filter(wiki => {
    label => 'Wiki',
    on_format => sub {
        require Text::WikiFormat;
        Text::WikiFormat::format($_[0]);
    },
});

sub build {
    my($ctx, $markup) = @_;
    my $b = MT::Builder->new;
    my $tokens = $b->compile($ctx, $markup) or die $b->errstr;
    $b->build($ctx, $tokens);
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
ok($blog);

my $author = MT::Author->load({ name => 'Chuck D' });
ok($author);

ok($author && $author->is_valid_password('bass'));
ok($author && !$author->is_valid_password('wrong'));

my $ctx = MT::Template::Context->new;
$ctx->stash('blog', $blog);
$ctx->stash('blog_id', $blog->id);
ok($ctx);

## Test MTBlog* tags
ok(build($ctx, '<$MTBlogName$>'), $blog->name);
ok(build($ctx, '<$MTBlogURL$>'), $blog->site_url);
ok(build($ctx, '<$MTBlogDescription$>'), $blog->description);
ok(build($ctx, '<a href="<$MTBlogURL$>"><$MTBlogName$></a>'),
   qq(<a href="@{[ $blog->site_url ]}">@{[ $blog->name ]}</a>));

my $entry = MT::Entry->load(1);
$entry->text_more("Something\nelse");
my @cmts = MT::Comment->load({entry_id => $entry->id});
for (@cmts) { $_->remove() }
 $ctx->stash('entry', $entry);
my $ts = local $ctx->{current_timestamp} = $entry->created_on;
my @ts = unpack 'A4A2A2A2A2A2', $ts;
$ts = sprintf "%04d.%02d.%02d %02d:%02d:%02d", @ts;

ok(build($ctx, '<$MTEntryTitle$>'), $entry->title);
ok(build($ctx, '<$MTEntryAuthor$>'), $entry->author->name);
ok(build($ctx, '<$MTEntryMore$>'), html_text_transform($entry->text_more));
ok(build($ctx, '<$MTEntryCommentCount$>'), 0);
ok(build($ctx, '<$MTEntryDate format="%Y.%m.%d %H:%M:%S"$>'), $ts);

ok(build($ctx, '<$MTEntryBody words="2"$>'), first_n_words($entry->text, 2));

## Test convert_breaks variations with <$MTEntryBody$>.
ok(build($ctx, '<$MTEntryBody$>'), html_text_transform($entry->text));
ok(build($ctx, '<$MTEntryBody convert_breaks="0"$>'), $entry->text);
ok(build($ctx, '<$MTEntryBody convert_breaks="1"$>'), html_text_transform($entry->text));
$entry->convert_breaks(0);
ok(build($ctx, '<$MTEntryBody$>'), $entry->text);
ok(build($ctx, '<$MTEntryBody convert_breaks="0"$>'), $entry->text);
ok(build($ctx, '<$MTEntryBody convert_breaks="1"$>'), html_text_transform($entry->text));
$entry->column_values->{convert_breaks} = undef;
ok(build($ctx, '<$MTEntryBody$>'), html_text_transform($entry->text));
ok(build($ctx, '<$MTEntryBody convert_breaks="0"$>'), $entry->text);
ok(build($ctx, '<$MTEntryBody convert_breaks="1"$>'), html_text_transform($entry->text));
$blog->convert_paras(0);
ok(build($ctx, '<$MTEntryBody$>'), $entry->text);
ok(build($ctx, '<$MTEntryBody convert_breaks="0"$>'), $entry->text);
ok(build($ctx, '<$MTEntryBody convert_breaks="1"$>'), html_text_transform($entry->text));
$entry->convert_breaks(1);
$blog->convert_paras(1);

## Test convert_breaks variations with <$MTEntryMore$>.
ok(build($ctx, '<$MTEntryMore$>'), html_text_transform($entry->text_more));
ok(build($ctx, '<$MTEntryMore convert_breaks="0"$>'), $entry->text_more);
ok(build($ctx, '<$MTEntryMore convert_breaks="1"$>'), html_text_transform($entry->text_more));
$entry->convert_breaks(0);
ok(build($ctx, '<$MTEntryMore$>'), $entry->text_more);
ok(build($ctx, '<$MTEntryMore convert_breaks="0"$>'), $entry->text_more);
ok(build($ctx, '<$MTEntryMore convert_breaks="1"$>'), html_text_transform($entry->text_more));
$entry->column_values->{convert_breaks} = undef;
ok(build($ctx, '<$MTEntryMore$>'), html_text_transform($entry->text_more));
ok(build($ctx, '<$MTEntryMore convert_breaks="0"$>'), $entry->text_more);
ok(build($ctx, '<$MTEntryMore convert_breaks="1"$>'), html_text_transform($entry->text_more));
$blog->convert_paras(0);
ok(build($ctx, '<$MTEntryMore$>'), $entry->text_more);
ok(build($ctx, '<$MTEntryMore convert_breaks="0"$>'), $entry->text_more);
ok(build($ctx, '<$MTEntryMore convert_breaks="1"$>'), html_text_transform($entry->text_more));
$entry->convert_breaks(1);
$blog->convert_paras(1);

## This should run remove_html first (stripping "<html">), then
## run encode_xml. Previous to 2.61 encode_xml was run first, wrapping
## the excerpt in CDATA, which was then screwed up by remove_html.
$entry->excerpt('Contains <html>');
ok(build($ctx, '<$MTEntryExcerpt remove_html="1" encode_xml="1"$>'), 'Contains ');
$entry->excerpt('Fight the powers that be');

## Test with set excerpt.
ok(build($ctx, '<$MTEntryExcerpt$>'), $entry->excerpt);
ok(build($ctx, '<$MTEntryExcerpt convert_breaks="1"$>'), html_text_transform($entry->excerpt));
ok(build($ctx, '<$MTEntryExcerpt no_generate="1"$>'), $entry->excerpt);

## Test with auto-generating excerpt.
$entry->excerpt('');
ok(build($ctx, '<$MTEntryExcerpt$>'), first_n_words($entry->text, 40) . '...');
ok(build($ctx, '<$MTEntryExcerpt convert_breaks="1"$>'), first_n_words($entry->text, 40) . '...');
ok(build($ctx, '<$MTEntryExcerpt no_generate="1"$>'), '');

## Make sure text formatting is applied before excerpt is generated,
## unless convert_breaks="0" is explicitly set.
$entry->convert_breaks('wiki');
$entry->text(q(This text is ''strong''));
ok(build($ctx, '<$MTEntryExcerpt$>'), 'This text is strong...');
ok(build($ctx, '<$MTEntryExcerpt convert_breaks="1"$>'), 'This text is strong...');
ok(build($ctx, '<$MTEntryExcerpt convert_breaks="0"$>'), q(This text is ''strong''...));

$entry->convert_breaks('__default__');
$entry->text('Elvis was a hero to most but he never meant shit to me');

ok(build($ctx, '<$MTEntryBody encode_xml="1"$>'), "<![CDATA[<p>Elvis was a hero to most but he never meant shit to me</p>]]>");

my $comment = MT::Comment->new;
$comment->entry_id($entry->id);
$comment->blog_id($entry->blog_id);
$comment->author('JL');
$comment->text('This is not a comment');
$comment->visible(1);
$comment->save or die $comment->errstr;

ok(build($ctx, '<MTComments><$MTCommentBody encode_xml="1"$></MTComments>'),
   "<![CDATA[<p>This is not a comment</p>]]>");
ok(build($ctx, '<$MTEntryCommentCount$>'), 1);
