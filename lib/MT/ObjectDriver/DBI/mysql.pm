# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::ObjectDriver::DBI::mysql;
use strict;

use MT::ObjectDriver::DBI;
@MT::ObjectDriver::DBI::mysql::ISA = qw( MT::ObjectDriver::DBI );

use constant TEMP_TABLE => 'temp_Table';

## We need to use a temporary table hack, and we drop the temporary
## table after we're done with it. So in on_load_complete, we need
## to know whether it's a temp table or not.

sub ts2db {
    return unless defined $_[1] && ($_[1] =~ m/^\d{14}$/);
    sprintf '%04d-%02d-%02d %02d:%02d:%02d', unpack 'A4A2A2A2A2A2', $_[1];
}

sub db2ts {
    (my $ts = $_[1]) =~ tr/\- ://d;
    return 0 if defined $ts && $ts eq '00000000000000';
    $ts;
}

sub fetch_id { $_[1]->{mysql_insertid} || $_[1]->{insertid} }

sub on_load_complete {
    my $driver = shift;
    my($sth) = @_;
    if ($sth->{private_is_tmp}) {
        $driver->{dbh}->do("drop table " . TEMP_TABLE);
    }
}

sub _set_names {
    my $driver = shift;
    return 1 if exists $driver->{set_names};

    my $cfg = MT::ConfigMgr->instance;
    my $set_names = $cfg->SQLSetNames;
    $driver->{set_names} = 1;
    return 1 if (defined $set_names) && !$set_names;

    eval {
        local $@;
        my $sth = $driver->{dbh}->prepare('show variables like "character_set_database"') or return $driver->error($driver->{dbh}->errstr);
        $sth->execute or return $driver->error($sth->errstr);
        my $result = $sth->fetchall_hashref('Variable_name');
        my $charset_db = $result->{character_set_database}{Value};
        if (defined($charset_db) && ($charset_db ne 'latin1')) {
            # MySQL 4.1+ and non-latin1(database) == needs SET NAMES call.
            my $c = lc $cfg->PublishCharset;
            my %Charset = (
                'utf-8' => 'utf8',
                'shift_jis' => 'sjis',
                'euc-jp' => 'ujis',
                #'iso-8859-1' => 'latin1'
            );
            $c = $Charset{$c} ? $Charset{$c}  : $c;
            $driver->{dbh}->do("SET NAMES " . $c) or 
                return ($driver->{dbh}->errstr);
            if (!defined $set_names) {
                # SQLSetNames has never been assigned; we had a successful
                # 'SET NAMES' command, so it's safe to SET NAMES in the future.
                $cfg->SQLSetNames(1, 1);
                $cfg->save_config;
            }
        } else {
            # 'set names' command isn't working for this verison of mysql,
            # assign SQLSetNames to 0 to prevent further errors.
            $cfg->SQLSetNames(0, 1);
            $cfg->save_config;
            return 0;
        }
    };
    1;
}

sub configure {
    my $driver = shift;
    $driver->SUPER::init(@_);
    my $sql_set_names = $driver->_set_names;
    $driver;
}

sub init {
    my $driver = shift;
    $driver->SUPER::init(@_);
    my $cfg = $driver->cfg;
    my $dsn = 'dbi:mysql:database=' . $cfg->Database;
    $dsn .= ';hostname=' . $cfg->DBHost if $cfg->DBHost;
    $dsn .= ';mysql_socket=' . $cfg->DBSocket if $cfg->DBSocket;
    $dsn .= ';port=' . $cfg->DBPort if $cfg->DBPort;
    $driver->{dbh} = DBI->connect($dsn, $cfg->DBUser, $cfg->DBPassword,
        { RaiseError => 0, PrintError => 0 })
        or return $driver->error(MT->translate("Connection error: [_1]",
             $DBI::errstr));
    $driver;
}

