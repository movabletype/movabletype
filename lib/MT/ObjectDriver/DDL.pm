# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ObjectDriver::DDL;

use strict;
use warnings;

use DBI qw(:sql_types);

# Must be implemented!
sub column_defs;
sub index_defs { }

sub can_add_column     {0}
sub can_alter_column   {0}
sub can_drop_column    {0}
sub can_add_constraint {1}

sub upgrade_begin   { () }
sub upgrade_end     { () }
sub drop_table      { () }
sub create_table    { () }
sub index_table     { () }
sub create_sequence { }
sub drop_sequence   { }

sub unique_constraint_sql {
    my $ddl = shift;
    my ($class) = @_;

    my $pk = $class->properties->{primary_key};
    return q{} if !ref $pk || 'ARRAY' ne ref $pk;

    my $driver = $class->driver;
    my $dbd    = $driver->dbd;
    my $table  = $class->table_name;

    my @key_fields = map { $dbd->db_column_name( $table, $_ ) } @$pk;
    return ', PRIMARY KEY (' . join( q{, }, @key_fields ) . ')';
}

sub table_exists {
    my $ddl = shift;
    my ($class) = @_;
    defined $ddl->column_defs($class);
}

sub add_column {
    my $ddl   = shift;
    my @stmts = $ddl->add_column_sql(@_);
    push @stmts, $ddl->index_column_sql(@_);
    return @stmts;
}

sub alter_column {
    my $ddl = shift;
    return $ddl->alter_column_sql(@_);
}

sub drop_column {
    my $ddl = shift;
    return $ddl->drop_column_sql(@_);
}

sub index_column {
    my $ddl = shift;
    return $ddl->drop_index_sql(@_), $ddl->index_column_sql(@_);
}

sub drop_index {
    my $ddl = shift;
    return $ddl->drop_index_sql(@_);
}

sub fix_class {
    my $ddl = shift;
    my ($class) = @_;

    my $db_defs    = $ddl->column_defs($class);
    my $exists     = defined $db_defs ? 1 : 0;
    my $table_name = $class->table_name;

    my @stmts;
    if ($exists) {
        push @stmts, $ddl->create_table_as_sql($class);
        push @stmts, $ddl->drop_table_sql($class);
    }

    push @stmts, $ddl->create_table_sql($class);

    if ($exists) {
        push @stmts, $ddl->insert_from_sql( $class, $db_defs );
    }

    push @stmts, $ddl->index_table_sql($class);

    # everything is cool, so drop the upgrade table
    push @stmts, "DROP TABLE ${table_name}_upgrade" if $exists;

    return @stmts;
}

