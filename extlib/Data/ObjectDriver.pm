# $Id: ObjectDriver.pm 560 2009-01-28 18:37:28Z btrott $

package Data::ObjectDriver;
use strict;
use warnings;
use Class::Accessor::Fast;

use base qw( Class::Accessor::Fast );
use Data::ObjectDriver::Iterator;

__PACKAGE__->mk_accessors(qw( pk_generator txn_active ));

our $VERSION = '0.06';
our $DEBUG = $ENV{DOD_DEBUG} || 0;
our $PROFILE = $ENV{DOD_PROFILE} || 0;
our $PROFILER;
our $LOGGER;

sub new {
    my $class = shift;
    my $driver = bless {}, $class;
    $driver->init(@_);
    $driver;
}

sub logger {
    my $class = shift;
    if ( @_ ) {
        return $LOGGER = shift;
    } else {
        return $LOGGER ||= sub {
            print STDERR @_;
        };
    }
}

sub init {
    my $driver = shift;
    my %param = @_;
    $driver->pk_generator($param{pk_generator});
    $driver->txn_active(0);
    $driver;
}

# Alias record_query to start_query
*record_query = \*start_query;

sub start_query {
    my $driver = shift;
    my($sql, $bind) = @_;

    $driver->debug($sql, $bind) if $DEBUG;
    $driver->profiler($sql) if $PROFILE;

    return;
}

sub end_query { }

sub begin_work {
    my $driver = shift;
    $driver->txn_active(1);
    $driver->debug(sprintf("%14s", "BEGIN_WORK") . ": driver=$driver");
}

sub commit {
    my $driver = shift;
    _end_txn($driver, 'commit');
}

sub rollback {
    my $driver = shift;
    _end_txn($driver, 'rollback');
}

sub _end_txn {
    my $driver = shift;
    my $method = shift;
    $driver->txn_active(0);
    $driver->debug(sprintf("%14s", uc($method)) . ": driver=$driver");
}

sub debug {
    my $driver = shift;
    return unless $DEBUG;

    my $class = ref $driver || $driver;
    my @caller;
    my $i = 0;
    while (1) {
        @caller = caller($i++);
        last if $caller[0] !~ /^(Data::ObjectDriver|$class)/;
    }

    my $where = " in file $caller[1] line $caller[2]\n";

    if (@_ == 1 && !ref($_[0])) {
        $driver->logger->( @_, $where );
    } else {
        require Data::Dumper;
        local $Data::Dumper::Indent = 1;
        $driver->logger->( Data::Dumper::Dumper(@_), $where );
    }
}

sub profiler {
    my $driver = shift;
    my ($sql) = @_;
    $PROFILER ||= eval {
        require Data::ObjectDriver::Profiler;
        Data::ObjectDriver::Profiler->new;
    };
    return $PROFILE = 0 if $@ || !$PROFILER;
    return $PROFILER unless @_;
    $PROFILER->record_query($driver, $sql);
}

sub list_or_iterator {
    my $driver = shift;
    my($objs) = @_;

    ## Emulate the standard search behavior of returning an
    ## iterator in scalar context, and the full list in list context.
    if (wantarray) {
        return @{$objs};
    } else {
        my $iter = sub { shift @{$objs} };
        return Data::ObjectDriver::Iterator->new($iter);
    }
}

sub cache_object { }
sub uncache_object { }

1;
__END__

=head1 NAME

Data::ObjectDriver - Simple, transparent data interface, with caching

=head1 SYNOPSIS

    ## Set up your database driver code.
    package FoodDriver;
    sub driver {
        Data::ObjectDriver::Driver::DBI->new(
            dsn      => 'dbi:mysql:dbname',
            username => 'username',
            password => 'password',
        )
    }

    ## Set up the classes for your recipe and ingredient objects.
    package Recipe;
    use base qw( Data::ObjectDriver::BaseObject );
    __PACKAGE__->install_properties({
        columns     => [ 'recipe_id', 'title' ],
        datasource  => 'recipe',
        primary_key => 'recipe_id',
        driver      => FoodDriver->driver,
    });

    package Ingredient;
    use base qw( Data::ObjectDriver::BaseObject );
    __PACKAGE__->install_properties({
        columns     => [ 'ingredient_id', 'recipe_id', 'name', 'quantity' ],
        datasource  => 'ingredient',
        primary_key => [ 'recipe_id', 'ingredient_id' ],
        driver      => FoodDriver->driver,
    });

    ## And now, use them!
    my $recipe = Recipe->new;
    $recipe->title('Banana Milkshake');
    $recipe->save;

    my $ingredient = Ingredient->new;
    $ingredient->recipe_id($recipe->id);
    $ingredient->name('Bananas');
    $ingredient->quantity(5);
    $ingredient->save;

    ## Needs more bananas!
    $ingredient->quantity(10);
    $ingredient->save;

    ## Shorthand constructor
    my $ingredient = Ingredient->new(recipe_id=> $recipe->id,
                                     name => 'Milk',
                                     quantity => 2);

