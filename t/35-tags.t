#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 1
  template: ''
  expected: ''

-
  name: test item 2
  template: <MTCGIPath>
  expected: "http://narnia.na/cgi-bin/"

-
  name: test item 3
  template: <MTCGIRelativeURL>
  expected: /cgi-bin/

-
  name: test item 4
  template: <MTStaticWebPath>
  expected: "http://narnia.na/mt-static/"

-
  name: test item 5
  template: <MTCommentScript>
  expected: mt-comments.cgi

-
  name: test item 6
  template: <MTTrackbackScript>
  expected: mt-tb.cgi

-
  name: test item 7
  template: <MTSearchScript>
  expected: mt-search.cgi

-
  name: test item 8
  template: <MTXMLRPCScript>
  expected: mt-xmlrpc.cgi

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
  name: test item 14
  template: <MTPublishCharset lower_case='1'>
  expected: utf-8

-
  name: test item 15
  template: <MTIfNonEmpty tag="MTDate">nonempty</MTIfNonEmpty>
  expected: nonempty

-
  name: test item 16
  template: ''
  expected: ''

-
  name: test item 17
  template: <MTIfNonZero tag="MTBlogEntryCount">nonzero</MTIfNonZero>
  expected: nonzero

-
  name: test item 18
  template: <MTCommenterNameThunk>
  expected: <script type='text/javascript'>var commenter_name = getCookie('commenter_name')</script>

-
  name: test item 19
  run: 0
  template: <MTCommenterName>
  expected: ''

-
  name: test item 20
  run: 0
  template: <MTCommenterEmail>
  expected: ''

-
  name: test item 21
  template: <MTBlogs><MTBlogID></MTBlogs>
  expected: 1

-
  name: test item 22
  template: <MTBlogs><MTBlogName></MTBlogs>
  expected: none

-
  name: test item 23
  template: <MTBlogs><MTBlogDescription></MTBlogs>
  expected: Narnia None Test Blog

-
  name: test item 24
  template: <MTBlogs><MTBlogURL></MTBlogs>
  expected: "http://narnia.na/nana/"

-
  name: test item 25
  template: <MTBlogs><MTBlogArchiveURL></MTBlogs>
  expected: "http://narnia.na/nana/archives/"

-
  name: test item 26
  template: <MTBlogs><MTBlogRelativeURL></MTBlogs>
  expected: /nana/

-
  name: test item 27
  template: <MTBlogs><MTBlogSitePath></MTBlogs>
  expected: t/site/

-
  name: test item 28
  template: <MTBlogs><MTBlogHost></MTBlogs>
  expected: narnia.na

-
  name: test item 29
  template: <MTBlogs><MTBlogHost exclude_port="1"></MTBlogs>
  expected: narnia.na

-
  name: test item 30
  template: <MTBlogs><MTBlogTimezone></MTBlogs>
  expected: "-03:30"

-
  name: test item 31
  template: <MTBlogs><MTBlogTimezone no_colon="1"></MTBlogs>
  expected: -0330

-
  name: test item 32
  template: <MTBlogs><MTBlogEntryCount></MTBlogs>
  expected: 6

-
  name: test item 33
  template: <MTBlogs><MTBlogCommentCount></MTBlogs>
  expected: 9

-
  name: test item 34
  run: 0
  template: |-
    <MTBlogs><MTBlogIfCCLicense><MTBlogCCLicenseURL>
    <MTBlogCCLicenseImage>
    <MTCCLicenseRDF></MTBlogIfCCLicense></MTBlogs>
  expected: "http://creativecommons.org/licenses/by-nc-sa/2.0/\nhttp://creativecommons.org/images/public/somerights20.gif\n<!--\n<rdf:RDF xmlns=\"http://web.resource.org/cc/\"\n         xmlns:dc=\"http://purl.org/dc/elements/1.1/\"\n         xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"><\nWork rdf:about=\"http://narnia.na/nana/\">\n<dc:title>none</dc:title>\n<dc:description>Narnia None Test Blog</dc:description>\n<license rdf:resource=\"http://creativecommons.org/licenses/by-nc-sa/2.0/\" />\n</Work>\n<License rdf:about=\"http://creativecommons.org/licenses/by-nc-sa/2.0/\">\n</License>\n</rdf:RDF>\n-->\n"

-
  name: test item 35
  template: "<MTArchiveList archive_type=\"Monthly\"><MTArchiveListHeader>(Header)</MTArchiveListHeader><MTArchiveListFooter>(Footer)</MTArchiveListFooter><MTArchiveTitle>|</MTArchiveList>"
  expected: "(Header)January 1978|January 1965|January 1964|January 1963|January 1962|(Footer)January 1961|"

-
  name: test item 36
  template: <MTEntries lastn="10"> * <MTEntryTitle></MTEntries>
  expected: " * A Rainy Day * Verse 5 * Verse 4 * Verse 3 * Verse 2 * Verse 1"

-
  name: test item 37
  template: <MTInclude module="blog-name">
  expected: none

-
  name: test item 38
  run: 0
  template: <MTInclude module="blog-name">
  expected: none

-
  name: test item 39
  template: <MTEntries lastn='1'><MTLink entry_id="1"></MTEntries>
  expected: "http://narnia.na/nana/archives/1978/01/a-rainy-day.html"

-
  name: test item 40
  template: <MTLink template="Main Index">
  expected: "http://narnia.na/nana/"

-
  name: test item 41
  template: <MTVersion>
  expected: VERSION_ID

-
  name: test item 42
  template: <MTDefaultLanguage>
  expected: en_US

-
  name: test item 43
  template: <MTSignOnURL>
  expected: "https://www.typekey.com/t/typekey/login?"

-
  name: test item 44
  run: 0
  template: <MTErrorMessage>
  expected: ''

-
  name: test item 45
  template: <MTSetVar name="x" value="x-var"><MTGetVar name="x">
  expected: x-var

-
  name: test item 46
  template: <MTBlogLanguage>
  expected: en_us

-
  name: test item 47
  template: <MTBlogCCLicenseURL>
  expected: "http://creativecommons.org/licenses/by-nc-sa/2.0/"

-
  name: test item 48
  template: <MTBlogCCLicenseImage>
  expected: "http://creativecommons.org/images/public/somerights20.gif"

-
  name: test item 49
  template: <MTEntries lastn="1" offset="1"><MTCCLicenseRDF></MTEntries>
  expected: "<!--\n<rdf:RDF xmlns=\"http://web.resource.org/cc/\"\n         xmlns:dc=\"http://purl.org/dc/elements/1.1/\"\n         xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\">\n<Work rdf:about=\"http://narnia.na/nana/archives/1965/01/verse-5.html\">\n<dc:title>Verse 5</dc:title>\n<dc:description></dc:description>\n<dc:creator>Chucky Dee</dc:creator>\n<dc:date>1965-01-31T07:45:01-03:30</dc:date>\n<license rdf:resource=\"http://creativecommons.org/licenses/by-nc-sa/2.0/\" />\n</Work>\n<License rdf:about=\"http://creativecommons.org/licenses/by-nc-sa/2.0/\">\n</License>\n</rdf:RDF>\n-->\n"

-
  name: test item 50
  template: <MTBlogIfCCLicense>1</MTBlogIfCCLicense>
  expected: 1

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
  name: test item 74
  run: 0
  template: <MTTypeKeyToken>
  expected: token

-
  name: test item 75
  template: <MTEntries lastn="1"><MTRemoteSignInLink></MTEntries>
  expected: "https://www.typekey.com/t/typekey/login?&amp;lang=en_US&amp;t=token&amp;v=1.1&amp;_return=http://narnia.na/cgi-bin/mt-comments.cgi%3f__mode=handle_sign_in%26key=TypeKey%26static=0%26entry_id=1"

-
  name: test item 76
  template: <MTEntries lastn="1"><MTRemoteSignOutLink></MTEntries>
  expected: "http://narnia.na/cgi-bin/mt-comments.cgi?__mode=handle_sign_in&amp;static=0&amp;logout=1&amp;entry_id=1"

-
  name: test item 77
  run: 0
  template: <MTEntries lastn="1"></MTEntries>
  expected: ''

-
  name: test item 78
  template: <MTComments lastn="1"><MTCommentAuthor></MTComments>
  expected: John Doe

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
  name: test item 84
  template: <MTEntries lastn="1"><MTEntryTitle dirify="1"></MTEntries>
  expected: a_rainy_day

-
  name: test item 85
  template: <MTEntries lastn="1"><MTEntryTitle trim_to="6"></MTEntries>
  expected: A Rain

-
  name: test item 86
  template: <MTEntries lastn="1"><MTEntryTitle decode_html="1"></MTEntries>
  expected: A Rainy Day

-
  name: test item 87
  template: <MTEntries lastn="1"><MTEntryTitle decode_xml="1"></MTEntries>
  expected: A Rainy Day

-
  name: test item 88
  template: <MTEntries lastn="1"><MTEntryTitle remove_html="1"></MTEntries>
  expected: A Rainy Day

-
  name: test item 89
  template: <MTEntries lastn="1" sanitize="1"><h1><strong><MTEntryTitle></strong></h1></MTEntries>
  expected: <strong>A Rainy Day</strong>

-
  name: test item 90
  template: <MTEntries lastn="1" encode_html="1"><strong><MTEntryTitle></strong></MTEntries>
  expected: "&lt;strong&gt;A Rainy Day&lt;/strong&gt;"

-
  name: test item 91
  template: <MTEntries lastn="1" encode_xml="1"><strong><MTEntryTitle></strong></MTEntries>
  expected: <![CDATA[<strong>A Rainy Day</strong>]]>

-
  name: test item 92
  template: <MTEntries lastn="1" encode_js="1">"<MTEntryTitle>"</MTEntries>
  expected: \"A Rainy Day\"

-
  name: test item 93
  template: <MTEntries lastn="1" encode_php="1">'<MTEntryTitle>'</MTEntries>
  expected: \'A Rainy Day\'

-
  name: test item 94
  template: <MTEntries lastn="1"><MTEntryTitle encode_url="1"></MTEntries>
  expected: "A%20Rainy%20Day"

-
  name: test item 95
  template: <MTEntries lastn="1"><MTEntryTitle upper_case="1"></MTEntries>
  expected: A RAINY DAY

-
  name: test item 96
  template: <MTEntries lastn="1"><MTEntryTitle lower_case="1"></MTEntries>
  expected: a rainy day

-
  name: test item 97
  template: |-
    <MTEntries lastn="1" strip_linefeeds="1">
    <MTEntryTitle>
    </MTEntries>
  expected: A Rainy Day

-
  name: test item 98
  template: <MTEntries lastn="1"><MTEntryTitle space_pad="30"></MTEntries>
  expected: "                   A Rainy Day"

-
  name: test item 99
  template: <MTEntries lastn="1"><MTEntryTitle space_pad="-30"></MTEntries>
  expected: "A Rainy Day                   "

-
  name: test item 100
  template: <MTEntries lastn="1"><MTEntryTitle zero_pad="30"></MTEntries>
  expected: 0000000000000000000A Rainy Day

-
  name: test item 101
  template: "<MTEntries lastn=\"1\"><MTEntryTitle sprintf=\"%030s\"></MTEntries>"
  expected: 0000000000000000000A Rainy Day

-
  name: test item 102
  template: <MTCategories><MTCategoryLabel></MTCategories>
  expected: foosubfoo

-
  name: test item 103
  template: <MTCategories><MTCategoryID></MTCategories>
  expected: 13

-
  name: test item 104
  template: <MTCategories><MTCategoryDescription></MTCategories>
  expected: barsubcat

-
  name: test item 105
  run: 0
  template: ''
  expected: ''

-
  name: test item 106
  template: <MTEntries lastn="1"><MTEntryTrackbackID></MTEntries>
  expected: 1

-
  name: test item 107
  template: <MTEntries lastn="1"><MTEntryBasename></MTEntries>
  expected: a_rainy_day

-
  name: test item 108
  run: 0
  template: <MTCGIServerPath>
  expected: CURRENT_WORKING_DIRECTORY

-
  name: test item 109
  template: <MTComments lastn="1"><MTCommentBody></MTComments>
  expected: <p>Comment for entry 5, visible</p>

-
  name: test item 110
  template: <MTComments lastn="1"><MTCommentDate></MTComments>
  expected: "September 12, 2004  6:28 PM"

-
  name: test item 111
  template: <MTComments lastn="1"><MTCommentID></MTComments>
  expected: 2

-
  name: test item 112
  template: <MTComments lastn="1"><MTCommentEntryID></MTComments>
  expected: 5

-
  name: test item 113
  template: <MTComments lastn="1"><MTCommentIP></MTComments>
  expected: 127.0.0.1

-
  name: test item 114
  template: <MTComments lastn="3"><MTCommentAuthorLink>,</MTComments>
  expected: "<a title=\"http://chuckd.com/\" href=\"http://chuckd.com/\">Chucky Dee</a>,Comment 3,John Doe,"

-
  name: test item 115
  template: <MTComments lastn="1"><MTCommentEmail></MTComments>
  expected: johnd@doe.com

-
  name: test item 116
  template: <MTComments lastn="1"><MTCommentAuthorIdentity></MTComments>
  expected: "<img alt=\"\" src=\"http://narnia.na/mt-static/images/comment/typepad_logo.png\" width=\"16\" height=\"16\" />"

-
  name: test item 117
  template: <MTComments lastn="1"><MTCommentURL></MTComments>
  expected: "http://john.doe.com/"

-
  name: test item 118
  template: <MTComments lastn="1"><MTCommentOrderNumber></MTComments>
  expected: 1

-
  name: test item 119
  template: <MTComments lastn="1"><MTCommentEntry><MTEntryTitle></MTCommentEntry></MTComments>
  expected: Verse 2

-
  name: test item 120
  template: <MTPings lastn="1"><MTPingDate></MTPings>
  expected: "April  5, 2005 12:00 AM"

-
  name: test item 121
  template: <MTPings lastn="1"><MTPingID></MTPings>
  expected: 1

