# $Id$

BEGIN { unshift @INC, 't/' }

use Test;
use MT::Entry;
use MT::Blog;
use MT;
use strict;

BEGIN { plan tests => 29 };

use vars qw( $DB_DIR $T_CFG );
require 'test-common.pl';
system('rm t/db/* 2>/dev/null');
require 'blog-common.pl';
my $mt = MT->new( Config => $T_CFG ) or die MT->errstr;
MT->add_text_filter(wiki => {
    label => 'Wiki',
    on_format => sub {
        require Text::WikiFormat;
        Text::WikiFormat::format($_[0]);
    },
});

my $blog = MT::Blog->load(1);
ok($blog);

my $entry = MT::Entry->load(1);
ok($entry);
ok($entry->blog_id, $blog->id);
ok($entry->status, MT::Entry::RELEASE());
ok($entry->status, 2);
ok($entry->title, 'A Rainy Day');
ok($entry->allow_comments, 1);
ok($entry->excerpt, 'A story of a stroll.');
ok($entry->text, 'On a drizzly day last weekend,');
ok($entry->text_more, 'I took my grandpa for a walk.');

ok(MT::Entry::status_text(1), 'Draft');
ok(MT::Entry::status_text($entry->status), 'Publish');
ok(MT::Entry::status_int('Draft'), 1);
ok(MT::Entry::status_int('Publish'), 2);
ok(MT::Entry::status_int('Future'), 4);

my $author = $entry->author;
ok($author->name, 'Chuck D');
#ok($author->id, 1);

## Test next and previous.
## Test category, categories, and is_in_category.
## Test permalink, archive_url, archive_file.
## Test text_filters.
## Test comments, comment_count, ping_count.

## Test entry auto-generation.
$entry->excerpt('');
ok($entry->excerpt, '');
ok($entry->get_excerpt, $entry->text . '...');
$blog->words_in_excerpt(3);
ok($entry->get_excerpt, 'On a drizzly...');
$entry->convert_breaks('wiki');
$entry->text("Foo ''bar'' baz");
ok($entry->get_excerpt, 'Foo bar baz...');

## Test TrackBack object generation.
$entry->allow_pings(1);
ok($entry->save);
my $tb = MT::Trackback->load({ entry_id => $entry->id });
ok($tb);
ok($tb->entry_id, $entry->id);
ok($tb->description, $entry->get_excerpt);
ok($tb->title, $entry->title);
ok($tb->url, $entry->permalink);
ok($tb->is_disabled, 0);
$entry->allow_pings(0);
ok($entry->save);
$tb = MT::Trackback->load({ entry_id => $entry->id });
ok($tb->is_disabled, 1);
