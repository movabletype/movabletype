#!/usr/bin/perl -w

use strict;
use warnings;

use lib 'extlib';
use lib 'lib';
use lib 't/lib';

use Test::More qw(no_plan);

use MT;
use MT::Blog;
use MT::Entry;
use MT::Template;
use MT::Template::Context;
use MT::Test qw(:db :data);

my $mt = MT->new or die MT->errstr;

my $blog = MT::Blog->load(1);
$blog->include_cache(1);
$blog->include_system("");

my $include = MT::Template->new;
$include->blog_id($blog->id);
$include->name('Included Template');
$include->type('custom');
$include->text('hello');
$include->cache_expire_type(2);
$include->cache_expire_event("entry");
$include->include_with_ssi(0);
$include->save;

my $tmpl = MT::Template->new;
$tmpl->blog_id($blog->id);
$tmpl->text('<mt:include module="Included Template">');

my $ctx = MT::Template::Context->new;

my $out1 = $tmpl->build($ctx, {});
is($out1, "hello", "Test template successfully built");

$tmpl->text('<mt:include module="Included Template"> yay');
$tmpl->save;

my $out2 = $tmpl->build($ctx, {});
is($out2, "hello", "Test template should be the same");

my $entry = MT::Entry->new;
$entry->text("Hello");
$entry->blog_id($blog->id);
$entry->status(MT::Entry::RELEASE());
$entry->title("Hello");
$entry->author_id(2);
$entry->save;

$mt->rebuild( BlogId => $blog->id, Force  => 1 ) || print "Rebuild error: ", $mt->errstr;

my $out3 = $tmpl->build($ctx, {});
is($out3, "hello yay", "Test template should be the same");
