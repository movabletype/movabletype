#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Author;
use MT::CMS::Export;
use MT::Blog;
use MT::Comment;
use MT::Entry;
use MT::Import;
use MT::ImportExport;
use MT::Test;
use MT::Test::App;

$test_env->prepare_fixture('db_data');

my $blog = MT::Blog->load(1);
my $user = MT::Author->load(2);

# export entries from a valid blog
my $app = MT::Test::App->new('MT::App::CMS');
$app->login($user);
$app->post_ok({ __mode => 'export', blog_id => $blog->id });
my $good_out = $app->content;

# export entries for an invalid blog
my $res = eval { $app->post_ok({ __mode => 'export', blog_id => 1000 }); };
my $error = $@ || $app->generic_error;
like($error, qr/Invalid request/i, "Failed as expected");

# write the file and make sure no funny characters are there
open my $OUT, ">", "test_import.txt";
foreach my $line (split "\n", $good_out) {
    chomp $line;
    print $OUT "$line\n";
}
close $OUT;

# we are going to use the existing blog, so make sure all entries and comments are removed
my @entries = MT::Entry->load({ blog_id => $blog->id });
foreach my $entry (@entries) {
    $entry->remove;
}
ok(MT::Entry->count({ blog_id => $blog->id }) == 0, "Got rid of all entries");

my @comments = MT::Comment->load({ blog_id => $blog->id });
foreach my $comment (@comments) {
    $comment->remove;
}
ok(MT::Comment->count({ blog_id => $blog->id }) == 0, "Got rid of all comments");

# use the file as the input to the import script
my $impt = MT::Import->new;
my $ie   = MT::ImportExport->new;
open my $IN, "<", "test_import.txt" or die "COULD NOT OPEN FILE";
close $IN;
my $iter = $impt->_get_stream_iterator('test_import.txt', sub { my ($string) = @_; print STDERR "[cb_iterator] $string\n"; 1 });

my %param = ();
$param{'Iter'}              = $iter;
$param{'Blog'}              = $blog;
$param{'Callback'}          = 1;
$param{'ParentAuthor'}      = $user;
$param{'NewAuthorPassword'} = 'PASSWORD';
$param{'ConvertBreaks'}     = '';
$param{'Callback'}          = sub { my ($string) = @_; print " $string\n"; 1 };
my $result = $ie->import_contents(%param);

# check if the blog has entries and comments
ok(MT::Entry->count({ blog_id => $blog->id }) > 0, "We have entries again");

unlink("test_import.txt");

done_testing;
