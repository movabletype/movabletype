# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::ObjectDriver::DDL::SQLite;

use strict;
use warnings;
use base qw( MT::ObjectDriver::DDL );

sub index_defs {
    my $ddl = shift;
    my ($class) = @_;
    my $driver = $class->driver;
    my $dbh = $driver->r_handle;
    my $field_prefix = $class->datasource;
    my $table_name = $class->table_name;
    my $sth = $dbh->prepare(<<SQL)
SELECT name, sql
FROM sqlite_master
WHERE type = "index"
AND tbl_name="$table_name"
SQL
        or return undef;
    $sth->execute or return undef;

    my $defs = {};
    while (my $row = $sth->fetchrow_hashref) {
        my $key = $row->{'name'};
        next unless $key =~ m/^(mt_)?\Q$field_prefix\E_/;
        next if $key =~ m/(.+autoindex)/;
        my $sql = $row->{'sql'}
            or next;

        $key =~ s/^mt_\Q$field_prefix\E_//;
        my $cols = [];
        my $is_unique = 0;
        my $idx_columns;
        if ( $sql =~ m/CREATE( UNIQUE)? INDEX (?:.+?) ON $table_name \((.+?)\)/i ) {
            $is_unique = $1 ? 'unique' eq lc($1) : 0;
            $idx_columns = $2;
            for my $col ( split ',', $idx_columns ) {
                $col =~ s/^\Q$field_prefix\E_//;
                push @$cols, $col;
            }
        }
        unless ( $is_unique ) {
            # Check constraints to identify unique index
            my $sth_tbl = $dbh->prepare(<<TBLSQL);
SELECT name, sql FROM sqlite_master
WHERE type = "table" AND name = "$table_name"
TBLSQL
            $sth_tbl->execute or next;
            my $rows_tbl = $sth_tbl->fetchall_hashref('name');
            $sth_tbl->finish;
            my $sql_tbl = $rows_tbl->{$table_name}->{'sql'}
                or next;
            my $idx_name = $row->{'name'};
            if ( $sql_tbl =~ m/CONSTRAINT\s+$idx_name\s+UNIQUE\s+\(\s*$idx_columns\s*\)/im ) {
                $is_unique = 1;
            }
        }

        if ( $is_unique ) {
            $defs->{$key} = { 'unique' => 1, 'columns' => $cols };
        }
        else {
            if ((@$cols == 1) && ($key eq $cols->[0])) {
                $defs->{$key} = 1;
            } else {
                $defs->{$key} = { 'columns' => $cols };
            }
        }

    }
    $sth->finish;
    return undef unless %$defs;

    return $defs;
}

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
        if ( exists $obj_defs->{$colname} ) {
            $defs->{$colname}{not_null} = $obj_defs->{$colname}{not_null};
        }
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
    my $type = (ref($def) eq 'HASH') ? $def->{type} : $def;
    if ($type eq 'string') {
        $type = 'varchar(' . $def->{size} . ')';
    }
    return $type;
}

sub can_add_constraint { 0 }

sub unique_constraint_sql {
    my $ddl = shift;
    my ($class) = @_;

    my $table_name = $class->table_name;
    my $props = $class->properties;
    my $field_prefix = $class->datasource;
    my $indexes = $props->{indexes};

    my @stmts;
    if ($indexes) {
        # FIXME: Handle possible future primary key tuple case
        my $pk = $props->{primary_key};
        foreach my $name (keys %$indexes) {
            next if $pk && $name eq $pk;
            if (ref $indexes->{$name} eq 'HASH') {
                my $idx_info = $indexes->{$name};
                next unless exists($idx_info->{unique}) && $idx_info->{unique};
                my $column_list = $idx_info->{columns} || [ $name ];
                my $columns = '';
                foreach my $col (@$column_list) {
                    $columns .= ',' unless $columns eq '';
                    $columns .= $field_prefix . '_' . $col;
                }
                if ($columns) {
                    push @stmts, "CONSTRAINT ${table_name}_$name UNIQUE ($columns)";
                }
            }
        }
    }
    if (@stmts) {
        return ',' . join("\n", @stmts);
    }
    return q();
}

sub drop_index_sql {
    my $ddl = shift;
    my ($class, $key) = @_;
    my $table_name = $class->table_name;

    my $props = $class->properties;
    my $indexes = $props->{indexes};
    return q() unless exists($indexes->{$key});

    return "DROP INDEX ${table_name}_$key";
}

1;