sub insert_from_sql {
    my $ddl = shift;
    my ( $class, $db_defs ) = @_;

    my $sql = '';

    my $driver = $class->driver;
    my $dbd    = $driver->dbd;
    my $dbh    = $driver->rw_handle;

    my $props      = $class->properties;
    my $class_defs = $class->column_defs;
    return 0 if !$class_defs;

    # now determine which of these fields exist in both
    my %columns;
    foreach ( keys %$class_defs, keys %$db_defs ) {
        $columns{$_} = 1;
    }
    my @fields_from = keys %$db_defs;
    my @fields_to   = @fields_from;
    foreach (@fields_from) {
        delete $columns{$_};
    }

    # now, what is left in @columns are the new fields
    my @new_fields = keys %columns;

    # remove columns removed in new version
    @fields_to = grep { exists $class_defs->{$_} } @fields_to;
    @fields_from = @fields_to;

    my $table_name = $class->table_name;
    $sql = "INSERT INTO $table_name (";

    my $to_fields = '';
    foreach (@fields_to) {
        $to_fields .= ',' if $to_fields ne '';
        $to_fields .= $dbd->db_column_name( $table_name, $_ );
    }
    $sql .= $to_fields;

    my $new_fields = '';
    foreach my $fld (@new_fields) {
        $new_fields .= ',' if $new_fields ne '';
        $new_fields .= $dbd->db_column_name( $table_name, $fld );
    }
    $sql .= ',' if $to_fields && $new_fields;
    $sql .= $new_fields;
    $sql .= ')';

    $sql .= "\nSELECT ";
    my $from_fields = '';
    foreach my $col (@fields_from) {
        $from_fields .= ',' if $from_fields ne '';
        my $def = $class_defs->{$col};
        if ( defined $def ) {
            if ( $ddl->type2db($def) ne $ddl->type2db( $db_defs->{$col} ) ) {
                $from_fields .= $ddl->cast_column_sql( $class, $col,
                    $db_defs->{$col} );
            }
            else {
                $from_fields .= $dbd->db_column_name( $table_name, $col );
            }
        }
        else {
            $from_fields .= $dbd->db_column_name( $table_name, $col );
        }
    }
    $sql .= $from_fields;
    if (@new_fields) {
        $sql .= ',' if @fields_from;
        my $new_fields = '';
        foreach my $col (@new_fields) {
            $new_fields .= ',' if $new_fields ne '';
            my $def   = $class_defs->{$col};
            my $value = $def->{default};
            if ( !defined $value && $def->{not_null} ) {
                if ( $def->{type} =~ m/time/ ) {
                    $value = '19700101000000'
                        ;    # non-null date or should it be 'now'?
                }
                elsif ( $def->{type} =~ m/int|float|double|boolean/ ) {
                    $value = 0;
                }
                else {
                    $value = '';
                }
            }
            if ( defined $value ) {
                if ( ( $def->{type} =~ m/time/ ) || $dbd->is_date_col($col) )
                {
                    $value = $dbh->quote( $dbd->ts2db($value) );
                }
                elsif ( $def->{type} !~ m/int|float|double|boolean/ ) {
                    $value = $dbh->quote($value);
                }
            }
            $value = 'NULL' if !defined $value;
            $new_fields .= $value;
        }
        $sql .= $new_fields;
    }
    $sql .= "\nFROM ${table_name}_upgrade";

    return $sql;
}

sub drop_table_sql {
    my $ddl        = shift;
    my ($class)    = @_;
    my $table_name = $class->table_name;
    return "DROP TABLE $table_name";
}

sub drop_index_sql {
    my $ddl = shift;
    my ( $class, $key ) = @_;
    my $table_name = $class->table_name;

    my $db_index = $ddl->index_defs($class);
    return q() unless exists( $db_index->{$key} );

    my $props   = $class->properties;
    my $indexes = $props->{indexes};
    # return q() unless exists( $indexes->{$key} );

    if ( ref $indexes->{$key} eq 'HASH' ) {
        my $idx_info = $indexes->{$key};
        if ( $idx_info->{unique} && $ddl->can_add_constraint ) {
            return
                "ALTER TABLE $table_name DROP CONSTRAINT ${table_name}_$key";
        }
    }

    return "DROP INDEX ${table_name}_$key ON $table_name";
}

sub create_table_as_sql {
    my $ddl        = shift;
    my ($class)    = @_;
    my $table_name = $class->table_name;
    return "CREATE TABLE ${table_name}_upgrade AS SELECT * FROM $table_name";
}

sub create_table_sql {
    my $ddl = shift;
    my ($class) = @_;

    my $table_name = $class->table_name;
    my $table_ddl  = "CREATE TABLE $table_name ( \n";
    my @cols;

    # make sure new columns are at the end...
    my $defs = $class->column_defs;
    return 0 unless $defs;
    my $col_names = $class->column_names;
    foreach my $name (@$col_names) {
        my $def = $defs->{$name};
        next unless defined $def;
        my $sql = $ddl->column_sql( $class, $name );
        push @cols, $sql;
    }
    $table_ddl .= "\t" . ( join ",\n\t", @cols ) . "\n";

    $table_ddl .= $ddl->unique_constraint_sql(@_) . "\n";

    $table_ddl .= ')';

    return $table_ddl;
}

