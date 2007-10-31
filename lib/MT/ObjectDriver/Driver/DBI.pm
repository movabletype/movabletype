# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::ObjectDriver::Driver::DBI;

use strict;
use base qw( Data::ObjectDriver::Driver::DBI );

sub init {
    my $driver = shift;
    my (%param) = @_;
    $param{prefix} ||= 'mt_';
    $driver->SUPER::init(%param);
    my $opts = $driver->connect_options || {};
    $opts->{RaiseError} = 0;
    $driver->connect_options($opts);
    $driver;
}

sub configure {
    my $driver = shift;
    $driver->dbd->configure($driver, @_);
}

sub table_exists {
    my $driver = shift;
    my ($class) = @_;
    return $driver->dbd->ddl_class->table_exists($class);
}

# Be mindful of SQLite when you modify the method.
# SQLite has its own count method in its DBD.
sub count {
    my $driver = shift;
    my($class, $terms, $args) = @_;

    my $join = $args->{join};
    my $select = 'COUNT(*)';
    if ($join && $join->[3]->{unique}) {
        my $col;
        if ($join->[3]{unique} =~ m/\D/) {
            $col = $args->{join}[3]{unique};
        } else {
            $col = $class->properties->{primary_key};
        }
        my $dbcol = $driver->dbd->db_column_name($class->datasource, $col);
        $select = "COUNT(DISTINCT $dbcol)";
    }

    return $driver->_select_aggregate(
        select   => $select,
        class    => $class,
        terms    => $terms,
        args     => $args,
        override => {
                     order  => '',
                     limit  => undef,
                     offset => undef,
                    },
    );
}

sub remove_all {
    my $driver = shift;
    my ($class) = @_;
    return $driver->direct_remove($class);
}

sub count_group_by {
    my $driver = shift;
    my ($class, $terms, $args) = @_;

    $driver->_do_group_by('COUNT(*)', @_);
}

sub sum_group_by {
    my $driver = shift;
    my ($class, $terms, $args) = @_;

    my $sum_column = delete $args->{sum};
    return unless $sum_column;
    $sum_column = $driver->_decorate_column_name($class, $sum_column);
    $args->{sort} = "sum_$sum_column" unless exists $args->{sort};
    $args->{direction} = 'descend' unless exists $args->{direction};
    $driver->_do_group_by("SUM($sum_column) AS sum_$sum_column", @_);
}

sub _do_group_by {
    my $driver = shift;
    my ($agg_func, $class, $terms, $args) = @_;
    my $props = $class->properties;
    if ($props->{class_type}) {
        my $class_col = $props->{class_column};
        unless ($terms->{$class_col}) {
            $terms->{$class_col} = $class->class_type;
        }
    }
    if ($args->{no_class}) {
        delete $terms->{$props->{class_column}};
        delete $args->{no_class};
    }
    my $order = delete $args->{sort};
    my $direction = delete $args->{direction};
    my $limit = exists $args->{limit} ? delete $args->{limit} : undef;
    my $stmt = $driver->prepare_statement($class, $terms, $args);

    ## Ugly. Maybe we need a clear_select method in D::OD::SQL?
    $stmt->select([]);
    $stmt->select_map({});
    $stmt->select_map_reverse({});

    $stmt->add_select($agg_func);

    ## This is the nastiest thing I've ever seen. The caller should really
    ## just give the full column name, instead, rather than having to
    ## loop over all of the columns to replace something like
    ## EXTRACT(year FROM created_on) with EXTRACT(year FROM entry_created_on).
    my $decorate = $stmt->field_decorator($class);

    my @group = map { $decorate->($_) } @{ $args->{group} };
    for my $term (@group) {
        $stmt->add_select($term);
    }
    $stmt->group([ map { { column => $_ } } @group ]);

    ## Ugly.
    my $sql = $stmt->as_sql;
    if ($order) {
        $sql .= "\nORDER BY " . $decorate->($order);
        if ($direction) {
            $sql .= $direction eq 'descend' ? ' DESC' : ' ASC';
        }
    }

    my $dbh = $driver->r_handle;
    $driver->start_query($sql, $stmt->bind);
    my $sth = $dbh->prepare_cached($sql);
    $sth->execute(@{ $stmt->bind });

    my @bindvars;
    for (@{ $args->{group} }) {
        push @bindvars, \my($var);
    }
    $sth->bind_columns(undef, \my($count), @bindvars);

    my $i = 0;
    return sub {
        unless ($sth->fetch && defined $count && (!defined $limit || ($i < $limit))) {
            $sth->finish;
            $driver->end_query($sth);
            return;
        }
        my @returnvals = map { $$_ } @bindvars;
        $i++;
        return($count, @returnvals);
    }
}

