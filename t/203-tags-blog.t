#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
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
  name: test item 154
  template: <MTBlogLanguage locale="1">
  expected: en_US

-
  name: test item 194
  template: <MTBlogFileExtension>
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
  name: test item 541
  template: <MTIfBlog>HasBlog</MTIfBlog>
  expected: HasBlog


