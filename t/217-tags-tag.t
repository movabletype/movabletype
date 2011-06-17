#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;


my $mt    = MT->instance;
my $tag   = MT->model('tag')->load(1);
my $asset = MT->model('image')->load(1);

local $MT::Test::Tags::PRERUN = sub {
    my ($stock) = @_;
    $stock->{tag}   = $tag;
    $stock->{asset} = $asset;
};
local $MT::Test::Tags::PRERUN_PHP
    = '$stock["tag"] = $db->fetch_tag(' . $tag->id . ');'
    . '$stock["asset"] = $db->fetch_assets(' . $asset->id . ');';


run_tests_by_data();
__DATA__
-
  name: TagName prints the name of the tag.
  template: <MTTagName>
  expected: grandpa
  stash:
    Tag: $tag

-
  name: TagLabel is just an alias for the TagName.
  template: <MTTagLabel>
  expected: grandpa
  stash:
    Tag: $tag

-
  name: TagID prints the ID of the tag.
  template: <MTTagID>
  expected: 1
  stash:
    Tag: $tag

-
  name: TagSearchLink prints a link to search the entry that has this tag.
  template: <MTTagSearchLink>
  expected: "http://narnia.na/cgi-bin/mt-search.cgi?IncludeBlogs=1&amp;tag=grandpa&amp;limit=20"
  stash:
    Tag: $tag

-
  name: Tags lists all tags in current blog context.
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
  name: Tags with an attribute "glue" prints all tags that joined by specified characters.
  template: |
    <MTTags glue=","><MTTagName></MTTags>
  expected: |
    anemones,grandpa,rain,strolling,verse

-
  name: Tags with an attribute "sort_by=rank" prints all tags that sorted by the rank.
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

-
  name: EntryTags lists all tags in current entry context.
  template: |
    <MTEntryTags>
      <MTTagName>
    </MTEntryTags>
  expected: |
    grandpa
    rain
    strolling

-
  name: EntryIfTagged without attribute prints the inner content if an entry has any tag.
  template: <MTEntryIfTagged>has tags</MTEntryIfTagged>
  expected: has tags

-
  name: EntryIfTagged with an attribute "tag" prints the inner content if an entry has speciried tag.
  template: <MTEntryIfTagged tag="grandpa">tagged</MTEntryIfTagged>
  expected: tagged

-
  name: TagCount prints the number of entries that have been tagged with the current tag.
  template: |
    <MTTags>
      <MTTagName> (count <MTTagCount>)
    </MTTags>
  expected: |
    anemones (count 2)
    grandpa (count 1)
    rain (count 4)
    strolling (count 1)
    verse (count 5)

-
  name: TagCount prints the rank of the current tag.
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
  name: Entries with an attribute "tag=grandpa" lists all entries that have been tagged with the specified tag.
  template: |
    <MTEntries tag="grandpa">
      <MTEntryTitle />
    </MTEntries>
  expected: "A Rainy Day"

-
  name: Entries with an attribute "tag=verse" lists all entries that have been tagged with the specified tag.
  template: |
    <MTEntries tag="verse">
      <MTEntryTitle />
    </MTEntries>
  expected: |
    Verse 5
    Verse 4
    Verse 3
    Verse 2
    Verse 1

-
  name: AssetTags lists all tags in current asset context.
  template: |
    <MTAssetTags>
      <$MTTagLabel$>
    </MTAssetTags>
  expected: |
    alpha
    beta
    gamma
  stash:
    asset: $asset


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

