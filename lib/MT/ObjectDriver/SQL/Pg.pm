# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
    my $n = $stmt->limit;
    my $o = $stmt->offset || 0;
    $n = 'ALL' if !$n && $o;
    return '' unless $n;
    die "Non-numerics in limit/offset clause ($n, $o)" if ($o =~ /\D/) || (($n ne 'ALL') && ($n =~ /\D/));
    return sprintf "LIMIT %s%s\n", $n,
           ($o ? " OFFSET " . int($o) : "");
}

1;
