# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::ObjectDriver::DBI;
use strict;

use DBI;

use MT::Util qw( offset_time_list );
use MT::ObjectDriver;
@MT::ObjectDriver::DBI::ISA = qw( MT::ObjectDriver );

sub generate_id { undef }
sub fetch_id { undef }
sub ts2db { $_[1] }
sub db2ts { $_[1] }
sub table_prefix { 'mt' }

my %Date_Cols = map { $_ => 1 } qw( created_on modified_on children_modified_on last_moved_on );
sub is_date_col { $Date_Cols{$_[1]} }
sub date_cols { keys %Date_Cols }

# Override in DB Driver to pass correct attributes to bind_param call
sub bind_param_attributes { return undef; }

sub on_load_complete { }

sub load_iter {
    my $driver = shift;
    $driver->run_callbacks($_[0] . '::pre_load', \@_);
    my($class, $terms, $args) = @_;
    my($tbl, $sql, $bind) =
        $driver->_prepare_from_where($class, $terms, $args);
    my(%rec, @bind, @cols);
    my $cols = $class->column_names;
    for my $col (@$cols) {
        push @cols, $col;
        push @bind, \$rec{$col};
    }
    my $tmp = "select ";
    $tmp .= "distinct " if $args->{join} && $args->{join}[3]{unique};
    $tmp .= join(', ', map "${tbl}_$_", @cols) . "\n";
    $sql = $tmp . $sql;
    my $dbh = $driver->{dbh};
    warn "load_iter - Preparing SQL: $sql" if $MT::DebugMode & 4;
    my $sth = $dbh->prepare($sql) or return sub { $driver->error($dbh->errstr) };
    $sth->{private_is_tmp} = 1 if $tbl =~ m/^temp_/i;
    $sth->execute(@$bind) or return sub { $driver->error($sth->errstr) };
    $sth->bind_columns(undef, @bind);
    sub {
        if ((@_ && ($_[0] eq 'finish')) || !$sth->fetch) {
            $sth->finish;
            $driver->on_load_complete($sth);
            return;
        }
        my $obj = $class->new;
        ## Convert DB timestamp format to our timestamp format.
        for my $col ($driver->date_cols) {
            $rec{$col} = $driver->db2ts($rec{$col}) if $rec{$col};
        }
        $obj->set_values(\%rec);
        $driver->run_callbacks($class . '::post_load', \@_, $obj);
        $obj;
    };
}

my %object_cache = ();
my @object_cache_queue = ();

sub clear_cache {
    %object_cache = ();
    @object_cache_queue = ();
}

use constant MAX_CACHE_SIZE => 1000;

sub load {
    my $driver = shift;
    $driver->run_callbacks($_[0] . '::pre_load', \@_);
    my($class, $terms, $args) = @_;
    if ($args->{cached_ok} && $terms && !(ref $terms)) {
        if ($object_cache{$class}->{$terms}) {
            return $object_cache{$class}->{$terms};
        }
    }
    my($tbl, $sql, $bind) =
        $driver->_prepare_from_where($class, $terms, $args);
    my(%rec, @bind, @cols);
    my $cols = $class->column_names;
    for my $col (@$cols) {
        push @cols, $col;
        push @bind, \$rec{$col};
    }
    my $tmp = "select ";
    $tmp .= "distinct " if $args->{join} && $args->{join}[3]{unique};
    $tmp .= join(', ', map "${tbl}_$_", @cols) . "\n";
    $sql = $tmp . $sql;
    my $dbh = $driver->{dbh};
    warn "load - Preparing SQL: $sql" if $MT::DebugMode & 4;
    my $sth = $dbh->prepare($sql)
        or return $driver->error(MT->translate("Loading data failed with SQL error [_1]", $dbh->errstr));
    $sth->{private_is_tmp} = 1 if $tbl =~ m/^temp_/i;
    my $result = $sth->execute(@$bind)
        or return $driver->error(MT->translate("Loading data failed with SQL error [_1]", $sth->errstr));
    $sth->bind_columns(undef, @bind); 
    my @objs;
    while ($sth->fetch) {
        ## Convert DB timestamp format to our timestamp format.
        for my $col ($driver->date_cols) {
            $rec{$col} = $driver->db2ts($rec{$col}) if $rec{$col};
        }
        my $obj = $class->new();
        $obj->set_values(\%rec);
        $driver->run_callbacks($class . '::post_load', \@_, $obj);
        unless (wantarray) {
            # assume, when loading by pk, that there's only one result obj.; cache it!
            if ($terms && !(ref $terms)) {
                if (exists $object_cache{$class} && (scalar keys %{$object_cache{$class}} > MAX_CACHE_SIZE)) {
                    # garbage collection
                    $object_cache{$class} = {};
                }
                $object_cache{$class}->{$terms} = $obj;
            }
            $sth->finish;
            $driver->on_load_complete($sth);
            return $obj;
        }
        push @objs, $obj;
    }
    $sth->finish;
    $driver->on_load_complete($sth);
    wantarray ? @objs : @objs ? $objs[0] : undef;
}