-
  name: test item 122
  template: <MTPings lastn="1"><MTPingTitle></MTPings>
  expected: Foo

-
  name: test item 123
  template: <MTPings lastn="1"><MTPingURL></MTPings>
  expected: "http://example.com/"

-
  name: test item 124
  template: <MTPings lastn="1"><MTPingExcerpt></MTPings>
  expected: Bar

-
  name: test item 125
  template: <MTPings lastn="1"><MTPingIP></MTPings>
  expected: 127.0.0.1

-
  name: test item 126
  template: <MTPings lastn="1"><MTPingBlogName></MTPings>
  expected: Example Blog

-
  name: test item 127
  template: "<MTCategories><MTCategoryLabel>: <MTCategoryCount>; </MTCategories>"
  expected: "foo: 1; subfoo: 1; "

-
  name: test item 128
  template: <MTCategories><MTCategoryArchiveLink>; </MTCategories>
  expected: "http://narnia.na/nana/archives/foo/; http://narnia.na/nana/archives/foo/subfoo/; "

-
  name: test item 129
  template: "<MTCategories show_empty=\"1\"><MTCategoryLabel>: <MTCategoryTrackbackLink> </MTCategories>"
  expected: "bar: http://narnia.na/cgi-bin/mt-tb.cgi/2 foo:  subfoo:  "

-
  name: test item 130
  template: <MTSubCategories show_empty="1" top="1"><MTCategoryLabel></MTSubCategories>
  expected: barfoo

-
  name: test item 131
  template: "<MTSubCategories show_empty=\"1\" top=\"1\"><MTSubCatIsFirst>First: <MTCategoryLabel></MTSubCatIsFirst></MTSubCategories>"
  expected: "First: bar"

-
  name: test item 132
  template: <MTSubCategories show_empty="1" top="1">[[<MTCategoryLabel><MTSubCatsRecurse>]]</MTSubCategories>
  expected: '[[bar]][[foo[[subfoo]]]]'

-
  name: test item 133
  template: "<MTSubCategories show_empty=\"1\" top=\"1\"><MTSubCatIsLast>Last: <MTCategoryLabel></MTSubCatIsLast></MTSubCategories>"
  expected: "Last: foo"

-
  name: test item 134
  template: <MTTopLevelCategories><MTCategoryLabel></MTTopLevelCategories>
  expected: barfoo

-
  name: test item 135
  template: <MTSubCategories show_empty="1" top="1"><MTHasParentCategory>Parent of <MTCategoryLabel> is <MTParentCategory><MTCategoryLabel></MTParentCategory></MTHasParentCategory><MTHasNoParentCategory><MTCategoryLabel> has no parent</MTHasNoParentCategory>; <MTSubCatsRecurse></MTSubCategories>
  expected: "bar has no parent; foo has no parent; Parent of subfoo is foo; "

-
  name: test item 136
  template: <MTTopLevelCategories show_empty="1"><MTCategoryLabel><MTHasSubCategories> (has subcategories)</MTHasSubCategories><MTHasNoSubCategories> (has no subcategories)</MTHasNoSubCategories></MTTopLevelCategories>
  expected: bar (has no subcategories)foo (has subcategories)

-
  name: test item 137
  template: <MTCategories show_empty="1"><MTSubCategoryPath>;</MTCategories>
  expected: bar;foo;foo/subfoo;

-
  name: test item 138
  template: <MTEntriesWithSubCategories category="foo"><MTEntryTitle>;</MTEntriesWithSubCategories>
  expected: Verse 4;Verse 3;

-
  name: test item 139
  template: <MTEntriesWithSubCategories category="foo/subfoo"><MTEntryTitle>;</MTEntriesWithSubCategories>
  expected: Verse 4;

-
  name: test item 140
  template: <MTPings lastn="1"><MTPingDate></MTPings>
  expected: "April  5, 2005 12:00 AM"

-
  name: test item 141
  template: <MTEntries lastn="1"><MTPingsSent><MTPingsSentURL>; </MTPingsSent></MTEntries>
  expected: "http://technorati.com/; "

-
  name: test item 142
  template: disabled
  expected: disabled

-
  name: test item 143
  template: <MTCategories show_empty="1"><MTIfIsAncestor child="subfoo"><MTCategoryLabel> is an ancestor to subfoo</MTIfIsAncestor></MTCategories>
  expected: foo is an ancestor to subfoosubfoo is an ancestor to subfoo

-
  name: test item 144
  template: <MTCategories show_empty="1"><MTIfIsDescendant parent="foo"><MTCategoryLabel> is a descendant of foo</MTIfIsDescendant></MTCategories>
  expected: foo is a descendant of foosubfoo is a descendant of foo

-
  name: test item 145
  template: "<MTCategories show_empty=\"1\"><MTCategoryLabel>'s top parent is: <MTTopLevelParent><MTCategoryLabel></MTTopLevelParent>; </MTCategories>"
  expected: "bar's top parent is: bar; foo's top parent is: foo; subfoo's top parent is: foo; "

-
  name: test item 146
  template: <MTEntries lastn="1"><MTEntryTitle lower_case="1"></MTEntries>
  expected: a rainy day

-
  name: test item 147
  template: <MTArchiveList archive_type="Monthly"><MTArchiveTitle>-<MTArchiveLink>; </MTArchiveList>
  expected: "January 1978-http://narnia.na/nana/archives/1978/01/; January 1965-http://narnia.na/nana/archives/1965/01/; January 1964-http://narnia.na/nana/archives/1964/01/; January 1963-http://narnia.na/nana/archives/1963/01/; January 1962-http://narnia.na/nana/archives/1962/01/; January 1961-http://narnia.na/nana/archives/1961/01/; "

-
  name: test item 148
  template: "Previous: <MTArchiveList archive_type=\"Monthly\"><MTArchivePrevious><MTArchiveTitle>-<MTArchiveLink>;</MTArchivePrevious> </MTArchiveList>"
  expected: "Previous: January 1965-http://narnia.na/nana/archives/1965/01/; January 1964-http://narnia.na/nana/archives/1964/01/; January 1963-http://narnia.na/nana/archives/1963/01/; January 1962-http://narnia.na/nana/archives/1962/01/; January 1961-http://narnia.na/nana/archives/1961/01/;  "

-
  name: test item 149
  template: "Next: <MTArchiveList archive_type=\"Monthly\"><MTArchiveNext><MTArchiveTitle>-<MTArchiveLink>;</MTArchiveNext> </MTArchiveList>"
  expected: "Next:  January 1978-http://narnia.na/nana/archives/1978/01/; January 1965-http://narnia.na/nana/archives/1965/01/; January 1964-http://narnia.na/nana/archives/1964/01/; January 1963-http://narnia.na/nana/archives/1963/01/; January 1962-http://narnia.na/nana/archives/1962/01/; "

-
  name: test item 150
  template: <MTArchiveList archive_type="Monthly"><MTArchiveTitle>-<MTArchiveCount>; </MTArchiveList>
  expected: "January 1978-1; January 1965-1; January 1964-1; January 1963-1; January 1962-1; January 1961-1; "

-
  name: test item 151
  template: <MTEntries lastn="1"><MTEntryCommentCount></MTEntries>
  expected: 3

-
  name: test item 152
  template: <MTComments lastn="1"><MTCommentBody sanitize=" "></MTComments>
  expected: Comment for entry 5, visible

-
  name: test item 153
  template: <MTComments lastn="1"><MTCommentID></MTComments>
  expected: 2

-
  name: test item 154
  template: <MTBlogLanguage locale="1">
  expected: en_US

-
  name: test item 155
  template: <MTEntries lastn="1"><MTIfCommentsActive>active</MTIfCommentsActive></MTEntries>
  expected: active

-
  name: test item 156
  template: <MTEntries lastn="1"><MTIfCommentsAccepted>accepted</MTIfCommentsAccepted></MTEntries>
  expected: accepted

-
  name: test item 157
  template: <MTEntries lastn="1" offset="1"><MTIfCommentsActive>active</MTIfCommentsActive></MTEntries>
  expected: active

-
  name: test item 158
  template: <MTEntries lastn="1" offset="1"><MTIfCommentsAccepted>accepted</MTIfCommentsAccepted></MTEntries>
  expected: accepted

-
  name: test item 159
  template: <MTEntries lastn="1" offset="2"><MTIfCommentsActive>active</MTIfCommentsActive></MTEntries>
  expected: active

-
  name: test item 160
  template: <MTEntries lastn="1" offset="2"><MTIfCommentsAccepted>accepted</MTIfCommentsAccepted></MTEntries>
  expected: accepted

-
  name: test item 161
  template: <MTEntries lastn="1" offset="3"><MTIfCommentsActive>active</MTIfCommentsActive></MTEntries>
  expected: active

-
  name: test item 162
  template: <MTEntries lastn="1" offset="3"><MTIfCommentsAccepted>accepted</MTIfCommentsAccepted></MTEntries>
  expected: accepted

-
  name: test item 163
  template: <MTEntries lastn="1" offset="4"><MTIfCommentsActive>active</MTIfCommentsActive></MTEntries>
  expected: active

-
  name: test item 164
  template: <MTEntries lastn="1" offset="4"><MTIfCommentsAccepted>accepted</MTIfCommentsAccepted></MTEntries>
  expected: ''

-
  name: test item 165
  template: <MTEntries lastn="1" offset="5"><MTIfCommentsActive>active</MTIfCommentsActive></MTEntries>
  expected: ''

-
  name: test item 166
  template: <MTEntries lastn="1" offset="5"><MTIfCommentsAccepted>accepted</MTIfCommentsAccepted></MTEntries>
  expected: ''

-
  name: test item 167
  template: <MTEntries lastn="10"><MTEntryID> <MTEntryCommentCount>; </MTEntries>
  expected: "1 3; 8 1; 7 0; 6 3; 5 1; 4 0; "

-
  name: test item 168
  template: <MTIfRegistrationNotRequired>yes<MTElse>no</MTElse></MTIfRegistrationNotRequired>
  expected: no

-
  name: test item 169
  template: <MTIfRegistrationRequired>yes<MTElse>no</MTElse></MTIfRegistrationRequired>
  expected: yes

-
  name: test item 170
  template: <MTBlogIfCommentsOpen>yes<MTElse>no</MTElse></MTBlogIfCommentsOpen>
  expected: yes

-
  name: test item 171
  template: <MTSetVar name="x" value="   abc   "><MTGetVar name="x" trim="1">
  expected: abc

-
  name: test item 172
  template: <MTSetVar name="x" value="   abc   "><MTGetVar name="x" ltrim="1">
  expected: "abc   "

-
  name: test item 173
  template: <MTSetVar name="x" value="   abc"><MTGetVar name="x" rtrim="1">
  expected: "   abc"

-
  name: test item 174
  template: <MTSetVar name="x" value="abc"><MTGetVar name="x" filters="__default__">
  expected: <p>abc</p>

-
  name: test item 175
  template: <MTIfStatic>1</MTIfStatic>
  expected: STATIC_CONSTANT

-
  name: test item 176
  template: <MTIfDynamic>1</MTIfDynamic>
  expected: DYNAMIC_CONSTANT

-
  name: test item 177
  template: <MTTags glue=","><MTTagName></MTTags>
  expected: anemones,grandpa,rain,strolling,verse

-
  name: test item 178
  template: <MTEntries lastn="1"><MTEntryTags glue=","><MTTagName></MTEntryTags></MTEntries>
  expected: grandpa,rain,strolling

-
  name: test item 179
  template: <MTEntries lastn="1"><MTEntryTags glue=","><MTTagID></MTEntryTags></MTEntries>
  expected: 1,2,3

-
  name: test item 180
  template: <MTEntries lastn="1"><MTEntryIfTagged>has tags</MTEntryIfTagged></MTEntries>
  expected: has tags

-
  name: test item 181
  template: <MTEntries lastn="1"><MTEntryIfTagged tag="grandpa">tagged</MTEntryIfTagged></MTEntries>
  expected: tagged

-
  name: test item 182
  template: <MTEntries lastn="1"><MTEntryTags glue=" "><MTTagSearchLink></MTEntryTags></MTEntries>
  expected: "http://narnia.na/cgi-bin/mt-search.cgi?IncludeBlogs=1&amp;tag=grandpa&amp;limit=20 http://narnia.na/cgi-bin/mt-search.cgi?IncludeBlogs=1&amp;tag=rain&amp;limit=20 http://narnia.na/cgi-bin/mt-search.cgi?IncludeBlogs=1&amp;tag=strolling&amp;limit=20"

-
  name: test item 183
  template: "<MTTags glue=':'><MTTagCount></MTTags>"
  expected: "2:1:4:1:5"

-
  name: test item 184
  template: <MTIfTypeKeyToken>tokened</MTIfTypeKeyToken>
  expected: tokened

-
  name: test item 185
  template: <MTIfCommentsModerated>moderated</MTIfCommentsModerated>
  expected: moderated

-
  name: test item 186
  template: <MTIfRegistrationAllowed>allowed</MTIfRegistrationAllowed>
  expected: allowed

-
  name: test item 187
  template: <MTIfArchiveTypeEnabled type="Category">enabled</MTIfArchiveTypeEnabled>
  expected: enabled

-
  name: test item 188
  template: "<MTEntries lastn=\"1\"><MTFileTemplate format=\"%y/%m/%d/%b\"></MTEntries>"
  expected: 1978/01/31/a_rainy_day

-
  name: test item 189
  template: <MTAdminCGIPath>
  expected: "http://narnia.na/cgi-bin/"

-
  name: test item 190
  template: <MTConfigFile>
  expected: CFG_FILE

-
  name: test item 191
  template: <MTAdminScript>
  expected: mt.cgi

-
  name: test item 192
  template: <MTAtomScript>
  expected: mt-atom.cgi

-
  name: test item 193
  template: <MTCGIHost>
  expected: narnia.na

