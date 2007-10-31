package MT::ObjectDriver::DDL::SQLite;

use strict;
use warnings;
use base qw( MT::ObjectDriver::DDL );

sub column_defs {
    my $ddl = shift; 
    my ($class) = @_;

    my $driver = $class->driver;
    my $dbh = $driver->r_handle;
    my $table_name = $class->table_name;
    my $field_prefix = $class->datasource;
    my $props = $class->properties;
    my $obj_defs = $class->column_defs;

    return undef unless $dbh;

    # Disable RaiseError if set, since the table we're about to describe
    # may not actually exist (in which case, the return value is undef,
    # signalling an nonexistent table to the caller).
    local $dbh->{RaiseError} = 0;
    my $sth = $dbh->prepare('SELECT * FROM ' . $table_name . ' LIMIT 1')
        or return undef;
    $sth->execute or return undef;
    my $fields = $sth->{'NUM_OF_FIELDS'};
    my $coltypes = $sth->{'TYPE'};
    my $name = $sth->{'NAME'};
    my $null = $sth->{'NULLABLE'};
    #my $skip_null_checks;
    #if (!$null || !@$null) {
    #    $skip_null_checks = 1;
    #}
    my $defs = {};
    foreach (my $col = 0; $col < $fields; $col++) {
        my $colname = lc $name->[$col];
        $colname =~ s/^\Q$field_prefix\E_//i;
        my $coltype = $ddl->db2type($coltypes->[$col]);
        if ($coltypes->[$col] =~ m/\((\d+)\)/) {
            $defs->{$colname}{size} = $1;
        }
        $defs->{$colname}{type} = $coltype;
        if ($colname =~ m/_id$/) {
            $defs->{$colname}{key} = 1;
        }
        if ( $coltype eq 'integer' && $defs->{$colname}{key} ) {
            # with sqlite, integer primary keys auto increment. always.
            $defs->{$colname}{auto} = 1;
        }
        #if ($skip_null_checks) {
            $defs->{$colname}{not_null} = $obj_defs->{$colname}{not_null};
        #} else {
        #    if ( (defined $null->[$col]) && ($null->[$col] == 0) ) {
        #        $defs->{$colname}{not_null} = 1;
        #    }
        #}
    }
    $sth->finish;
    return $defs;
}

sub db2type {
    my $ddl = shift;
    my ($db_type) = @_;
    $db_type =~ s/\(\d+\)//g;
    if ($db_type eq 'varchar') {
        $db_type = 'string';
    }
    return $db_type;
}

sub type2db {
    my $ddl = shift;
    my ($def) = @_;
    my $type = $def->{type};
    if ($type eq 'string') {
        $type = 'varchar(' . $def->{size} . ')';
    }
    return $type;
}

1;
