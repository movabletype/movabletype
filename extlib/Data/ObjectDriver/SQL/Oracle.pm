# $Id$
# Contributor(s): Xiaoou Wu <xiaoou.wu@oracle.com>
#
package Data::ObjectDriver::SQL::Oracle;

use strict;
use base qw(Data::ObjectDriver::SQL);

## Oracle doesn't have the LIMIT clause.
sub as_limit {
    return '';
}

## Override as_sql to emulate the LIMIT clause.
sub as_sql {
    my $stmt   = shift;
    my $limit  = $stmt->limit;
    my $offset = $stmt->offset;

    if (defined $limit && defined $offset) {
        my @fields = $stmt->select;
        push @fields, "ROW_NUMBER() OVER (ORDER BY 1) R";
    }

    my $sql = $stmt->SUPER::as_sql(@_);

    if (defined $limit) {
        $sql = "SELECT * FROM ( $sql ) WHERE ";
        if (defined $offset) {
            $sql = $sql . " R BETWEEN $offset + 1 AND $limit + $offset";
        } else {
            $sql = $sql . " rownum <= $limit";
        }
    }
    return $sql;
}

1;

__END__

=head1 NAME

Data::ObjectDriver::SQL::Oracle

=head1 DESCRIPTION

This module overrides methods of the Data::ObjectDriver::SQL module
with Oracle specific implementation.

=head1 LICENSE

This module is free software;
you may redistribute and/or modify it under the same
terms as Perl itself.

=head1 AUTHOR & COPYRIGHT

This module is
copyright (c) 2009 Xiaoou Wu E<lt>xiaoou.wu@oracle.comE<gt>.
All rights reserved.

=cut
