# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Template::Tags::Score;

use strict;
use warnings;

# FIXME: should this routine return an empty string?
sub _object_score_for {
    my ( $stash_key, $ctx, $args, $cond ) = @_;
    my $key = $args->{namespace};
    return '' unless $key;
    my $object = $ctx->stash($stash_key);
    return '' unless $object;
    my $score = $object->score_for($key);
    if ( !$score && exists( $args->{default} ) ) {
        return $args->{default};
    }
    return $ctx->count_format( $score, $args );
}

###########################################################################

=head2 EntryScore

A function tag that provides total score of the entry in context. Scores
grouped by namespace of a plugin are summed to calculate total score of an
entry.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for score to be calculated. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:EntryScore namespace="FiveStarRating"$>

=for tags entries, scoring

=cut

sub _hdlr_entry_score {
    return _object_score_for( 'entry', @_ );
}

###########################################################################

=head2 AssetScore

A function tag that provides total score of the asset in context. Scores
grouped by namespace of a plugin are summed to calculate total score of an
asset.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for score to be calculated. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:AssetScore namespace="FiveStarRating"$>

=for tags assets, scoring

=cut

sub _hdlr_asset_score {
    return _object_score_for( 'asset', @_ );
}

###########################################################################

=head2 AuthorScore

A function tag that provides total score of the author in context. Scores
grouped by namespace of a plugin are summed to calculate total score of an
author.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for score to be calculated. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:AuthorScore namespace="FiveStarRating"$>

=for tags authors, scoring

=cut

sub _hdlr_author_score {
    return _object_score_for( 'author', @_ );
}

sub _object_score_high {
    my ( $stash_key, $ctx, $args, $cond ) = @_;
    my $key = $args->{namespace};
    return '' unless $key;
    my $object = $ctx->stash($stash_key);
    return '' unless $object;
    return $object->score_high($key);
}

###########################################################################

=head2 EntryScoreHigh

A function tag that provides the highest score of the entry in context.
Scorings grouped by namespace of a plugin are sorted to find the highest
score of an entry.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for score to be calculated. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:EntryScoreHigh namespace="FiveStarRating"$>

=for tags entries, scoring

=cut

sub _hdlr_entry_score_high {
    return _object_score_high( 'entry', @_ );
}

###########################################################################

=head2 AssetScoreHigh

A function tag that provides the highest score of the asset in context.
Scorings grouped by namespace of a plugin are sorted to find the
highest score of an asset.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the score to be sorted. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:AssetScoreHigh namespace="FiveStarRating"$>

=for tags assets, scoring

=cut

sub _hdlr_asset_score_high {
    return _object_score_high( 'asset', @_ );
}

###########################################################################

=head2 AuthorScoreHigh

A function tag that provides the highest score of the author in context.
Scorings grouped by namespace of a plugin are sorted to find the
highest score of an author.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the score to be sorted. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:AuthorScoreHigh namespace="FiveStarRating"$>

=for tags authors, scoring

=cut

sub _hdlr_author_score_high {
    return _object_score_high( 'author', @_ );
}

sub _object_score_low {
    my ( $stash_key, $ctx, $args, $cond ) = @_;
    my $key = $args->{namespace};
    return '' unless $key;
    my $object = $ctx->stash($stash_key);
    return '' unless $object;
    return $object->score_low($key);
}

###########################################################################

=head2 EntryScoreLow

A function tag that provides the lowest score of the entry in context.
Scorings grouped by namespace of a plugin are sorted to find the
lowest score of an entry.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the score to be sorted. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:EntryScoreLow namespace="FiveStarRating"$>

=for tags entries, scoring

=cut

sub _hdlr_entry_score_low {
    return _object_score_low( 'entry', @_ );
}

###########################################################################

=head2 AssetScoreLow

A function tag that provides the lowest score of the asset in context.
Scorings grouped by namespace of a plugin are sorted to find the lowest
score of an asset.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the score to be sorted. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:AssetScoreLow namespace="FiveStarRating"$>

=for tags assets, scoring

=cut

sub _hdlr_asset_score_low {
    return _object_score_low( 'asset', @_ );
}

###########################################################################

=head2 AuthorScoreLow

A function tag that provides the lowest score of the author in context.
Scorings grouped by namespace of a plugin are sorted to find the lowest
score of an author.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the score to be sorted. Namespace is defined by each
plugin which leverages rating API.

=back

B<Example:>

    <$mt:AuthorScoreLow namespace="FiveStarRating"$>

=for tags authors, scoring

=cut

sub _hdlr_author_score_low {
    return _object_score_low( 'author', @_ );
}

# FIXME: should this routine return an empty string?
sub _object_score_avg {
    my ( $stash_key, $ctx, $args, $cond ) = @_;
    my $key = $args->{namespace};
    return '' unless $key;
    my $object = $ctx->stash($stash_key);
    return '' unless $object;
    my $avg = $object->score_avg($key);
    return $ctx->count_format( $avg, $args );
}

###########################################################################

=head2 EntryScoreAvg

A function tag that provides the avarage score of the entry in context. Scores
grouped by namespace of a plugin are summed to calculate total score of an
entry, and average is calculated by dividing the total score by the number of
scorings or 'votes'.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for avarage score to be calculated. Namespace is defined by
each plugin which leverages rating API.

=back

B<Example:>

    <$mt:EntryScoreAvg namespace="FiveStarRating"$>

