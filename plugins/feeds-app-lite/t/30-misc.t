#!perl
use strict;
use warnings;

use MT::Test tests => 25;

MT->new(Config => '../../mt.cfg') or die MT->errstr;

my @src = (
           'First post',
           'Second post',
           'Third post',
           'Fourth post',
           'Fifth post',
           'Sixth post',
           'Seventh post',
           'Eighth post',
           'Ninth post',
           'Tenth post'
);

my @titles;

my $tmpl1 = <<TMPL1;
<MTFeeds uri="http://lab.appnel.com/6A/feeds-app-lite/full_rss.xml">
<MTFeedEntries>
<MTTestListItem stash="titles"><MTFeedEntryTitle></MTTestListItem>
</MTFeedEntries>
</MTFeeds>
TMPL1

@titles = @src;    # clone.
run_test_tmpl(\$tmpl1, sub { $_[1]->stash('titles', \@titles) });

my $tmpl2 = <<TMPL2;
<MTFeeds uri="http://lab.appnel.com/6A/feeds-app-lite/full_rss.xml">
<MTFeedEntries lastn="3">
<MTTestListItem stash="titles"><MTFeedEntryTitle></MTTestListItem>
</MTFeedEntries>
</MTFeeds>
TMPL2

@titles = @src[0 .. 2];
run_test_tmpl(\$tmpl2, sub { $_[1]->stash('titles', \@titles) });

my $tmpl3 = <<TMPL3;
<MTFeeds uri="http://lab.appnel.com/6A/feeds-app-lite/full_rss.xml">
<MTFeedEntries offset="3">
<MTTestListItem stash="titles"><MTFeedEntryTitle></MTTestListItem>
</MTFeedEntries>
</MTFeeds>
TMPL3

@titles = @src[3 .. 9];
run_test_tmpl(\$tmpl3, sub { $_[1]->stash('titles', \@titles) });

my $tmpl4 = <<TMPL4;
<MTFeeds uri="http://lab.appnel.com/6A/feeds-app-lite/full_rss.xml">
<MTFeedEntries lastn="3" offset="3">
<MTTestListItem stash="titles"><MTFeedEntryTitle></MTTestListItem>
</MTFeedEntries>
</MTFeeds>
TMPL4

@titles = @src[3 .. 5];
run_test_tmpl(\$tmpl4, sub { $_[1]->stash('titles', \@titles) });

my $tmpl5 = <<TMPL5;
<MTTestIs blank="1" trim="1" test_name="Busted Feed Handling"><MTFeeds uri="http://lab.appnel.com/6A/feeds-app-lite/busted.xml">
<MTFeedEntries>
<MTFeedEntryTitle>
</MTFeedEntries>
</MTFeeds></MTTestIs>
TMPL5

run_test_tmpl(\$tmpl5);

my $tmpl6 = <<TMPL6;
<MTTestIs blank="1" test_name="Feed Not Found Handling"><MTFeeds uri="http://lab.appnel.com/6A/feeds-app-lite/noNEXisTanT.xml">
<MTFeedEntries>
<MTFeedEntryTitle>
</MTFeedEntries>
</MTFeeds></MTTestIs>
TMPL6

run_test_tmpl(\$tmpl6);
