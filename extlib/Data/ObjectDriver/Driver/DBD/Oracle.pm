# $Id$
# Contributor(s): Xiaoou Wu <xiaoou.wu@oracle.com>
#
package Data::ObjectDriver::Driver::DBD::Oracle;

use strict;

use base qw( Data::ObjectDriver::Driver::DBD );

use Data::ObjectDriver::SQL::Oracle;
use Data::ObjectDriver::Errors;
use DBD::Oracle qw(:ora_types);

sub init_dbh {
    my $dbd   = shift;
    my ($dbh) = @_;
    $dbh->{LongReadLen}      = 1024000;
    $dbh->{FetchHashKeyName} = 'NAME_lc';
    return bless $dbh, 'Data::ObjectDriver::Driver::DBD::Oracle::db';
}

sub bind_param_attributes {
    my ($dbd, $data_type) = @_;
    if ($data_type && $data_type eq 'blob') {
        return { ora_type => ORA_BLOB };
    }
    return;
}

sub map_error_code {
    my $dbd = shift;
    my($code, $msg) = @_;
    if ($msg && $msg =~ /ORA-00001/i) {
        return Data::ObjectDriver::Errors->UNIQUE_CONSTRAINT;
    } else {
        return;
    }
}

## Oracle doesn't support auto-increment, it needs a SEQUENCE to emulate
## this feature. For usage, please see NOTES.
sub fetch_id {
    my $dbd = shift;
    my ($class, $dbh, $sth, $driver) = @_;
    my $seq = $dbd->sequence_name($class, $driver);
    my ($last_insert_id) = $dbh->selectrow_array("SELECT $seq.CURRVAL "
                                                  . " FROM DUAL");
    return $last_insert_id;
}

sub sequence_name {
    my $dbd = shift;
    my ($class, $driver) = @_;
    my $datasource = $class ->datasource;
    my $prefix     = $driver->prefix;
    $datasource    = join('', $prefix, $datasource) if $prefix;
    join '_', $datasource,
              $dbd->db_column_name(
                $class->datasource,
                $class->properties->{primary_key},
              ),
              'seq';
}

sub bulk_insert {
    my $dbd      = shift;
    my $dbh      = shift;
    my $table    = shift;
    my $cols     = shift;
    my $rows_ref = shift;

    my $sql = "INSERT INTO $table("
              . join(',', @$cols)
              . ") VALUES ("
              . join(',',  map {'?'} @$cols)
              .  ")";
    my $sth = $dbh->prepare($sql);
    foreach my $row (@{ $rows_ref || []}) {
        $sth->execute(@$row);
    }
    return 1;
}

##
sub sql_class { 'Data::ObjectDriver::SQL::Oracle' }

package Data::ObjectDriver::Driver::DBD::Oracle::db;

use strict;

## Inherit the DB class from DBI::db.
use base qw(DBI::db);

## Oracle doesn't allow a SELECT statement without FROM.
sub _adjust_stmt {
    my $stmt = shift;
    my $has_select = ($stmt =~ m/^\s*SELECT\b/io);
    my $has_from   = ($stmt =~ m/\bFROM\b/io);
    $stmt .= " FROM DUAL" if ($has_select and !$has_from);
    return $stmt;
}

sub selectrow_array {
    my $self = shift;
    my $stmt  = shift;
    $stmt = _adjust_stmt($stmt);
    unshift @_, $stmt;
    $self->SUPER::selectrow_array(@_);
}

1;

__END__

=head1 NAME

Data::ObjectDriver::Driver::DBD::Oracle - Oracle Driver for Data::ObjectDriver

=head1 DESCRIPTION

This module overrides methods of the Data::ObjectDriver::Driver::DBD module
with Oracle specific implementation.

=head1 NOTES

Oracle doesn't support auto-increment, so before you use this feature, you
should create a sequence and a trigger to work with it.

For example, you want field ID in table WINES be auto-increment, then create:

    -- Create sequence
    CREATE SEQUENCE WINES_ID_SEQ
    MINVALUE 1
    MAXVALUE 999999999999999999999999999
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

    -- Create trigger
    CREATE OR REPLACE TRIGGER WINES_ID_TR
      BEFORE INSERT ON WINES
      FOR EACH ROW
    BEGIN
      SELECT WINES_ID_SEQ.NEXTVAL INTO :NEW.ID FROM DUAL;
    END;

=head1 LICENSE

This module is free software;
you may redistribute and/or modify it under the same
terms as Perl itself.

=head1 AUTHOR & COPYRIGHT

This module is
copyright (c) 2009 Xiaoou Wu E<lt>xiaoou.wu@oracle.comE<gt>.
All rights reserved.

=cut
