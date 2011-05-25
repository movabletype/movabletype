#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 9
  template: <MTEntries lastn='1'><MTEntryDate></MTEntries>
  expected: "January 31, 1978  7:45 AM"

-
  name: test item 10
  template: <MTEntries lastn='1'><MTEntryDate utc="1"></MTEntries>
  expected: "January 31, 1978 11:15 AM"

-
  name: test item 11
  template: <MTEntries lastn='1'><MTEntryDate format_name=""></MTEntries>
  expected: "January 31, 1978  7:45 AM"

-
  name: test item 12
  template: "<MTEntries lastn='1'><MTEntryDate format=\"%Y-%m-%dT%H:%M:%S\"></MTEntries>"
  expected: "1978-01-31T07:45:00"

-
  name: test item 13
  template: <MTEntries lastn='1'><MTEntryDate language="pl"></MTEntries>
  expected: "31 stycznia 1978  7:45"

-
  name: test item 36
  template: <MTEntries lastn="10"> * <MTEntryTitle></MTEntries>
  expected: " * A Rainy Day * Verse 5 * Verse 4 * Verse 3 * Verse 2 * Verse 1"

-
  name: test item 39
  template: <MTEntries lastn='1'><MTLink entry_id="1"></MTEntries>
  expected: "http://narnia.na/nana/archives/1978/01/a-rainy-day.html"


-
  name: test item 51
  template: <MTEntries category="foo"><MTEntryTitle></MTEntries>
  expected: Verse 3

-
  name: test item 52
  template: <MTEntries author="Bob D"><MTEntryTitle></MTEntries>
  expected: Verse 3

-
  name: test item 53
  template: <MTEntries days="DAYS_CONSTANT1"><MTEntryTitle></MTEntries>
  expected: A Rainy Day

-
  name: test item 54
  template: <MTEntries days="DAYS_CONSTANT2"><MTEntryTitle></MTEntries>
  expected: ''

-
  name: test item 55
  template: <MTEntries lastn="1"><MTEntryBody></MTEntries>
  expected: <p>On a drizzly day last weekend,</p>

-
  name: test item 56
  template: <MTEntries lastn="1"><MTEntryMore></MTEntries>
  expected: <p>I took my grandpa for a walk.</p>

-
  name: test item 57
  template: <MTEntries lastn="1"><MTEntryStatus></MTEntries>
  expected: Publish

-
  name: test item 58
  template: <MTEntries lastn="1"><MTEntryDate></MTEntries>
  expected: "January 31, 1978  7:45 AM"

-
  name: test item 59
  template: <MTEntries lastn="1"><MTEntryFlag flag="allow_pings"></MTEntries>
  expected: 1

-
  name: test item 60
  template: <MTEntries lastn="1"><MTEntryExcerpt></MTEntries>
  expected: A story of a stroll.

-
  name: test item 61
  template: <MTEntries lastn="1"><MTEntryKeywords></MTEntries>
  expected: keywords

-
  name: test item 62
  template: <MTEntries lastn="1"><MTEntryAuthor></MTEntries>
  expected: Chuck D

-
  name: test item 63
  template: <MTEntries lastn="1"><MTEntryAuthorNickname></MTEntries>
  expected: Chucky Dee

-
  name: test item 64
  template: <MTEntries lastn="1"><MTEntryAuthorEmail></MTEntries>
  expected: chuckd@example.com

-
  name: test item 65
  template: <MTEntries lastn="1"><MTEntryAuthorURL></MTEntries>
  expected: "http://chuckd.com/"

-
  name: test item 66
  template: <MTEntries lastn="1"><MTEntryAuthorLink></MTEntries>
  expected: "<a href=\"http://chuckd.com/\">Chucky Dee</a>"

-
  name: test item 67
  template: <MTEntries lastn="1"><MTEntryID></MTEntries>
  expected: 1

-
  name: test item 68
  template: <MTEntries lastn="1"><MTEntryTrackbackLink></MTEntries>
  expected: "http://narnia.na/cgi-bin/mt-tb.cgi/1"

