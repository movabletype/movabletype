# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ObjectDriver::DDL::Pg;

use strict;
use warnings;
use base qw( MT::ObjectDriver::DDL );

sub can_add_column   {1}
sub can_drop_column  {1}
sub can_alter_column {0}

sub index_defs {
    my $ddl          = shift;
    my ($class)      = @_;
    my $driver       = $class->driver;
    my $dbh          = $driver->r_handle;
    my $field_prefix = $class->datasource;
    my $table_name   = $class->table_name;
    my $sth          = $dbh->prepare(<<SQL)
SELECT cidx.relname as index_name, idx.indisunique, idx.indisprimary, idx.indnatts, idx.indkey, am.amname
FROM pg_index idx
INNER JOIN pg_class cidx ON idx.indexrelid = cidx.oid
INNER JOIN pg_class ctbl ON idx.indrelid = ctbl.oid
INNER JOIN pg_am am ON cidx.relam = am.oid
WHERE ctbl.relname = '$table_name'
SQL
        or return undef;
    $sth->execute or return undef;

    my $defs = {};
    while ( my $row = $sth->fetchrow_hashref ) {
        next if 1 == $row->{'indisprimary'};

        my $key = $row->{'index_name'};
        next unless $key =~ m/^(mt_)?\Q$field_prefix\E_/;
        $key = 'mt_' . $key unless $key =~ m/^mt_/;

        my $type = $row->{'amname'};

        # ignore fulltext or other unrecognized indexes for now
        next unless $type eq 'btree';

        my $is_unique = $row->{'indisunique'};
        $key =~ s/^mt_\Q$field_prefix\E_//;

        my $indkeys = $row->{'indkey'};
        $indkeys =~ s/\s+/,/g;

        my $sth_att = $dbh->prepare(<<ATTSQL)
SELECT attnum, attname
FROM pg_attribute att
INNER JOIN pg_class ctbl ON att.attrelid = ctbl.oid
WHERE att.attnum IN ($indkeys)
AND ctbl.relname = '$table_name'
ATTSQL
            or next;
        $sth_att->execute or next;
        my $row_att = $sth_att->fetchall_hashref('attnum');
        $sth_att->finish;

        my $cols;
        if ( 1 == $row->{'indnatts'} ) {

            # $indkeys have column's attnum
            my $col = $row_att->{$indkeys}->{'attname'};
            $col =~ s/^\Q$field_prefix\E_//;
            $cols = [$col];
        }
        else {
            my @cols;
            for my $indkey ( split ',', $indkeys ) {
                my $col = $row_att->{$indkey}->{'attname'};
                $col =~ s/^\Q$field_prefix\E_//;
                push @cols, $col;
            }
            $cols = \@cols;
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
    return $defs;
}

sub column_defs {
    my $ddl = shift;
    my ($class) = @_;

    my $table_name   = $class->table_name;
    my $field_prefix = $class->datasource;
    my $dbh          = $class->driver->r_handle;
    return undef unless $dbh;

    local $dbh->{RaiseError} = 0;
    my $sth = $dbh->column_info( undef, undef, $table_name, undef );
    my $attr = $sth->fetchall_hashref('COLUMN_NAME') or return undef;
    return undef if $sth->err;
    return undef unless %$attr;

    my @key_column_names = $dbh->primary_key( undef, undef, $table_name );
    my $key_columns = {};
    foreach (@key_column_names) {
        $key_columns->{$_} = 1;
    }

    my $defs = {};
    foreach my $field_name ( keys %$attr ) {
        my $col     = $attr->{$field_name};
        my $coltype = $ddl->db2type( $col->{DATA_TYPE} );
        my $colname = lc $col->{COLUMN_NAME};
        $colname =~ s/^\Q$field_prefix\E_//i;
        $defs->{$colname}{type} = $coltype;
        if ( $coltype eq 'string' ) {
            if ( defined $col->{COLUMN_SIZE} ) {
                $defs->{$colname}{size} = $col->{COLUMN_SIZE};
            }
            else {
                $defs->{$colname}{type} = 'text';
            }
        }
        unless ( $col->{NULLABLE} ) {
            $defs->{$colname}{not_null} = 1;
        }
        if ( $col->{PRIMARY_KEY} ) {
            $defs->{$colname}{key} = 1;
        }
        elsif ( exists $key_columns->{ $field_prefix . '_' . $colname } ) {
            $defs->{$colname}{key} = 1;
        }
    }
    $defs;
}

sub drop_sequence {
    my $ddl     = shift;
    my ($class) = @_;
    my $driver  = $class->driver;
    my $dbh     = $driver->rw_handle;

    # do this, but ignore error since it usually means the
    # sequence didn't exist to begin with
    if ( my $col = $class->properties->{primary_key} ) {
        ## If it's a complex primary key, use the second half.
        if ( ref $col ) {
            $col = $col->[1];
        }
        my $def = $class->column_def($col);
        if ( exists( $def->{auto} ) && $def->{auto} ) {

            #if ($def->{type} eq 'integer') {
            my $seq = $driver->dbd->sequence_name($class);
            local $dbh->{RaiseError} = 0;
            $dbh->do( 'DROP SEQUENCE ' . $seq );
        }
    }
    1;
}

sub create_sequence {
    my $ddl = shift;
    my ($class) = @_;

    my $driver = $class->driver;
    my $dbh    = $driver->rw_handle;

    if ( my $col = $class->properties->{primary_key} ) {
        ## If it's a complex primary key, use the second half.
        if ( ref $col ) {
            $col = $col->[1];
        }
        my $def = $class->column_def($col);
        if ( exists( $def->{auto} ) && $def->{auto} ) {

            #if ($def->{type} eq 'integer') {
            my $seq          = $driver->dbd->sequence_name($class);
            my $table_name   = $class->table_name;
            my $field_prefix = $class->datasource;
            my $max_sql
                = 'SELECT MAX('
                . $field_prefix . '_'
                . $col
                . ') FROM '
                . $table_name;
            my ($start) = $dbh->selectrow_array($max_sql);

            $dbh->do( 'CREATE SEQUENCE '
                    . $seq
                    . ( $start ? ( ' START ' . ( $start + 1 ) ) : '' ) );
        }
    }
    1;
}

sub type2db {
    my $ddl   = shift;
    my ($def) = @_;
    my $type  = $def->{type};
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
        return 'smallint';
    }
    elsif ( $type eq 'datetime' ) {
        return 'timestamp';
    }
    elsif ( $type eq 'timestamp' ) {
        return 'timestamp';
    }
    elsif ( $type eq 'integer' ) {
        return 'integer';
    }
    elsif ( $type eq 'blob' ) {
        return 'bytea';
    }
    elsif ( $type eq 'text' ) {
        return 'text';
    }
    elsif ( $type eq 'float' ) {
        return 'float';
    }
    elsif ( $type eq 'double' ) {
        return 'float';
    }
    Carp::croak( "undefined type: " . $type );
}

sub column_sql {
    my $ddl = shift;
    my ( $class, $name ) = @_;

    # ugly but we need to return the sql to express
    # a column differently based on whether we are declaring
    # the column for creating a table or for altering a column.
    # postgres 7.x does not support the 'not null' and 'default'
    # keywords when altering the column.
    if ( ( caller(1) )[3] =~ m/::create_table_sql$/ ) {
        my $def = $class->column_def($name);
        return $ddl->SUPER::column_sql( $class, $name );
    }

    my $field_prefix = $class->datasource;
    my $def          = $class->column_def($name);
    my $type         = $ddl->type2db($def);
    return $field_prefix . '_' . $name . ' ' . $type;
}

sub add_column_sql {
    my $ddl = shift;
    my ( $class, $name ) = @_;
    my $sql          = $ddl->column_sql( $class, $name );
    my $driver       = $class->driver;
    my $table_name   = $class->table_name;
    my $field_prefix = $class->datasource;
    my $dbh          = $driver->r_handle;
    my @stmt         = ("ALTER TABLE $table_name ADD $sql");

    my $def = $class->column_def($name);
    my $default_value;
    if ( exists $def->{default} ) {
        $default_value = $def->{default};
        if ( ( $def->{type} =~ m/time/ ) || $driver->dbd->is_date_col($name) )
        {
            $default_value
                = $dbh->quote( $driver->dbd->ts2db($default_value) );
        }
        elsif ( $def->{type} !~ m/int|float|double|boolean/ ) {
            $default_value = $dbh->quote($default_value);
        }
        push @stmt,
            "ALTER TABLE $table_name ALTER COLUMN ${field_prefix}_${name} SET DEFAULT "
            . $default_value;
        push @stmt,
            "UPDATE $table_name SET ${field_prefix}_${name} = $default_value WHERE ${field_prefix}_${name} IS NULL";
    }
    if ( $def->{key} ) {
        push @stmt,
            "ALTER TABLE $table_name ADD PRIMARY KEY (${field_prefix}_${name})";
    }
    elsif (( $def->{not_null} )
        && ( 70300 < $dbh->{pg_server_version} )
        && ( exists $def->{default} ) )
    {

        #postgresql under 7.3.0 does not support not null in alter table
        #plus,we can't set not null unless there are no rows contains null
        push @stmt,
            "UPDATE $table_name SET ${field_prefix}_${name} = $default_value WHERE ${field_prefix}_${name} IS NULL";
        push @stmt,
            "ALTER TABLE $table_name ALTER COLUMN ${field_prefix}_${name} SET NOT NULL";
    }
    return @stmt;
}

sub alter_column_sql {
    my $ddl = shift;
    my ( $class, $name ) = @_;
    my $sql = $ddl->SUPER::alter_column_sql(@_);
    $sql =~ s/\bMODIFY\b/ALTER COLUMN/;
    return $sql;
}

sub cast_column_sql {
    my $ddl = shift;
    my ( $class, $name, $from_def ) = @_;
    my $field_prefix = $class->datasource;
    my $def          = $class->column_def($name);
    if ( ( $from_def->{type} eq 'text' ) && ( $def->{type} eq 'blob' ) ) {
        return
            "cast(decode(${field_prefix}_$name, 'escape') as "
            . $ddl->type2db($def) . ')';
    }
    elsif ( ( $from_def->{type} eq 'blob' ) && ( $def->{type} eq 'text' ) ) {
        return
            "cast(encode(${field_prefix}_$name, 'escape') as "
            . $ddl->type2db($def) . ')';
    }
    else {
        return "cast(${field_prefix}_$name as " . $ddl->type2db($def) . ')';
    }
}

sub drop_index_sql {
    my $ddl = shift;
    my ( $class, $key ) = @_;
    my $table_name = $class->table_name;

    my $props   = $class->properties;
    my $indexes = $props->{indexes};
    return q() unless exists( $indexes->{$key} );

    if ( ref $indexes->{$key} eq 'HASH' ) {
        my $idx_info = $indexes->{$key};
        if ( $idx_info->{unique} && $ddl->can_add_constraint ) {
            return
                "ALTER TABLE $table_name DROP CONSTRAINT ${table_name}_$key";
        }
    }

    return "DROP INDEX ${table_name}_$key";
}

1;
