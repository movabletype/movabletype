# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::ObjectDriver::DDL::Pg;

use strict;
use warnings;
use base qw( MT::ObjectDriver::DDL );

sub can_add_column { 1 }
sub can_drop_column { 1 }
sub can_alter_column { 0 }

sub column_defs {
    my $ddl = shift;
    my ($class) = @_;

    my $table_name = $class->table_name;
    my $field_prefix = $class->datasource;
    my $dbh = $class->driver->r_handle;
    return undef unless $dbh;

    local $dbh->{RaiseError} = 0;
    my $attr = $dbh->func($table_name, 'table_attributes') or return undef;
    return undef unless @$attr;

    my $defs = {};
    foreach my $col (@$attr) {
        my $coltype = $ddl->db2type($col->{TYPE});
        my $colname = lc $col->{NAME};
        $colname =~ s/^\Q$field_prefix\E_//i;
        $defs->{$colname}{type} = $coltype;
        if ( $coltype eq 'string') {
            if (defined $col->{SIZE}) {
                $defs->{$colname}{size} = $col->{SIZE};
            } else {
                $defs->{$colname}{type} = 'text';
            }
        }
        if ( $col->{NOTNULL} ) {
            $defs->{$colname}{not_null} = 1;
        }
        if ( $col->{PRIMARY_KEY} ) {
            $defs->{$colname}{key} = 1;
        }
    }
    $defs;
}

sub drop_sequence {
    my $ddl = shift;
    my ($class) = @_;
    my $driver = $class->driver;
    my $dbh = $driver->rw_handle;

    # do this, but ignore error since it usually means the
    # sequence didn't exist to begin with
    my $def = $class->column_def('id');
    if ($def->{type} eq 'integer') {
        my $seq = $driver->dbd->sequence_name($class);
        local $dbh->{RaiseError} = 0;
        $dbh->do('DROP SEQUENCE ' . $seq);
    }
    1;
}

sub create_sequence {
    my $ddl = shift;
    my ($class) = @_;

    my $driver = $class->driver;
    my $dbh = $driver->rw_handle;

    my $def = $class->column_def('id');
    if ($def->{type} eq 'integer') {
        my $seq = $driver->dbd->sequence_name($class);
        my $table_name = $class->table_name;
        my $field_prefix = $class->datasource;
        my $max_sql = 'SELECT MAX(' . $field_prefix . '_id) FROM ' . $table_name;
        my ($start) = $dbh->selectrow_array($max_sql);

        $dbh->do('CREATE SEQUENCE ' . $seq . 
            ($start ? (' START ' . ($start + 1)) : ''));
    }
    1;
}

sub type2db {
    my $ddl = shift;
    my ($def) = @_;
    my $type = $def->{type};
    if ($type eq 'string') {
        return 'varchar(' . $def->{size} . ')';
    } elsif ($type eq 'smallint' ) {
        return 'smallint';
    } elsif ($type eq 'boolean') { 
        return 'smallint';
    } elsif ($type eq 'datetime') {
        return 'timestamp';
    } elsif ($type eq 'timestamp') {
        return 'timestamp';
    } elsif ($type eq 'integer') {
        return 'integer';
    } elsif ($type eq 'blob') {
        return 'bytea';
    } elsif ($type eq 'text') {
        return 'text';
    } elsif ($type eq 'float') {
        return 'float';
    }
    Carp::croak("undefined type: " . $type);
}

sub column_sql {
    my $ddl = shift;
    my ($class, $name) = @_;

    # ugly but we need to return the sql to express
    # a column differently based on whether we are declaring
    # the column for creating a table or for altering a column.
    # postgres 7.x does not support the 'not null' and 'default'
    # keywords when altering the column.
    if ((caller(1))[3] =~ m/::create_table_sql$/) {
        my $def = $class->column_def($name);
        return $ddl->SUPER::column_sql($class, $name);
    }

    my $field_prefix = $class->datasource;
    my $def = $class->column_def($name);
    my $type = $ddl->type2db($def);
    return $field_prefix . '_' . $name . ' ' . $type;
}

sub add_column_sql { 
    my $ddl = shift;
    my ($class, $name) = @_;
    my $sql = $ddl->column_sql($class, $name);
    my $driver = $class->driver;
    my $table_name = $class->table_name;
    my $field_prefix = $class->datasource;
    my $dbh = $driver->r_handle;
    my @stmt = ("ALTER TABLE $table_name ADD $sql");

    my $def = $class->column_def($name);
    my $default_value;
    if (exists $def->{default}) {
        $default_value = $def->{default};
        if (($def->{type} =~ m/time/) || $driver->dbd->is_date_col($name)) {
            $default_value = $dbh->quote($driver->dbd->ts2db($default_value));
        } elsif ($def->{type} !~ m/int|float|boolean/) {
            $default_value = $dbh->quote($default_value);
        }
        push @stmt, "ALTER TABLE $table_name ALTER COLUMN ${field_prefix}_${name} SET DEFAULT " . $default_value;
    }
    if ($def->{key}) {
        push @stmt, "ALTER TABLE $table_name ADD PRIMARY KEY (${field_prefix}_${name})";
    } elsif (($def->{not_null}) 
          && (70300 < $dbh->{pg_server_version})
          && (exists $def->{default})) {
          #postgresql under 7.3.0 does not support not null in alter table
          #plus,we can't set not null unless there are no rows contains null
        push @stmt, "UPDATE $table_name SET ${field_prefix}_${name} = $default_value WHERE ${field_prefix}_${name} IS NULL";
        push @stmt, "ALTER TABLE $table_name ALTER COLUMN ${field_prefix}_${name} SET NOT NULL";
    }
    return @stmt;
}

sub alter_column_sql {
    my $ddl = shift;
    my ($class, $name) = @_;
    my $sql = $ddl->SUPER::alter_column_sql(@_);
    $sql =~ s/\bMODIFY\b/ALTER COLUMN/;
    return $sql;
}

sub cast_column_sql {
    my $ddl = shift;
    my ($class, $name, $from_def) = @_;
    my $field_prefix = $class->datasource;
    my $def = $class->column_def($name);
    if (($from_def->{type} eq 'text') && ($def->{type} eq 'blob')) {
        return "cast(decode(${field_prefix}_$name, 'escape') as " . $ddl->type2db($def) . ')';
    } elsif (($from_def->{type} eq 'blob') && ($def->{type} eq 'text')) {
        return "cast(encode(${field_prefix}_$name, 'escape') as " . $ddl->type2db($def) . ')';
    } else {
        return "cast(${field_prefix}_$name as " . $ddl->type2db($def) . ')';
    }
}

1;
