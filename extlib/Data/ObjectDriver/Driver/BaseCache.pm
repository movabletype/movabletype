# $Id$

package Data::ObjectDriver::Driver::BaseCache;
use strict;
use warnings;

use base qw( Data::ObjectDriver Class::Accessor::Fast
             Class::Data::Inheritable );

use Carp ();

__PACKAGE__->mk_accessors(qw( cache fallback txn_buffer));
__PACKAGE__->mk_classdata(qw( Disabled ));

sub deflate { $_[1] }
sub inflate { $_[2] }

# subclasses must override these:
sub add_to_cache            { Carp::croak("NOT IMPLEMENTED") }
sub update_cache            { Carp::croak("NOT IMPLEMENTED") }
sub remove_from_cache       { Carp::croak("NOT IMPLEMENTED") }
sub get_from_cache          { Carp::croak("NOT IMPLEMENTED") }

sub init {
    my $driver = shift;
    $driver->SUPER::init(@_);
    my %param = @_;
    $driver->cache($param{cache})
        or Carp::croak("cache is required");
    $driver->fallback($param{fallback})
        or Carp::croak("fallback is required");
    $driver->txn_buffer([]);
    $driver;
}

sub begin_work {
    my $driver = shift;
    my $rv = $driver->fallback->begin_work(@_);
    $driver->SUPER::begin_work(@_);
    return $rv;
}

sub commit {
    my $driver = shift;
    return unless $driver->txn_active;

    my $rv = $driver->fallback->commit(@_);

    $driver->debug(sprintf("%14s", "COMMIT(" . scalar(@{$driver->txn_buffer}) . ")") . ": driver=$driver");
    while (my $cb = shift @{$driver->txn_buffer}) {
        $cb->();
    }
    $driver->SUPER::commit(@_);

    return $rv;
}

sub rollback {
    my $driver = shift;
    return unless $driver->txn_active;
    my $rv = $driver->fallback->rollback(@_);

    $driver->debug(sprintf("%14s", "ROLLBACK(" . scalar(@{$driver->txn_buffer}) . ")") . ": driver=$driver");
    $driver->txn_buffer([]);

    $driver->SUPER::rollback(@_);

    return $rv;
}

sub cache_object {
    my $driver = shift;
    my($obj) = @_;
    return $driver->fallback->cache_object($obj)
        if $driver->Disabled;
    ## If it's already cached in this layer, assume it's already cached in
    ## all layers below this, as well.
    unless (exists $obj->{__cached} && $obj->{__cached}{ref $driver}) {
        $driver->modify_cache(sub {
            $driver->add_to_cache(
                $driver->cache_key(ref($obj), $obj->primary_key),
                $driver->deflate($obj)
            );
        });
        $driver->fallback->cache_object($obj);
    }
}

sub lookup {
    my $driver = shift;
    my($class, $id) = @_;
    return unless defined $id;
    return $driver->fallback->lookup($class, $id)
        if $driver->Disabled or $driver->txn_active;
    my $key = $driver->cache_key($class, $id);
    my $obj = $driver->get_from_cache($key);
    if ($obj) {
        $obj = $driver->inflate($class, $obj);
        $obj->{__cached}{ref $driver} = 1;
    } else {
        $obj = $driver->fallback->lookup($class, $id);
    }
    $obj;
}

sub get_multi_from_cache {
    my $driver = shift;
    my(@keys) = @_;
    ## Use driver->get_from_cache to look up each object in the cache.
    ## We don't fall back here, because we only want to find items that
    ## are already cached.
    my %got;
    for my $key (@keys) {
        my $obj = $driver->get_from_cache($key) or next;
        $got{$key} = $obj;
    }
    \%got;
}