sub _prepare_count_sql {
    my $driver = shift;
    my($class, $terms, $args) = @_;
    my($tbl, $sql, $bind) = $driver->_prepare_from_where($class, $terms, $args);    if ($args->{join} && $args->{join}[3]{unique}) {
        $sql = "select count(distinct ${tbl}_id)\n" . $sql;
    } else {
        $sql = "select count(*)\n" . $sql;
    }
    ($tbl, $sql, $bind);
}

sub count {
    my $driver = shift;
    my($class, $terms, $args) = @_;
    local $args->{limit} = undef;
    local $args->{offset} = undef;
    my ($tbl, $sql, $bind) = $driver->_prepare_count_sql(@_);
    ## Remove any order by clauses, because they will cause errors in
    ## some drivers (and they're not necessary)
    $sql =~ s/order by \w+ (?:asc|desc)//;
    my $dbh = $driver->{dbh};
    warn "count - Preparing SQL: $sql" if $MT::DebugMode & 4;
    my $sth = $dbh->prepare($sql) or return;
    $sth->{private_is_tmp} = 1 if $tbl =~ m/^temp_/i;
    $sth->execute(@$bind) or return $driver->error(MT->translate("Count [_1] failed on SQL error [_2]", $class, $sth->errstr));
    $sth->bind_columns(undef, \my($count));
    $sth->fetch or return;
    $sth->finish;
    $driver->on_load_complete($sth);
    $count;
}

sub count_group_by {
    my $driver = shift;
    my ($class, $terms, $args) = @_;
    my($tbl, $sql, $bind) = $driver->_prepare_from_where($class, $terms,
                                    {%$args, suppress_order_by => 1});
    ## Remove any order by clauses, because the _prepare_from_where
    ## routine isn't savvy about function-based order-by clauses (yet)
    $sql =~ s/order\s+by\s+[\w)(]+\s*(?:asc|desc)//;
    my $group_by_terms = (join ", ", @{$args->{group}});
    foreach my $col (@{$class->column_names}) {
        $group_by_terms =~ s/\b$col\b/${tbl}_$col/g;
        $args->{sort} =~ s/\b$col\b/${tbl}_$col/g if exists $args->{sort};
    }
    $sql = "select count(*), " . $group_by_terms . " " . $sql
        . " group by " . $group_by_terms
        . ($args->{sort} ? " order by " . $args->{sort} : "");
    my $dbh = $driver->{dbh};
    warn "count_group_by - Preparing SQL: $sql" if $MT::DebugMode & 4;
    my $sth = $dbh->prepare($sql) or return sub { $driver->error(MT->translate("Prepare failed")) };
    $sth->execute(@$bind) or return return sub { $driver->error(MT->translate("Execute failed")) };
    $sth->{private_is_tmp} = 1 if $tbl =~ m/^temp_/i;
    my @bindvars = ();
    for (@{$args->{group}}) {
        push @bindvars, \my($var);
    }
    $sth->bind_columns(undef, \my($count), @bindvars);
    sub {
        if ((@_ && ($_[0] eq 'finish')) || !$sth->fetch) {
            $sth->finish;
            $driver->on_load_complete($sth);
            return;
        }
        if (!defined($count)) {
            $sth->finish;
            $driver->on_load_complete($sth);
        } else {
            my @returnvals = map { $$_ } @bindvars;
            return ($count, @returnvals);
        }
    }
}

sub exists {
    my $driver = shift;
    my($obj) = @_;
    return unless $obj->id;
    my $tbl = $obj->datasource;
    my $pfx = $driver->table_prefix;
    my $sql = "select 1 from ${pfx}_$tbl where ${tbl}_id = ?";
    my $dbh = $driver->{dbh};
    warn "exists - Preparing SQL: $sql" if $MT::DebugMode & 4;
    my $sth = $dbh->prepare($sql) or return;
    $sth->execute($obj->id)
        or return $driver->error(MT->translate("existence test failed on SQL error [_1]", $sth->errstr));
    my $exists = $sth->fetch;
    $sth->finish;
    $exists;
}

sub save {
    my $driver = shift;
    my($obj) = @_;
    my $original;
    ($original, $obj) = ($obj, $obj->clone());
    my $class = ref($obj);
    $driver->run_callbacks($class . '::pre_save', $obj, $original);
    my $result;
    if ($driver->exists($obj)) {
        $result = $driver->update($obj);
    } else {
        $result = $driver->insert($obj);
    }
    delete $object_cache{$class}->{$obj->id} if $obj->id && exists $object_cache{$class}->{$obj->id}; # invalidate the cache
    $original->id($obj->id);
    if ($original->properties->{audit}) {
        $original->created_on($obj->created_on);
        $original->modified_on($obj->modified_on);
    }
    $driver->run_callbacks($class . '::post_save', $obj, $original);
    return $result;
}

sub insert {
    my $driver = shift;
    my($obj) = @_;
    my $cols = $obj->column_names;
    unless ($obj->id) {
        ## If we don't already have an ID assigned for this object, we
        ## may need to generate one (depending on the underlying DB
        ## driver). If the driver gives us a new ID, we insert that into
        ## the new record; otherwise, we assume that the DB is using an
        ## auto-increment column of some sort, so we don't specify an ID
        ## at all.
        my $id = $driver->generate_id($obj);
        if ($id) {
            $obj->id($id);
        } else {
            $cols = [ grep $_ ne 'id', @$cols ];
        }
    }
    my $tbl = $obj->datasource;
    my $pfx = $driver->table_prefix;
    my $sql = "insert into ${pfx}_$tbl\n";
    $sql .= '(' . join(', ', map "${tbl}_$_", @$cols) . ')' . "\n" .
            'values (' . join(', ', ('?') x @$cols) . ')' . "\n";
    if ($obj->properties->{audit}) {
        my $blog_id;
        if ($obj->column_def('blog_id')) {
            $blog_id = $obj->blog_id;
        }
        my @ts = offset_time_list(time, $blog_id);
        my $ts = sprintf '%04d%02d%02d%02d%02d%02d',
            $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
        $obj->created_on($ts) unless $obj->created_on;
        $obj->modified_on($ts);
    }
    my $dbh = $driver->{dbh};
    warn "insert - Preparing SQL: $sql" if $MT::DebugMode & 4;
    my $sth = $dbh->prepare($sql)
        or return $driver->error($dbh->errstr);
    my $i = 1;
    my $col_defs = $obj->column_defs;
    for my $col (@$cols) {
        my $val = $obj->column($col);
        my $type = $col_defs ? $col_defs->{$col}{type} || 'char' : 'char';
        if ($type =~ m/time/ || $driver->is_date_col($col)) {
            $val = $driver->ts2db($val);
        }
        my $attr = $driver->bind_param_attributes($type, $obj, $col);

        $sth->bind_param($i++, $val, $attr);
    }
    $sth->execute()
        or return $driver->error(MT->translate("Insertion test failed on SQL error [_1]", $dbh->errstr));
    $sth->finish;

    ## Now, if we didn't have an object ID, we need to grab the
    ## newly-assigned ID.
    unless ($obj->id) {
        $obj->id($driver->fetch_id($sth));
    }
    1;
}

sub update {
    my $driver = shift;
    my($obj) = @_;
    my $cols = $obj->column_names;
    $cols = [ grep $_ ne 'id', @$cols ];
    my $tbl = $obj->datasource;
    my $pfx = $driver->table_prefix;
    my $sql = "update ${pfx}_$tbl set\n";
    $sql .= join(', ', map "${tbl}_$_ = ?", @$cols) . "\n";
    $sql .= "where ${tbl}_id = '" . $obj->id . "'";
    if ($obj->properties->{audit}) {
        my $blog_id;
        if ($obj->column_def('blog_id')) {
            $blog_id = $obj->blog_id;
        }
        my @ts = offset_time_list(time, $blog_id);
        my $ts = sprintf "%04d%02d%02d%02d%02d%02d",
            $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
        $obj->created_on($ts) unless $obj->created_on;
        $obj->modified_on($ts);
    }
    my $dbh = $driver->{dbh};

    warn "update - Preparing SQL: $sql" if $MT::DebugMode & 4;
    my $sth = $dbh->prepare($sql)
        or return $driver->error($dbh->errstr);
    my $i = 1;
    my $col_defs = $obj->column_defs;
    for my $col (@$cols) {
        my $val = $obj->column($col);
        my $type = $col_defs ? $col_defs->{$col}{type} || 'char' : 'char';
        if ($type =~ m/time/ || $driver->is_date_col($col)) {
            $val = $driver->ts2db($val);
        }
        my $attr = $driver->bind_param_attributes($type, $obj, $col);
        $sth->bind_param($i++, $val, $attr);
    }

    $sth->execute()
        or return $driver->error(MT->translate("Update failed on SQL error [_1]", $dbh->errstr));
    $sth->finish;
    1;
}

