# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::ObjectDriver::DBI::sqlite;
use strict;

use Fcntl;
use File::Basename;

use DBI qw(:sql_types);
use MT::ObjectDriver::DBI;
@MT::ObjectDriver::DBI::sqlite::ISA = qw( MT::ObjectDriver::DBI );

sub ts2db {
    sprintf '%04d-%02d-%02d %02d:%02d:%02d', unpack 'A4A2A2A2A2A2', $_[1];
}

sub db2ts {
    my $ts = $_[1];
    $ts =~ s/(?:\+|-)\d{2}$//;
    $ts =~ tr/\- ://d;
    $ts;
}

sub init {
    my $driver = shift;
    $driver->SUPER::init(@_);
    my $cfg = $driver->cfg;
    my $db_file = $cfg->Database;
    require File::Spec;
    if (!File::Spec->file_name_is_absolute($db_file)) {
        $db_file = File::Spec->catfile(MT->instance->config_dir, $db_file);
        $cfg->Database($db_file) if -f $db_file;
    }
    ## This is ugly but necessary. SQLite only creates files with 0644
    ## permissions, so we can't use umask settings to modify those. So
    ## instead, we have to create the file if it doesn't exist in order
    ## to give it the proper permissions.
    unless (-e $db_file) {
        my $umask = oct $driver->cfg->DBUmask;
        my $old = umask($umask);
        local *JUNK;
        sysopen JUNK, $db_file, O_RDWR|O_CREAT, 0666
            or return $driver->error(MT->translate("Can't open '[_1]': [_2]", $db_file, $!));
        close JUNK;
        umask($old);
    }
    unless (-w $db_file) {
        return $driver->error(MT->translate(
            "Your database file ('[_1]') is not writable.", $db_file));
    }
    my $dir = dirname($db_file);
    unless (-w $dir) {
        return $driver->error(MT->translate(
            "Your database directory ('[_1]') is not writable.", $dir));
    }
    my $dsn = 'dbi:SQLite:dbname=' . $db_file;
    if ($cfg->UseSQLite2) {
        $dsn = 'dbi:SQLite2:dbname=' . $db_file;
    }
    $driver->{dbh} = DBI->connect($dsn, "", "",
        { RaiseError => 0, PrintError => 0 })
        or return $driver->error(MT->translate("Connection error: [_1]", $DBI::errstr));
    $driver->{dbh}->{sqlite_handle_binary_nulls} = 1;
    $driver;
}

sub _prepare_from_where {
    my $driver = shift;
    my($class, $terms, $args) = @_;
    my($sql, @bind);

    ## Prefix the table name with 'mt_' to make it distinct.
    my $tbl = $class->datasource;
    my $tbl_name = 'mt_' . $tbl;

    my($w_sql, $w_terms, $w_bind) = ('', [], []);
    if (my $join = $args->{join}) {
        my($j_class, $j_col, $j_terms, $j_args) = @$join;
        my $j_tbl = $j_class->datasource;
        my $j_tbl_name = 'mt_' . $j_tbl;

        $sql = "from $j_tbl_name NATURAL LEFT OUTER JOIN $tbl_name\n";
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

        if (my $n = $j_args->{limit}) {
            $n =~ s/\D//g;   ## Get rid of any non-numerics.
            $w_sql .= sprintf "limit %d%s\n", $n,
                 ($args->{offset} ? " offset $args->{offset}" : "");
        } elsif (my $o = $j_args->{offset}) {
            $o =~ s/\D//g;   ## Get rid of any non-numerics.
            $w_sql .= sprintf "limit 2147483647 offset %d\n", $o; # 'maxint'
        }
    } else {
        $sql = "from $tbl_name\n";
        ($w_sql, $w_terms, $w_bind) = $driver->build_sql($class, $terms, $args, $tbl);
    }
    $sql .= "where " . join(' and ', @$w_terms) . "\n" if @$w_terms;
    $sql .= $w_sql;
    @bind = @$w_bind;
    if (my $n = $args->{limit}) {
        $sql .= sprintf "limit %d%s\n", $n,
             ($args->{offset} ? " offset $args->{offset}" : "");
    } elsif (my $o = $args->{offset}) {
        $sql .= sprintf "limit 2147483647 offset %d\n", $o;
    }
    ($class->datasource, $sql, \@bind);
}

sub _prepare_count_sql {
    my $driver = shift;
    my($class, $terms, $args) = @_;
    my($tbl, $sql, $bind) = $driver->_prepare_from_where($class, $terms, $args);
    if ($args->{join} && $args->{join}[3]{unique}) {
        $sql = "select count(*) from (select distinct ${tbl}_id\n" . $sql . ')';
    } else { 
        $sql = "select count(*)\n" . $sql;
    }
    ($tbl, $sql, $bind);
}

sub fetch_id { $_[0]->{dbh}->func('last_insert_rowid') }

sub bind_param_attributes {
   my ($driver, $data_type) = @_;
   if ($data_type eq 'blob') {
        return SQL_BLOB;
   }
   return undef;
}

sub column_defs {
    my $driver = shift;
    my ($type) = @_;

    my $props = $type->properties;
    my $ds = $props->{datasource};
    my $obj_defs = $type->column_defs;

    my $dbh = $driver->{dbh};
    return undef unless $dbh;

    my $sth = $dbh->prepare('select * from mt_' . $ds) or return undef;
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
        $colname =~ s/^\Q$ds\E_//i;
        my $coltype = $driver->db2type($coltypes->[$col]);
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
    $defs;
}

sub db2type {
    my $driver = shift;
    my ($db_type) = @_;
    $db_type =~ s/\(\d+\)//g;
    if ($db_type eq 'varchar') {
        $db_type = 'string';
    }
    $db_type;
}

sub type2db {
    my $driver = shift;
    my ($def) = @_;
    my $type = $def->{type};
    if ($type eq 'string') {
        $type = 'varchar(' . $def->{size} . ')';
    }
    return $type;
}

#sub upgrade_begin {
#    my $driver = shift;
#    my ($class) = @_;
#    my $ds = $class->properties->{datasource};
#    $driver->{__ddl}{$ds} = [];
#    return ();
#}
#
#sub fix_class {
#    my $driver = shift;
#    my ($class) = @_;
#    my $ds = $class->properties->{datasource};
#    my $new_columns = $driver->{__ddl}{$ds};
#    if ($new_columns && (scalar @$new_columns)) {
#        # okay, let's recreate this table
#        #print "upgrading these columns: " . join (',', @$new_columns). "\n";
#    }
#    delete $driver->{__ddl}{$ds};
#    return $driver->SUPER::fix_class($class);
#}
#
#sub upgrade_end {
#    my $driver = shift;
#    my ($class) = @_;
#    my $ds = $class->properties->{datasource};
#    if (exists $driver->{__ddl}{$ds}) {
#        return $driver->fix_class($class);
#    }
#    return ();
#}

sub _cast_column {
    my $driver = shift;
    my ($class, $name) = @_;
    my $ds = $class->properties->{datasource};
    return "${ds}_$name";
}

1;