sub _select_aggregate {
    my $driver = shift;
    my %param = @_;

    my($class, $orig_terms, $orig_args) = @param{qw( class terms args )};
    my $overrides = $param{override};
    my $select = $param{select};

    ## Handle legacy load-by-id syntax.
    if($orig_terms && !ref $orig_terms) {
        $orig_terms = { id => $orig_terms };
    }

    ## Convert $terms and $args like we would for a search.
    my $terms = $orig_terms ? { %$orig_terms } : undef;
    my $args  = $orig_args  ? { %$orig_args  } : undef;
    $class->call_trigger('pre_search', $terms, $args);

    my $stmt = $driver->prepare_statement($class, $terms, $args);
    ## Remove any unnecessary clauses, because they will cause errors in
    ## some drivers (and they're not necessary)
    while(my ($clause, $value) = each %$overrides) {
        $stmt->$clause($value);
    }
    $stmt->select([]);
    my $sql = "SELECT $select\n" . $stmt->as_sql;
    $driver->select_one($sql, $stmt->bind);
}

sub _decorate_column_names_in {
    my $driver = shift;
    my ($hash, $class) = @_;

    my $dbd = $driver->dbd;
    for my $col (keys %$hash) {
        my $new_col = $dbd->db_column_name($class->datasource, $col);
        $hash->{$new_col} = delete $hash->{$col};
    }

    return $hash;
}

sub _decorate_column_name {
    my $driver = shift;
    my ($class, $col) = @_;
    return $driver->dbd->db_column_name($class->datasource, $col);
}

