#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 177
  template: |
    <MTTags>
      <MTTagName>
    </MTTags>
  expected: |
    anemones
    grandpa
    rain
    strolling
    verse

-
  name: test item 178
  template: |
    <MTEntries lastn="1">
      <MTEntryTags>
        <MTTagName>
      </MTEntryTags>
    </MTEntries>
  expected: |
    grandpa
    rain
    strolling

-
  name: test item 179
  template: |
    <MTEntries lastn="1">
      <MTEntryTags>
        <MTTagID>
      </MTEntryTags>
    </MTEntries>
  expected: |
    1
    2
    3

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
  template: |
    <MTTags>
      <MTTagCount>
    </MTTags>
  expected: |
    2
    1
    4
    1
    5

-
  name: test item 225
  template: |
    <MTTags>
      <MTTagName> (rank <MTTagRank>)
    </MTTags>
  expected: |
    anemones (rank 4)
    grandpa (rank 6)
    rain (rank 2)
    strolling (rank 6)
    verse (rank 1)

-
  name: test item 226
  template: |
    <MTEntries tag="grandpa" lastn="1">
      <MTEntryTags>
        <MTTagRank>
      </MTEntryTags>
    </MTEntries>
  expected: |
    6
    2
    6

-
  name: test item 227
  template: |
    <MTEntries tag="verse" lastn="1">
      <MTEntryTags>
        <MTTagRank>
      </MTEntryTags>
    </MTEntries>
  expected: |
    2
    1

-
  name: test item 228
  template: <MTEntries tags="grandpa" lastn="1"><MTEntryTitle></MTEntries>
  expected: A Rainy Day

-
  name: test item 305
  template: |
    <MTTags>
      <MTTagLabel>
    </MTTags>
  expected: |
    anemones
    grandpa
    rain
    strolling
    verse

-
  name: test item 306
  template: |
    <MTEntries lastn="1">
      <MTEntryTags>
        <MTTagLabel>
      </MTEntryTags>
    </MTEntries>
  expected: |
    grandpa
    rain
    strolling

-
  name: test item 307
  template: |
    <MTTags>
      <MTTagLabel> (rank <MTTagRank>)
    </MTTags>
  expected: |
    anemones (rank 4)
    grandpa (rank 6)
    rain (rank 2)
    strolling (rank 6)
    verse (rank 1)

-
  name: test item 308
  template: |
    <MTAssets lastn="1">
      <MTAssetTags>
        <$MTTagLabel$>;
      </MTAssetTags>
    </MTAssets>
  expected: |
    alpha;
    beta;
    gamma;

-
  name: test item 403
  template: |
    <MTTags sort_by="rank">
      <MTTagLabel> (rank <MTTagRank>)
    </MTTags>
  expected: |
    verse (rank 1)
    rain (rank 2)
    anemones (rank 4)
    grandpa (rank 6)
    strolling (rank 6)


######## Tags
## glue
## type
## sort_by
## sort_order
## limit
## top

######## EntryTags
## glue
## include_private

######## PageTags
## glue
## include_private

######## AssetTags
## glue
## include_private

######## EntryIfTagged
## tag or name
## include_private

######## PageIfTagged
## tag
## include_private

######## AssetIfTagged
## tag or name
## include_private

######## TagSearchLink
## tmpl_blog_id

######## TagRank
## max (optional; default "6")

######## TagLabel

######## TagName
## normalize (optional; default "0")
## quote (optional; default "0")

######## TagID

######## TagCount

