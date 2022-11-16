# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ObjectDriver::Driver::DBI;

use strict;
use warnings;
use base qw( Data::ObjectDriver::Driver::DBI );

sub PING_CHECK_THROTTLE () {5}

__PACKAGE__->mk_accessors(qw( role ));

sub init {
    my $driver = shift;
    my (%param) = @_;
    $param{prefix} ||= 'mt_';
    $driver->SUPER::init(%param);
    my $opts = $driver->connect_options || {};

    require MT;
    my $mt  = MT->instance;
    my $cfg = $mt->config;
    $opts->{RaiseError}         = $cfg->DBIRaiseError;
    $opts->{ShowErrorStatement} = $cfg->DBIShowErrorStatement if $MT::DebugMode;

    $driver->connect_options($opts);
    $driver;
}

sub init_db {

    my $driver = shift;
    my $dbh;

    require MT;
    my $mt        = MT->instance;
    my $cfg       = $mt->config;
    my $retry_max = $cfg->DBMaxRetries || 0;
    my $retry_int = $cfg->DBRetryInterval || 0;
    my $retry     = 0;

RETRY_CONN:
    eval { $dbh = $driver->SUPER::init_db(@_); };

    if ( my $err = $@ ) {
        require MT::I18N;
        my $from = MT::I18N::guess_encoding($err) || 'utf-8';
        my $to   = $cfg->PublishCharset           || 'utf-8';
        $err = Encode::encode_utf8($err) if Encode::is_utf8($err);
        Encode::from_to( $err, $from, $to );

        if ( $retry++ < $retry_max ) {
            warn $err if $cfg->DebugMode;
            sleep $retry_int;
            goto RETRY_CONN;
        }
        else {
            Carp::croak($err);
        }
    }
    return $dbh;
}

sub start_query {
    my $driver = shift;
    my ( $sql, $bind ) = @_;
    if ( $MT::DebugMode && $MT::DebugMode & 4 ) {
        local @MT::ObjectDriver::Driver::DBI::CARP_NOT = qw/
            Data::ObjectDriver::Driver::BaseCache
            /;
        local @Data::ObjectDriver::Driver::BaseCache::CARP_NOT = qw/
            Data::ObjectDriver::Driver::DBI
            /;
        local @Data::ObjectDriver::Driver::DBI::CARP_NOT = qw/
            Data::ObjectDriver::BaseObject
            /;
        $sql =~ s/\r?\n/ /g;
        Carp::carp "QUERY: $sql";
    }
    return $driver->SUPER::start_query(@_);
}

sub dbh_handle {
    my $driver = shift;
    my ($opt)  = @_;
    my $dbh    = $driver->dbh;
    if ($dbh) {
        if ( !$dbh->{private_last_ping}
            || ( $dbh->{private_last_ping} + PING_CHECK_THROTTLE < time ) )
        {
            if ( $dbh->ping ) {
                $dbh->{private_last_ping} = time;
            }
            else {
                $driver->dbh( $dbh = undef );
            }
        }
    }
    unless ($dbh) {
        if ( my $getter = $driver->get_dbh ) {
            local $opt->{driver} = $driver;
            $dbh = $getter->($opt);
            $dbh->{private_last_ping} = time if $dbh;
        }
        else {
            $dbh = $driver->init_db() or die $driver->last_error;
            my $orig_reuse = $driver->reuse_dbh;
            if ( $orig_reuse && !$dbh->ping ) {

                # A database connection has been reused,
                # but this is probably already expired.
                $driver->reuse_dbh(0);
                $dbh = $driver->init_db() or die $driver->last_error;
                $driver->reuse_dbh($orig_reuse);
            }
            $dbh->{private_last_ping} = time;
            $driver->dbh($dbh);
        }
    }
    $dbh;
}
*rw_handle = \&dbh_handle;

sub r_handle {
    my $driver = shift;
    return $driver->dbh_handle( { readonly => 1 } );
}

