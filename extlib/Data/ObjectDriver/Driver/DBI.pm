# $Id: DBI.pm 559 2009-01-24 00:30:59Z ykerherve $

package Data::ObjectDriver::Driver::DBI;
use strict;
use warnings;

use base qw( Data::ObjectDriver Class::Accessor::Fast );

use DBI;
use Carp ();
use Data::ObjectDriver::Errors;
use Data::ObjectDriver::SQL;
use Data::ObjectDriver::Driver::DBD;
use Data::ObjectDriver::Iterator;

__PACKAGE__->mk_accessors(qw( dsn username password connect_options dbh get_dbh dbd prefix reuse_dbh force_no_prepared_cache));


sub init {
    my $driver = shift;
    my %param = @_;
    for my $key (keys %param) {
        $driver->$key($param{$key});
    }
    if(!exists $param{dbd}) {
        ## Create a DSN-specific driver (e.g. "mysql").
        my $type;
        if (my $dsn = $driver->dsn) {
            ($type) = $dsn =~ /^dbi:(\w*)/i;
        } elsif (my $dbh = $driver->dbh) {
            $type = $dbh->{Driver}{Name};
        } elsif (my $getter = $driver->get_dbh) {
## Ugly. Shouldn't have to connect just to get the driver name.
            my $dbh = $getter->();
            $type = $dbh->{Driver}{Name};
        }
        $driver->dbd(Data::ObjectDriver::Driver::DBD->new($type));
    }
    $driver;
}

sub generate_pk {
    my $driver = shift;
    if (my $generator = $driver->pk_generator) {
        return $generator->(@_);
    }
}

# Some versions of SQLite require the undefing to finalise properly
sub _close_sth {
    my $sth = shift;
    $sth->finish;
    undef $sth;
}

# Some versions of SQLite have problems with prepared caching due to finalisation order
sub _prepare_cached {
    my $driver = shift;
    my $dbh    = shift;
    my $sql    = shift;
    return ($driver->dbd->can_prepare_cached_statements)? $dbh->prepare_cached($sql) : $dbh->prepare($sql);
}

my %Handles;
sub init_db {
    my $driver = shift;
    my $dbh;
    if ($driver->reuse_dbh) {
        $dbh = $Handles{$driver->dsn};
    }
    unless ($dbh) {
        eval {
            $dbh = DBI->connect($driver->dsn, $driver->username, $driver->password,
                { RaiseError => 1, PrintError => 0, AutoCommit => 1,
                %{$driver->connect_options || {}} })
                or Carp::croak("Connection error: " . $DBI::errstr);
        };
        if ($@) {
            Carp::croak($@);
        }
    }
    if ($driver->reuse_dbh) {
        $Handles{$driver->dsn} = $dbh;
    }
    $driver->dbd->init_dbh($dbh);
    $driver->{__dbh_init_by_driver} = 1;
    return $dbh;
}

sub rw_handle {
    my $driver = shift;
    my $db = shift || 'main';
    $driver->dbh(undef) if $driver->dbh and !$driver->dbh->ping;
    my $dbh = $driver->dbh;
    unless ($dbh) {
        if (my $getter = $driver->get_dbh) {
            $dbh = $getter->();
        } else {
            $dbh = $driver->init_db($db) or die $driver->last_error;
            $driver->dbh($dbh);
        }
    }
    $dbh;
}
*r_handle = \&rw_handle;

sub fetch_data {
    my $driver = shift;
    my($obj) = @_;
    return unless $obj->has_primary_key;
    my $terms = $obj->primary_key_to_terms;
    my $args  = { limit => 1 };
    my $rec = {};
    my $sth = $driver->fetch($rec, $obj, $terms, $args);
    $sth->fetch;
    _close_sth($sth);
    $driver->end_query($sth);
    return $rec;
}

