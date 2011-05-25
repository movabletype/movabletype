#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
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
  name: test item 403
  template: <MTTags glue=',' sort_by='rank'><MTTagLabel> <MTTagRank></MTTags>
  expected: verse 1,rain 2,anemones 4,grandpa 6,strolling 6