=head1 DESCRIPTION

I<Data::ObjectDriver> is an object relational mapper, meaning that it maps
object-oriented design concepts onto a relational database.

It's inspired by, and descended from, the I<MT::ObjectDriver> classes in
Six Apart's Movable Type and TypePad weblogging products. But it adds in
caching and partitioning layers, allowing you to spread data across multiple
physical databases, without your application code needing to know where the
data is stored.

It's currently considered ALPHA code. The API is largely fixed, but may seen
some small changes in the future. For what it's worth, the likeliest area
for changes are in the syntax for the I<search> method, and would most
likely not break much in the way of backwards compatibility.

=head1 METHODOLOGY

I<Data::ObjectDriver> provides you with a framework for building
database-backed applications. It provides built-in support for object
caching and database partitioning, and uses a layered approach to allow
building very sophisticated database interfaces without a lot of code.

You can build a driver that uses any number of caching layers, plus a
partitioning layer, then a final layer that actually knows how to load
data from a backend datastore.

For example, the following code:

    my $driver = Data::ObjectDriver::Driver::Cache::Memcached->new(
            cache    => Cache::Memcached->new(
                            servers => [ '127.0.0.1:11211' ],
                        ),
            fallback => Data::ObjectDriver::Driver::Partition->new(
                            get_driver => \&get_driver,
                        ),
    );

creates a new driver that supports both caching (using memcached) and
partitioning.

It's useful to demonstrate the flow of a sample request through this
driver framework. The following code:

    my $ingredient = Ingredient->lookup([ $recipe->recipe_id, 1 ]);

would take the following path through the I<Data::ObjectDriver> framework:

=over 4

=item 1.

The caching layer would look up the object with the given primary key in all
of the specified memcached servers.

If the object was found in the cache, it would be returned immediately.

If the object was not found in the cache, the caching layer would fall back
to the driver listed in the I<fallback> setting: the partitioning layer.

=item 2.

The partitioning layer does not know how to look up objects by itself--all
it knows how to do is to give back a driver that I<does> know how to look
up objects in a backend datastore.

In our example above, imagine that we're partitioning our ingredient data
based on the recipe that the ingredient is found in. For example, all of
the ingredients for a "Banana Milkshake" would be found in one partition;
all of the ingredients for a "Chocolate Sundae" might be found in another
partition.

So the partitioning layer needs to tell us which partition to look in to
load the ingredients for I<$recipe-E<gt>recipe_id>. If we store a
I<partition_id> column along with each I<$recipe> object, that information
can be loaded very easily, and the partitioning layer will then
instantiate a I<DBI> driver that knows how to load an ingredient from
that recipe.

=item 3.

Using the I<DBI> driver that the partitioning layer created,
I<Data::ObjectDriver> can look up the ingredient with the specified primary
key. It will return that key back up the chain, giving each layer a chance
to do something with it.

=item 4.

The caching layer, when it receives the object loaded in Step 3, will
store the object in memcached.

=item 5.

The object will be passed back to the caller. Subsequent lookups of that
same object will come from the cache.

=back

=head1 HOW IS IT DIFFERENT?

I<Data::ObjectDriver> differs from other similar frameworks
(e.g. L<Class::DBI>) in a couple of ways:

=over 4

=item * It has built-in support for caching.

=item * It has built-in support for data partitioning.

=item * Drivers are attached to classes, not to the application as a whole.

This is essential for partitioning, because your partition drivers need
to know how to load a specific class of data.

But it can also be useful for caching, because you may find that it doesn't
make sense to cache certain classes of data that change constantly.

=item * The driver class != the base object class.

All of the object classes you declare will descend from
I<Data::ObjectDriver::BaseObject>, and all of the drivers you instantiate
or subclass will descend from I<Data::ObjectDriver> itself.

This provides a useful distinction between your data/classes, and the
drivers that describe how to B<act> on that data, meaning that an
object based on I<Data::ObjectDriver::BaseObject> is not tied to any
particular type of driver.

=back

=head1 USAGE

=head2 Class->lookup($id)

Looks up/retrieves a single object with the primary key I<$id>, and returns
the object.