sub remove {
    my $driver = shift;
    my($obj) = @_;
    my $class = ref $obj;
    $driver->run_callbacks($class . '::pre_remove', $obj);
    my $id = $obj->id();
    return $driver->error(MT->translate("No such object.")) unless defined($id);
    my $tbl = $obj->datasource;
    my $pfx = $driver->table_prefix;
    my $sql = "delete from ${pfx}_$tbl where ${tbl}_id = ?";
    my $dbh = $driver->{dbh};
    warn "remove - Preparing SQL: $sql" if $MT::DebugMode & 4;
    my $sth = $dbh->prepare($sql)
        or return $driver->error($dbh->errstr);
    $sth->execute($id)
        or return $driver->error(MT->translate("Remove failed on SQL error [_1]", $dbh->errstr));
    $sth->finish;
    $driver->run_callbacks($class . '::post_remove', $obj);
    1;
}

sub remove_all {
    my $driver = shift;
    my($class) = @_;
    $driver->run_callbacks($class . '::pre_remove_all', @_);
    my $pfx = $driver->table_prefix;
    my $sql = "delete from ${pfx}_" . $class->datasource;
    my $dbh = $driver->{dbh};
    warn "remove_all - Preparing SQL: $sql" if $MT::DebugMode & 4;
    my $sth = $dbh->prepare($sql)
        or return $driver->error($dbh->errstr);
    $sth->execute
        or return $driver->error(MT->translate("Remove-all failed on SQL error [_1]", $dbh->errstr));
    $sth->finish;
    $driver->run_callbacks($class . '::post_remove_all', @_);
    1;
}

sub DESTROY {
    $_[0]->{dbh}->disconnect if $_[0]->{dbh};
}

sub table_exists {
    my $driver = shift;
    my ($class) = @_;
    my $defs = $driver->column_defs($class);
    defined $defs;
}

sub build_sql {
    my($driver, $class, $terms, $args, $tbl) = @_;
    my(@bind, @terms);
    if ($terms) {
        if (!ref($terms)) {
            return('', [ "${tbl}_id = ?" ], [ $terms ]);
        }
        for my $col (keys %$terms) {
            my $term = '';
            if (ref($terms->{$col}) eq 'ARRAY') {
                if ($args->{range} && $args->{range}{$col}
                    || $args->{range_incl} && $args->{range_incl}{$col}) {
                    my($start, $end) = @{ $terms->{$col} };
                    if (defined $start) {
                        if ($args->{range}{$col}) {
                            $term = "${tbl}_$col > ?";
                        } else {
                            $term = "${tbl}_$col >= ?";
                        }
                        push @bind,
                          $driver->is_date_col($col) ? $driver->ts2db($start) : $start;
                    }
                    $term .= " and " if (defined $start && defined $end);
                    if (defined $end) {
                        if ($args->{range}{$col}) {
                            $term .= "${tbl}_$col < ?";
                        } else {
                            $term .= "${tbl}_$col <= ?";
                        }
                        push @bind,
                          $driver->is_date_col($col) ? $driver->ts2db($end) : $end;
                    }
                } else {
                    $term = "${tbl}_$col in (" .
                        (join (", ", map {$driver->{dbh}->quote($_)} @{$terms->{$col}})) . ")";
                    if ($args->{not} && $args->{not}{$col}) {
                        $term = 'not ('. $term . ')';
                    }
                }
            } else {
                if ($args->{null} && $args->{null}{$col}) {
                    $term = "${tbl}_$col is null";
                } elsif ($args->{not_null} && $args->{not_null}{$col}) {
                    $term = "${tbl}_$col is not null";
                } else {
                    $term = "${tbl}_$col = ?";
                    push @bind, $driver->is_date_col($col) ?
                        $driver->ts2db($terms->{$col}) : $terms->{$col};
                }
            }
            push @terms, "($term)";
        }
    }
    if (my $sv = $args->{start_val}) {
        my $col = $args->{sort} || $driver->primary_key;
        my $cmp = $args->{direction} eq 'descend' ? '<' : '>';
        push @terms, "(${tbl}_$col $cmp ?)";
        push @bind, $driver->is_date_col($col) ? $driver->ts2db($sv) : $sv;
    }
    my $sql = '';
    unless ($args->{suppress_order_by}) {
        if ($args->{'sort'} || $args->{direction}) {
            my $order = $args->{'sort'} || 'id';
            my $dir = $args->{direction} &&
            $args->{direction} eq 'descend' ? 'desc' : 'asc';
            $sql .= "order by ${tbl}_$order $dir\n";
        }
    }
    ($sql, \@terms, \@bind);
}

