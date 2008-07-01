#!/usr/bin/perl
# $Id$
use strict;
use warnings;

use lib 't/lib';
use lib 'lib';
use lib 'extlib';

use Test::More tests => 31;

use MT;
use MT::Blog;
use MT::Entry;

use vars qw( $DB_DIR $T_CFG );

use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use MT::Test qw(:db :data);

my $mt = MT->instance( Config => $T_CFG ) or die MT->errstr;
isa_ok($mt, 'MT');

my $blog = MT::Blog->load(1);
isa_ok($blog, 'MT::Blog');

my $entry = MT::Entry->load(1);
isa_ok($entry, 'MT::Entry');
is($entry->blog_id, $blog->id, 'blog id');
is($entry->status, MT::Entry::RELEASE(), 'status');
is($entry->status, 2, 'status 2');
is($entry->title, 'A Rainy Day', 'title');
is($entry->allow_comments, 1, 'allow_comments 1');
is($entry->excerpt, 'A story of a stroll.', 'excerpt');
is($entry->text, 'On a drizzly day last weekend,', 'text');
is($entry->text_more, 'I took my grandpa for a walk.', 'text_more');

is(MT::Entry::status_text(1), 'Draft', 'Draft');
is(MT::Entry::status_text($entry->status), 'Publish', 'Publish');
is(MT::Entry::status_int('Draft'), 1, 'Draft 1');
is(MT::Entry::status_int('Publish'), 2, 'Publish 2');
is(MT::Entry::status_int('Future'), 4, 'Future 4');

my $author = $entry->author;
isa_ok($author, 'MT::Author');
is($author->name, 'Chuck D', 'name');
#ok($author->id, 1);

## Test next and previous.
## Test category, categories, and is_in_category.
## Test permalink, archive_url, archive_file.
## Test text_filters.
## Test comments, comment_count, ping_count.

## Test entry auto-generation.
$entry->excerpt('');
is($entry->excerpt, '', 'excerpt empty');
is($entry->get_excerpt, $entry->text . '...', 'get_excerpt');
$blog->words_in_excerpt(3);
$entry->cache_property('blog', undef, $blog);
is($entry->get_excerpt, 'On a drizzly...', 'get_excerpt');
$entry->convert_breaks('textile_2');
$entry->text("Foo _bar_ baz");
is($entry->get_excerpt, 'Foo bar baz...', 'get_excerpt');

## Test TrackBack object generation.
$entry->allow_pings(1);
ok($entry->save, 'save');
my $tb = MT::Trackback->load({ entry_id => $entry->id });
isa_ok($tb, 'MT::Trackback');
is($tb->entry_id, $entry->id, 'entry_id');
is($tb->description, $entry->get_excerpt, 'description');
is($tb->title, $entry->title, 'title');
is($tb->url, $entry->permalink, 'url');
is($tb->is_disabled, 0, 'is_disabled');
$entry->allow_pings(0);
ok($entry->save, 'save');
$tb = MT::Trackback->load({ entry_id => $entry->id });
is($tb->is_disabled, 1, 'is_disabled');
