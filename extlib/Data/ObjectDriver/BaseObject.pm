# $Id$

package Data::ObjectDriver::BaseObject;
use strict;
use warnings;

our $HasWeaken;
eval q{ use Scalar::Util qw(weaken) }; ## no critic
$HasWeaken = !$@;

use Carp ();

use Class::Trigger qw( pre_save post_save post_load pre_search
                       pre_insert post_insert pre_update post_update
                       pre_remove post_remove post_inflate );

use Data::ObjectDriver::ResultSet;

## Global Transaction variables
our @WorkingDrivers;
our $TransactionLevel = 0;

sub install_properties {
    my $class = shift;
    my($props) = @_;
    my $columns = delete $props->{columns};
    $props->{columns} = [];
    {
        no strict 'refs'; ## no critic
        *{"${class}::__properties"} = sub { $props };
    }

    foreach my $col (@$columns) {
        $class->install_column($col);
    }
    return $props;
}

sub install_column {
    my($class, $col, $type) = @_;
    my $props = $class->properties;

    push @{ $props->{columns} }, $col;
    $props->{column_names}{$col} = ();
    # predefine getter/setter methods here
    # Skip adding this method if the class overloads it.
    # this lets the SUPER::columnname magic do it's thing
    if (! $class->can($col)) {
        no strict 'refs'; ## no critic
        *{"${class}::$col"} = $class->column_func($col);
    }
    if ($type) {
        $props->{column_defs}{$col} = $type;
    }
}

sub properties {
    my $this = shift;
    my $class = ref($this) || $this;
    $class->__properties;
}

# see docs below

sub has_a {
    my $class = shift;
    my @args = @_;

    # Iterate over each remote object
    foreach my $config (@args) {
        my $parentclass = $config->{class};

        # Parameters
        my $column = $config->{column};
        my $method = $config->{method};
        my $cached = $config->{cached} || 0;
        my $parent_method = $config->{parent_method};

        # column is required
        if (!defined($column)) {
            die "Please specify a valid column for $parentclass"
        }

        # create a method name based on the column
        if (! defined $method) {
            if (!ref($column)) {
                $method = $column;
                $method =~ s/_id$//;
                $method .= "_obj";
            } elsif (ref($column) eq 'ARRAY') {
                foreach my $col (@{$column}) {
                    my $part = $col;
                    $part =~ s/_id$//;
                    $method .= $part . '_';
                }
                $method .= "obj";
            }
        }

        # die if we have clashing methods method
        if (! defined $method || defined(*{"${class}::$method"})) {
            die "Please define a valid method for $class->$column";
        }

        if ($cached) {
            # Store cached item inside this object's namespace
            my $cachekey = "__cache_$method";

            no strict 'refs'; ## no critic
            *{"${class}::$method"} = sub {
                my $obj = shift;

                return $obj->{$cachekey}
                    if defined $obj->{$cachekey};

                my $id = (ref($column) eq 'ARRAY')
                    ? [ map { $obj->{column_values}->{$_} } @{$column}]
                    : $obj->{column_values}->{$column}
                    ;
                ## Hold in a variable here too, so we don't lose it immediately
                ## by having only the weak reference.
                my $ret = $parentclass->lookup($id);
                if ($HasWeaken) {
                    $obj->{$cachekey} = $ret;
                    weaken($obj->{$cachekey});
                }
                return $ret;
            };
        } else {
            if (ref($column)) {
                no strict 'refs'; ## no critic
                *{"${class}::$method"} = sub {
                    my $obj = shift;
                    return $parentclass->lookup([ map{ $obj->{column_values}->{$_} } @{$column}]);
                };
            } else {
                no strict 'refs'; ## no critic
                *{"${class}::$method"} = sub {
                    return $parentclass->lookup(shift()->{column_values}->{$column});
                };
            }
        }

        # now add to the parent
        if (!defined $parent_method) {
            $parent_method = lc($class);
            $parent_method =~ s/^.*:://;

            $parent_method .= '_objs';
        }
        if (ref($column)) {
            no strict 'refs'; ## no critic
            *{"${parentclass}::$parent_method"} = sub {
                my $obj = shift;
                my $terms = shift || {};
                my $args = shift;

                my $primary_key = $obj->primary_key;

                # inject pk search into given terms.
                # composite key, ugh
                foreach my $key (@$column) {
                    $terms->{$key} = shift(@{$primary_key});
                }

                return $class->search($terms, $args);
            };
        } else {
            no strict 'refs'; ## no critic
            *{"${parentclass}::$parent_method"} = sub {
                my $obj = shift;
                my $terms = shift || {};
                my $args = shift;
                # TBD - use primary_key_to_terms
                $terms->{$column} = $obj->primary_key;
                return $class->search($terms, $args);
            };
        };
    } # end of loop over class names
    return;
}