sub prepare_statement {
    my $driver = shift;
    my($class, $terms, $orig_args) = @_;
    my $args = defined $orig_args ? { %$orig_args } : {};

    my %stmt_args;

    ## Statements don't know anything about table/column name decoration,
    ## so for any set of column names we send the statement, we must pre-
    ## decorate the column names.

    for my $arg (qw( transform range range_incl not null not_null like binary count_distinct )) {
        if(exists $args->{$arg}) {
            my %stmt_data = %{ delete $args->{$arg} };
            $driver->_decorate_column_names_in(\%stmt_data, $class);
            $stmt_args{$arg} = \%stmt_data;
        }
    }

    ## Tell the statement what's a date column.
    if(my $date_columns = $class->columns_of_type('datetime')) {
        my %date_columns_hash;
        @date_columns_hash{@$date_columns} = (1) x scalar @$date_columns;
        $driver->_decorate_column_names_in(\%date_columns_hash, $class);
        $stmt_args{date_columns} = \%date_columns_hash;
    }

    ## Tell the statement what's a lob column.
    if(my $lob_columns = $class->columns_of_type('text', 'blob')) {
        my %lob_columns_hash;
        @lob_columns_hash{@$lob_columns} = (1) x scalar @$lob_columns;
        $driver->_decorate_column_names_in(\%lob_columns_hash, $class);
        $stmt_args{lob_columns} = \%lob_columns_hash;
    }

    my $join = delete $args->{join};

    ## Convert fetchonly args from legacy hashes to Data::ObjectDriver's
    ## expected arrays.
    ## TODO: handle this in MT::OD::SQL instead of converting a hash to an
    ## array to a hash again?
    if(exists $args->{fetchonly}) {
        if ('HASH' eq ref $args->{fetchonly}) {
            $args->{fetchonly} = [ keys %{ $args->{fetchonly} } ];
        }
    }

    ## Make sure to include our ORDER BY field in the SELECT fields if
    ## we're doing a SELECT DISTINCT (for postgres).
    if($join && $join->[3]->{unique}) {
        my $sort = $args->{sort};
        if (my $fonly = $args->{fetchonly}) {
            if (defined $sort) {
                unless (grep { $_ eq $sort } @$fonly) {
                    push @$fonly, $sort;
                }
            }
            $args->{fetchonly} = $fonly;
        }

        my $j_sort = $join->[3]->{sort};
        if (my $j_fonly = $join->[3]->{fetchonly}) {
            if (defined $j_sort) {
                unless (grep { $_ eq $j_sort } @$j_fonly) {
                    push @$j_fonly, $j_sort;
                }
            }
            $join->[3]->{fetchonly} = $j_fonly;
        }
    }

    my $start_val = $args->{sort} ? delete $args->{start_val} : undef;

    my $stmt = $driver->dbd->sql_class->new(%stmt_args);

    ## START CORE D::OD::Driver::DBI prepare_statement
    my $dbd = $driver->dbd;
    my $tbl = $driver->table_for($class);

    if ($tbl) {
        my $cols = $class->column_names;
        my %fetch = $args->{fetchonly} ?
            (map { $_ => 1 } @{ $args->{fetchonly} }) : ();
        my $skip = $stmt->select_map_reverse;
        for my $col (@$cols) {
            next if $skip->{$col};
            if (keys %fetch) {
                next unless $fetch{$col};
            }
            my $dbcol = $dbd->db_column_name($tbl, $col);
            $stmt->add_select($dbcol => $col);
        }

        $stmt->from([ $tbl ]);

        if (defined($terms)) {
            for my $col (keys %$terms) {
                my $db_col = $dbd->db_column_name($tbl, $col);
                $stmt->add_where($db_col, $terms->{$col});
            }
        }

        ## Set statement's ORDER clause if any.
        if ($args->{sort} || $args->{direction}) {
            my $order = $args->{sort} || 'id';
            my $dir = $args->{direction} &&
                      $args->{direction} eq 'descend' ? 'DESC' : 'ASC';
            $stmt->order({
                column => $dbd->db_column_name($tbl, $order),
                desc   => $dir,
            });
        }
    }
    $stmt->limit($args->{limit}) if $args->{limit};
    $stmt->offset($args->{offset}) if $args->{offset};

    if (my $terms = $args->{having}) {
        for my $col (keys %$terms) {
            $stmt->add_having($col => $terms->{$col});
        }
    }
    ## END

    ## Keep the statement reference we're going to return with, in case
    ## we have to subselect from it.
    my $major_stmt = $stmt;

    ## Implement `join` arg like MT::ObjectDriver, for compatibility.
    if($join) {
        my ($j_class, $j_col, $j_terms, $j_args) = @$join;
        my $j_unique;
        if($j_unique = delete $j_args->{unique}) {
            $stmt->distinct(1);
        }

        ## Handle legacy load-by-ID in join.
        if(defined $j_terms && !ref $j_terms) {
            ## TODO: don't assume primary key
            my $key = $j_class->properties->{primary_key};
            $j_terms = { $key => $j_terms };
        }

        my $join_stmt = $driver->prepare_statement($j_class, $j_terms, $j_args);  # recursive

        $j_args->{unique} = $j_unique if $j_unique;

        for my $field (qw( from where bind )) {
            push @{ $stmt->$field() }, @{ $join_stmt->$field() };
        }
        $stmt->from_stmt($join_stmt->from_stmt);
        $stmt->limit($j_args->{limit}) if exists $j_args->{limit};
        $stmt->offset($j_args->{offset}) if exists $j_args->{offset};

        if($join_stmt->order) {
            ## Preserve the sort order.
            my @new_order;
            for my $sql_stmt ($stmt, $join_stmt) {
                if(my $order = $sql_stmt->order) {
                    if('ARRAY' eq ref $order) {
                        push @new_order, @$order;
                    } else {
                        push @new_order, $order;
                    }
                }
            }
            $stmt->order(\@new_order);

            if ($stmt->distinct) {
                $major_stmt = $driver->dbd->sql_class->distinct_stmt($stmt);
            }
        }

        ## Join across the given column(s).
        $j_col = [$j_col] unless ref $j_col;
        my $tuple = $class->primary_key_tuple;
        COLUMN: foreach my $i (0..$#$j_col) {
            next unless defined $j_col->[$i];
            my $t = $tuple->[$i];
            my $c = $j_col->[$i];

            my $where_col = $driver->_decorate_column_name($class, $t);
            my $dec_j_col = $driver->_decorate_column_name($j_class, $c);
            my $where_val = "= $dec_j_col";
            $stmt->add_where($where_col, \$where_val);
        }
    }

    if ($start_val) {
        ## TODO: support complex primary keys
        my $col = $args->{sort} || $class->primary_key;
        $col = $driver->_decorate_column_name($class, $col);
        my $op = $args->{direction} eq 'descend' ? '<' : '>';
        $stmt->add_where($col, { value => $start_val, op => $op });
    }

    ## Return with this reference, because we might have wrapped $stmt in
    ## a subselect.
    return $major_stmt;
}

sub sql {
    my $driver = shift;
    my ($sql) = @_;
    my $dbh = $driver->rw_handle;
    if (!ref $sql) {
        $sql = [ $sql ];
    }
    foreach (@$sql) {
        $dbh->do($_) or return $driver->error($dbh->errstr);
    }
    1;
}   

1;
__END__

=head1 NAME

MT::ObjectDriver::Driver::DBI

=head1 METHODS

TODO

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
