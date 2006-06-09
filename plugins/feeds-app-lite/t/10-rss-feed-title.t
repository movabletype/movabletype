#!perl
use strict;
use warnings;

use MT::Test tests => 5;

MT->new(Config => '../../mt.cfg') or die MT->errstr;

map {
    run_test_tmpl(sub { tmpl($_) })
} qw( example2 example3 example4 example5 example6 );

sub tmpl {
    my $uri  = 'http://lab.appnel.com/6A/feeds-app-lite/' . $_[0] . '.xml';
    my $tmpl = <<TMPL;
<MTFeeds uri="$uri">
<MTTestIs value="FEED TITLE"><MTFeedTitle></MTTestIs>
</MTFeeds>
TMPL
    $tmpl;
}
