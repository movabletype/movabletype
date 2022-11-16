# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ObjectDriver::DDL::mysql;

use strict;
use warnings;
use base qw( MT::ObjectDriver::DDL );

sub can_add_column   {1}
sub can_drop_column  {1}
sub can_alter_column {1}

sub index_defs {
    my $ddl          = shift;
    my ($class)      = @_;
    my $driver       = $class->driver;
    my $dbh          = $driver->r_handle;
    my $field_prefix = $class->datasource;
    my $table_name   = $class->table_name;
    local $dbh->{RaiseError} = 0;
    my $sth = $dbh->prepare( 'SHOW INDEX FROM ' . $table_name )
        or return undef;
    $sth->execute or return undef;

    my $bags   = {};
    my $unique = {};
    my $sizes  = {};
    while ( my $row = $sth->fetchrow_hashref ) {
        my $key = $row->{'Key_name'};
        next unless $key =~ m/^(mt_)?\Q$field_prefix\E_/;
        $key = 'mt_' . $key unless $key =~ m/^mt_/;

        my $type = $row->{'Index_type'};

        # ignore fulltext or other unrecognized indexes for now
        next unless $type eq 'BTREE';

        my $seq        = $row->{'Seq_in_index'};
        my $col        = $row->{'Column_name'};
        my $non_unique = $row->{'Non_unique'};
        my $null       = $row->{'Null'};
        my $size       = $row->{'Sub_part'};

        $key =~ s/^mt_\Q$field_prefix\E_//;
        $col =~ s/^\Q$field_prefix\E_//;

        $unique->{$key} = 1 unless $non_unique;
        $sizes->{$key}->{$col} = $size if defined $size;
        my $idx_bag = $bags->{$key} ||= [];
        $idx_bag->[ $seq - 1 ] = $col;
    }
    $sth->finish;
    if ( !%$bags ) {
        return undef;
    }

    my $defs = {};
    foreach my $key ( keys %$bags ) {
        my $cols = $bags->{$key};
        my %sizes = %{ $sizes->{$key} || {} };
        if ( $unique->{$key} ) {
            $defs->{$key} = {
                columns => $cols,
                unique  => 1,
                %sizes ? ( sizes => \%sizes ) : (),
            };
        }
        else {
            if ( ( @$cols == 1 ) && ( $key eq $cols->[0] ) && !%sizes ) {
                $defs->{$key} = 1;
            }
            else {
                $defs->{$key} = {
                    columns => $cols,
                    %sizes ? ( sizes => \%sizes ) : (),
                };
            }
        }
    }

    return $defs;
}

sub column_defs {
    my $ddl = shift;
    my ($class) = @_;

    my $driver       = $class->driver;
    my $dbh          = $driver->r_handle;
    my $field_prefix = $class->datasource;
    my $table_name   = $class->table_name;

    # Disable RaiseError if set, since the table we're about to describe
    # may not actually exist (in which case, the return value is undef,
    # signalling an nonexistent table to the caller).
    local $dbh->{RaiseError} = 0;
    my $sth = $dbh->prepare( 'describe ' . $table_name ) or return undef;
    $sth->execute or return undef;
    my $defs = {};
    while ( my $row = $sth->fetchrow_hashref ) {
        my $colname = lc $row->{Field};
        next if $colname !~ m/^\Q$field_prefix\E_/i;
        $colname =~ s/^\Q$field_prefix\E_//i;
        my $coltype = $row->{Type};

        # Remove comments
        # e.g. old temporal formats mark
        # https://mariadb.com/kb/en/datetime/#internal-format
        $coltype =~ s{\s*/\*.*?\*/\s*}{}gs;

        my ($size) = ( $coltype =~ m/(?:var)?char\((\d+)\)/i ? $1 : undef );
        $coltype = $ddl->db2type($coltype);
        $defs->{$colname}{type} = $coltype;
        $defs->{$colname}{auto}
            = ( $row->{Extra} =~ m/auto_increment/i ) ? 1 : 0;
        $defs->{$colname}{key} = $row->{Key} eq 'PRI' ? 1 : 0;

        if ( ( $coltype eq 'string' ) && $size ) {
            $defs->{$colname}{size} = $size;
        }
        if (  !$row->{Null}
            || $row->{Null} eq 'NO'
            || ( $coltype eq 'timestamp' ) )
        {
            $defs->{$colname}{not_null} = 1;
        }
        else {
            $defs->{$colname}{not_null} = 0;
        }
    }
    $sth->finish;
    if ( !%$defs ) {
        return undef;
    }
    return $defs;
}

