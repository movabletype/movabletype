# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::ObjectScore;

use strict;
use base qw( MT::Object );

__PACKAGE__->install_properties({
    column_defs => {
        'id'           => 'integer not null auto_increment',
        'namespace'    => 'string(255) not null',
        'object_id'    => 'integer',
        'author_id'    => 'integer',
        'score'        => 'float',
        'object_ds'    => 'string(50) not null',
        'ip'           => 'string(16)',
    },
    indexes => {
        namespace => 1,
        object_id => 1,
        author_id => 1,
        ip        => 1,
    },
    defaults => {
        object_id => 0,
        author_id => 0,
    },
    audit => 1,
    datasource  => 'objectscore',
    primary_key => 'id',
});

sub class_label {
    MT->translate("Object Score");
}

sub class_label_plural {
    MT->translate("Object Scores");
}

sub scored_by {
    my $class = shift;
    my ($namespace, $user) = @_;
    MT::ObjectScore->load_iter({
        author_id => $user->id,
        defined($namespace) ? (namespace => $namespace) : (),
    });
}

1;
__END__

=head1 NAME

MT::Scorable - An interface for any MT::Object that wishes to be rated.

=head1 SYNOPSIS

    use MT::Entry;
    my $entry = MT::Entry->load($id);
    $entry->set_score('key', $app->user, 100, $overwrite);

=head1 METHODS

=head2 get_score($namespace, $user)

Return the score of the object, scored by the user specified.
This is not for total score of an object.  This is to get a score
specified by a user to an object.

=head2 set_score($namespace, $user, $score, $overwrite)

Set specified score to the object by the user.  If $overwrite argument
is false and the user has already scored the object before, error results.

=head2 score_for($namespace)

Return the total score of the object.

=head2 vote_for($namespace)

Return how many users scored to the object.

=head2 score_high($namespace)

Return the highest score to the object.

=head2 score_low($namespace)

Return the lowest score to the object.

=head2 score_avg($namespace)

Return the average score of the object.

=head2 rank_for($namespace, $max)

Return the rank of the object based on its score among other objects
of the same type.  The smaller the number is, the higher the object's rank is.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut

