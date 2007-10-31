#!perl
use strict;
use warnings;

use MT::Test tests => 6;

MT->new(Config => '../../mt.cfg') or die MT->errstr;

map {
    run_test_tmpl(sub { tmpl($_) })
} qw( example28 example29 example32 example33 example34 example35 );

sub tmpl {
    my $uri  = 'http://lab.appnel.com/6A/feeds-app-lite/' . $_[0] . '.xml';
    my $tmpl = <<TMPL;
<MTFeeds uri="$uri">
<MTFeedEntries lastn="1">
<MTTestIs value="http://www.example.com/ENTRY/ALTERNATE/LINK/"><MTFeedEntryLink></MTTestIs>
</MTFeedEntries>
</MTFeeds>
TMPL
    $tmpl;
}