-
  name: test item 69
  template: <MTEntries lastn="1"><MTEntryTrackbackData></MTEntries>
  expected: "<!--\n<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n         xmlns:trackback=\"http://madskills.com/public/xml/rss/module/trackback/\"\n         xmlns:dc=\"http://purl.org/dc/elements/1.1/\">\n<rdf:Description\n    rdf:about=\"http://narnia.na/nana/archives/1978/01/a-rainy-day.html\"\n    trackback:ping=\"http://narnia.na/cgi-bin/mt-tb.cgi/1\"\n    dc:title=\"A Rainy Day\"\n    dc:identifier=\"http://narnia.na/nana/archives/1978/01/a-rainy-day.html\"\n    dc:subject=\"\"\n    dc:description=\"A story of a stroll.\"\n    dc:creator=\"Chucky Dee\"\n    dc:date=\"1978-01-31T07:45:00-03:30\" />\n</rdf:RDF>\n-->\n"

-
  name: test item 70
  template: <MTEntries lastn="1"><MTEntryLink archive_type="Individual"></MTEntries>
  expected: "http://narnia.na/nana/archives/1978/01/a-rainy-day.html"

-
  name: test item 71
  template: <MTEntries lastn="1"><MTEntryPermalink archive_type="Individual"></MTEntries>
  expected: "http://narnia.na/nana/archives/1978/01/a-rainy-day.html"

-
  name: test item 72
  template: <MTEntries id="6"><MTEntryCategory></MTEntries>
  expected: foo

-
  name: test item 73
  template: <MTEntries id="6"><MTEntryCategories><MTCategoryLabel></MTEntryCategories></MTEntries>
  expected: foo

-
  name: test item 77
  run: 0
  template: <MTEntries lastn="1"></MTEntries>
  expected: ''

-
  name: test item 79
  template: <MTEntries lastn="1"><MTEntryTrackbackCount></MTEntries>
  expected: 1

-
  name: test item 80
  template: <MTEntries lastn="1" offset="1"><MTEntryNext><MTEntryTitle></MTEntryNext></MTEntries>
  expected: A Rainy Day

-
  name: test item 81
  template: <MTEntries offset="1" lastn="1"><MTEntryPrevious><MTEntryTitle></MTEntryPrevious></MTEntries>
  expected: Verse 4

-
  name: test item 82
  template: <MTEntries lastn="1"><MTEntryDate format_name="rfc822"></MTEntries>
  expected: "Tue, 31 Jan 1978 07:45:00 -0330"

-
  name: test item 83
  template: <MTEntries lastn="1"><MTEntryDate utc="1"></MTEntries>
  expected: "January 31, 1978 11:15 AM"

-
  name: test item 106
  template: <MTEntries lastn="1"><MTEntryTrackbackID></MTEntries>
  expected: 1

-
  name: test item 107
  template: <MTEntries lastn="1"><MTEntryBasename></MTEntries>
  expected: a_rainy_day

-
  name: test item 195
  template: <MTEntries lastn="1"><MTEntryAuthorUsername></MTEntries>
  expected: Chuck D

-
  name: test item 196
  template: <MTEntries lastn="1"><MTEntryAuthorDisplayName></MTEntries>
  expected: Chucky Dee

-
  name: test item 197
  template: <MTEntries lastn="1"><MTEntryAtomID></MTEntries>
  expected: "tag:narnia.na,1978:/nana//1.1"

-
  name: test item 198
  template: <MTEntries lastn="1"><MTEntryTitle trim_to="20"></MTEntries>
  expected: A Rainy Day

-
  name: test item 214
  template: <MTEntries lastn='1'><MTEntryIfExtended>entry is extended</MTEntryIfExtended></MTEntries>
  expected: entry is extended

-
  name: test item 215
  template: <MTEntries offset="2" lastn="2"> * <MTEntryTitle></MTEntries>
  expected: " * Verse 4 * Verse 3"

-
  name: test item 216
  template: <MTEntries offset="2"> * <MTEntryTitle></MTEntries>
  expected: " * Verse 4 * Verse 3 * Verse 2 * Verse 1"

-
  name: test item 229
  template: <MTEntries category='subfoo' lastn='1'><MTEntryTitle></MTEntries>
  expected: Verse 4

-
  name: test item 230
  run: 0
  template: <MTEntries tags='verse' category='foo' lastn='1'><MTEntryTitle></MTEntries>
  expected: Verse 3

-
  name: test item 231
  template: <MTEntries author='Bob D' category='foo'><MTEntryTitle></MTEntries>
  expected: Verse 3

-
  name: test item 232
  template: <MTEntries author='Chuck D' tags='strolling'><MTEntryTitle></MTEntries>
  expected: A Rainy Day