=for tags entries, scoring

=cut

sub _hdlr_entry_score_avg {
    return _object_score_avg( 'entry', @_ );
}

###########################################################################

=head2 AssetScoreAvg

A function tag that provides the avarage score of the asset in context.
Scores grouped by namespace of a plugin are summed to calculate total
score of an asset, and average is calculated by dividing the total
score by the number of scorings or 'votes'.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for avarage score to be calculated. Namespace is defined by
each plugin which leverages rating API.

=back

B<Example:>

    <$mt:AssetScoreAvg namespace="FiveStarRating"$>

=for tags assets, scoring

=cut

sub _hdlr_asset_score_avg {
    return _object_score_avg( 'asset', @_ );
}

###########################################################################

=head2 AuthorScoreAvg

A function tag that provides the avarage score of the author in context.
Scores grouped by namespace of a plugin are summed to calculate total score of
an author, and average is calculated by dividing the total score by the number
of scorings or 'votes'.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for avarage score to be calculated. Namespace is defined by
each plugin which leverages rating API.

=back

B<Example:>

    <$mt:AuthorScoreAvg namespace="FiveStarRating"$>

=for tags authors, scoring

=cut

sub _hdlr_author_score_avg {
    return _object_score_avg( 'author', @_ );
}

# FIXME: should this routine return an empty string?
sub _object_score_count {
    my ( $stash_key, $ctx, $args, $cond ) = @_;
    my $key = $args->{namespace};
    return '' unless $key;
    my $object = $ctx->stash($stash_key);
    return '' unless $object;
    my $count = $object->vote_for($key);
    return $ctx->count_format( $count, $args );
}

###########################################################################

=head2 EntryScoreCount

A function tag that provides the number of scorings or 'votes' made to the
entry in context. Scorings grouped by namespace of a plugin are summed.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the number of scorings to be calculated. Namespace is
defined by each plugin which leverages rating API.

=back

B<Example:>

    <$mt:EntryScoreCount namespace="FiveStarRating"$>

=for tags entries, scoring

=cut

sub _hdlr_entry_score_count {
    return _object_score_count( 'entry', @_ );
}

###########################################################################

=head2 AssetScoreCount

A function tag that provides the number of scorings or 'votes' made to the
asset in context. Scorings grouped by namespace of a plugin are summed.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the number of scorings to be calculated. Namespace is
defined by each plugin which leverages rating API.

=back

B<Example:>

    <$mt:AssetScoreCount namespace="FiveStarRating"$>

=for tags assets, scoring

=cut

sub _hdlr_asset_score_count {
    return _object_score_count( 'asset', @_ );
}

###########################################################################

=head2 AuthorScoreCount

A function tag that provides the number of scorings or 'votes' made to the
author in context. Scorings grouped by namespace of a plugin are summed.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for the number of scorings to be calculated. Namespace is
defined by each plugin which leverages rating API.

=back

B<Example:>

    <$mt:AuthorScoreCount namespace="FiveStarRating"$>

=for tags authors, scoring

=cut

sub _hdlr_author_score_count {
    return _object_score_count( 'author', @_ );
}

sub _object_rank {
    my ( $stash_key, $dbd_args, $ctx, $args, $cond ) = @_;
    my $key = $args->{namespace};
    return '' unless $key;
    my $object = $ctx->stash($stash_key);
    return '' unless $object;
    return $object->rank_for( $key, $args->{max}, $dbd_args );
}

###########################################################################

=head2 EntryRank

A function tag which returns a number from 1 to 6 (by default) which
represents the rating of the entry in context in terms of total
score where '1' is used for the highest score, '6' for the lowest score.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for rank to be calculated. Namespace is defined by each plugin which leverages rating API.

=item * max (optional; default "6")

Allows a user to specify the upper bound of the scale.

=back

B<Example:>

    <$mt:EntryRank namespace="FiveStarRating"$>

=for tags entries, scoring

=cut

sub _hdlr_entry_rank {
    return _object_rank(
        'entry',
        {   'join' => MT->model('entry')->join_on(
                undef,
                {   id     => \'= objectscore_object_id',
                    status => MT::Entry::RELEASE()
                }
            )
        },
        @_
    );
}

###########################################################################

=head2 AssetRank

A function tag which returns a number from 1 to 6 (by default) which
represents the rating of the asset in context in terms of total score where
'1' is used for the highest score, '6' for the lowest score.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for rank to be calculated. Namespace is defined by each plugin which leverages rating API.

=item * max (optional; default "6")

Allows a user to specify the upper bound of the scale.

=back

B<Example:>

    <$mt:AssetRank namespace="FiveStarRating"$>

=for tags assets, scoring

=cut

sub _hdlr_asset_rank {
    return _object_rank( 'asset', {}, @_ );
}

###########################################################################

=head2 AuthorRank

A function tag which returns a number from 1 to 6 (by default) which
represents the rating of the author in context in terms of total score where
'1' is used for the highest score, '6' for the lowest score.

B<Attributes:>

=over 4

=item * namespace (required)

Specify namespace for rank to be calculated. Namespace is defined by each plugin which leverages rating API.

=item * max (optional; default "6")

Allows a user to specify the upper bound of the scale.

=back

B<Example:>

    <$mt:AuthorRank namespace="FiveStarRating"$>

=for tags authors, scoring

=cut

sub _hdlr_author_rank {
    return _object_rank( 'author', {}, @_ );
}

1;