sub driver {
    my $class = shift;
    $class->properties->{driver} ||= $class->properties->{get_driver}->();
}

sub get_driver {
    my $class = shift;
    $class->properties->{get_driver} = shift if @_;
}

sub new {
    my $obj = bless {}, shift;

    return $obj->init(@_);
}

sub init {
    my $self = shift;

    while (@_) {
        my $field = shift;
        my $val   = shift;
        $self->$field($val);
    }
    return $self;
}

sub is_pkless {
    my $obj = shift;
    my $prop_pk = $obj->properties->{primary_key};
    return 1 if ! $prop_pk;
    return 1 if ref $prop_pk eq 'ARRAY' && ! @$prop_pk;
}

sub is_primary_key {
    my $obj = shift;
    my($col) = @_;

    my $prop_pk = $obj->properties->{primary_key};
    if (ref($prop_pk)) {
        for my $pk (@$prop_pk) {
            return 1 if $pk eq $col;
        }
    } else {
        return 1 if $prop_pk eq $col;
    }

    return;
}

sub primary_key_tuple {
    my $obj = shift;
    my $pk = $obj->properties->{primary_key} || return;
    $pk = [ $pk ] unless ref($pk) eq 'ARRAY';
    $pk;
}

sub primary_key {
    my $obj = shift;
    my $pk = $obj->primary_key_tuple;
    my @val = map { $obj->$_() }  @$pk;
    @val == 1 ? $val[0] : \@val;
}

