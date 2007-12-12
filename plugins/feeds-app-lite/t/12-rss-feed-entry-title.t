#!perl
use strict;
use warnings;

use MT::Test tests => 5;

MT->new(Config => '../../mt.cfg') or die MT->errstr;

map {
    run_test_tmpl(sub { tmpl($_) })
} qw( example10 example11 example12 example13 example14 );

sub tmpl {
    my $uri  = 'http://lab.appnel.com/6A/feeds-app-lite/' . $_[0] . '.xml';
    my $tmpl = <<TMPL;
<MTFeeds uri="$uri">
<MTFeedEntries lastn="1">
<MTTestIs value="ENTRY TITLE"><MTFeedEntryTitle></MTTestIs>
</MTFeedEntries>
</MTFeeds>
TMPL
    $tmpl;
}
