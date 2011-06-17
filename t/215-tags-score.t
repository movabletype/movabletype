#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;


my $mt     = MT->instance;
my %scores = (
    'comment' => {
        1 => [
            {   author_id => 1,
                score     => 1,
            },
            {   author_id => 2,
                score     => 2,
            },
        ],
        2 => [
            {   author_id => 1,
                score     => 5,
            },
        ],
    },
    'tbping' => {
        1 => [
            {   author_id => 1,
                score     => 1,
            },
            {   author_id => 2,
                score     => 2,
            },
        ],
        3 => [
            {   author_id => 1,
                score     => 5,
            },
        ],
    },
);
while ( my ( $key, $values ) = each(%scores) ) {
    while ( my ( $id, $scores ) = each(%$values) ) {
        my $obj = $mt->model($key)->load($id);
        foreach my $s (@$scores) {
            $obj->set_score( 'unit test',
                $mt->model('author')->load( $s->{author_id} ),
                $s->{score}, 1 );
            $obj->save;
        }
    }
}


run_tests_by_data();
__DATA__
-
  name: EntryScoreCount prints the entry's score count of specified namespace.
  template: |
    <MTEntries lastn="10">
      <MTEntryID> (count <MTEntryScoreCount namespace="unit test">)
    </MTEntries>
  expected: |
    1 (count 0)
    8 (count 0)
    7 (count 0)
    6 (count 2)
    5 (count 3)
    4 (count 2)

-
  name: EntryScore prints the entry's score of specified namespace.
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
  name: EntryScoreHigh prints the entry's highest score of specified namespace.
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
  name: EntryScoreLow prints the entry's lowest score of specified namespace.
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
  name: EntryScoreAvg prints the entry's average score of specified namespace.
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
  name: EntryRank prints the entry's rank of specified namespace.
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
  name: EntryRank prints the entry's rank that is normalized within the range of "max" of specified namespace.
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
  name: Entries with attributes "sort_by=score", "namespace" and "min_score" lists the entries that is sorted by score with more than specified score.
  template: |
    <MTEntries sort_by="score" namespace="unit test" min_score="1">
      <MTEntryID> (score <MTEntryScore namespace="unit test">)
    </MTEntries>
  expected: |
    5 (score 12)
    4 (score 5)
    6 (score 2)

-
  name: AssetScoreCount prints the asset's score count of specified namespace.
  template: |
    <MTAssets lastn="10">
      <MTAssetID> (count <MTAssetScoreCount namespace="unit test">)
    </MTAssets>
  expected: |
    1 (count 3)
    2 (count 2)

-
  name: AssetScore prints the asset's score of specified namespace.
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
  name: AssetScoreHigh prints the asset's highest score of specified namespace.
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
  name: AssetScoreLow prints the asset's lowest score of specified namespace.
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
  name: AssetScoreAvg prints the asset's average score of specified namespace.
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
  name: AssetRank prints the asset's rank of specified namespace.
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
  name: AssetRank prints the asset's rank that is normalized within the range of "max" of specified namespace.
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
  name: Assets with attributes "sort_by=score", "namespace" and "min_score" lists the assets that is sorted by score with more than specified score.
  template: |
    <MTAssets sort_by="score" namespace="unit test" min_score="1" sort_order="ascend">
      <MTAssetID> (score <MTAssetScore namespace="unit test">)
    </MTAssets>
  expected: |
    2 (score 5)
    1 (score 12)

-
  name: CommentScoreCount prints the comment's score count of specified namespace.
  template: |
    <MTComments lastn="10">
      <MTCommentID> (count <MTCommentScoreCount namespace="unit test">)
    </MTComments>
  expected: |
    13 (count 0)
    6 (count 0)
    1 (count 2)
    12 (count 0)
    11 (count 0)
    15 (count 0)
    14 (count 0)
    3 (count 0)
    2 (count 1)

-
  name: CommentScore prints the comment's score of specified namespace.
  template: |
    <MTComments lastn="10">
      <MTIf tag="MTCommentScoreCount" namespace="unit test">
        <MTCommentID> (score <MTCommentScore namespace="unit test">)
      </MTIf>
    </MTComments>
  expected: |
    1 (score 3)
    2 (score 5)

-
  name: CommentScoreHigh prints the comment's highest score of specified namespace.
  template: |
    <MTComments lastn="10">
      <MTIf tag="MTCommentScoreCount" namespace="unit test">
        <MTCommentID> (score <MTCommentScoreHigh namespace="unit test">)
      </MTIf>
    </MTComments>
  expected: |
    1 (score 2)
    2 (score 5)