sub prepare_fetch {
    my $driver = shift;
    my($class, $orig_terms, $orig_args) = @_;

    ## Use (shallow) duplicates so the pre_search trigger can modify them.
    my $terms = defined $orig_terms ? ( ref $orig_terms eq 'ARRAY' ? [ @$orig_terms ] : { %$orig_terms } ) : {};
    my $args  = defined $orig_args  ? { %$orig_args  } : {};
    $class->call_trigger('pre_search', $terms, $args);

    my $stmt = $driver->prepare_statement($class, $terms, $args);

    my $sql = $stmt->as_sql;
    $sql .= "\nFOR UPDATE" if $orig_args->{for_update};
    return ($sql, $stmt->{bind}, $stmt)
}

sub fetch {
    my $driver = shift;
    my($rec, $class, $orig_terms, $orig_args) = @_;

    my ($sql, $bind, $stmt) = $driver->prepare_fetch($class, $orig_terms, $orig_args);

    my @bind;
    my $map = $stmt->select_map;
    for my $col (@{ $stmt->select }) {
        push @bind, \$rec->{ $map->{$col} };
    }

    my $dbh = $driver->r_handle($class->properties->{db});
    $driver->start_query($sql, $stmt->{bind});

    my $sth = $orig_args->{no_cached_prepare} ? $dbh->prepare($sql) : $driver->_prepare_cached($dbh, $sql);
    $sth->execute(@{ $stmt->{bind} });
    $sth->bind_columns(undef, @bind);

    # need to slurp 'offset' rows for DBs that cannot do it themselves
    if (!$driver->dbd->offset_implemented && $orig_args->{offset}) {
        for (1..$orig_args->{offset}) {
            $sth->fetch;
        }
    }

    return $sth;
}

sub load_object_from_rec {
    my $driver = shift;
    my ($class, $rec, $no_triggers) = @_;

    my $obj = $class->new;
    $obj->set_values_internal($rec);
    ## Don't need a duplicate as there's no previous version in memory
    ## to preserve.
    $obj->{__is_stored} = 1;
    $obj->call_trigger('post_load') unless $no_triggers;
    return $obj;
}

sub search {
    my($driver) = shift;
    my($class, $terms, $args) = @_;

    my $rec = {};
    my $sth = $driver->fetch($rec, $class, $terms, $args);

    my $iter = sub {
        ## This is kind of a hack--we need $driver to stay in scope,
        ## so that the DESTROY method isn't called. So we include it
        ## in the scope of the closure.
        my $d = $driver;

        unless ($sth->fetch) {
            _close_sth($sth);
            $driver->end_query($sth);
            return;
        }
        return $driver->load_object_from_rec($class, $rec, $args->{no_triggers});
    };

    if (wantarray) {
        my @objs = ();

        while (my $obj = $iter->()) {
            push @objs, $obj;
        }
        return @objs;
    } else {
        my $iterator = Data::ObjectDriver::Iterator->new(
            $iter, sub { _close_sth($sth); $driver->end_query($sth) },
        );
        return $iterator;
    }
    return;
}

sub lookup {
    my $driver = shift;
    my($class, $id) = @_;
    return unless defined $id;
    my @obj = $driver->search($class,
        $class->primary_key_to_terms($id), { limit => 1 , is_pk => 1 });
    $obj[0];
}

sub lookup_multi {
    my $driver = shift;
    my($class, $ids) = @_;
    return [] unless @$ids;
    my @got;
    ## If it's a single-column PK, assume it's in one partition, and
    ## use an OR search. FIXME: can we instead check for partitioning?
    unless (ref($ids->[0])) {
        my $terms = $class->primary_key_to_terms([ $ids ]);
        my @sqlgot = $driver->search($class, $terms, { is_pk => 1 });
        my %hgot = map { $_->primary_key() => $_ } @sqlgot;
        @got = map { defined $_ ? $hgot{$_} : undef } @$ids;
    } else {
        for my $id (@$ids) {
            push @got, eval{ $class->driver->lookup($class, $id) };
        }
    }
    \@got;
}

