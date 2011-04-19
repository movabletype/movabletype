# $Id$

package Data::ObjectDriver::Driver::DBD::mysql;
use strict;
use warnings;
use base qw( Data::ObjectDriver::Driver::DBD );

use Carp qw( croak );
use Data::ObjectDriver::Errors;

use constant ERROR_MAP => {
    1062 => Data::ObjectDriver::Errors->UNIQUE_CONSTRAINT,
};

sub fetch_id { $_[3]->{mysql_insertid} || $_[3]->{insertid} }

sub map_error_code {
    my $dbd = shift;
    my($code, $msg) = @_;
    return if !defined $code;
    return ERROR_MAP->{$code};
}

sub sql_for_unixtime {
    return "UNIX_TIMESTAMP()";
}

# yes, MySQL supports LIMIT on a DELETE
sub can_delete_with_limit { 1 }

# yes, MySQL makes every search case insensitive
sub is_case_insensitive { 1 };

# yes, MySQL invented(?) REPLACE INTO extension
sub can_replace { 1 }


sub bulk_insert {
    my $dbd = shift;
    my $dbh = shift;
    my $table = shift;

    my $cols = shift;
    my $rows_ref = shift;

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

    return $dbh->do($sql, undef, map { @$_ } @$rows_ref);
}

1;
