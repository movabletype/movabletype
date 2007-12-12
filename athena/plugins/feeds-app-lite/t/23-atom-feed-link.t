#!perl
use strict;
use warnings;

use MT::Test tests => 3;

MT->new(Config => '../../mt.cfg') or die MT->errstr;

map {
    run_test_tmpl(sub { tmpl($_) })
} qw( entry_link_href entry_link_no_rel entry_link_rel );

sub tmpl {
    my $uri  = 'http://lab.appnel.com/6A/feeds-app-lite/' . $_[0] . '.xml';
    my $tmpl = <<TMPL;
<MTFeeds uri="$uri">
<MTFeedEntries lastn="1">
<MTTestIs value="http://www.example.com/"><MTFeedEntryLink></MTTestIs>
</MTFeedEntries>
</MTFeeds>
TMPL
    $tmpl;
}