sub select_one {
    my $driver = shift;
    my($sql, $bind) = @_;
    my $dbh = $driver->r_handle;

    $driver->start_query($sql, $bind);
    my $sth = $driver->_prepare_cached($dbh, $sql);
    $sth->execute(@$bind);
    $sth->bind_columns(undef, \my($val));
    unless ($sth->fetch) {
        _close_sth($sth);
        $driver->end_query($sth);
        return;
    }

    _close_sth($sth);
    $driver->end_query($sth);

    return $val;
}

sub table_for {
    my $driver = shift;
    my($this) = @_;
    my $src = $this->datasource or return;
    return $driver->prefix ? join('', $driver->prefix, $src) : $src;
}

sub exists {
    my $driver = shift;
    my($obj) = @_;
    return unless $obj->has_primary_key;

    ## should call pre_search trigger so we can use enum in the part of PKs
    my $terms = $obj->primary_key_to_terms;

    my $class = ref $obj;
    $terms ||= {};
    $class->call_trigger('pre_search', $terms);

    my $tbl = $driver->table_for($obj);
    my $stmt = $driver->prepare_statement($class, $terms, { limit => 1 });
    my $sql = "SELECT 1 FROM $tbl\n";
    $sql .= $stmt->as_sql_where;
    my $dbh = $driver->r_handle($obj->properties->{db});
    $driver->start_query($sql, $stmt->{bind});
    my $sth = $driver->_prepare_cached($dbh, $sql);
    $sth->execute(@{ $stmt->{bind} });
    my $exists = $sth->fetch;
    _close_sth($sth);
    $driver->end_query($sth);

    return $exists;
}

sub replace {
    my $driver = shift;
    if ($driver->dbd->can_replace) {
        return $driver->_insert_or_replace(@_, { replace => 1 });
    }
    if (! $driver->txn_active) {
        $driver->begin_work;
        eval {
            $driver->remove(@_);
            $driver->insert(@_);
        };
        if ($@) {
            $driver->rollback;
            Carp::croak("REPLACE transaction error $driver: $@");
        }
        $driver->commit;
        return;
    }
    $driver->remove(@_);
    $driver->insert(@_);
}

sub insert {
    my $driver = shift;
    my($orig_obj) = @_;
    $driver->_insert_or_replace($orig_obj, { replace => 0 });
}

sub _insert_or_replace {
    my $driver = shift;
    my($orig_obj, $options) = @_;

    ## Syntax switch between INSERT or REPLACE statement based on options
    $options ||= {};
    my $INSERT_OR_REPLACE = $options->{replace} ? 'REPLACE' : 'INSERT';

    ## Use a duplicate so the pre_save trigger can modify it.
    my $obj = $orig_obj->clone_all;
    $obj->call_trigger('pre_save', $orig_obj);
    $obj->call_trigger('pre_insert', $orig_obj);

    my $cols = $obj->column_names;
    if (!$obj->is_pkless && ! $obj->has_primary_key) {
        ## If we don't already have a primary key assigned for this object, we
        ## may need to generate one (depending on the underlying DB
        ## driver). If the driver gives us a new ID, we insert that into
        ## the new record; otherwise, we assume that the DB is using an
        ## auto-increment column of some sort, so we don't specify an ID
        ## at all.
        my $pk = $obj->primary_key_tuple;
        if(my $generated = $driver->generate_pk($obj)) {
            ## The ID is the only thing we *are* allowed to change on
            ## the original object, so copy it back.
            $orig_obj->$_($obj->$_) for @$pk;
        } else {
            ## Filter the undefined key fields out of the columns to include
            ## in the query, so that we don't specify them in the query.
            my %pk = map { $_ => 1 } @$pk;
            $cols = [ grep !$pk{$_} || defined $obj->$_(), @$cols ];
        }
    }
    my $tbl = $driver->table_for($obj);
    my $sql = "$INSERT_OR_REPLACE INTO $tbl\n";
    my $dbd = $driver->dbd;
    $sql .= '(' . join(', ',
                  map { $dbd->db_column_name($tbl, $_) }
                  @$cols) .
            ')' . "\n" .
            'VALUES (' . join(', ', ('?') x @$cols) . ')' . "\n";
    my $dbh = $driver->rw_handle($obj->properties->{db});
    $driver->start_query($sql, $obj->{column_values});
    my $sth = $driver->_prepare_cached($dbh, $sql);
    my $i = 1;
    my $col_defs = $obj->properties->{column_defs};
    for my $col (@$cols) {
        my $val = $obj->column($col);
        my $type = $col_defs->{$col} || 'char';
        my $attr = $dbd->bind_param_attributes($type, $obj, $col);
        $sth->bind_param($i++, $val, $attr);
    }
    eval { $sth->execute };
	die "Failed to execute $sql with ".join(", ",@$cols).": $@" if $@;
    _close_sth($sth);
    $driver->end_query($sth);

    ## Now, if we didn't have an object ID, we need to grab the
    ## newly-assigned ID.
    if (!$obj->is_pkless && ! $obj->has_primary_key) {
        my $pk = $obj->primary_key_tuple; ## but do that only for relation that aren't PK-less
        my $id_col = $pk->[0]; # XXX are we sure we will always use '0' ?
        my $id = $dbd->fetch_id(ref($obj), $dbh, $sth, $driver);
        $obj->$id_col($id);
        ## The ID is the only thing we *are* allowed to change on
        ## the original object.
        $orig_obj->$id_col($id);
    }

    $obj->call_trigger('post_save', $orig_obj);
    $obj->call_trigger('post_insert', $orig_obj);

    $orig_obj->{__is_stored} = 1;
    $orig_obj->{changed_cols} = {};
    1;
}

