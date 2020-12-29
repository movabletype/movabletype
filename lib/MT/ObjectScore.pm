# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ObjectScore;

use strict;
use warnings;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'        => 'integer not null auto_increment',
            'namespace' => 'string(100) not null',
            'object_id' => 'integer',
            'author_id' => 'integer',
            'score'     => 'float',
            'object_ds' => 'string(50) not null',
            'ip'        => 'string(50)',
        },
        indexes => {

            # usually used to remove all scores for a given object
            ds_obj => { columns => [ 'object_ds', 'object_id' ], },

            # common requests for scoring
            ns_user_ds_obj => {
                columns =>
                    [ 'namespace', 'author_id', 'object_ds', 'object_id' ],
            },

            # common requests for anonymous scoring (ip-based)
            ns_ip_ds_obj => {
                columns => [ 'namespace', 'ip', 'object_ds', 'object_id' ],
            },

            # for scored_by method
            user_ns => { columns => [ 'author_id', 'namespace' ], },
        },
        defaults => {
            object_id => 0,
            author_id => 0,
        },
        audit       => 1,
        datasource  => 'objectscore',
        primary_key => 'id',
    }
);

sub class_label {
    MT->translate("Object Score");
}

sub class_label_plural {
    MT->translate("Object Scores");
}

sub scored_by {
    my $class = shift;
    my ( $namespace, $user ) = @_;
    MT::ObjectScore->load_iter(
        {   author_id => $user->id,
            defined($namespace) ? ( namespace => $namespace ) : (),
        }
    );
}

sub score {
    my $objectscore = shift;
    if ( scalar @_ ) {
        $objectscore->{__orig_value}->{score} = $objectscore->score
            unless exists( $objectscore->{__orig_value}->{score} );
    }
    return $objectscore->column( 'score', @_ );
}

1;
__END__

=head1 NAME

MT::ObjectScore - A backend for MT::Scorable, An interface for any MT::Object that wishes to be rated.

=head1 USAGE

This class is used by L<MT::Scorable>, and not to be used directly

=head1 METHODS

=head2 MT::ObjectScore->class_label

Returns the localized descriptive name for this class.

=head2 MT::ObjectScore->class_label_plural

Returns the localized, plural descriptive name for this class.

=head2 MT::ObjectScore->scored_by($namespace, $user)

returns an iterator for all the scores made by $user. $user should be a MT::Author object,
and $namespace is a string describing the category of the scores, which can be undef 
for everything.

=head1 Fields

The following data fields are included in an ObjectScore object. access as any other 
MT::Object object

=over 4

=item * id

=item * author_id - who made this score

=item * namespace - a category of the score

=item * object_ds - which object type this score was made for?

=item * object_id - the ID of the said object

=item * score

=item * ip 

=back

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