-
  name: CommentScoreLow prints the comment's lowest score of specified namespace.
  template: |
    <MTComments lastn="10">
      <MTIf tag="MTCommentScoreCount" namespace="unit test">
        <MTCommentID> (score <MTCommentScoreLow namespace="unit test">)
      </MTIf>
    </MTComments>
  expected: |
    1 (score 1)
    2 (score 5)

-
  name: CommentScoreAvg prints the comment's average score of specified namespace.
  template: |
    <MTComments lastn="10">
      <MTIf tag="MTCommentScoreCount" namespace="unit test">
        <MTCommentID> (score <MTCommentScoreAvg namespace="unit test">)
      </MTIf>
    </MTComments>
  expected: |
    1 (score 1.50)
    2 (score 5.00)

-
  name: CommentRank prints the comment's rank of specified namespace.
  template: |
    <MTComments lastn="10">
      <MTIf tag="MTCommentScoreCount" namespace="unit test">
        <MTCommentID> (rank <MTCommentRank namespace="unit test">)
      </MTIf>
    </MTComments>
  expected: |
    1 (rank 6)
    2 (rank 1)

-
  name: CommentRank prints the comment's rank that is normalized within the range of "max" of specified namespace.
  template: |
    <MTComments lastn="10">
      <MTIf tag="MTCommentScoreCount" namespace="unit test">
        <MTCommentID> (rank <MTCommentRank max="10" namespace="unit test">)
      </MTIf>
    </MTComments>
  expected: |
    1 (rank 10)
    2 (rank 3)

-
  name: Comments with attributes "sort_by=score", "namespace" and "min_score" lists the comments that is sorted by score with more than specified score.
  template: |
    <MTComments sort_by="score" namespace="unit test" min_score="1">
      <MTCommentID> (score <MTCommentScore namespace="unit test">)
    </MTComments>
  expected: |
    1 (score 3)
    2 (score 5)

-
  name: AuthorScoreCount prints the author's score count of specified namespace.
  template: |
    <MTAuthors lastn="10">
      <MTAuthorID> (count <MTAuthorScoreCount namespace="unit test">)
    </MTAuthors>
  expected: |
    2 (count 1)
    3 (count 1)

-
  name: AuthorScore prints the author's score of specified namespace.
  template: |
    <MTAuthors lastn="10">
      <MTIf tag="MTAuthorScoreCount" namespace="unit test">
        <MTAuthorID> (score <MTAuthorScore namespace="unit test">)
      </MTIf>
    </MTAuthors>
  expected: |
    2 (score 2)
    3 (score 3)

-
  name: AuthorScoreHigh prints the author's highest score of specified namespace.
  template: |
    <MTAuthors lastn="10">
      <MTIf tag="MTAuthorScoreCount" namespace="unit test">
        <MTAuthorID> (score <MTAuthorScoreHigh namespace="unit test">)
      </MTIf>
    </MTAuthors>
  expected: |
    2 (score 2)
    3 (score 3)

-
  name: AuthorScoreLow prints the author's lowest score of specified namespace.
  template: |
    <MTAuthors lastn="10">
      <MTIf tag="MTAuthorScoreCount" namespace="unit test">
        <MTAuthorID> (score <MTAuthorScoreLow namespace="unit test">)
      </MTIf>
    </MTAuthors>
  expected: |
    2 (score 2)
    3 (score 3)

-
  name: AuthorScoreAvg prints the author's average score of specified namespace.
  template: |
    <MTAuthors lastn="10">
      <MTIf tag="MTAuthorScoreCount" namespace="unit test">
        <MTAuthorID> (score <MTAuthorScoreAvg namespace="unit test">)
      </MTIf>
    </MTAuthors>
  expected: |
    2 (score 2.00)
    3 (score 3.00)

-
  name: AuthorRank prints the author's rank of specified namespace.
  template: |
    <MTAuthors lastn="10">
      <MTIf tag="MTAuthorScoreCount" namespace="unit test">
        <MTAuthorID> (rank <MTAuthorRank namespace="unit test">)
      </MTIf>
    </MTAuthors>
  expected: |
    2 (rank 3)
    3 (rank 1)

-
  name: AuthorRank prints the author's rank that is normalized within the range of "max" of specified namespace.
  template: |
    <MTAuthors lastn="10">
      <MTIf tag="MTAuthorScoreCount" namespace="unit test">
        <MTAuthorID> (rank <MTAuthorRank max="10" namespace="unit test">)
      </MTIf>
    </MTAuthors>
  expected: |
    2 (rank 7)
    3 (rank 5)