-
  name: test item 194
  template: <MTBlogFileExtension>
  expected: .html

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
  name: test item 199
  template: <MTCategories show_empty="1" glue=","><MTCategoryLabel>-<MTCategoryNext show_empty="1"><MTCategoryLabel></MTCategoryNext></MTCategories>
  expected: bar-foo,foo-,subfoo-

-
  name: test item 200
  template: <MTCategories show_empty="1" glue=","><MTCategoryLabel>-<MTCategoryPrevious show_empty="1"><MTCategoryLabel></MTCategoryPrevious></MTCategories>
  expected: bar-,foo-bar,subfoo-

-
  name: test item 201
  template: <MTEntries lastn="1" offset="3"><MTIfCategory name="foo">in category</MTIfCategory></MTEntries>
  expected: in category

-
  name: test item 202
  template: ''
  expected: ''

-
  name: test item 203
  template: <MTIndexList><MTIndexName>-<MTIndexLink>-<MTIndexBasename>;</MTIndexList>
  expected: "Archive Index-http://narnia.na/nana/archives.html-index;Feed - Recent Entries-http://narnia.na/nana/atom.xml-index;JavaScript-http://narnia.na/nana/mt.js-index;Main Index-http://narnia.na/nana/-index;RSD-http://narnia.na/nana/rsd.xml-index;Stylesheet-http://narnia.na/nana/styles.css-index;"

-
  name: test item 204
  template: <MTIfNeedEmail>email needed</MTIfNeedEmail>
  expected: ''

-
  name: test item 205
  template: <MTIfAllowCommentHTML>comment html allowed</MTIfAllowCommentHTML>
  expected: comment html allowed

-
  name: test item 206
  template: <MTIfCommentsAllowed>comments allowed</MTIfCommentsAllowed>
  expected: comments allowed

-
  name: test item 207
  template: <MTEntries lastn='1'><MTIfPingsActive>pings active</MTIfPingsActive></MTEntries>
  expected: pings active

-
  name: test item 208
  template: <MTEntries lastn='1'><MTIfPingsAccepted>pings accepted</MTIfPingsAccepted></MTEntries>
  expected: pings accepted

-
  name: test item 209
  template: <MTEntries lastn='1'><MTIfPingsAllowed>pings allowed</MTIfPingsAllowed></MTEntries>
  expected: pings allowed

-
  name: test item 210
  run: 0
  template: <MTIfDynamicComments>dynamic comments<MTElse>static comments</MTElse></MTIfDynamicComments>
  expected: static comments

-
  name: test item 211
  template: <MTEntries lastn='1'><MTEntryIfAllowComments>entry allows comments</MTEntryIfAllowComments></MTEntries>
  expected: entry allows comments

-
  name: test item 212
  template: <MTEntries lastn='1'><MTEntryIfCommentsOpen>entry comments open</MTEntryIfCommentsOpen></MTEntries>
  expected: entry comments open

-
  name: test item 213
  template: <MTEntries lastn='1'><MTEntryIfAllowPings>entry allows pings</MTEntryIfAllowPings></MTEntries>
  expected: entry allows pings

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
  name: test item 217
  template: <MTArchiveList archive_type='Category'><MTArchiveCategory></MTArchiveList>
  expected: foosubfoo

-
  name: test item 218
  template: <MTArchiveList><MTArchiveFile></MTArchiveList>
  expected: a_rainy_day.htmlverse_5.htmlverse_4.htmlverse_3.htmlverse_2.htmlverse_1.html

-
  name: test item 219
  template: <MTArchives><MTArchiveType></MTArchives>
  expected: IndividualMonthlyWeeklyDailyCategoryPage

-
  name: test item 220
  template: <MTArchiveList archive_type='Monthly'><MTArchiveDateEnd></MTArchiveList>
  expected: "January 31, 1978 11:59 PMJanuary 31, 1965 11:59 PMJanuary 31, 1964 11:59 PMJanuary 31, 1963 11:59 PMJanuary 31, 1962 11:59 PMJanuary 31, 1961 11:59 PM"

-
  name: test item 221
  template: <MTArchiveList archive_type='Daily'><MTArchiveDateEnd></MTArchiveList>
  expected: "January 31, 1978 11:59 PMJanuary 31, 1965 11:59 PMJanuary 31, 1964 11:59 PMJanuary 31, 1963 11:59 PMJanuary 31, 1962 11:59 PMJanuary 31, 1961 11:59 PM"

-
  name: test item 222
  template: <MTArchiveList archive_type='Weekly'><MTArchiveDateEnd></MTArchiveList>
  expected: "February  4, 1978 11:59 PMFebruary  6, 1965 11:59 PMFebruary  1, 1964 11:59 PMFebruary  2, 1963 11:59 PMFebruary  3, 1962 11:59 PMFebruary  4, 1961 11:59 PM"

-
  name: test item 223
  template: <MTComments lastn='3'><MTFeedbackScore>,</MTComments>
  expected: 0,0,1.5,

-
  name: test item 224
  template: "<MTComments lastn='3' glue=','><MTIfNonEmpty tag='CommenterName'><MTCommenterName>: <MTCommenterIfTrusted>trusted<MTElse>untrusted</MTElse></MTCommenterIfTrusted><MTElse><MTCommentAuthor></MTIfNonEmpty></MTComments>"
  expected: "Chucky Dee: trusted,Comment 3: untrusted,John Doe: trusted"

-
  name: test item 225
  template: <MTTags glue=','><MTTagName> <MTTagRank></MTTags>
  expected: anemones 4,grandpa 6,rain 2,strolling 6,verse 1

-
  name: test item 226
  template: <MTEntries tag='grandpa' lastn='1'><MTEntryTags glue=','><MTTagRank></MTEntryTags></MTEntries>
  expected: 6,2,6

-
  name: test item 227
  template: <MTEntries tag='verse' lastn='1'><MTEntryTags glue=','><MTTagRank></MTEntryTags></MTEntries>
  expected: 2,1

-
  name: test item 228
  template: <MTEntries tags='grandpa' lastn='1'><MTEntryTitle></MTEntries>
  expected: A Rainy Day

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
  name: test item 233
  template: <MTSetVar name='x' value='0'><MTIfNonZero tag='GetVar' name='x'><MTElse>0</MTElse></MTIfNonZero>
  expected: 0

-
  name: test item 234
  template: <MTAsset id='1'><$MTAssetID$></MTAsset>
  expected: 1

-
  name: test item 235
  template: <MTAssets type='image'><$MTAssetID$></MTAssets>
  expected: 1

-
  name: test item 236
  template: <MTAssets type='file'><$MTAssetID$></MTAssets>
  expected: 2

-
  name: test item 237
  template: <MTAssets type='all'><$MTAssetID$></MTAssets>
  expected: ''

-
  name: test item 238
  template: <MTAssets file_ext='jpg'><$MTAssetID$></MTAssets>
  expected: 1

-
  name: test item 239
  template: <MTAssets file_ext='tmpl'><$MTAssetID$></MTAssets>
  expected: 2

-
  name: test item 240
  template: <MTAssets file_ext='dat'><$MTAssetID$></MTAssets>
  expected: ''

-
  name: test item 241
  template: <MTAssets lastn='1'><$MTAssetID$></MTAssets>
  expected: 1

-
  name: test item 242
  template: <MTAssets days='1'><$MTAssetID$>;</MTAssets>
  expected: 1;

-
  name: test item 243
  template: <MTAssets author='Chuck D'><$MTAssetID$></MTAssets>
  expected: ''

-
  name: test item 244
  template: <MTAssets author='Melody'><$MTAssetID$>;</MTAssets>
  expected: 1;2;

-
  name: test item 245
  template: <MTAssets limit='1' offset='1'><$MTAssetID$></MTAssets>
  expected: 2

-
  name: test item 246
  template: <MTAssets limit='1' offset='2'><$MTAssetID$></MTAssets>
  expected: ''

-
  name: test item 247
  template: <MTAssets tag='alpha'><$MTAssetID$></MTAssets>
  expected: 1

-
  name: test item 248
  template: <MTAssets sort_by='file_name'><$MTAssetID$>;</MTAssets>
  expected: 2;1;

-
  name: test item 249
  template: <MTAssets sort_order='ascend'><$MTAssetID$>;</MTAssets>
  expected: 2;1;

-
  name: test item 250
  template: <MTAssets lastn='1'><$MTAssetFileName$></MTAssets>
  expected: test.jpg

-
  name: test item 251
  template: <MTAssets lastn='1'><$MTAssetURL$></MTAssets>
  expected: "http://narnia.na/nana/images/test.jpg"

-
  name: test item 252
  template: <MTAssets lastn='1'><$MTAssetType$></MTAssets>
  expected: image

-
  name: test item 253
  template: <MTAssets lastn='1'><$MTAssetMimeType$></MTAssets>
  expected: image/jpeg

-
  name: test item 254
  template: <MTAssets lastn='1'><$MTAssetFilePath$></MTAssets>
  expected: CURRENT_WORKING_DIRECTORY/t/images/test.jpg

-
  name: test item 255
  template: <MTAssets limit='1' sort_order='ascend'><$MTAssetDateAdded$></MTAssets>
  expected: "January 31, 1978  7:45 AM"

-
  name: test item 256
  template: <MTAssets lastn='1'><$MTAssetAddedBy$></MTAssets>
  expected: Melody

-
  name: test item 257
  template: <MTAssets lastn='1'><$MTAssetProperty property='file_size'$></MTAssets>
  expected: 84.1 KB

-
  name: test item 258
  template: <MTAssets lastn='1'><$MTAssetProperty property='file_size' format='0'$></MTAssets>
  expected: 86094

-
  name: test item 259
  template: <MTAssets lastn='1'><$MTAssetProperty property='file_size' format='1'$></MTAssets>
  expected: 84.1 KB

-
  name: test item 260
  template: <MTAssets lastn='1'><$MTAssetProperty property='file_size' format='k'$></MTAssets>
  expected: 84.1

-
  name: test item 261
  template: <MTAssets lastn='1'><$MTAssetProperty property='file_size' format='m'$></MTAssets>
  expected: 0.1

-
  name: test item 262
  template: <MTAssets lastn='1' type='image'><$MTAssetProperty property='image_width'$></MTAssets>
  expected: 640

-
  name: test item 263
  template: <MTAssets lastn='1' type='image'><$MTAssetProperty property='image_height'$></MTAssets>
  expected: 480

-
  name: test item 264
  template: <MTAssets lastn='1' type='file'><$MTAssetProperty property='image_width'$></MTAssets>
  expected: 0

-
  name: test item 265
  template: <MTAssets lastn='1' type='file'><$MTAssetProperty property='image_height'$></MTAssets>
  expected: 0

-
  name: test item 266
  template: <MTAssets limit='1' sort_order='ascend'><$MTAssetProperty property='image_width'$></MTAssets>
  expected: 0

-
  name: test item 267
  template: <MTAssets limit='1' sort_order='ascend'><$MTAssetProperty property='image_height'$></MTAssets>
  expected: 0

-
  name: test item 268
  template: <MTAssets limit='1' sort_order='ascend'><$MTAssetProperty property='image_width'$></MTAssets>
  expected: 0

-
  name: test item 269
  template: <MTAssets limit='1' sort_order='ascend'><$MTAssetProperty property='image_height'$></MTAssets>
  expected: 0

-
  name: test item 270
  template: <MTAssets lastn='1'><$MTAssetProperty property='label'$></MTAssets>
  expected: Image photo

-
  name: test item 271
  template: <MTAssets lastn='1'><$MTAssetProperty property='description'$></MTAssets>
  expected: This is a test photo.

-
  name: test item 272
  template: <MTAssets lastn='1'><$MTAssetFileExt$></MTAssets>
  expected: jpg

-
  name: test item 273
  template: <MTAssets lastn='1'><$MTAssetThumbnailURL width='160'$></MTAssets>
  expected: "http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-160xauto-1.jpg"

-
  name: test item 274
  template: <MTAssets lastn='1'><$MTAssetThumbnailURL height='240'$></MTAssets>
  expected: "http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-autox240-1.jpg"

-
  name: test item 275
  template: <MTAssets lastn='1'><$MTAssetThumbnailURL scale='75'$></MTAssets>
  expected: "http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-480x360-1.jpg"

-
  name: test item 276
  template: <MTAssets lastn='1'><$MTAssetLink$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\">test.jpg</a>"

-
  name: test item 277
  template: <MTAssets lastn='1'><$MTAssetThumbnailLink$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg\" width=\"640\" height=\"480\" alt=\"\" /></a>"

-
  name: test item 278
  template: <MTAssets lastn='1'><$MTAssetThumbnailLink width='160'$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-160xauto-1.jpg\" width=\"160\" height=\"120\" alt=\"\" /></a>"

-
  name: test item 279
  template: <MTAssets lastn='1'><$MTAssetThumbnailLink height='240'$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-autox240-1.jpg\" width=\"320\" height=\"240\" alt=\"\" /></a>"

-
  name: test item 280
  template: <MTAssets lastn='1'><$MTAssetThumbnailLink scale='100'$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg\" width=\"640\" height=\"480\" alt=\"\" /></a>"

-
  name: test item 281
  template: <MTAssets lastn='1'><$MTAssetLink new_window='1'$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\" target=\"_blank\">test.jpg</a>"

-
  name: test item 282
  template: <MTAssets lastn='1'><$MTAssetThumbnailLink new_window='1'$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\" target=\"_blank\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg\" width=\"640\" height=\"480\" alt=\"\" /></a>"

-
  name: test item 283
  template: <MTAssets lastn='1'><$MTAssetThumbnailLink new_window='1' width='160'$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\" target=\"_blank\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-160xauto-1.jpg\" width=\"160\" height=\"120\" alt=\"\" /></a>"

-
  name: test item 284
  template: <MTAssets lastn='1'><$MTAssetThumbnailLink new_window='1' scale='100'$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\" target=\"_blank\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg\" width=\"640\" height=\"480\" alt=\"\" /></a>"