I<$id> can be either a scalar or a reference to an array, in the case of
a class with a multiple column primary key.

=head2 Class->lookup_multi(\@ids)

Looks up/retrieves multiple objects with the IDs I<\@ids>, which should be
a reference to an array of IDs. As in the case of I<lookup>, an ID can
be either a scalar or a reference to an array.

Returns a reference to an array of objects B<in the same order> as the IDs
you passed in. Any objects that could not successfully be loaded will be
represented in that array as an C<undef> element.

So, for example, if you wanted to load 2 objects with the primary keys
C<[ 5, 3 ]> and C<[ 4, 2 ]>, you'd call I<lookup_multi> like this:

    Class->lookup_multi([
        [ 5, 3 ],
        [ 4, 2 ],
    ]);

And if the first object in that list could not be loaded successfully,
you'd get back a reference to an array like this:

    [
        undef,
        $object
    ]

where I<$object> is an instance of I<Class>.

=head2 Class->search(\%terms [, \%options ])

Searches for objects matching the terms I<%terms>. In list context, returns
an array of matching objects; in scalar context, returns a reference to
a subroutine that acts as an iterator object, like so:

    my $iter = Ingredient->search({ recipe_id => 5 });
    while (my $ingredient = $iter->()) {
        ...
    }

C<$iter> is blessed in L<Data::ObjectDriver::Iterator> package, so the above
could also be written:

    my $iter = Ingredient->search({ recipe_id => 5 });
    while (my $ingredient = $iter->next()) {
        ...
    }

The keys in I<%terms> should be column names for the database table
modeled by I<Class> (and the values should be the desired values for those
columns).

I<%options> can contain:

=over 4

=item * sort

The name of a column to use to sort the result set.

Optional.

=item * direction

The direction in which you want to sort the result set. Must be either
C<ascend> or C<descend>.

Optional.

=item * limit

The value for a I<LIMIT> clause, to limit the size of the result set.

Optional.

=item * offset

The offset to start at when limiting the result set.

Optional.

=item * fetchonly

A reference to an array of column names to fetch in the I<SELECT> statement.

Optional; the default is to fetch the values of all of the columns.

=item * for_update

If set to a true value, the I<SELECT> statement generated will include a
I<FOR UPDATE> clause.

=item * comment

A sql comment to watermark the SQL query.

=item * window_size

Used when requesting an iterator for the search method and selecting
a large result set or a result set of unknown size. In such a case,
no LIMIT clause is assigned, which can load all available objects into
memory. Specifying C<window_size> will load objects in manageable chunks.
This will also cause any caching driver to be bypassed for issuing
the search itself. Objects are still placed into the cache upon load.

This attribute is ignored when the search method is invoked in an array
context, or if a C<limit> attribute is also specified that is smaller than
the C<window_size>.

=back

=head2 Class->search(\@terms [, \%options ])

This is an alternative calling signature for the search method documented
above. When providing an array of terms, it allows for constructing complex
expressions that mix 'and' and 'or' clauses. For example:

    my $iter = Ingredient->search([ { recipe_id => 5 },
        -or => { calories => { value => 300, op => '<' } } ]);
    while (my $ingredient = $iter->()) {
        ...
    }

Supported logic operators are: '-and', '-or', '-and_not', '-or_not'.

=head2 Class->add_trigger($trigger, \&callback)

Adds a trigger to all objects of class I<Class>, such that when the event
I<$trigger> occurs to any of the objects, subroutine C<&callback> is run. Note
that triggers will not occur for instances of I<subclasses> of I<Class>, only
of I<Class> itself. See TRIGGERS for the available triggers.

=head2 Class->call_trigger($trigger, [@callback_params])

Invokes the triggers watching class I<Class>. The parameters to send to the
callbacks (in addition to I<Class>) are specified in I<@callback_params>. See
TRIGGERS for the available triggers.

=head2 $obj->save

Saves the object I<$obj> to the database.

If the object is not yet in the database, I<save> will automatically
generate a primary key and insert the record into the database table.
Otherwise, it will update the existing record.

If an error occurs, I<save> will I<croak>.

Internally, I<save> calls I<update> for records that already exist in the
database, and I<insert> for those that don't.

=head2 $obj->remove

Removes the object I<$obj> from the database.

If an error occurs, I<remove> will I<croak>.

=head2 Class->remove(\%terms, \%args)

Removes objects found with the I<%terms>. So it's a shortcut of:

  my @obj = Class->search(\%terms, \%args);
  for my $obj (@obj) {
      $obj->remove;
  }

