#!/usr/bin/perl

use strict;
use warnings;
use File::Copy;
use Data::Dumper;

use lib qw( t t/lib ./extlib ./lib);

use Test::More tests => 9;
use MT::Test qw(:db :data);

undef $MT::mt_inst;
eval { undef %MT::mt_inst };
undef @MT::Components;
undef %MT::Components;
undef %MT::Plugins;
undef $MT::MT_DIR;

require MT::App::CMS;
my $app = MT::App::CMS->instance;
$app->param('save_revision', 1);

my $entry = $app->model('entry')->load(1);
my $orig = $entry->clone();
$entry->title( "A rainY dayclass" );
save_entry();

$entry->title( lc $entry->title() );
save_entry();

my $text = $entry->text();
$text .= "\nThis is another line\n";
$entry->text( $text );
save_entry();

is( $app->model('entry:revision')->count({entry_id=>$entry->id}), 3, "we should have two revisions by now" );

my $rev_rec1 = $entry->load_revision(2);
my $rev_rec2 = $entry->load_revision(3);

isnt($rev_rec1, undef, "Got non-undef revision record");

my $rev1 = $rev_rec1->[0];
my $rev2 = $rev_rec2->[0];

isnt($rev1, undef, "Got non-undef revision");

my $diff = $rev1->diff_object($rev2);
clean_diff($diff);

is($entry->current_revision(), 3, "current revision is 3");

my $diff2 = $entry->diff_revision(2);
clean_diff($diff2);

is_deeply($diff, $diff2, "diff revision with current");

my $diff3 = $entry->diff_revision({rev_number => [2,3]});
clean_diff($diff3);
is_deeply($diff, $diff3, "diff revision with current");

my $diff4 = $entry->diff_revision({rev_number => [1,2]});
my $diff5 = $entry->diff_revision(1);
clean_diff($diff4);
clean_diff($diff5);
isnt(undef, $diff4, "diff4 is not undef");
is_deeply($diff5, { %$diff4, %$diff }, "two diffs equal big diff");

is($rev1->title, lc("A rainY dayclass"), "rev is a normal entry object");

sub clean_diff {
	my ($diff) = @_;
	while (my ($key, $val) = each %$diff) {
		delete $diff->{$key} unless $val and @$val;
		if (@$val == 1) {
			my $flag = $val->[0]->{flag};
			delete $diff->{$key} if not $flag or $flag eq 'u';
		}
	}
}

sub save_entry {
	$app->run_callbacks('cms_pre_save.entry', $app, $entry, $orig);
	$entry->save();
	$app->run_callbacks('cms_post_save.entry', $app, $entry, $orig);
	$orig = $entry->clone();
}