-
  name: test item 285
  template: <MTAssets lastn='1'><$MTAssetThumbnailLink new_window='1' scale='100'$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\" target=\"_blank\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg\" width=\"640\" height=\"480\" alt=\"\" /></a>"

-
  name: test item 286
  template: <$MTAssetCount$>
  expected: 2

-
  name: test item 287
  template: <MTAssets lastn='1'><MTAssetTags><$MTTagName$>; </MTAssetTags></MTAssets>
  expected: "alpha; beta; gamma; "

-
  name: test item 288
  template: <MTAssets><MTAssetsHeader>(Head)</MTAssetsHeader><$MTAssetID$>;<MTAssetsFooter>(Last)</MTAssetsFooter></MTAssets>
  expected: (Head)1;2;(Last)

-
  name: test item 289
  template: <MTEntries lastn="10"><MTIfNonZero tag="MTEntryScoreCount" namespace="unit test"><MTEntryID> <MTEntryScore namespace="unit test">; </MTIfNonZero></MTEntries>
  expected: "6 2; 5 12; 4 5; "

-
  name: test item 290
  template: <MTEntries lastn="10"><MTIfNonZero tag="MTEntryScoreCount" namespace="unit test"><MTEntryID> <MTEntryScoreHigh namespace="unit test">; </MTIfNonZero></MTEntries>
  expected: "6 1; 5 5; 4 3; "

-
  name: test item 291
  template: <MTEntries lastn="10"><MTIfNonZero tag="MTEntryScoreCount" namespace="unit test"><MTEntryID> <MTEntryScoreLow namespace="unit test">; </MTIfNonZero></MTEntries>
  expected: "6 1; 5 3; 4 2; "

-
  name: test item 292
  template: <MTEntries lastn="10"><MTIfNonZero tag="MTEntryScoreCount" namespace="unit test"><MTEntryID> <MTEntryScoreAvg namespace="unit test">; </MTIfNonZero></MTEntries>
  expected: "6 1.00; 5 4.00; 4 2.50; "

-
  name: test item 293
  template: <MTEntries lastn="10"><MTIfNonZero tag="MTEntryScoreCount" namespace="unit test"><MTEntryID> <MTEntryScoreCount namespace="unit test">; </MTIfNonZero></MTEntries>
  expected: "6 2; 5 3; 4 2; "

-
  name: test item 294
  template: <MTEntries lastn="10"><MTIfNonZero tag="MTEntryScoreCount" namespace="unit test"><MTEntryID> <MTEntryRank namespace="unit test">; </MTIfNonZero></MTEntries>
  expected: "6 6; 5 1; 4 4; "

-
  name: test item 295
  template: <MTEntries lastn="10"><MTIfNonZero tag="MTEntryScoreCount" namespace="unit test"><MTEntryID> <MTEntryRank max="10" namespace="unit test">; </MTIfNonZero></MTEntries>
  expected: "6 10; 5 1; 4 5; "

-
  name: test item 296
  template: <MTEntries glue="; " sort_by="score" namespace="unit test" min_score="1"><MTEntryID>-<MTEntryScore namespace="unit test"></MTEntries>
  expected: 5-12; 4-5; 6-2

-
  name: test item 297
  template: <MTAssets lastn="10"><MTIfNonZero tag="MTAssetScoreCount" namespace="unit test"><MTAssetID> <MTAssetScore namespace="unit test">; </MTIfNonZero></MTAssets>
  expected: "1 12; 2 5; "

-
  name: test item 298
  template: <MTAssets lastn="10"><MTIfNonZero tag="MTAssetScoreCount" namespace="unit test"><MTAssetID> <MTAssetScoreHigh namespace="unit test">; </MTIfNonZero></MTAssets>
  expected: "1 5; 2 3; "

-
  name: test item 299
  template: <MTAssets lastn="10"><MTIfNonZero tag="MTAssetScoreCount" namespace="unit test"><MTAssetID> <MTAssetScoreLow namespace="unit test">; </MTIfNonZero></MTAssets>
  expected: "1 3; 2 2; "

-
  name: test item 300
  template: <MTAssets lastn="10"><MTIfNonZero tag="MTAssetScoreCount" namespace="unit test"><MTAssetID> <MTAssetScoreAvg namespace="unit test">; </MTIfNonZero></MTAssets>
  expected: "1 4.00; 2 2.50; "

-
  name: test item 301
  template: <MTAssets lastn="10"><MTIfNonZero tag="MTAssetScoreCount" namespace="unit test"><MTAssetID> <MTAssetScoreCount namespace="unit test">; </MTIfNonZero></MTAssets>
  expected: "1 3; 2 2; "

-
  name: test item 302
  template: <MTAssets lastn="10"><MTIfNonZero tag="MTAssetScoreCount" namespace="unit test"><MTAssetID> <MTAssetRank namespace="unit test">; </MTIfNonZero></MTAssets>
  expected: "1 1; 2 6; "

-
  name: test item 303
  template: <MTAssets lastn="10"><MTIfNonZero tag="MTAssetScoreCount" namespace="unit test"><MTAssetID> <MTAssetRank max="10" namespace="unit test">; </MTIfNonZero></MTAssets>
  expected: "1 1; 2 10; "

-
  name: test item 304
  template: <MTAssets sort_by="score" namespace="unit test"><MTAssetID>; </MTAssets>
  expected: "1; 2; "

-
  name: test item 305
  template: <MTTags glue=","><MTTagLabel></MTTags>
  expected: anemones,grandpa,rain,strolling,verse

-
  name: test item 306
  template: <MTEntries lastn="1"><MTEntryTags glue=","><MTTagLabel></MTEntryTags></MTEntries>
  expected: grandpa,rain,strolling

-
  name: test item 307
  template: <MTTags glue=','><MTTagLabel> <MTTagRank></MTTags>
  expected: anemones 4,grandpa 6,rain 2,strolling 6,verse 1

-
  name: test item 308
  template: <MTAssets lastn='1'><MTAssetTags><$MTTagLabel$>; </MTAssetTags></MTAssets>
  expected: "alpha; beta; gamma; "

-
  name: test item 309
  template: <MTComments><MTIfCommentParent><p><MTCommentParent><MTCommentAuthor></MTCommentParent></p></MTIfCommentParent></MTComments>
  expected: <p>Comment 11</p><p>v14GrUH 4 cheep</p>

-
  name: test item 310
  template: <MTComments sort_by='id' sort_order='ascend'><MTIfCommentReplies>,<MTCommentReplies><MTCommentsHeader><ul></MTCommentsHeader><li><MTCommentID></li><MTCommentsFooter></ul></MTCommentsFooter></MTCommentReplies></MTIfCommentReplies></MTComments>
  expected: ,<ul><li>11</li></ul>,<ul><li>12</li></ul>

-
  name: test item 311
  template: <MTComments sort_by='id' sort_order='ascend'><MTIfCommentReplies>,<MTCommentReplies><MTCommentsHeader><ul></MTCommentsHeader><li><MTCommentID><MTCommentRepliesRecurse></li><MTCommentsFooter></ul></MTCommentsFooter></MTCommentReplies></MTIfCommentReplies></MTComments>
  expected: ,<ul><li>11<ul><li>12</li></ul></li></ul>,<ul><li>12</li></ul>

-
  name: test item 312
  template: <MTPages><MTPageID>;</MTPages>
  expected: 23;22;21;20;

-
  name: test item 313
  template: <MTPages lastn='1'><MTPageID>;</MTPages>
  expected: 23;

-
  name: test item 314
  template: <MTPages lastn='1' offset='1'><MTPageID>;</MTPages>
  expected: 22;

-
  name: test item 315
  template: <MTPages folder='info'><MTPageID>;</MTPages>
  expected: 21;

-
  name: test item 316
  template: <MTPages folder='download' include_subfolders='1'><MTPageID>;</MTPages>
  expected: 23;22;

-
  name: test item 317
  template: <MTPages tag='river'><MTPageID>;</MTPages>
  expected: 20;

-
  name: test item 318
  template: <MTPages id='20'><MTPageID>;</MTPages>
  expected: 20;

-
  name: test item 319
  template: <MTPages sort_by='created_on' sort_order='scend'><MTPageID>;</MTPages>
  expected: 23;22;21;20;

-
  name: test item 320
  template: <MTPages id='21'><MTPageFolder><MTFolderID></MTPageFolder></MTPages>
  expected: 20

-
  name: test item 321
  template: <MTPages id='20'><MTPageTags><MTTagName>;</MTPageTags></MTPages>
  expected: flow;river;watch;

-
  name: test item 322
  template: <MTPages id='20'><MTPageTitle></MTPages>
  expected: Watching the River Flow

-
  name: test item 323
  template: <MTPages id='20'><MTPageBody></MTPages>
  expected: <p>What the matter with me,</p>

-
  name: test item 324
  template: <MTPages id='20'><MTPageDate format_name='rfc822'></MTPages>
  expected: "Tue, 31 Jan 1978 07:45:00 -0330"

-
  name: test item 325
  template: <MTPages id='20'><MTPageModifiedDate format_name='rfc822'></MTPages>
  expected: "Tue, 31 Jan 1978 07:46:00 -0330"

-
  name: test item 326
  template: <MTPages id='20'><MTPageAuthorDisplayName></MTPages>
  expected: Chucky Dee

-
  name: test item 327
  template: <MTPages id='20'><MTPageKeywords></MTPages>
  expected: no folder

-
  name: test item 328
  template: <MTPages id='20'><MTPageBasename></MTPages>
  expected: watching_the_river_flow

-
  name: test item 329
  template: <MTPages id='20'><MTPagePermalink></MTPages>
  expected: "http://narnia.na/nana/watching-the-river-flow.html"

-
  name: test item 330
  template: <MTPages id='20'><MTPageAuthorEmail></MTPages>
  expected: chuckd@example.com

-
  name: test item 331
  template: <MTPages id='20'><MTPageAuthorLink></MTPages>
  expected: "<a href=\"http://chuckd.com/\">Chucky Dee</a>"

-
  name: test item 332
  template: <MTPages id='20'><MTPageAuthorURL></MTPages>
  expected: "http://chuckd.com/"

-
  name: test item 333
  template: <MTPages id='20'><MTPageExcerpt></MTPages>
  expected: excerpt

-
  name: test item 334
  template: <MTBlogPageCount>
  expected: 4

-
  name: test item 335
  template: <MTFolders><MTFolderID>;</MTFolders>
  expected: 21;20;22;

-
  name: test item 336
  template: <MTFolders><MTSubFolders><MTFolderID></MTSubFolders></MTFolders>
  expected: 22

-
  name: test item 337
  template: <MTFolders><MTSubFolders><MTParentFolders><MTFolderID>;</MTParentFolders></MTSubFolders></MTFolders>
  expected: 21;22;

-
  name: test item 338
  template: <MTTopLevelFolders><MTFolderID>;</MTTopLevelFolders>
  expected: 21;20;

-
  name: test item 339
  template: <MTFolders><MTFolderBasename>;</MTFolders>
  expected: download;info;nightly;

-
  name: test item 340
  template: <MTFolders><MTFolderCount>;</MTFolders>
  expected: 1;1;1;

-
  name: test item 341
  template: <MTFolders><MTFolderDescription>;</MTFolders>
  expected: download top;information;nightly build;

-
  name: test item 342
  template: <MTFolders><MTFolderLabel>;</MTFolders>
  expected: download;info;nightly;

-
  name: test item 343
  template: <MTFolders><MTFolderPath>;</MTFolders>
  expected: download;info;download/nightly;

-
  name: test item 344
  template: <MTComments><MTCommentEntry><MTEntryClass>;</MTCommentEntry></MTComments>
  expected: page;entry;entry;entry;entry;entry;entry;entry;entry;

-
  name: test item 345
  template: <MTPings><MTPingEntry><MTEntryClass>;</MTPingEntry></MTPings>
  expected: page;entry;

-
  name: test item 346
  template: "<MTArchiveList archive_type='Individual' sort_order='ascend'><$MTArchiveDate format='%Y.%m.%d.%H.%M.%S'$>;</MTArchiveList>"
  expected: 1961.01.31.07.45.01;1962.01.31.07.45.01;1963.01.31.07.45.01;1964.01.31.07.45.01;1965.01.31.07.45.01;1978.01.31.07.45.00;

-
  name: test item 347
  template: <MTAuthors lastn="2"><MTAuthorID>;</MTAuthors>
  expected: 2;3;

-
  name: test item 348
  template: <MTAuthors sort_by='name'><MTAuthorName>;</MTAuthors>
  expected: Bob D;Chuck D;

-
  name: test item 349
  template: <MTAuthors sort_by='nickname'><MTAuthorDisplayName>;</MTAuthors>
  expected: Chucky Dee;Dylan;

-
  name: test item 350
  template: <MTAuthors sort_by='email'><MTAuthorEmail>;</MTAuthors>
  expected: bobd@example.com;chuckd@example.com;

-
  name: test item 351
  template: <MTAuthors sort_by='url'><MTAuthorURL>;</MTAuthors>
  expected: ";http://chuckd.com/;"

-
  name: test item 352
  template: <MTAuthors username='Chuck D'><MTAuthorName>;<MTAuthorDisplayName>;<MTAuthorEmail>;<MTAuthorURL>;</MTAuthors>
  expected: "Chuck D;Chucky Dee;chuckd@example.com;http://chuckd.com/;"

-
  name: test item 353
  run: 0
  template: <MTArchiveList type='Monthly'><MTPages><MTPageTitle></MTPages></MTArchiveList>
  expected: Watching the River Flow

-
  name: test item 354
  template: <MTAuthors sort_by='display_name' sort_order='descend'><MTAuthorID>;</MTAuthors>
  expected: 3;2;

-
  name: test item 355
  template: <MTArchives><MTArchiveLabel></MTArchives>
  expected: EntryMonthlyWeeklyDailyCategoryPage

-
  name: test item 356
  template: "<MTEntries><$MTEntryID$>:<MTComments><MTIfCommenterIsAuthor><MTIfCommenterIsEntryAuthor>2<MTElse>1</MTIfCommenterIsEntryAuthor><MTElse>0</MTIfCommenterIsAuthor>;</MTComments></MTEntries>"
  expected: "1:0;0;0;8:0;7:6:2;1;0;5:0;4:"

