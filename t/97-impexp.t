#!/usr/bin/perl

use strict;
use warnings;

use lib 't/lib', 'lib', 'extlib';
use Test::More tests => 6;

BEGIN {
        $ENV{MT_APP} = 'MT::App::CMS';
}

use MT;
use MT::Author;
use MT::CMS::Export;
use MT::Blog;
use MT::Comment;
use MT::Entry;
use MT::Import;
use MT::ImportExport;
use MT::Test qw( :app :db :data );

my $blog = MT::Blog->load(1);
my $user = MT::Author->load(2);

# export entries from a valid blog
my $app = _run_app( 'MT::App::CMS', { __test_user => $user, __mode => 'export', blog_id => $blog->id } );
my $good_out = delete $app->{__test_output};
ok ($good_out, "Export data is present");

# export entries for an invalid blog
$app = _run_app( 'MT::App::CMS', { __test_user => $user, __mode => 'export', blog_id => 1000 } );
my $bad_out = delete $app->{__test_output};
ok ($bad_out =~ /Load of blog '1000' failed/, "Failed as expected");

# write the file and make sure no funny characters are there
open OUT, ">test_import.txt";
foreach my $line (split "\n", $good_out) {
/);     next if ($line =~ /
	chomp $line;
	print OUT "$line\n";
}
close OUT;

# we are going to use the existing blog, so make sure all entries and comments are removed
my @entries = MT::Entry->load({ blog_id => $blog->id });
foreach my $entry (@entries) {
	$entry->remove;
}
ok (MT::Entry->count({ blog_id => $blog->id }) == 0, "Got rid of all entries");

my @comments = MT::Comment->load({ blog_id => $blog->id });
foreach my $comment (@comments) {
	$comment->remove;
}
ok (MT::Comment->count({ blog_id => $blog->id }) == 0, "Got rid of all comments");

# use the file as the input to the import script
my $impt = MT::Import->new;
my $ie = MT::ImportExport->new;
open IN, "<test_import.txt" or die "COULD NOT OPEN FILE";
close IN;
my $iter  = $impt->_get_stream_iterator('test_import.txt', sub { my ($string) = @_; print STDERR "[cb_iterator] $string\n"; 1});

my %param = ();
$param{'Iter'} = $iter;
$param{'Blog'} = $blog;
$param{'Callback'} = 1;
$param{'ParentAuthor'} = $user;
$param{'NewAuthorPassword'} = 'PASSWORD';
$param{'ConvertBreaks'} = '';
$param{'Callback'} = sub { my ($string) = @_; print " $string\n"; 1};
my $result = $ie->import_contents(%param);

# check if the blog has entries and comments
ok (MT::Entry->count({ blog_id => $blog->id }) > 0, "We have entries again");
ok (MT::Comment->count({ blog_id => $blog->id }) > 0, "We have comments again");