sub is_same_array {
    my($a1, $a2) = @_;
    return if ($#$a1 != $#$a2);
    for (my $i = 0; $i <= $#$a1; $i++) {
        return if $a1->[$i] ne $a2->[$i];
    }
    return 1;
}

sub primary_key_to_terms {
    my($obj, $id) = @_;
    my $pk = $obj->primary_key_tuple;
    if (! defined $id) {
        $id = $obj->primary_key;
    } else {
        if (ref($id) eq 'HASH') {
            my @keys = sort keys %$id;
            unless (is_same_array(\@keys, [ sort @$pk ])) {
                Carp::confess("keys don't match with primary keys: @keys|@$pk");
            }
            return $id;
        }
    }
    $id = [ $id ] unless ref($id) eq 'ARRAY';
    my %terms;
    @terms{@$pk} = @$id;
    \%terms;
}

sub is_same {
    my($obj, $other) = @_;

    my @a;
    for my $o ($obj, $other) {
        push @a, [ map { $o->$_() } @{ $o->primary_key_tuple }];
    }
    return is_same_array( @a );
}

sub object_is_stored {
    my $obj = shift;
    return $obj->{__is_stored} ? 1 : 0;
}
sub pk_str {
    my ($obj) = @_;
    my $pk = $obj->primary_key;
    return $pk unless ref ($pk) eq 'ARRAY';
    return join (":", @$pk);
}

sub has_primary_key {
    my $obj = shift;
    return unless @{$obj->primary_key_tuple};
    my $val = $obj->primary_key;
    $val = [ $val ] unless ref($val) eq 'ARRAY';
    for my $v (@$val) {
        return unless defined $v;
    }
    1;
}

sub datasource { $_[0]->properties->{datasource} }

sub columns_of_type {
    my $obj = shift;
    my($type) = @_;
    my $props = $obj->properties;
    my $cols = $props->{columns};
    my $col_defs = $props->{column_defs};
    my @cols;
    for my $col (@$cols) {
        push @cols, $col if $col_defs->{$col} && $col_defs->{$col} eq $type;
    }
    \@cols;
}

sub set_values {
    my $obj = shift;
    my $values = shift;
    for my $col (keys %$values) {
        unless ( $obj->has_column($col) ) {
            Carp::croak("You tried to set non-existent column $col to value $values->{$col} on " . ref($obj));
        }
        $obj->$col($values->{$col});
    }
}

sub set_values_internal {
    my $obj = shift;
    my $values = shift;
    for my $col (keys %$values) {
        # Not needed for the internal version of this method
        #unless ( $obj->has_column($col) ) {
        #    Carp::croak("You tried to set inexistent column $col to value $values->{$col} on " . ref($obj));
        #}

        $obj->column_values->{$col} = $values->{$col};
    }
}

sub clone {
    my $obj = shift;
    my $clone = $obj->clone_all;
    for my $pk (@{ $obj->primary_key_tuple }) {
        $clone->$pk(undef);
    }
    $clone;
}

sub clone_all {
    my $obj = shift;
    my $clone = ref($obj)->new();
    $clone->set_values_internal($obj->column_values);
    $clone->{changed_cols} = defined $obj->{changed_cols} ? { %{$obj->{changed_cols}} } : undef;
    $clone;
}

sub has_column {
    return exists $_[0]->properties->{column_names}{$_[1]};
}

sub column_names {
    ## Reference to a copy.
    [ @{ shift->properties->{columns} } ]
}

sub column_values { $_[0]->{'column_values'} ||= {} }

## In 0.1 version we didn't die on inexistent column
## which might lead to silent bugs
## You should override column if you want to find the old
## behaviour
sub column {
    my $obj = shift;
    my $col = shift or return;
    unless ($obj->has_column($col)) {
        Carp::croak("Cannot find column '$col' for class '" . ref($obj) . "'");
    }

    # set some values
    if (@_) {
        $obj->{column_values}->{$col} = shift;
        unless ($_[0] && ref($_[0]) eq 'HASH' && $_[0]->{no_changed_flag}) {
            $obj->{changed_cols}->{$col}++;
        }
    }

    $obj->{column_values}->{$col};
}

sub column_func {
    my $obj = shift;
    my $col = shift or die "Must specify column";

    return sub {
        my $obj = shift;
        # getter
        return $obj->{column_values}->{$col} unless (@_);

        # setter
        my ($val, $flags) = @_;
        $obj->{column_values}->{$col} = $val;
        unless ($flags && ref($flags) eq 'HASH' && $flags->{no_changed_flag}) {
            $obj->{changed_cols}->{$col}++;
        }

        return $obj->{column_values}->{$col};
    };
}


sub changed_cols_and_pk {
    my $obj = shift;
    keys %{$obj->{changed_cols}};
}

sub changed_cols {
    my $obj = shift;
    my $pk = $obj->primary_key_tuple;
    my %pk = map { $_ => 1 } @$pk;
    grep !$pk{$_}, $obj->changed_cols_and_pk;
}

sub is_changed {
    my $obj = shift;
    if (@_) {
        return exists $obj->{changed_cols}->{$_[0]};
    } else {
        return $obj->changed_cols > 0;
    }
}

sub exists {
    my $obj = shift;
    return 0 unless $obj->has_primary_key;
    $obj->_proxy('exists', @_);
}

sub save {
    my $obj = shift;
    if ($obj->exists(@_)) {
        return $obj->update(@_);
    } else {
        return $obj->insert(@_);
    }
}

sub bulk_insert {
    my $class = shift;
    my $driver = $class->driver;

    return $driver->bulk_insert($class, @_);
}

sub lookup {
    my $class = shift;
    my $driver = $class->driver;
    my $obj = $driver->lookup($class, @_) or return;
    $driver->cache_object($obj);
    $obj;
}

sub lookup_multi {
    my $class = shift;
    my $driver = $class->driver;
    my $objs = $driver->lookup_multi($class, @_) or return;
    for my $obj (@$objs) {
        $driver->cache_object($obj) if $obj;
    }
    $objs;
}

sub result {
    my $class = shift;
    my ($terms, $args) = @_;

    return Data::ObjectDriver::ResultSet->new({
                          class     => (ref $class || $class),
                          page_size => delete $args->{page_size},
                          paging    => delete $args->{no_paging},
                          terms     => $terms,
                          args      => $args,
                          });
}

sub search {
    my $class = shift;
    my($terms, $args) = @_;
    my $driver = $class->driver;
    if (wantarray) {
        my @objs = $driver->search($class, $terms, $args);

        ## Don't attempt to cache objects where the caller specified fetchonly,
        ## because they won't be complete.
        ## Also skip this step if we don't get any objects back from the search
        if (!$args->{fetchonly} || !@objs) {
            for my $obj (@objs) {
                $driver->cache_object($obj) if $obj;
            }
        }
        return @objs;
    } else {
        my $iter = $driver->search($class, $terms, $args);
        return $iter if $args->{fetchonly};

        my $caching_iter = sub {
            my $d = $driver;

            my $o = $iter->();
            unless ($o) {
                $iter->end;
                return;
            }
            $driver->cache_object($o);
            return $o;
        };
        return Data::ObjectDriver::Iterator->new($caching_iter, sub { $iter->end });
    }
}

sub remove         { shift->_proxy( 'remove',         @_ ) }
sub update         { shift->_proxy( 'update',         @_ ) }
sub insert         { shift->_proxy( 'insert',         @_ ) }
sub replace        { shift->_proxy( 'replace',        @_ ) }
sub fetch_data     { shift->_proxy( 'fetch_data',     @_ ) }
sub uncache_object { shift->_proxy( 'uncache_object', @_ ) }

sub refresh {
    my $obj = shift;
    return unless $obj->has_primary_key;
    my $fields = $obj->fetch_data;
    $obj->set_values_internal($fields);
    $obj->call_trigger('post_load');
    $obj->driver->cache_object($obj);
    return 1;
}

## NOTE: I wonder if it could be useful to BaseObject superclass
## to override the global transaction flag. If so, I'd add methods
## to manipulate this flag and the working drivers. -- Yann
sub _proxy {
    my $obj = shift;
    my($meth, @args) = @_;
    my $driver = $obj->driver;
    ## faster than $obj->txn_active && ! $driver->txn_active but see note.
    if ($TransactionLevel && ! $driver->txn_active) {
        $driver->begin_work;
        push @WorkingDrivers, $driver;
    }
    $driver->$meth($obj, @args);
}

sub txn_active { $TransactionLevel }

sub begin_work {
    my $class = shift;
    if ( $TransactionLevel > 0 ) {
        Carp::carp(
            $TransactionLevel > 1
            ? "$TransactionLevel transactions already active"
            : "Transaction already active"
        );
    }
    $TransactionLevel++;
}

sub commit {
    my $class = shift;
    $class->_end_txn('commit');
}

sub rollback {
    my $class = shift;
    $class->_end_txn('rollback');
}

sub _end_txn {
    my $class = shift;
    my $meth  =  shift;
    
    ## Ignore nested transactions
    if ($TransactionLevel > 1) {
        $TransactionLevel--;
        return;
    }
    
    if (! $TransactionLevel) {
        Carp::carp("No active transaction to end; ignoring $meth");
        return;
    }
    my @wd = @WorkingDrivers;
    $TransactionLevel--;
    @WorkingDrivers = ();
    
    for my $driver (@wd) {
        $driver->$meth;
    }
}

sub txn_debug {
    my $class = shift;
    return {
        txn     => $TransactionLevel,
        drivers => \@WorkingDrivers,
    };
}

sub deflate { { columns => shift->column_values } }

sub inflate {
    my $class = shift;
    my($deflated) = @_;
    my $obj = $class->new;
    $obj->set_values_internal($deflated->{columns});
    $obj->call_trigger('post_inflate');
    return $obj;
}

sub DESTROY { }

sub AUTOLOAD {
    my $obj = $_[0];
    (my $col = our $AUTOLOAD) =~ s!.+::!!;
    Carp::croak("Cannot find method '$col' for class '$obj'") unless ref $obj;
    unless ($obj->has_column($col)) {
        Carp::croak("Cannot find column '$col' for class '" . ref($obj) . "'");
    }

    {
        no strict 'refs'; ## no critic
        *$AUTOLOAD = $obj->column_func($col);
    }

    goto &$AUTOLOAD;
}

sub has_partitions {
    my $class = shift;
    my(%param) = @_;
    my $how_many = delete $param{number}
        or Carp::croak("number (of partitions) is required");

    ## save the number of partitions in the class
    $class->properties->{number_of_partitions} = $how_many;

    ## Save the get_driver subref that we were passed, so that the
    ## SimplePartition driver can access it.
    $class->properties->{partition_get_driver} = delete $param{get_driver}
        or Carp::croak("get_driver is required");

    ## When creating a new $class object, we should automatically fill in
    ## the partition ID by selecting one at random, unless a partition_id
    ## is already defined. This allows us to keep it simple but for the
    ## caller to do something more complex, if it wants to.
    $class->add_trigger(pre_insert => sub {
        my($obj, $orig_obj) = @_;
        unless (defined $obj->partition_id) {
            my $partition_id = int(rand $how_many) + 1;
            $obj->partition_id($partition_id);
            $orig_obj->partition_id($partition_id);
        }
    });
}

1;

__END__

=head1 NAME

Data::ObjectDriver::BaseObject - base class for modeled objects

=head1 SYNOPSIS

    package Ingredient;
    use base qw( Data::ObjectDriver::BaseObject );

    __PACKAGE__->install_properties({
        columns     => [ 'ingredient_id', 'recipe_id', 'name', 'quantity' ],
        datasource  => 'ingredient',
        primary_key => [ 'recipe_id', 'ingredient_id' ],
        driver      => FoodDriver->driver,
    });

    __PACKAGE__->has_a(
        { class => 'Recipe', column => 'recipe_id', }
    );

    package main;

    my ($ingredient) = Ingredient->search({ recipe_id => 4, name => 'rutabaga' });
    $ingredient->quantity(7);
    $ingredient->save();


=head1 DESCRIPTION

I<Data::ObjectDriver::BaseObject> provides services to data objects modeled
with the I<Data::ObjectDriver> object relational mapper.

=head1 CLASS DEFINITION

=head2 C<Class-E<gt>install_properties(\%params)>

Defines all the properties of the specified object class. Generally you should
call C<install_properties()> in the body of your class definition, so the
properties can be set when the class is C<use>d or C<require>d.

Required members of C<%params> are:

=over 4

=item * C<columns>

All the columns in the object class. This property is an arrayref.

=item * C<datasource>

The identifier of the table in which the object class's data are stored.
Usually the datasource is simply the table name, but the datasource can be
decorated into the table name by the C<Data::ObjectDriver::DBD> module if the
database requires special formatting of table names.

=item * C<driver> or C<get_driver>

The driver used to perform database operations (lookup, update, etc) for the
object class.

C<driver> is the instance of C<Data::ObjectDriver> to use. If your driver
requires configuration options not available when the properties are initially
set, specify a coderef as C<get_driver> instead. It will be called the first
time the driver is needed, storing the driver in the class's C<driver> property
for subsequent calls.

=back

The optional members of C<%params> are:

=over 4

=item * C<primary_key>

The column or columns used to uniquely identify an instance of the object
class. If one column (such as a simple numeric ID) identifies the class,
C<primary_key> should be a scalar. Otherwise, C<primary_key> is an arrayref.

=item * C<column_defs>

Specifies types for specially typed columns, if any, as a hashref. For example,
if a column holds a timestamp, name it in C<column_defs> as a C<date> for
proper handling with some C<Data::ObjectDriver::Driver::DBD> database drivers.
Columns for which types aren't specified are handled as C<char> columns.

Known C<column_defs> types are:

=over 4

=item * C<blob>

A blob of binary data. C<Data::ObjectDriver::Driver::DBD::Pg> maps this to
C<DBI::Pg::PG_BYTEA>, C<DBD::SQLite> to C<DBI::SQL_BLOB> and C<DBD::Oracle>
to C<ORA_BLOB>.

=item * C<bin_char>

A non-blob string of binary data. C<Data::ObjectDriver::Driver::DBD::SQLite>
maps this to C<DBI::SQL_BINARY>.

=back

Other types may be defined by custom database drivers as needed, so consult
their documentation.

=item * C<db>

The name of the database. When used with C<Data::ObjectDriver::Driver::DBI>
type object drivers, this name is passed to the C<init_db> method when the
actual database handle is being created.

=back

Custom object drivers may define other properties for your object classes.
Consult the documentation of those object drivers for more information.

=head2 C<Class-E<gt>install_column($col, $def)>

Modify the Class definition to declare a new column C<$col> of definition <$def>
(see L<column_defs>).

=head2 C<Class-E<gt>has_a(@definitions)>

B<NOTE:> C<has_a> is an experimental system, likely to both be buggy and change
in future versions.

Defines a foreign key reference between two classes, creating accessor methods
to retrieve objects both ways across the reference. For each defined reference,
two methods are created: one for objects of class C<Class> to load the objects
they reference, and one for objects of the referenced class to load the set of
C<Class> objects that reference I<them>.

For example, this definition:

    package Ingredient;
    __PACKAGE__->has_a(
        { class => 'Recipe', column => 'recipe_id' },
    );

would create C<Ingredient-E<gt>recipe_obj> and C<Recipe-E<gt>ingredient_objs>
instance methods.

Each member of C<@definitions> is a hashref containing the parameters for
creating one accessor method. The required members of these hashes are:

=over 4

=item * C<class>

The class to associate.

=item * C<column>

The column or columns in this class that identify the primary key of the
associated object. As with primary keys, use a single scalar string for a
single column or an arrayref for a composite key.

=back

The optional members of C<has_a()> definitions are:

=over 4

=item * C<method>

The name of the accessor method to create.

By default, the method name is the concatenated set of column names with each
C<_id> suffix removed, and the suffix C<_obj> appended at the end of the method
name. For example, if C<column> were C<['recipe_id', 'ingredient_id']>, the
resulting method would be called C<recipe_ingredient_obj> by default.

=item * C<cached>

Whether to keep a reference to the foreign object once it's loaded. Subsequent
calls to the accessor method would return that reference immediately.

=item * C<parent_method>

The name of the reciprocal method created in the referenced class named in
C<class>.

By default, that method is named with the lowercased name of the current class
with the suffix C<_objs>. For example, if in your C<Ingredient> class you
defined a relationship with C<Recipe> on the column C<recipe_id>, this would
create a C<$recipe-E<gt>ingredient_objs> method.

Note that if you reference one class with multiple sets of fields, you can omit
only one parent_method; otherwise the methods would be named the same thing.
For instance, if you had a C<Friend> class with two references to C<User>
objects in its C<user_id> and C<friend_id> columns, one of them would need a
C<parent_method>.

=back

=head2 C<Class-E<gt>has_partitions(%param)>

Defines that the given class is partitioned, configuring it for use with the
C<Data::ObjectDriver::Driver::SimplePartition> object driver. Required members
of C<%param> are:

=over 4

=item * C<number>

The number of partitions in which objects of this class may be stored.

=item * C<get_driver>

A function that returns an object driver, given a partition ID and any extra
parameters specified when the class's
C<Data::ObjectDriver::Driver::SimplePartition> was instantiated.

=back

Note that only the parent object for use with the C<SimplePartition> driver
should use C<has_partitions()>. See
C<Data::ObjectDriver::Driver::SimplePartition> for more about partitioning.

=head1 BASIC USAGE

=head2 C<Class-E<gt>lookup($id)>

Returns the instance of C<Class> with the given value for its primary key. If
C<Class> has a complex primary key (more than one column), C<$id> should be an
arrayref specifying the column values in the same order as specified in the
C<primary_key> property.

=head2 C<Class-E<gt>search(\%terms, [\%args])>

Returns all instances of C<Class> that match the values specified in
C<\%terms>, keyed on column names. In list context, C<search> returns the
objects containing those values. In scalar context, C<search> returns an
iterator function containing the same set of objects.

Your search can be customized with parameters specified in C<\%args>. Commonly
recognized parameters (those implemented by the standard C<Data::ObjectDriver>
object drivers) are:

=over 4

=item * C<sort>

A column by which to order the object results.

=item * C<direction>

If set to C<descend>, the results (ordered by the C<sort> column) are returned
in descending order. Otherwise, results will be in ascending order.

=item * C<limit>

The number of results to return, at most. You can use this with C<offset> to
paginate your C<search()> results.

=item * C<offset>

The number of results to skip before the first returned result. Use this with
C<limit> to paginate your C<search()> results.

=item * C<fetchonly>

A list (arrayref) of columns that should be requested. If specified, only the
specified columns of the resulting objects are guaranteed to be set to the
correct values.

Note that any caching object drivers you use may opt to ignore C<fetchonly>
instructions, or decline to cache objects queried with C<fetchonly>.

=item * C<for_update>

If true, instructs the object driver to indicate the query is a search, but the
application may want to update the data after. That is, the generated SQL
C<SELECT> query will include a C<FOR UPDATE> clause.

=back

All options are passed to the object driver, so your driver may support
additional options.

=head2 C<Class-E<gt>result(\%terms, [\%args])>

Takes the same I<%terms> and I<%args> arguments that I<search> takes, but
instead of executing the query immediately, returns a
I<Data::ObjectDriver::ResultSet> object representing the set of results.

=head2 C<$obj-E<gt>exists()>

Returns true if C<$obj> already exists in the database.

=head2 C<$obj-E<gt>save()>

Saves C<$obj> to the database, whether it is already there or not. That is,
C<save()> is functionally:

    $obj->exists() ? $obj->update() : $obj->insert()

=head2 C<$obj-E<gt>update()>

Saves changes to C<$obj>, an object that already exists in its database.

=head2 C<$obj-E<gt>insert()>

Adds C<$obj> to the database in which it should exist, according to its object
driver and configuration.

=head2 C<$obj-E<gt>remove()>

Deletes C<$obj> from its database.

=head2 C<$obj-E<gt>replace()>

Replaces C<$obj> in the database. Does the right thing if the driver
knows how to REPLACE object, ala MySQL.

=head1 USAGE

=head2 C<Class-E<gt>new(%columns)>

Returns a new object of the given class, initializing its columns with the values
in C<%columns>.

=head2 C<$obj-E<gt>init(%columns)>

Initializes C<$obj>i by initializing its columns with the values in
C<%columns>.

Override this method if you must do initial configuration to new instances of
C<$obj>'s class that are not more appropriate as a C<post_load> callback.

=head2 C<Class-E<gt>properties()>

Returns the named object class's properties as a hashref. Note that some of the
standard object class properties, such as C<primary_key>, have more convenient
accessors than reading the properties directly.

=head2 C<Class-E<gt>driver()>

Returns the object driver for this class, invoking the class's I<get_driver>
function (and caching the result for future calls) if necessary.

=head2 C<Class-E<gt>get_driver($get_driver_fn)>

Sets the function used to find the object driver for I<Class> objects (that is,
the C<get_driver> property).

Note that once C<driver()> has been called, the C<get_driver> function is not
used. Usually you would specify your function as the C<get_driver> parameter to
C<install_properties()>.

=head2 C<Class-E<gt>is_pkless()>

Returns whether the given object class has a primary key defined.

=head2 C<Class-E<gt>is_primary_key($column)>

Returns whether the given column is or is part of the primary key for C<Class>
objects.

=head2 C<$obj-E<gt>primary_key()>

Returns the I<values> of the primary key fields of C<$obj>.

=head2 C<Class-E<gt>primary_key_tuple()>

Returns the I<names> of the primary key fields of C<Class> objects.

=head2 C<$obj-E<gt>is_same($other_obj)>

Do a primary key check on C<$obj> and $<other_obj> and returns true only if they
are identical.

=head2 C<$obj-E<gt>object_is_stored()>

Returns true if the object hasn't been stored in the database yet.
This is particularly useful in triggers where you can then determine
if the object is being INSERTED or just UPDATED.

=head2 C<$obj-E<gt>pk_str()>

returns the primary key has a printable string.

=head2 C<$obj-E<gt>has_primary_key()>

Returns whether the given object has values for all of its primary key fields.

=head2 C<$obj-E<gt>uncache_object()>

If you use a Cache driver, returned object will be automatically cached as a result
of common retrieve operations. In some rare cases you may want the cache to be cleared
explicitly, and this method provides you with a way to do it.

=head2 C<$obj-E<gt>primary_key_to_terms([$id])>

Returns C<$obj>'s primary key as a hashref of values keyed on column names,
suitable for passing as C<search()> terms. If C<$id> is specified, convert that
primary key instead of C<$obj>'s.

=head2 C<Class-E<gt>datasource()>

Returns the datasource for objects of class C<Class>. That is, returns the
C<datasource> property of C<Class>.

=head2 C<Class-E<gt>columns_of_type($type)>

Returns the list of columns in C<Class> objects that hold data of type
C<$type>, as an arrayref. Columns are of a certain type when they are set that
way in C<Class>'s C<column_defs> property.

=head2 C<$obj-E<gt>set_values(\%values)>

Sets all the columns of C<$obj> that are members of C<\%values> to the values
specified there.

=head2 C<$obj-E<gt>set_values_internal(\%values)>

Sets new specified values of C<$obj>, without using any overridden mutator
methods of C<$obj> and without marking the changed columns changed.

=head2 C<$obj-E<gt>clone()>

Returns a new object of the same class as I<$obj> containing the same data,
except for primary keys, which are set to C<undef>.

=head2 C<$obj-E<gt>clone_all()>

Returns a new object of the same class as I<$obj> containing the same data,
including all key fields.

=head2 C<Class-E<gt>has_column($column)>

Returns whether a column named C<$column> exists in objects of class <Class>.

=head2 C<Class-E<gt>column_names()>

Returns the list of columns in C<Class> objects as an arrayref.

=head2 C<$obj-E<gt>column_values()>

Returns the columns and values in the given object as a hashref.

=head2 C<$obj-E<gt>column($column, [$value])>

Returns the value of C<$obj>'s column C<$column>. If C<$value> is specified,
C<column()> sets the first.

Note the usual way of accessing and mutating column values is through the named
accessors:

    $obj->column('fred', 'barney');  # possible
    $obj->fred('barney');            # preferred

=head2 C<$obj-E<gt>is_changed([$column])>

Returns whether any values in C<$obj> have changed. If C<$column> is given,
returns specifically whether that column has changed.

=head2 C<$obj-E<gt>changed_cols_and_pk()>

Returns the list of all columns that have changed in C<$obj> since it was last
loaded from or saved to the database, as a list.

=head2 C<$obj-E<gt>changed_cols()>

Returns the list of changed columns in C<$obj> as a list, except for any
columns in C<$obj>'s primary key (even if they have changed).

=head2 C<Class-E<gt>lookup_multi(\@ids)>

Returns a list (arrayref) of objects as specified by their primary keys.

=head2 C<Class-E<gt>bulk_insert(\@columns, \@data)>

Adds the given data, an arrayref of arrayrefs containing column values in the
order of column names given in C<\@columns>, as directly to the database as
C<Class> records.

Note that only some database drivers (for example,
C<Data::ObjectDriver::Driver::DBD::Pg>) implement the bulk insert operation.

=head2 C<$obj-E<gt>fetch_data()>

Returns the current values from C<$obj> as saved in the database, as a hashref.

=head2 C<$obj-E<gt>refresh()>

Resets the values of C<$obj> from the database. Any unsaved modifications to
C<$obj> will be lost, and any made meanwhile will be reflected in C<$obj>
afterward.

=head2 C<$obj-E<gt>column_func($column)>

Creates an accessor/mutator method for column C<$column>, returning it as a
coderef.

Override this if you need special behavior in all accessor/mutator methods.

=head2 C<$obj-E<gt>deflate()>

Returns a minimal representation of the object, for use in caches where
you might want to preserve space (like memcached). Can also be overridden
by subclasses to store the optimal representation of an object in the
cache. For example, if you have metadata attached to an object, you might
want to store that in the cache, as well.

=head2 C<Class-E<gt>inflate($deflated)>

Inflates the deflated representation of the object I<$deflated> into a proper
object in the class I<Class>. That is, undoes the operation C<$deflated =
$obj-E<gt>deflate()> by returning a new object equivalent to C<$obj>.

=head1 TRANSACTION SUPPORT AND METHODS

=head2 Introduction

When dealing with the methods on this class, the transactions are global,
i.e: applied to all drivers. You can still enable transactions per driver
if you directly use the driver API.

=head2 C<Class-E<gt>begin_work>

This enable transactions globally for all drivers until the next L<rollback>
or L<commit> call on the class.

If begin_work is called while a transaction is still active (nested transaction)
then the two transactions are merged. So inner transactions are ignored and
a warning will be emitted.

=head2 C<Class-E<gt>rollback>

This rollbacks all the transactions since the last begin work, and exits
from the active transaction state.

=head2 C<Class-E<gt>commit>

Commits the transactions, and exits from the active transaction state.

=head2 C<Class-E<gt>txn_debug>

Just return the value of the global flag and the current working drivers
in a hashref.

=head2 C<Class-E<gt>txn_active>

Returns true if a transaction is already active.

=head1 DIAGNOSTICS

=over 4

=item * C<Please specify a valid column for I<class>>

One of the class relationships you defined with C<has_a()> was missing a
C<column> member.

=item * C<Please define a valid method for I<column>>

One of the class relationships you defined with C<has_a()> was missing its
C<method> member and a method name could not be generated, or the class for
which you specified the relationship already has a method by that name. Perhaps
you specified an additional accessor by the same name for that class.

=item * C<keys don't match with primary keys: I<list>>

The hashref of values you passed as the ID to C<primary_key_to_terms()> was
missing or had extra members. Perhaps you used a full C<column_values()> hash
instead of only including that class's key fields.

=item * C<You tried to set inexistent column I<column name> to value I<data> on I<class name>>

The hashref you specified to C<set_values()> contained keys that are not
defined columns for that class of object. Perhaps you invoked it on the wrong
class, or did not fully filter members of the hash out before using it.

=item * C<Cannot find column 'I<column>' for class 'I<class>'>

The column you specified to C<column()> does not exist for that class, you
attempted to use an automatically generated accessor/mutator for a column that
doesn't exist, or attempted to use a column accessor as a class method instead
of an instance method. Perhaps you performed your call on the wrong class or
variable, or misspelled a method or column name.

=item * C<Must specify column>

You invoked the C<column_func()> method without specifying a column name.
Column names are required to create the accessor/mutator function, so it knows
what data member of the object to use.

=item * C<number (of partitions) is required>

You attempted to define partitioning for a class without specifying the number
of partitions for that class in the C<number> member. Perhaps your logic for
determining the number of partitions resulted in C<undef> or 0.

=item * C<get_driver is required>

You attempted to define partitioning for a class without specifying the
function to find the object driver for a partition ID as the C<get_driver>
member.

=back

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

=head1 SEE ALSO

L<Data::ObjectDriver>, L<Data::ObjectDriver::Driver::DBI>,
L<Data::ObjectDriver::Driver::SimplePartition>

=head1 LICENSE

I<Data::ObjectDriver> is free software; you may redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR & COPYRIGHT

Except where otherwise noted, I<Data::ObjectDriver> is Copyright 2005-2006
Six Apart, cpan@sixapart.com. All rights reserved.

=cut

