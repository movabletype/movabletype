#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
    $ENV{MT_APP} = 'MT::App::CMS';
}

plan tests => 6;

use MT;
use MT::Author;
use MT::CMS::Export;
use MT::Blog;
use MT::Comment;
use MT::Entry;
use MT::Import;
use MT::ImportExport;
use MT::Test;

MT::Test->init_app;

$test_env->prepare_fixture('db_data');

my $blog = MT::Blog->load(1);
my $user = MT::Author->load(2);

# export entries from a valid blog
my $app = _run_app( 'MT::App::CMS', { __test_user => $user, __mode => 'export', blog_id => $blog->id } );
my $good_out = delete $app->{__test_output};
ok ($good_out, "Export data is present");

# export entries for an invalid blog
eval {
    $app = _run_app( 'MT::App::CMS', { __test_user => $user, __mode => 'export', blog_id => 1000 } );
};
my $eval_error = $@;
ok ( $eval_error );
like ($eval_error, qr/Invalid request/i, "Failed as expected");

# write the file and make sure no funny characters are there
open OUT, ">test_import.txt";
foreach my $line (split "\n", $good_out) {
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

unlink("test_import.txt");