sub configure {
    my $driver = shift;
    $driver->dbd->configure( $driver, @_ );
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
    my ( $class, $terms, $args ) = @_;

    my @joins = ( $args->{join}, @{ $args->{joins} || [] } );
    my $select = 'COUNT(*)';
    for my $join (@joins) {
        if ( $join && $join->[3]->{unique} ) {
            my $col;
            if ( $join->[3]{unique} =~ m/\D/ ) {
                $col = $args->{join}[3]{unique};
            }
            else {
                $col = $class->properties->{primary_key};
            }
            my $dbcol
                = $driver->dbd->db_column_name( $class->datasource, $col,
                $args->{alias} );
            $select = "COUNT(DISTINCT $dbcol)";
        }
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

sub exist {
    my $driver = shift;
    my ( $class, $terms, $args ) = @_;

    return $driver->_select_aggregate(
        select   => '1',
        class    => $class,
        terms    => $terms,
        args     => $args,
        override => {
            order  => '',
            limit  => 1,
            offset => undef,
        },
    );
}

sub remove_all {
    my $driver = shift;
    my ($class) = @_;
    return $driver->direct_remove($class);
}

sub direct_remove {
    my $driver = shift;
    my ( $class, $orig_terms, $orig_args ) = @_;
    $class->call_trigger( 'pre_direct_remove', $orig_terms, $orig_args );
    $driver->SUPER::direct_remove(@_);
}

sub count_group_by {
    my $driver = shift;
    my ( $class, $terms, $args ) = @_;

    $driver->_do_group_by( 'COUNT(*) AS cnt', @_ );
}

sub sum_group_by {
    my $driver = shift;
    my ( $class, $terms, $args ) = @_;

    my $sum_column = delete $args->{sum};
    return unless $sum_column;
    $sum_column = $driver->_decorate_column_name( $class, $sum_column );
    $args->{sort}      = "sum_$sum_column" unless exists $args->{sort};
    $args->{direction} = 'descend'         unless exists $args->{direction};
    $driver->_do_group_by( "SUM($sum_column) AS sum_$sum_column", @_ );
}

sub avg_group_by {
    my $driver = shift;
    my ( $class, $terms, $args ) = @_;

    my $avg_column = delete $args->{avg};
    return unless $avg_column;
    $avg_column = $driver->_decorate_column_name( $class, $avg_column );
    $args->{sort}      = "avg_$avg_column" unless exists $args->{sort};
    $args->{direction} = 'descend'         unless exists $args->{direction};
    $driver->_do_group_by( "AVG($avg_column) AS avg_$avg_column", @_ );
}

sub max_group_by {
    my $driver = shift;
    my ( $class, $terms, $args ) = @_;

    my $max_column = delete $args->{max};
    return unless $max_column;
    $max_column = $driver->_decorate_column_name( $class, $max_column );
    $args->{sort}      = "max_$max_column" unless exists $args->{sort};
    $args->{direction} = 'descend'         unless exists $args->{direction};
    $driver->_do_group_by( "MAX($max_column) AS max_$max_column", @_ );
}

sub _do_group_by {
    my $driver = shift;
    my ( $agg_func, $class, $terms, $args ) = @_;
    my $props = $class->properties;
    $terms ||= {};
    $args  ||= {};    # declare these for pre_search to work
    $class->call_trigger( 'pre_search', $terms, $args );
    my $order = delete $args->{sort} || '';
    my $direction = delete $args->{direction};
    if ( $order =~ /\sdesc|asc/i ) {
        my @new_order;
        while ( $order =~ /(?:\s*([\w\s\(\)]+?)\s(desc|asc))/ig ) {
            push @new_order, { column => $1, desc => $2 };
        }
        $order = \@new_order if @new_order;
    }
    my $limit  = exists $args->{limit}  ? $args->{limit}  : undef;
    my $offset = exists $args->{offset} ? $args->{offset} : undef;
    my $stmt = $driver->prepare_statement( $class, $terms, $args );

    ## Ugly. Maybe we need a clear_select method in D::OD::SQL?
    $stmt->select( [] );
    $stmt->select_map(         {} );
    $stmt->select_map_reverse( {} );

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
    $stmt->group( [ map { { column => $_ } } @group ] );

    ## Set statement's ORDER clause if any.
    if ($order) {
        if ( !ref($order) ) {
            $stmt->order(
                [   {   column => $decorate->($order),
                        desc   => ( $direction || '' ) eq 'descend'
                        ? 'DESC'
                        : 'ASC'
                    }
                ]
            );
        }
        else {
            my @order;
            foreach my $ord (@$order) {
                push @order,
                    {
                    column => $decorate->( $ord->{column} ),
                    desc   => $ord->{desc},
                    };
            }
            $stmt->order( \@order );
        }
    }

    my $sql = $stmt->as_sql;

    my $dbh = $driver->r_handle;
    $driver->start_query( $sql, $stmt->bind );
    my $sth = $dbh->prepare_cached($sql);
    $sth->execute( @{ $stmt->bind } );

    my @bindvars;
    my $col_count = scalar @{ $stmt->select };
    $col_count--;
    for ( 1 .. $col_count ) {
        push @bindvars, \my ($var);
    }
    $sth->bind_columns( undef, \my ($count), @bindvars );

    my $i      = 0;
    my $finish = sub {
        return unless $sth;
        $sth->finish;
        $driver->end_query($sth);
        undef $sth;
    };
    my $iter = sub {
        unless ( $sth->fetch
            && defined $count
            && ( !defined $limit || ( $i < $limit ) ) )
        {
            $sth->finish;
            $driver->end_query($sth);
            return;
        }
        my @returnvals = map {$$_} @bindvars;
        $i++;
        $class->call_trigger( 'post_group_by', \$count, \@returnvals )
            unless $args->{no_triggers};
        return ( $count, @returnvals );
    };
    return Data::ObjectDriver::Iterator->new( $iter, $finish );
}

sub _select_aggregate {
    my $driver = shift;
    my %param  = @_;

    my ( $class, $orig_terms, $orig_args ) = @param{qw( class terms args )};
    my $overrides = $param{override};
    my $select    = $param{select};

    ## Handle legacy load-by-id syntax.
    if ( $orig_terms && !ref $orig_terms ) {
        $orig_terms = { id => $orig_terms };
    }

    ## Convert $terms and $args like we would for a search.
    my $terms = {};
    if ( ref($orig_terms) eq 'HASH' ) {
        $terms = {%$orig_terms};
    }
    elsif ( ref($orig_terms) eq 'ARRAY' ) {
        $terms = [@$orig_terms];
    }
    my $args = $orig_args ? {%$orig_args} : {};
    $class->call_trigger( 'pre_search', $terms, $args );

    my $stmt = $driver->prepare_statement( $class, $terms, $args );
    ## Remove any unnecessary clauses, because they will cause errors in
    ## some drivers (and they're not necessary)
    while ( my ( $clause, $value ) = each %$overrides ) {
        $stmt->$clause($value);
    }
    $stmt->select( [] );
    $stmt->select_map(         {} );
    $stmt->select_map_reverse( {} );
    $stmt->add_select( $select => $select );
    my $sql = $stmt->as_sql;
    my $value = $driver->select_one( $sql, $stmt->bind );
    $class->call_trigger( 'post_select_aggregate', \$value )
        unless $orig_args->{no_triggers};
    return $value;
}

sub _decorate_column_names_in {
    my $driver = shift;
    my ( $hash, $class, $alias ) = @_;

    my $dbd = $driver->dbd;
    for my $col ( keys %$hash ) {
        my $new_col
            = $dbd->db_column_name( $class->datasource, $col, $alias );
        $hash->{$new_col} = delete $hash->{$col};
    }

    return $hash;
}

sub _decorate_column_name {
    my $driver = shift;
    my ( $class, $col, $alias ) = @_;
    my $name
        = $driver->dbd->db_column_name( $class->datasource, $col, $alias );
    $name;
}

sub prepare_statement {
    my $driver = shift;
    my ( $class, $terms, $orig_args, $recursive ) = @_;
    my $args = defined $orig_args ? {%$orig_args} : {};

    my @joins = (
        ( $args->{join}  ? $args->{join}       : () ),
        ( $args->{joins} ? @{ $args->{joins} } : () ),
    );
    my %stmt_args;
    my $alias = $orig_args->{alias};

    ## Statements don't know anything about table/column name decoration,
    ## so for any set of column names we send the statement, we must pre-
    ## decorate the column names.

    for my $arg (
        qw( transform range range_incl not null not_null like binary count_distinct )
        )
    {
        if ( exists $args->{$arg} ) {
            my %stmt_data = %{ $args->{$arg} };
            $driver->_decorate_column_names_in( \%stmt_data, $class, $alias );
            $stmt_args{$arg} = \%stmt_data;
        }
    }

    ## Tell the statement what's a date column.
    if ( my $date_columns = $class->columns_of_type('datetime') ) {
        my %date_columns_hash;
        @date_columns_hash{@$date_columns} = (1) x scalar @$date_columns;
        $driver->_decorate_column_names_in( \%date_columns_hash, $class,
            $alias );
        $stmt_args{date_columns} = \%date_columns_hash;
    }

    ## Tell the statement what's a lob column.
    if ( my $lob_columns = $class->columns_of_type( 'text', 'blob' ) ) {
        my %lob_columns_hash;
        @lob_columns_hash{@$lob_columns} = (1) x scalar @$lob_columns;
        $driver->_decorate_column_names_in( \%lob_columns_hash, $class,
            $alias );
        $stmt_args{lob_columns} = \%lob_columns_hash;
    }

    my $join = $args->{join};

    ## Convert fetchonly args from legacy hashes to Data::ObjectDriver's
    ## expected arrays.
    ## TODO: handle this in MT::OD::SQL instead of converting a hash to an
    ## array to a hash again?
    if ( exists $args->{fetchonly} ) {
        if ( 'HASH' eq ref $args->{fetchonly} ) {
            $args->{fetchonly} = [ keys %{ $args->{fetchonly} } ];
        }
    }

    ## Make sure to include our ORDER BY field in the SELECT fields if
    ## we're doing a SELECT DISTINCT (for postgres).
    if ( $join && $join->[3]->{unique} ) {
        my $sort = $args->{sort};
        if ( my $fonly = $args->{fetchonly} ) {
            if ( defined $sort ) {
                unless ( grep { $_ eq $sort } @$fonly ) {
                    push @$fonly, $sort;
                }
            }
            $args->{fetchonly} = $fonly;
        }

        my $j_sort = $join->[3]->{sort};
        if ( my $j_fonly = $join->[3]->{fetchonly} ) {
            if ( defined $j_sort ) {
                unless ( grep { $_ eq $j_sort } @$j_fonly ) {
                    push @$j_fonly, $j_sort;
                }
            }
            $join->[3]->{fetchonly} = $j_fonly;
        }
    }

    my $start_val = $args->{sort} ? $args->{start_val} : undef;

    my $stmt = $driver->dbd->sql_class->new(%stmt_args);

    ## START CORE D::OD::Driver::DBI prepare_statement
    my $dbd = $driver->dbd;
    my $tbl = $driver->table_for($class);

    if ($tbl) {
        my $cols = $class->column_names;
        my %fetch
            = $args->{fetchonly}
            ? ( map { $_ => 1 } @{ $args->{fetchonly} } )
            : ();
        my $skip = $stmt->select_map_reverse;
        for my $col (@$cols) {
            next if $skip->{$col};
            if ( keys %fetch ) {
                next unless $fetch{$col};
            }
            my $dbcol = $dbd->db_column_name( $tbl, $col, $alias );
            $stmt->add_select( $dbcol => $col );
        }
        if ($alias) {
            $stmt->from( ["$tbl $alias"] );
        }
        else {
            $stmt->from( [$tbl] );
        }

        if ( defined($terms) ) {
            my $mutator = $stmt->column_mutator;
            $stmt->column_mutator(
                sub {
                    my ($col) = @_;
                    my $db_col = $dbd->db_column_name( $tbl, $col, $alias );
                    if ( $mutator && 'CODE' eq ref($mutator) ) {
                        $db_col = $mutator->($db_col);
                    }
                    return $db_col;
                }
            );
            if ( ref $terms eq 'ARRAY' ) {
                $stmt->add_complex_where($terms);
            }
            else {
                for my $col ( keys %$terms ) {
                    $stmt->add_where( join( '.', $alias || $tbl, $col ),
                        $terms->{$col} );
                }
            }
            $stmt->column_mutator(undef);
        }

        ## Set statement's ORDER clause if any.
        if ( $args->{sort} || $args->{direction} ) {
            my $order = $args->{sort} || 'id';
            if ( !ref($order) ) {
                my $dir = $args->{direction}
                    && $args->{direction} eq 'descend' ? 'DESC' : 'ASC';
                $stmt->order(
                    {   column =>
                            $dbd->db_column_name( $tbl, $order, $alias ),
                        desc => $dir,
                    }
                );
            }
            else {
                my @order;
                foreach my $ord (@$order) {
                    push @order,
                        {
                        column => $dbd->db_column_name(
                            $tbl, $ord->{column}, $alias
                        ),
                        desc => $ord->{desc},
                        };
                }
                $stmt->order( \@order );
            }
        }

        if ( my $ft_arg = $args->{'freetext'} ) {
            my @columns = map { $dbd->db_column_name( $tbl, $_, $alias ) }
                @{ $ft_arg->{'columns'} };
            $stmt->add_freetext_where( \@columns,
                $ft_arg->{'search_string'} );
        }
    }
    $stmt->limit( $args->{limit} )   if $args->{limit};
    $stmt->offset( $args->{offset} ) if $args->{offset};

    if ( my $terms = $args->{having} ) {
        for my $col ( keys %$terms ) {
            $stmt->add_having( $col => $terms->{$col} );
        }
    }
    ## END

    ## Keep the statement reference we're going to return with, in case
    ## we have to subselect from it.
    my $major_stmt = $stmt;

    ## Implement `join` arg like MT::ObjectDriver, for compatibility.
    my %joined_table = ();
    my %seen_alias;
    while ( my $join = shift @joins ) {
        my ( $j_class, $j_col, $j_terms, $j_args ) = @$join;
        my $j_unique;
        if ( $j_unique = $j_args->{unique} ) {
            $stmt->distinct(1);
        }

        ## Handle legacy load-by-ID in join.
        if ( defined $j_terms && !ref $j_terms ) {
            ## TODO: don't assume primary key
            my $key = $j_class->properties->{primary_key};
            $j_terms = { $key => $j_terms };
        }

        my $join_stmt
            = $driver->prepare_statement( $j_class, $j_terms, $j_args, 1 )
            ;    # recursive

        $j_args->{unique} = $j_unique if $j_unique;

        for my $field (qw( from where bind )) {
            push @{ $stmt->$field() }, @{ $join_stmt->$field() };
        }

        ## Remove dupulicated from table.
        my %count;
        my @from = grep { !$count{$_}++ } @{ $stmt->from };
        $stmt->from( \@from );

        $stmt->from_stmt( $join_stmt->from_stmt );
        $stmt->limit( $j_args->{limit} )   if exists $j_args->{limit};
        $stmt->offset( $j_args->{offset} ) if exists $j_args->{offset};

        if ( $join_stmt->order ) {
            ## Preserve the sort order.
            my @new_order;
            for my $sql_stmt ( $stmt, $join_stmt ) {
                if ( my $order = $sql_stmt->order ) {
                    if ( 'ARRAY' eq ref $order ) {
                        push @new_order, @$order;
                    }
                    else {
                        push @new_order, $order;
                    }
                }
            }
            $stmt->order( \@new_order );

            if ( $stmt->distinct ) {
                $major_stmt = $driver->dbd->sql_class->distinct_stmt($stmt);
            }
        }

        $stmt->{joins}
            = [ @{ $stmt->{joins} || [] }, @{ $join_stmt->{joins} || [] } ]
            if $join_stmt->{joins};

        if ( $j_args->{type} ) {
            my $cond = $j_args->{condition};
            my $cond_query;
            my $to_class
                = $j_args->{to}
                ? MT->model( $j_args->{to} )
                : $class;
            my $to_table = $driver->table_for($to_class);
            my $j_table  = $driver->table_for($j_class);
            my $j_alias  = $j_args->{alias};
            if ( $j_alias && $seen_alias{$j_alias}++ ) {
                $j_alias .= '_' . $seen_alias{$j_alias};
            }
            if ( 'HASH' eq ref $cond ) {
                my $dbh = $driver->rw_handle;
                foreach my $cond_col ( keys %$cond ) {
                    my $col = $driver->_decorate_column_name( $j_class,
                        $cond_col, $j_alias );
                    $cond_query .= ' AND ' if $cond_query;
                    my $condition = $cond->{$cond_col};
                    if ( 'SCALAR' eq ref $condition ) {
                        $condition = $$condition;
                    }
                    else {
                        $condition = ' = ' . $dbh->quote($condition);
                    }
                    $cond_query .= " $col " . $condition;
                }
            }
            else {
                $cond = [$cond] unless ref $cond;
                my $tuple = $to_class->primary_key_tuple;
            COLUMN: foreach my $i ( 0 .. $#$cond ) {
                    next unless defined $cond->[$i];
                    my $t = $tuple->[$i];
                    my $c = $cond->[$i];

                    my $where_col
                        = $driver->_decorate_column_name( $to_class, $t,
                        $j_alias );
                    my $dec_j_col
                        = $driver->_decorate_column_name( $j_class, $c,
                        $j_alias );
                    my $where_val = "$dec_j_col";
                    $cond_query .= ' AND ' if $cond_query;
                    $cond_query .= "$where_col = $where_val";
                }
            }

            $stmt->add_join(
                $to_table,
                {   table => $j_alias ? "$j_table $j_alias" : $j_table,
                    condition => $cond_query,
                    type      => $j_args->{type},
                },
            );

            $joined_table{$j_table} = $joined_table{$to_table} = 1;
        }
        else {
            ## Join across the given column(s).
            $j_col = [$j_col] unless ref $j_col;
            my $to_class
                = $j_args->{to}
                ? MT->model( $j_args->{to} )
                : $class;
            my $tuple   = $to_class->primary_key_tuple;
            my $j_alias = $j_args->{alias};
        COLUMN: foreach my $i ( 0 .. $#$j_col ) {
                next unless defined $j_col->[$i];
                my $t = $tuple->[$i];
                my $c = $j_col->[$i];

                my $where_col = $driver->_decorate_column_name( $to_class, $t,
                    $j_alias );
                my $dec_j_col = $driver->_decorate_column_name( $j_class, $c,
                    $j_alias );
                my $where_val = "= $dec_j_col";
                $stmt->add_where( $where_col, \$where_val );
            }
        }
    }
    $stmt->from( [ grep { !$joined_table{$_} } @{ $stmt->from } ] );

    if ($start_val) {
        ## TODO: support complex primary keys
        my $col = $args->{sort} || $class->primary_key;
        if ( ref $col eq 'ARRAY' ) {
            if ( ref $col->[0] eq 'HASH' ) {

                # complex 'sort' array/hash structure
                foreach (@$col) {
                    $_->{column} = $driver->_decorate_column_name( $class,
                        $_->{column} );
                }
            }
            else {

                # primary key as array of column names
                foreach (@$col) {
                    $_ = $driver->_decorate_column_name( $class, $_ );
                }
            }
        }
        else {
            $col = $driver->_decorate_column_name( $class, $col );
        }
        my $op = $args->{direction} eq 'descend' ? '<' : '>';
        $stmt->add_where( $col, { value => $start_val, op => $op } );
    }

    ## Always sort by primary keys.
    my @pk = @{ $class->primary_key_tuple() || [] };
    if (   @pk
        && !$recursive
        && !$orig_args->{group} )
    {
        my @column_id = map { $dbd->db_column_name( $tbl, $_, $alias ) } @pk;
        if ( my $order = $stmt->order() ) {
            if ( ref($order) eq 'HASH' ) {
                $order = [$order];
            }
            if ( ref($order) eq 'ARRAY' ) {
                my @order_id;
                foreach my $column_id (@column_id) {
                    if ( !( grep { $_->{column} eq $column_id } @$order ) ) {
                        push @order_id,
                            { column => $column_id, desc => 'ASC' };
                    }
                }
                if (@order_id) {
                    $stmt->order( [ @$order, @order_id ] );
                }
            }
        }
        else {
            $stmt->order(
                [ map { +{ column => $_, desc => 'ASC' } } @column_id ] );
        }
    }

    ## Return with this reference, because we might have wrapped $stmt in
    ## a subselect.
    return $major_stmt;
}

sub sql {
    my $driver = shift;
    my ($sql)  = @_;
    my $dbh    = $driver->rw_handle;
    if ( !ref $sql ) {
        $sql = [$sql];
    }
    foreach (@$sql) {
        $dbh->do($_) or return $driver->last_error;
    }
    1;
}

sub search {
    my $driver = shift;
    $driver->SUPER::search(@_);
}

1;
__END__

=head1 NAME

MT::ObjectDriver::Driver::DBI

=head1 METHODS

TODO

=head1 Callbacks

MT::ObjectDriver::Driver::DBI fires the following callbacks,
or "triggers" when it loads data from the database.

=over 4

=item * post_select_aggregate

    callback($class, \$value)

Callback issued prior to returning the value that is retrieved
as the result of select_one method.

=item * post_group_by

    callback($class, \$value, \@returnvals)

Callback issued prior to returning the number and additional return
values that are retrieved as the result of grouping query.  The value
in the $value parameter is what was calculated from the database.
For example, in count_group_by method, $value holds the count for each
group, while in sum_group_by method, $value holds the sum for each group.
@returnvals parameter holds the additional data that wiil be retured.

=back

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
