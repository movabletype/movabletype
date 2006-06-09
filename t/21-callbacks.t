# $Id$

use strict;

BEGIN { unshift @INC, 't/' }

use Test;

BEGIN { plan tests => 6 };

use MT;

BEGIN { unshift @INC, 't/' }

require 'test-common.pl';
require 'blog-common.pl';

use vars qw($T_CFG);

my $mt = MT->new(Config => $T_CFG);

die "Couldn't create MT (" . MT->errstr. ")" unless $mt;

print "# " . MT->errstr() if !$mt;

sub rot13 {
    $_[0] =~ tr/A-Za-z/N-ZA-Mn-za-m/;
    return $_[0];
}

use MT::Plugin;

my $plug = new MT::Plugin();

use MT::Entry;

# my $blog = MT::Blog->new();
# $blog->set_values({ name => 'none'});
# $blog->save();

use MT::Plugin;
my $plugin = new MT::Plugin({name => "21-callbacks.t"});


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
ok($entry->text, $TEST_TEXT . '(rot13d)');   # test that the in-mem object got altered

my $entry2 = MT::Entry->load($id);
ok($entry2->text, $TEST_TEXT);     # test that the on-disk obj got altered

use MT::ObjectDriver::DBM;

# TBD: generalize this
my $driver = MT::ObjectDriver->new('DBM');

use DB_File;
use strict;

my %entries;
tie %entries, "DB_File", $mt->{cfg}->DataSource . "/entry.db",
                         O_RDWR, 0400, $DB_BTREE
    || die $!;
my $rec = $entries{$id};
$rec = $driver->{serializer}->unserialize($rec);
use Data::Dumper;
ok($$rec->{text}, rot13($TEST_TEXT));

ok($entry2->text_more, $TEST_TEXT_MORE);
ok($$rec->{text_more}, $TEST_TEXT_MORE);

### Test app callbacks

my @result_cats = ();

require MT::App::CMS;
my $cms = MT::App::CMS->new(Config => $T_CFG);

MT->add_callback('AppPostEntrySave', 1, $plugin, 
                 sub { 
                       my @plcmts = MT::Placement->load({entry_id => $_[2]->id});
		       for my $plcmt (@plcmts) {
			   push @result_cats, $plcmt->category_id;
		       }
		   } );

MT::unplug();
require CGI;
my $q = new CGI;
#$q->param(id => $entry2->id);
$q->param(blog_id => 1);
$q->param(category_id => 17);
# $q->param(username => 'Chuck D');
# $q->param(password => 'bass');
$q->param(text => "Buddha blessed and boo-ya blasted; 
these are the words that she manifested.");
$cms->{query} = $q;
require MT::Permission;
$cms->{perms} = new MT::Permission();
$cms->{perms}->can_post(1);
$cms->{author} = new MT::Author();
$cms->{author}->name("Mel E. Mel");
$cms->{author}->id(1);
# fake out the magic; we're not testing that right now
no warnings 'once';
*MT::App::CMS::validate_magic = sub { 1; };
use warnings 'once';
print STDERR $cms->save_entry();
ok($result_cats[0], 17);