-
  name: test item 406
  template: <MTEntries recently_commented_on='3' glue=','><MTEntryTitle></MTEntries>
  expected: Verse 2,Verse 3,A Rainy Day

-
  name: test item 424
  template: "<mt:entries limit='1'><mt:EntryTitle></mt:Entries>"
  expected: A Rainy Day

-
  name: test item 425
  template: "<mt:entries category='NOT foo'><mt:EntryTitle>;</mt:Entries>"
  expected: A Rainy Day;Verse 5;Verse 4;Verse 2;Verse 1;

-
  name: test item 426
  template: "<mt:entries lastn='1' tags='verse'><mt:EntryTitle></mt:Entries>"
  expected: Verse 5

-
  name: test item 551
  template: <MTEntriesCount>
  expected: 6

-
  name: test item 552
  template: "<MTEntries lastn='3'><MTDateHeader>Header:<MTEntryDate>,</MTDateHeader><MTDateFooter>Footer:<MTEntryDate>,</MTDateFooter></MTEntries>"
  expected: "Header:January 31, 1978  7:45 AM,Footer:January 31, 1978  7:45 AM,Header:January 31, 1965  7:45 AM,Footer:January 31, 1965  7:45 AM,Header:January 31, 1964  7:45 AM,Footer:January 31, 1964  7:45 AM,"

-
  name: test item 553
  template: <MTEntries lastn='3'><MTEntriesHeader><ul></MTEntriesHeader><li><MTEntryTitle></li><MTEntriesFooter><ul></MTEntriesFooter></MTEntries>
  expected: <ul><li>A Rainy Day</li><li>Verse 5</li><li>Verse 4</li><ul>

-
  name: test item 554
  template: <MTEntries lastn="1"><MTEntryAdditionalCategories glue=','><MTCategoryLabel></MTEntryAdditionalCategories></MTEntries>
  expected: ''

-
  name: test item 555
  template: <MTEntries lastn="1"><MTEntryAuthorID></MTEntries>
  expected: 2

-
  name: test item 556
  template: <MTEntries lastn="1"><MTEntryAuthorUserpic></MTEntries>
  expected: <img src="/mt-static/support/assets_c/userpics/userpic-2-100x100.png?3" width="100" height="100" alt="" />

-
  name: test item 557
  template: <MTEntries lastn="1"><MTEntryAuthorUserpicAsset><MTAssetFilename></MTEntryAuthorUserpicAsset></MTEntries>
  expected: test.jpg

-
  name: test item 558
  template: <MTEntries lastn="1"><MTEntryAuthorUserpicURL></MTEntries>
  expected: /mt-static/support/assets_c/userpics/userpic-2-100x100.png

-
  name: test item 559
  template: <MTEntries lastn="1"><MTEntryBlogDescription></MTEntries>
  expected: Narnia None Test Blog

-
  name: test item 560
  template: <MTEntries lastn="1"><MTEntryBlogID></MTEntries>
  expected: 1

-
  name: test item 561
  template: <MTEntries lastn="1"><MTEntryBlogName></MTEntries>
  expected: none

-
  name: test item 562
  template: <MTEntries lastn="1"><MTEntryBlogURL></MTEntries>
  expected: "http://narnia.na/nana/"

-
  name: test item 563
  template: <MTEntries lastn="1"><MTEntryClassLabel lower_case='1'></MTEntries>
  expected: entry

-
  name: test item 564
  template: <MTEntries lastn="1"><MTEntryCreatedDate></MTEntries>
  expected: "January 31, 1978  7:45 AM"

-
  name: test item 565
  template: <MTEntries category="foo" lastn="1"><MTEntryIfCategory category='foo'><MTCategoryLabel></MTEntryIfCategory></MTEntries>
  expected: foo

-
  name: test item 566
  template: <MTEntries lastn="1"><MTEntryModifiedDate></MTEntries>
  expected: "January 31, 1978  7:46 AM"

-
  name: test item 604
  template: <MTEntries tags='@grandparent' lastn='1'><MTEntryTitle></MTEntries>
  expected: ''

-
  name: test item 611
  template: <MTEntries id="6"><MTEntryPrimaryCategory><MTCategoryLabel></MTEntryPrimaryCategory></MTEntries>
  expected: foo

-
  name: test item 612
  template: <MTEntries id="6"><MTEntryCategories type="primary"><MTCategoryLabel></MTEntryCategories></MTEntries>
  expected: foo

