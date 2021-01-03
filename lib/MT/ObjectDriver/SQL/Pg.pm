# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ObjectDriver::SQL::Pg;

use strict;
use warnings;
use base qw( MT::ObjectDriver::SQL );

*distinct_stmt = \&MT::ObjectDriver::SQL::_subselect_distinct;

#--------------------------------------#
# Instance Methods

sub as_limit {
    my $stmt = shift;
    my $n    = $stmt->limit;
    my $o    = $stmt->offset || 0;
    $n = 'ALL' if !$n && $o;
    return '' unless $n;
    die "Non-numerics in limit/offset clause ($n, $o)"
        if ( $o =~ /\D/ ) || ( ( $n ne 'ALL' ) && ( $n =~ /\D/ ) );
    return sprintf "LIMIT %s%s\n", $n, ( $o ? " OFFSET " . int($o) : "" );
}

sub _mk_term {
    my $stmt = shift;
    my ( $col, $val ) = @_;

    if ( ref $val eq 'HASH' ) {
        if ( !exists $val->{op} ) {
            if ( exists $val->{like} ) {
                my $cols = $stmt->binary;
                if ( !$cols || !exists $cols->{$col} ) {
                    $val = { op => 'ILIKE', value => $val->{like} };
                }
            }
        }
    }

    $stmt->SUPER::_mk_term( $col, $val );
}

1;
