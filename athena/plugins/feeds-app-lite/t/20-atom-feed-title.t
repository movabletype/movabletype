#!perl
use strict;
use warnings;

use MT::Test tests => 8;

MT->new(Config => '../../mt.cfg') or die MT->errstr;

map {
    run_test_tmpl(sub { tmpl($_, 'Example Atom') })
  }
  qw( feed_title feed_title_content_type_text
  feed_title_content_type feed_title_content_value
  feed_title_text_plain);

run_test_tmpl(sub { tmpl_markup('feed_title_inline_markup') }, \&init);
run_test_tmpl(sub { tmpl_markup('feed_title_inline_markup_2') },
              sub { init(@_, 'History of the <blink> tag') });
run_test_tmpl(sub { tmpl_markup('feed_title_escaped_markup') }, \&init);

sub tmpl {
    my $uri  = 'http://lab.appnel.com/6A/feeds-app-lite/' . $_[0] . '.xml';
    my $val  = $_[1];
    my $tmpl = <<TMPL;
<MTFeeds uri="$uri">
<MTTestIs value="$val"><MTFeedTitle></MTTestIs>
</MTFeeds>
TMPL
    $tmpl;
}

sub init { $_[1]->{__stash}{vars}{'markup'} = $_[2] || 'Example <b>Atom</b>' }

sub tmpl_markup {
    my $uri  = 'http://lab.appnel.com/6A/feeds-app-lite/' . $_[0] . '.xml';
    my $tmpl = <<TMPL;
<MTFeeds uri="$uri">
<MTTestIs var="markup"><MTFeedTitle></MTTestIs>
</MTFeeds>
TMPL
    $tmpl;
}
