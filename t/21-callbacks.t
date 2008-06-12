#!/usr/bin/perl
# $Id$
use strict;
use warnings;

use Test::More tests => 5;
use CGI;

use lib 'extlib';
use lib 't/lib';
use lib 'lib';

use MT;
use MT::Test;
use MT::Plugin;
use MT::Entry;
use MT::App::CMS;
use MT::Permission;

use vars qw($T_CFG);

use lib 't';
require 'test-common.pl';
require 'blog-common.pl';

my $mt = MT->new(Config => $T_CFG);
die "Couldn't create MT (" . MT->errstr. ")" unless $mt;

sub rot13 {
    $_[0] =~ tr/A-Za-z/N-ZA-Mn-za-m/;
    return $_[0];
}

my $plug = MT::Plugin->new();

# my $blog = MT::Blog->new();
# $blog->set_values({ name => 'none'});
# $blog->save();

my $plugin = MT::Plugin->new({name => "21-callbacks.t"});

### Test object callbacks

my ($pre_save_called, $post_load_called);
MT->add_callback('MT::Entry::pre_save', 1, $plugin, 
                 sub { my ($eh, $obj, $app_obj) = @_;
                       $pre_save_called = 1;
                       $obj->text(rot13($obj->text));
                       $app_obj->text($app_obj->text . '(rot13d)')} )
    || die "Couldn't add pre_save cb: " . MT->errstr;
MT->add_callback('MT::Entry::post_load', 1, $plugin,
                 sub { my ($eh, $obj) = @_;
                       $post_load_called = 1;
                       $obj->text(rot13($obj->text)) } )
    || die "Couldn't add post_load cb: " . MT->errstr;

my $entry = MT::Entry->new();
my $TEST_TEXT = "Come flow on the mic with the mighty mic master ";
my $TEST_TEXT_MORE = "beau-coup ducks, I'm a sucker to disaster. Scribble-dabbble scrabble, on the microphone I babble, as I fit the funky words! Into a puzzle! Yes, yes, yes, on and on as I flex, .... birds manifest, feel the vibe from here to Asia--dip trip, flip fantasia.";
$entry->author_id(1);
$entry->status(1);
$entry->text($TEST_TEXT);
$entry->text_more($TEST_TEXT_MORE);
$entry->title("Cantaloop");
$entry->blog_id(1);
$entry->save() or die $entry->errstr();

ok($pre_save_called, 'pre-save callback was called');

is($entry->text, $TEST_TEXT . '(rot13d)', 'in-mem object altered');

my $id = $entry->id();
ok($id, 'new entry has an id');

my $entry2 = MT::Entry->load($id);
ok($post_load_called, 'post-load callback was called');
is($entry2->text, $TEST_TEXT, 'on-disk obj altered');

