#!perl
use strict;
use warnings;

use MT::Test tests => 3;

MT->new(Config => '../../mt.cfg') or die MT->errstr;

map {
    run_test_tmpl(sub { tmpl($_) })
} qw( feed_link_href feed_link_no_rel feed_link_rel );

sub tmpl {
    my $uri  = 'http://lab.appnel.com/6A/feeds-app-lite/' . $_[0] . '.xml';
    my $tmpl = <<TMPL;
<MTFeeds uri="$uri">
<MTTestIs value="http://www.example.com/"><MTFeedLink></MTTestIs>
</MTFeeds>
TMPL
    $tmpl;
}
