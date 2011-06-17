#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: IfStatic prints the inner content if published statically.
  template: <MTIfStatic>1</MTIfStatic>
  expected: STATIC_CONSTANT

-
  name: IfDynamic prints the inner content if published dynamically.
  template: <MTIfDynamic>1</MTIfDynamic>
  expected: DYNAMIC_CONSTANT

-
  name: FeedbackScore prints the junk score of current comment or ping.
  template: |
    <MTComments lastn='3'>
      <MTFeedbackScore>
    </MTComments>
  expected: |
    0
    0
    1.5

-
  name: GoogleSearch and GoogleSearchResult prints the search result.
  skip: Currently not supported.
  template: <MTGoogleSearch query='six apart' results='1'><MTGoogleSearchResult property='URL'></MTGoogleSearch>
  expected: "http://www.sixapart.com/"

-
  name: TemplateNote doesn't print anything.
  template: <MTTemplateNOTE note='Comment'>
  expected: ''

-
  name: IfImageSupport prints the inner content if image support is available.
  template: <MTIfImageSupport>Supported</MTIfImageSupport>
  expected: Supported


######## IfImageSupport

######## FeedbackScore

######## ImageURL

######## ImageWidth

######## ImageHeight

######## WidgetManager

######## WidgetSet
## name (required)
## blog_id (optional)

######## CaptchaFields