sub update {
    my $driver = shift;

    my($orig_obj, $terms) = @_;

    ## Use a duplicate so the pre_save trigger can modify it.
    my $obj = $orig_obj->clone_all;
    $obj->call_trigger('pre_save', $orig_obj);
    $obj->call_trigger('pre_update', $orig_obj);

    my $cols = $obj->column_names;
    my @changed_cols = $obj->changed_cols;

    ## If there's no updated columns, update() is no-op
    ## but we should call post_* triggers
    unless (@changed_cols) {
        $obj->call_trigger('post_save', $orig_obj);
        $obj->call_trigger('post_update', $orig_obj);
        return 1;
    }

    my $tbl = $driver->table_for($obj);
    my $sql = "UPDATE $tbl SET\n";
    my $dbd = $driver->dbd;
    $sql .= join(', ',
            map { $dbd->db_column_name($tbl, $_) . " = ?" }
            @changed_cols) . "\n";
    my $stmt = $driver->prepare_statement(ref($obj), {
            %{ $obj->primary_key_to_terms },
            %{ $terms || {} }
        });
    $sql .= $stmt->as_sql_where;

    my $dbh = $driver->rw_handle($obj->properties->{db});
    $driver->start_query($sql, $obj->{column_values});
    my $sth = $driver->_prepare_cached($dbh, $sql);
    my $i = 1;
    my $col_defs = $obj->properties->{column_defs};
    for my $col (@changed_cols) {
        my $val = $obj->column($col);
        my $type = $col_defs->{$col} || 'char';
        my $attr = $dbd->bind_param_attributes($type, $obj, $col);
        $sth->bind_param($i++, $val, $attr);
    }

    ## Bind the primary key value(s).
    for my $val (@{ $stmt->{bind} }) {
        $sth->bind_param($i++, $val);
    }

    my $rows = $sth->execute;
    _close_sth($sth);
    $driver->end_query($sth);

    $obj->call_trigger('post_save', $orig_obj);
    $obj->call_trigger('post_update', $orig_obj);

    $orig_obj->{changed_cols} = {};
    return $rows;
}