sub index_table_sql {
    my $ddl = shift;
    my ($class) = @_;

    # since our newly created table already has an index
    # for the primary key field, all we need to do is create
    # any supplemental indexes and/or unique constraints

    my $table_name   = $class->table_name;
    my $props        = $class->properties;
    my $field_prefix = $class->datasource;
    my $indexes      = $props->{indexes};

    my @stmts;
    if ($indexes) {
        my $pk = $props->{primary_key};
        undef $pk if ref $pk;    # ignore complex key
        foreach my $name ( keys %$indexes ) {
            next if $pk && $name eq $pk;
            next
                if 'HASH' eq ref $indexes->{$name}
                && $indexes->{$name}->{ms_clustered}
                ;    # This index is only for Clustered index on SQLAzure
            push @stmts, $ddl->index_column_sql( $class, $name );
        }
    }

    return @stmts;
}

sub index_column_sql {
    my $ddl = shift;
    my ( $class, $name ) = @_;

    my @stmts;
    my $props   = $class->properties;
    my $indexes = $props->{indexes};
    return @stmts unless $indexes;
    return @stmts unless exists( $indexes->{$name} );

    my $table_name   = $class->table_name;
    my $field_prefix = $class->datasource;
    my $pk           = $props->{primary_key};
    if ( !ref $indexes->{$name} ) {
        if ( !$pk || ref $pk || $name ne $pk ) {
            push @stmts,
                "CREATE INDEX ${table_name}_$name ON $table_name (${field_prefix}_$name)";
        }
    }
    elsif ( ref $indexes->{$name} eq 'HASH' ) {

        # check to see if this lists our column in the list of
        # indexed columns
        my $idx_info = $indexes->{$name};
        my $column_list = $idx_info->{columns} || [$name];
        if ( grep {$name} @$column_list ) {

            # create this index
            my $columns = '';
            foreach my $col (@$column_list) {
                $columns .= ',' unless $columns eq '';
                $columns .= $field_prefix . '_' . $col;
            }
            if ( $idx_info->{unique} && $ddl->can_add_constraint ) {
                push @stmts,
                    "ALTER TABLE $table_name ADD CONSTRAINT ${table_name}_$name UNIQUE ($columns)";
            }
            else {
                push @stmts,
                    "CREATE INDEX ${table_name}_$name ON $table_name ($columns)";
            }
        }
    }
    return @stmts;
}

sub add_column_sql {
    my $ddl = shift;
    my ( $class, $name ) = @_;
    my $sql = $ddl->column_sql( $class, $name );
    my $table_name = $class->table_name;
    return "ALTER TABLE $table_name ADD $sql";
}

sub alter_column_sql {
    my $ddl = shift;
    my ( $class, $name ) = @_;
    my $sql = $ddl->column_sql( $class, $name );
    my $table_name = $class->table_name;
    return "ALTER TABLE $table_name MODIFY $sql";
}

sub drop_column_sql {
    my $ddl = shift;
    my ( $class, $name ) = @_;
    my $driver       = $class->driver;
    my $table_name   = $class->table_name;
    my $field_prefix = $class->datasource;
    return "ALTER TABLE $table_name DROP ${field_prefix}_$name";
}

