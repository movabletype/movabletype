# $Id$

package Data::ObjectDriver::Driver::DBD::MariaDB;
use strict;
use warnings;
use Carp;
use base qw( Data::ObjectDriver::Driver::DBD::mysql );

sub fetch_id { $_[3]->{mariadb_insertid} || $_[3]->{insertid} }

sub bind_param_attributes {
    my ($dbd, $data_type) = @_;
    if ($data_type) {
        if ($data_type eq 'blob') {
            return DBI::SQL_BINARY;
        } elsif ($data_type eq 'binchar') {
            return DBI::SQL_BINARY;
        }
    }
    return;
}

sub bulk_insert {
    my $dbd = shift;
    my $dbh = shift;
    my $table = shift;

    my $cols = shift;
    my $rows_ref = shift;
    my $attrs = shift || {};

    croak "Usage bulk_insert(dbd, dbh, table, columnref, rowsref)"
        unless (defined $dbd && defined $dbh && defined $table && defined $cols &&
                defined $rows_ref);

    return 0e0 if (scalar(@{$rows_ref}) == 0);

    my $sql = "INSERT INTO $table ("  . join(',', @{$cols}) . ") VALUES\n";

    my $one_data_row = "(" . (join ',', (('?') x @$cols)) . ")";
    my $ph = join ",", (($one_data_row) x @$rows_ref);
    $sql .= $ph;

    # For now just write all data, at some point we need to lookup the
    # maximum packet size for SQL

    if (%$attrs) {
        my $sth = $dbh->prepare($sql);
        my $i = 1;
        for my $row (@$rows_ref) {
            for (my $j = 0; $j < @$cols; $j++) {
                $sth->bind_param($i++, $row->[$j], $attrs->{$cols->[$j]});
            }
        }
        $sth->execute;
    } else {
        return $dbh->do($sql, undef, map { @$_ } @$rows_ref);
    }
}

1;
