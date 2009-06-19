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
use MT::Util qw(offset_time_list);

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
ok($out1 eq "hello", "Test template successfully built");

my @ts = offset_time_list(time, $blog->id);
my $ts = sprintf '%04d%02d%02d%02d%02d%02d', $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
MT::Request->instance->reset;
$include->text('hello yay');
$include->modified_on($ts);
$include->save;
MT::Touch->touch($blog->id, 'entry');
my $out2 = $tmpl->build($ctx, {});
ok($out2 eq "hello", "Test template should be the same");

MT::Request->instance->reset;
my $entry = MT::Entry->new;
$entry->text("Hello");
$entry->blog_id($blog->id);
$entry->status(MT::Entry::RELEASE());
$entry->title("Hello");
$entry->author_id(2);
$entry->save;
MT::Touch->touch($blog->id, 'template');
MT::Touch->touch($blog->id, 'entry');
@ts = offset_time_list(time, $blog->id);
$ts = sprintf '%04d%02d%02d%02d%02d%02d', $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
$tmpl->modified_on($ts);
$tmpl->save;
$mt->rebuild( BlogId => $blog->id, Force  => 1 ) || print "Rebuild error: ", $mt->errstr;
my $out3 = $tmpl->build($ctx, {});
ok($out3 ne "hello yay", "Test template should be different");