sub _prepare_from_where {
    my $driver = shift;
    my($class, $terms, $args) = @_;
    my($sql, @bind);

    ## Prefix the table name with 'mt_' to make it distinct.
    my $tbl = $class->datasource;
    my $tbl_name = 'mt_' . $tbl;

    my $is_tmp = 0;
    my($w_sql, $w_terms, $w_bind) = ('', [], []);
    if (my $join = $args->{'join'}) {
        my($j_class, $j_col, $j_terms, $j_args) = @$join;
        my $j_tbl = $j_class->datasource;
        my $j_tbl_name = 'mt_' . $j_tbl;

        ## If we are doing a join where we want distinct and "order by",
        ## we need to use a temporary table to get around a bug in
        ## MySQL, and because MySQL doesn't support subselects.
        ## So we create a new temporary table, then adjust the
        ## returned SQL to select from that table.
        if ($j_args->{unique} && $j_args->{'sort'}) {
            ##     create temporary table tempTable
            ##     select <all foo cols>, <bar sort key> as temp_sort_key
            ##     from foo, bar
            ##     where foo.id = bar.foo_id
            my $dir = $j_args->{direction} eq 'descend' ? 'desc' : 'asc';
            my $ct_sql = "create temporary table " . TEMP_TABLE . "\nselect ";
            my $cols = $class->column_names;
            $ct_sql .= join(', ', map "${tbl}_$_ as " . TEMP_TABLE . "_$_", @$cols) .
                       ", ${j_tbl}_$j_args->{'sort'} as temp_sort_key\n";
            $ct_sql .= "from $tbl_name, $j_tbl_name\n";
            my($junk, $ct_terms, $ct_bind) =
                $driver->build_sql($j_class, $j_terms, $j_args, $j_tbl);
            push @$ct_terms, "(${tbl}_id = ${j_tbl}_$j_col)";
            $ct_sql .= "where " . join ' and ', @$ct_terms if @$ct_terms;
            $ct_sql .= " order by ${j_tbl}_$j_args->{'sort'} $dir";

            my $dbh = $driver->{dbh};
            my $sth = $dbh->prepare($ct_sql) or return $driver->error($dbh->errstr);
            $sth->execute(@$ct_bind) or return $driver->error($sth->errstr);
            $sth->finish;

            ##     select distinct <all foo cols>
            ##     from tempTable
            ##     order by temp_sort_key <asc|desc>
            $sql = "from " . TEMP_TABLE . "\n";
            $w_sql = "order by temp_sort_key $dir\n";
            if (my $n = $j_args->{limit}) {
                $n =~ s/\D//g;   ## Get rid of any non-numerics.
                $w_sql .= sprintf "limit %s%d\n",
                    ($args->{offset} ? "$args->{offset}," : ""), $n;
            } elsif (my $o = $j_args->{offset}) {
                $o =~ s/\D//g;   ## Get rid of any non-numerics.
                $w_sql .= sprintf "limit %d, 2147483647\n", $o; # 'maxint for mysql 3.x'
            }
            $is_tmp = 1;
        } else {
            $sql = "from $tbl_name, $j_tbl_name\n";
            ($w_sql, $w_terms, $w_bind) =
                $driver->build_sql($j_class, $j_terms, $j_args, $j_tbl);
            push @$w_terms, "${tbl}_id = ${j_tbl}_$j_col";

            ## We are doing a join, but some args and terms may have been
            ## specified for the "outer" piece of the join--for example, if
            ## we are doing a join of entry and comments where we end up with
            ## entries, sorted by the created_on date in the entry table, or
            ## filtered by author ID. In that case the sort or author ID will
            ## be specified in the spec for the Entry load, not for the join
            ## load.
            my($o_sql, $o_terms, $o_bind) =
                $driver->build_sql($class, $terms, $args, $tbl);
            $w_sql .= $o_sql;
            if ($o_terms && @$o_terms) {
                push @$w_terms, @$o_terms;
                push @$w_bind, @$o_bind;
            }
        }
    } else {
        $sql = "from $tbl_name\n";
        ($w_sql, $w_terms, $w_bind) = $driver->build_sql($class, $terms, $args, $tbl);
    }
    $sql .= "where " . join(' and ', @$w_terms) . "\n" if @$w_terms;
    $sql .= $w_sql;
    @bind = @$w_bind;
    if (my $n = $args->{limit}) {
        $n =~ s/\D//g;   ## Get rid of any non-numerics.
        $sql .= sprintf "limit %s%d\n",
            ($args->{offset} ? "$args->{offset}," : ""), $n;
    } elsif (my $o = $args->{offset}) {
        $o =~ s/\D//g;   ## Get rid of any non-numerics.
        $sql .= sprintf "limit %d, 2147483647\n", $o; # 'maxint' for mysql 3.x
    }
    ($is_tmp ? TEMP_TABLE : $class->datasource, $sql, \@bind);
}