sub remove {
    my $driver = shift;
    my $orig_obj = shift;

    ## If remove() is called on class method and we have 'nofetch'
    ## option, we remove the record using $term and won't create
    ## $object. This is for efficiency and PK-less tables
    ## Note: In this case, triggers won't be fired
    ## Otherwise, Class->remove is a shortcut for search+remove
    unless (ref($orig_obj)) {
        if ($_[1] && $_[1]->{nofetch}) {
            return $driver->direct_remove($orig_obj, @_);
        } else {
            my $result = 0;
            my @obj = $driver->search($orig_obj, @_);
            for my $obj (@obj) {
                my $res = $obj->remove(@_) || 0;
                $result += $res;
            }
            return $result || 0E0;
        }
    }

    return unless $orig_obj->has_primary_key;

    ## Use a duplicate so the pre_save trigger can modify it.
    my $obj = $orig_obj->clone_all;
    $obj->call_trigger('pre_remove', $orig_obj);

    my $tbl = $driver->table_for($obj);
    my $sql = "DELETE FROM $tbl\n";
    my $stmt = $driver->prepare_statement(ref($obj), $obj->primary_key_to_terms);
    $sql .= $stmt->as_sql_where;
    my $dbh = $driver->rw_handle($obj->properties->{db});
    $driver->start_query($sql, $stmt->{bind});
    my $sth = $driver->_prepare_cached($dbh, $sql);
    my $result = $sth->execute(@{ $stmt->{bind} });
    _close_sth($sth);
    $driver->end_query($sth);

    $obj->call_trigger('post_remove', $orig_obj);

    $orig_obj->{__is_stored} = 1;
    return $result;
}

sub direct_remove {
    my $driver = shift;
    my($class, $orig_terms, $orig_args) = @_;

    ## Use (shallow) duplicates so the pre_search trigger can modify them.
    my $terms = defined $orig_terms ? { %$orig_terms } : {};
    my $args  = defined $orig_args  ? { %$orig_args  } : {};
    $class->call_trigger('pre_search', $terms, $args);

    my $stmt = $driver->prepare_statement($class, $terms, $args);
    my $tbl  = $driver->table_for($class);
    my $sql  = "DELETE from $tbl\n";
       $sql .= $stmt->as_sql_where;

    # not all DBD drivers can do this.  check.  better to die than do
    # unbounded DELETE when they requested a limit.
    if ($stmt->limit) {
        Carp::croak("Driver doesn't support DELETE with LIMIT")
            unless $driver->dbd->can_delete_with_limit;
        $sql .= $stmt->as_limit;
    }

    my $dbh = $driver->rw_handle($class->properties->{db});
    $driver->start_query($sql, $stmt->{bind});
    my $sth = $driver->_prepare_cached($dbh, $sql);
    my $result = $sth->execute(@{ $stmt->{bind} });
    _close_sth($sth);
    $driver->end_query($sth);
    return $result;
}

sub bulk_insert {
    my $driver = shift;
    my $class = shift;
    my $dbd = $driver->dbd;

    my $cols = shift;
    my $data = shift;


    Carp::croak("Driver doesn't support bulk_insert")
	    unless ($dbd->can('bulk_insert'));

    # check that cols are valid..
    my %valid_cols = map {$_ => 1} @{$class->column_names};

    my $invalid_cols;
    foreach my $c (@{$cols}) {
        $invalid_cols .= "$c " if (!$valid_cols{$c});
    }
    if (defined($invalid_cols)) {
        Carp::croak("Invalid columns $invalid_cols passed to bulk_insert");
    }


    # pass this directly to the backend DBD
    my $dbh = $driver->rw_handle($class->properties->{db});
    my $tbl  = $driver->table_for($class);
    my @db_cols =  map {$dbd->db_column_name($tbl, $_) } @{$cols};

    return $dbd->bulk_insert($dbh, $tbl, \@db_cols, $data);
}