-
  name: Authors with attributes "sort_by=score", "namespace" and "min_score" lists the authors that is sorted by score with more than specified score.
  template: |
    <MTAuthors sort_by="score" namespace="unit test" min_score="1">
      <MTAuthorID> (score <MTAuthorScore namespace="unit test">)
    </MTAuthors>
  expected: |
    3 (score 3)
    2 (score 2)

-
  name: PingScoreCount prints the ping's score count of specified namespace.
  template: |
    <MTPings lastn="10">
      <MTPingID> (count <MTPingScoreCount namespace="unit test">)
    </MTPings>
  expected: |
    1 (count 2)
    3 (count 1)

-
  name: PingScore prints the ping's score of specified namespace.
  template: |
    <MTPings lastn="10">
      <MTIf tag="MTPingScoreCount" namespace="unit test">
        <MTPingID> (score <MTPingScore namespace="unit test">)
      </MTIf>
    </MTPings>
  expected: |
    1 (score 3)
    3 (score 5)

-
  name: PingScoreHigh prints the ping's highest score of specified namespace.
  template: |
    <MTPings lastn="10">
      <MTIf tag="MTPingScoreCount" namespace="unit test">
        <MTPingID> (score <MTPingScoreHigh namespace="unit test">)
      </MTIf>
    </MTPings>
  expected: |
    1 (score 2)
    3 (score 5)

-
  name: PingScoreLow prints the ping's lowest score of specified namespace.
  template: |
    <MTPings lastn="10">
      <MTIf tag="MTPingScoreCount" namespace="unit test">
        <MTPingID> (score <MTPingScoreLow namespace="unit test">)
      </MTIf>
    </MTPings>
  expected: |
    1 (score 1)
    3 (score 5)

-
  name: PingScoreAvg prints the ping's average score of specified namespace.
  template: |
    <MTPings lastn="10">
      <MTIf tag="MTPingScoreCount" namespace="unit test">
        <MTPingID> (score <MTPingScoreAvg namespace="unit test">)
      </MTIf>
    </MTPings>
  expected: |
    1 (score 1.50)
    3 (score 5.00)

-
  name: PingRank prints the ping's rank of specified namespace.
  template: |
    <MTPings lastn="10">
      <MTIf tag="MTPingScoreCount" namespace="unit test">
        <MTPingID> (rank <MTPingRank namespace="unit test">)
      </MTIf>
    </MTPings>
  expected: |
    1 (rank 6)
    3 (rank 1)

-
  name: PingRank prints the ping's rank that is normalized within the range of "max" of specified namespace.
  template: |
    <MTPings lastn="10">
      <MTIf tag="MTPingScoreCount" namespace="unit test">
        <MTPingID> (rank <MTPingRank max="10" namespace="unit test">)
      </MTIf>
    </MTPings>
  expected: |
    1 (rank 10)
    3 (rank 3)

-
  name: Pings with attributes "sort_by=score", "namespace" and "min_score" lists the pings that is sorted by score with more than specified score.
  template: |
    <MTPings sort_by="score" namespace="unit test" min_score="1">
      <MTPingID> (score <MTPingScore namespace="unit test">)
    </MTPings>
  expected: |
    3 (score 5)
    1 (score 3)


######## EntryScore
## namespace (required)

######## CommentScore
## namespace (required)

######## PingScore
## namespace (required)

######## AssetScore
## namespace (required)

######## AuthorScore
## namespace (required)

######## EntryScoreHigh
## namespace (required)

######## CommentScoreHigh
## namespace (required)

######## PingScoreHigh
## namespace (required)

######## AssetScoreHigh
## namespace (required)

######## AuthorScoreHigh
## namespace (required)

######## EntryScoreLow
## namespace (required)

######## CommentScoreLow
## namespace (required)

######## PingScoreLow
## namespace (required)

######## AssetScoreLow
## namespace (required)

######## AuthorScoreLow
## namespace (required)

######## EntryScoreAvg
## namespace (required)

######## CommentScoreAvg
## namespace (required)

######## PingScoreAvg
## namespace (required)

######## AssetScoreAvg
## namespace (required)

######## AuthorScoreAvg
## namespace (required)

######## EntryScoreCount
## namespace (required)

######## CommentScoreCount
## namespace (required)

######## PingScoreCount
## namespace (required)

######## AssetScoreCount
## namespace (required)

######## AuthorScoreCount
## namespace (required)

######## EntryRank
## namespace (required)
## max (optional; default "6")

######## CommentRank
## namespace (required)
## max (optional; default "6")

######## PingRank
## namespace (required)
## max (optional; default "6")

######## AssetRank
## namespace (required)
## max (optional; default "6")

######## AuthorRank
## namespace (required)
## max (optional; default "6")