However, when you pass C<nofetch> option set to C<%args>, it won't
create objects with C<search>, but issues I<DELETE> SQL directly to
the database.

  ## issues "DELETE FROM tbl WHERE user_id = 2"
  Class->remove({ user_id => 2 }, { nofetch => 1 });

This might be much faster and useful for tables without Primary Key,
but beware that in this case B<Triggers won't be fired> because no
objects are instanciated.

=head2 Class->bulk_insert([col1, col2], [[d1,d2], [d1,d2]]);

Bulk inserts data into the underlying table.  The first argument
is an array reference of columns names as specified in install_properties

=head2 $obj->add_trigger($trigger, \&callback)

Adds a trigger to the object I<$obj>, such that when the event I<$trigger>
occurs to the object, subroutine C<&callback> is run. See TRIGGERS for the
available triggers. Triggers are invoked in the order in which they are added.

=head2 $obj->call_trigger($trigger, [@callback_params])

Invokes the triggers watching all objects of I<$obj>'s class and the object
I<$obj> specifically for trigger event I<$trigger>. The additional parameters
besides I<$obj>, if any, are passed as I<@callback_params>. See TRIGGERS for
the available triggers.

=head1 TRIGGERS

I<Data::ObjectDriver> provides a trigger mechanism by which callbacks can be
called at certain points in the life cycle of an object. These can be set on a
class as a whole or individual objects (see USAGE).

Triggers can be added and called for these events:

=over 4

=item * pre_save -> ($obj, $orig_obj)

Callbacks on the I<pre_save> trigger are called when the object is about to be
saved to the database. For example, use this callback to translate special code
strings into numbers for storage in an integer column in the database. Note that this hook is also called when you C<remove> the object.

Modifications to I<$obj> will affect the values passed to subsequent triggers
and saved in the database, but not the original object on which the I<save>
method was invoked.

=item * post_save -> ($obj, $orig_obj)

Callbaks on the I<post_save> triggers are called after the object is
saved to the database. Use this trigger when your hook needs primary
key which is automatically assigned (like auto_increment and
sequence). Note that this hooks is B<NOT> called when you remove the
object.

=item * pre_insert/post_insert/pre_update/post_update/pre_remove/post_remove -> ($obj, $orig_obj)

Those triggers are fired before and after $obj is created, updated and
deleted.

=item * post_load -> ($obj)

Callbacks on the I<post_load> trigger are called when an object is being
created from a database query, such as with the I<lookup> and I<search> class
methods. For example, use this callback to translate the numbers your
I<pre_save> callback caused to be saved I<back> into string codes.

Modifications to I<$obj> will affect the object passed to subsequent triggers
and returned from the loading method.

Note I<pre_load> should only be used as a trigger on a class, as the object to
which the load is occuring was not previously available for triggers to be
added.

=item * pre_search -> ($class, $terms, $args)

Callbacks on the I<pre_search> trigger are called when a content addressed
query for objects of class I<$class> is performed with the I<search> method.
For example, use this callback to translate the entry in I<$terms> for your
code string field to its appropriate integer value.

Modifications to I<$terms> and I<$args> will affect the parameters to
subsequent triggers and what objects are loaded, but not the original hash
references used in the I<search> query.

Note I<pre_search> should only be used as a trigger on a class, as I<search> is
never invoked on specific objects.

=over

The return values from your callbacks are ignored.

Note that the invocation of callbacks is the responsibility of the object
driver. If you implement a driver that does not delegate to
I<Data::ObjectDriver::Driver::DBI>, it is I<your> responsibility to invoke the
appropriate callbacks with the I<call_trigger> method.

=back

=back

=head1 PROFILING

For performance tuning, you can turn on query profiling by setting
I<$Data::ObjectDriver::PROFILE> to a true value. Or, alternatively, you can
set the I<DOD_PROFILE> environment variable to a true value before starting
your application.

To obtain the profile statistics, get the global
I<Data::ObjectDriver::Profiler> instance:

    my $profiler = Data::ObjectDriver->profiler;

Then see the documentation for I<Data::ObjectDriver::Profiler> to see the
methods on that class.


=head1 TRANSACTIONS


Transactions are supported by Data::ObjectDriver's default drivers. So each
Driver is capable to deal with transactional state independently. Additionally
<Data::ObjectDriver::BaseObject> class know how to turn transactions switch on
for all objects.

In the case of a global transaction all drivers used during this time are put
in a transactional state until the end of the transaction.