sub db2type {
    my $ddl = shift;
    my ($type) = @_;
    $type = lc $type;
    $type =~ s/\(.+//;
    if ( $type eq 'int' ) {
        return 'integer';
    }
    elsif ( $type eq 'smallint' ) {
        return 'smallint';
    }
    elsif ( $type eq 'bigint' ) {
        return 'bigint';
    }
    elsif ( $type eq 'mediumint' ) {
        return 'integer';
    }
    elsif ( $type eq 'bigint' ) {
        return 'integer';
    }
    elsif ( $type eq 'varchar' ) {
        return 'string';
    }
    elsif ( $type eq 'varbinary' ) {
        return 'string';
    }
    elsif ( $type eq 'char' ) {
        return 'string';
    }
    elsif ( $type eq 'mediumtext' ) {
        return 'text';
    }
    elsif ( $type eq 'blob' ) {
        return 'blob';
    }
    elsif ( $type eq 'mediumblob' ) {
        return 'blob';
    }
    elsif ( $type eq 'tinyint' ) {
        return 'boolean';
    }
    elsif ( $type eq 'datetime' ) {
        return 'datetime';
    }
    elsif ( $type eq 'timestamp' ) {
        return 'timestamp';
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

sub type2db {
    my $ddl = shift;
    my ($def) = @_;
    return undef if !defined $def;
    my $type = $def->{type};
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
        return 'tinyint';
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
        return 'mediumblob';
    }
    elsif ( $type eq 'text' ) {
        return 'mediumtext';
    }
    elsif ( $type eq 'float' ) {
        return 'float';
    }
    elsif ( $type eq 'double' ) {
        return 'double';
    }
    Carp::croak( "undefined type: " . $type );
}

sub column_sql {
    my $ddl = shift;
    my ( $class, $name ) = @_;
    my $sql = $ddl->SUPER::column_sql( $class, $name );
    my $def = $class->column_def($name);
    $sql .= ' auto_increment' if $def->{auto};
    return $sql;
}

sub cast_column_sql {
    my $ddl = shift;
    my ( $class, $name, $from_def ) = @_;

    my $def          = $class->column_def($name);
    my $field_prefix = $class->datasource;
    my %cast_type    = (
        'string'    => 'char',
        'smallint'  => 'signed',
        'bigint'    => 'signed',
        'integer'   => 'signed',
        'blob'      => 'binary',
        'text'      => 'char',
        'datetime'  => 'datetime',
        'timestamp' => 'timestamp',
        'boolean'   => 'signed',
        'float'     => 'signed',
        'double'    => 'signed',
    );
    return
        "CAST(${field_prefix}_$name AS " . $cast_type{ $def->{type} } . ')';
}

sub create_table_sql {
    my ( $ddl, $class ) = @_;
    my $sql = $ddl->SUPER::create_table_sql($class);
    my $dbh = $class->driver->rw_handle;
    if ( $dbh->{private_set_names} eq 'utf8mb4' ) {
        $sql .= " ROW_FORMAT=DYNAMIC";
    }
    $sql;
}

sub drop_table_sql {
    my $ddl        = shift;
    my ($class)    = @_;
    my $table_name = $class->table_name;
    return "DROP TABLE IF EXISTS $table_name";
}

1;
