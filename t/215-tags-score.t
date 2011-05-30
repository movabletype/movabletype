#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 289
  template: |
    <MTEntries lastn="10">
      <MTIf tag="MTEntryScoreCount" namespace="unit test">
        <MTEntryID> (score <MTEntryScore namespace="unit test">)
      </MTIf>
    </MTEntries>
  expected: |
    6 (score 2)
    5 (score 12)
    4 (score 5)

-
  name: test item 290
  template: |
    <MTEntries lastn="10">
      <MTIf tag="MTEntryScoreCount" namespace="unit test">
        <MTEntryID> (score <MTEntryScoreHigh namespace="unit test">)
      </MTIf>
    </MTEntries>
  expected: |
    6 (score 1)
    5 (score 5)
    4 (score 3)

-
  name: test item 291
  template: |
    <MTEntries lastn="10">
      <MTIf tag="MTEntryScoreCount" namespace="unit test">
        <MTEntryID> (score <MTEntryScoreLow namespace="unit test">)
      </MTIf>
    </MTEntries>
  expected: |
    6 (score 1)
    5 (score 3)
    4 (score 2)

-
  name: test item 292
  template: |
    <MTEntries lastn="10">
      <MTIf tag="MTEntryScoreCount" namespace="unit test">
        <MTEntryID> (score <MTEntryScoreAvg namespace="unit test">)
      </MTIf>
    </MTEntries>
  expected: |
    6 (score 1.00)
    5 (score 4.00)
    4 (score 2.50)

-
  name: test item 293
  template: |
    <MTEntries lastn="10">
      <MTIf tag="MTEntryScoreCount" namespace="unit test">
        <MTEntryID> (score <MTEntryScoreCount namespace="unit test">)
      </MTIf>
    </MTEntries>
  expected: |
    6 (score 2)
    5 (score 3)
    4 (score 2)

-
  name: test item 294
  template: |
    <MTEntries lastn="10">
      <MTIf tag="MTEntryScoreCount" namespace="unit test">
        <MTEntryID> (rank <MTEntryRank namespace="unit test">)
      </MTIf>
    </MTEntries>
  expected: |
    6 (rank 6)
    5 (rank 1)
    4 (rank 4)

-
  name: test item 295
  template: |
    <MTEntries lastn="10">
      <MTIf tag="MTEntryScoreCount" namespace="unit test">
        <MTEntryID> (rank <MTEntryRank max="10" namespace="unit test">)
      </MTIf>
    </MTEntries>
  expected: |
    6 (rank 10)
    5 (rank 1)
    4 (rank 5)

-
  name: test item 296
  template: |
    <MTEntries sort_by="score" namespace="unit test" min_score="1">
      <MTEntryID> (score <MTEntryScore namespace="unit test">)
    </MTEntries>
  expected: |
    5 (score 12)
    4 (score 5)
    6 (score 2)

-
  name: test item 297
  template: |
    <MTAssets lastn="10">
      <MTIf tag="MTAssetScoreCount" namespace="unit test">
        <MTAssetID> (score <MTAssetScore namespace="unit test">)
      </MTIf>
    </MTAssets>
  expected: |
    1 (score 12)
    2 (score 5)

-
  name: test item 298
  template: |
    <MTAssets lastn="10">
      <MTIf tag="MTAssetScoreCount" namespace="unit test">
        <MTAssetID> (score <MTAssetScoreHigh namespace="unit test">)
      </MTIf>
    </MTAssets>
  expected: |
    1 (score 5)
    2 (score 3)

-
  name: test item 299
  template: |
    <MTAssets lastn="10">
      <MTIf tag="MTAssetScoreCount" namespace="unit test">
        <MTAssetID> (score <MTAssetScoreLow namespace="unit test">)
      </MTIf>
    </MTAssets>
  expected: |
    1 (score 3)
    2 (score 2)

-
  name: test item 300
  template: |
    <MTAssets lastn="10">
      <MTIf tag="MTAssetScoreCount" namespace="unit test">
        <MTAssetID> (score <MTAssetScoreAvg namespace="unit test">)
      </MTIf>
    </MTAssets>
  expected: |
    1 (score 4.00)
    2 (score 2.50)

-
  name: test item 301
  template: |
    <MTAssets lastn="10">
      <MTIf tag="MTAssetScoreCount" namespace="unit test">
        <MTAssetID> (score <MTAssetScoreCount namespace="unit test">)
      </MTIf>
    </MTAssets>
  expected: |
    1 (score 3)
    2 (score 2)

-
  name: test item 302
  template: |
    <MTAssets lastn="10">
      <MTIfNonZero tag="MTAssetScoreCount" namespace="unit test">
        <MTAssetID> (rank <MTAssetRank namespace="unit test">)
      </MTIfNonZero>
    </MTAssets>
  expected: |
    1 (rank 1)
    2 (rank 6)

-
  name: test item 303
  template: |
    <MTAssets lastn="10">
      <MTIfNonZero tag="MTAssetScoreCount" namespace="unit test">
        <MTAssetID> (rank <MTAssetRank max="10" namespace="unit test">)
      </MTIfNonZero>
    </MTAssets>
  expected: |
    1 (rank 1)
    2 (rank 10)

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