sub begin_work {
    my $driver = shift;

    return if $driver->txn_active;

    my $dbh = $driver->dbh;

    unless ($dbh) {
        $driver->{__delete_dbh_after_txn} = 1;
        $dbh = $driver->rw_handle;
        $driver->dbh($dbh);
    }

    if ($dbh->{AutoCommit}) {
        eval {
            $dbh->begin_work;
        };
        if (my $err = $@) {
            $driver->rollback;
            Carp::croak("Begin work failed for driver $driver: $err");
        }
    }
    ## if for some reason AutoCommit was 0 but txn_active was false,
    ## then we set it to true now
    $driver->txn_active(1);
}

sub commit { shift->_end_txn('commit') }
sub rollback { shift->_end_txn('rollback') }

sub _end_txn {
    my $driver = shift;
    my($action) = @_;

    ## if the driver has its own internal txn_active flag
    ## off, we don't bother ending. Maybe we already did
    if ($driver->txn_active) {
        $driver->txn_active(0);

        my $dbh = $driver->dbh
            or Carp::croak("$action called without a stored handle--begin_work?");

        unless ($dbh->{AutoCommit}) {
            eval { $dbh->$action() };
            if ($@) {
                Carp::croak("$action failed for driver $driver: $@");
            }
        }
    }
    if ($driver->{__delete_dbh_after_txn}) {
        $driver->dbh(undef);
        delete $driver->{__delete_dbh_after_txn};
    }
    return 1;
}

sub DESTROY {
    my $driver = shift;
    ## Don't take the responsability of disconnecting this handler
    ## if we haven't created it ourself.
    return unless $driver->{__dbh_init_by_driver};
    if (my $dbh = $driver->dbh) {
        $dbh->disconnect if $dbh;
    }
}

sub prepare_statement {
    my $driver = shift;
    my($class, $terms, $args) = @_;

    my $dbd = $driver->dbd;
    my $stmt = $args->{sql_statement} || $dbd->sql_class->new;

    if (my $tbl = $driver->table_for($class)) {
        my $cols = $class->column_names;
        my %fetch = $args->{fetchonly} ?
            (map { $_ => 1 } @{ $args->{fetchonly} }) : ();
        my $skip = $stmt->select_map_reverse;
        for my $col (@$cols) {
            next if $skip->{$col};
            if (keys %fetch) {
                next unless $fetch{$col};
            }
            my $dbcol = join '.', $tbl, $dbd->db_column_name($tbl, $col);
            $stmt->add_select($dbcol => $col);
        }

        $stmt->from([ $tbl ]);

        if (defined($terms)) {
            if (ref $terms eq 'ARRAY') {
                # Used for translating property names deep within the
                # $terms structure to column names
                $stmt->column_mutator(sub {
                    my ($col) = @_;
                    return $dbd->db_column_name($tbl, $col);
                });
                $stmt->add_complex_where($terms);
                $stmt->column_mutator(undef);
            }
            else {
                for my $col (keys %$terms) {
                    my $db_col = $dbd->db_column_name($tbl, $col);
                    $stmt->add_where(join('.', $tbl, $db_col), $terms->{$col});
                }
            }
        }

        ## Set statement's ORDER clause if any.
        if ($args->{sort} || $args->{direction}) {
            my @order;
            my $sort = $args->{sort} || 'id';
            unless (ref $sort) {
                $sort = [{column    => $sort,
                          direction => $args->{direction}||''}];
            }

            foreach my $pair (@$sort) {
                my $col = $dbd->db_column_name($tbl, $pair->{column} || 'id');
                my $dir = $pair->{direction} || '';
                push @order, {column => $col,
                              desc   => ($dir eq 'descend') ? 'DESC' : 'ASC',
                             }
            }

            $stmt->order(\@order);
        }
    }
    $stmt->limit( $args->{limit} )     if $args->{limit};
    $stmt->offset( $args->{offset} )   if $args->{offset};
    $stmt->comment( $args->{comment} ) if $args->{comment};

    if (my $terms = $args->{having}) {
        for my $col (keys %$terms) {
            $stmt->add_having($col => $terms->{$col});
        }
    }

    $stmt;
}

sub last_error {
    my $driver = shift;
    return $driver->dbd->map_error_code($DBI::err, $DBI::errstr);
}

1;
