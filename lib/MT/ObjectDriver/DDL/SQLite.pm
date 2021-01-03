# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ObjectDriver::DDL::SQLite;

use strict;
use warnings;
use base qw( MT::ObjectDriver::DDL );

sub index_defs {
    my $ddl          = shift;
    my ($class)      = @_;
    my $driver       = $class->driver;
    my $dbh          = $driver->r_handle;
    my $field_prefix = $class->datasource;
    my $table_name   = $class->table_name;
    my $sth          = $dbh->prepare(<<SQL)
SELECT name, sql
FROM sqlite_master
WHERE type = "index"
AND tbl_name="$table_name"
SQL
        or return undef;
    $sth->execute or return undef;

    my $defs = {};
    while ( my $row = $sth->fetchrow_hashref ) {
        my $key = $row->{'name'};
        next unless $key =~ m/^(mt_)?\Q$field_prefix\E_/;
        next if $key =~ m/(.+autoindex)/;
        my $sql = $row->{'sql'}
            or next;

        $key =~ s/^mt_\Q$field_prefix\E_//;
        my $cols      = [];
        my $is_unique = 0;
        my $idx_columns;
        if ( $sql
            =~ m/CREATE( UNIQUE)? INDEX (?:.+?) ON $table_name \((.+?)\)/i )
        {
            $is_unique = $1 ? 'unique' eq lc($1) : 0;
            $idx_columns = $2;
            for my $col ( split ',', $idx_columns ) {
                $col =~ s/^\Q$field_prefix\E_//;
                push @$cols, $col;
            }
        }
        unless ($is_unique) {

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
            if ( $sql_tbl
                =~ m/CONSTRAINT\s+$idx_name\s+UNIQUE\s+\(\s*$idx_columns\s*\)/im
                )
            {
                $is_unique = 1;
            }
        }

        if ($is_unique) {
            $defs->{$key} = { 'unique' => 1, 'columns' => $cols };
        }
        else {
            if ( ( @$cols == 1 ) && ( $key eq $cols->[0] ) ) {
                $defs->{$key} = 1;
            }
            else {
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

    my $driver       = $class->driver;
    my $dbh          = $driver->r_handle;
    my $table_name   = $class->table_name;
    my $field_prefix = $class->datasource;

    return undef unless $dbh;

    # Disable RaiseError if set, since the table we're about to describe
    # may not actually exist (in which case, the return value is undef,
    # signalling an nonexistent table to the caller).
    local $dbh->{RaiseError} = 1;
    my $sth = $dbh->prepare( 'PRAGMA table_info("' . $table_name . '")' )
        or return undef;
    $sth->execute or return undef;
    my $defs = {};
    my @pks;
    while ( my $row = $sth->fetchrow_hashref ) {
        my $colname = lc $row->{name};
        $colname =~ s/^\Q$field_prefix\E_//i;
        my $coltype = $ddl->db2type( $row->{type} );
        if ( $row->{type} =~ m/\((\d+)\)/ ) {
            $defs->{$colname}{size} = $1;
        }
        $defs->{$colname}{type} = $coltype;

        # TODO: isn't key for pks, not foreign keys?
        if ( $colname =~ m/_id$/ ) {
            $defs->{$colname}{key} = 1;
        }
        if ( $row->{pk} ) {
            $defs->{$colname}{key} = 1;
            push @pks, $colname;
        }
        $defs->{$colname}{not_null} = 1
            if $row->{notnull};
        $defs->{$colname}{default} = $row->{dflt_value}
            if defined $row->{dflt_value};
    }
    $sth->finish;
    return undef unless %$defs;

    if ( @pks && 1 == scalar @pks ) {
        my ($colname) = @pks;
        if ( $defs->{$colname}{type} eq 'integer' ) {

            # with sqlite, simple integer primary keys auto increment. always.
            $defs->{$colname}{auto} = 1;
        }
    }

    return $defs;
}

sub db2type {
    my $ddl = shift;
    my ($db_type) = @_;
    $db_type =~ s/\(\d+\)//g;
    if ( $db_type eq 'varchar' ) {
        $db_type = 'string';
    }
    return $db_type;
}

sub type2db {
    my $ddl = shift;
    my ($def) = @_;
    return undef if !defined $def;
    my $type = ( ref($def) eq 'HASH' ) ? $def->{type} : $def;
    $type = $def->{type};
    if ( $type eq 'string' ) {
        return 'varchar(' . $def->{size} . ')';
    }
    elsif ( $type eq 'smallint' ) {
        return 'smallint';
    }
    elsif ( $type eq 'bigint' ) {
        return 'bigint';
    }
    elsif ( $type eq 'boolean' ) {
        return 'boolean';
    }
    elsif ( $type eq 'datetime' ) {
        return 'datetime';
    }
    elsif ( $type eq 'timestamp' ) {
        return 'timestamp';
    }
    elsif ( $type eq 'integer' ) {
        return 'integer';
    }
    elsif ( $type eq 'blob' ) {
        return 'blob';
    }
    elsif ( $type eq 'text' ) {
        return 'text';
    }
    elsif ( $type eq 'float' ) {
        return 'float';
    }
    elsif ( $type eq 'double' ) {
        return 'double';
    }
    Carp::croak( "undefined type: " . $type );
}

sub can_add_constraint {0}

sub unique_constraint_sql {
    my $ddl = shift;
    my ($class) = @_;

    my $table_name   = $class->table_name;
    my $props        = $class->properties;
    my $field_prefix = $class->datasource;
    my $indexes      = $props->{indexes};
    my $pk           = $props->{primary_key};

    my @stmts;
    if ($indexes) {
        foreach my $name ( keys %$indexes ) {
            next if $pk && $name eq $pk;
            if ( ref $indexes->{$name} eq 'HASH' ) {
                my $idx_info = $indexes->{$name};
                next
                    unless exists( $idx_info->{unique} )
                    && $idx_info->{unique};
                my $column_list = $idx_info->{columns} || [$name];
                my $columns = '';
                foreach my $col (@$column_list) {
                    $columns .= ',' unless $columns eq '';
                    $columns .= $field_prefix . '_' . $col;
                }
                if ($columns) {
                    push @stmts,
                        "CONSTRAINT ${table_name}_$name UNIQUE ($columns)";
                }
            }
        }
    }
    if ( $pk && 'ARRAY' eq ref $pk ) {
        my @columns = map { join q{_}, $field_prefix, $_ } @$pk;
        my $columns = join q{, }, @columns;
        push @stmts, "PRIMARY KEY ($columns)";
    }
    if (@stmts) {
        return ',' . join( "\n", @stmts );
    }
    return q();
}

sub drop_index_sql {
    my $ddl = shift;
    my ( $class, $key ) = @_;
    my $table_name = $class->table_name;

    my $props   = $class->properties;
    my $indexes = $props->{indexes};
    return q() unless exists( $indexes->{$key} );

    return "DROP INDEX ${table_name}_$key";
}

1;