use DBI qw(:sql_types);
sub db2type {
    my $driver = shift;
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
    }
    warn "unresolved type: $type\n";
    undef;
}

sub sql {
    my $driver = shift;
    my ($sql) = @_;
    if (!ref $sql) {
        $sql = [ $sql ];
    }
    foreach (@$sql) {
        $driver->{dbh}->do($_) or return $driver->error($driver->{dbh}->errstr);
    }
    1;
}

sub add_column {
    my $driver = shift;
    my @stmts = $driver->add_column_sql(@_);
    push @stmts, $driver->_index_column(@_);
    @stmts;
}

sub alter_column {
    my $driver = shift;
    $driver->alter_column_sql(@_);
}

sub drop_column {
    my $driver = shift;
    $driver->drop_column_sql(@_);
}

sub add_column_sql {
    my $driver = shift;
    my ($class, $name) = @_;
    my $pfx = $driver->table_prefix;
    my $sql = $driver->column_sql($class, $name);
    my $ds = $class->properties->{datasource};
    "alter table ${pfx}_$ds add $sql";
}
sub alter_column_sql {
    my $driver = shift;
    my ($class, $name) = @_;
    my $pfx = $driver->table_prefix;
    my $sql = $driver->column_sql($class, $name);
    my $ds = $class->properties->{datasource};
    "alter table ${pfx}_$ds modify $sql";
}
sub drop_column_sql {
    my $driver = shift;
    my ($class, $name) = @_;
    my $pfx = $driver->table_prefix;
    my $ds = $class->properties->{datasource};
    "alter table ${pfx}_$ds drop ${ds}_$name";
}

sub column_sql {
    my $driver = shift;
    my ($class, $name) = @_;

    my $ds = $class->properties->{datasource};
    my $def = $class->column_def($name);
    my $type = $driver->type2db($def);
    my $nullable = '';
    if ($def->{not_null}) {
        $nullable = ' not null';
    }
    my $default = '';
    if ($def->{type} eq 'timestamp') {
        delete $def->{default} if exists $def->{default};
    }
    if (exists $def->{default}) {
        my $value = $def->{default};
        if (($def->{type} =~ m/time/) || $driver->is_date_col($name)) {
            $value = $driver->{dbh}->quote($driver->ts2db($value));
        } elsif ($def->{type} !~ m/int|float|boolean/) {
            $value = $driver->{dbh}->quote($value);
        }
        $default = ' default ' . $value;
    }
    my $key = '';
    if ($def->{key}) {
        $key = ' primary key';
    }
    $ds . '_' . $name . ' ' . $type . $nullable . $default . $key;
}

sub fix_class {
    my $driver = shift;
    my ($class) = @_;
    my $dbh = $driver->{dbh};

    my $db_defs = $driver->column_defs($class);

    my $exists = defined $db_defs ? 1 : 0;

    my $ds = $class->properties->{datasource};
    my $pfx = $driver->table_prefix;

    my @stmts;
    if ($exists) {
        push @stmts, "create table ${pfx}_${ds}_upgrade as select * from ${pfx}_$ds";
        push @stmts, $driver->_drop_table($class);
    }

    push @stmts, $driver->_create_table($class);

    if ($exists) {
        push @stmts, $driver->_insert_from($class, $db_defs);
    }

    push @stmts, $driver->_index_table($class);        

    # everything is cool, so drop the upgrade table
    push @stmts, "drop table ${pfx}_${ds}_upgrade" if $exists;

    @stmts;
}