sub column_sql {
    my $ddl = shift;
    my ( $class, $name ) = @_;

    my $driver = $class->driver;
    my $dbd    = $driver->dbd;

    my $field_prefix = $class->datasource;
    my $def          = $class->column_def($name);
    my $type         = $ddl->type2db($def);
    my $nullable     = '';
    if ( $def->{not_null} ) {
        $nullable = ' NOT NULL';
    }
    my $default = '';
    if ( $def->{type} eq 'timestamp' ) {
        delete $def->{default} if exists $def->{default};
    }
    if ( exists $def->{default} ) {
        my $dbh   = $driver->r_handle;
        my $value = $def->{default};
        if ( ( $def->{type} =~ m/time/ ) || $dbd->is_date_col($name) ) {
            $value = $dbh->quote( $dbd->ts2db($value) );
        }
        elsif ( $def->{type} !~ m/int|float|double|boolean/ ) {
            $value = $dbh->quote($value);
        }
        $default = ' DEFAULT ' . $value;
    }
    my $key
        = !$def->{key}                          ? q{}
        : ref $class->properties->{primary_key} ? q{}
        :                                         ' PRIMARY KEY';
    return
          $field_prefix . '_'
        . $name . ' '
        . $type
        . $nullable
        . $default
        . $key;
}

sub db2type {
    my $ddl = shift;
    my ($type) = @_;
    if ( $type == SQL_INTEGER ) {
        return 'integer';
    }
    elsif ( $type == SQL_DATETIME ) {
        return 'datetime';
    }
    elsif ( $type == SQL_TIMESTAMP ) {
        return 'timestamp';
    }
    elsif ( $type == SQL_TYPE_TIMESTAMP_WITH_TIMEZONE ) {
        return 'timestamp';
    }
    elsif ( $type == SQL_TYPE_TIMESTAMP ) {
        return 'timestamp';
    }
    elsif ( $type == -5 ) {    #SQL_BIGINT) {
        return 'bigint';
    }
    elsif ( $type == SQL_SMALLINT ) {
        return 'smallint';
    }
    elsif ( $type == SQL_TINYINT ) {
        return 'boolean';
    }
    elsif ( $type == SQL_DECIMAL ) {
        return 'float';
    }
    elsif ( $type == SQL_DOUBLE ) {
        return 'double';
    }
    elsif ( $type == SQL_REAL ) {
        return 'float';
    }
    elsif ( $type == SQL_CHAR ) {
        return 'string';
    }
    elsif ( $type == SQL_VARCHAR ) {
        return 'string';
    }
    elsif ( $type == SQL_BINARY ) {
        return 'blob';
    }
    elsif ( $type == SQL_BLOB ) {
        return 'blob';
    }
    elsif ( $type == SQL_CLOB ) {
        return 'text';
    }
    elsif ( $type == SQL_LONGVARCHAR ) {
        return 'text';
    }
    elsif ( $type == SQL_LONGVARBINARY ) {
        return 'blob';
    }
    elsif ( $type == SQL_VARBINARY ) {
        return 'blob';
    }
    elsif ( $type == SQL_BOOLEAN ) {
        return 'boolean';
    }
    elsif ( $type == SQL_FLOAT ) {
        return 'float';
    }
    warn "unresolved type: $type\n";
    undef;
}

sub cast_column_sql {
    my $ddl = shift;
    my ( $class, $name, $from_def ) = @_;
    my $field_prefix = $class->datasource;
    return "${field_prefix}_$name";
}

1;

__END__

=head1 NAME

MT::ObjectDriver::DDL - Data Definition Language driver

=head1 SYNOPSIS

    my $ddl = $driver->ddl_class->new();
    $ddl->create_table($class);
    my @ddl = $ddl->as_ddl;

    $ddl->add_column($class, 'foo');
    my @ddl = $ddl->as_ddl;

=head1 DESCRIPTION

The Data Definition Language (DDL) drivers provide compatible SQL for creating
and changing the database tables that contain Movable Type's data. The DDL
drivers are mainly used by MT::Upgrade, the automatic upgrader.

=head1 METHODS

=head2 $ddl->column_defs($class)

Returns a description of the current column definitions in the table holding
records for C<$class>, an C<MT::Object> subclass. These descriptions are
comparable to the results of C<MT::Object::column_defs()>; that is, the
description for a class is a hashref containing a column definition for each
column of the class, keyed on the name of the column. Each column definition is
itself a hashref with the possible keys:

=over 4

=item * C<type>

The type of data contained in the column. See C<db2type()> for the possible
values of this member.

=item * C<auto>

If true, indicates the column is an auto-increment column (that is, a column
automatically filled by the database when no value is provided for new
records).

=item * C<key>

If true, indicates the column is or is part of the table's primary key. The
combined value of all key columns in a record must be unique, and should
constitute the identity of the record.

=item * C<size>

For string columns, the maximum possible length of values in the column.

=item * C<not_null>

If true, indicates the column is not allowed to contain a C<NULL> value.

=item * C<default>

The default value used if a record is sent to be saved with no value for that
column.

=back

If the table does not exist, no value is returned.

Subclasses B<must> themselves implement C<column_defs()>. No default
implementation is provided.

=head2 $ddl->index_defs($class)

Returns a description of all the index definitions for the table storing
records for C<$class>, an C<MT::Object> subclass. These descriptions are
hashrefs containing individual index definitions, keyed on the names of the
indexes.

Each index definition is either C<1>, meaning the index is on the single column
named the same as the index, or a hashref with the possible keys:

=over 4

=item * C<columns>

An arrayref listing the columns that compose the index.

=item * C<unique>

If true, indicates a record's values for the indexes are required to be unique
across the table.

=back

If no indexes exist for the table, either no value or an empty hashref is
returned.

=head2 $ddl->table_exists($class)

Returns whether the table for C<$class>, an C<MT::Object> subclass, exists in
the database.

=head2 $ddl->unique_constraint_sql($class)

Returns the SQL describing the uniqueness constraints specified in the
properties of C<$class>, an C<MT::Object> subclass, suitable for insertion at
the end of a C<CREATE TABLE> statement.

The default implementation returns a standard multi-column C<PRIMARY KEY>
declaration if the primary key of C<$class> is multiple columns, or the empty
string otherwise.

=head2 $ddl->can_add_column()

Returns whether the database can add columns to a table that already exists.

The default implementation returns false. Subclasses should override this
method to return true if they implement C<add_column_sql()>.

=head2 $ddl->can_drop_column()

Returns whether the database can drop (remove) columns from a table that
already exists.

The default implementation returns false. Subclasses should override this
method to return true if they implement C<drop_column_sql()>.

=head2 $ddl->can_alter_column()

Returns whether the database can change the definition of a column that already
exists.

The default implementation returns false. Subclasses should override this
method to return true if they implement C<alter_column_sql()>.

=head2 $ddl->can_add_constraint()

Returns whether the database can add a constraint on the table that already
exists.

The default implementation returns B<true>. Subclasses should override this
method to return B<false> if the database does not support the C<ALTER TABLE
... ADD CONSTRAINT> statement.

=head2 $ddl->fix_class()

=head2 $ddl->insert_from_sql()

=head2 $ddl->drop_table_sql()

=head2 $ddl->drop_index_sql()

=head2 $ddl->create_table_sql()

=head2 $ddl->create_table_as_sql()

=head2 $ddl->index_table_sql()

=head2 $ddl->index_column_sql()

=head2 $ddl->add_column_sql()

=head2 $ddl->alter_column_sql()

=head2 $ddl->drop_column_sql()

=head2 $ddl->column_sql()

=head2 $ddl->cast_column_sql()

=head2 $ddl->db2type()

=head2 $ddl->type2db()

TODO

=head2 $ddl->add_column()

=head2 $ddl->alter_column()

=head2 $ddl->drop_column()

=head2 $ddl->index_column()

B<Deprecated.> These methods return the results of the corresponding C<_sql>
methods.

=head2 $ddl->create_table()

=head2 $ddl->drop_table()

=head2 $ddl->index_table()

=head2 $ddl->create_sequence()

=head2 $ddl->drop_sequence()

B<Deprecated.> These methods return no value.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
