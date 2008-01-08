# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::ObjectDriver::DDL;

use strict;
use warnings;

use DBI qw(:sql_types);

# Must be implemented!
sub column_defs;
sub index_defs {}

sub can_add_column { 0 }
sub can_alter_column { 0 }
sub can_drop_column { 0 }
sub can_add_constraint { 1 }

sub upgrade_begin {()}
sub upgrade_end {()}
sub drop_table {()}
sub create_table {()}
sub index_table {()}
sub create_sequence {}
sub drop_sequence {}
sub unique_constraint_sql { '' }

sub table_exists {
    my $ddl = shift;
    my ($class) = @_;
    defined $ddl->column_defs($class);
}

sub add_column {
    my $ddl = shift;
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

sub fix_class {
    my $ddl = shift;
    my ($class) = @_;

    my $db_defs = $ddl->column_defs($class);
    my $exists = defined $db_defs ? 1 : 0;
    my $table_name = $class->table_name;

    my @stmts;
    if ($exists) {
        push @stmts, $ddl->create_table_as_sql($class);
        push @stmts, $ddl->drop_table_sql($class);
    }

    push @stmts, $ddl->create_table_sql($class);

    if ($exists) {
        push @stmts, $ddl->insert_from_sql($class, $db_defs);
    }

    push @stmts, $ddl->index_table_sql($class);

    # everything is cool, so drop the upgrade table
    push @stmts, "DROP TABLE ${table_name}_upgrade" if $exists;

    return @stmts;
}

sub insert_from_sql {
    my $ddl = shift;
    my ($class, $db_defs) = @_;

    my $sql = '';

    my $driver = $class->driver;
    my $dbd = $driver->dbd;
    my $dbh = $driver->rw_handle;

    my $props = $class->properties;
    my $class_defs = $class->column_defs;
    return 0 if !$class_defs;

    # now determine which of these fields exist in both
    my %columns;
    foreach (keys %$class_defs, keys %$db_defs) {
        $columns{$_} = 1;
    }
    my @fields_from = keys %$db_defs;
    my @fields_to = @fields_from;
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
        $to_fields .= $dbd->db_column_name($table_name, $_);
    }
    $sql .= $to_fields;

    my $new_fields = '';
    foreach my $fld (@new_fields) {
        $new_fields .= ',' if $new_fields ne '';
        $new_fields .= $dbd->db_column_name($table_name, $fld);
    }
    $sql .= ',' if $to_fields && $new_fields;
    $sql .= $new_fields;
    $sql .= ')';

    $sql .= "\nSELECT ";
    my $from_fields = '';
    foreach my $col (@fields_from) {
        $from_fields .= ',' if $from_fields ne '';
        my $def = $class_defs->{$col};
        if (defined $def) {
            if ($ddl->type2db($def) ne $ddl->type2db($db_defs->{$col})) {
                $from_fields .= $ddl->cast_column_sql($class, $col, $db_defs->{$col});
            } else {
                $from_fields .= $dbd->db_column_name($table_name, $col);
            }
        } else {
            $from_fields .= $dbd->db_column_name($table_name, $col);
        }
    }
    $sql .= $from_fields;
    if (@new_fields) {
        $sql .= ',' if @fields_from;
        my $new_fields = '';
        foreach my $col (@new_fields) {
            $new_fields .= ',' if $new_fields ne '';
            my $def = $class_defs->{$col};
            my $value = $def->{default};
            if (!defined $value && $def->{not_null}) {
                if ($def->{type} =~ m/time/) {
                    $value = '19700101000000'; # non-null date or should it be 'now'?
                } elsif ($def->{type} =~ m/int|float|boolean/) {
                    $value = 0;
                } else {
                    $value = '';
                }
            }
            if (defined $value) {
                if (($def->{type} =~ m/time/) || $dbd->is_date_col($col)) {
                    $value = $dbh->quote($dbd->ts2db($value));
                } elsif ($def->{type} !~ m/int|float|boolean/) {
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
    my $ddl = shift;
    my ($class) = @_;
    my $table_name = $class->table_name;
    return "DROP TABLE $table_name";
}

sub drop_index_sql {
    my $ddl = shift;
    my ($class, $key) = @_;
    my $table_name = $class->table_name;

    my $props = $class->properties;
    my $indexes = $props->{indexes};
    return q() unless exists($indexes->{$key});

    if (ref $indexes->{$key} eq 'HASH') {
        my $idx_info = $indexes->{$key};
        if ($idx_info->{unique} && $ddl->can_add_constraint) {
            return "ALTER TABLE $table_name DROP CONSTRAINT ${table_name}_$key";
        }
    }

    return "DROP INDEX ${table_name}_$key ON $table_name";
}

sub create_table_as_sql {
    my $ddl = shift;
    my ($class) = @_;
    my $table_name = $class->table_name;
    return "CREATE TABLE ${table_name}_upgrade AS SELECT * FROM $table_name";
}

sub create_table_sql {
    my $ddl = shift;
    my ($class) = @_;

    my $table_name = $class->table_name;
    my $table_ddl = "CREATE TABLE $table_name ( \n";
    my @cols;
    # make sure new columns are at the end...
    my $defs = $class->column_defs;
    return 0 unless $defs;
    my $col_names = $class->column_names;
    foreach my $name (@$col_names) {
        my $def = $defs->{$name};
        next unless defined $def;
        my $sql = $ddl->column_sql($class, $name);
        push @cols, $sql;
    }
    $table_ddl .= "\t" . (join ",\n\t", @cols) . "\n";

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
            push @stmts, $ddl->index_column_sql($class, $name);
        }
    }

    return @stmts;
}

sub index_column_sql {
    my $ddl = shift;
    my ($class, $name) = @_;

    my @stmts;
    my $props = $class->properties;
    my $indexes = $props->{indexes};
    return @stmts unless $indexes;
    return @stmts unless exists($indexes->{$name});

    my $table_name = $class->table_name;
    my $field_prefix = $class->datasource;
    my $pk = $props->{primary_key};
    if (!ref $indexes->{$name}) {
        if (!($pk && $name eq $pk)) {
            push @stmts, "CREATE INDEX ${table_name}_$name ON $table_name (${field_prefix}_$name)";
        }
    }
    elsif (ref $indexes->{$name} eq 'HASH') {
        # check to see if this lists our column in the list of
        # indexed columns
        my $idx_info = $indexes->{$name};
        my $column_list = $idx_info->{columns} || [ $name ];
        if (grep { $name } @$column_list) {
            # create this index
            my $columns = '';
            foreach my $col (@$column_list) {
                $columns .= ',' unless $columns eq '';
                $columns .= $field_prefix . '_' . $col;
            }
            if ($idx_info->{unique} && $ddl->can_add_constraint) {
                push @stmts, "ALTER TABLE $table_name ADD CONSTRAINT ${table_name}_$name UNIQUE ($columns)";
            } else {
                push @stmts, "CREATE INDEX ${table_name}_$name ON $table_name ($columns)";
            }
        }
    }
    return @stmts;
}

sub add_column_sql {
    my $ddl = shift;
    my ($class, $name) = @_;
    my $sql = $ddl->column_sql($class, $name);
    my $table_name = $class->table_name;
    return "ALTER TABLE $table_name ADD $sql";
}

sub alter_column_sql {
    my $ddl = shift;
    my ($class, $name) = @_;
    my $sql = $ddl->column_sql($class, $name);
    my $table_name = $class->table_name;
    return "ALTER TABLE $table_name MODIFY $sql";
}

sub drop_column_sql {
    my $ddl = shift;
    my ($class, $name) = @_;
    my $driver = $class->driver;
    my $table_name = $class->table_name;
    my $field_prefix = $class->datasource;
    return "ALTER TABLE $table_name DROP ${field_prefix}_$name";
}

sub column_sql { 
    my $ddl = shift;
    my ($class, $name) = @_;

    my $driver = $class->driver;
    my $dbd = $driver->dbd;

    my $field_prefix = $class->datasource;
    my $def = $class->column_def($name);
    my $type = $ddl->type2db($def);
    my $nullable = '';
    if ($def->{not_null}) {
        $nullable = ' NOT NULL';
    }
    my $default = '';
    if ($def->{type} eq 'timestamp') {
        delete $def->{default} if exists $def->{default};
    }
    if (exists $def->{default}) {
        my $dbh = $driver->r_handle;
        my $value = $def->{default};
        if (($def->{type} =~ m/time/) || $dbd->is_date_col($name)) {
            $value = $dbh->quote($dbd->ts2db($value));
        } elsif ($def->{type} !~ m/int|float|boolean/) {
            $value = $dbh->quote($value);
        }
        $default = ' DEFAULT ' . $value;
    }
    my $key = '';
    $key = ' PRIMARY KEY' if $def->{key};
    return $field_prefix . '_' . $name . ' ' . $type . $nullable . $default . $key;
}

sub db2type {
    my $ddl = shift;
    my ($type) = @_;
    if ($type == SQL_INTEGER) {
        return 'integer';
    } elsif ($type == SQL_DATETIME) {
        return 'datetime';
    } elsif ($type == SQL_TIMESTAMP) {
        return 'timestamp';
    } elsif ($type == SQL_TYPE_TIMESTAMP_WITH_TIMEZONE) {
        return 'timestamp';
    } elsif ($type == SQL_TYPE_TIMESTAMP) {
        return 'timestamp';
    } elsif ($type == -5) { #SQL_BIGINT) {
        return 'bigint';
    } elsif ($type == SQL_SMALLINT) {
        return 'smallint';
    } elsif ($type == SQL_TINYINT) {
        return 'boolean';
    } elsif ($type == SQL_DECIMAL) {
        return 'float';
    } elsif ($type == SQL_DOUBLE) {
        return 'float';
    } elsif ($type == SQL_REAL) {
        return 'float';
    } elsif ($type == SQL_CHAR) {
        return 'string';
    } elsif ($type == SQL_VARCHAR) {
        return 'string';
    } elsif ($type == SQL_BINARY) {
        return 'blob';
    } elsif ($type == SQL_BLOB) {
        return 'blob';
    } elsif ($type == SQL_CLOB) {
        return 'text';
    } elsif ($type == SQL_LONGVARCHAR) {
        return 'text';
    } elsif ($type == SQL_LONGVARBINARY) {
        return 'blob';
    } elsif ($type == SQL_VARBINARY) {
        return 'blob';
    } elsif ($type == SQL_BOOLEAN) {
        return 'boolean';
    }
    warn "unresolved type: $type\n";
    undef;
}

sub cast_column_sql {
    my $ddl = shift;
    my ($class, $name, $from_def) = @_;
    my $field_prefix = $class->datasource;
    return "${field_prefix}_$name";
}

1;

__END__

=head1 NAME

MT::ObjectDriver::DDL

=head1 DESCRIPTION

=head1 SYNOPSIS

    my $ddl = $driver->ddl_class->new();
    $ddl->create_table($class);
    my @ddl = $ddl->as_ddl;

    $ddl->add_column($class, 'foo');
    my @ddl = $ddl->as_ddl;

=head1 METHODS

=head2 $ddl->add_column()

=head2 $ddl->create_table()

=head2 $ddl->drop_table()

=head2 $ddl->drop_column()

=head2 $ddl->create_index()

=head2 $ddl->drop_index()

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