-
  name: test item 357
  template: <MTPages id='20'><$MTPageMore$></MTPages>
  expected: <p>I don't have much to say,</p>

-
  name: test item 358
  template: <MTAssets lastn='1'><$MTAssetlabel$></MTAssets>
  expected: Image photo

-
  name: test item 359
  template: <MTEntries id='1'><MTEntryAssets><$MTAssetID$></MTEntryAssets></MTEntries>
  expected: 1

-
  name: test item 360
  template: <MTPages id='20'><MTPageAssets><$MTAssetID$></MTPageAssets></MTPages>
  expected: 2

-
  name: test item 361
  template: "<MTAuthors><$MTAuthorAuthType$>:<$MTAuthorAuthIconURL$>;</MTAuthors>"
  expected: "MT:http://narnia.na/mt-static/images/comment/mt_logo.png;MT:http://narnia.na/mt-static/images/comment/mt_logo.png;"

-
  name: test item 362
  template: "<MTComments><$MTCommenterAuthType$>:<$MTCommenterAuthIconURL$>;</MTComments>"
  expected: ":;:;:;:;:;MT:http://narnia.na/mt-static/images/comment/mt_logo.png;MT:http://narnia.na/mt-static/images/comment/mt_logo.png;:;TypeKey:http://narnia.na/mt-static/images/comment/typepad_logo.png;"

-
  name: test item 363
  template: <MTAuthors need_entry='0' ><MTAuthorName>;</MTAuthors>
  expected: Chuck D;Bob D;Melody;

-
  name: test item 364
  template: <MTAuthors need_entry='0' status='disabled'><MTAuthorName>;</MTAuthors>
  expected: Hiro Nakamura;

-
  name: test item 365
  template: <MTAuthors need_entry='0' status='enabled or disabled'><MTAuthorName>;</MTAuthors>
  expected: Chuck D;Bob D;Hiro Nakamura;Melody;

-
  name: test item 366
  template: <MTAuthors need_entry='0' role='Author'><MTAuthorName>;</MTAuthors>
  expected: Bob D;

-
  name: test item 367
  template: <MTAuthors need_entry='0' role='Author or Designer'><MTAuthorName>;</MTAuthors>
  expected: Bob D;

-
  name: test item 368
  template: <MTSetVar name='offices' value='San Francisco' index='0'><MTSetVar name='offices' value='Tokyo' function='unshift'><MTSetVarBlock name='offices' index='2'>Paris</MTSetVarBlock>--<MTGetVar name='offices' function='count'>;<MTGetVar name='offices' index='1'>;<MTGetVar name='offices' function='shift'>;<MTGetVar name='offices' function='count'>;<MTGetVar name='offices' index='1'>
  expected: --3;San Francisco;Tokyo;2;Paris

-
  name: test item 369
  template: <MTSetVar name='MTVersions' key='4.0' value='Athena'><MTSetVarBlock name='MTVersions' key='4.01'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions' key='4.1'>Boomer<MTSetVar name='4.2' value='Cal'></MTSetVarBlock><MTGetVar name='MTVersions' key='4.0'>;<MTGetVar name='MTVersions' key='4.01'>;<MTGetVar name='MTVersions' key='4.1'>;<MTGetVar name='MTVersions' key='4.2'>;
  expected: Athena;Enterprise Solution;Boomer;;

-
  name: test item 370
  template: <MTVar name='object1' key='name' value='foo'><MTVar name='object1' key='price' value='1.00'><MTVar name='object2' key='name' value='bar'><MTVar name='object2' key='price' value='1.13'><MTSetVar name='array1' function='push' value='$object1'><MTSetVar name='array1' function='push' value='$object2'><MTLoop name='array1'><MTVar name='name'>(<MTVar name='price'>)<br /></MTLoop>
  expected: foo(1.00)<br />bar(1.13)<br />

-
  name: test item 371
  template: <MTSetVar name='offices1' value='San Francisco' index='0'><MTSetVar name='offices1' value='Tokyo' function='unshift'><MTSetVarBlock name='offices1' index='2'>Paris</MTSetVarBlock>--<MTGetVar name='offices1' function='count'>;<MTGetVar name='offices1' index='1'>;<MTGetVar name='offices1' function='shift'>;<MTGetVar name='offices1' function='count'>;<MTGetVar name='offices1' index='1'>
  expected: --3;San Francisco;Tokyo;2;Paris

-
  name: test item 372
  template: <MTSetVar name='offices2' value='San Francisco' index='0'><MTSetVar name='offices2' value='Tokyo' function='unshift'><MTSetVarBlock name='offices2' index='2'>Paris</MTSetVarBlock>--<MTSetVarBlock name='count'><MTGetVar name='offices2' function='count' op='sub' value='1'></MTSetVarBlock><MTFor from='0' to='$count' step='1' glue=','><MTGetVar name='offices2' index='$__index__'></MTFor>
  expected: --Tokyo,San Francisco,Paris

-
  name: test item 373
  template: <MTSetHashVar name='MTVersions2'><MTSetVar name='4.0' value='Athena'><MTSetVarBlock name='4.01'>Enterprise Solution</MTSetVarBlock><MTSetVar name='4.1' value='Boomer'><MTVar name='4.2' value='Cal'></MTSetHashVar>--<MTLoop name='MTVersions2' sort_by='value'><MTVar name='__key__'> - <MTVar name='__value__'>;</MTLoop>
  expected: --4.0 - Athena;4.1 - Boomer;4.2 - Cal;4.01 - Enterprise Solution;

-
  name: test item 374
  template: <MTSetHashVar name='MTVersions3'><MTSetVar name='4.0' value='Athena'><MTSetVarBlock name='4.01'>Enterprise Solution</MTSetVarBlock><MTSetVar name='4.1' value='Boomer'></MTSetHashVar><MTVar name='MTVersions3' key='4.2' value='Cal'>--<MTLoop name='MTVersions3' sort_by='key'><MTVar name='__key__'> - <MTVar name='__value__'>;</MTLoop>
  expected: --4.0 - Athena;4.01 - Enterprise Solution;4.1 - Boomer;4.2 - Cal;

-
  name: test item 375
  template: <MTSetVar name='offices3' value='San Francisco' index='0'><MTSetVar name='offices3' value='Tokyo' function='unshift'><MTSetVarBlock name='offices3' index='2'>Paris</MTSetVarBlock>--<MTLoop name='offices3' glue=','><MTVar name='__value__'></MTLoop>
  expected: --Tokyo,San Francisco,Paris

-
  name: test item 376
  template: <MTSetVar name='offices4' value='San Francisco' index='0'><MTSetVar name='offices4' value='Tokyo' function='unshift'><MTSetVarBlock name='offices4' index='2'>Paris</MTSetVarBlock>--<MTLoop name='offices4' glue=',' sort_by='value'><MTVar name='__value__'></MTLoop>
  expected: --Paris,San Francisco,Tokyo

-
  name: test item 377
  template: "<MTSetVar name='num' op='add' value='99'><MTGetVar name='num'>;<MTGetVar name='num' value='1' op='+'>;<MTSetVar name='num' value='1'><MTGetVar name='num'>;<MTGetVar name='num' value='20' op='mul'>;<MTSetVar name='num' value='2' op='add'><MTGetVar name='num'>;<MTGetVar name='num' value='20' op='*'>;<MTSetVar name='num' value='3' op='*'><MTGetVar name='num'>;<MTGetVar name='num' value='3' op='/'>;<MTSetVar name='num' op='div' value='2'><MTGetVar name='num'>;<MTGetVar name='num' value='0.5' op='-'>;<MTSetVar name='num' op='mod' value='6'><MTGetVar name='num'>;<MTGetVar name='num' value='3' op='%'>;"
  expected: 99;100;1;20;3;60;9;3;4.5;4;4;1;

-
  name: test item 378
  template: <MTSetVar name='num' value='1'><MTGetVar name='num' op='++'>;<MTSetVar name='num' op='inc'><MTGetVar name='num'>;<MTSetVar name='num' op='dec'><MTGetVar name='num'>;<MTGetVar name='num' op='--'>;
  expected: 2;2;1;0;

-
  name: test item 379
  template: <MTSetVar name='offices9[0]' value='San Francisco'><MTSetVar name='unshift(offices9)' value='Tokyo'><MTSetVarBlock name='offices9[2]'>Paris</MTSetVarBlock>--<MTGetVar name='count(offices9)'>;<MTGetVar name='offices9[1]'>;<MTGetVar name='shift(offices9)'>;<MTGetVar name='count(offices9)'>;<MTGetVar name='offices9' index='1'>
  expected: --3;San Francisco;Tokyo;2;Paris

-
  name: test item 380
  template: <MTSetVar name='MTVersions4{4.0}' value='Athena'><MTSetVarBlock name='MTVersions4{4.01}'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions4{4.1}'>Boomer<MTSetVar name='4.2' value='Cal'></MTSetVarBlock><MTGetVar name='MTVersions4{4.0}'>;<MTGetVar name='MTVersions4{4.01}'>;<MTGetVar name='MTVersions4{4.1}'>;<MTGetVar name='MTVersions4{4.2}'>;
  expected: Athena;Enterprise Solution;Boomer;;

-
  name: test item 381
  template: <MTVar name='object3{name}' value='foo'><MTVar name='object3{price}' value='1.00'><MTVar name='object4{name}' value='bar'><MTVar name='object4{price}' value='1.13'><MTSetVar name='push(array2)' value='$object3'><MTSetVar name='push(array2)' value='$object4'><MTLoop name='array2'><MTVar name='name'>(<MTVar name='price'>)<br /></MTLoop>
  expected: foo(1.00)<br />bar(1.13)<br />

-
  name: test item 382
  template: <MTSetVar name='offices5[0]' value='San Francisco'><MTSetVar name='unshift(offices5)' value='Tokyo'><MTSetVarBlock name='offices5[2]'>Paris</MTSetVarBlock>--<MTGetVar name='count(offices5)'>;<MTGetVar name='offices5[1]'>;<MTGetVar name='shift(offices5)'>;<MTGetVar name='count(offices5)'>;<MTGetVar name='offices5[1]'>
  expected: --3;San Francisco;Tokyo;2;Paris

-
  name: test item 383
  template: <MTSetVar name='offices6[0]' value='San Francisco'><MTSetVar name='unshift(offices6)' value='Tokyo'><MTSetVarBlock name='offices6[2]'>Paris</MTSetVarBlock>--<MTSetVarBlock name='count'><MTGetVar name='count(offices6)' op='--'></MTSetVarBlock><MTFor from='0' to='$count' increment='1' glue=','><MTGetVar name='offices6[$__index__]'></MTFor>
  expected: --Tokyo,San Francisco,Paris

-
  name: test item 384
  template: <MTSetVar name='MTVersions5{4.0}' value='Athena'><MTSetVarBlock name='MTVersions5{4.01}'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions5{4.1}'>Boomer</MTSetVarBlock><MTSetHashVar name='MTVersions5'><MTSetVar name='4.2' value='Cal'></MTSetHashVar>--<MTLoop name='MTVersions5' sort_by='key reverse'><MTVar name='__key__'> - <MTVar name='__value__'>;</MTLoop>
  expected: --4.2 - Cal;4.1 - Boomer;4.01 - Enterprise Solution;4.0 - Athena;

-
  name: test item 385
  template: <MTSetVar name='MTVersions6{4.0}' value='Athena'><MTSetVarBlock name='MTVersions6{4.01}'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions6{4.1}'>Boomer<MTSetVar name='4.2' value='Cal'></MTSetVarBlock>--<MTLoop name='MTVersions6' sort_by='key'><MTVar name='__key__'> - <MTVar name='__value__'>;</MTLoop>
  expected: --4.0 - Athena;4.01 - Enterprise Solution;4.1 - Boomer;

-
  name: test item 386
  template: <MTSetVar name='offices7' value='San Francisco' index='0'><MTSetVar name='unshift(offices7)' value='Tokyo'><MTSetVarBlock name='offices7' index='2'>Paris</MTSetVarBlock>--<MTVar name='offices7[1]'>,<MTVar name='shift(offices7)'>,<MTSetVar name='i' value='1'><MTVar name='offices7[$i]'>
  expected: --San Francisco,Tokyo,Paris

-
  name: test item 387
  template: <MTSetVar name='offices8' value='San Francisco' index='0'><MTSetVar name='unshift(offices8)' value='Tokyo'><MTSetVarBlock name='offices8' index='2'>Paris</MTSetVarBlock><MTSetVar name='var_offices' value='$offices8'>--<MTVar name='var_offices[1]'>,<MTVar name='shift(var_offices)'>,<MTSetVar name='i' value='1'><MTVar name='var_offices[$i]'>
  expected: --San Francisco,Tokyo,Paris

-
  name: test item 388
  template: <MTSetVar name='MTVersions7' key='4.0' value='Athena'><MTSetVarBlock name='MTVersions7' key='4.01'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions7' key='4.1'>Boomer<MTSetVar name='4.2' value='Cal'></MTSetVarBlock><MTSetVar name='var_hash' value='$MTVersions7'><MTGetVar name='var_hash{4.0}'>;<MTGetVar name='var_hash{4.01}'>;<MTGetVar name='var_hash{4.1}'>;<MTGetVar name='var_hash{4.2}'>;
  expected: Athena;Enterprise Solution;Boomer;;

-
  name: test item 389
  template: <MTSetVar name='MTVersions8' key='4.0' value='Athena'><MTSetVarBlock name='MTVersions8' key='4.01'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions8' key='4.1'>Boomer</MTSetVarBlock><MTSetHashVar name='MTVersions8'><MTSetVarBlock name='4.2'>Cal</MTSetVarBlock></MTSetHashVar><MTGetVar name='delete(MTVersions8{4.0})'>;<MTGetVar name='MTVersions8{4.0}'>;<MTSetVar name='delete(MTVersions8{4.01})'>;<MTGetVar name='MTVersions8{4.01}'>;<MTGetVar name='MTVersions8' function='delete' key='4.2'>;<MTGetVar name='MTVersions8' function='delete' key='4.1'>;<MTGetVar name='MTVersions8' key='4.1'>;
  expected: Athena;;;;Cal;Boomer;;

