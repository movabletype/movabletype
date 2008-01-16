#!/usr/bin/perl
# $Id$
use strict;
use warnings;

use Test::More tests => 3;
use CGI;
use DB_File;

use MT;
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

MT->add_callback('MT::Entry::pre_save', 1, $plugin, 
		 sub { my ($eh, $obj, $app_obj) = @_; 
		       $obj->text(rot13($obj->text));
		       $app_obj->text($app_obj->text . '(rot13d)')} )
    || die "Couldn't add pre_save cb: " . MT->errstr;
MT->add_callback('MT::Entry::post_load', 1, $plugin,
		 sub { my ($eh, $args, $obj) = @_;
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
my $id = $entry->id();
is($entry->text, $TEST_TEXT . '(rot13d)', 'in-mem object altered');

my $entry2 = MT::Entry->load($id);
is($entry2->text, $TEST_TEXT, 'on-disk obj altered');

# TBD: generalize this
my $driver = MT::ObjectDriver->new('DBI::SQLite');

#my %entries;
#tie %entries, "DB_File", $mt->{cfg}->DataSource . "/entry.db",
#                         O_RDWR, 0400, $DB_BTREE
#    || die $!;
#my $rec = $entries{$id};
#$rec = $driver->{serializer}->unserialize($rec);
#is($$rec->{text}, rot13($TEST_TEXT), 'text rotated');

#is($entry2->text_more, $TEST_TEXT_MORE, '$entry2->text_more()');
#is($$rec->{text_more}, $TEST_TEXT_MORE, '$$rec->{text_more}');

### Test app callbacks

my @result_cats = ();

my $cms = MT::App::CMS->new(Config => $T_CFG);

MT->add_callback('AppPostEntrySave', 1, $plugin, 
                 sub { 
                       my @plcmts = MT::Placement->load({entry_id => $_[2]->id});
		       for my $plcmt (@plcmts) {
			   push @result_cats, $plcmt->category_id;
		       }
		   } );

MT::unplug();
my $q = CGI->new();
#$q->param(id => $entry2->id);
$q->param(blog_id => $entry2->blog_id);
$q->param(category_id => 17);
# $q->param(username => 'Chuck D');
# $q->param(password => 'bass');
$q->param(text => "Buddha blessed and boo-ya blasted; 
these are the words that she manifested.");
$cms->{query} = $q;
$cms->{perms} = MT::Permission->new();
$cms->{perms}->can_post(1);
$cms->{author} = MT::Author->new();
$cms->{author}->name("Mel E. Mel");
$cms->{author}->id(1);
# fake out the magic; we're not testing that right now
no warnings qw(once redefine);
*MT::App::CMS::validate_magic = sub { 1; };
use warnings qw(once redefine);
print STDERR $cms->save_entry();
is($result_cats[0], 17, 'result_cats = 17');
