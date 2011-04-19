# $Id

package Data::ObjectDriver::Driver::DBD::SQLite;
use strict;
use warnings;
use base qw( Data::ObjectDriver::Driver::DBD );

use Data::ObjectDriver::Errors;

# yes according to http://www.sqlite.org/lang_replace.html
sub can_replace { 1 }

# SQLite has problems with prepare_cached
sub can_prepare_cached_statements { 0 }

sub fetch_id { $_[2]->func('last_insert_rowid') }

sub bind_param_attributes {
    my ($dbd, $data_type) = @_;
    if ($data_type) {
        if ($data_type eq 'blob') {
            return DBI::SQL_BLOB;
        } elsif ($data_type eq 'binchar') {
            return DBI::SQL_BINARY;
        }
    }
    return;
}

sub map_error_code {
    my $dbd = shift;
    my($code, $msg) = @_;
    if ($msg && $msg =~ /not unique/) {
        return Data::ObjectDriver::Errors->UNIQUE_CONSTRAINT;
    } else {
        return;
    }
}


sub bulk_insert {
    my $dbd = shift;
    my $dbh = shift;
    my $table = shift;

    my $cols = shift;
    my $rows_ref = shift;

    my $sql = "INSERT INTO $table("  . join(',', @{$cols}) . ") VALUES (" . join(',',  map {'?'} @{$cols}) .  ")\n";

    my $sth = $dbh->prepare($sql);

    foreach my $row (@{$rows_ref}) {
	$sth->execute(@{$row});
    }

    # For now just write all data, at some point we need to lookup the
    # maximum packet size for SQL
    return 1;
}

1;

=pod

=head1 NAME

Data::ObjectDriver::Driver::DBD::SQLite - SQLite driver

=head2 DESCRIPTION

This class provides an interface to the SQLite (L<http://sqlite.org>)
database through DBI.

=head2 NOTES & BUGS

This is experimental.

With the 1.11 version of L<DBD::SQLite> Blobs are handled transparently,
so C<bind_param_attributes> is optionnal.
With previous version of L<DBD::SQLite> users have experimented issues
with binary data in CHAR (partially solved by the DBI::SQL_BINARY binding).

=cut