-
  name: test item 390
  template: <MTSetVar name='offices9' value='San Francisco' index='0'><MTSetVar name='unshift(offices9)' value='Tokyo'><MTSetVarBlock name='offices9' index='2'>Paris</MTSetVarBlock>--<MTIf name='offices9' index='2' eq='Paris'>TRUE<MTElse>FALSE</MTIf>,<MTIf name='offices9[1]' eq='San Francisco'>TRUE<MTElse>FALSE</MTIf>,<MTVar name='idx' value='0'><MTIf name='offices9[$idx]' eq='San Francisco'><MTVar name='offices9[0]'><MTElse name='offices9[2]' eq='San Francisco'>TRUE<MTElse>FALSE</MTIf>,<MTIf name='offices9' index='3' eq='1'><MTIgnore>value is undef so it is always evaluated false.</MTIgnore>TRUE<MTElse>FALSE</MTIf>,
  expected: --TRUE,TRUE,FALSE,FALSE,

-
  name: test item 391
  template: <MTSetVar name='MTVersions8' key='4.0' value='Athena'><MTSetVarBlock name='MTVersions8' key='4.01'>Enterprise Solution</MTSetVarBlock><MTSetVarBlock name='MTVersions8' key='4.1'>Boomer</MTSetVarBlock><MTSetVar name='var_hash' value='$MTVersions8'><MTIf name='var_hash{4.0}' eq='Enterprise Solution'>TRUE<MTElse>FALSE</MTIf>;<MTIf name='var_hash{4.01}' eq='Enterprise Solution'>TRUE<MTElse>FALSE</MTIf>;<MTIf name='var_hash' key='4.2' eq='Boomer'>TRUE<MTElse>FALSE</MTIf>;<MTIf name='MTVersions8{4.1}' ne='Boomer'><MTVar name='MTVersions8{4.1}'><MTElse name='MTVersions8{4.1}' eq='Cal'>TRUE<MTElse>FALSE</MTIf>;
  expected: FALSE;TRUE;FALSE;FALSE;

-
  name: test item 392
  template: <MTSetVar name='num' value='1'><MTGetVar name='num'>;<MTIf name='num' eq='1'>TRUE<MTElse>FALSE</MTIf>;<MTGetVar name='num' value='20' op='mul'>;<MTIf name='num' value='3' op='*' eq='60'>TRUE<MTElse>FALSE</MTIf>;<MTIf name='num' value='3' op='+' eq='4'>TRUE<MTElse name='num' op='+' value='4' eq='5'>555<MTElse>FALSE</MTIf>;
  expected: 1;TRUE;20;FALSE;TRUE;

-
  name: test item 393
  template: <MTAssets lastn='1'><$MTAssetLabel$></MTAssets>
  expected: Image photo

-
  name: test item 394
  template: <MTAssets lastn='1'><$MTAssetDescription$></MTAssets>
  expected: This is a test photo.

-
  name: test item 395
  template: <MTSetVar name='val' value='0'><MTIfNonEmpty name="val">zero</MTIfNonEmpty>
  expected: zero

-
  name: test item 396
  template: "<mt:setvar name='foo' value='hoge'><mt:if name='foo' eq='hoge'>value is hoge.<mt:elseif name='foo' eq='koge'>value is koge.<mt:else eq='joge'>value is joge.<mt:elseif eq='moge'>value is moge.<mt:else>value is <mt:getvar name='foo'>.</mt:if>"
  expected: value is hoge.

-
  name: test item 397
  template: "<mt:setvar name='foo' value='koge'><mt:if name='foo' eq='hoge'>value is hoge.<mt:elseif name='foo' eq='koge'>value is koge.<mt:else eq='joge'>value is joge.<mt:elseif eq='moge'>value is moge.<mt:else>value is <mt:getvar name='foo'>.</mt:if>"
  expected: value is koge.

-
  name: test item 398
  template: "<mt:setvar name='foo' value='joge'><mt:if name='foo' eq='hoge'>value is hoge.<mt:elseif name='foo' eq='koge'>value is koge.<mt:else eq='joge'>value is joge.<mt:elseif eq='moge'>value is moge.<mt:else>value is <mt:getvar name='foo'>.</mt:if>"
  expected: value is joge.

-
  name: test item 399
  template: "<mt:setvar name='foo' value='moge'><mt:if name='foo' eq='hoge'>value is hoge.<mt:elseif name='foo' eq='koge'>value is koge.<mt:else eq='joge'>value is joge.<mt:elseif eq='moge'>value is moge.<mt:else>value is <mt:getvar name='foo'>.</mt:if>"
  expected: value is moge.

-
  name: test item 400
  template: "<mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>value is hoge.<mt:elseif name='foo' eq='koge'>value is koge.<mt:else eq='joge'>value is joge.<mt:elseif eq='moge'>value is moge.<mt:else>value is <mt:getvar name='foo'>.</mt:if>"
  expected: value is poge.

-
  name: test item 401
  template: "<mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'><mt:else>value is <mt:var name='foo'></mt:if>"
  expected: value is poge

-
  name: test item 402
  template: "<mt:setvar name='foo' value='1'><mt:if name='bar'>true<mt:else>false</mt:if>"
  expected: false

-
  name: test item 403
  template: <MTTags glue=',' sort_by='rank'><MTTagLabel> <MTTagRank></MTTags>
  expected: verse 1,rain 2,anemones 4,grandpa 6,strolling 6

-
  name: test item 404
  template: <MTSubCategories category='foo'><MTCategoryLabel></MTSubCategories>
  expected: subfoo

-
  name: test item 405
  template: <MTCategories sort_by='label' sort_order='ascend' show_empty='1'><MTCategoryLabel>'<MTSubCategories><MTCategoryLabel></MTSubCategories>'</MTCategories>
  expected: bar''foo'subfoo'subfoo''

-
  name: test item 406
  template: <MTEntries recently_commented_on='3' glue=','><MTEntryTitle></MTEntries>
  expected: Verse 2,Verse 3,A Rainy Day

-
  name: test item 407
  template: "value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:elseif name='foo' eq='moge'>moge<mt:else>false</mt:if>"
  expected: value is false

-
  name: test item 408
  template: "value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:else name='foo' eq='moge'>moge<mt:else>false</mt:if>"
  expected: value is false

-
  name: test item 409
  run: 0
  template: "value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:elseif eq='moge'>moge<mt:else>false</mt:if>"
  expected: value is false

-
  name: test item 410
  run: 0
  template: "value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:else eq='moge'>moge<mt:else>false</mt:if>"
  expected: value is false

-
  name: test item 411
  run: 0
  template: "value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:elseif eq='poge'>poge<mt:else>false</mt:if>"
  expected: value is poge

-
  name: test item 412
  run: 0
  template: "value is <mt:setvar name='foo' value='poge'><mt:if name='foo' eq='hoge'>hoge<mt:else eq='poge'>poge<mt:else>false</mt:if>"
  expected: value is poge

-
  name: test item 413
  run: 0
  template: "<mt:var name='ar[0]' value='A'><mt:var name='ar[1]' value='B'><mt:var name='ar[2]' value='C'><mt:loop name='ar'><mt:if name='__value__' eq='A'><mt:var name='__counter__'><mt:elseif eq='B'><mt:var name='__counter__'><mt:else><mt:var name='__counter__'></mt:if></mt:loop>"
  expected: 123

-
  name: test item 414
  run: 0
  template: "<mt:var name='ar[0]' value='A'><mt:var name='ar[1]' value='B'><mt:var name='ar[2]' value='C'><mt:loop name='ar'><mt:if name='__value__' eq='A'><mt:var name='__counter__'><mt:else eq='B'><mt:var name='__counter__'><mt:else><mt:var name='__counter__'></mt:if></mt:loop>"
  expected: 123

-
  name: test item 415
  run: 0
  template: "value is <mt:setvar name='foo' value='fuga'><mt:if name='foo' eq='hoge'>hoge<mt:elseif eq='poge'>poge<mt:elseif eq='fuga'>fuga<mt:else>false</mt:if>"
  expected: value is fuga

-
  name: test item 416
  run: 0
  template: "value is <mt:setvar name='foo' value='fuga'><mt:if name='foo' eq='hoge'>hoge<mt:else eq='poge'>poge<mt:else eq='fuga'>fuga<mt:else>false</mt:if>"
  expected: value is fuga

-
  name: test item 417
  run: 0
  template: "<mt:var name='ar[0]' value='A'><mt:var name='ar[1]' value='B'><mt:var name='ar[2]' value='C'><mt:loop name='ar'><mt:if name='__value__' eq='A'><mt:var name='__counter__'><mt:elseif eq='B'><mt:var name='__counter__'><mt:elseif eq='C'>hoge!<mt:else><mt:var name='__counter__'></mt:if></mt:loop>"
  expected: 12hoge!

-
  name: test item 418
  run: 0
  template: "<mt:var name='ar[0]' value='A'><mt:var name='ar[1]' value='B'><mt:var name='ar[2]' value='C'><mt:loop name='ar'><mt:if name='__value__' eq='A'><mt:var name='__counter__'><mt:else eq='B'><mt:var name='__counter__'><mt:else eq='C'>hoge!<mt:else><mt:var name='__counter__'></mt:if></mt:loop>"
  expected: 12hoge!

-
  name: test item 419
  template: "<mt:setvar name='foo' value='c'><mt:if name='foo' eq='a'>value is a.<mt:elseif eq='b'>value is b.<mt:else eq='c'>value is c.<mt:elseif eq='d'>value is d.<mt:else>value is this: <mt:getvar name='foo'>.</mt:if>"
  expected: value is c.

-
  name: test item 420
  template: "<mt:setvar name='foo' value='c'><mt:setvar name='bar' value='xxx'><mt:if name='foo' eq='a'>value is a.<mt:else><mt:if name='bar' eq='aaa'><mt:else eq='c'>value is c<mt:else eq='xxx'>value is xxx.</mt:if></mt:if>"
  expected: value is xxx.

-
  name: test item 421
  template: "<mt:setvar name='foo' value='c'><mt:setvar name='bar' value='xxx'><mt:if name='foo' eq='a'>value is a.<mt:elseif name='bar' eq='aaa'><mt:else eq='c'>value is c<mt:else eq='xxx'>value is xxx.</mt:if>"
  expected: value is xxx.

-
  name: test item 422
  template: "<mt:var name='foo' value='2'><mt:if name='foo' eq='1'>incorrect<mt:else eq='2'>correct<mt:else eq='3'>incorrect</mt:if>"
  expected: correct

-
  name: test item 423
  template: "<mt:var name='foo1' value='foo-1'><mt:var name='foo2' value='foo-2'><mt:if name='foo1' eq='abc'>incorrect-1<mt:else eq='def'>incorrect-2<mt:else eq='foo-1'>CORRECT-1<mt:if name='foo2' eq='ghi'>incorrect-3<mt:else eq='foo-2'>CORRECT-2<mt:else>incorrect-4</mt:if><mt:else eq='foo-2'>incorrect-5<mt:else>incorrect-6</mt:if>"
  expected: CORRECT-1CORRECT-2

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
  name: test item 427
  template: "<mt:authors username='Chuck D'><MTAuthorName>;<MTAuthorDisplayName>;<MTAuthorEmail>;<MTAuthorURL>;</mt:authors>"
  expected: "Chuck D;Chucky Dee;chuckd@example.com;http://chuckd.com/;"

-
  name: test item 428
  template: "<mt:authors id='2' username='Bob D'><MTAuthorName>;<MTAuthorDisplayName>;<MTAuthorEmail>;<MTAuthorURL>;</mt:authors>"
  expected: "Chuck D;Chucky Dee;chuckd@example.com;http://chuckd.com/;"

-
  name: test item 429
  template: "<mt:authors id='2'><MTAuthorName>;<MTAuthorDisplayName>;<MTAuthorEmail>;<MTAuthorURL>;</mt:authors>"
  expected: "Chuck D;Chucky Dee;chuckd@example.com;http://chuckd.com/;"

-
  name: test item 430
  template: "<mt:Websites><mt:WebsiteName></mt:Websites>"
  expected: Test site

-
  name: test item 431
  template: "<mt:Websites><mt:WebsiteDescription></mt:Websites>"
  expected: Narnia None Test Website

-
  name: test item 432
  template: "<mt:Websites><mt:WebsiteURL></mt:Websites>"
  expected: "http://narnia.na/"

-
  name: test item 433
  template: "<mt:Websites><mt:WebsitePath></mt:Websites>"
  expected: t/

-
  name: test item 434
  template: "<mt:Websites><mt:WebsiteID></mt:Websites>"
  expected: 2

-
  name: test item 435
  template: "<mt:Websites><mt:WebsiteTimezone></mt:Websites>"
  expected: "-03:30"

-
  name: test item 436
  template: "<mt:Websites><mt:WebsiteTimezone no_colon='1'></mt:Websites>"
  expected: -0330

-
  name: test item 437
  template: "<mt:Websites><mt:WebsiteLanguage></mt:Websites>"
  expected: en_us

-
  name: test item 438
  template: "<mt:Websites><mt:WebsiteLanguage locale='1'></mt:Websites>"
  expected: en_US

-
  name: test item 439
  template: "<mt:Websites><mt:IfWebsite>1</mt:IfWebsite></mt:Websites>"
  expected: 1

-
  name: test item 440
  template: "<mt:Websites><MTWebsiteCCLicenseURL></mt:Websites>"
  expected: "http://creativecommons.org/licenses/by-nc-sa/2.0/"

-
  name: test item 441
  template: "<mt:Websites><MTWebsiteCCLicenseImage></mt:Websites>"
  expected: "http://creativecommons.org/images/public/somerights20.gif"