=head2 Example

    ## start a transaction
    Data::ObjectDriver::BaseObject->begin_work;

    $recipe = Recipe->new;
    $recipe->title('lasagnes');
    $recipe->save;

    my $ingredient = Ingredient->new;
    $ingredient->recipe_id($recipe->recipe_id);
    $ingredient->name("more layers");
    $ingredient->insert;
    $ingredient->remove;

    if ($you_are_sure) {
        Data::ObjectDriver::BaseObject->commit;
    }
    else {
        ## erase all trace of the above
        Data::ObjectDriver::BaseObject->rollback;
    }

=head2 Driver implementation

Drivers have to implement the following methods:

=over 4

=item * begin_work to initialize a transaction

=item * rollback

=item * commmit

=back

=head2 Nested transactions

Are not supported and will result in warnings and the inner transactions
to be ignored. Be sure to B<end> each transaction and not to let et long
running transaction open (i.e you should execute a rollback or commit for
each open begin_work).

=head2 Transactions and DBI

In order to make transactions work properly you have to make sure that
the C<$dbh> for each DBI drivers are shared among drivers using the same
database (basically dsn).

One way of doing that is to define a get_dbh() subref in each DBI driver
to return the same dbh if the dsn and attributes of the connection are
identical.

The other way is to use the new configuration flag on the DBI driver that
has been added specifically for this purpose: C<reuse_dbh>.

    ## example coming from the test suite
    __PACKAGE__->install_properties({
        columns => [ 'recipe_id', 'partition_id', 'title' ],
        datasource => 'recipes',
        primary_key => 'recipe_id',
        driver => Data::ObjectDriver::Driver::Cache::Cache->new(
            cache => Cache::Memory->new,
            fallback => Data::ObjectDriver::Driver::DBI->new(
                dsn      => 'dbi:SQLite:dbname=global.db',
                reuse_dbh => 1,  ## be sure that the corresponding dbh is shared
            ),
        ),
    });

=head1 EXAMPLES

=head2 A Partitioned, Caching Driver

    package Ingredient;
    use strict;
    use base qw( Data::ObjectDriver::BaseObject );

    use Data::ObjectDriver::Driver::DBI;
    use Data::ObjectDriver::Driver::Partition;
    use Data::ObjectDriver::Driver::Cache::Cache;
    use Cache::Memory;
    use Carp;

    our $IDs;

    __PACKAGE__->install_properties({
        columns     => [ 'ingredient_id', 'recipe_id', 'name', 'quantity', ],
        datasource  => 'ingredients',
        primary_key => [ 'recipe_id', 'ingredient_id' ],
        driver      =>
            Data::ObjectDriver::Driver::Cache::Cache->new(
                cache    => Cache::Memory->new( namespace => __PACKAGE__ ),
                fallback =>
                    Data::ObjectDriver::Driver::Partition->new(
                        get_driver   => \&get_driver,
                        pk_generator => \&generate_pk,
                    ),
            ),
    });

    sub get_driver {
        my($terms) = @_;
        my $recipe;
        if (ref $terms eq 'HASH') {
            my $recipe_id = $terms->{recipe_id}
                or Carp::croak("recipe_id is required");
            $recipe = Recipe->lookup($recipe_id);
        } elsif (ref $terms eq 'ARRAY') {
            $recipe = Recipe->lookup($terms->[0]);
        }
        Carp::croak("Unknown recipe") unless $recipe;
        Data::ObjectDriver::Driver::DBI->new(
            dsn          => 'dbi:mysql:database=cluster' . $recipe->cluster_id,
            username     => 'foo',
            pk_generator => \&generate_pk,
        );
    }

    sub generate_pk {
        my($obj) = @_;
        $obj->ingredient_id(++$IDs{$obj->recipe_id});
        1;
    }

    1;

=head1 SUPPORTED DATABASES

I<Data::ObjectDriver> is very modular and it's not very diffucult to add new drivers.

=over 4

=item * MySQL is well supported and has been heavily tested.

=item * PostgreSQL has been been used in production and should just work, too.

=item * SQLite is supported, but YMMV depending on the version. This is the
backend used for the test suite.

=item * Oracle support has been added in 0.06

=back

=head1 LICENSE

I<Data::ObjectDriver> is free software; you may redistribute it and/or modify
it under the same terms as Perl itself.

=head1 MAILING LIST, CODE & MORE INFORMATION

I<Data::ObjectDriver> developers can be reached via the following group:
L<http://groups.google.com/group/data-objectdriver>

Bugs should be reported using the CPAN RT system, patches are encouraged when
reporting bugs.

L<http://code.sixapart.com/>

=head1 AUTHOR & COPYRIGHT

Except where otherwise noted, I<Data::ObjectDriver> is Copyright 2005-2006
Six Apart, cpan@sixapart.com. All rights reserved.

=cut