sub lookup_multi {
    my $driver = shift;
    my($class, $ids) = @_;
    return $driver->fallback->lookup_multi($class, $ids)
        if $driver->Disabled or $driver->txn_active;

    my %id2key = map { $_ => $driver->cache_key($class, $_) } grep { defined } @$ids;
    my $got = $driver->get_multi_from_cache(values %id2key);

    ## If we got back all of the objects from the cache, return immediately.
    if (scalar keys %$got == @$ids) {
        my @objs;
        for my $id (@$ids) {
            my $obj = $driver->inflate($class, $got->{ $id2key{$id} });
            $obj->{__cached}{ref $driver} = 1;
            push @objs, $obj;
        }
        return \@objs;
    }

    ## Otherwise, look through the list of IDs to see what we're missing,
    ## and fall back to the backend to look up those objects.
    my($i, @got, @need, %need2got) = (0);
    for my $id (@$ids) {
        if (defined $id && (my $obj = $got->{ $id2key{$id} })) {
            $obj = $driver->inflate($class, $obj);
            $obj->{__cached}{ref $driver} = 1;
            push @got, $obj;
        } else {
            push @got, undef;
            push @need, $id;
            $need2got{$#need} = $i;
        }
        $i++;
    }

    if (@need) {
        my $more = $driver->fallback->lookup_multi($class, \@need);
        $i = 0;
        for my $obj (@$more) {
            $got[ $need2got{$i++} ] = $obj;
        }
    }

    \@got;
}

## We fallback by default
sub fetch_data {
    my $driver = shift;
    my ($obj) = @_;
    return $driver->fallback->fetch_data($obj);
}

sub search {
    my $driver = shift;
    return $driver->fallback->search(@_)
        if $driver->Disabled;
    my($class, $terms, $args) = @_;

    ## If the caller has asked only for certain columns, assume that
    ## he knows what he's doing, and fall back to the backend.
    return $driver->fallback->search(@_)
        if $args->{fetchonly};

    ## Tell the fallback driver to fetch only the primary columns,
    ## then run the search using the fallback.
    local $args->{fetchonly} = $class->primary_key_tuple;
    ## Disable triggers for this load. We don't want the post_load trigger
    ## being called twice.
    local $args->{no_triggers} = 1;
    my @objs = $driver->fallback->search($class, $terms, $args);

    my $windowed = (!wantarray) && $args->{window_size};

    if ( $windowed ) {
        my @window;
        my $window_size = $args->{window_size};
        my $iter = sub {
            my $d = $driver;
            while ( (!@window) && @objs ) {
                my $objs = $driver->lookup_multi(
                    $class,
                    [ map { $_->primary_key }
                          splice( @objs, 0, $window_size ) ]
                );
                # A small possibility exists that we may fetch
                # some IDs here that no longer exist; grep these out
                @window = grep { defined $_ } @$objs if $objs;
            }
            return @window ? shift @window : undef;
        };
        return Data::ObjectDriver::Iterator->new($iter, sub { @objs = (); @window = () });
    } else {
        ## Load all of the objects using a lookup_multi, which is fast from
        ## cache.
        my $objs = $driver->lookup_multi($class, [ map { $_->primary_key } @objs ]);
        return $driver->list_or_iterator($objs);
    }
}

sub update {
    my $driver = shift;
    my($obj) = @_;
    return $driver->fallback->update($obj)
        if $driver->Disabled;
    my $ret = $driver->fallback->update(@_);
    my $key = $driver->cache_key(ref($obj), $obj->primary_key);
    $driver->modify_cache(sub {
        $driver->uncache_object($obj);
    });
    return $ret;
}

sub replace {
    my $driver = shift;
    my($obj) = @_;
    return $driver->fallback->replace($obj)
        if $driver->Disabled;

    # Collect this logic before $obj changes on the next line via 'replace'
    my $has_pk = ref $obj && $obj->has_primary_key;
    my $ret = $driver->fallback->replace($obj);
    if ($has_pk) {
        my $key = $driver->cache_key(ref($obj), $obj->primary_key);
        $driver->modify_cache(sub {
            $driver->update_cache($key, $driver->deflate($obj));
        });
    }
    return $ret;
}

sub remove {
    my $driver = shift;
    my($obj) = @_;
    return $driver->fallback->remove(@_)
        if $driver->Disabled;

    if ($_[2] && $_[2]->{nofetch}) {
        ## since direct_remove isn't an object method, it can't benefit
        ## from inheritance, we're forced to keep things a bit obfuscated here
        ## (I'd rather have a : sub direct_remove { die "unavailable" } in the driver
        Carp::croak("nofetch option isn't compatible with a cache driver");
    }
    if (ref $obj) {
        $driver->uncache_object($obj);
    }
    $driver->fallback->remove(@_);
}

sub uncache_object {
    my $driver = shift;
    my($obj) = @_;
    my $key = $driver->cache_key(ref($obj), $obj->primary_key);
    return $driver->modify_cache(sub {
        delete $obj->{__cached};
        $driver->remove_from_cache($key);
        $driver->fallback->uncache_object($obj);
    });
}

sub cache_key {
    my $driver = shift;
    my($class, $id) = @_;
    if ($class->can('cache_class')) {
        $class = $class->cache_class;
    }
    my $key = join ':', $class, ref($id) eq 'ARRAY' ? @$id : $id;
    if (my $v = $class->can('cache_version')) {
        $key .= ':' . $v->();
    }
    return $key;
}

# if we're operating within a transaction then we need to buffer CRUD
# and only commit to the cache upon commit
sub modify_cache {
    my ($driver, $cb) = @_;

    unless ($driver->txn_active) {
        return $cb->();
    }
    $driver->debug(sprintf("%14s", "BUFFER(1)") . ": driver=$driver");
    push @{$driver->txn_buffer} => $cb;
}

sub DESTROY { }

sub AUTOLOAD {
    my $driver = $_[0];
    (my $meth = our $AUTOLOAD) =~ s/.+:://;
    my $fallback = $driver->fallback;
    ## Check for invalid methods, but make sure we still allow
    ## chaining 2 caching drivers together.
    Carp::croak("Cannot call method '$meth' on object '$driver'")
        unless $fallback->can($meth) ||
               UNIVERSAL::isa($fallback, __PACKAGE__);
    {
        no strict 'refs'; ## no critic
        *$AUTOLOAD = sub {
            shift->fallback->$meth(@_);
        };
    }
    goto &$AUTOLOAD;
}

1;

__END__

=head1 NAME

Data::ObjectDriver::Driver::BaseCache - parent class for caching object drivers

=head1 SYNOPSIS

=head1 DESCRIPTION

Data::ObjectDriver::Driver::BaseCache provides behavior utilized for all
caching object drivers for use with Data::ObjectDriver. That behavior is
looking up requested objects in a cache, and falling back to another
Data::ObjectDriver for a cache miss.

=head1 USAGE

Drivers based on Data::ObjectDriver::Driver::BaseCache support all standard
operations for Data::ObjectDriver object drivers (lookup, search, update,
insert, replace, remove, and fetch_data). BaseCache-derived drivers also support:

=head2 C<Data::ObjectDriver::Driver::BaseCache-E<gt>new( %params )>

Creates a new instance of a BaseCache driver. Required members of C<%params> are:

=over 4

=item * C<cache>

The object with which to interface with the external cache. For example, for
the C<Memcached> caching object driver, the value of the C<cache> member should
be a C<Cache::Memcached> object.

=item * C<fallback>

The C<Data::ObjectDriver> object driver to which to fall back when the cache
does not yet contain a requested object. The C<fallback> member is also the
object driver to which updates and inserts are passed.

=back

=head2 C<$driver-E<gt>cache_key($class, $primary_key)>

Returns the cache key for an object of the given class with the given primary
key. The cache key is used with the external cache to identify an object.

In BaseCache's implementation, the key is the class name and all the column
names of the primary key concatenated, separated by single colons.

=head2 C<$driver-E<gt>get_multi_from_cache(@cache_keys)>

Returns the objects corresponding to the given cache keys, as represented in
the external cache.

=head2 C<Data::ObjectDriver::Driver::BaseClass-E<gt>Disabled([ $value ])>

Returns whether caches of the given class are disabled, first updating the
disabled state of drivers of the given class to C<$value>, if given. When a
caching driver is disabled, all operations are automatically passed through to
the fallback object driver.

Note that, if you disable and reenable a caching driver, some of the cached
data may be invalid due to updates that were performed while the driver was
disabled not being reflected in the external cache.

=head1 SUBCLASSING

When creating a caching driver from C<BaseCache>, the behavior for interaction
with the external cache (through the C<cache> member of the constructor) must
be defined by implementing these methods:

=head2 C<$driver-E<gt>add_to_cache($cache_key, $obj_repr)>

Sets the cache entry for C<$cache_key> to the given object representation. This
method is used when the corresponding object is being saved to the database for
the first time.

=head2 C<$driver-E<gt>update_cache($cache_key, $obj_repr)>

Sets the cache entry for C<$cache_key> to the given object representation. This
method is used when the corresponding object already exists in the database and
is being saved.

=head2 C<$driver-E<gt>remove_from_cache($cache_key)>

Clears the given cache entry. This method is used when the corresponding object
is being deleted from the database.

=head2 C<$driver-E<gt>get_from_cache($cache_key)>

Returns the object corresponding to the given cache key, as it exists in the
external cache.

=head2 C<$driver-E<gt>inflate($class, $obj_repr)>

Returns an instance of C<$class> containing the data in the representation
C<$obj_repr>, as returned from the C<get_from_cache> method.

In BaseCache's implementation, no operation is performed. C<get_from_cache>
should itself return the appropriate instances of
C<Data::ObjectDriver::BaseObject>.

=head2 C<$driver-E<gt>deflate($obj)>

Returns a representation of the given C<Data::ObjectDriver::BaseObject>
instance, suitable for passing to the C<add_to_cache> and C<update_cache>
methods.

In BaseCache's implementation, no operation is performed. C<add_to_cache> and
C<update_cache> should themselves accept C<Data::ObjectDriver::BaseObject>
instances.

=head1 LICENSE

I<Data::ObjectDriver> is free software; you may redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR & COPYRIGHT

Except where otherwise noted, I<Data::ObjectDriver> is Copyright 2005-2006
Six Apart, cpan@sixapart.com. All rights reserved.

=cut