-
  name: test item 442
  template: "<mt:Websites><MTWebsiteIfCCLicense>1</MTWebsiteIfCCLicense></mt:Websites>"
  expected: 1

-
  name: test item 443
  template: "<mt:Websites><mt:WebsiteFileExtension></mt:Websites>"
  expected: .html

-
  name: test item 444
  template: <MTBlogURL id='1'>
  expected: "http://narnia.na/nana/"

-
  name: test item 445
  template: <MTBlogRelativeURL id='1'>
  expected: /nana/

-
  name: test item 446
  template: <MTBlogSitePath is='1'>
  expected: t/site/

-
  name: test item 447
  template: <MTBlogArchiveURL id='1'>
  expected: "http://narnia.na/nana/archives/"

-
  name: test item 448
  template: "<mt:Websites><mt:WebsiteHasBlog>true</mt:WebsiteHasBlog></mt:Websites>"
  expected: true

-
  name: test item 449
  template: "<mt:BlogParentWebsite><mt:WebsiteID></mt:BlogParentWebsite>"
  expected: 2

-
  name: test item 450
  run: 0
  template: "<MTCalendar><MTCalendarWeekHeader month='197801'><tr></MTCalendarWeekHeader><td><MTCalendarCellNumber>,<MTCalendarIfEntries><MTEntries lastn='1'><a href='<$MTEntryPermalink$>'><$MTCalendarDay$></a></MTEntries></MTCalendarIfEntries><MTCalendarIfNoEntries><$MTCalendarDay$></MTCalendarIfNoEntries><MTCalendarIfBlank>&nbsp;</MTCalendarIfBlank></td><MTCalendarWeekFooter></tr></MTCalendarWeekFooter></MTCalendar>', 'e' : '<tr><td>1,&nbsp;</td><td>2,&nbsp;</td><td>3,&nbsp;</td><td>4,&nbsp;</td><td>5,&nbsp;</td><td>6,1</td><td>7,2</td></tr><tr><td>8,3</td><td>9,4</td><td>10,5</td><td>11,6</td><td>12,7</td><td>13,8</td><td>14,9</td></tr><tr><td>15,10</td><td>16,11</td><td>17,12</td><td>18,13</td><td>19,14</td><td>20,15</td><td>21,16</td></tr><tr><td>22,17</td><td>23,18</td><td>24,19</td><td>25,20</td><td>26,21</td><td>27,22</td><td>28,23</td></tr><tr><td>29,24</td><td>30,25</td><td>31,26</td><td>32,27</td><td>33,28</td><td>34,29</td><td>35,30</td></tr>"
  expected: ''

-
  name: test item 451
  run: 0
  template: <MTGoogleSearch query='six apart' results='1'><MTGoogleSearchResult property='URL'></MTGoogleSearch>
  expected: "http://www.sixapart.com/"

-
  name: test item 452
  template: <MTComments lastn="1"><MTCommentIfModerated>Moderated<MTElse>NotModerated</MTCommentIfModerated></MTComments>
  expected: Moderated

-
  name: test item 453
  template: <MTComments lastn="1"><MTCommentLink></MTComments>
  expected: "http://narnia.na/nana/archives/1962/01/verse-2.html#comment-2"

-
  name: test item 454
  template: <MTComments lastn="1"><MTCommentName></MTComments>
  expected: John Doe

-
  name: test item 455
  template: <MTComments lastn="1"><MTCommentParentID></MTComments>
  expected: ''

-
  name: test item 456
  template: <MTComments lastn="1"><MTCommentRank></MTComments>
  expected: ''

-
  name: test item 457
  template: <MTComments lastn="1"><MTCommentReplyToLink></MTComments>
  expected: "<a title=\"Reply\" href=\"javascript:void(0);\" onclick=\"mtReplyCommentOnClick(2, 'John Doe')\">Reply</a>"

-
  name: test item 458
  template: <MTComments lastn="1"><MTCommentScore></MTComments>
  expected: ''

-
  name: test item 459
  template: <MTComments lastn="1"><MTCommentScoreAVG></MTComments>
  expected: ''

-
  name: test item 460
  template: <MTComments lastn="1"><MTCommentScoreCount></MTComments>
  expected: ''

-
  name: test item 461
  template: <MTComments lastn="1"><MTCommentScoreHigh></MTComments>
  expected: ''

-
  name: test item 462
  template: <MTComments lastn="1"><MTCommentScoreLow></MTComments>
  expected: ''

-
  name: test item 463
  template: <MTCategories><MTCategoryBasename></MTCategories>
  expected: foosubfoo

-
  name: test item 464
  template: <MTCategories><MTCategoryCommentCount></MTCategories>
  expected: 30

-
  name: test item 465
  template: <MTCategories><MTCategoryIfAllowPings>Allow<MTElse>NotAllow</MTCategoryIfAllowPings></MTCategories>
  expected: NotAllowNotAllow

-
  name: test item 466
  template: <MTCategories><MTCategoryTrackbackCount></MTCategories>
  expected: 00

-
  name: test item 467
  template: <MTSubCategories category='subfoo' include_current='1'><MTParentCategories glue='-' exclude_current='1'><MTCategoryLabel></MTParentCategories></MTSubCategories>
  expected: foo

-
  name: test item 468
  template: <MTSubCategories category='subfoo' include_current='1'><MTParentCategories glue='-'><MTCategoryLabel></MTParentCategories></MTSubCategories>
  expected: foo-subfoo

-
  name: test item 469
  template: <MTComments lastn="1"><MTCommentBlogID></MTComments>
  expected: 1

-
  name: test item 470
  template: <MTComments lastn="1"><MTCommenterID></MTComments>
  expected: 4

-
  name: test item 471
  template: <MTComments lastn="1"><MTCommenterURL></MTComments>
  expected: ''

-
  name: test item 472
  template: <MTComments lastn="1"><MTCommenterUsername></MTComments>
  expected: John Doe

-
  name: test item 473
  template: <MTComments lastn="1"><MTCommenterUserpic></MTComments>
  expected: ''

-
  name: test item 474
  template: <MTComments lastn="1"><MTCommenterUserpicAsset></MTCommenterUserpicAsset></MTComments>
  expected: ''

-
  name: test item 475
  template: <MTComments lastn="1"><MTCommenterUserpicURL></MTComments>
  expected: ''

-
  name: test item 476
  template: <MTBlogs><MTBlogCategoryCount></MTBlogs>
  expected: 3

-
  name: test item 477
  template: <MTBlogs><MTBlogPingCount></MTBlogs>
  expected: 2

-
  name: test item 478
  template: <MTBlogs><MTBlogTemplatesetID></MTBlogs>
  expected: classic-blog

-
  name: test item 479
  template: <MTBlogs><MTBlogThemeID></MTBlogs>
  expected: classic-blog

-
  name: test item 480
  template: <MTAuthors lastn="1"><MTAuthorEntryCount></MTAuthors>
  expected: 5

-
  name: test item 481
  template: <MTAuthors lastn="1"><MTAuthorHasEntry><MTAuthorName setvar="author_name"><MTEntries author="$author_name" lastn="1">has</MTEntries></MTAuthorHasEntry></MTAuthors>
  expected: has

-
  name: test item 482
  template: <MTAuthors lastn="1"><MTAuthorHasPage><MTAuthorName setvar="author_name"><MTPages author="$author_name" lastn="1">has</MTPages></MTAuthorHasPage></MTAuthors>
  expected: has

-
  name: test item 483
  template: <MTAuthors lastn="1"><MTAuthorNext><MTAuthorName></MTAuthorNext></MTAuthors>
  expected: ''

-
  name: test item 484
  template: <MTAuthors lastn="1"><MTAuthorPrevious><MTAuthorName></MTAuthorPrevious></MTAuthors>
  expected: Bob D

-
  name: test item 485
  template: <MTAuthors lastn="1"><MTAuthorRank></MTAuthors>
  expected: ''

-
  name: test item 486
  template: <MTAuthors lastn="1"><MTAuthorScore></MTAuthors>
  expected: ''

-
  name: test item 487
  template: <MTAuthors lastn="1"><MTAuthorScoreAvg></MTAuthors>
  expected: ''

-
  name: test item 488
  template: <MTAuthors lastn="1"><MTAuthorScoreCount></MTAuthors>
  expected: ''

-
  name: test item 489
  template: <MTAuthors lastn="1"><MTAuthorScoreHigh></MTAuthors>
  expected: ''

-
  name: test item 490
  template: <MTAuthors lastn="1"><MTAuthorScoreLow></MTAuthors>
  expected: ''

-
  name: test item 491
  template: <MTAuthors lastn="1"><MTAuthorUserpic></MTAuthors>
  expected: <img src="/mt-static/support/assets_c/userpics/userpic-2-100x100.png?3" width="100" height="100" alt="" />

-
  name: test item 492
  template: <MTAuthors lastn="1"><MTAuthorUserpicAsset><MTAssetFileName></MTAuthorUserpicAsset></MTAuthors>
  expected: test.jpg

-
  name: test item 493
  template: <MTAuthors lastn="1"><MTAuthorUserpicURL></MTAuthors>
  expected: /mt-static/support/assets_c/userpics/userpic-2-100x100.png

-
  name: test item 494
  template: <MTAuthors lastn="1"><MTAuthorBasename></MTAuthors>
  expected: chucky_dee

-
  name: test item 495
  template: <MTAssets assets_per_row="2"><MTAssetIsFirstInRow>First</MTAssetIsFirstInRow><MTAssetIsLastInRow>Last</MTAssetIsLastInRow></MTAssets>
  expected: FirstLast

-
  name: test item 496
  template: <MTAssets lastn='1'><MTAssetIfTagged tag="alpha">Tagged<MTElse>Not Tagged</MTAssetIfTagged></MTAssets>
  expected: Tagged

-
  name: test item 497
  template: <MTAssets lastn='1'><MTAssetIfTagged tag="empty_tag_name">Tagged<MTElse>Not Tagged</MTAssetIfTagged></MTAssets>
  expected: Not Tagged

-
  name: test item 498
  template: <MTArchiveList type='Individual'><MTArchiveListHeader><MTArchiveTypeLabel></MTArchiveListHeader></MTArchiveList>
  expected: Entry

-
  name: test item 499
  template: <MTUserSessionCookieDomain>
  expected: .narnia.na

-
  name: test item 500
  template: <MTUserSessionCookieName>
  expected: mt_blog_user

-
  name: test item 501
  template: <MTUserSessionCookiePath>
  expected: /

-
  name: test item 502
  template: <MTUserSessionCookieTimeout>
  expected: 14400

-
  name: test item 503
  template: <MTWebsiteCommentCount>
  expected: 9

-
  name: test item 504
  template: <MTWebsiteHost>
  expected: narnia.na

-
  name: test item 505
  template: <MTWebsiteIfCommentsOpen>Opened</MTWebsiteIfCommentsOpen>
  expected: Opened

-
  name: test item 506
  template: <MTWebsitePageCount>
  expected: 4

-
  name: test item 507
  template: <MTWebsitePingCount>
  expected: 2

-
  name: test item 508
  template: <MTWebsiteRelativeURL>
  expected: /nana/

-
  name: test item 509
  template: <MTWebsiteThemeID>
  expected: classic-blog

-
  name: test item 510
  template: <MTNotifyScript>
  expected: mt-add-notify.cgi

-
  name: test item 511
  template: <MTPages lastn='1'><MTPageIfTagged tag='page3'><MTPageTitle></MTPageIfTagged></MTPages>
  expected: 'Page #3'

-
  name: test item 512
  template: <MTPages lastn='1' offset='1'><MTPageNext><MTPageTitle></MTPageNext></MTPages>
  expected: 'Page #3'

-
  name: test item 513
  template: <MTPages lastn='1'><MTPagePrevious><MTPageTitle></MTPagePrevious></MTPages>
  expected: 'Page #2'

-
  name: test item 514
  template: <MTPages lastn='3'><MTPagesHeader><ul></MTPagesHeader><li><MTPageTitle></li><MTPagesFooter></ul></MTPagesFooter></MTPages>
  expected: '<ul><li>Page #3</li><li>Page #2</li><li>Page #1</li></ul>'

-
  name: test item 515
  template: <MTFolders><MTParentFolder><MTFolderLabel></MTParentFolder></MTFolders>
  expected: download

-
  name: test item 516
  template: <MTFolders><MTHasParentFolder><MTFolderLabel></MTHasParentFolder></MTFolders>
  expected: nightly

-
  name: test item 517
  template: <MTPings lastn='1'><MTPingRank></MTPings>
  expected: ''

-
  name: test item 518
  template: <MTPings lastn='1'><MTPingScore></MTPings>
  expected: ''

-
  name: test item 519
  template: <MTPings lastn='1'><MTPingScoreavg></MTPings>
  expected: ''

-
  name: test item 520
  template: <MTPings lastn='1'><MTPingScorecount></MTPings>
  expected: ''

-
  name: test item 521
  template: <MTPings lastn='1'><MTPingScorehigh></MTPings>
  expected: ''

-
  name: test item 522
  template: <MTPings lastn='1'><MTPingScorelow></MTPings>
  expected: ''

-
  name: test item 523
  template: <MTPings><MTPingsHeader><ul></MTPingsHeader><li><MTPingTitle></li><MTPingsFooter></ul></MTPingsFooter></MTPings>
  expected: <ul><li>Trackbacking to a page</li><li>Foo</li></ul>

-
  name: test item 524
  template: <MTProductName>
  expected: Movable Type

-
  name: test item 525
  template: <MTSection>Content</MTSection>
  expected: Content

-
  name: test item 526
  template: |-
    <MTSetVars>
    foo=Foo
    </MTSetVars><MTGetVar name='foo'>
  expected: Foo

-
  name: test item 527
  template: <MTSetVarTemplate name='foo_template'><MTSetVar name='foo' value='Bar'></MTSetVarTemplate><MTSetVar name='foo' value='Foo'><MTVar name='foo_template'><MTGetVar name='foo'>
  expected: Bar