sub build_sql {
    my $driver = shift;
    my ($class, $terms, $args, $tbl) = @_;
    my ($w_sql, $w_terms, $w_bind) = $driver->SUPER::build_sql(@_);
    if ($args->{binary} && @$w_terms) {
        foreach my $col (keys %{$args->{binary}}) {
            next unless $args->{binary}{$col};
            foreach my $wterm (@$w_terms) {
                if ($wterm =~ m/^(\()?($tbl\_$col )/) {
                    my $paren = $1 || '';
                    my $column = $2;
                    $wterm =~ s/^(\()?($tbl\_$col )/${paren}binary $column/;
                }
            }
        }
    }
    return ($w_sql, $w_terms, $w_bind);
}

sub column_defs {
    my $driver = shift;
    my ($type) = @_;

    my $ds = $type->properties->{datasource};

    my $dbh = $driver->{dbh};
    return undef unless $dbh;

    my $sth = $dbh->prepare('describe mt_' . $ds) or return undef;
    $sth->execute or return undef;
    my $defs = {};
    while (my $row = $sth->fetchrow_hashref) {
        my $colname = lc $row->{Field};
        next if $colname !~ m/^\Q$ds\E_/i;
        $colname =~ s/^\Q$ds\E_//i;
        my $coltype = $row->{Type};
        my ($size) = ($coltype =~ m/(?:var)?char\((\d+)\)/i ? $1 : undef);
        $coltype = $driver->db2type($coltype);
        $defs->{$colname}{type} = $coltype;
        $defs->{$colname}{auto} = ($row->{Extra} =~ m/auto_increment/i) ? 1 : 0;
        if (($coltype eq 'string') && $size) {
            $defs->{$colname}{size} = $size;
        }
        if ( !$row->{Null} || $row->{Null} eq 'NO' || ($coltype eq 'timestamp') ) {
            $defs->{$colname}{not_null} = 1;
        } else {
            $defs->{$colname}{not_null} = 0;
        }
    }
    $sth->finish;
    if (!%$defs) {
        return undef;
    }
    $defs;
}

sub db2type {
    my $driver = shift;
    my ($type) = @_;
    $type = lc $type;
    $type =~ s/\(.+//;
    if ($type eq 'int') {
        return 'integer';
    } elsif ($type eq 'smallint') {
        return 'smallint';
    } elsif ($type eq 'mediumint') {
        return 'integer';
    } elsif ($type eq 'varchar') {
        return 'string';
    } elsif ($type eq 'char') {
        return 'string';
    } elsif ($type eq 'mediumtext') {
        return 'text';
    } elsif ($type eq 'blob') {
        return 'blob';
    } elsif ($type eq 'mediumblob') {
        return 'blob';
    } elsif ($type eq 'tinyint') {
        return 'boolean';
    } elsif ($type eq 'datetime') {
        return 'datetime';
    } elsif ($type eq 'timestamp') {
        return 'timestamp';
    } elsif ($type eq 'text') {
        return 'text';
    } elsif ($type eq 'float') {
        return 'float';
    }
    return $driver->error(MT->translate("undefined type: [_1]", $type));
}

sub type2db {
    my $driver = shift;
    my ($def) = @_;
    return undef if !defined $def;
    my $type = $def->{type};
    if ($type eq 'string') {
        return 'varchar(' . $def->{size} . ')';
    } elsif ($type eq 'smallint' ) {
        return 'smallint';
    } elsif ($type eq 'boolean') {
        return 'tinyint';
    } elsif ($type eq 'datetime') {
        return 'datetime';
    } elsif ($type eq 'timestamp') {
        return 'timestamp';
    } elsif ($type eq 'integer') {
        return 'integer';
    } elsif ($type eq 'blob') {
        return 'mediumblob';
    } elsif ($type eq 'text') {
        return 'mediumtext';
    } elsif ($type eq 'float') {
        return 'float';
    }
    return $driver->error(MT->translate("undefined type: [_1]", $type));
}

sub can_add_column { 1 }
sub can_drop_column { 1 }
sub can_alter_column { 1 }

sub column_sql {
    my $driver = shift;
    my ($class, $name) = @_;
    my $sql = $driver->SUPER::column_sql($class, $name);
    my $def = $class->column_def($name);
    $sql .= ' auto_increment' if $def->{auto};
    $sql;
}

sub _cast_column {
    my $driver = shift;
    my ($class, $name) = @_;

    my $def = $class->column_def($name);
    my $ds = $class->properties->{datasource};
    my %cast_type = (
        'string' => 'char',
        'smallint' => 'signed',
        'integer' => 'signed',
        'blob' => 'binary',
        'text' => 'char',
        'datetime' => 'datetime',
        'timestamp' => 'timestamp',
        'boolean' => 'signed',
        'float' => 'signed',
    );
    "cast(${ds}_$name as " . $cast_type{$def->{type}} . ')';
}

1;
