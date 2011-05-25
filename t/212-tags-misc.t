#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 175
  template: <MTIfStatic>1</MTIfStatic>
  expected: STATIC_CONSTANT

-
  name: test item 176
  template: <MTIfDynamic>1</MTIfDynamic>
  expected: DYNAMIC_CONSTANT

-
  name: test item 223
  template: <MTComments lastn='3'><MTFeedbackScore>,</MTComments>
  expected: 0,0,1.5,

-
  name: test item 451
  run: 0
  template: <MTGoogleSearch query='six apart' results='1'><MTGoogleSearchResult property='URL'></MTGoogleSearch>
  expected: "http://www.sixapart.com/"

-
  name: test item 531
  template: <MTTemplateNOTE note='Comment'>
  expected: ''

-
  name: test item 547
  template: <MTIfImageSupport>Supported</MTIfImageSupport>
  expected: Supported

