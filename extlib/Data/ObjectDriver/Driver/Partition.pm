# $Id: Partition.pm 552 2008-12-24 02:15:57Z ykerherve $

package Data::ObjectDriver::Driver::Partition;
use strict;
use warnings;
use Carp();

use base qw( Data::ObjectDriver Class::Accessor::Fast );

__PACKAGE__->mk_accessors(qw( get_driver ));

sub init {
    my $driver = shift;
    $driver->SUPER::init(@_);
    my %param = @_;
    $driver->get_driver($param{get_driver});
    $driver->{__working_drivers} = [];
    $driver;
}

sub lookup {
    my $driver = shift;
    my($class, $id) = @_;
    return unless $id;
    $driver->get_driver->($id)->lookup($class, $id);
}

sub lookup_multi {
    my $driver = shift;
    my($class, $ids) = @_;
    return [] unless @$ids;
    $driver->get_driver->($ids->[0])->lookup_multi($class, $ids);
}

sub exists     { shift->_exec_partitioned('exists',     @_) }
sub insert     { shift->_exec_partitioned('insert',     @_) }
sub replace    { shift->_exec_partitioned('replace',    @_) }
sub update     { shift->_exec_partitioned('update',     @_) }
sub remove     { shift->_exec_partitioned('remove',     @_) }
sub fetch_data { shift->_exec_partitioned('fetch_data', @_) }

sub search {
    my $driver = shift;
    my($class, $terms, $args) = @_;
    $driver->get_driver->($terms, $args)->search($class, $terms, $args);
}

sub _exec_partitioned {
    my $driver = shift;
    my($meth, $obj, @rest) = @_;
    ## If called as a class method, pass in the stuff in @rest.
    my $d;
    if (ref($obj)) {
        my $terms = $obj->column_values;
        # @rest should only contain $args, but just in case
        # don't assume we have nothing else and build @rest2
        (undef, my @rest2) = @rest;
        $d = $driver->get_driver->($terms, @rest2);
    } else {
        $d = $driver->get_driver->(@rest);
    }

    if ( $driver->txn_active ) {
        $driver->add_working_driver($d);
    }
    $d->$meth($obj, @rest);
}

sub add_working_driver {
    my $driver = shift;
    my $part_driver = shift;
    if (! $part_driver->txn_active) {
        $part_driver->begin_work;
        push @{$driver->{__working_drivers}}, $part_driver;
    }
}

sub commit {
    my $driver = shift;

    ## if the driver has its own internal txn_active flag
    ## off, we don't bother ending. Maybe we already did
    return unless $driver->txn_active;

    $driver->SUPER::commit(@_);
    _end_txn($driver, 'commit', @_);
}

sub rollback {
    my $driver = shift;

    ## if the driver has its own internal txn_active flag
    ## off, we don't bother ending. Maybe we already did
    return unless $driver->txn_active;

    $driver->SUPER::rollback(@_);
    _end_txn($driver, 'rollback', @_);
}

sub _end_txn {
    my ($driver, $method) = @_;

    my $wd = $driver->{__working_drivers};
    $driver->{__working_drivers} = [];

    for my $part_driver (@{ $wd || [] }) {
        $part_driver->$method;
    }
}


1;

__END__

=pod

=head1 NAME

Data::ObjectDriver::Driver::Partition - base class for partitioned object drivers

=head1 SYNOPSIS

    package SomeObject;

    __PACKAGE__->install_properties({
        ...
        primary_key => 'id',
        driver      => Data::ObjectDriver::Driver::Partition->new(get_driver => \&find_partition),
    });

    # Say we have a list of 5 arrayrefs of the DBI driver information.
    my @DBI_INFO;

    sub find_partition {
        my ($part_key, $args) = @_;

        my $id;

        if (ref $terms && ref $terms eq 'HASH') {
            # This is a search($terms, $args) call.
            my $terms = $part_key;
            $id = $terms->{id}
                or croak "Can't determine partition from a search() with no id field";
        }
        else {
            # This is a lookup($id) or some method invoked on an object where we know the ID.
            my $id = $part_key;
        }

        # "ID modulo N" is not a good partitioning strategy, but serves as an example.
        my $partition = $id % 5;
        return Data::ObjectDriver::Driver::DBI->new( @{ $DBI_INFO[$partition] } );
    }


=head1 DESCRIPTION

I<Data::ObjectDriver::Driver::Partition> provides the basic structure for
partitioning objects into different databases. Using partitions, you can
horizontally scale your application by using different database servers to hold
sets of data.

To partition data, you need a certain criteria to determine which partition
data goes in. Partition drivers use a C<get_driver> function to find the
database driver for the correct partition, given either the arguments to a
C<search()> or the object's primary key for a C<lookup()>, C<update()>, etc
where the key is known.

=head1 SUGGESTED PRACTICES

While you can use any stable, predictable method of selecting the partition for
an object, the most flexible way is to keep an unpartitioned table that maps
object keys to their partitions. You can then look up the appropriate record in
your get_driver method to find the partition.

For many applications, you can partition several classes of data based on the
ID of the user account that "owns" them. In this case, you would include the
user ID as the first part of a complex primary key.

Because multiple objects can use the same partitioning scheme, often
I<Data::ObjectDriver::Driver::Partition> is subclassed to define the
C<get_driver> function once and automatically specify it to the
I<Data::ObjectDriver::Driver::Partition> constructor.

Note these practices are codified into the
I<Data::ObjectDriver::Driver::SimplePartition> class.

=head1 USAGE

=head2 C<Data::ObjectDriver::Driver::Partition-E<gt>new(%params)>

Creates a new partitioning driver. The required members of C<%params> are:

=over 4

=item * C<get_driver>

A reference to a function to be used to retrieve for a given object or set of
search terms. Your function is invoked as either:

=over 4

=item * C<get_driver(\%terms, \%args)>

Return a driver based on the given C<search()> parameters.

=item * C<get_driver($id)>

Return a driver based on the given object ID. Note that C<$id> may be an
arrayref, if the class was defined with a complex primary key.

=back

=item * C<pk_generator>

A reference to a function that, given a data object, generates a primary key
for it. This is the same C<pk_generator> given to C<Data::ObjectDriver>'s
constructor.

=back

=head2 C<$driver-E<gt>search($class, $terms, $args)>

=head2 C<$driver-E<gt>lookup($class, $id)>

=head2 C<$driver-E<gt>lookup_multi($class, @ids)>

=head2 C<$driver-E<gt>exists($obj)>

=head2 C<$driver-E<gt>insert($obj)>

=head2 C<$driver-E<gt>update($obj)>

=head2 C<$driver-E<gt>remove($obj)>

=head2 C<$driver-E<gt>fetch_data($what)>

Performs the named action, by passing these methods through to the appropriate
database driver as determined by C<$driver>'s C<get_driver> function.

=head1 DIAGNOSTICS

No errors are created by I<Data::ObjectDriver::Driver::Partition> itself.
Errors may come from a specific partitioning subclass or the driver for a
particular database.

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

=head1 SEE ALSO

I<Data::ObjectDriver::Driver::SimplePartition>

=head1 LICENSE

I<Data::ObjectDriver> is free software; you may redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR & COPYRIGHT

Except where otherwise noted, I<Data::ObjectDriver> is Copyright 2005-2006
Six Apart, cpan@sixapart.com. All rights reserved.

=cut