-
  name: test item 528
  template: <MTStaticFilePath>
  expected: STATIC_FILE_PATH

-
  name: test item 529
  template: <MTSubFolders><MTIF tag='FolderID' eq='21'><MTFolderLabel>;<MTSubfolderRecurse></MTIF></MTSubFolders>
  expected: ''

-
  name: test item 530
  template: <MTSupportDirectoryURL>
  expected: /mt-static/support/

-
  name: test item 531
  template: <MTTemplateNOTE note='Comment'>
  expected: ''

-
  name: test item 532
  template: <MTFolders><MTIF tag='FolderID' eq='22'><MTToplevelFolder><MTFolderLabel></MTToplevelFolder></MTIF></MTFolders>
  expected: download

-
  name: test item 533
  template: <MTSetVar name='foo' value='Foo'><MTUnless name='foo' eq='Bar'>Content</MTUnless>
  expected: Content

-
  name: test item 534
  template: <MTSetVar name='foo' value='Foo'><MTUnless name='foo' eq='Foo'>Content</MTUnless>
  expected: ''

-
  name: test item 535
  template: <MTFolders><MTFolderHeader><ul></MTFolderHeader><li><MTFolderLabel></li><MTFolderFooter></ul></MTFolderFooter></MTFolders>
  expected: <ul><li>download</li><li>info</li><li>nightly</li></ul>

-
  name: test item 536
  template: <MTFolders show_empty='1' glue=','><MTFolderLabel>-<MTFolderNext show_empty='1'><MTFolderLabel></MTFolderNext></MTFolders>
  expected: download-info,info-,nightly-

-
  name: test item 537
  template: <MTFolders show_empty='1' glue=','><MTFolderLabel>-<MTFolderPrevious show_empty='1'><MTFolderLabel></MTFolderPrevious></MTFolders>
  expected: download-,info-download,nightly-

-
  name: test item 538
  template: <MTFolders><MTHasSubFolders><MTSubFolders><MTFolderID></MTSubFolders></MTHasSubFolders></MTFolders>
  expected: 22

-
  name: test item 539
  template: <MTHTTPContentType type='application/xml'>
  expected: ''

-
  name: test item 540
  template: "<MTIfAuthor>HasAuthor:Outside</MTIfAuthor><MTAuthors lastn='1'><MTIfAuthor>HasAuthor:Inside</MTIfAuthor></MTAuthors>"
  expected: "HasAuthor:Inside"

-
  name: test item 541
  template: <MTIfBlog>HasBlog</MTIfBlog>
  expected: HasBlog

-
  name: test item 542
  template: <MTIfCommenterRegistrationAllowed>Allowed</MTIfCommenterRegistrationAllowed>
  expected: Allowed

-
  name: test item 543
  template: "<MTComments lastn='3' glue=','><MTIfNonEmpty tag='CommenterName'><MTCommenterName>: <MTIfCommenterTrusted>trusted<MTElse>untrusted</MTElse></MTIfCommenterTrusted><MTElse><MTCommentAuthor></MTIfNonEmpty></MTComments>"
  expected: "Chucky Dee: trusted,Comment 3: untrusted,John Doe: trusted"

-
  name: test item 544
  template: <MTIfExternalUserManagement>External</MTIfExternalUserManagement>
  expected: ''

-
  name: test item 545
  template: <MTPages id='22'><MTIfFolder name='download'>download</MTIfFolder></MTPages>
  expected: download

-
  name: test item 546
  template: <MTPages id='23'><MTIfFolder name='download'>download</MTIfFolder></MTPages>
  expected: ''

-
  name: test item 547
  template: <MTIfImageSupport>Supported</MTIfImageSupport>
  expected: Supported

-
  name: test item 548
  template: <MTIfPingsModerated>Moderated</MTIfPingsModerated>
  expected: Moderated

-
  name: test item 549
  template: <MTIfRequireCommentEmails>Requied</MTIfRequireCommentEmails>
  expected: ''

-
  name: test item 550
  template: <MTDate ts='20101010101010'>
  expected: "October 10, 2010 10:10 AM"

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
  name: test item 567
  template: <MTIncludeBlock module='header-line'>Title</MTIncludeBlock>
  expected: <h1>Title</h1>

-
  name: test item 568
  template: <MTIncludeBlock module='header-line'>Title</MTIncludeBlock>
  expected: <h1>Title</h1>

-
  name: test item 569
  template: |-
    <MTSetVarBlock name="foo">a
    b
    c</MTSetVarBlock><MTGetVar name="foo" count_paragraphs="1">
  expected: 3

-
  name: test item 570
  template: <MTSetVarBlock name="foo">-1234567</MTSetVarBlock><MTGetVar name="foo" numify="1">
  expected: -1,234,567

-
  name: test item 571
  template: <MTSetVarBlock name="foo">Foo</MTSetVarBlock><MTGetVar name="foo" encode_sha1="1">
  expected: 201a6b3053cc1422d2c3670b62616221d2290929

-
  name: test item 572
  template: <MTSetVarBlock name="foo">Foo</MTSetVarBlock><MTGetVar name="foo" spacify=" ">
  expected: F o o

-
  name: test item 573
  template: <MTSetVarBlock name="foo">Foo</MTSetVarBlock><MTGetVar name="foo" count_characters="1">
  expected: 3

-
  name: test item 574
  template: <MTSetVarBlock name="foo">Foo</MTSetVarBlock><MTGetVar name="foo" cat="Bar">
  expected: FooBar

-
  name: test item 575
  template: <MTSetVarBlock name="foo">FooBar</MTSetVarBlock><MTGetVar name="foo" regex_replace="/Fo*/i","Bar">
  expected: BarBar

-
  name: test item 576
  template: <MTSetVarBlock name="foo">Foo Bar Baz</MTSetVarBlock><MTGetVar name="foo" count_words="1">
  expected: 3

-
  name: test item 577
  template: <MTSetVarBlock name="foo">foo</MTSetVarBlock><MTGetVar name="foo" capitalize="1">
  expected: Foo

-
  name: test item 578
  template: <MTSetVarBlock name="foo">FooBar</MTSetVarBlock><MTGetVar name="foo" replace="Bar","Foo">
  expected: FooFoo

-
  name: test item 579
  template: |-
    <MTSetVarBlock name="foo">aaa
    bbb</MTSetVarBlock><MTGetVar name="foo" indent="2">
  expected: "  aaa\n  bbb"

-
  name: test item 580
  template: |-
    <MTSetVarBlock name="foo">aaa
    bbb</MTSetVarBlock><MTGetVar name="foo" indent="2">
  expected: "  aaa\n  bbb"

-
  name: test item 581
  template: <MTSetVar name="foo" value="Foo"><MTSetVar name="bar" value="<MTGetVar name='foo'>"><MTGetVar name="bar" mteval="1">
  expected: Foo

-
  name: test item 582
  template: <MTSetVarBlock name="foo"><span>Foo</span></MTSetVarBlock><MTGetVar name="foo" strip_tags="1">
  expected: Foo

-
  name: test item 583
  template: <MTSetVar name="foo" value="Foo"><MTVar name="foo" setvar="bar"><MTVar name="bar">
  expected: Foo

-
  name: test item 584
  template: <MTSetVarBlock name="foo">1234567890</MTSetVarBlock><MTGetVar name="foo" wrap_text="4">
  expected: |-
    123
    456
    789
    0

-
  name: test item 585
  template: |-
    <MTSetVarBlock name="foo">123
    456</MTSetVarBlock><MTGetVar name="foo" nl2br="xhtml" strip="">
  expected: 123<br/>456

-
  name: test item 586
  template: <MTSetVarBlock name="foo">  Foo  Bar  </MTSetVarBlock><MTGetVar name="foo" strip="">
  expected: FooBar

-
  name: test item 587
  template: "<MTSetVarBlock name=\"foo\">  Foo  Bar  </MTSetVarBlock><MTGetVar name=\"foo\" strip=\"&nbsp;\">"
  expected: "&nbsp;Foo&nbsp;Bar&nbsp;"

-
  name: test item 588
  template: "<MTSetVarBlock name=\"foo\">1</MTSetVarBlock><MTGetVar name=\"foo\" string_format=\"%06d\">"
  expected: 000001

-
  name: test item 589
  template: <MTSetVarBlock name="foo"></MTSetVarBlock><MTGetVar name="foo" _default="Default">
  expected: Default

-
  name: test item 590
  template: <MTSetVarBlock name="foo">Foo</MTSetVarBlock><MTGetVar name="foo" _default="Default">
  expected: Foo

-
  name: test item 591
  template: <MTSetVarBlock name="foo"><span>Foo</span></MTSetVarBlock><MTGetVar name="foo" escape="html">
  expected: "&lt;span&gt;Foo&lt;/span&gt;"

-
  name: test item 592
  run: 0
  template: <MTSetVarBlock name="foo"><span>Foo</span></MTSetVarBlock><MTGetVar name="foo" escape="htmlall">
  expected: "&lt;span&gt;Foo&lt;/span&gt;"

-
  name: test item 593
  template: "<MTSetVarBlock name=\"foo\">http://example.com/?q=@</MTSetVarBlock><MTGetVar name=\"foo\" escape=\"url\">"
  expected: "http%3A%2F%2Fexample.com%2F%3Fq%3D%40"

-
  name: test item 594
  run: 0
  template: "<MTSetVarBlock name=\"foo\">http://example.com/?q=@</MTSetVarBlock><MTGetVar name=\"foo\" escape=\"urlpathinfo\">"
  expected: "http%3A//example.com/%3Fq%3D%40"

-
  name: test item 595
  run: 0
  template: "<MTSetVarBlock name=\"foo\">http://example.com/?q=@</MTSetVarBlock><MTGetVar name=\"foo\" escape=\"quotes\">"
  expected: "http://example.com/?q=@"

-
  name: test item 596
  run: 0
  template: "<MTSetVarBlock name=\"foo\">http://example.com/?q=@</MTSetVarBlock><MTGetVar name=\"foo\" escape=\"hex\">"
  expected: "%68%74%74%70%3a%2f%2f%65%78%61%6d%70%6c%65%2e%63%6f%6d%2f%3f%71%3d%40"

-
  name: test item 597
  run: 0
  template: "<MTSetVarBlock name=\"foo\">http://example.com/?q=@</MTSetVarBlock><MTGetVar name=\"foo\" escape=\"hexentity\">"
  expected: "&#x68;&#x74;&#x74;&#x70;&#x3a;&#x2f;&#x2f;&#x65;&#x78;&#x61;&#x6d;&#x70;&#x6c;&#x65;&#x2e;&#x63;&#x6f;&#x6d;&#x2f;&#x3f;&#x71;&#x3d;&#x40;"

-
  name: test item 598
  run: 0
  template: "<MTSetVarBlock name=\"foo\">http://example.com/?q=@</MTSetVarBlock><MTGetVar name=\"foo\" escape=\"decentity\">"
  expected: "&#104;&#116;&#116;&#112;&#58;&#47;&#47;&#101;&#120;&#97;&#109;&#112;&#108;&#101;&#46;&#99;&#111;&#109;&#47;&#63;&#113;&#61;&#64;"

-
  name: test item 599
  run: 0
  template: <MTSetVarBlock name="foo"><script>alert("test");</script></MTSetVarBlock><MTGetVar name="foo" escape="javascript">
  expected: \<s\cript\>alert(\"test\");\<\/s\cript\>

-
  name: test item 600
  run: 0
  template: <MTSetVarBlock name="foo">test@example.com</MTSetVarBlock><MTGetVar name="foo" escape="mail">
  expected: test [AT] example [DOT] com

-
  name: test item 601
  run: 0
  template: <MTSetVarBlock name="foo"><span>Foo</span></MTSetVarBlock><MTGetVar name="foo" escape="nonstd">
  expected: <span>Foo</span>

-
  name: test item 602
  template: "<MTSetVarBlock name=\"foo\"><a href=\"http://example.com/\">Example</a></MTSetVarBlock><MTGetVar name=\"foo\" nofollowfy=\"1\">"
  expected: "<a href=\"http://example.com/\" rel=\"nofollow\">Example</a>"

-
  name: test item 603
  template: "<MTSetVarBlock name=\"foo\"><a href=\"http://example.com/\" rel=\"next\">Example</a></MTSetVarBlock><MTGetVar name=\"foo\" nofollowfy=\"1\">"
  expected: "<a href=\"http://example.com/\" rel=\"nofollow next\">Example</a>"

-
  name: test item 604
  template: <MTEntries tags='@grandparent' lastn='1'><MTEntryTitle></MTEntries>
  expected: ''

-
  name: test item 605
  template: <MTEntries lastn="1"><MTEntryTitle trim_to="6+..."></MTEntries>
  expected: A Rain...

-
  name: test item 606
  template: <MTAuthors id="2"><MTAuthorScore namespace='unit test'></MTAuthors>
  expected: 2

-
  name: test item 607
  template: <MTAuthors id="2"><MTAuthorScoreAvg namespace='unit test'></MTAuthors>
  expected: 2.00

-
  name: test item 608
  template: <MTAuthors id="2"><MTAuthorScoreCount namespace='unit test'></MTAuthors>
  expected: 1

-
  name: test item 609
  template: "<mt:Authors need_entry='0' namespace='unit test' sort_by='score' offset='1'><mt:AuthorName>,</mt:Authors>"
  expected: Chuck D,Melody,

-
  name: test item 610
  template: "<mt:Authors need_entry='0' namespace='unit test' sort_by='score' offset='2'><mt:AuthorName>,</mt:Authors>"
  expected: Melody,

-
  name: test item 611
  template: <MTEntries id="6"><MTEntryPrimaryCategory><MTCategoryLabel></MTEntryPrimaryCategory></MTEntries>
  expected: foo

-
  name: test item 612
  template: <MTEntries id="6"><MTEntryCategories type="primary"><MTCategoryLabel></MTEntryCategories></MTEntries>
  expected: foo
