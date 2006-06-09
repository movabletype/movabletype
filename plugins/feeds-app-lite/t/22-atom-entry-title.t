#!perl
use strict;
use warnings;

use MT::Test tests => 6;

MT->new(Config => '../../mt.cfg') or die MT->errstr;

run_test_tmpl(sub { tmpl('entry_title_content_value', 'Example Atom') });
run_test_tmpl(sub { tmpl('entry_title_text_plain',    'Example Atom') });

run_test_tmpl(sub { tmpl_markup('entry_title_text_plain_brackets') },
              sub { init(@_, 'History of the <blink> tag') });

run_test_tmpl(sub { tmpl_markup('entry_title_inline_markup') }, \&init);
run_test_tmpl(sub { tmpl_markup('entry_title_inline_markup_2') },
              sub { init(@_, 'History of the <blink> tag') });
run_test_tmpl(sub { tmpl_markup('entry_title_escaped_markup') }, \&init);

sub tmpl {
    my $uri  = 'http://lab.appnel.com/6A/feeds-app-lite/' . $_[0] . '.xml';
    my $val  = $_[1];
    my $tmpl = <<TMPL;
<MTFeeds uri="$uri">
<MTFeedEntries lastn="1">
<MTTestIs value="$val"><MTFeedEntryTitle></MTTestIs>
</MTFeedEntries>
</MTFeeds>
TMPL
    $tmpl;
}

sub init { $_[1]->{__stash}{vars}{'markup'} = $_[2] || 'Example <b>Atom</b>' }

sub tmpl_markup {
    my $uri  = 'http://lab.appnel.com/6A/feeds-app-lite/' . $_[0] . '.xml';
    my $tmpl = <<TMPL;
<MTFeeds uri="$uri">
<MTFeedEntries lastn="1">
<MTTestIs var="markup"><MTFeedEntryTitle></MTTestIs>
</MTFeedEntries>
</MTFeeds>
TMPL
    $tmpl;
}