sub _insert_from {
    my $driver = shift;
    my ($class, $db_defs) = @_;

    my $ddl = '';

    my $props = $class->properties;
    my $class_defs = $class->column_defs;
    return 0 if !$class_defs;

    my $pfx = $driver->table_prefix;
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

    my $ds = $props->{datasource};
    $ddl = "insert into ${pfx}_$ds (";

    my $to_fields = '';
    foreach (@fields_to) {
        $to_fields .= ',' if $to_fields ne '';
        $to_fields .= $ds . '_' . $_;
    }
    $ddl .= $to_fields;

    my $new_fields = '';
    foreach (@new_fields) {
        $new_fields .= ',' if $new_fields ne '';
        $new_fields .= $ds . '_' . $_;
    }
    $ddl .= ',' if $to_fields && $new_fields;
    $ddl .= $new_fields;
    $ddl .= ')';

    $ddl .= "\nselect ";
    my $from_fields = '';
    foreach my $col (@fields_from) {
        $from_fields .= ',' if $from_fields ne '';
        my $def = $class_defs->{$col};
        if (defined $def) {
            if ($driver->type2db($def) ne $driver->type2db($db_defs->{$col})) {
                $from_fields .= $driver->_cast_column($class, $col, $db_defs->{$col});
            } else {
                $from_fields .= $ds.'_'.$col;
            }
        } else {
            $from_fields .= $ds.'_'.$col;
        }
    }
    $ddl .= $from_fields;
    if (@new_fields) {
        $ddl .= ',' if @fields_from;
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
                if (($def->{type} =~ m/time/) || $driver->is_date_col($col)) {
                    $value = $driver->{dbh}->quote($driver->ts2db($value));
                } elsif ($def->{type} !~ m/int|float|boolean/) {
                    $value = $driver->{dbh}->quote($value);
                }
            }
            $value = 'NULL' if !defined $value;
            $new_fields .= $value;
        }
        $ddl .= $new_fields;
    }
    $ddl .= "\nfrom ${pfx}_${ds}_upgrade";

    $ddl;
}

sub _drop_table {
    my $driver = shift;
    my ($class) = @_;
    my $ds = $class->properties->{datasource};
    my $pfx = $driver->table_prefix;
    my $dbh = $driver->{dbh};
    "drop table ${pfx}_$ds";
}

sub _create_table {
    my $driver = shift;
    my ($class) = @_;

    my $ds = $class->properties->{datasource};
    my $pfx = $driver->table_prefix;
    my $table_ddl = "create table ${pfx}_$ds ( \n";
    my @cols;
    # make sure new columns are at the end...
    my $defs = $class->column_defs;
    return 0 unless $defs;
    my $col_names = $class->column_names;
    foreach my $name (@$col_names) {
        my $def = $defs->{$name};
        next unless defined $def;
        my $sql = $driver->column_sql($class, $name);
        push @cols, $sql;
    }
    $table_ddl .= "\t" . (join ",\n\t", @cols) . "\n";
    $table_ddl .= ')'; 

    $table_ddl;
}

sub _index_table {
    my $driver = shift;
    my ($class) = @_;

    # since our newly created table already has an index
    # for the primary key field, all we need to do is create
    # any supplemental indexes and/or unique constraints

    my $props = $class->properties;
    my $pfx = $driver->table_prefix;
    my $indexes = $props->{indexes};
    my $ds = $props->{datasource};

    my @stmts;
    if ($indexes) {
        my $pk = $props->{primary_key};
        foreach my $name (keys %$indexes) {
            next if $pk && $name eq $pk;

            my $ddl = "create index ${pfx}_${ds}_$name on ${pfx}_$ds (${ds}_$name)";
            push @stmts, $ddl;
        }
    }

    @stmts;
}

sub _index_column {
    my $driver = shift;
    my ($class, $name) = @_;

    my $props = $class->properties;
    my $pfx = $driver->table_prefix;
    my $indexes = $props->{indexes};
    my $ds = $props->{datasource};
    my @stmts;
    if ($indexes) {
        return () unless $indexes->{$name};
        my $pk = $props->{primary_key};
        if (!($pk && $name eq $pk)) {
            my $ddl = "create index ${pfx}_${ds}_$name on ${pfx}_$ds (${ds}_$name)";
            push @stmts, $ddl;
        }
    }
    @stmts;
}

1;
