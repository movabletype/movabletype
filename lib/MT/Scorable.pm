# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

# An interface for any MT::Object that wishes to utilize rating/scoring themselves

package MT::Scorable;

use strict;
use MT::ObjectScore;
use MT::Memcached;

use constant SCORE_CACHE_TIME => 7 * 24 * 60 * 60;    ## 1 week

sub install_properties {
    my $pkg = shift;
    my ($class) = @_;
    $class->add_trigger( post_remove => \&post_remove_score );
}

sub post_remove_score {
    my $class = shift;
    my ($obj) = @_;
    require MT::ObjectScore;
    MT::ObjectScore->remove({
        object_ds => $obj->datasource,
        object_id => $obj->id,
    });
}

sub get_score {
    my $obj = shift;
    my ( $namespace, $user ) = @_;

    my $term = {
        namespace => $namespace,
        object_id => $obj->id,
        author_id => $user->id,
        object_ds => $obj->datasource,
    };
    my $s = @{ $obj->_load_score_data($term) }[0] or return undef;
    $s->score;
}

sub set_score {
    my $obj = shift;
    my ( $namespace, $user, $score, $overwrite ) = @_;

    return $obj->error( MT->translate('Object must be saved first.') )
      unless $obj->id;

    my $mt = MT->instance;
    my $ip;
    if ( $mt->isa('MT::App') ) {
        $ip = $mt->remote_ip;
    }

    my $term = {
        namespace => $namespace,
        object_id => $obj->id,
        ( $ip ? ( ip => $ip ) : () ),
        ( $user ? ( author_id => $user->id ) : ( author_id => 0 ) ),
        object_ds => $obj->datasource,
    };
    my $s = @{ $obj->_load_score_data($term) }[0];
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
            "Could not set score to the object '[_1]'(ID: [_2])",
            $obj->datasource, $obj->id
        )
      );
    $obj->_flush_score_cache($term);
    return $s;
}

sub _get_objectscores {
    my $obj         = shift;
    my ($namespace) = @_;
    my $scores      = $obj->_load_score_data(
        {
            namespace => $namespace,
            object_id => $obj->id,
            object_ds => $obj->datasource,
        }
    );
    my $req = MT::Request->instance();
    $req->cache( $obj->datasource . '_scores_' . $obj->id . "_$namespace", $scores );
    return $scores;
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

sub votes_for {
    my $obj         = shift;
    my ($namespace) = @_;
    my $req         = MT::Request->instance();
    my $scores      = $req->stash( $obj->datasource . '_scores_' . $obj->id . "_$namespace" );
    unless ($scores) {
        $scores = $obj->_get_objectscores($namespace);
    }
    return scalar @$scores;
}
*vote_for = \&votes_for; # backward-compatible mapping for typo

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
    return q() unless $score || ( $score eq '0' );

    my $req   = MT::Request->instance();
    my $total = $req->stash( $obj->datasource . "_score_total_$namespace" );
    my $high  = $req->stash( $obj->datasource . "_score_high_$namespace" );
    my $low   = $req->stash( $obj->datasource . "_score_low_$namespace" );
    unless ( $total && $high && $low ) {
        my $term = {
            'object_ds' => $obj->datasource,
            'namespace' => $namespace,
        };
        ( $total, $high, $low ) = $obj->_load_rank_data( $term, $score, $dbd_args );
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

    if ( ( 0 < $total ) && ( $total < $max ) ) {
        $factor *= ( $total / $max );
    }

    my $level = int( log( $score - $low + 1 ) * $factor );
    $max - $level;
}

sub _cache_key {
    my $obj = shift;
    my ($term) = @_;
    my $key;
    if ( $term->{author_id} ) {
        $key = sprintf "%sscore%s-%d-%d", $term->{object_ds},
          $term->{namespace}, $term->{object_id}, $term->{author_id};
    }
    elsif ( $term->{object_id} ) {
        $key = sprintf "%sscore%s-%d", $term->{object_ds}, $term->{namespace},
          $term->{object_id};
    }
    else {
        $key = sprintf "%sscore%s", $term->{object_ds}, $term->{namespace};
    }
    return $key;
}

sub _load_score_data {
    my $obj    = shift;
    my ($term) = @_;
    my $cache  = MT::Memcached->instance;
    my $memkey = $obj->_cache_key($term);
    my $scores;
    $scores = $cache->get($memkey);
    unless ( $scores = $cache->get($memkey) ) {
        $scores = [ grep { defined } MT::ObjectScore->load($term) ];
        $cache->set( $memkey, $scores, SCORE_CACHE_TIME );
    }
    return $scores;
}

sub _load_rank_data {
    my $obj = shift;
    my ( $term, $score, $dbd_args ) = @_;
    my $cache  = MT::Memcached->instance;
    my $memkey = $obj->_cache_key($term);
    my $total  = $cache->get( $memkey . "_total" );
    my $high   = $cache->get( $memkey . "_high" );
    my $low    = $cache->get( $memkey . "_low" );
    unless ( $total && $high && $low ) {
        my $sgb_iter = MT::ObjectScore->sum_group_by(
            $term,
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
            $low = $score
              if ( ( $score || $score == 0 ) && ( $score < $low ) )
              || $low == 0;
            $high = $score
              if ( ( $score || $score == 0 ) && ( $score > $high ) );
            $score *= -1 if ( 0 > $score );
            $total += $score;
        }
        $cache->set( $memkey . "_total", $total, SCORE_CACHE_TIME );
        $cache->set( $memkey . "_high",  $high,  SCORE_CACHE_TIME );
        $cache->set( $memkey . "_low",   $high,  SCORE_CACHE_TIME );
    }

    return ( $total, $high, $low );
}

sub _flush_score_cache {
    my $obj    = shift;
    my ($term) = @_;
    my $memkey = $obj->_cache_key($term);
    MT::Memcached->instance->delete($memkey);
    delete $term->{author_id};
    $memkey = $obj->_cache_key($term);
    MT::Memcached->instance->delete($memkey);
    delete $term->{object_id};
    $memkey = $obj->_cache_key($term);
    MT::Memcached->instance->delete( $memkey . "_total" );
    MT::Memcached->instance->delete( $memkey . "_high" );
    MT::Memcached->instance->delete( $memkey . "_low" );
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

