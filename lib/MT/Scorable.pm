# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

# An interface for any MT::Object that wishes to utilize rating/scoring themselves

package MT::Scorable;

use MT::ObjectScore;

sub get_score {
    my $obj = shift;
    my ( $namespace, $user ) = @_;

    my $term = {
        namespace => $namespace,
        object_id => $obj->id,
        author_id => $user->id,
        object_ds => $obj->datasource,
    };
    my $s = MT::ObjectScore->load($term);
    $s->score;
}

sub set_score {
    my $obj = shift;
    my ( $namespace, $user, $score, $overwrite ) = @_;

    my $term = {
        namespace => $namespace,
        object_id => $obj->id,
        author_id => $user->id,
        object_ds => $obj->datasource,
    };
    my $s = MT::ObjectScore->load($term);
    return $obj->error( MT->translate('Already scored for this object.') )
      if $s && !$overwrite;

    unless ($s) {
        $s = MT::ObjectScore->new;
        $s->set_values($term);
    }
    $s->score($score);
    $s->save
      or return $obj->error(
        MT->translate(
            'Can not set score to the object \'[_1]\'(ID: [_2])',
            $obj->datasource, $obj->id
        )
      );
    return $s;
}

sub _get_objectscores {
    my $obj         = shift;
    my ($namespace) = @_;
    my @scores      = MT::ObjectScore->load(
        {
            namespace => $namespace,
            object_id => $obj->id,
            object_ds => $obj->datasource,
        }
    );
    my $req = MT::Request->instance();
    $req->cache( $obj->datasource . '_scores_' . $obj->id . "_$namespace" , \@scores );
    return \@scores;
}

sub score_for {
    my $obj = shift;
    my ($namespace) = @_;

    my $req    = MT::Request->instance();
    my $scores = $req->stash( $obj->datasource . '_scores_' . $obj->id . "_$namespace" );
    unless ( $scores && @$scores ) {
        $scores = $obj->_get_objectscores($namespace);
    }
    return q() unless @$scores;
    my $sum = 0;
    $sum += $_->score for @$scores;
    return $sum;
}

sub vote_for {
    my $obj         = shift;
    my ($namespace) = @_;
    my $req         = MT::Request->instance();
    my $scores      = $req->stash( $obj->datasource . '_scores_' . $obj->id . "_$namespace" );
    unless ($scores) {
        $scores = $obj->_get_objectscores($namespace);
    }
    return scalar @$scores;
}

sub _score_top {
    my $obj = shift;
    my ( $namespace, $block ) = @_;
    my $req    = MT::Request->instance();
    my $scores = $req->stash( $obj->datasource . '_scores_' . $obj->id . "_$namespace" );
    unless ($scores) {
        $scores = $obj->_get_objectscores($namespace);
    }
    return 0 unless scalar @$scores;
    my @sorted = sort $block @$scores;
    return $sorted[0]->score;
}

sub score_high {
    my $obj = shift;
    my ($namespace) = @_;
    return $obj->_score_top(
        $namespace,
        sub {
            return ( $b->score ) - ( $a->score );
        }
    );
}

sub score_low {
    my $obj = shift;
    my ($namespace) = @_;
    return $obj->_score_top(
        $namespace,
        sub {
            return ( $a->score ) - ( $b->score );
        }
    );
}

sub score_avg {
    my $obj         = shift;
    my ($namespace) = @_;
    my $req         = MT::Request->instance();
    my $scores      = $req->stash( $obj->datasource . '_scores_' . $obj->id . "_$namespace" );
    unless ($scores) {
        $scores = $obj->_get_objectscores($namespace);
    }
    my $count = scalar @$scores;
    return 0 unless $count;
    my $sum = 0;
    $sum += $_->score for @$scores;
    return sprintf( "%.2f", ( $sum / $count ) );
}

sub rank_for {
    my $obj = shift;
    my ( $namespace, $max, $dbd_args ) = @_;
    $max = 6 unless defined $max;
    my $score = $obj->score_for($namespace);
    return q() unless $score || ($score eq '0');

    my $req   = MT::Request->instance();
    my $total = $req->stash( $obj->datasource . "_score_total_$namespace" );
    my $high  = $req->stash( $obj->datasource . "_score_high_$namespace" );
    my $low   = $req->stash( $obj->datasource . "_score_low_$namespace" );
    unless ( $total && $high && $low ) {
        my $sgb_iter = MT::ObjectScore->sum_group_by(
            {
                'object_ds' => $obj->datasource,
                'namespace' => $namespace,
            },
            {
                'sum' => 'score',
                group => ['object_id'],
                ( defined($dbd_args) && %$dbd_args ) ? (%$dbd_args) : (),
            }
        );
        $total = 0;
        $high  = 0;
        $low   = 0;

        while ( my ( $score, $object_id ) = $sgb_iter->() ) {
            $low = $score if ( ( $score || $score == 0 ) && ( $score < $low ) ) || $low == 0;
            $high = $score if ( ( $score || $score == 0 ) && ( $score > $high ) );
            $score *= -1 if ( 0 > $score );
            $total += $score;
        }
        $req->cache( $obj->datasource . "_score_total_$namespace", $total );
        $req->cache( $obj->datasource . "_score_high_$namespace",  $high );
        $req->cache( $obj->datasource . "_score_low_$namespace",   $low );
    }

    my $factor;

    if ( $high - $low == 0 ) {
        $low -= $max;
        $factor = 1;
    }
    else {
        $factor = ( $max - 1 ) / log( $high - $low + 1 );
    }

    if (( 0 < $total ) && ( $total < $max )) {
        $factor *= ( $total / $max );
    }

    my $level = int( log( $score - $low + 1 ) * $factor );
    $max - $level;
}

1;
__END__

=head1 NAME

MT::Scorable - An interface for any MT::Object that wishes to rated.

=head1 SYNOPSIS

    use MT::Entry;
    my $entry = MT::Entry->load($id);
    $entry->set_score('key', $app->user, 100, $overwrite);

=head1 METHODS

=head2 get_score($plugin_key, $user)

Return the score of the object, scored by the user specified.
This is not for total score of an object.  This is to get a score
specified by a user to an object.

=head2 set_score($plugin_key, $user, $score, $overwrite)

Set specified score to the object by the user.  If $overwrite argument
is false and the user has already scored the object before, error results.

=head2 score_for($plugin_key)

Return the total score of the object.

=head2 vote_for($plugin_key)

Return how many users scored to the object.

=head2 score_high($plugin_key)

Return the highest score to the object.

=head2 score_low($plugin_key)

Return the lowest score to the object.

=head2 score_avg($plugin_key)

Return the average score of the object.

=head2 rank_for($plugin_key, $max)

Return the rank of the object based on its score among other objects
of the same type.  The smaller the number is, the higher the object's rank is.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut

